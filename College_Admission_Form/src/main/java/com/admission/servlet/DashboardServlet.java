package com.admission.servlet;
import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class DashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final ProgramDAO progDAO = new ProgramDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (user.isAdmin()) {
            Map<String,Integer> sm = appDAO.countByStatusAll();
            req.setAttribute("totalStudents",   userDAO.countByRole("STUDENT"));
            req.setAttribute("totalApps",       appDAO.count());
            req.setAttribute("pendingApps",     sm.getOrDefault("PENDING",0));
            req.setAttribute("approvedApps",    sm.getOrDefault("APPROVED",0));
            req.setAttribute("rejectedApps",    sm.getOrDefault("REJECTED",0));
            req.setAttribute("underReviewApps", sm.getOrDefault("UNDER_REVIEW",0));
            req.setAttribute("waitlistedApps",  sm.getOrDefault("WAITLISTED",0));
            req.setAttribute("totalPrograms",   progDAO.count());
            req.setAttribute("recentApplications", appDAO.findRecent(8));
            req.setAttribute("programs",        progDAO.findAllActive());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } else {
            List<Application> myApps = appDAO.findByStudentId(user.getId());
            req.setAttribute("myApplications", myApps);
            req.setAttribute("totalApps",  myApps.size());
            req.setAttribute("pendingApps",  (int) myApps.stream().filter(a->"PENDING".equals(a.getStatus())).count());
            req.setAttribute("approvedApps", (int) myApps.stream().filter(a->"APPROVED".equals(a.getStatus())).count());
            req.setAttribute("unreadNotifs", new NotificationDAO().countUnread(user.getId()));
            req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
        }
    }
}