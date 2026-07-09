package com.admission.servlet;
import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class NotificationServlet extends HttpServlet {
    private final NotificationDAO dao = new NotificationDAO();
    private final UserDAO userDAO = new UserDAO();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action"); if(action==null) action="list";
        User user = (User) req.getSession().getAttribute("loggedUser");
        switch(action) {
            case "list":
                req.setAttribute("notifications", dao.findAll());
                req.setAttribute("students", userDAO.findAllStudents());
                req.getRequestDispatcher("/admin/notifications.jsp").forward(req,resp); break;
            case "myNotifications":
                dao.markAllRead(user.getId());
                req.setAttribute("notifications", dao.findByUserId(user.getId()));
                req.getRequestDispatcher("/student/notifications.jsp").forward(req,resp); break;
            case "count":
                resp.setContentType("application/json");
                resp.getWriter().write("{\"count\":"+dao.countUnread(user.getId())+"}"); break;
            case "markAllRead":
                dao.markAllRead(user.getId());
                resp.sendRedirect(req.getContextPath()+"/NotificationServlet?action=list"); break;
        }
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String title=req.getParameter("title"), msg=req.getParameter("message");
        if ("ALL".equals(req.getParameter("recipientType")))
            userDAO.findAllStudents().forEach(s -> dao.create(new Notification(s.getId(),title,msg)));
        else dao.create(new Notification(Integer.parseInt(req.getParameter("userId")),title,msg));
        resp.sendRedirect(req.getContextPath()+"/NotificationServlet?action=list");
    }
}
