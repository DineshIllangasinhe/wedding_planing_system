package com.wedding.controller;

import com.wedding.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        try {
            UserService users = new UserService(dataSource(getServletContext()));
            var err = users.register(username, password, email, fullName, phone);
            if (err.isPresent()) {
                req.setAttribute("formError", err.get());
                req.setAttribute("username", username);
                req.setAttribute("email", email);
                req.setAttribute("fullName", fullName);
                req.setAttribute("phone", phone);
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }
}
