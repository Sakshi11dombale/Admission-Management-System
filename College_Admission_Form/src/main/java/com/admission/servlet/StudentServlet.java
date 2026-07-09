package com.admission.servlet;
import com.admission.dao.UserDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class StudentServlet extends HttpServlet {
    private final UserDAO dao = new UserDAO();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("students", dao.findAllStudents());
        req.getRequestDispatcher("/admin/students.jsp").forward(req,resp);
    }
}
