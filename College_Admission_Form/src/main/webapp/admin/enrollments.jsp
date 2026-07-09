<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","Year-wise Enrollments");
    request.setAttribute("currentPage","enrollments");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i> Home</a>
    <span class="sep">/</span><span class="current">Enrollments</span>
</div>

<!-- Header -->
<div class="section-header">
    <h2 class="section-title">
        <i class="fas fa-calendar-check"></i> Year-wise Enrollments
        <c:if test="${pendingCount > 0}">
            <span style="background:#fef2f2;color:#dc2626;font-size:12px;padding:3px 10px;border-radius:20px;margin-left:8px;font-weight:700;animation:pulse 2s infinite">
                ${pendingCount} Pending
            </span>
        </c:if>
    </h2>
    <div style="display:flex;gap:8px;flex-wrap:wrap">
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list"
           style="padding:7px 16px;border-radius:20px;font-size:12px;font-weight:600;text-decoration:none;border:1.5px solid ${empty param.status ? '#2563eb' : '#e2e8f0'};background:${empty param.status ? '#2563eb' : '#fff'};color:${empty param.status ? '#fff' : '#64748b'}">
            All (${totalCount})
        </a>
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list&status=PENDING"
           style="padding:7px 16px;border-radius:20px;font-size:12px;font-weight:600;text-decoration:none;border:1.5px solid ${param.status == 'PENDING' ? '#d97706' : '#e2e8f0'};background:${param.status == 'PENDING' ? '#d97706' : '#fff'};color:${param.status == 'PENDING' ? '#fff' : '#64748b'}">
            Pending (${pendingCount})
        </a>
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list&status=APPROVED"
           style="padding:7px 16px;border-radius:20px;font-size:12px;font-weight:600;text-decoration:none;border:1.5px solid ${param.status == 'APPROVED' ? '#059669' : '#e2e8f0'};background:${param.status == 'APPROVED' ? '#059669' : '#fff'};color:${param.status == 'APPROVED' ? '#fff' : '#64748b'}">
            Approved
        </a>
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=list&status=REJECTED"
           style="padding:7px 16px;border-radius:20px;font-size:12px;font-weight:600;text-decoration:none;border:1.5px solid ${param.status == 'REJECTED' ? '#dc2626' : '#e2e8f0'};background:${param.status == 'REJECTED' ? '#dc2626' : '#fff'};color:${param.status == 'REJECTED' ? '#fff' : '#64748b'}">
            Rejected
        </a>
    </div>
</div>

