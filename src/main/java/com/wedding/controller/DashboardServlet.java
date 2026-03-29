package com.wedding.controller;

import com.wedding.model.Booking;
import com.wedding.model.BookingStatus;
import com.wedding.model.Payment;
import com.wedding.model.PaymentStatus;
import com.wedding.model.User;
import com.wedding.model.Vendor;
import com.wedding.service.BookingService;
import com.wedding.service.PaymentService;
import com.wedding.service.VendorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireLogin(req, resp)) {
            return;
        }
        User u = currentUser(req);
        try {
            BookingService bookings = new BookingService(dataDir(getServletContext()));
            PaymentService payments = new PaymentService(dataDir(getServletContext()));
            VendorService vendors = new VendorService(dataDir(getServletContext()));
            List<Booking> history = bookings.bookingHistoryForUser(u.getId(), true);
            List<Payment> payList = u.isAdmin()
                    ? payments.listAll()
                    : payments.listByUser(u.getId());
            Map<Long, Vendor> vendorMap = new HashMap<>();
            for (Vendor v : vendors.listAll()) {
                vendorMap.put(v.getId(), v);
            }
            BigDecimal totalPaid = payList.stream()
                    .filter(p -> p.getStatus() == PaymentStatus.PAID)
                    .map(Payment::getAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            req.setAttribute("bookingHistory", history);
            req.setAttribute("payments", payList);
            req.setAttribute("vendorMap", vendorMap);
            req.setAttribute("totalPaid", totalPaid);
            req.setAttribute("upcoming", history.stream()
                    .filter(b -> b.getStatus() == BookingStatus.CONFIRMED || b.getStatus() == BookingStatus.PENDING)
                    .limit(5)
                    .collect(Collectors.toList()));
            req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp").forward(req, resp);
        } catch (IOException e) {
            throw new ServletException(e);
        }
    }
}
