<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Dashboard"); request.setAttribute("currentPage","dashboard"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <i class="fas fa-home"></i><span class="sep">/</span><span class="current">Dashboard</span>
</div>

<div class="stats-row">
    <div class="stat-card">
        <div class="stat-icon blue"><i class="fas fa-users"></i></div>
        <div class="stat-info"><div class="stat-value">${totalStudents}</div><div class="stat-label">Total Students</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon orange"><i class="fas fa-file-alt"></i></div>
        <div class="stat-info"><div class="stat-value">${totalApps}</div><div class="stat-label">Total Applications</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon teal"><i class="fas fa-hourglass-half"></i></div>
        <div class="stat-info"><div class="stat-value">${pendingApps}</div><div class="stat-label">Pending Review</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
        <div class="stat-info"><div class="stat-value">${approvedApps}</div><div class="stat-label">Approved</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon red"><i class="fas fa-times-circle"></i></div>
        <div class="stat-info"><div class="stat-value">${rejectedApps}</div><div class="stat-label">Rejected</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon purple"><i class="fas fa-book-open"></i></div>
        <div class="stat-info"><div class="stat-value">${totalPrograms}</div><div class="stat-label">Programs</div></div>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title"><i class="fas fa-clock"></i> Recent Applications</h5>
                <a href="${pageContext.request.contextPath}/ApplicationServlet?action=list" class="btn btn-outline btn-sm">View All</a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr><th>App No.</th><th>Student</th><th>Program</th><th>Date</th><th>Status</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentApplications}">
                                <c:forEach var="app" items="${recentApplications}">
                                    <tr>
                                        <td><span class="fw-600 text-primary">${app.applicationNo}</span></td>
                                        <td>
                                            <div class="fw-600 fs-13">${app.fullName}</div>
                                            <div class="text-muted" style="font-size:11px">${app.studentEmail}</div>
                                        </td>
                                        <td class="fs-13">${app.programName}</td>
                                        <td class="text-muted fs-13"><fmt:formatDate value="${app.submittedAt}" pattern="dd MMM yyyy"/></td>
                                        <td><span class="badge badge-${app.status.toLowerCase()}">${app.status}</span></td>
                                        <td><a href="${pageContext.request.contextPath}/ApplicationServlet?action=view&id=${app.id}" class="btn btn-light btn-xs"><i class="fas fa-eye"></i></a></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="6"><div class="empty-state py-4"><i class="fas fa-folder-open"></i><h4>No applications yet</h4></div></td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card mb-4">
            <div class="card-header"><h5 class="card-title"><i class="fas fa-chart-pie"></i> Status Chart</h5></div>
            <div class="card-body text-center">
                <canvas id="statusChart" height="200"></canvas>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="card-title"><i class="fas fa-chair"></i> Seat Availability</h5>
            </div>
            <div class="card-body">
                <c:forEach var="prog" items="${programs}">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="fs-13 fw-600">${prog.name}</span>
                            <span class="text-muted fs-13">${prog.availableSeats}/${prog.totalSeats}</span>
                        </div>
                        <div class="seat-progress progress-bar-wrap" data-pct="${prog.occupancyPercent}">
                            <div class="progress-bar-fill"></div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
var ctx = document.getElementById('statusChart');
if (ctx) {
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Pending','Approved','Rejected','Under Review','Waitlisted'],
            datasets: [{
                data: [${pendingApps},${approvedApps},${rejectedApps},${underReviewApps != null ? underReviewApps : 0},${waitlistedApps != null ? waitlistedApps : 0}],
                backgroundColor: ['#fbbf24','#22c55e','#ef4444','#38bdf8','#a78bfa'],
                borderWidth: 0
            }]
        },
        options: { cutout:'65%', plugins:{ legend:{ display:false } } }
    });
}
</script>
<%@ include file="/WEB-INF/includes/footer.jsp" %>