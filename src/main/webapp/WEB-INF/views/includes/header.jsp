<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - E-Voting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 56px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .content {
            flex: 1;
        }
        .footer {
            margin-top: auto;
            padding: 20px 0;
            background-color: #f8f9fa;
        }
        /* Custom color scheme - Purple instead of blue */
        .btn-primary {
            background-color: #6f42c1;
            border-color: #6f42c1;
        }
        .btn-primary:hover, .btn-primary:focus {
            background-color: #5a32a3;
            border-color: #5a32a3;
        }
        .bg-primary {
            background-color: #6f42c1 !important;
        }
        .btn-info {
            background-color: #9d6adc;
            border-color: #9d6adc;
        }
        .btn-info:hover, .btn-info:focus {
            background-color: #8250df;
            border-color: #8250df;
        }
        a {
            color: #6f42c1;
        }
        a:hover, a:focus {
            color: #5a32a3;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">E-Voting System</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/election">Elections</a>
                        </li>
                        <c:if test="${sessionScope.user.role eq 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-elections">Manage Elections</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a>
                            </li>
                        </c:if>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <span class="nav-link">Welcome, ${sessionScope.user.fullName}</span>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

        <div class="container content mt-4">        <c:if test="${not empty errorMessage}">            <div class="alert alert-danger alert-dismissible fade show" role="alert">                ${errorMessage}                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>            </div>        </c:if>        <c:if test="${not empty successMessage}">            <div class="alert alert-success alert-dismissible fade show" role="alert">                ${successMessage}                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>            </div>        </c:if> 