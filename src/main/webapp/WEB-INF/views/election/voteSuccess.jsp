<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Vote Successful" />
</jsp:include>

<div class="row mb-4">
    <div class="col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election">Elections</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}">Details</a></li>
                <li class="breadcrumb-item active" aria-current="page">Vote Success</li>
            </ol>
        </nav>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-8 offset-md-2">
        <div class="card">
            <div class="card-header bg-success text-white">
                <h2>Vote Cast Successfully!</h2>
            </div>
            <div class="card-body">
                <div class="alert alert-success">
                    <p>${successMessage}</p>
                </div>
                
                <h4>Election: ${election.title}</h4>
                <p>${election.description}</p>
                
                <hr>
                
                <p>Thank you for participating in this election. Your vote has been recorded securely and anonymously.</p>
                <p>You can view the results after the election ends on <strong><fmt:formatDate value="${election.endDate}" pattern="yyyy-MM-dd HH:mm" /></strong>.</p>
                
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/election/details?id=${election.electionId}" class="btn btn-primary">Back to Election Details</a>
                    <a href="${pageContext.request.contextPath}/election" class="btn btn-secondary">View All Elections</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" /> 