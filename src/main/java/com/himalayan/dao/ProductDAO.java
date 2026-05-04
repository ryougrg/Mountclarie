package com.himalayan.dao;

import com.himalayan.model.Product;
import com.himalayan.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Create product
    public boolean addProduct(Product product) throws SQLException {
        String sql = "INSERT INTO products (product_name, category, price, stock_quantity, description, rack_number) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getCategory());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getRackNumber());
            return ps.executeUpdate() > 0;
        }
    }

    // Read all products
    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setDescription(rs.getString("description"));
                product.setImageUrl(rs.getString("image_url"));
                product.setRackNumber(rs.getString("rack_number"));
                products.add(product);
            }
        }
        return products;
    }

    // Get product by ID
    public Product getProductById(int id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setDescription(rs.getString("description"));
                product.setRackNumber(rs.getString("rack_number"));
                return product;
            }
            return null;
        }
    }

    // Update product
    public boolean updateProduct(Product product) throws SQLException {
        String sql = "UPDATE products SET product_name=?, category=?, price=?, stock_quantity=?, description=?, rack_number=? WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getCategory());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getRackNumber());
            ps.setInt(7, product.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // Delete product
    public boolean deleteProduct(int id) throws SQLException {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Search products
    public List<Product> searchProducts(String keyword) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE product_name LIKE ? OR category LIKE ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setDescription(rs.getString("description"));
                product.setRackNumber(rs.getString("rack_number"));
                products.add(product);
            }
        }
        return products;
    }
}