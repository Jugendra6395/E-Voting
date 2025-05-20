<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Elections" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <h1>Available Elections</h1>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h2>Active Elections</h2>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty elections}">
                        <div class="alert alert-info">There are no active elections at the moment.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Description</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${elections}" var="election">
                                        <tr>
                                            <td>${election.title}</td>
                                            <td>${election.description}</td>
                                            <td><fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                            <td><fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}" class="btn btn-primary btn-sm">Details</a>
                                                <a href="${pageContext.request.contextPath}/election/vote?id=${election.electionId}" class="btn btn-success btn-sm">Vote</a>
                                                <a href="${pageContext.request.contextPath}/election/results?id=${election.electionId}" class="btn btn-info btn-sm">Results</a>
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