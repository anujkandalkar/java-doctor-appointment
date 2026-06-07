package com.healthconnect.servlet;

import com.healthconnect.dao.PortalDao;
import com.healthconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet({"/patient/dashboard", "/doctor/dashboard"})
public class DashboardServlet extends HttpServlet {
    private final PortalDao portal = new PortalDao();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = current(req);
        String path = req.getServletPath();
        if (user == null || (path.startsWith("/patient") && !"PATIENT".equals(user.getRole())) || (path.startsWith("/doctor") && !"DOCTOR".equals(user.getRole()))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            if (path.startsWith("/patient")) {
                req.setAttribute("doctors", portal.searchDoctors(req.getParameter("city"), req.getParameter("hospital"), req.getParameter("specialization")));
                req.setAttribute("appointments", portal.patientAppointments(user.getId()));
                req.setAttribute("reports", portal.reportsForPatient(user.getId()));
                req.setAttribute("messages", portal.messagesForUser(user.getId()));
                req.getRequestDispatcher("/WEB-INF/views/patient-dashboard.jsp").forward(req, resp);
            } else {
                req.setAttribute("appointments", portal.doctorAppointments(user.getId()));
                req.setAttribute("patients", portal.patientsForDoctor(user.getId()));
                req.setAttribute("messages", portal.messagesForUser(user.getId()));
                req.getRequestDispatcher("/WEB-INF/views/doctor-dashboard.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private User current(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("user");
    }
}
