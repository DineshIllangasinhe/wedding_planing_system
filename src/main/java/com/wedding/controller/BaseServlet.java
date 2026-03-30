package com.wedding.controller;

import com.wedding.config.AppPaths;
import com.wedding.model.User;

import javax.servlet.http.HttpServlet;
import javax.sql.DataSource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Shared helpers for authentication-aware servlets.
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
}
