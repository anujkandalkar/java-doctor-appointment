package com.healthconnect.servlet;

import com.healthconnect.dao.PortalDao;
import com.healthconnect.dao.UserDao;
import com.healthconnect.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet({"/login", "/register"})
public class AuthServlet extends HttpServlet {
    private final UserDao users = new UserDao();
    private final PortalDao portal = new PortalDao();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(req.getServletPath().equals("/register") ? "/WEB-INF/views/register.jsp" : "/WEB-INF/views/login.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getServletPath().equals("/register")) {
                String role = req.getParameter("role");
                User user = users.create(role, req.getParameter("name"), req.getParameter("email"), req.getParameter("phone"), req.getParameter("city"), req.getParameter("password"));
                if ("DOCTOR".equals(role)) {
                    portal.upsertDoctorProfile(user.getId(), req.getParameter("hospital"), req.getParameter("specialization"), req.getParameter("education"), parseInt(req.getParameter("experience")), req.getParameter("fee"), req.getParameter("bio"), req.getParameter("days"));
                } else {
                    portal.upsertPatientProfile(user.getId(), req.getParameter("age"), req.getParameter("gender"), req.getParameter("bloodGroup"), req.getParameter("allergies"), req.getParameter("history"));
                }
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + ("DOCTOR".equals(user.getRole()) ? "/doctor/dashboard" : "/patient/dashboard"));
                return;
            }
            User user = users.login(req.getParameter("email"), req.getParameter("password"));
            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }
            req.getSession().setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + ("DOCTOR".equals(user.getRole()) ? "/doctor/dashboard" : "/patient/dashboard"));
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception ex) { return 0; }
    }
}
