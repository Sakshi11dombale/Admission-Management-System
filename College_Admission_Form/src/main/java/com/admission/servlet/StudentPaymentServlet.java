package com.admission.servlet;
import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class StudentPaymentServlet extends HttpServlet {
    private final FeeDAO         feeDAO = new FeeDAO();
    private final ApplicationDAO appDAO = new ApplicationDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        req.setAttribute("myPayments",      feeDAO.findByStudentId(user.getId()));
        req.setAttribute("myApplications",  appDAO.findByStudentId(user.getId()));
        req.setAttribute("totalPaid",       feeDAO.totalPaidByStudent(user.getId()));
        req.getRequestDispatcher("/student/payments.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        try {
            int applicationId = Integer.parseInt(req.getParameter("applicationId"));
            Application app = appDAO.findById(applicationId);

            if (app == null || app.getStudentId() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/StudentPaymentServlet");
                return;
            }

            FeePayment f = new FeePayment();
            f.setApplicationId(applicationId);
            f.setStudentId(user.getId());
            f.setTransactionId("ENGG" + System.currentTimeMillis());
            f.setAmount(new BigDecimal(req.getParameter("amount")));
            f.setPaymentType(req.getParameter("paymentType"));
            f.setPaymentMode(req.getParameter("paymentMode"));
            f.setPaymentStatus("COMPLETED");
            f.setAcademicYear(req.getParameter("academicYear"));
            f.setYearOfStudy(Integer.parseInt(req.getParameter("yearOfStudy")));
            f.setSemester(Integer.parseInt(req.getParameter("semester")));
            f.setBankReference(req.getParameter("bankReference"));
            f.setRemarks("Student online payment");

            if (feeDAO.save(f)) {
                req.getSession().setAttribute("flashSuccess",
                    "Payment of Rs." + req.getParameter("amount") + " successful! Transaction ID: ENGG" + System.currentTimeMillis());
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/StudentPaymentServlet");
    }
}