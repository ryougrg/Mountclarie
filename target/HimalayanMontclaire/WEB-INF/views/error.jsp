<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Himalayan Montclairé</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="error-container">
    <h1>Error</h1>
    <p><%= request.getAttribute("error") != null ? request.getAttribute("error") : "Access Denied" %></p>
    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
</div>
</body>
</html>