<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","Year Re-Enrollment Form");
    request.setAttribute("currentPage","enrollments");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i> Home</a>
    <span class="sep">/</span>
    <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=myEnrollments">My Enrollments</a>
    <span class="sep">/</span>
    <span class="current">Year ${nextYear} Enrollment Form</span>
</div>

<!-- Banner -->
<div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);border-radius:16px;padding:24px 28px;margin-bottom:24px;color:#fff">
    <div style="display:inline-flex;align-items:center;gap:6px;background:rgba(245,158,11,0.2);border:1px solid rgba(245,158,11,0.4);color:#f59e0b;font-size:12px;padding:4px 12px;border-radius:20px;margin-bottom:10px;font-weight:600">
        <i class="fas fa-calendar-check"></i> Year ${nextYear} Annual Re-Enrollment
    </div>
    <h2 style="font-size:20px;font-weight:700;margin-bottom:6px">
        ${program.name}
    </h2>
    <p style="color:#93c5fd;font-size:13px;margin:0">
        ${program.departmentName} &nbsp;|&nbsp;
        ${application.applicationNo} &nbsp;|&nbsp;
        Category: ${application.category}
    </p>
</div>

<form method="post" action="${pageContext.request.contextPath}/EnrollmentServlet" id="enrollForm">
    <input type="hidden" name="action"        value="submitEnroll">
    <input type="hidden" name="applicationId" value="${application.id}">
    <input type="hidden" name="yearOfStudy"   value="${nextYear}">
    <input type="hidden" name="academicYear"  value="${academicYear}">
    <input type="hidden" name="prevEnrollId"  value="${prevEnroll != null ? prevEnroll.id : ''}">

    <!-- STEP A: Previous Year Performance (only if year > 1) -->
    <c:if test="${nextYear > 1}">
    <div class="card">
        <div style="background:linear-gradient(135deg,#fefce8,#fef9c3);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
            <div style="width:34px;height:34px;background:#d97706;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px">
                <i class="fas fa-chart-bar"></i>
            </div>
            <div>
                <div style="font-size:14px;font-weight:700;color:#1e293b">Year ${nextYear - 1} Academic Performance</div>
                <div style="font-size:12px;color:#64748b">Enter your Year ${nextYear - 1} result to proceed with enrollment</div>
            </div>
        </div>
        <div class="card-body">
            <c:if test="${prevEnroll != null && prevEnroll.sgpa != null}">
                <div class="alert alert-success" style="margin-bottom:16px">
                    <i class="fas fa-check-circle"></i>
                    <div>Year ${nextYear - 1} performance already recorded — SGPA: ${prevEnroll.sgpa}, CGPA: ${prevEnroll.cgpa}</div>
                </div>
            </c:if>
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">SGPA <span style="color:#dc2626">*</span></label>
                    <input type="number" name="sgpa" class="form-control" required
                           min="0" max="10" step="0.01"
                           placeholder="e.g. 7.85"
                           value="${prevEnroll != null && prevEnroll.sgpa != null ? prevEnroll.sgpa : ''}">
                    <div style="font-size:11px;color:#64748b;margin-top:3px">Semester Grade Point (0-10)</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label">CGPA <span style="color:#dc2626">*</span></label>
                    <input type="number" name="cgpa" class="form-control" required
                           min="0" max="10" step="0.01"
                           placeholder="e.g. 7.50"
                           value="${prevEnroll != null && prevEnroll.cgpa != null ? prevEnroll.cgpa : ''}">
                    <div style="font-size:11px;color:#64748b;margin-top:3px">Cumulative GPA (0-10)</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Backlogs</label>
                    <input type="number" name="backlogs" class="form-control"
                           min="0" max="20" value="0"
                           value="${prevEnroll != null ? prevEnroll.backlogs : '0'}">
                    <div style="font-size:11px;color:#dc2626;margin-top:3px">Failed subjects (0 = none)</div>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Attendance % <span style="color:#dc2626">*</span></label>
                    <input type="number" name="attendance" class="form-control" required
                           min="0" max="100" step="0.01" placeholder="e.g. 85.00"
                           value="${prevEnroll != null && prevEnroll.attendancePercent != null ? prevEnroll.attendancePercent : ''}">
                    <div style="font-size:11px;color:#64748b;margin-top:3px">Min 75% required</div>
                </div>
            </div>

            <!-- Warning if backlogs or low attendance -->
            <div id="backlogWarning" style="display:none;margin-top:12px" class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <div>You have backlogs. Enrollment is allowed but admin may review your case carefully.</div>
            </div>
            <div id="attendanceWarning" style="display:none;margin-top:8px" class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <div>Attendance below 75%. This may result in enrollment rejection.</div>
            </div>
        </div>
    </div>
    </c:if>

    <!-- STEP B: Enrollment & Fee Info -->
    <div class="card">
        <div style="background:linear-gradient(135deg,#eff6ff,#dbeafe);padding:14px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;gap:10px">
            <div style="width:34px;height:34px;background:#2563eb;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <div style="font-size:14px;font-weight:700;color:#1e293b">Year ${nextYear} Enrollment Details</div>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Year of Study</label>
                    <input type="text" class="form-control"
                           value="Year ${nextYear} of ${program.durationYears}"
                           readonly style="background:#f8fafc;font-weight:700">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Academic Year</label>
                    <input type="text" class="form-control"
                           value="${academicYear}"
                           readonly style="background:#f8fafc;font-weight:700">
                </div>
            </div>
        </div>
    </div>

    <!-- STEP C: Fee Summary -->
    <div class="card">
        <div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);padding:14px 22px;border-bottom:1px solid rgba(255,255,255,0.1)">
            <div style="font-size:14px;font-weight:700;color:#fff">💰 Fee Summary — Year ${nextYear}</div>
            <div style="font-size:11px;color:#93c5fd">Category: ${application.category}</div>
        </div>
        <div class="card-body">
            <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:14px">
                <div style="background:#f8fafc;border-radius:12px;padding:16px;text-align:center">
                    <div style="font-size:11px;color:#64748b;font-weight:600;margin-bottom:6px">YEAR ${nextYear} BASE FEE</div>
                    <div style="font-size:22px;font-weight:800;color:#64748b">
                        ₹<fmt:formatNumber value="${program.feeGeneral}" pattern="#,##,##0"/>
                    </div>
                </div>
                <div style="background:linear-gradient(135deg,#eff6ff,#dbeafe);border-radius:12px;padding:16px;text-align:center;border:2px solid #2563eb">
                    <div style="font-size:11px;color:#2563eb;font-weight:700;margin-bottom:6px">YOUR FEE (${application.category})</div>
                    <div style="font-size:30px;font-weight:800;color:#1a4b8c">
                        ₹<fmt:formatNumber value="${feeForYear}" pattern="#,##,##0"/>
                    </div>
                    <div style="font-size:11px;color:#64748b;margin-top:4px">Per Year</div>
                </div>
                <div style="background:#f0fdf4;border-radius:12px;padding:16px;text-align:center">
                    <div style="font-size:11px;color:#059669;font-weight:600;margin-bottom:6px">PAYMENT DUE</div>
                    <div style="font-size:16px;font-weight:700;color:#059669">After Approval</div>
                    <div style="font-size:11px;color:#64748b;margin-top:4px">Pay from Fee Payments section</div>
                </div>
            </div>

            <div class="alert alert-info" style="margin-top:16px;margin-bottom:0">
                <i class="fas fa-info-circle"></i>
                <div>Fee payment is required <strong>after enrollment is approved</strong>. You will receive a notification.</div>
            </div>
        </div>
    </div>

    <!-- Declaration -->
    <div class="card">
        <div class="card-body">
            <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer">
                <input type="checkbox" id="declCheck" required
                       style="width:18px;height:18px;margin-top:2px;accent-color:#2563eb;flex-shrink:0">
                <span style="font-size:13px;color:#374151;line-height:1.7">
                    I declare that I wish to continue my B.Tech/M.Tech studies in Year ${nextYear}.
                    The academic details I have entered are true and correct.
                    I understand that re-enrollment is subject to admin approval and timely fee payment.
                    I agree to follow all college rules and regulations for the academic year ${academicYear}.
                </span>
            </label>
        </div>
    </div>

    <!-- Buttons -->
    <div style="display:flex;justify-content:space-between;align-items:center;margin-top:4px">
        <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=myEnrollments"
           class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Back
        </a>
        <button type="submit" id="submitBtn"
                style="background:linear-gradient(135deg,#1a4b8c,#2563eb);color:#fff;border:none;padding:13px 32px;border-radius:10px;font-size:15px;font-weight:700;cursor:pointer;display:inline-flex;align-items:center;gap:10px;box-shadow:0 4px 16px rgba(37,99,235,0.35)">
            <i class="fas fa-calendar-check"></i> Submit Year ${nextYear} Enrollment
        </button>
    </div>
</form>

<script>
// Show warnings based on input
var backInput = document.querySelector('[name="backlogs"]');
var attInput  = document.querySelector('[name="attendance"]');

if (backInput) {
    backInput.addEventListener('input', function() {
        document.getElementById('backlogWarning').style.display =
            parseInt(this.value) > 0 ? 'flex' : 'none';
    });
}
if (attInput) {
    attInput.addEventListener('input', function() {
        document.getElementById('attendanceWarning').style.display =
            parseFloat(this.value) < 75 && this.value !== '' ? 'flex' : 'none';
    });
}

// Prevent double submit
document.getElementById('enrollForm').addEventListener('submit', function() {
    var btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
});
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>