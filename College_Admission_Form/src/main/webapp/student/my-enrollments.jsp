<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    request.setAttribute("pageTitle","My Enrollments");
    request.setAttribute("currentPage","enrollments");
%>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i> Home</a>
    <span class="sep">/</span>
    <span class="current">My Enrollments</span>
</div>

<%-- Flash messages --%>
<c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success" data-auto-dismiss><i class="fas fa-check-circle"></i> ${sessionScope.flashSuccess}</div>
    <c:remove var="flashSuccess" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.flashError}">
    <div class="alert alert-danger" data-auto-dismiss><i class="fas fa-exclamation-circle"></i> ${sessionScope.flashError}</div>
    <c:remove var="flashError" scope="session"/>
</c:if>
<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
</c:if>

<!-- Header Banner -->
<div style="background:linear-gradient(135deg,#0a1628,#1a4b8c);border-radius:16px;padding:24px 28px;margin-bottom:24px;color:#fff">
    <h2 style="font-size:20px;font-weight:700;margin-bottom:6px">
        <i class="fas fa-calendar-check" style="color:#f59e0b;margin-right:8px"></i>
        Year-wise Enrollment
    </h2>
    <p style="color:#93c5fd;font-size:13px;margin:0">
        Engineering students must enroll every year. Each year requires admin approval and fee payment.
    </p>
</div>

