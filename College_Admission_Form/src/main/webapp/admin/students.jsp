<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Students"); request.setAttribute("currentPage","students"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">Students</span>
</div>
<div class="section-header">
    <h2><i class="fas fa-user-graduate me-2 text-primary"></i>Students</h2>
    <div class="search-bar">
        <input type="text" id="studentSearch" placeholder="Search..." oninput="filterStudents(this.value)">
        <button><i class="fas fa-search"></i></button>
    </div>
</div>
<div class="card">
    <div class="table-responsive">
        <table class="data-table" id="studentsTable">
            <thead><tr><th>#</th><th>Name</th><th>Username</th><th>Email</th><th>Phone</th><th>Registered</th><th>Action</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty students}">
                        <c:forEach var="s" items="${students}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:34px;height:34px;background:#e8f0fe;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;color:#1a3c6e">${s.fullName.charAt(0)}</div>
                                        <span class="fw-600">${s.fullName}</span>
                                    </div>
                                </td>
                                <td class="fs-13">${s.username}</td>
                                <td class="text-muted fs-13">${s.email}</td>
                                <td class="fs-13">${s.phone != null ? s.phone : '-'}</td>
                                <td class="text-muted fs-13"><fmt:formatDate value="${s.createdAt}" pattern="dd MMM yyyy"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/ApplicationServlet?action=list&studentId=${s.id}" class="btn btn-light btn-xs">
                                        <i class="fas fa-file-alt"></i> Applications
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="7"><div class="empty-state"><i class="fas fa-user-graduate"></i><h4>No Students Registered</h4></div></td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
<script>
function filterStudents(q){
    document.querySelectorAll('#studentsTable tbody tr').forEach(function(row){
        row.style.display = row.textContent.toLowerCase().includes(q.toLowerCase()) ? '' : 'none';
    });
}
</script>
<%@ include file="/WEB-INF/includes/footer.jsp" %>