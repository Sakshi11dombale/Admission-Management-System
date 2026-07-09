package com.admission.servlet;
import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class ProgramServlet extends HttpServlet {
    private final ProgramDAO    progDAO = new ProgramDAO();
    private final DepartmentDAO deptDAO = new DepartmentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        req.setAttribute("programs",    progDAO.findAll());
        req.setAttribute("departments", deptDAO.findAll());
        req.getRequestDispatcher("/admin/programs.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (!user.isAdmin()) { resp.sendRedirect(req.getContextPath() + "/DashboardServlet"); return; }

        String action = req.getParameter("action");

        if ("create".equals(action)) {
            Program p = new Program();
            p.setName(req.getParameter("name"));
            p.setCode(req.getParameter("code"));
            p.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
            p.setDegreeType(req.getParameter("degreeType"));
            p.setDurationYears(Integer.parseInt(req.getParameter("durationYears")));
            p.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
            p.setEligibility(req.getParameter("eligibility"));
            p.setDescription(req.getParameter("description"));
            p.setActive(true);

            BigDecimal base = new BigDecimal(req.getParameter("baseFee"));
            p.setBaseFee(base);
            p.setFeeGeneral(base);

            String feeObc = req.getParameter("feeObc");
            String feeSc  = req.getParameter("feeSc");
            String feeSt  = req.getParameter("feeSt");
            String feeEws = req.getParameter("feeEws");

            p.setFeeObc(feeObc != null && !feeObc.isEmpty()
                ? new BigDecimal(feeObc) : base.multiply(new BigDecimal("0.75")));
            p.setFeeSc(feeSc != null && !feeSc.isEmpty()
                ? new BigDecimal(feeSc) : base.multiply(new BigDecimal("0.50")));
            p.setFeeSt(feeSt != null && !feeSt.isEmpty()
                ? new BigDecimal(feeSt) : base.multiply(new BigDecimal("0.50")));
            p.setFeeEws(feeEws != null && !feeEws.isEmpty()
                ? new BigDecimal(feeEws) : base.multiply(new BigDecimal("0.70")));
            p.setFeeMinority(base.multiply(new BigDecimal("0.90")));

            // Year-wise fees (Year 1 slightly higher)
            p.setFeeYear1(base.multiply(new BigDecimal("1.15")));
            p.setFeeYear2(base);
            p.setFeeYear3(base);
            p.setFeeYear4(base.multiply(new BigDecimal("0.95")));

            if (progDAO.create(p)) {
                req.setAttribute("successMsg", "Program added successfully!");
            } else {
                req.setAttribute("errorMsg", "Failed to add program.");
            }

        } else if ("update".equals(action)) {
            Program p = new Program();
            p.setId(Integer.parseInt(req.getParameter("id")));
            p.setName(req.getParameter("name"));
            p.setCode(req.getParameter("code"));
            p.setDegreeType(req.getParameter("degreeType"));
            p.setDurationYears(Integer.parseInt(req.getParameter("durationYears")));
            p.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
            p.setEligibility(req.getParameter("eligibility"));
            p.setDescription(req.getParameter("description"));
            p.setActive("true".equals(req.getParameter("isActive")));
            BigDecimal base = new BigDecimal(req.getParameter("baseFee"));
            p.setBaseFee(base);
            p.setFeeGeneral(base);
            p.setFeeObc(base.multiply(new BigDecimal("0.75")));
            p.setFeeSc(base.multiply(new BigDecimal("0.50")));
            p.setFeeSt(base.multiply(new BigDecimal("0.50")));
            p.setFeeEws(base.multiply(new BigDecimal("0.70")));
            p.setFeeMinority(base.multiply(new BigDecimal("0.90")));
            p.setFeeYear1(base.multiply(new BigDecimal("1.15")));
            p.setFeeYear2(base);
            p.setFeeYear3(base);
            p.setFeeYear4(base.multiply(new BigDecimal("0.95")));
            progDAO.update(p);

        } else if ("delete".equals(action)) {
            progDAO.delete(Integer.parseInt(req.getParameter("id")));
        }

        req.setAttribute("programs",    progDAO.findAll());
        req.setAttribute("departments", deptDAO.findAll());
        req.getRequestDispatcher("/admin/programs.jsp").forward(req, resp);
    }
}
