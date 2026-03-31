package com.wedding.controller;

import com.wedding.model.User;
import com.wedding.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireLogin(req, resp)) {
            return;
        }
        req.setAttribute("profileUser", currentUser(req));
        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireLogin(req, resp)) {
            return;
        }
        String action = req.getParameter("action");
        User u = currentUser(req);
        try {
            UserService users = new UserService(dataSource(getServletContext()));
            if ("delete".equals(action)) {
                // Self-service delete (CRUD -> Delete) for currently logged-in user.
                var err = users.delete(u.getId());
                if (err.isPresent()) {
                    req.setAttribute("formError", err.get());
                    req.setAttribute("profileUser", u);
                    req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, resp);
                    return;
                }
                HttpSession s = req.getSession(false);
                if (s != null) {
                    s.invalidate();
                }
                resp.sendRedirect(req.getContextPath() + "/index.jsp?deleted=1");
                return;
            }
            String email = req.getParameter("email");
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            String newPassword = req.getParameter("newPassword");
            // Self-service update (CRUD -> Update) with validation in UserService.
            var err = users.update(u.getId(), email, fullName, phone, newPassword);
            if (err.isPresent()) {
                req.setAttribute("formError", err.get());
                User refreshed = users.findById(u.getId()).orElse(u);
                req.setAttribute("profileUser", refreshed);
                req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, resp);
                return;
            }
            User refreshed = users.findById(u.getId()).orElse(u);
            req.getSession().setAttribute(SESSION_USER, refreshed);
            resp.sendRedirect(req.getContextPath() + "/profile?saved=1");
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }
}
