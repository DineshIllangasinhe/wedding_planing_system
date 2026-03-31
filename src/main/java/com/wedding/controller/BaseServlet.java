package com.wedding.controller;

import com.wedding.config.AppPaths;
import com.wedding.model.User;

import javax.servlet.http.HttpServlet;
import javax.sql.DataSource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Locale;

/**
 * Base controller class used by all feature servlets.
 *
 * <p>Viva note:
 * this is inheritance in OOP. Common behavior (session access, auth checks,
 * parameter validation) is centralized here so child servlets stay focused on
 * business use-cases (Booking, Payment, Vendor, etc.).</p>
 */
public abstract class BaseServlet extends HttpServlet {

    protected static final String SESSION_USER = "currentUser";

    protected DataSource dataSource(javax.servlet.ServletContext ctx) {
        return AppPaths.dataSource(ctx);
    }

    protected User currentUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) {
            return null;
        }
        Object u = s.getAttribute(SESSION_USER);
        return u instanceof User ? (User) u : null;
    }

    protected boolean requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (currentUser(req) == null) {
            String q = req.getRequestURI();
            if (req.getQueryString() != null) {
                q += "?" + req.getQueryString();
            }
            resp.sendRedirect(req.getContextPath() + "/login?next=" + java.net.URLEncoder.encode(q, java.nio.charset.StandardCharsets.UTF_8));
            return false;
        }
        return true;
    }

    protected boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!requireLogin(req, resp)) {
            return false;
        }
        User u = currentUser(req);
        if (u == null || !u.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Administrator access required.");
            return false;
        }
        return true;
    }

    protected String requiredParam(HttpServletRequest req, String name) {
        // Shared request validation: fail fast before service/database calls.
        String value = req.getParameter(name);
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Missing required parameter: " + name);
        }
        return value.trim();
    }

    protected long requiredPositiveLongParam(HttpServletRequest req, String name) {
        // Input contract used by CRUD IDs (create/update/delete/select).
        long value = Long.parseLong(requiredParam(req, name));
        if (value <= 0) {
            throw new IllegalArgumentException("Invalid parameter: " + name);
        }
        return value;
    }

    protected LocalDate requiredDateParam(HttpServletRequest req, String name) {
        // ISO date parsing for form fields like eventDate.
        return LocalDate.parse(requiredParam(req, name));
    }

    protected <E extends Enum<E>> E requiredEnumParam(HttpServletRequest req, String name, Class<E> enumType) {
        return Enum.valueOf(enumType, requiredParam(req, name).toUpperCase(Locale.ROOT));
    }
}
