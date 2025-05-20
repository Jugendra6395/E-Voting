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
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manage-elections">Manage Elections</a></li>
                <li class="breadcrumb-item active" aria-current="page">View Results</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h2>Election Results: ${election.title}</h2>
                <a href="${pageContext.request.contextPath}/admin/add-candidate?electionId=${election.electionId}" class="btn btn-primary">Add Candidate</a>
            </div>
            <div class="card-body">
                <p>${election.description}</p>
                <p>
                    <strong>Start Date:</strong> <fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /><br>
                    <strong>End Date:</strong> <fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" /><br>
                    <strong>Status:</strong> 
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
                </p>
                
                <hr>
                
                <h4>Voting Results</h4>
                <p>Total votes cast: ${totalVotes}</p>
                
                <c:choose>
                    <c:when test="${empty candidates}">
                        <div class="alert alert-info">No candidates have been registered for this election yet.</div>
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
                        
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5>Download Results</h5>
                                <div class="d-grid gap-2 d-md-flex">
                                    <a href="${pageContext.request.contextPath}/admin/export-results?id=${election.electionId}&format=csv" class="btn btn-outline-primary">
                                        <i class="bi bi-file-earmark-spreadsheet"></i> Export to CSV
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/export-results?id=${election.electionId}&format=pdf" class="btn btn-outline-danger">
                                        <i class="bi bi-file-earmark-pdf"></i> Export to PDF
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/admin/manage-elections" class="btn btn-secondary">Back to Manage Elections</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 