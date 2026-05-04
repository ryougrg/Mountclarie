package com.himalayan.controller;

import com.himalayan.dao.ProductDAO;
import com.himalayan.model.Product;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String productName = request.getParameter("productName");
                String category = request.getParameter("category");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                String description = request.getParameter("description");
                String rackNumber = request.getParameter("rackNumber");

                Product product = new Product(productName, category, price, stock, description, rackNumber);
                productDAO.addProduct(product);
                request.setAttribute("success", "Product added successfully");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(id);
                if (product != null) {
                    product.setProductName(request.getParameter("productName"));
                    product.setCategory(request.getParameter("category"));
                    product.setPrice(new BigDecimal(request.getParameter("price")));
                    product.setStockQuantity(Integer.parseInt(request.getParameter("stock")));
                    product.setDescription(request.getParameter("description"));
                    product.setRackNumber(request.getParameter("rackNumber"));
                    productDAO.updateProduct(product);
                    request.setAttribute("success", "Product updated successfully");
                }

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                productDAO.deleteProduct(id);
                request.setAttribute("success", "Product deleted successfully");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Operation failed: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String deleteId = request.getParameter("delete");
            if (deleteId != null) {
                productDAO.deleteProduct(Integer.parseInt(deleteId));
                request.setAttribute("success", "Product deleted");
            }

            request.setAttribute("products", productDAO.getAllProducts());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }
}