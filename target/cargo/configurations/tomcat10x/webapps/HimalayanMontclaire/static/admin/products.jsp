<%@ include file="/WEB-INF/templates/admin-head.jsp" %>
<%@ include file="/WEB-INF/templates/admin-header.jsp" %>
<%@ include file="/WEB-INF/templates/admin-nav.jsp" %>

<div class="admin-content">
    <h1>Manage Products</h1>

    <% if(request.getAttribute("success") != null) { %>
    <div class="success-msg"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if(request.getAttribute("error") != null) { %>
    <div class="error-msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <a href="add-product.jsp" class="btn-add">+ Add New Product</a>

    <table class="product-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Product Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%@ page import="java.util.List" %>
        <%@ page import="com.himalayan.model.Product" %>
        <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products == null || products.isEmpty()) {
        %>
        <tr><td colspan="6">No products found</td></tr>
        <% } else {
            for (Product p : products) {
        %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getProductName() %></td>
            <td><%= p.getCategory() %></td>
            <td><%= p.getPrice() %></td>
            <td><%= p.getStockQuantity() %></td>
            <td>
                <a href="edit-product?id=<%= p.getId() %>">Edit</a> |
                <a href="products?action=delete&id=<%= p.getId() %>" onclick="return confirm('Delete?')">Delete</a>
            </td>
        </tr>
        <% } } %>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/templates/admin-footer.html" %>