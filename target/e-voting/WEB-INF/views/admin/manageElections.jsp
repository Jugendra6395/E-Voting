<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Manage Elections" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Manage Elections</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h2>Manage Elections</h2>
                <a href="${pageContext.request.contextPath}/admin/create-election" class="btn btn-primary">Create New Election</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty elections}">
                        <div class="alert alert-info">There are no elections in the system.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>Description</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${elections}" var="election">
                                        <tr>
                                            <td>${election.electionId}</td>
                                            <td>${election.title}</td>
                                            <td>${election.description.length() > 50 ? election.description.substring(0, 50).concat('...') : election.description}</td>
                                            <td><fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                            <td><fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                            <td>
                                                <c:set var="now" value="<%= new java.util.Date() %>" />
                                                <c:choose>
                                                    <c:when test="${!election.active}">
                                                        <span class="badge bg-secondary">Inactive</span>
                                                    </c:when>
                                                    <c:when test="${election.startDate gt now}">
                                                        <span class="badge bg-warning">Upcoming</span>
                                                    </c:when>
                                                    <c:when test="${election.endDate lt now}">
                                                        <span class="badge bg-danger">Ended</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success">Active</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}" class="btn btn-sm btn-info">View</a>
                                                    <a href="${pageContext.request.contextPath}/admin/add-candidate?electionId=${election.electionId}" class="btn btn-sm btn-primary">Add Candidate</a>
                                                    <a href="${pageContext.request.contextPath}/admin/view-results?id=${election.electionId}" class="btn btn-sm btn-success">Results</a>
                                                    <form action="${pageContext.request.contextPath}/admin/update-election" method="post" style="display:inline;">
                                                        <input type="hidden" name="electionId" value="${election.electionId}">
                                                        <input type="hidden" name="isActive" value="${!election.active}">
                                                        <button type="submit" class="btn btn-sm ${election.active ? 'btn-warning' : 'btn-success'}">
                                                            ${election.active ? 'Deactivate' : 'Activate'}
                                                        </button>
                                                    </form>
                                                </div>
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