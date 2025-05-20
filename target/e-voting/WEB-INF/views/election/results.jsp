<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Election Results" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election">Elections</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}">Details</a></li>
                <li class="breadcrumb-item active" aria-current="page">Results</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h2>Results: ${election.title}</h2>
            </div>
            <div class="card-body">
                <p>${election.description}</p>
                <p>
                    <strong>Start Date:</strong> <fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /><br>
                    <strong>End Date:</strong> <fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" />
                </p>
                
                <hr>
                
                <h4>Voting Results</h4>
                <p>Total votes cast: ${totalVotes}</p>
                
                <c:choose>
                    <c:when test="${empty candidates}">
                        <div class="alert alert-info">No candidates have been registered for this election.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Candidate</th>
                                        <th>Description</th>
                                        <th>Votes</th>
                                        <th>Percentage</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${candidates}" var="candidate">
                                        <tr>
                                            <td>${candidate.name}</td>
                                            <td>${candidate.description}</td>
                                            <td>${voteCounts[candidate.candidateId] != null ? voteCounts[candidate.candidateId] : 0}</td>
                                            <td>
                                                <c:if test="${totalVotes > 0}">
                                                    <fmt:formatNumber value="${(voteCounts[candidate.candidateId] != null ? voteCounts[candidate.candidateId] : 0) / totalVotes * 100}" maxFractionDigits="2"/>%
                                                </c:if>
                                                <c:if test="${totalVotes == 0}">
                                                    0%
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5>Results Visualization</h5>
                                <div class="progress" style="height: 40px;">
                                    <c:forEach items="${candidates}" var="candidate" varStatus="loop">
                                        <c:set var="voteCount" value="${voteCounts[candidate.candidateId] != null ? voteCounts[candidate.candidateId] : 0}" />
                                        <c:set var="percentage" value="${totalVotes > 0 ? (voteCount / totalVotes * 100) : 0}" />
                                        <div class="progress-bar bg-${loop.index % 4 == 0 ? 'primary' : (loop.index % 4 == 1 ? 'success' : (loop.index % 4 == 2 ? 'info' : 'warning'))}" 
                                             role="progressbar" style="width: ${percentage}%" 
                                             aria-valuenow="${percentage}" aria-valuemin="0" aria-valuemax="100">
                                            ${candidate.name} (<fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%)
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}" class="btn btn-primary">Back to Details</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 