<div class="card">
    <div class="table-wrap">
        <table class="data-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Enrollment No.</th>
                    <th>Student</th>
                    <th>Program</th>
                    <th>Year</th>
                    <th>Acad. Year</th>
                    <th>Fee</th>
                    <th>Paid</th>
                    <th>SGPA</th>
                    <th>Backlogs</th>
                    <th>Attendance</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <c:forEach var="enr" items="${enrollments}" varStatus="st">
                            <tr style="${enr.status == 'PENDING' ? 'background:#fffbeb' : ''}">
                                <td style="color:#64748b;font-size:12px">${st.count}</td>
                                <td style="font-size:11px;font-weight:600;color:#2563eb">${enr.enrollmentNo}</td>
                                <td>
                                    <div style="font-weight:600;font-size:13px">${enr.studentName}</div>
                                    <div style="font-size:11px;color:#64748b">${enr.studentEmail}</div>
                                </td>
                                <td>
                                    <div style="font-size:12px;font-weight:600">${enr.programName}</div>
                                    <div style="font-size:11px;color:#64748b">${enr.departmentName}</div>
                                </td>
                                <td style="text-align:center">
                                    <span style="background:#eff6ff;color:#2563eb;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:700">
                                        Yr ${enr.yearOfStudy}
                                    </span>
                                </td>
                                <td style="font-size:12px;color:#64748b">${enr.academicYear}</td>
                                <td style="font-weight:700;color:#1a4b8c;font-size:13px">
                                    ₹<fmt:formatNumber value="${enr.applicableFee}" pattern="#,##,##0"/>
                                </td>
                                <td style="text-align:center">
                                    <c:choose>
                                        <c:when test="${enr.feePaid}">
                                            <span style="color:#059669;font-size:16px">✓</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#dc2626;font-size:11px;font-weight:700">Due</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align:center">
                                    <c:choose>
                                        <c:when test="${enr.sgpa != null}">
                                            <span style="font-weight:700;color:${enr.sgpa >= 6 ? '#059669' : enr.sgpa >= 5 ? '#d97706' : '#dc2626'}">${enr.sgpa}</span>
                                        </c:when>
                                        <c:otherwise><span style="color:#94a3b8">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align:center">
                                    <c:choose>
                                        <c:when test="${enr.backlogs > 0}">
                                            <span style="color:#dc2626;font-weight:700">${enr.backlogs}</span>
                                        </c:when>
                                        <c:otherwise><span style="color:#059669;font-weight:700">0</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align:center">
                                    <c:choose>
                                        <c:when test="${enr.attendancePercent != null}">
                                            <span style="font-weight:700;color:${enr.attendancePercent >= 75 ? '#059669' : '#dc2626'}">${enr.attendancePercent}%</span>
                                        </c:when>
                                        <c:otherwise><span style="color:#94a3b8">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge badge-${enr.status.toLowerCase()}">${enr.status}</span>
                                </td>
                                <td>
                                    <div style="display:flex;gap:4px;flex-wrap:wrap">
                                        <c:if test="${enr.status == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" style="display:inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="id" value="${enr.id}">
                                                <input type="hidden" name="status" value="APPROVED">
                                                <input type="hidden" name="remarks" value="Enrollment approved.">
                                                <button type="submit" class="btn btn-success btn-xs"
                                                        onclick="return confirm('Approve Year ${enr.yearOfStudy} enrollment for ${enr.studentName}?')">
                                                    <i class="fas fa-check"></i> Approve
                                                </button>
                                            </form>
                                            <button class="btn btn-danger btn-xs"
                                                    onclick="showRejectModal(${enr.id}, '${enr.studentName}', ${enr.yearOfStudy})">
                                                <i class="fas fa-times"></i> Reject
                                            </button>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=view&id=${enr.id}"
                                           class="btn btn-light btn-xs">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="13">
                                <div class="empty-state">
                                    <i class="fas fa-calendar-times"></i>
                                    <h3>No Enrollment Requests</h3>
                                    <p>Student re-enrollment requests will appear here.</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Reject Modal -->
<div class="modal-overlay" id="rejectModal">
    <div class="modal-box" style="max-width:500px">
        <div class="modal-header">
            <h4><i class="fas fa-times-circle" style="color:#dc2626"></i> Reject Enrollment</h4>
            <button class="modal-close" onclick="closeModal('rejectModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="id"     id="rejectId">
            <input type="hidden" name="status" value="REJECTED">
            <div class="modal-body">
                <div id="rejectInfo" style="background:#fef2f2;border-radius:8px;padding:12px;margin-bottom:16px;font-size:13px;color:#dc2626;font-weight:600"></div>
                <label class="form-label">Reason for Rejection <span style="color:#dc2626">*</span></label>
                <select name="remarks" class="form-select" required style="margin-bottom:10px">
                    <option value="">-- Select reason --</option>
                    <option value="Backlogs not cleared. Please clear all backlogs before re-enrolling.">Backlogs not cleared</option>
                    <option value="Attendance shortage. Minimum 75% attendance required.">Attendance shortage (below 75%)</option>
                    <option value="Previous year fee not paid. Please clear dues before enrolling.">Previous year fee not paid</option>
                    <option value="Documents incomplete. Please submit all required documents.">Incomplete documents</option>
                    <option value="SGPA too low. Minimum 5.0 SGPA required for promotion.">Low SGPA</option>
                    <option value="Other reason. Please contact the admission office.">Other</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('rejectModal')">Cancel</button>
                <button type="submit" class="btn btn-danger"><i class="fas fa-times"></i> Confirm Reject</button>
            </div>
        </form>
    </div>
</div>

<script>
function showRejectModal(id, name, year) {
    document.getElementById('rejectId').value = id;
    document.getElementById('rejectInfo').textContent =
        'Student: ' + name + ' | Year: ' + year;
    openModal('rejectModal');
}
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>