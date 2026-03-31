package com.wedding.controller;

import com.wedding.model.User;
import com.wedding.model.UserRole;
import com.wedding.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

/**
 * Admin-only user directory (list/search/filter/delete users).
 *
 * <p>Viva note:
 * demonstrates role-based authorization + admin CRUD operations separated
 * from self-service profile operations.</p>
 */
@WebServlet("/admin/users")
public class UserAdminServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) {
            return;
        }
        try {
            UserService users = new UserService(dataSource(getServletContext()));
            // Read operation with server-side filtering (query + role).
            List<User> filtered = filterUsers(users.listAll(), req.getParameter("q"), req.getParameter("role"));
            req.setAttribute("allUsers", filtered);
            req.setAttribute("searchQuery", req.getParameter("q") == null ? "" : req.getParameter("q").trim());
            req.setAttribute("roleFilter", normalizeRole(req.getParameter("role")));
            req.setAttribute("roles", UserRole.values());
            req.getRequestDispatcher("/WEB-INF/jsp/admin-users.jsp").forward(req, resp);
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) {
            return;
        }
        String action = req.getParameter("action");
        User admin = currentUser(req);
        try {
            UserService users = new UserService(dataSource(getServletContext()));
            if ("delete".equals(action)) {
                // Delete operation with safety rule: admin cannot remove own account here.
                long id = requiredPositiveLongParam(req, "userId");
                if (id == admin.getId()) {
                    req.setAttribute("flashError", "You cannot delete your own administrator account from this screen.");
                    bindFilteredUsers(req, users);
                    req.getRequestDispatcher("/WEB-INF/jsp/admin-users.jsp").forward(req, resp);
                    return;
                }
                var err = users.delete(id);
                if (err.isPresent()) {
                    req.setAttribute("flashError", err.get());
                } else {
                    req.setAttribute("flashSuccess", "User deleted.");
                }
                bindFilteredUsers(req, users);
                req.getRequestDispatcher("/WEB-INF/jsp/admin-users.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (RuntimeException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=invalid");
        }
    }

    private void bindFilteredUsers(HttpServletRequest req, UserService users) throws IOException {
        List<User> filtered = filterUsers(users.listAll(), req.getParameter("q"), req.getParameter("role"));
        req.setAttribute("allUsers", filtered);
        req.setAttribute("searchQuery", req.getParameter("q") == null ? "" : req.getParameter("q").trim());
        req.setAttribute("roleFilter", normalizeRole(req.getParameter("role")));
        req.setAttribute("roles", UserRole.values());
    }

    private static List<User> filterUsers(List<User> users, String q, String role) {
        String query = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        String normalizedRole = normalizeRole(role);
        return users.stream()
                .filter(u -> normalizedRole.isEmpty() || u.getRole().name().equals(normalizedRole))
                .filter(u -> query.isEmpty()
                        || u.getUsername().toLowerCase(Locale.ROOT).contains(query)
                        || u.getFullName().toLowerCase(Locale.ROOT).contains(query)
                        || u.getEmail().toLowerCase(Locale.ROOT).contains(query)
                        || u.getPhone().toLowerCase(Locale.ROOT).contains(query))
                .collect(Collectors.toList());
    }

    private static String normalizeRole(String role) {
        if (role == null || role.isBlank()) {
            return "";
        }
        try {
            return UserRole.valueOf(role.trim().toUpperCase(Locale.ROOT)).name();
        } catch (IllegalArgumentException ignored) {
            return "";
        }
    }
}
