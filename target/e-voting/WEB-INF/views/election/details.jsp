<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Election Details" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election">Elections</a></li>
                <li class="breadcrumb-item active" aria-current="page">Details</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h2>${election.title}</h2>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <h5>Description:</h5>
                        <p>${election.description}</p>
                    </div>
                    <div class="col-md-4">
                        <h5>Start Date:</h5>
                        <p><fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                    </div>
                    <div class="col-md-4">
                        <h5>End Date:</h5>
                        <p><fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                    </div>
                </div>
                
                <h4>Candidates</h4>
                <c:choose>
                    <c:when test="${empty candidates}">
                        <div class="alert alert-info">No candidates have been registered for this election yet.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach items="${candidates}" var="candidate">
                                <div class="col-md-4 mb-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="card-title">${candidate.name}</h5>
                                        </div>
                                        <div class="card-body">
                                            <p class="card-text">${candidate.description}</p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/election/vote?id=${election.electionId}" class="btn btn-success">Vote Now</a>
                <a href="${pageContext.request.contextPath}/election/results?id=${election.electionId}" class="btn btn-info">View Results</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 