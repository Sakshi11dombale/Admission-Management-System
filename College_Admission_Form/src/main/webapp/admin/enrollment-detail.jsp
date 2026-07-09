<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","Enrollment Detail");
    request.setAttribute("currentPage","enrollments");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span>
    <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list">Enrollments</a>
    <span class="sep">/</span>
    <span class="current">${enrollment.enrollmentNo}</span>
</div>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px">
    <div>
        <h2 style="font-size:20px;font-weight:700">${enrollment.studentName}</h2>
        <div style="display:flex;gap:8px;margin-top:6px;align-items:center">
            <span class="app-no">${enrollment.enrollmentNo}</span>
            <span class="badge badge-${enrollment.status.toLowerCase()}">${enrollment.status}</span>
            <span style="background:#eff6ff;color:#2563eb;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:700">Year ${enrollment.yearOfStudy}</span>
        </div>
    </div>
    <div style="display:flex;gap:8px">
        <c:if test="${enrollment.status == 'PENDING'}">
            <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" style="display:inline">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="id" value="${enrollment.id}">
                <input type="hidden" name="status" value="APPROVED">
                <input type="hidden" name="remarks" value="Approved by admin.">
                <button type="submit" class="btn btn-success" onclick="return confirm('Approve this enrollment?')">
                    <i class="fas fa-check"></i> Approve
                </button>
            </form>
            <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" style="display:inline">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="id" value="${enrollment.id}">
                <input type="hidden" name="status" value="REJECTED">
                <input type="hidden" name="remarks" value="Rejected by admin.">
                <button type="submit" class="btn btn-danger" onclick="return confirm('Reject this enrollment?')">
                    <i class="fas fa-times"></i> Reject
                </button>
            </form>
        </c:if>
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list" class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Back
        </a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-info-circle"></i> Enrollment Details</h5></div>
            <div class="card-body">
                <div class="detail-grid">
                    <div class="detail-item"><div class="detail-label">Student Name</div><div class="detail-value">${enrollment.studentName}</div></div>
                    <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value">${enrollment.studentEmail}</div></div>
                    <div class="detail-item"><div class="detail-label">Program</div><div class="detail-value">${enrollment.programName}</div></div>
                    <div class="detail-item"><div class="detail-label">Department</div><div class="detail-value">${enrollment.departmentName}</div></div>
                    <div class="detail-item"><div class="detail-label">Year of Study</div><div class="detail-value">Year ${enrollment.yearOfStudy}</div></div>
                    <div class="detail-item"><div class="detail-label">Academic Year</div><div class="detail-value">${enrollment.academicYear}</div></div>
                    <div class="detail-item"><div class="detail-label">Applicable Fee</div><div class="detail-value" style="color:#1a4b8c;font-weight:700">₹<fmt:formatNumber value="${enrollment.applicableFee}" pattern="#,##,##0"/></div></div>
                    <div class="detail-item"><div class="detail-label">Fee Paid</div><div class="detail-value">${enrollment.feePaid ? '✅ Yes' : '❌ No'}</div></div>
                </div>
                <c:if test="${enrollment.sgpa != null}">
                    <hr style="margin:16px 0;border-color:#f1f5f9">
                    <div style="font-weight:700;color:#1e293b;margin-bottom:12px">Previous Year Academic Performance</div>
                    <div class="detail-grid">
                        <div class="detail-item"><div class="detail-label">SGPA</div><div class="detail-value">${enrollment.sgpa}</div></div>
                        <div class="detail-item"><div class="detail-label">CGPA</div><div class="detail-value">${enrollment.cgpa}</div></div>
                        <div class="detail-item"><div class="detail-label">Backlogs</div><div class="detail-value" style="${enrollment.backlogs > 0 ? 'color:#dc2626' : ''}">${enrollment.backlogs}</div></div>
                        <div class="detail-item"><div class="detail-label">Attendance</div><div class="detail-value">${enrollment.attendancePercent}%</div></div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-history"></i> Timeline</h5></div>
            <div class="card-body">
                <div class="timeline">
                    <div class="tl-item">
                        <div class="tl-date"><fmt:formatDate value="${enrollment.enrolledAt}" pattern="dd MMM yyyy, HH:mm"/></div>
                        <div class="tl-title">Re-enrollment Submitted</div>
                        <div class="tl-desc">Student submitted Year ${enrollment.yearOfStudy} enrollment</div>
                    </div>
                    <c:if test="${enrollment.approvedAt != null}">
                        <div class="tl-item">
                            <div class="tl-date"><fmt:formatDate value="${enrollment.approvedAt}" pattern="dd MMM yyyy, HH:mm"/></div>
                            <div class="tl-title">Status: ${enrollment.status}</div>
                            <div class="tl-desc">${enrollment.adminRemarks}</div>
                        </div>
                    </c:if>
                    <c:if test="${enrollment.feePaidDate != null}">
                        <div class="tl-item">
                            <div class="tl-date"><fmt:formatDate value="${enrollment.feePaidDate}" pattern="dd MMM yyyy"/></div>
                            <div class="tl-title">Fee Paid</div>
                            <div class="tl-desc">₹<fmt:formatNumber value="${enrollment.applicableFee}" pattern="#,##,##0"/> received</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>