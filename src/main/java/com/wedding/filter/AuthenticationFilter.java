package com.wedding.filter;

import com.wedding.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Protects authenticated areas; redirects guests to login with return URL.
 */
@WebFilter(urlPatterns = {
        "/dashboard", "/bookings", "/payments", "/profile"
})
public class AuthenticationFilter implements Filter {

    private static final String SESSION_USER = "currentUser";

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute(SESSION_USER);
        if (u == null) {
            String uri = req.getRequestURI();
            String qs = req.getQueryString();
            if (qs != null) {
                uri += "?" + qs;
            }
            String next = URLEncoder.encode(uri, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/login?next=" + next);
            return;
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
