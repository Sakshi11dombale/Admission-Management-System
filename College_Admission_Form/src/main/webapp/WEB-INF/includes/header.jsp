<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    com.admission.model.User loggedUser = (com.admission.model.User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "College Admission" %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>

<aside class="sidebar" id="mainSidebar">
    <a href="${pageContext.request.contextPath}/DashboardServlet" class="sidebar-brand">
        <div class="brand-icon"><i class="fas fa-graduation-cap"></i></div>
        <div class="brand-text">
            <strong>AdmissionPro</strong>
            <span>Management System</span>
        </div>
    </a>

    <% if (loggedUser.isAdmin()) { %>
    <div class="sidebar-section-label">Main</div>
    <nav>
        <a href="${pageContext.request.contextPath}/DashboardServlet" class="<%= "dashboard".equals(currentPage)?"active":"" %>"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/ApplicationServlet?action=list" class="<%= "applications".equals(currentPage)?"active":"" %>"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list"class="<%= "enrollments".equals(currentPage) ? "active" : "" %>"> <i class="fas fa-calendar-alt"></i> Enrollments</a>
    <%-- Pending badge --%>
</a>
    </nav>
    <div class="sidebar-section-label">Management</div>
    <nav>
        <a href="${pageContext.request.contextPath}/ProgramServlet?action=list" class="<%= "programs".equals(currentPage)?"active":"" %>"><i class="fas fa-book-open"></i> Programs</a>
        <a href="${pageContext.request.contextPath}/StudentServlet?action=list" class="<%= "students".equals(currentPage)?"active":"" %>"><i class="fas fa-user-graduate"></i> Students</a>
        <a href="${pageContext.request.contextPath}/FeeServlet?action=list" class="<%= "fees".equals(currentPage)?"active":"" %>"><i class="fas fa-money-bill-wave"></i> Fee Payments</a>
        <a href="${pageContext.request.contextPath}/DocumentServlet?action=list" class="<%= "documents".equals(currentPage)?"active":"" %>"><i class="fas fa-folder-open"></i> Documents</a>
    </nav>
    <div class="sidebar-section-label">Communication</div>
    <nav>
        <a href="${pageContext.request.contextPath}/NotificationServlet?action=list" class="<%= "notifications".equals(currentPage)?"active":"" %>"><i class="fas fa-bell"></i> Notifications</a>
    </nav>
    <% } else { %>
    <div class="sidebar-section-label">My Portal</div>
    <nav>
        <a href="${pageContext.request.contextPath}/DashboardServlet" class="<%= "dashboard".equals(currentPage)?"active":"" %>"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/ApplicationServlet?action=myApplications" class="<%= "applications".equals(currentPage)?"active":"" %>"><i class="fas fa-file-alt"></i> My Applications</a>
        <a href="${pageContext.request.contextPath}/StudentPaymentServlet?action=payments" class="<%= "payments".equals(currentPage) ? "active" : "" %>"><i class="fas fa-credit-card"></i> Fee Payments</a>
        <a href="${pageContext.request.contextPath}/student/apply.jsp" class="<%= "apply".equals(currentPage)?"active":"" %>"><i class="fas fa-plus-circle"></i> Apply Now</a>
    	<a href="${pageContext.request.contextPath}/EnrollmentServlet?action=myEnrollments"class="<%= "enrollments".equals(currentPage) ? "active" : "" %>"><i class="fas fa-calendar-check"></i> My Enrollments</a>
        <a href="${pageContext.request.contextPath}/ProgramServlet?action=list" class="<%= "programs".equals(currentPage)?"active":"" %>"><i class="fas fa-book-open"></i> Browse Programs</a>
        <a href="${pageContext.request.contextPath}/NotificationServlet?action=myNotifications" class="<%= "notifications".equals(currentPage)?"active":"" %>"><i class="fas fa-bell"></i> Notifications</a>
    </nav>
    <% } %>

    <div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar"><i class="fas fa-user"></i></div>
            <div>
                <div style="font-weight:600;font-size:13px;color:#fff"><%= loggedUser.getFullName() %></div>
                <div style="font-size:11px;color:rgba(255,255,255,0.5)"><%= loggedUser.getRole() %></div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/LogoutServlet" style="color:rgba(255,255,255,0.6);font-size:13px;text-decoration:none;display:flex;align-items:center;gap:6px">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</aside>

<div class="main-wrapper">
    <header class="topbar">
        <button class="btn-icon d-md-none" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <span class="page-title"><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "" %></span>
        <div class="topbar-actions">
            <div class="admin-chip">
                <div class="chip-avatar"><i class="fas fa-user"></i></div>
                <%= loggedUser.getFullName().split(" ")[0] %>
            </div>
        </div>
    </header>
    <div class="page-content">