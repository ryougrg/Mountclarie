<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.himalayan.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - Himalayan Montclairé</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
    <%
    User admin = (User) session.getAttribute("user");
%>
<div class="admin-top-bar">
    <div class="logo">
        <h2>🏔️ Admin Panel</h2>
    </div>
    <div class="admin-info">
        <span>Welcome, <%= (admin != null) ? admin.getFullName() : "Admin" %></span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
</div>