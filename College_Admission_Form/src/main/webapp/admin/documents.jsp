<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Documents"); request.setAttribute("currentPage","documents"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">Documents</span>
</div>
<div class="section-header"><h2><i class="fas fa-folder-open me-2 text-primary"></i>All Documents</h2></div>
<div class="card">
    <div class="table-responsive">
        <table class="data-table">
            <thead><tr><th>#</th><th>App ID</th><th>Type</th><th>File Name</th><th>Size</th><th>Uploaded</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty documents}">
                        <c:forEach var="doc" items="${documents}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td class="fw-600 text-primary">${doc.applicationId}</td>
                                <td><span style="background:#e8f0fe;color:#1a3c6e;padding:3px 8px;border-radius:6px;font-size:12px">${doc.docType.replace('_',' ')}</span></td>
                                <td class="fs-13"><i class="fas fa-file-pdf text-danger me-1"></i>${doc.originalName}</td>
                                <td class="text-muted fs-13">${doc.fileSizeFormatted}</td>
                                <td class="text-muted fs-13"><fmt:formatDate value="${doc.uploadedAt}" pattern="dd MMM yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${doc.verified}"><span class="badge badge-approved"><i class="fas fa-check"></i> Verified</span></c:when>
                                        <c:otherwise><span class="badge badge-pending">Pending</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/DocumentServlet?action=download&id=${doc.id}" class="btn btn-light btn-xs"><i class="fas fa-download"></i></a>
                                    <c:if test="${not doc.verified}">
                                        <a href="${pageContext.request.contextPath}/DocumentServlet?action=verify&id=${doc.id}&appId=${doc.applicationId}" class="btn btn-success btn-xs"><i class="fas fa-check"></i></a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><tr><td colspan="8"><div class="empty-state"><i class="fas fa-folder-open"></i><h4>No Documents Uploaded</h4></div></td></tr></c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>