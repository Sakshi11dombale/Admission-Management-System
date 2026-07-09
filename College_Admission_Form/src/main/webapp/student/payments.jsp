<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","Fee Payments");
    request.setAttribute("currentPage","payments");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i> Home</a>
    <span class="sep">/</span><span class="current">Fee Payments</span>
</div>

<c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success" data-auto-dismiss><i class="fas fa-check-circle"></i> ${sessionScope.flashSuccess}</div>
    <c:remove var="flashSuccess" scope="session"/>
</c:if>

<!-- Page Header -->
<div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);border-radius:16px;padding:24px 28px;margin-bottom:24px;color:#fff;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px">
    <div>
        <h2 style="font-size:20px;font-weight:700;margin-bottom:4px"><i class="fas fa-receipt" style="color:#f59e0b;margin-right:8px"></i>Engineering College Fee Payment</h2>
        <p style="color:#93c5fd;font-size:13px;margin:0">Year-wise tuition fee payment | Category-based concessions applied</p>
    </div>
    <button onclick="openModal('payModal')" style="background:linear-gradient(135deg,#f59e0b,#f97316);color:#fff;border:none;padding:12px 22px;border-radius:10px;font-size:13px;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:8px;box-shadow:0 4px 14px rgba(245,158,11,0.4)">
        <i class="fas fa-credit-card"></i> Pay Fee Now
    </button>
</div>

<!-- Stats -->
<div class="stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:24px">
    <div class="stat-card green">
        <div class="stat-icon"><i class="fas fa-rupee-sign"></i></div>
        <div class="stat-value">₹<fmt:formatNumber value="${totalPaid != null ? totalPaid : 0}" pattern="#,##,##0"/></div>
        <div class="stat-label">Total Paid</div>
    </div>
    <div class="stat-card blue">
        <div class="stat-icon"><i class="fas fa-receipt"></i></div>
        <div class="stat-value">${not empty myPayments ? myPayments.size() : 0}</div>
        <div class="stat-label">Transactions</div>
    </div>
    <div class="stat-card amber">
        <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
        <div class="stat-value">${currentYear != null ? currentYear : 1}</div>
        <div class="stat-label">Current Year of Study</div>
    </div>
</div>

<!-- Year-wise Payment Status -->
<c:if test="${not empty myApplications}">
<div class="card">
    <div class="card-header"><h5 class="card-title"><i class="fas fa-calendar-alt"></i> Year-wise Fee Status</h5></div>
    <div class="card-body">
        <c:forEach var="app" items="${myApplications}">
            <c:if test="${app.status == 'APPROVED'}">
            <div style="margin-bottom:20px">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
                    <div>
                        <div style="font-size:14px;font-weight:700;color:#1e293b">${app.programName}</div>
                        <div style="font-size:12px;color:#64748b">${app.applicationNo} · ${app.category}</div>
                    </div>
                    <span class="badge badge-approved">Admitted</span>
                </div>
                <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:10px">
                    <c:forEach begin="1" end="4" var="yr">
                        <div style="border:1px solid #e2e8f0;border-radius:10px;padding:14px;text-align:center">
                            <div style="font-size:12px;font-weight:700;color:#1e293b;margin-bottom:4px">Year ${yr}</div>
                            <div style="font-size:11px;color:#64748b;margin-bottom:8px">2024-${24+yr}</div>
                            <div style="font-size:15px;font-weight:700;color:#1a4b8c;margin-bottom:8px">₹<fmt:formatNumber value="${app.applicableFeePerYear != null ? app.applicableFeePerYear : 0}" pattern="#,##,##0"/></div>
                            <span style="background:#fffbeb;color:#d97706;padding:3px 8px;border-radius:10px;font-size:10px;font-weight:700">PENDING</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>
        </c:forEach>
    </div>
</div>
</c:if>

