<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Notifications"); request.setAttribute("currentPage","notifications"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">Notifications</span>
</div>
<div class="section-header">
    <h2><i class="fas fa-bell me-2 text-primary"></i>Notifications</h2>
    <button class="btn btn-primary" data-modal="sendNotifModal"><i class="fas fa-paper-plane"></i> Send Notification</button>
</div>

<div class="card">
    <div class="table-responsive">
        <table class="data-table">
            <thead><tr><th>#</th><th>Student</th><th>Title</th><th>Message</th><th>Sent</th><th>Read</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <c:forEach var="n" items="${notifications}" varStatus="st">
                            <tr style="${not n.read?'background:#fffbeb':''}">
                                <td>${st.count}</td>
                                <td class="fs-13">${n.userName}</td>
                                <td class="fw-600">${n.title}</td>
                                <td class="text-muted fs-13" style="max-width:300px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${n.message}</td>
                                <td class="text-muted fs-13"><fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, HH:mm"/></td>
                                <td><c:choose><c:when test="${n.read}"><span class="badge badge-approved">Read</span></c:when><c:otherwise><span class="badge badge-pending">Unread</span></c:otherwise></c:choose></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><tr><td colspan="6"><div class="empty-state"><i class="fas fa-bell-slash"></i><h4>No Notifications Sent</h4></div></td></tr></c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<div class="modal-overlay" id="sendNotifModal">
    <div class="modal-box">
        <div class="modal-header"><h4>Send Notification</h4><button class="modal-close" onclick="closeModal('sendNotifModal')">&times;</button></div>
        <form method="post" action="${pageContext.request.contextPath}/NotificationServlet">
            <input type="hidden" name="action" value="send">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Recipient</label>
                    <select name="recipientType" class="form-select" onchange="document.getElementById('specificDiv').style.display=this.value==='SPECIFIC'?'block':'none'">
                        <option value="ALL">All Students</option>
                        <option value="SPECIFIC">Specific Student</option>
                    </select>
                </div>
                <div id="specificDiv" style="display:none" class="form-group">
                    <label class="form-label">Select Student</label>
                    <select name="userId" class="form-select">
                        <option value="">-- Select --</option>
                        <c:forEach var="s" items="${students}">
                            <option value="${s.id}">${s.fullName} (${s.email})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group"><label class="form-label">Title *</label><input type="text" name="title" class="form-control" required></div>
                <div class="form-group mb-0"><label class="form-label">Message *</label><textarea name="message" class="form-control" rows="4" required></textarea></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" onclick="closeModal('sendNotifModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Send</button>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>