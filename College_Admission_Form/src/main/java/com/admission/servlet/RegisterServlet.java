package com.admission.servlet;
import com.admission.dao.UserDAO;
import com.admission.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String firstName = req.getParameter("firstName");
        String lastName  = req.getParameter("lastName");
        String email     = req.getParameter("email");
        String phone     = req.getParameter("phone");
        String username  = req.getParameter("username");
        String password  = req.getParameter("password");

        // Validation
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName  == null || lastName.trim().isEmpty()  ||
            email     == null || email.trim().isEmpty()     ||
            username  == null || username.trim().isEmpty()  ||
            password  == null || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "All required fields must be filled.");
            req.setAttribute("from", "register");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("errorMsg", "Password must be at least 6 characters.");
            req.setAttribute("from", "register");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.existsByUsername(username.trim())) {
                req.setAttribute("errorMsg", "Username '" + username + "' is already taken. Please choose another.");
                req.setAttribute("from", "register");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            if (userDAO.existsByEmail(email.trim())) {
                req.setAttribute("errorMsg", "Email '" + email + "' is already registered. Please login.");
                req.setAttribute("from", "register");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setFullName(firstName.trim() + " " + lastName.trim());
            user.setEmail(email.trim());
            user.setPhone(phone != null ? phone.trim() : "");
            user.setUsername(username.trim());
            user.setPassword(password);
            user.setRole("STUDENT");

            if (userDAO.register(user)) {
                req.setAttribute("successMsg", "Account created successfully! You can now login with username: " + username);
            } else {
                req.setAttribute("errorMsg", "Registration failed. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Registration error: " + e.getMessage());
        }

        req.setAttribute("from", "register");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}