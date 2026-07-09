package com.admission.servlet;
import com.admission.dao.*;
import com.admission.model.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.UUID;

@MultipartConfig(maxFileSize=5242880, maxRequestSize=20971520, fileSizeThreshold=1048576)
public class ApplicationServlet extends HttpServlet {
    private final ApplicationDAO appDAO  = new ApplicationDAO();
    private final ProgramDAO     progDAO = new ProgramDAO();
    private final DocumentDAO    docDAO  = new DocumentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action"); if (action==null) action="list";
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        switch(action) {
            case "list":
                req.setAttribute("applications", appDAO.findAllFiltered(req.getParameter("status"),req.getParameter("programId"),req.getParameter("search")));
                req.setAttribute("programs", progDAO.findAllActive());
                req.getRequestDispatcher("/admin/applications.jsp").forward(req,resp);
                break;

            case "myApplications":
                req.setAttribute("applications", appDAO.findByStudentId(user.getId()));
                req.getRequestDispatcher("/student/my-applications.jsp").forward(req,resp);
                break;

            case "view":
                int id = Integer.parseInt(req.getParameter("id"));
                Application app = appDAO.findById(id);
                req.setAttribute("application", app);
                req.setAttribute("documents",   docDAO.findByApplicationId(id));
                req.setAttribute("payments",    new FeeDAO().findByApplicationId(id));
                req.getRequestDispatcher(user.isAdmin() ? "/admin/application-detail.jsp" : "/student/application-status.jsp").forward(req,resp);
                break;

            case "applyForm":
                DepartmentDAO deptDAO = new DepartmentDAO();
                req.setAttribute("departments", deptDAO.findAll());
                String deptId = req.getParameter("deptId");
                if (deptId != null && !deptId.isEmpty()) {
                    req.setAttribute("programs", progDAO.findByDepartment(Integer.parseInt(deptId)));
                    req.setAttribute("selectedDeptId", deptId);
                } else {
                    req.setAttribute("programs", progDAO.findAll());
                }
                req.getRequestDispatcher("/student/apply.jsp").forward(req, resp);
                break;
        }
    }
    
    private void loadApplyForm(HttpServletRequest req, String deptId) {
        DepartmentDAO deptDAO = new DepartmentDAO();
        req.setAttribute("departments", deptDAO.findAll());
        if (deptId != null && !deptId.isEmpty()) {
            req.setAttribute("programs", progDAO.findByDepartment(Integer.parseInt(deptId)));
            req.setAttribute("selectedDeptId", deptId);
        } else {
            req.setAttribute("programs", progDAO.findAll());
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        User user = (User) req.getSession().getAttribute("loggedUser");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        if ("submit".equals(action)) {
            try {
                Application a = new Application();
                a.setStudentId(user.getId());

                int programId = Integer.parseInt(req.getParameter("programId"));
                a.setProgramId(programId);

                // Get program to determine department and fee
                Program prog = progDAO.findById(programId);
                if (prog == null) throw new Exception("Invalid program selected.");
                a.setDepartmentId(prog.getDepartmentId());

                a.setFirstName(req.getParameter("firstName"));
                a.setLastName(req.getParameter("lastName"));
                a.setDob(Date.valueOf(req.getParameter("dob")));
                a.setGender(req.getParameter("gender"));
                a.setCategory(req.getParameter("category"));
                a.setReligion(req.getParameter("religion"));
                a.setAddress(req.getParameter("address"));
                a.setCity(req.getParameter("city"));
                a.setState(req.getParameter("state"));
                a.setPincode(req.getParameter("pincode"));
                a.setParentName(req.getParameter("parentName"));
                a.setParentPhone(req.getParameter("parentPhone"));
                a.setParentOccupation(req.getParameter("parentOccupation"));

                String income = req.getParameter("annualIncome");
                if (income != null && !income.isEmpty()) a.setAnnualIncome(new BigDecimal(income));

                String t10 = req.getParameter("tenthMarks");
                String t12 = req.getParameter("twelfthMarks");
                String ent = req.getParameter("entranceScore");
                String rank = req.getParameter("entranceRank");

                if (t10 != null && !t10.isEmpty()) a.setTenthMarks(new BigDecimal(t10));
                if (t12 != null && !t12.isEmpty()) a.setTwelfthMarks(new BigDecimal(t12));
                if (ent != null && !ent.isEmpty()) a.setEntranceScore(new BigDecimal(ent));
                if (rank != null && !rank.isEmpty()) a.setEntranceRank(Integer.parseInt(rank));

                a.setTenthBoard(req.getParameter("tenthBoard"));
                a.setTwelfthBoard(req.getParameter("twelfthBoard"));
                a.setTwelfthStream(req.getParameter("twelfthStream"));
                a.setEntranceExam(req.getParameter("entranceExam"));

                // Calculate fee based on category
                java.math.BigDecimal feePerYear = prog.getFeeByCategory(a.getCategory());
                java.math.BigDecimal totalFee = feePerYear.multiply(new java.math.BigDecimal(prog.getDurationYears()));
                a.setApplicableFeePerYear(feePerYear);
                a.setTotalProgramFee(totalFee);

                boolean created = appDAO.create(a);

                if (created) {
                    // File uploads
                    try {
                        String uploadDir = getServletContext().getRealPath("/uploads");
                        new java.io.File(uploadDir).mkdirs();
                        Application saved = appDAO.findByApplicationNo(a.getApplicationNo());
                        String[] docTypes = {"PHOTO","TENTH_MARKSHEET","TWELFTH_MARKSHEET",
                                             "ENTRANCE_CERT","CATEGORY_CERT","INCOME_CERT",
                                             "DOMICILE_CERT","ID_PROOF"};
                        for (String dtype : docTypes) {
                            Part part = req.getPart("doc_" + dtype);
                            if (part != null && part.getSize() > 0) {
                                String origName = part.getSubmittedFileName();
                                if (origName != null && !origName.isEmpty()) {
                                    String stored = java.util.UUID.randomUUID() + "_" + origName.replaceAll("[^a-zA-Z0-9._-]","_");
                                    part.write(uploadDir + java.io.File.separator + stored);
                                    Document doc = new Document();
                                    doc.setApplicationId(saved.getId()); doc.setDocType(dtype);
                                    doc.setOriginalName(origName); doc.setStoredName(stored);
                                    doc.setFileSize(part.getSize()); doc.setMimeType(part.getContentType());
                                    docDAO.save(doc);
                                }
                            }
                        }
                    } catch (Exception fe) { fe.printStackTrace(); }

                    req.getSession().setAttribute("flashSuccess",
                        "Application submitted! Your Application No: " + a.getApplicationNo() +
                        " | Applicable Fee: Rs." + feePerYear.toPlainString() + "/year");
                    resp.sendRedirect(req.getContextPath() + "/ApplicationServlet?action=myApplications");
                } else {
                    req.setAttribute("errorMsg", "Submission failed. Please try again.");
                    loadApplyForm(req, null);
                    req.getRequestDispatcher("/student/apply.jsp").forward(req, resp);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                req.setAttribute("errorMsg", "Error: " + ex.getMessage());
                loadApplyForm(req, null);
                req.getRequestDispatcher("/student/apply.jsp").forward(req, resp);
            }
        }if ("submit".equals(action)) {
            try {
                Application a = new Application();
                a.setStudentId(user.getId());

                int programId = Integer.parseInt(req.getParameter("programId"));
                a.setProgramId(programId);

                // Get program to determine department and fee
                Program prog = progDAO.findById(programId);
                if (prog == null) throw new Exception("Invalid program selected.");
                a.setDepartmentId(prog.getDepartmentId());

                a.setFirstName(req.getParameter("firstName"));
                a.setLastName(req.getParameter("lastName"));
                a.setDob(Date.valueOf(req.getParameter("dob")));
                a.setGender(req.getParameter("gender"));
                a.setCategory(req.getParameter("category"));
                a.setReligion(req.getParameter("religion"));
                a.setAddress(req.getParameter("address"));
                a.setCity(req.getParameter("city"));
                a.setState(req.getParameter("state"));
                a.setPincode(req.getParameter("pincode"));
                a.setParentName(req.getParameter("parentName"));
                a.setParentPhone(req.getParameter("parentPhone"));
                a.setParentOccupation(req.getParameter("parentOccupation"));

                String income = req.getParameter("annualIncome");
                if (income != null && !income.isEmpty()) a.setAnnualIncome(new BigDecimal(income));

                String t10 = req.getParameter("tenthMarks");
                String t12 = req.getParameter("twelfthMarks");
                String ent = req.getParameter("entranceScore");
                String rank = req.getParameter("entranceRank");

                if (t10 != null && !t10.isEmpty()) a.setTenthMarks(new BigDecimal(t10));
                if (t12 != null && !t12.isEmpty()) a.setTwelfthMarks(new BigDecimal(t12));
                if (ent != null && !ent.isEmpty()) a.setEntranceScore(new BigDecimal(ent));
                if (rank != null && !rank.isEmpty()) a.setEntranceRank(Integer.parseInt(rank));

                a.setTenthBoard(req.getParameter("tenthBoard"));
                a.setTwelfthBoard(req.getParameter("twelfthBoard"));
                a.setTwelfthStream(req.getParameter("twelfthStream"));
                a.setEntranceExam(req.getParameter("entranceExam"));

                // Calculate fee based on category
                java.math.BigDecimal feePerYear = prog.getFeeByCategory(a.getCategory());
                java.math.BigDecimal totalFee = feePerYear.multiply(new java.math.BigDecimal(prog.getDurationYears()));
                a.setApplicableFeePerYear(feePerYear);
                a.setTotalProgramFee(totalFee);

                boolean created = appDAO.create(a);

                if (created) {
                    // File uploads
                    try {
                        String uploadDir = getServletContext().getRealPath("/uploads");
                        new java.io.File(uploadDir).mkdirs();
                        Application saved = appDAO.findByApplicationNo(a.getApplicationNo());
                        String[] docTypes = {"PHOTO","TENTH_MARKSHEET","TWELFTH_MARKSHEET",
                                             "ENTRANCE_CERT","CATEGORY_CERT","INCOME_CERT",
                                             "DOMICILE_CERT","ID_PROOF"};
                        for (String dtype : docTypes) {
                            Part part = req.getPart("doc_" + dtype);
                            if (part != null && part.getSize() > 0) {
                                String origName = part.getSubmittedFileName();
                                if (origName != null && !origName.isEmpty()) {
                                    String stored = java.util.UUID.randomUUID() + "_" + origName.replaceAll("[^a-zA-Z0-9._-]","_");
                                    part.write(uploadDir + java.io.File.separator + stored);
                                    Document doc = new Document();
                                    doc.setApplicationId(saved.getId()); doc.setDocType(dtype);
                                    doc.setOriginalName(origName); doc.setStoredName(stored);
                                    doc.setFileSize(part.getSize()); doc.setMimeType(part.getContentType());
                                    docDAO.save(doc);
                                }
                            }
                        }
                    } catch (Exception fe) { fe.printStackTrace(); }

                    req.getSession().setAttribute("flashSuccess",
                        "Application submitted! Your Application No: " + a.getApplicationNo() +
                        " | Applicable Fee: Rs." + feePerYear.toPlainString() + "/year");
                    resp.sendRedirect(req.getContextPath() + "/ApplicationServlet?action=myApplications");
                } else {
                    req.setAttribute("errorMsg", "Submission failed. Please try again.");
                    loadApplyForm(req, null);
                    req.getRequestDispatcher("/student/apply.jsp").forward(req, resp);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                req.setAttribute("errorMsg", "Error: " + ex.getMessage());
                loadApplyForm(req, null);
                req.getRequestDispatcher("/student/apply.jsp").forward(req, resp);
            }
        

        } else if ("updateStatus".equals(action)) {
            if (!user.isAdmin()) { resp.sendRedirect(req.getContextPath() + "/student/dashboard.jsp"); return; }
            int appId = Integer.parseInt(req.getParameter("id"));
            appDAO.updateStatus(appId, req.getParameter("status"), req.getParameter("remarks"));
            Application app = appDAO.findById(appId);
            if (app != null) {
                new NotificationDAO().create(new Notification(app.getStudentId(),
                    "Application Status Updated",
                    "Your application " + app.getApplicationNo() + " is now: " + req.getParameter("status")));
            }
            resp.sendRedirect(req.getContextPath() + "/ApplicationServlet?action=view&id=" + appId);
        }
        
        
    }
}