<!-- Payment History -->
<div class="card">
    <div class="card-header"><h5 class="card-title"><i class="fas fa-history"></i> Payment History</h5></div>
    <div class="table-wrap">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Application</th>
                    <th>Department / Program</th>
                    <th>Year</th>
                    <th>Semester</th>
                    <th>Type</th>
                    <th>Mode</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty myPayments}">
                        <c:forEach var="p" items="${myPayments}">
                            <tr>
                                <td class="app-no" style="font-size:11px">${p.transactionId}</td>
                                <td style="font-size:11px;color:#64748b">${p.applicationNo}</td>
                                <td style="font-size:12px">${p.programName}</td>
                                <td style="text-align:center">
                                    <span style="background:#eff6ff;color:#2563eb;padding:3px 8px;border-radius:10px;font-size:11px;font-weight:700">Yr ${p.yearOfStudy}</span>
                                </td>
                                <td style="text-align:center;font-size:12px">Sem ${p.semester}</td>
                                <td style="font-size:12px">${p.paymentType.replace('_',' ')}</td>
                                <td style="font-size:12px">${p.paymentMode}</td>
                                <td style="font-weight:700;color:#1a4b8c">₹<fmt:formatNumber value="${p.amount}" pattern="#,##,##0"/></td>
                                <td style="font-size:12px;color:#64748b"><fmt:formatDate value="${p.paymentDate}" pattern="dd MMM yyyy"/></td>
                                <td><span class="badge badge-approved"><i class="fas fa-check"></i> ${p.paymentStatus}</span></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="10">
                            <div class="empty-state">
                                <i class="fas fa-receipt"></i>
                                <h3>No Payments Yet</h3>
                                <p>Make your first fee payment using "Pay Fee Now" button.</p>
                            </div>
                        </td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Payment Modal -->
<div class="modal-overlay" id="payModal">
    <div class="modal-box" style="max-width:600px">
        <div class="modal-header">
            <h4><i class="fas fa-credit-card"></i> Engineering Fee Payment</h4>
            <button class="modal-close" onclick="closeModal('payModal')">&times;</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/StudentPaymentServlet">
            <div class="modal-body">
                <div class="alert alert-info"><i class="fas fa-info-circle"></i><div>Fee amount is auto-calculated based on your category. Verify the amount before paying.</div></div>
                <div class="form-group">
                    <label class="form-label">Select Admitted Application <span class="req">*</span></label>
                    <select name="applicationId" class="form-select" required>
                        <option value="">-- Select application --</option>
                        <c:forEach var="app" items="${myApplications}">
                            <option value="${app.id}" data-fee="${app.applicableFeePerYear != null ? app.applicableFeePerYear : 0}">
                                ${app.applicationNo} — ${app.programName} (${app.category})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Year of Study <span class="req">*</span></label>
                        <select name="yearOfStudy" class="form-select" required>
                            <option value="1">1st Year (2024-25)</option>
                            <option value="2">2nd Year (2025-26)</option>
                            <option value="3">3rd Year (2026-27)</option>
                            <option value="4">4th Year (2027-28)</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Semester <span class="req">*</span></label>
                        <select name="semester" class="form-select" required>
                            <option value="1">Semester 1 (Odd)</option>
                            <option value="2">Semester 2 (Even)</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Academic Year</label>
                        <select name="academicYear" class="form-select">
                            <option value="2024-25">2024-25</option>
                            <option value="2025-26">2025-26</option>
                            <option value="2026-27">2026-27</option>
                            <option value="2027-28">2027-28</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Payment Type <span class="req">*</span></label>
                        <select name="paymentType" class="form-select" required>
                            <option value="TUITION_FEE">Tuition Fee</option>
                            <option value="EXAM_FEE">Examination Fee</option>
                            <option value="HOSTEL_FEE">Hostel Fee</option>
                            <option value="LAB_FEE">Laboratory Fee</option>
                            <option value="LIBRARY_FEE">Library Fee</option>
                            <option value="OTHER">Other / Miscellaneous</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Payment Mode <span class="req">*</span></label>
                        <select name="paymentMode" class="form-select" required>
                            <option value="ONLINE">Online (UPI/Card/Net Banking)</option>
                            <option value="NEFT">NEFT / RTGS</option>
                            <option value="DD">Demand Draft</option>
                            <option value="CASH">Cash at College Counter</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Amount (₹) <span class="req">*</span></label>
                        <input type="number" name="amount" id="payAmount" class="form-control" required min="1" step="1" placeholder="Enter amount">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Bank Reference / UTR Number</label>
                        <input type="text" name="bankReference" class="form-control" placeholder="Bank reference number (for NEFT/DD)">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('payModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-check-circle"></i> Confirm Payment</button>
            </div>
        </form>
    </div>
</div>

<script>
document.querySelector('select[name="applicationId"]').addEventListener('change', function() {
    var opt = this.options[this.selectedIndex];
    var fee = opt.getAttribute('data-fee');
    if (fee) document.getElementById('payAmount').value = Math.round(parseFloat(fee) / 2);
});
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>