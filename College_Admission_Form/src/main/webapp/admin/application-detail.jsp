<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Application Detail"); request.setAttribute("currentPage","applications"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span>
    <a href="${pageContext.request.contextPath}/ApplicationServlet?action=list">Applications</a>
    <span class="sep">/</span><span class="current">${application.applicationNo}</span>
</div>

<c:if test="${not empty successMsg}">
    <div class="alert alert-success" data-auto-dismiss><i class="fas fa-check-circle"></i><div>${successMsg}</div></div>
</c:if>

<div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-3">
    <div>
        <h2 style="font-size:22px;font-weight:700;color:#1c2a3a">${application.fullName}</h2>
        <div class="d-flex align-items-center gap-2 mt-1">
            <span class="text-muted fs-13">${application.applicationNo}</span>
            <span class="badge badge-${application.status.toLowerCase()}">${application.status}</span>
        </div>
    </div>
    <div class="d-flex gap-2 flex-wrap">
        <c:if test="${application.status=='PENDING'||application.status=='UNDER_REVIEW'}">
            <button class="btn btn-warning" data-modal="reviewModal"><i class="fas fa-search"></i> Review</button>
            <button class="btn btn-success" onclick="submitStatus('APPROVED')"><i class="fas fa-check"></i> Approve</button>
            <button class="btn btn-danger"  onclick="submitStatus('REJECTED')"><i class="fas fa-times"></i> Reject</button>
        </c:if>
        <a href="${pageContext.request.contextPath}/ApplicationServlet?action=list" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-user"></i> Personal Information</h5></div>
            <div class="card-body">
                <div class="detail-grid">
                    <div class="detail-item"><div class="detail-label">Full Name</div><div class="detail-value">${application.fullName}</div></div>
                    <div class="detail-item"><div class="detail-label">Date of Birth</div><div class="detail-value"><fmt:formatDate value="${application.dob}" pattern="dd MMMM yyyy"/></div></div>
                    <div class="detail-item"><div class="detail-label">Gender</div><div class="detail-value">${application.gender}</div></div>
                    <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value">${application.studentEmail}</div></div>
                    <div class="detail-item"><div class="detail-label">Address</div><div class="detail-value">${application.address}</div></div>
                    <div class="detail-item"><div class="detail-label">City / State</div><div class="detail-value">${application.city}, ${application.state} - ${application.pincode}</div></div>
                    <div class="detail-item"><div class="detail-label">Parent Name</div><div class="detail-value">${application.parentName}</div></div>
                    <div class="detail-item"><div class="detail-label">Parent Phone</div><div class="detail-value">${application.parentPhone}</div></div>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-graduation-cap"></i> Academic Details</h5></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-center p-3" style="background:#f8fafc;border-radius:10px">
                            <div style="font-size:32px;font-weight:700;color:#1a3c6e">${application.tenthMarks}%</div>
                            <div class="text-muted fs-13 mt-1">10th Standard</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3" style="background:#f8fafc;border-radius:10px">
                            <div style="font-size:32px;font-weight:700;color:#1a3c6e">${application.twelfthMarks}%</div>
                            <div class="text-muted fs-13 mt-1">12th Standard</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3" style="background:#f8fafc;border-radius:10px">
                            <div style="font-size:32px;font-weight:700;color:#1a3c6e">${application.entranceScore}</div>
                            <div class="text-muted fs-13 mt-1">Entrance Score</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-folder-open"></i> Documents</h5></div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead><tr><th>Type</th><th>File</th><th>Size</th><th>Verified</th><th>Action</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty documents}">
                                <c:forEach var="doc" items="${documents}">
                                    <tr>
                                        <td>${doc.docType.replace('_',' ')}</td>
                                        <td>${doc.originalName}</td>
                                        <td class="text-muted fs-13">${doc.fileSizeFormatted}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${doc.verified}"><span class="badge badge-approved"><i class="fas fa-check"></i> Verified</span></c:when>
                                                <c:otherwise><span class="badge badge-pending">Pending</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/DocumentServlet?action=download&id=${doc.id}" class="btn btn-light btn-xs"><i class="fas fa-download"></i></a>
                                            <c:if test="${not doc.verified}">
                                                <a href="${pageContext.request.contextPath}/DocumentServlet?action=verify&id=${doc.id}&appId=${application.id}" class="btn btn-success btn-xs"><i class="fas fa-check"></i></a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="5" class="text-center text-muted py-3">No documents uploaded</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="card-title"><i class="fas fa-money-bill-wave"></i> Fee Payments</h5>
                <a href="${pageContext.request.contextPath}/FeeServlet?action=list" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Add Payment</a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead><tr><th>Transaction ID</th><th>Type</th><th>Mode</th><th>Amount</th><th>Date</th><th>Status</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty payments}">
                                <c:forEach var="pay" items="${payments}">
                                    <tr>
                                        <td class="fw-600 text-primary">${pay.transactionId}</td>
                                        <td class="fs-13">${pay.paymentType.replace('_',' ')}</td>
                                        <td class="fs-13">${pay.paymentMode}</td>
                                        <td class="fw-600">&#8377; <fmt:formatNumber value="${pay.amount}" pattern="#,##,##0.00"/></td>
                                        <td class="text-muted fs-13"><fmt:formatDate value="${pay.paymentDate}" pattern="dd MMM yyyy"/></td>
                                        <td><span class="badge badge-${pay.paymentStatus.toLowerCase()}">${pay.paymentStatus}</span></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="6" class="text-center text-muted py-3">No payments recorded</td></tr></c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-book-open"></i> Applied Program</h5></div>
            <div class="card-body">
                <div class="mb-3"><div class="detail-label">Program</div><div class="detail-value fw-600">${application.programName}</div></div>
                <div class="mb-3"><div class="detail-label">Submitted On</div><div class="detail-value"><fmt:formatDate value="${application.submittedAt}" pattern="dd MMM yyyy, HH:mm"/></div></div>
                <c:if test="${not empty application.adminRemarks}">
                    <div><div class="detail-label">Admin Remarks</div>
                    <div style="background:#f8fafc;padding:10px;border-radius:8px;font-size:13px">${application.adminRemarks}</div></div>
                </c:if>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-bolt"></i> Quick Actions</h5></div>
            <div class="card-body d-flex flex-column gap-2">
                <c:if test="${application.status=='PENDING'}">
                    <button class="btn btn-outline w-100" onclick="submitStatus('UNDER_REVIEW')"><i class="fas fa-search me-2"></i>Mark Under Review</button>
                </c:if>
                <button class="btn btn-light w-100" onclick="window.print()"><i class="fas fa-print me-2"></i>Print Application</button>
            </div>
        </div>

        <div class="card">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-history"></i> Timeline</h5></div>
            <div class="card-body">
                <div class="timeline">
                    <div class="timeline-item">
                        <div class="tl-time"><fmt:formatDate value="${application.submittedAt}" pattern="dd MMM yyyy"/></div>
                        <div class="tl-title">Application Submitted</div>
                    </div>
                    <c:if test="${application.reviewedAt != null}">
                        <div class="timeline-item">
                            <div class="tl-time"><fmt:formatDate value="${application.reviewedAt}" pattern="dd MMM yyyy"/></div>
                            <div class="tl-title">Status: ${application.status}</div>
                            <div class="tl-desc">${application.adminRemarks}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Review Modal -->
