<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.himalayan.model.User" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Approvals - Himalayan Montclairé</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <style>
        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .users-table th, .users-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .users-table th {
            background-color: #4CAF50;
            color: white;
        }
        .status-pending {
            color: orange;
            font-weight: bold;
        }
        .status-approved {
            color: green;
            font-weight: bold;
        }
        .approve-btn {
            background-color: #4CAF50;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            font-size: 12px;
        }
        .approve-btn:hover {
            background-color: #45a049;
        }
        .success-msg {
            background-color: #dff0d8;
            color: green;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .error-msg {
            background-color: #f2dede;
            color: red;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .checkbox-col {
            width: 30px;
        }
        .btn-approve-selected {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .btn-approve-selected:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="admin-container">
    <nav class="admin-nav">
        <div class="nav-brand">
            <h2>🏔️ Himalayan Montclairé Admin</h2>
        </div>
        <div class="nav-user">
            <span>Welcome, <%= user.getFullName() %></span>
            <a href="../logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="admin-sidebar">
        <ul>
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="products">Manage Products</a></li>
            <li><a href="users" style="background-color: #4CAF50;">User Approvals</a></li>
            <li><a href="reports.jsp">Reports</a></li>
        </ul>
    </div>

    <div class="admin-content">
        <h1>User Approvals</h1>
        <p>Approve or manage user registrations.</p>

        <% if(request.getAttribute("success") != null) { %>
        <div class="success-msg"><%= request.getAttribute("success") %></div>
        <% } %>

        <% if(request.getAttribute("error") != null) { %>
        <div class="error-msg"><%= request.getAttribute("error") %></div>
        <% } %>

        <h2>Pending Approval Requests</h2>

        <form method="post" action="users">
            <input type="hidden" name="action" value="approveMultiple">

            <table class="users-table">
                <thead>
                <tr>
                    <th class="checkbox-col"><input type="checkbox" onclick="toggleAll(this)"></th>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<User> pendingUsers = (List<User>) request.getAttribute("pendingUsers");
                    if (pendingUsers == null || pendingUsers.isEmpty()) {
                %>
                <tr>
                    <td colspan="8" style="text-align: center;">No pending users to approve</td>
                </tr>
                <%
                } else {
                    for (User pendingUser : pendingUsers) {
                %>
                <tr>
                    <td><input type="checkbox" name="userIds" value="<%= pendingUser.getId() %>"></td>
                    <td><%= pendingUser.getId() %></td>
                    <td><%= pendingUser.getFullName() %></td>
                    <td><%= pendingUser.getEmail() %></td>
                    <td><%= pendingUser.getPhone() %></td>
                    <td><%= pendingUser.getAddress() %></td>
                    <td><span class="status-pending">Pending</span></td>
                    <td>
                        <a href="users?action=approve&id=<%= pendingUser.getId() %>" class="approve-btn"
                           onclick="return confirm('Approve <%= pendingUser.getFullName() %>?')">Approve</a>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>

            <% if (pendingUsers != null && !pendingUsers.isEmpty()) { %>
            <button type="submit" class="btn-approve-selected">Approve Selected Users</button>
            <% } %>
        </form>

        <h2 style="margin-top: 40px;">Approved Users</h2>
        <table class="users-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Address</th>
                <th>Role</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<User> approvedUsers = (List<User>) request.getAttribute("approvedUsers");
                if (approvedUsers == null || approvedUsers.isEmpty()) {
            %>
            <tr>
                <td colspan="7" style="text-align: center;">No approved users found</td>
            </tr>
            <%
            } else {
                for (User approvedUser : approvedUsers) {
            %>
            <tr>
                <td><%= approvedUser.getId() %></td>
                <td><%= approvedUser.getFullName() %></td>
                <td><%= approvedUser.getEmail() %></td>
                <td><%= approvedUser.getPhone() %></td>
                <td><%= approvedUser.getAddress() %></td>
                <td><%= approvedUser.getRole() %></td>
                <td><span class="status-approved">Approved</span></td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('input[name="userIds"]');
        checkboxes.forEach(checkbox => checkbox.checked = source.checked);
    }
</script>
</body>
</html>