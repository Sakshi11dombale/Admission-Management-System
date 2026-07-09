<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Application Status"); request.setAttribute("currentPage","applications"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span>
    <a href="${pageContext.request.contextPath}/ApplicationServlet?action=myApplications">My Applications</a>
    <span class="sep">/</span><span class="current">${application.applicationNo}</span>
</div>

<div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-3">
    <div>
        <h2 style="font-size:22px;font-weight:700;color:#1c2a3a">${application.programName}</h2>
        <div class="d-flex gap-2 mt-1 align-items-center">
            <span class="text-muted fs-13">${application.applicationNo}</span>
            <span class="badge badge-${application.status.toLowerCase()}">${application.status}</span>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/ApplicationServlet?action=myApplications" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back</a>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-user"></i> Your Details</h5></div>
            <div class="card-body">
                <div class="detail-grid">
                    <div class="detail-item"><div class="detail-label">Full Name</div><div class="detail-value">${application.fullName}</div></div>
                    <div class="detail-item"><div class="detail-label">Date of Birth</div><div class="detail-value"><fmt:formatDate value="${application.dob}" pattern="dd MMMM yyyy"/></div></div>
                    <div class="detail-item"><div class="detail-label">Gender</div><div class="detail-value">${application.gender}</div></div>
                    <div class="detail-item"><div class="detail-label">City, State</div><div class="detail-value">${application.city}, ${application.state}</div></div>
                    <div class="detail-item"><div class="detail-label">10th Marks</div><div class="detail-value">${application.tenthMarks}%</div></div>
                    <div class="detail-item"><div class="detail-label">12th Marks</div><div class="detail-value">${application.twelfthMarks}%</div></div>
                </div>
                <c:if test="${not empty application.adminRemarks}">
                    <div class="mt-3 alert alert-info"><i class="fas fa-comment"></i><div><strong>Admin Remarks:</strong> ${application.adminRemarks}</div></div>
                </c:if>
            </div>
        </div>
        <div class="card">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-folder-open"></i> My Documents</h5></div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead><tr><th>Type</th><th>File</th><th>Status</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty documents}">
                                <c:forEach var="doc" items="${documents}">
                                    <tr>
                                        <td>${doc.docType.replace('_',' ')}</td>
                                        <td class="fs-13">${doc.originalName}</td>
                                        <td><c:choose><c:when test="${doc.verified}"><span class="badge badge-approved"><i class="fas fa-check"></i> Verified</span></c:when><c:otherwise><span class="badge badge-pending">Pending</span></c:otherwise></c:choose></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="3" class="text-center text-muted py-3">No documents uploaded</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-info-circle"></i> Application Status</h5></div>
            <div class="card-body">
                <div class="text-center mb-4">
                    <div style="width:80px;height:80px;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-size:32px;background:${application.status=='APPROVED'?'#dcfce7':application.status=='REJECTED'?'#fee2e2':'#fff8e1'}">
                        <c:choose>
                            <c:when test="${application.status=='APPROVED'}"><i class="fas fa-check-circle" style="color:#16a34a"></i></c:when>
                            <c:when test="${application.status=='REJECTED'}"><i class="fas fa-times-circle" style="color:#dc2626"></i></c:when>
                            <c:otherwise><i class="fas fa-hourglass-half" style="color:#d97706"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="mt-2 fw-600" style="font-size:16px">${application.status}</div>
                </div>
                <div class="timeline">
                    <div class="timeline-item">
                        <div class="tl-time"><fmt:formatDate value="${application.submittedAt}" pattern="dd MMM yyyy"/></div>
                        <div class="tl-title">Application Submitted</div>
                    </div>
                    <c:if test="${application.reviewedAt != null}">
                        <div class="timeline-item">
                            <div class="tl-time"><fmt:formatDate value="${application.reviewedAt}" pattern="dd MMM yyyy"/></div>
                            <div class="tl-title">Reviewed: ${application.status}</div>
                            <div class="tl-desc">${application.adminRemarks}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>