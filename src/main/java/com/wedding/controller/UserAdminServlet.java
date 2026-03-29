package com.wedding.controller;

import com.wedding.model.User;
import com.wedding.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Admin-only user directory (view all, delete). Profile servlet covers self-service update.
 */
@WebServlet("/admin/users")
public class UserAdminServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) {
            return;
        }
        try {
            UserService users = new UserService(dataDir(getServletContext()));
            List<User> all = users.listAll();
            req.setAttribute("allUsers", all);
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
            UserService users = new UserService(dataDir(getServletContext()));
            if ("delete".equals(action)) {
                long id = Long.parseLong(req.getParameter("userId"));
                if (id == admin.getId()) {
                    req.setAttribute("flashError", "You cannot delete your own administrator account from this screen.");
                    req.setAttribute("allUsers", users.listAll());
                    req.getRequestDispatcher("/WEB-INF/jsp/admin-users.jsp").forward(req, resp);
                    return;
                }
                var err = users.delete(id);
                if (err.isPresent()) {
                    req.setAttribute("flashError", err.get());
                } else {
                    req.setAttribute("flashSuccess", "User deleted.");
                }
                req.setAttribute("allUsers", users.listAll());
                req.getRequestDispatcher("/WEB-INF/jsp/admin-users.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }
}
