package com.admission.servlet;
import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class FeeServlet extends HttpServlet {
    private final FeeDAO feeDAO = new FeeDAO();
    private final ApplicationDAO appDAO = new ApplicationDAO();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("payments",        feeDAO.findAll(req.getParameter("status"),req.getParameter("search")));
        req.setAttribute("totalRevenue",    feeDAO.totalRevenue());
        req.setAttribute("totalPayments",   feeDAO.count(null));
        req.setAttribute("pendingPayments", feeDAO.count("PENDING"));
        req.getRequestDispatcher("/admin/fees.jsp").forward(req,resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            Application app = appDAO.findByApplicationNo(req.getParameter("applicationNo"));
            if (app==null) { resp.sendRedirect(req.getContextPath()+"/FeeServlet?action=list"); return; }
            FeePayment f = new FeePayment();
            f.setApplicationId(app.getId()); f.setTransactionId("TXN"+System.currentTimeMillis());
            f.setAmount(new BigDecimal(req.getParameter("amount"))); f.setPaymentType(req.getParameter("paymentType"));
            f.setPaymentMode(req.getParameter("paymentMode")); f.setPaymentStatus(req.getParameter("paymentStatus"));
            f.setRemarks(req.getParameter("remarks")); feeDAO.save(f);
        } else if ("confirm".equals(action)) { feeDAO.confirm(Integer.parseInt(req.getParameter("id"))); }
        resp.sendRedirect(req.getContextPath()+"/FeeServlet?action=list");
    }
}
