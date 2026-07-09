<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Fee Payments"); request.setAttribute("currentPage","fees"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">Fee Payments</span>
</div>

<div class="stats-row mb-4">
    <div class="stat-card">
        <div class="stat-icon green"><i class="fas fa-rupee-sign"></i></div>
        <div class="stat-info"><div class="stat-value">&#8377;<fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,##,##0"/></div><div class="stat-label">Total Revenue</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon blue"><i class="fas fa-receipt"></i></div>
        <div class="stat-info"><div class="stat-value">${totalPayments != null ? totalPayments : 0}</div><div class="stat-label">Transactions</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon orange"><i class="fas fa-hourglass-half"></i></div>
        <div class="stat-info"><div class="stat-value">${pendingPayments != null ? pendingPayments : 0}</div><div class="stat-label">Pending</div></div>
    </div>
</div>

<div class="section-header">
    <h2><i class="fas fa-money-bill-wave me-2 text-primary"></i>Fee Payments</h2>
    <button class="btn btn-primary" data-modal="addFeeModal"><i class="fas fa-plus"></i> Record Payment</button>
</div>

<div class="card mb-4">
    <div class="card-body py-3">
        <form method="get" action="${pageContext.request.contextPath}/FeeServlet" class="d-flex flex-wrap gap-3 align-items-end">
            <input type="hidden" name="action" value="list">
            <div>
                <label class="form-label mb-1">Status</label>
                <select name="status" class="form-select">
                    <option value="">All</option>
                    <option value="PENDING"   ${param.status=='PENDING'  ?'selected':''}>Pending</option>
                    <option value="COMPLETED" ${param.status=='COMPLETED'?'selected':''}>Completed</option>
                    <option value="FAILED"    ${param.status=='FAILED'   ?'selected':''}>Failed</option>
                </select>
            </div>
            <div>
                <label class="form-label mb-1">Search</label>
                <div class="search-bar">
                    <input type="text" name="search" placeholder="Transaction / Name" value="${param.search}">
                    <button type="submit"><i class="fas fa-search"></i></button>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/FeeServlet?action=list" class="btn btn-light"><i class="fas fa-times"></i> Clear</a>
        </form>
    </div>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="data-table">
            <thead><tr><th>#</th><th>Transaction ID</th><th>Student</th><th>Type</th><th>Mode</th><th>Amount</th><th>Date</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty payments}">
                        <c:forEach var="pay" items="${payments}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td class="fw-600 text-primary">${pay.transactionId}</td>
                                <td class="fs-13">${pay.applicantName}</td>
                                <td class="fs-13">${pay.paymentType.replace('_',' ')}</td>
                                <td><span style="background:#f1f5f9;padding:3px 8px;border-radius:6px;font-size:12px">${pay.paymentMode}</span></td>
                                <td class="fw-600">&#8377; <fmt:formatNumber value="${pay.amount}" pattern="#,##,##0.00"/></td>
                                <td class="text-muted fs-13"><fmt:formatDate value="${pay.paymentDate}" pattern="dd MMM yyyy"/></td>
                                <td><span class="badge badge-${pay.paymentStatus.toLowerCase()}">${pay.paymentStatus}</span></td>
                                <td>
                                    <c:if test="${pay.paymentStatus=='PENDING'}">
                                        <form method="post" action="${pageContext.request.contextPath}/FeeServlet" style="display:inline">
                                            <input type="hidden" name="action" value="confirm">
                                            <input type="hidden" name="id" value="${pay.id}">
                                            <button type="submit" class="btn btn-success btn-xs" data-confirm="Confirm this payment?"><i class="fas fa-check"></i></button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><tr><td colspan="9"><div class="empty-state"><i class="fas fa-receipt"></i><h4>No Payments Found</h4></div></td></tr></c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<div class="modal-overlay" id="addFeeModal">
    <div class="modal-box">
        <div class="modal-header"><h4>Record Fee Payment</h4><button class="modal-close" onclick="closeModal('addFeeModal')">&times;</button></div>
        <form method="post" action="${pageContext.request.contextPath}/FeeServlet">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group"><label class="form-label">Application No. *</label><input type="text" name="applicationNo" class="form-control" required placeholder="APP..."></div>
                <div class="row g-3">
                    <div class="col-md-6"><label class="form-label">Payment Type *</label>
                        <select name="paymentType" class="form-select" required>
                            <option value="APPLICATION_FEE">Application Fee</option>
                            <option value="REGISTRATION_FEE">Registration Fee</option>
                            <option value="SEMESTER_FEE">Semester Fee</option>
                        </select>
                    </div>
                    <div class="col-md-6"><label class="form-label">Payment Mode *</label>
                        <select name="paymentMode" class="form-select" required>
                            <option value="ONLINE">Online</option>
                            <option value="DD">Demand Draft</option>
                            <option value="CASH">Cash</option>
                        </select>
                    </div>
                    <div class="col-md-6"><label class="form-label">Amount (&#8377;) *</label><input type="number" name="amount" class="form-control" required step="0.01"></div>
                    <div class="col-md-6"><label class="form-label">Status</label>
                        <select name="paymentStatus" class="form-select">
                            <option value="COMPLETED">Completed</option>
                            <option value="PENDING">Pending</option>
                        </select>
                    </div>
                    <div class="col-12"><label class="form-label">Remarks</label><input type="text" name="remarks" class="form-control"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" onclick="closeModal('addFeeModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Record</button>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>