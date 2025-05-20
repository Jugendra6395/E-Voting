<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Manage Users" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Manage Users</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h2>Manage Users</h2>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty users}">
                        <div class="alert alert-info">There are no users in the system.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Full Name</th>
                                        <th>Role</th>
                                        <th>Registration Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>${user.userId}</td>
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>${user.fullName}</td>
                                            <td><span class="badge ${user.role == 'admin' ? 'bg-danger' : 'bg-primary'}">${user.role}</span></td>
                                            <td><fmt:formatDate value="${user.registrationDate}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <span class="badge ${user.active ? 'bg-success' : 'bg-secondary'}">
                                                    ${user.active ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <!-- Don't allow deactivating the current admin user -->
                                                <c:if test="${user.userId != sessionScope.user.userId}">
                                                    <form action="${pageContext.request.contextPath}/admin/update-user" method="post" style="display:inline;">
                                                        <input type="hidden" name="userId" value="${user.userId}">
                                                        <input type="hidden" name="isActive" value="${!user.active}">
                                                        <button type="submit" class="btn btn-sm ${user.active ? 'btn-warning' : 'btn-success'}">
                                                            ${user.active ? 'Deactivate' : 'Activate'}
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 