<div class="modal-overlay" id="reviewModal">
    <div class="modal-box">
        <div class="modal-header">
            <h4>Update Application Status</h4>
            <button class="modal-close" onclick="closeModal('reviewModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/ApplicationServlet">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="id" value="${application.id}">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">New Status</label>
                    <select name="status" class="form-select">
                        <option value="PENDING">Pending</option>
                        <option value="UNDER_REVIEW" selected>Under Review</option>
                        <option value="APPROVED">Approved</option>
                        <option value="REJECTED">Rejected</option>
                        <option value="WAITLISTED">Waitlisted</option>
                    </select>
                </div>
                <div class="form-group mb-0">
                    <label class="form-label">Remarks</label>
                    <textarea name="remarks" class="form-control" rows="3" placeholder="Add remarks...">${application.adminRemarks}</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" onclick="closeModal('reviewModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update</button>
            </div>
        </form>
    </div>
</div>

<form id="statusForm" method="post" action="${pageContext.request.contextPath}/ApplicationServlet">
    <input type="hidden" name="action" value="updateStatus">
    <input type="hidden" name="id" value="${application.id}">
    <input type="hidden" name="status" id="statusInput">
    <input type="hidden" name="remarks" value="Status updated by admin.">
</form>
<script>
function submitStatus(s){
    if(confirm('Change status to '+s+'?')){
        document.getElementById('statusInput').value=s;
        document.getElementById('statusForm').submit();
    }
}
</script>
<%@ include file="/WEB-INF/includes/footer.jsp" %>