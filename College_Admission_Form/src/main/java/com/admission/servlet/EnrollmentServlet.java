package com.admission.servlet;

import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class EnrollmentServlet extends HttpServlet {

    private final EnrollmentDAO  enrollDAO = new EnrollmentDAO();
    private final ApplicationDAO appDAO    = new ApplicationDAO();
    private final ProgramDAO     progDAO   = new ProgramDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        String action = req.getParameter("action");
        if (action == null) action = user.isAdmin() ? "list" : "myEnrollments";

        try {
            switch (action) {

                // ===== STUDENT: View all my enrollments =====
                case "myEnrollments":
                    handleMyEnrollments(req, resp, user);
                    break;

                // ===== STUDENT: Show re-enroll form =====
                case "reEnrollForm":
                    handleReEnrollForm(req, resp, user);
                    break;

                // ===== ADMIN: List all enrollments =====
                case "list":
                    if (!user.isAdmin()) {
                        resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
                        return;
                    }
                    req.setAttribute("enrollments", enrollDAO.findAll(req.getParameter("status")));
                    req.setAttribute("pendingCount", enrollDAO.count("PENDING"));
                    req.setAttribute("totalCount",   enrollDAO.count(null));
                    req.getRequestDispatcher("/admin/enrollments.jsp").forward(req, resp);
                    break;

                // ===== ADMIN: View one enrollment =====
                case "view":
                    if (!user.isAdmin()) {
                        resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet");
                        return;
                    }
                    String idStr = req.getParameter("id");
                    if (idStr != null) {
                        req.setAttribute("enrollment", enrollDAO.findById(Integer.parseInt(idStr)));
                    }
                    req.getRequestDispatcher("/admin/enrollment-detail.jsp").forward(req, resp);
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            req.setAttribute("errorMsg", "Error: " + ex.getMessage());
            req.getRequestDispatcher("/student/my-enrollments.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {

                // ===== STUDENT submits re-enrollment =====
                case "submitEnroll":
                    handleSubmitEnroll(req, resp, user);
                    break;

                // ===== ADMIN approves or rejects =====
                case "updateStatus":
                    if (!user.isAdmin()) {
                        resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
                        return;
                    }
                    handleUpdateStatus(req, resp);
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            req.getSession().setAttribute("flashError", "Error: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
        }
    }

    // ----------------------------------------------------------------
    // STUDENT: Show my enrollments page
    // ----------------------------------------------------------------
    private void handleMyEnrollments(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        List<Application> myApps = appDAO.findByStudentId(user.getId());
        List<Enrollment>  myEnrollments = enrollDAO.findByStudent(user.getId());

        req.setAttribute("myApplications", myApps);
        req.setAttribute("enrollments",    myEnrollments);
        req.getRequestDispatcher("/student/my-enrollments.jsp").forward(req, resp);
    }

    // ----------------------------------------------------------------
    // STUDENT: Show the re-enroll form
    // ----------------------------------------------------------------
    private void handleReEnrollForm(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String appIdStr = req.getParameter("appId");
        if (appIdStr == null || appIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        int appId = Integer.parseInt(appIdStr);
        Application app = appDAO.findById(appId);

        // Security: make sure this app belongs to this student
        if (app == null || app.getStudentId() != user.getId()) {
            req.getSession().setAttribute("flashError", "Invalid application.");
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // Must be approved to enroll
        if (!"APPROVED".equals(app.getStatus())) {
            req.getSession().setAttribute("flashError",
                "Your admission application must be approved before enrolling. Current status: " + app.getStatus());
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        Program prog = progDAO.findById(app.getProgramId());
        if (prog == null) {
            req.getSession().setAttribute("flashError", "Program not found.");
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // Find what year to enroll for
        int latestApproved = enrollDAO.getLatestApprovedYear(user.getId(), app.getProgramId());
        int nextYear       = latestApproved + 1;

        // Check if all years are done
        if (nextYear > prog.getDurationYears()) {
            req.getSession().setAttribute("flashError",
                "You have completed all " + prog.getDurationYears() +
                " years of " + prog.getName() + ". Congratulations!");
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // Check if already applied for next year (pending or approved)
        Enrollment existing = enrollDAO.findByStudentProgramYear(user.getId(), app.getProgramId(), nextYear);
        if (existing != null) {
            req.getSession().setAttribute("flashError",
                "You have already submitted enrollment for Year " + nextYear +
                ". Status: " + existing.getStatus());
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // Get previous year enrollment (for displaying its data)
        Enrollment prevEnroll = latestApproved > 0
            ? enrollDAO.findByStudentProgramYear(user.getId(), app.getProgramId(), latestApproved)
            : null;

        // Calculate fee for next year
        BigDecimal fee = calcFeeForYear(prog, app.getCategory(), nextYear);

        req.setAttribute("application",   app);
        req.setAttribute("program",       prog);
        req.setAttribute("nextYear",      nextYear);
        req.setAttribute("latestApproved", latestApproved);
        req.setAttribute("prevEnroll",    prevEnroll);
        req.setAttribute("feeForYear",    fee);
        req.setAttribute("academicYear",  getAcademicYear(nextYear));
        req.getRequestDispatcher("/student/re-enroll.jsp").forward(req, resp);
    }

    // ----------------------------------------------------------------
    // STUDENT: Submit enrollment form
    // ----------------------------------------------------------------
    private void handleSubmitEnroll(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {

        int appId       = Integer.parseInt(req.getParameter("applicationId"));
        int yearOfStudy = Integer.parseInt(req.getParameter("yearOfStudy"));
        String acYear   = req.getParameter("academicYear");

        Application app  = appDAO.findById(appId);
        if (app == null || app.getStudentId() != user.getId()) {
            req.getSession().setAttribute("flashError", "Invalid application.");
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        Program prog = progDAO.findById(app.getProgramId());
        if (prog == null) {
            req.getSession().setAttribute("flashError", "Program not found.");
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // ALWAYS get department from program, never trust application.departmentId
        int departmentId = prog.getDepartmentId();
        if (departmentId <= 0) {
            req.getSession().setAttribute("flashError",
                "Program is not linked to a valid department. Please contact admin.");
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // Double-check not already enrolled
        Enrollment existing = enrollDAO.findByStudentProgramYear(user.getId(), app.getProgramId(), yearOfStudy);
        if (existing != null) {
            req.getSession().setAttribute("flashError",
                "Already applied for Year " + yearOfStudy + ". Status: " + existing.getStatus());
            resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
            return;
        }

        // Save previous year performance if provided
        String prevEnrollIdStr = req.getParameter("prevEnrollId");
        if (prevEnrollIdStr != null && !prevEnrollIdStr.isEmpty()) {
            try {
                int prevId = Integer.parseInt(prevEnrollIdStr);
                String sgpaStr = req.getParameter("sgpa");
                String cgpaStr = req.getParameter("cgpa");
                String backStr = req.getParameter("backlogs");
                String attStr  = req.getParameter("attendance");
                if (sgpaStr != null && !sgpaStr.isEmpty()) {
                    enrollDAO.savePerformance(
                        prevId,
                        Double.parseDouble(sgpaStr),
                        Double.parseDouble(cgpaStr != null && !cgpaStr.isEmpty() ? cgpaStr : sgpaStr),
                        Integer.parseInt(backStr != null && !backStr.isEmpty() ? backStr : "0"),
                        Double.parseDouble(attStr != null && !attStr.isEmpty() ? attStr : "75")
                    );
                }
            } catch (Exception ignored) {}
        }

        // Create enrollment
        Enrollment enr = new Enrollment();
        enr.setStudentId(user.getId());
        enr.setApplicationId(appId);
        enr.setProgramId(app.getProgramId());
        enr.setDepartmentId(departmentId);  // ← from program, guaranteed valid
        enr.setYearOfStudy(yearOfStudy);
        enr.setAcademicYear(acYear != null && !acYear.isEmpty() ? acYear : getAcademicYear(yearOfStudy));
        enr.setApplicableFee(calcFeeForYear(prog, app.getCategory(), yearOfStudy));
        enr.setStatus("PENDING");

        if (enrollDAO.create(enr)) {
            try {
                notifDAO.create(new Notification(1,
                    "New Year " + yearOfStudy + " Enrollment Request",
                    user.getFullName() + " has applied for Year " + yearOfStudy +
                    " enrollment in " + prog.getName() + ". Enrollment No: " + enr.getEnrollmentNo()));
            } catch (Exception ignored) {}

            req.getSession().setAttribute("flashSuccess",
                "Year " + yearOfStudy + " enrollment submitted successfully! " +
                "Enrollment No: " + enr.getEnrollmentNo() +
                " | Fee: Rs." + enr.getApplicableFee() + "/year. Waiting for admin approval.");
        } else {
            req.getSession().setAttribute("flashError",
                "Failed to submit enrollment. Check server console for SQL error details.");
        }

        resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=myEnrollments");
    }

    // ----------------------------------------------------------------
    // ADMIN: Approve or Reject enrollment
    // ----------------------------------------------------------------
    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int    id      = Integer.parseInt(req.getParameter("id"));
        String status  = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        if (remarks == null || remarks.isEmpty()) remarks = status + " by admin.";

        Enrollment enr = enrollDAO.findById(id);
        enrollDAO.updateStatus(id, status, remarks);

        if ("APPROVED".equals(status) && enr != null) {
            // Update current_year in applications
            try (java.sql.Connection c = com.admission.util.DBConnection.getConnection();
                 java.sql.PreparedStatement ps = c.prepareStatement(
                    "UPDATE applications SET current_year = ? WHERE id = ?")) {
                ps.setInt(1, enr.getYearOfStudy());
                ps.setInt(2, enr.getApplicationId());
                ps.executeUpdate();
            } catch (Exception ex) { ex.printStackTrace(); }

            // Notify student
            try {
                notifDAO.create(new Notification(enr.getStudentId(),
                    "Year " + enr.getYearOfStudy() + " Enrollment APPROVED",
                    "Your Year " + enr.getYearOfStudy() + " enrollment (" + enr.getEnrollmentNo() +
                    ") has been approved! Please pay the fee of Rs." + enr.getApplicableFee() +
                    " before the due date."));
            } catch (Exception ignored) {}
        } else if ("REJECTED".equals(status) && enr != null) {
            try {
                notifDAO.create(new Notification(enr.getStudentId(),
                    "Year " + enr.getYearOfStudy() + " Enrollment REJECTED",
                    "Your Year " + enr.getYearOfStudy() + " enrollment has been rejected. " +
                    "Reason: " + remarks + ". Please contact the admission office."));
            } catch (Exception ignored) {}
        }

        resp.sendRedirect(req.getContextPath() + "/EnrollmentServlet?action=list");
    }

    // ----------------------------------------------------------------
    // Helpers
    // ----------------------------------------------------------------
    private BigDecimal calcFeeForYear(Program prog, String category, int year) {
        // Get year-specific base fee
        BigDecimal yearFee;
        switch (year) {
            case 1:  yearFee = prog.getFeeYear1() != null ? prog.getFeeYear1() : prog.getBaseFee(); break;
            case 2:  yearFee = prog.getFeeYear2() != null ? prog.getFeeYear2() : prog.getBaseFee(); break;
            case 3:  yearFee = prog.getFeeYear3() != null ? prog.getFeeYear3() : prog.getBaseFee(); break;
            case 4:  yearFee = prog.getFeeYear4() != null ? prog.getFeeYear4() : prog.getBaseFee(); break;
            default: yearFee = prog.getBaseFee();
        }

        // Apply category discount ratio
        BigDecimal generalFee = prog.getFeeGeneral();
        BigDecimal catFee     = prog.getFeeByCategory(category);

        if (generalFee != null && generalFee.compareTo(BigDecimal.ZERO) > 0
                && catFee != null && yearFee != null) {
            java.math.BigDecimal ratio = catFee.divide(generalFee, 4, java.math.RoundingMode.HALF_UP);
            return yearFee.multiply(ratio).setScale(0, java.math.RoundingMode.HALF_UP);
        }
        return yearFee != null ? yearFee : BigDecimal.ZERO;
    }

    private String getAcademicYear(int yearOfStudy) {
        int base = 2024;
        int start = base + yearOfStudy - 1;
        return start + "-" + String.valueOf(start + 1).substring(2);
    }
}