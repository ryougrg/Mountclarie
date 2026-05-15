<%@ page import="com.himalayan.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    String role = (loggedInUser != null) ? loggedInUser.getRole() : "";
%>

<!-- Top Header / Announcement Bar -->
<div class="top-bar">
    <div class="container">
        <span>Free Shipping on orders over ₹5000</span>
        <div class="top-links">
            <% if (loggedInUser == null) { %>
            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i> Login</a>
            <a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Register</a>
            <% } else { %>
            <span><i class="fas fa-user"></i> Welcome, <%= loggedInUser.getFullName() %></span>
            <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            <% } %>
        </div>
    </div>
</div>

<!-- Main Header / Logo Area -->
<header class="main-header">
    <div class="container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/">
                <h1>🏔️ Himalayan Montclairé</h1>
                <span class="tagline">Premium Clothing Brand</span>
            </a>
        </div>

        <!-- Search Bar -->
        <div class="search-bar">
            <form action="${pageContext.request.contextPath}/products" method="get">
                <input type="text" name="keyword" placeholder="Search products...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <!-- Header Icons -->
        <div class="header-icons">
            <a href="${pageContext.request.contextPath}/user/wishlist.jsp" class="icon">
                <i class="fas fa-heart"></i>
                <span class="badge">0</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="icon">
                <i class="fas fa-shopping-bag"></i>
                <span class="badge">0</span>
            </a>
        </div>
    </div>
</header>