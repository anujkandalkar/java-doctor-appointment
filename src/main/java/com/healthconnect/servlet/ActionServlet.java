package com.healthconnect.servlet;

import com.healthconnect.dao.PortalDao;
import com.healthconnect.model.User;
import com.healthconnect.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.file.*;
import java.sql.SQLException;
import java.util.UUID;

@MultipartConfig(maxFileSize = 8 * 1024 * 1024)
@WebServlet({"/appointment/request", "/appointment/status", "/profile/patient", "/profile/doctor", "/message/send", "/report/upload", "/logout"})
public class ActionServlet extends HttpServlet {
    private final PortalDao portal = new PortalDao();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            switch (req.getServletPath()) {
                case "/appointment/request":
                    portal.requestAppointment(user.getId(), Integer.parseInt(req.getParameter("doctorId")), req.getParameter("disease"), req.getParameter("date"), req.getParameter("time"));
                    resp.sendRedirect(req.getContextPath() + "/patient/dashboard?success=appointment");
                    break;
                case "/appointment/status":
                    portal.updateAppointmentStatus(Integer.parseInt(req.getParameter("appointmentId")), user.getId(), req.getParameter("status"), req.getParameter("altDate"), req.getParameter("altTime"), req.getParameter("note"));
                    resp.sendRedirect(req.getContextPath() + "/doctor/dashboard?success=status");
                    break;
                case "/profile/patient":
                    portal.upsertPatientProfile(user.getId(), req.getParameter("age"), req.getParameter("gender"), req.getParameter("bloodGroup"), req.getParameter("allergies"), req.getParameter("history"));
                    resp.sendRedirect(req.getContextPath() + "/patient/dashboard?success=profile");
                    break;
                case "/profile/doctor":
                    portal.upsertDoctorProfile(user.getId(), req.getParameter("hospital"), req.getParameter("specialization"), req.getParameter("education"), parseInt(req.getParameter("experience")), req.getParameter("fee"), req.getParameter("bio"), req.getParameter("days"));
                    resp.sendRedirect(req.getContextPath() + "/doctor/dashboard?success=profile");
                    break;
                case "/message/send":
                    StoredFile messageFile = store(req.getPart("attachment"));
                    portal.sendMessage(user.getId(), Integer.parseInt(req.getParameter("receiverId")), req.getParameter("body"), messageFile.originalName, messageFile.storedName);
                    resp.sendRedirect(req.getHeader("Referer"));
                    break;
                case "/report/upload":
                    StoredFile report = store(req.getPart("report"));
                    portal.saveReport(Integer.parseInt(req.getParameter("patientId")), user.getId(), req.getParameter("title"), report.originalName, report.storedName, req.getParameter("message"));
                    resp.sendRedirect(req.getContextPath() + "/doctor/dashboard?success=report");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        resp.sendRedirect(req.getContextPath() + "/");
    }

    private StoredFile store(Part part) throws IOException, ServletException {
        if (part == null || part.getSize() == 0) return new StoredFile(null, null);
        String original = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        if (!SecurityUtil.isValidReportType(original)) throw new ServletException("Unsupported file type");
        String stored = UUID.randomUUID() + "_" + SecurityUtil.cleanFileName(original);
        Path uploadDir = Paths.get(System.getProperty("user.home"), "healthconnect-uploads");
        Files.createDirectories(uploadDir);
        part.write(uploadDir.resolve(stored).toString());
        return new StoredFile(original, stored);
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception ex) { return 0; }
    }

    private static class StoredFile {
        final String originalName;
        final String storedName;
        StoredFile(String originalName, String storedName) {
            this.originalName = originalName;
            this.storedName = storedName;
        }
    }
}
