<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Add Candidate" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/manage-elections">Manage Elections</a></li>
                <li class="breadcrumb-item active" aria-current="page">Add Candidate</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-8 offset-md-2">
        <div class="card">
            <div class="card-header">
                <h2>Add Candidate to Election</h2>
            </div>
            <div class="card-body">
                <h4>Election: ${election.title}</h4>
                <p>${election.description}</p>
                <p>
                    <strong>Start Date:</strong> <fmt:formatDate value="${election.startDate}" pattern="yyyy-MM-dd HH:mm" /><br>
                    <strong>End Date:</strong> <fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" />
                </p>
                
                <hr>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/admin/add-candidate" method="post">
                    <input type="hidden" name="electionId" value="${election.electionId}">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Candidate Name</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Candidate Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        <div class="form-text">Provide a brief description or biography of the candidate.</div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/admin/manage-elections" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Add Candidate</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 