package com.wedding.controller;

import com.wedding.model.Booking;
import com.wedding.model.PackageType;
import com.wedding.model.Payment;
import com.wedding.model.PaymentStatus;
import com.wedding.model.User;
import com.wedding.service.BookingService;
import com.wedding.service.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/payments")
public class PaymentServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireLogin(req, resp)) {
            return;
        }
        User u = currentUser(req);
        try {
            PaymentService payments = new PaymentService(dataSource(getServletContext()));
            BookingService bookings = new BookingService(dataSource(getServletContext()));
            List<Payment> list = u.isAdmin() ? payments.listAll() : payments.listByUser(u.getId());
            List<Booking> bookingChoices = u.isAdmin()
                    ? bookings.listAll()
                    : bookings.listByUser(u.getId());
            req.setAttribute("payments", list);
            req.setAttribute("bookingChoices", bookingChoices);
            req.setAttribute("packageTypes", PackageType.values());
            req.setAttribute("paymentStatuses", PaymentStatus.values());
            String edit = req.getParameter("edit");
            if (edit != null && !edit.isBlank()) {
                long id = Long.parseLong(edit);
                payments.findById(id).ifPresent(p -> {
                    if (u.isAdmin() || p.getUserId() == u.getId()) {
                        req.setAttribute("editPayment", p);
                    }
                });
            }
            req.getRequestDispatcher("/WEB-INF/jsp/payments.jsp").forward(req, resp);
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/payments");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireLogin(req, resp)) {
            return;
        }
        User u = currentUser(req);
        String action = req.getParameter("action");
        try {
            PaymentService payments = new PaymentService(dataSource(getServletContext()));
            BookingService bookings = new BookingService(dataSource(getServletContext()));
            if ("delete".equals(action)) {
                if (!u.isAdmin()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                long id = Long.parseLong(req.getParameter("paymentId"));
                var err = payments.delete(id);
                redirect(req, resp, err, "Payment record deleted.");
                return;
            }
            if ("update".equals(action)) {
                long id = Long.parseLong(req.getParameter("paymentId"));
                Payment existing = payments.findById(id).orElse(null);
                if (existing == null || (!u.isAdmin() && existing.getUserId() != u.getId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                PackageType pkg = PackageType.valueOf(req.getParameter("packageType").trim().toUpperCase());
                BigDecimal amount = new BigDecimal(req.getParameter("amount").trim());
                PaymentStatus status = PaymentStatus.valueOf(req.getParameter("status").trim().toUpperCase());
                if (!u.isAdmin() && status != existing.getStatus()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                var err = payments.update(id, pkg, amount, u.isAdmin() ? status : existing.getStatus());
                redirect(req, resp, err, "Payment updated.");
                return;
            }
            if ("create".equals(action)) {
                long bookingId = Long.parseLong(req.getParameter("bookingId"));
                Booking b = bookings.findById(bookingId).orElse(null);
                if (b == null || (!u.isAdmin() && b.getUserId() != u.getId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                long payerId = u.isAdmin() ? b.getUserId() : u.getId();
                PackageType pkg = PackageType.valueOf(req.getParameter("packageType").trim().toUpperCase());
                BigDecimal amount = new BigDecimal(req.getParameter("amount").trim());
                var err = payments.create(bookingId, payerId, pkg, amount);
                redirect(req, resp, err, "Payment record created.");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/payments");
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/payments?error=invalid");
        }
    }

    private void redirect(HttpServletRequest req, HttpServletResponse resp,
                          java.util.Optional<String> err, String ok) throws IOException {
        if (err.isPresent()) {
            resp.sendRedirect(req.getContextPath() + "/payments?error=" + java.net.URLEncoder.encode(err.get(), java.nio.charset.StandardCharsets.UTF_8));
        } else {
            resp.sendRedirect(req.getContextPath() + "/payments?ok=" + java.net.URLEncoder.encode(ok, java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