<!-- Loop through each APPROVED application -->
<c:set var="hasApproved" value="false"/>
<c:forEach var="app" items="${myApplications}">
    <c:if test="${app.status == 'APPROVED'}">
        <c:set var="hasApproved" value="true"/>

        <div class="card" style="margin-bottom:24px">
            <!-- Card Header -->
            <div style="background:linear-gradient(135deg,#f8fafc,#eff6ff);padding:18px 22px;border-bottom:1px solid #e2e8f0;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px">
                <div>
                    <div style="font-size:16px;font-weight:700;color:#1e293b">${app.programName}</div>
                    <div style="font-size:12px;color:#64748b;margin-top:4px">
                        <span style="background:#eff6ff;color:#2563eb;padding:2px 8px;border-radius:6px;font-weight:600">${app.applicationNo}</span>
                        &nbsp;|&nbsp; Category: <strong>${app.category}</strong>
                        &nbsp;|&nbsp; Status: <span style="color:#059669;font-weight:700">ADMITTED</span>
                    </div>
                </div>

                <%-- Determine next year to apply for --%>
                <c:set var="appEnrollments" value="<%= new java.util.ArrayList() %>" />
                <c:forEach var="enr" items="${enrollments}">
                    <c:if test="${enr.applicationId == app.id}">
                        <c:set var="appEnrollments" value="${appEnrollments}"/>
                    </c:if>
                </c:forEach>

                <a href="${pageContext.request.contextPath}/EnrollmentServlet?action=reEnrollForm&appId=${app.id}"
                   style="background:linear-gradient(135deg,#f59e0b,#f97316);color:#fff;padding:10px 20px;border-radius:10px;font-size:13px;font-weight:700;text-decoration:none;display:inline-flex;align-items:center;gap:7px;box-shadow:0 4px 12px rgba(245,158,11,0.35)">
                    <i class="fas fa-plus-circle"></i> Apply for Next Year
                </a>
            </div>

            <!-- Year Cards Grid -->
            <div class="card-body">
                <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:14px">
                    <c:forEach begin="1" end="4" var="yr">
                        <%-- Find enrollment for this year --%>
                        <c:set var="foundEnr" value="${null}"/>
                        <c:forEach var="enr" items="${enrollments}">
                            <c:if test="${enr.applicationId == app.id && enr.yearOfStudy == yr}">
                                <c:set var="foundEnr" value="${enr}"/>
                            </c:if>
                        </c:forEach>

                        <div style="border-radius:12px;overflow:hidden;border:2px solid ${foundEnr != null && foundEnr.status == 'APPROVED' ? '#2563eb' : foundEnr != null && foundEnr.status == 'PENDING' ? '#f59e0b' : foundEnr != null && foundEnr.status == 'REJECTED' ? '#ef4444' : '#e2e8f0'}">

                            <!-- Year Header -->
                            <div style="padding:12px;text-align:center;background:${foundEnr != null && foundEnr.status == 'APPROVED' ? 'linear-gradient(135deg,#1a4b8c,#2563eb)' : foundEnr != null && foundEnr.status == 'PENDING' ? 'linear-gradient(135deg,#d97706,#f59e0b)' : foundEnr != null && foundEnr.status == 'REJECTED' ? 'linear-gradient(135deg,#dc2626,#ef4444)' : '#f8fafc'}">
                                <div style="font-size:18px;font-weight:800;color:${foundEnr != null ? '#fff' : '#94a3b8'}">
                                    Year ${yr}
                                </div>
                                <div style="font-size:10px;color:${foundEnr != null ? 'rgba(255,255,255,0.8)' : '#94a3b8'};margin-top:2px">
                                    <c:choose>
                                        <c:when test="${yr==1}">2024-25</c:when>
                                        <c:when test="${yr==2}">2025-26</c:when>
                                        <c:when test="${yr==3}">2026-27</c:when>
                                        <c:when test="${yr==4}">2027-28</c:when>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Year Body -->
                            <div style="padding:12px;background:#fff;min-height:120px">
                                <c:choose>
                                    <c:when test="${foundEnr != null}">
                                        <!-- STATUS BADGE -->
                                        <div style="text-align:center;margin-bottom:8px">
                                            <c:choose>
                                                <c:when test="${foundEnr.status == 'APPROVED'}">
                                                    <span style="background:#ecfdf5;color:#059669;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700">
                                                        <i class="fas fa-check"></i> APPROVED
                                                    </span>
                                                </c:when>
                                                <c:when test="${foundEnr.status == 'PENDING'}">
                                                    <span style="background:#fffbeb;color:#d97706;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700">
                                                        <i class="fas fa-clock"></i> PENDING
                                                    </span>
                                                </c:when>
                                                <c:when test="${foundEnr.status == 'REJECTED'}">
                                                    <span style="background:#fef2f2;color:#dc2626;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700">
                                                        <i class="fas fa-times"></i> REJECTED
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </div>

                                        <!-- Enrollment No -->
                                        <div style="font-size:10px;color:#94a3b8;text-align:center;margin-bottom:6px">
                                            ${foundEnr.enrollmentNo}
                                        </div>

                                        <!-- Fee -->
                                        <div style="text-align:center;font-size:15px;font-weight:800;color:#1a4b8c;margin-bottom:8px">
                                            ₹<fmt:formatNumber value="${foundEnr.applicableFee}" pattern="#,##,##0"/>
                                        </div>

                                        <!-- Fee Payment Status -->
                                        <div style="text-align:center;margin-bottom:8px">
                                            <c:choose>
                                                <c:when test="${foundEnr.feePaid}">
                                                    <span style="background:#ecfdf5;color:#059669;font-size:11px;padding:3px 10px;border-radius:10px;font-weight:600">
                                                        <i class="fas fa-check-circle"></i> Fee Paid
                                                    </span>
                                                </c:when>
                                                <c:when test="${foundEnr.status == 'APPROVED' && !foundEnr.feePaid}">
                                                    <a href="${pageContext.request.contextPath}/StudentPaymentServlet"
                                                       style="background:#fef2f2;color:#dc2626;font-size:11px;padding:4px 10px;border-radius:10px;font-weight:600;text-decoration:none;display:inline-block">
                                                        <i class="fas fa-exclamation-circle"></i> Pay Fee
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:#94a3b8;font-size:11px">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Academic Performance -->
                                        <c:if test="${foundEnr.sgpa != null}">
                                            <div style="background:#f8fafc;border-radius:8px;padding:8px;margin-top:6px">
                                                <div style="display:flex;justify-content:space-between;font-size:11px;margin-bottom:3px">
                                                    <span style="color:#64748b">SGPA</span>
                                                    <span style="font-weight:700">${foundEnr.sgpa}</span>
                                                </div>
                                                <div style="display:flex;justify-content:space-between;font-size:11px;margin-bottom:3px">
                                                    <span style="color:#64748b">CGPA</span>
                                                    <span style="font-weight:700">${foundEnr.cgpa}</span>
                                                </div>
                                                <c:if test="${foundEnr.backlogs > 0}">
                                                    <div style="display:flex;justify-content:space-between;font-size:11px">
                                                        <span style="color:#dc2626">Backlogs</span>
                                                        <span style="font-weight:700;color:#dc2626">${foundEnr.backlogs}</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:if>

                                        <!-- Rejection remarks -->
                                        <c:if test="${foundEnr.status == 'REJECTED' && not empty foundEnr.adminRemarks}">
                                            <div style="font-size:11px;color:#dc2626;margin-top:6px;background:#fef2f2;padding:6px;border-radius:6px">
                                                ${foundEnr.adminRemarks}
                                            </div>
                                        </c:if>
                                    </c:when>

                                    <c:otherwise>
                                        <!-- Not yet enrolled -->
                                        <div style="text-align:center;padding:16px 0">
                                            <i class="fas fa-lock" style="font-size:24px;color:#e2e8f0;display:block;margin-bottom:8px"></i>
                                            <div style="font-size:11px;color:#94a3b8">Not enrolled</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Progress bar -->
                <div style="margin-top:16px">
                    <c:set var="approvedCount" value="0"/>
                    <c:forEach var="enr" items="${enrollments}">
                        <c:if test="${enr.applicationId == app.id && enr.status == 'APPROVED'}">
                            <c:set var="approvedCount" value="${approvedCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    <div style="display:flex;justify-content:space-between;margin-bottom:5px;font-size:12px">
                        <span style="font-weight:600;color:#374151">Program Progress</span>
                        <span style="color:#2563eb;font-weight:700">${approvedCount} / 4 Years</span>
                    </div>
                    <div style="height:8px;background:#e2e8f0;border-radius:20px;overflow:hidden">
                        <div style="height:100%;width:${approvedCount * 25}%;background:linear-gradient(90deg,#2563eb,#3b82f6);border-radius:20px;transition:width 1s ease"></div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</c:forEach>

<!-- No approved applications -->
<c:if test="${!hasApproved}">
    <div class="card">
        <div class="card-body">
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <h3>No Approved Admissions</h3>
                <p>Your admission application must be approved by admin before you can enroll.</p>
                <a href="${pageContext.request.contextPath}/ApplicationServlet?action=myApplications"
                   class="btn btn-primary" style="margin-top:14px">View My Applications</a>
            </div>
        </div>
    </div>
</c:if>

<%@ include file="/WEB-INF/includes/footer.jsp" %>