package com.himalayan.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Utility class for handling HTTP cookies in Jakarta Servlet environment.
 */
public class CookieUtil {

    /**
     * Add a cookie to the response with specified name, value, and max age.
     */
    public static void addCookie(HttpServletResponse response,
                                 String name,
                                 String value,
                                 int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAgeSeconds);
        cookie.setPath("/");  // Available across entire application
        cookie.setHttpOnly(true);  // Security: prevent JavaScript access
        // cookie.setSecure(true); // Uncomment if using HTTPS
        response.addCookie(cookie);
    }

    /**
     * Get cookie value by name from the request.
     * Returns null if cookie not found.
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(name)) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * Delete a cookie by setting its max age to 0.
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    /**
     * Check if a cookie exists in the request.
     */
    public static boolean hasCookie(HttpServletRequest request, String name) {
        return getCookieValue(request, name) != null;
    }
}