package com.admission.servlet;
import com.admission.dao.UserDAO;
import com.admission.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "Username and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.authenticate(username.trim(), password);
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("loggedUser", user);
                session.setMaxInactiveInterval(60 * 60);
                resp.sendRedirect(req.getContextPath() + "/DashboardServlet");
            } else {
                req.setAttribute("errorMsg", "Invalid username or password. Please try again.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Login error: " + e.getMessage() + " — Check database connection.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/DashboardServlet");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}