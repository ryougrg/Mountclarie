package com.himalayan.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/error")
public class ErrorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String errorType = request.getParameter("type");
        String errorMsg = request.getParameter("message");

        if (errorType != null) {
            if ("unauthorized".equals(errorType)) {
                request.setAttribute("error", "Access Denied - Admin privileges required");
            } else if ("notfound".equals(errorType)) {
                request.setAttribute("error", "Page Not Found");
            } else if ("access".equals(errorType)) {
                request.setAttribute("error", "Please login to access this page");
            }
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
        }

        // If no specific error set, set a default
        if (request.getAttribute("error") == null) {
            request.setAttribute("error", "An error occurred");
        }

        request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}