package com.wedding.controller;

import com.wedding.model.Booking;
import com.wedding.model.BookingStatus;
import com.wedding.model.User;
import com.wedding.model.Vendor;
import com.wedding.service.BookingService;
import com.wedding.service.VendorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/bookings")
public class BookingServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireLogin(req, resp)) {
            return;
        }
        User u = currentUser(req);
        try {
            BookingService bookings = new BookingService(dataDir(getServletContext()));
            VendorService vendors = new VendorService(dataDir(getServletContext()));
            List<Booking> list = u.isAdmin() ? bookings.listAll() : bookings.listByUser(u.getId());
            Map<Long, Vendor> vendorMap = new HashMap<>();
            for (Vendor v : vendors.listAll()) {
                vendorMap.put(v.getId(), v);
            }
            req.setAttribute("bookings", list);
            req.setAttribute("vendors", vendors.listAll());
            req.setAttribute("vendorMap", vendorMap);
            req.setAttribute("statuses", BookingStatus.values());
            String edit = req.getParameter("edit");
            if (edit != null && !edit.isBlank()) {
                long id = Long.parseLong(edit);
                bookings.findById(id).ifPresent(b -> {
                    if (u.isAdmin() || b.getUserId() == u.getId()) {
                        req.setAttribute("editBooking", b);
                    }
                });
            }
            req.getRequestDispatcher("/WEB-INF/jsp/bookings.jsp").forward(req, resp);
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/bookings");
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
            BookingService bookings = new BookingService(dataDir(getServletContext()));
            if ("cancel".equals(action)) {
                long id = Long.parseLong(req.getParameter("bookingId"));
                Booking b = bookings.findById(id).orElse(null);
                if (b == null || (!u.isAdmin() && b.getUserId() != u.getId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                var err = bookings.cancel(id);
                redirectWithFlash(req, resp, err, "Booking cancelled.");
                return;
            }
            if ("delete".equals(action) && u.isAdmin()) {
                long id = Long.parseLong(req.getParameter("bookingId"));
                var err = bookings.deleteHard(id);
                redirectWithFlash(req, resp, err, "Booking deleted.");
                return;
            }
            if ("update".equals(action)) {
                long id = Long.parseLong(req.getParameter("bookingId"));
                Booking existing = bookings.findById(id).orElse(null);
                if (existing == null || (!u.isAdmin() && existing.getUserId() != u.getId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                long vendorId = Long.parseLong(req.getParameter("vendorId"));
                LocalDate date = LocalDate.parse(req.getParameter("eventDate"));
                BookingStatus status = BookingStatus.valueOf(req.getParameter("status").trim().toUpperCase());
                String notes = req.getParameter("notes");
                var err = bookings.update(id, vendorId, date, status, notes);
                redirectWithFlash(req, resp, err, "Booking updated.");
                return;
            }
            if ("create".equals(action)) {
                long vendorId = Long.parseLong(req.getParameter("vendorId"));
                LocalDate date = LocalDate.parse(req.getParameter("eventDate"));
                String notes = req.getParameter("notes");
                var err = bookings.create(u.getId(), vendorId, date, notes);
                redirectWithFlash(req, resp, err, "Booking request submitted.");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/bookings");
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/bookings?error=invalid");
        }
    }

    private void redirectWithFlash(HttpServletRequest req, HttpServletResponse resp,
                                   java.util.Optional<String> err, String ok) throws IOException {
        if (err.isPresent()) {
            resp.sendRedirect(req.getContextPath() + "/bookings?error=" + java.net.URLEncoder.encode(err.get(), java.nio.charset.StandardCharsets.UTF_8));
        } else {
            resp.sendRedirect(req.getContextPath() + "/bookings?ok=" + java.net.URLEncoder.encode(ok, java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
