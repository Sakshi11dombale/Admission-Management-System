<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","My Applications"); request.setAttribute("currentPage","applications"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">My Applications</span>
</div>
<div class="section-header">
    <h2><i class="fas fa-file-alt me-2 text-primary"></i>My Applications</h2>
    <a href="${pageContext.request.contextPath}/student/apply.jsp" class="btn btn-primary"><i class="fas fa-plus"></i> New Application</a>
</div>
<div class="card">
    <div class="table-responsive">
        <table class="data-table">
            <thead><tr><th>#</th><th>App Number</th><th>Program</th><th>Submitted</th><th>Status</th><th>Remarks</th><th>Action</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty applications}">
                        <c:forEach var="app" items="${applications}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td class="fw-600 text-primary">${app.applicationNo}</td>
                                <td class="fs-13">${app.programName}</td>
                                <td class="text-muted fs-13"><fmt:formatDate value="${app.submittedAt}" pattern="dd MMM yyyy"/></td>
                                <td><span class="badge badge-${app.status.toLowerCase()}">${app.status}</span></td>
                                <td class="text-muted fs-13">${not empty app.adminRemarks ? app.adminRemarks : '-'}</td>
                                <td><a href="${pageContext.request.contextPath}/ApplicationServlet?action=view&id=${app.id}" class="btn btn-light btn-xs"><i class="fas fa-eye"></i></a></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="7"><div class="empty-state"><i class="fas fa-folder-open"></i><h4>No Applications Yet</h4><p>Click 'New Application' to get started.</p></div></td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>