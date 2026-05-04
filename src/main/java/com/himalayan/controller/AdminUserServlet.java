package com.himalayan.controller;

import com.himalayan.dao.UserDAO;
import com.himalayan.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String userIdParam = request.getParameter("id");

        try {
            if ("approve".equals(action) && userIdParam != null) {
                int userId = Integer.parseInt(userIdParam);
                boolean approved = userDAO.approveUser(userId);

                if (approved) {
                    request.setAttribute("success", "User approved successfully!");
                } else {
                    request.setAttribute("error", "Failed to approve user.");
                }
            }

            // Get all unapproved users
            List<User> pendingUsers = userDAO.getUnapprovedUsers();
            request.setAttribute("pendingUsers", pendingUsers);

            // Also get all approved users for reference
            List<User> approvedUsers = userDAO.getAllApprovedUsers();
            request.setAttribute("approvedUsers", approvedUsers);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);  // Changed to /admin/users.jsp
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("approveMultiple".equals(action)) {
            String[] userIds = request.getParameterValues("userIds");
            if (userIds != null) {
                int approvedCount = 0;
                for (String id : userIds) {
                    try {
                        if (userDAO.approveUser(Integer.parseInt(id))) {
                            approvedCount++;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                request.setAttribute("success", approvedCount + " user(s) approved successfully!");
            }
        }

        // Refresh the list
        try {
            List<User> pendingUsers = userDAO.getUnapprovedUsers();
            request.setAttribute("pendingUsers", pendingUsers);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
}