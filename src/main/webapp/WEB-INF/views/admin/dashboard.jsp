<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Admin Dashboard" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <h1>Admin Dashboard</h1>
        <p class="lead">Manage your E-Voting System</p>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-4">
        <div class="card text-white bg-primary mb-3">
            <div class="card-header">Active Elections</div>
            <div class="card-body">
                <h5 class="card-title">${activeElectionCount}</h5>
                <p class="card-text">Elections currently active</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card text-white bg-success mb-3">
            <div class="card-header">Total Elections</div>
            <div class="card-body">
                <h5 class="card-title">${totalElectionCount}</h5>
                <p class="card-text">Total elections in the system</p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card text-white bg-info mb-3">
            <div class="card-header">Registered Users</div>
            <div class="card-body">
                <h5 class="card-title">${userCount}</h5>
                <p class="card-text">Users registered in the system</p>
            </div>
        </div>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h2>Quick Actions</h2>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/admin/create-election" class="btn btn-primary">Create New Election</a>
                    <a href="${pageContext.request.contextPath}/admin/manage-elections" class="btn btn-success">Manage Elections</a>
                    <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-info">Manage Users</a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h2>Active Elections</h2>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty activeElections}">
                        <div class="alert alert-info">There are no active elections at the moment.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group">
                            <c:forEach items="${activeElections}" var="election">
                                <a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}" class="list-group-item list-group-item-action">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h5 class="mb-1">${election.title}</h5>
                                        <small>
                                            <fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd" />
                                        </small>
                                    </div>
                                    <p class="mb-1">${election.description}</p>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 