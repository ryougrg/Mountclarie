package com.himalayan.controller.filter;

import com.himalayan.model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // DEBUG - Print the path being accessed
        System.out.println("=== AUTHFILTER DEBUG ===");
        System.out.println("Full URI: " + uri);
        System.out.println("Context Path: " + contextPath);
        System.out.println("Extracted Path: '" + path + "'");
        System.out.println("=======================");

        // PUBLIC PATHS - Anyone can access these WITHOUT logging in
        if (path.equals("/login") ||
                path.equals("/register") ||
                path.equals("/error") ||
                path.startsWith("/static/") ||
                path.startsWith("/css/") ||
                path.startsWith("/images/")) {
            System.out.println("PUBLIC PATH - Allowing access");
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Not logged in - redirect to login page
        if (user == null) {
            System.out.println("NOT LOGGED IN - Redirecting to /login");
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Admin area access check - only admin can access /admin/*
        if (path.startsWith("/admin/") && !"admin".equals(user.getRole())) {
            System.out.println("ADMIN ACCESS DENIED - Redirecting to error");
            res.sendRedirect(contextPath + "/error?type=unauthorized&message=Admin privileges required");
            return;
        }

        // User area access check - regular users can access /user/*
        if (path.startsWith("/user/") && !"user".equals(user.getRole())) {
            System.out.println("USER ACCESS DENIED - Redirecting to error");
            res.sendRedirect(contextPath + "/error?type=unauthorized&message=Access denied");
            return;
        }

        System.out.println("ALLOWING ACCESS - Chain continues");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}