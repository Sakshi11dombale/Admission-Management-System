package com.admission.filter;
import com.admission.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
        if (request.getRequestURI().contains("/admin/") && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp"); return;
        }
        chain.doFilter(req, res);
    }
    public void init(FilterConfig fc) {} public void destroy() {}
}
