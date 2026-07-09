package com.admission.servlet;
import com.admission.dao.DocumentDAO;
import com.admission.model.Document;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class DocumentServlet extends HttpServlet {
    private final DocumentDAO dao = new DocumentDAO();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action"); if(action==null) action="list";
        if ("list".equals(action)) {
            req.setAttribute("documents", dao.findAll());
            req.getRequestDispatcher("/admin/documents.jsp").forward(req,resp);
        } else if ("download".equals(action)) {
            Document doc = dao.findById(Integer.parseInt(req.getParameter("id")));
            File file = new File(getServletContext().getRealPath("/uploads"), doc.getStoredName());
            resp.setContentType(doc.getMimeType());
            resp.setHeader("Content-Disposition","attachment; filename=\""+doc.getOriginalName()+"\"");
            try(FileInputStream fis=new FileInputStream(file); OutputStream out=resp.getOutputStream()) {
                byte[] buf=new byte[4096]; int n; while((n=fis.read(buf))!=-1) out.write(buf,0,n);
            }
        } else if ("verify".equals(action)) {
            dao.verify(Integer.parseInt(req.getParameter("id")));
            resp.sendRedirect(req.getContextPath()+"/ApplicationServlet?action=view&id="+req.getParameter("appId"));
        }
    }
}
