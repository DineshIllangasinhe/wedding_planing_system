package com.wedding.controller;

import com.wedding.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String qs = req.getQueryString();
        String loc = req.getContextPath() + "/login.jsp" + (qs != null && !qs.isBlank() ? "?" + qs : "");
        resp.sendRedirect(loc);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String next = req.getParameter("next");
        if (username == null || password == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=missing");
            return;
        }
        try {
            UserService users = new UserService(dataSource(getServletContext()));
            var auth = users.authenticate(username, password);
            if (auth.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/login?error=credentials");
                return;
            }
            HttpSession session = req.getSession(true);
            session.setAttribute(SESSION_USER, auth.get());
            String target = safeNext(req.getContextPath(), next);
            resp.sendRedirect(target);
        } catch (Exception e) {
            getServletContext().log("Login failed", e);
            Throwable t = e;
            while (t.getCause() != null && t.getCause() != t) {
                t = t.getCause();
            }
            getServletContext().log("Root cause: " + t.getClass().getName() + ": " + t.getMessage());
            if (!resp.isCommitted()) {
                resp.sendRedirect(req.getContextPath() + "/login?error=server");
            }
        }
    }

    private static String safeNext(String contextPath, String next) {
        if (next == null || next.isBlank()) {
            return contextPath + "/dashboard";
        }
        try {
            String decoded = URLDecoder.decode(next, StandardCharsets.UTF_8);
            if (decoded.startsWith("/") && !decoded.startsWith("//") && !decoded.contains("\r") && !decoded.contains("\n")) {
                return contextPath + decoded;
            }
        } catch (Exception ignored) {
        }
        return contextPath + "/dashboard";
    }
}
