package com.himalayan.controller;

import com.himalayan.dao.UserDao;
import com.himalayan.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.loginUser(email, password);

            if (user != null) {
                // Check if approved
                if (!user.isApproved() && !user.getRole().equals("admin")) {
                    request.setAttribute("error", "Your account is pending admin approval");
                    request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                    return;
                }

                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60);

                // Set cookie (7 days)
                Cookie loginCookie = new Cookie("userEmail", email);
                loginCookie.setMaxAge(7 * 24 * 60 * 60);
                response.addCookie(loginCookie);

                // Redirect based on role
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("admin/admin-user-dashboard.jsp");
                } else {
                    response.sendRedirect("user/admin-user-dashboard.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
}