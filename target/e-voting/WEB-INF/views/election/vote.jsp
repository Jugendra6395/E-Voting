<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Vote" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election">Elections</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}">Details</a></li>
                <li class="breadcrumb-item active" aria-current="page">Vote</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h2>Vote: ${election.title}</h2>
            </div>
            <div class="card-body">
                <p>${election.description}</p>
                <p>
                    <strong>Start Date:</strong> <fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /><br>
                    <strong>End Date:</strong> <fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" />
                </p>
                
                <hr>
                
                <h4>Cast Your Vote</h4>
                <c:choose>
                    <c:when test="${empty candidates}">
                        <div class="alert alert-info">No candidates have been registered for this election yet.</div>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/election/vote" method="post">
                            <input type="hidden" name="electionId" value="${election.electionId}">
                            
                            <div class="mb-3">
                                <label class="form-label">Select a candidate:</label>
                                <div class="row">
                                    <c:forEach items="${candidates}" var="candidate">
                                        <div class="col-md-4 mb-3">
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="candidateId" 
                                                               id="candidate${candidate.candidateId}" value="${candidate.candidateId}" required>
                                                        <label class="form-check-label" for="candidate${candidate.candidateId}">
                                                            <h5 class="card-title">${candidate.name}</h5>
                                                            <p class="card-text">${candidate.description}</p>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <div class="alert alert-warning">
                                <strong>Warning:</strong> You can only vote once in this election. Your vote cannot be changed after submission.
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Submit Vote</button>
                            <a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}" class="btn btn-secondary">Cancel</a>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 