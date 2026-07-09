<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","My Dashboard"); request.setAttribute("currentPage","dashboard"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div style="background:linear-gradient(135deg,#1a3c6e,#2a5298);color:#fff;border-radius:14px;padding:28px 32px;margin-bottom:28px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px">
    <div>
        <h2 style="font-size:22px;font-weight:700;margin-bottom:4px">Welcome, ${loggedUser.fullName}! 👋</h2>
        <p style="opacity:0.8;font-size:14px;margin:0">Track your applications and admission status here.</p>
    </div>
    <a href="${pageContext.request.contextPath}/student/apply.jsp" class="btn btn-accent"><i class="fas fa-plus"></i> Apply Now</a>
    
</div>

<div class="stats-row">
    <div class="stat-card"><div class="stat-icon blue"><i class="fas fa-file-alt"></i></div><div class="stat-info"><div class="stat-value">${totalApps != null ? totalApps : 0}</div><div class="stat-label">My Applications</div></div></div>
    <div class="stat-card"><div class="stat-icon orange"><i class="fas fa-hourglass-half"></i></div><div class="stat-info"><div class="stat-value">${pendingApps != null ? pendingApps : 0}</div><div class="stat-label">Pending</div></div></div>
    <div class="stat-card"><div class="stat-icon green"><i class="fas fa-check-circle"></i></div><div class="stat-info"><div class="stat-value">${approvedApps != null ? approvedApps : 0}</div><div class="stat-label">Approved</div></div></div>
    <div class="stat-card"><div class="stat-icon teal"><i class="fas fa-bell"></i></div><div class="stat-info"><div class="stat-value">${unreadNotifs != null ? unreadNotifs : 0}</div><div class="stat-label">Notifications</div></div></div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title"><i class="fas fa-file-alt"></i> My Applications</h5>
                <a href="${pageContext.request.contextPath}/ApplicationServlet?action=myApplications" class="btn btn-outline btn-sm">View All</a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead><tr><th>App No.</th><th>Program</th><th>Applied On</th><th>Status</th><th>Action</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty myApplications}">
                                <c:forEach var="app" items="${myApplications}">
                                    <tr>
                                        <td class="fw-600 text-primary">${app.applicationNo}</td>
                                        <td class="fs-13">${app.programName}</td>
                                        <td class="text-muted fs-13"><fmt:formatDate value="${app.submittedAt}" pattern="dd MMM yyyy"/></td>
                                        <td><span class="badge badge-${app.status.toLowerCase()}">${app.status}</span></td>
                                        <td><a href="${pageContext.request.contextPath}/ApplicationServlet?action=view&id=${app.id}" class="btn btn-light btn-xs"><i class="fas fa-eye"></i></a></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="5"><div class="empty-state py-4"><i class="fas fa-file-alt"></i><h4>No Applications Yet</h4><a href="${pageContext.request.contextPath}/student/apply.jsp" class="btn btn-primary mt-2">Apply Now</a></div></td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-bell"></i> Recent Notifications</h5></div>
            <div style="padding:0">
                <c:choose>
                    <c:when test="${not empty myNotifications}">
                        <c:forEach var="n" items="${myNotifications}">
                            <div style="padding:14px 20px;border-bottom:1px solid #f1f5f9;${not n.read?'background:#fffbeb':''}">
                                <div class="fw-600 fs-13">${n.title}</div>
                                <div class="text-muted" style="font-size:12px">${n.message}</div>
                                <div style="font-size:11px;color:#94a3b8;margin-top:4px"><fmt:formatDate value="${n.createdAt}" pattern="dd MMM, HH:mm"/></div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><div class="empty-state py-4"><i class="fas fa-bell-slash"></i><p>No notifications.</p></div></c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>