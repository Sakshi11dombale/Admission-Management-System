<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% request.setAttribute("pageTitle","Notifications"); request.setAttribute("currentPage","notifications"); %>
<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-home"></i></a>
    <span class="sep">/</span><span class="current">Notifications</span>
</div>
<div class="section-header"><h2><i class="fas fa-bell me-2 text-primary"></i>My Notifications</h2></div>
<div class="card">
    <div style="padding:0">
        <c:choose>
            <c:when test="${not empty notifications}">
                <c:forEach var="n" items="${notifications}">
                    <div style="padding:18px 24px;border-bottom:1px solid #f1f5f9;${not n.read?'background:#fffbeb':''}">
                        <div class="d-flex gap-3 align-items-start">
                            <div style="width:40px;height:40px;background:${not n.read?'#fff3cd':'#f1f5f9'};border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0">
                                <i class="fas fa-bell" style="color:${not n.read?'#d97706':'#94a3b8'}"></i>
                            </div>
                            <div style="flex:1">
                                <div class="fw-600" style="font-size:15px">${n.title}</div>
                                <div class="text-muted mt-1" style="font-size:13px">${n.message}</div>
                                <div style="font-size:11px;color:#94a3b8;margin-top:6px"><i class="fas fa-clock me-1"></i><fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, HH:mm"/></div>
                            </div>
                            <c:if test="${not n.read}"><span class="badge badge-pending">New</span></c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state py-5"><i class="fas fa-bell-slash"></i><h4>No Notifications</h4><p>You're all caught up!</p></div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<%@ include file="/WEB-INF/includes/footer.jsp" %>