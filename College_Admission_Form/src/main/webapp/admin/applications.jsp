<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Applications"); request.setAttribute("currentPage","applications"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">Applications</span>
</div>

<c:if test="${not empty successMsg}">
    <div class="alert alert-success" data-auto-dismiss><i class="fas fa-check-circle"></i><div>${successMsg}</div></div>
</c:if>

<div class="section-header">
    <h2><i class="fas fa-file-alt me-2 text-primary"></i>All Applications</h2>
</div>

<div class="card mb-4">
    <div class="card-body py-3">
        <form method="get" action="${pageContext.request.contextPath}/ApplicationServlet" class="d-flex flex-wrap gap-3 align-items-end">
            <input type="hidden" name="action" value="list">
            <div>
                <label class="form-label mb-1">Status</label>
                <select name="status" class="form-select" style="min-width:150px">
                    <option value="">All Statuses</option>
                    <option value="PENDING"      ${param.status=='PENDING'      ?'selected':''}>Pending</option>
                    <option value="UNDER_REVIEW" ${param.status=='UNDER_REVIEW' ?'selected':''}>Under Review</option>
                    <option value="APPROVED"     ${param.status=='APPROVED'     ?'selected':''}>Approved</option>
                    <option value="REJECTED"     ${param.status=='REJECTED'     ?'selected':''}>Rejected</option>
                    <option value="WAITLISTED"   ${param.status=='WAITLISTED'   ?'selected':''}>Waitlisted</option>
                </select>
            </div>
            <div>
                <label class="form-label mb-1">Program</label>
                <select name="programId" class="form-select" style="min-width:180px">
                    <option value="">All Programs</option>
                    <c:forEach var="prog" items="${programs}">
                        <option value="${prog.id}" ${param.programId==prog.id?'selected':''}>${prog.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="form-label mb-1">Search</label>
                <div class="search-bar">
                    <input type="text" name="search" placeholder="Name / App No." value="${param.search}">
                    <button type="submit"><i class="fas fa-search"></i></button>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/ApplicationServlet?action=list" class="btn btn-light"><i class="fas fa-times"></i> Clear</a>
        </form>
    </div>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="data-table">
            <thead>
                <tr><th>#</th><th>App No.</th><th>Student</th><th>Program</th><th>10th%</th><th>12th%</th><th>Submitted</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty applications}">
                        <c:forEach var="app" items="${applications}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td class="fw-600 text-primary">${app.applicationNo}</td>
                                <td>
                                    <div class="fw-600">${app.fullName}</div>
                                    <div class="text-muted" style="font-size:11px">${app.studentEmail}</div>
                                </td>
                                <td class="fs-13">${app.programName}</td>
                                <td class="fs-13">${app.tenthMarks}%</td>
                                <td class="fs-13">${app.twelfthMarks}%</td>
                                <td class="text-muted fs-13"><fmt:formatDate value="${app.submittedAt}" pattern="dd MMM yyyy"/></td>
                                <td><span class="badge badge-${app.status.toLowerCase()}">${app.status}</span></td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <a href="${pageContext.request.contextPath}/ApplicationServlet?action=view&id=${app.id}" class="btn btn-light btn-xs"><i class="fas fa-eye"></i></a>
                                        <c:if test="${app.status=='PENDING'||app.status=='UNDER_REVIEW'}">
                                            <button class="btn btn-success btn-xs" onclick="quickStatus(${app.id},'APPROVED')"><i class="fas fa-check"></i></button>
                                            <button class="btn btn-danger btn-xs" onclick="quickStatus(${app.id},'REJECTED')"><i class="fas fa-times"></i></button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="9"><div class="empty-state"><i class="fas fa-folder-open"></i><h4>No Applications Found</h4></div></td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<form id="quickStatusForm" method="post" action="${pageContext.request.contextPath}/ApplicationServlet">
    <input type="hidden" name="action" value="updateStatus">
    <input type="hidden" name="id" id="qsId">
    <input type="hidden" name="status" id="qsStatus">
    <input type="hidden" name="remarks" value="Status updated by admin.">
</form>
<script>
function quickStatus(id,status){
    if(confirm(status==='APPROVED'?'Approve this application?':'Reject this application?')){
        document.getElementById('qsId').value=id;
        document.getElementById('qsStatus').value=status;
        document.getElementById('quickStatusForm').submit();
    }
}
</script>
<%@ include file="/WEB-INF/includes/footer.jsp" %>