package com.wedding.controller;

import com.wedding.model.Caterer;
import com.wedding.model.DecoratorVendor;
import com.wedding.model.Photographer;
import com.wedding.model.User;
import com.wedding.model.Vendor;
import com.wedding.model.VendorType;
import com.wedding.service.VendorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/vendors")
public class VendorServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = currentUser(req);
        String search = req.getParameter("search");
        String typeParam = req.getParameter("type");
        VendorType filter = null;
        if (typeParam != null && !typeParam.isBlank()) {
            try {
                filter = VendorType.valueOf(typeParam.trim().toUpperCase());
            } catch (IllegalArgumentException ignored) {
            }
        }
        try {
            VendorService vendors = new VendorService(dataSource(getServletContext()));
            var list = vendors.search(search, filter);
            req.setAttribute("vendors", list);
            req.setAttribute("search", search == null ? "" : search);
            req.setAttribute("typeFilter", filter);
            req.setAttribute("typeFilterParam", filter == null ? "" : filter.name());
            req.setAttribute("currentUser", u);
            String editId = req.getParameter("edit");
            if (editId != null && !editId.isBlank() && u != null && u.isAdmin()) {
                long id = Long.parseLong(editId);
                vendors.findById(id).ifPresent(v -> req.setAttribute("editVendor", v));
            }
            req.getRequestDispatcher("/WEB-INF/jsp/vendors.jsp").forward(req, resp);
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/vendors");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) {
            return;
        }
        String action = req.getParameter("action");
        try {
            VendorService vendors = new VendorService(dataSource(getServletContext()));
            if ("delete".equals(action)) {
                long id = Long.parseLong(req.getParameter("id"));
                var err = vendors.delete(id);
                if (err.isPresent()) {
                    req.setAttribute("flashError", err.get());
                } else {
                    req.setAttribute("flashSuccess", "Vendor removed.");
                }
                forwardList(req, resp, vendors);
                return;
            }
            if (!"save".equals(action)) {
                resp.sendRedirect(req.getContextPath() + "/vendors");
                return;
            }
            Vendor v = buildVendorFromRequest(req);
            String idStr = req.getParameter("id");
            var err = idStr == null || idStr.isBlank()
                    ? vendors.create(v)
                    : vendors.update(withId(v, Long.parseLong(idStr)));
            if (err.isPresent()) {
                req.setAttribute("flashError", err.get());
                if (idStr != null && !idStr.isBlank()) {
                    v.setId(Long.parseLong(idStr));
                }
                req.setAttribute("editVendor", v);
            } else {
                req.setAttribute("flashSuccess", "Vendor saved.");
            }
            forwardList(req, resp, vendors);
        } catch (IOException e) {
            throw new ServletException(e);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/vendors");
        }
    }

    private void forwardList(HttpServletRequest req, HttpServletResponse resp, VendorService vendors)
            throws ServletException, IOException {
        req.setAttribute("vendors", vendors.search("", null));
        req.setAttribute("typeFilterParam", "");
        req.setAttribute("search", "");
        req.setAttribute("currentUser", currentUser(req));
        req.getRequestDispatcher("/WEB-INF/jsp/vendors.jsp").forward(req, resp);
    }

    private static Vendor withId(Vendor v, long id) {
        v.setId(id);
        return v;
    }

    private static Vendor buildVendorFromRequest(HttpServletRequest req) {
        VendorType type = VendorType.valueOf(req.getParameter("vendorType").trim().toUpperCase());
        String name = req.getParameter("businessName");
        String email = req.getParameter("contactEmail");
        String phone = req.getParameter("contactPhone");
        String desc = req.getParameter("description");
        BigDecimal rate = new BigDecimal(req.getParameter("dailyRate").trim());
        int hours = 8;
        String ih = req.getParameter("includedHours");
        if (ih != null && !ih.isBlank()) {
            hours = Integer.parseInt(ih.trim());
        }
        return switch (type) {
            case PHOTOGRAPHER -> new Photographer(
                    0,
                    name,
                    email,
                    phone,
                    desc,
                    rate,
                    req.getParameter("shootingStyle"),
                    hours
            );
            case CATERING -> new Caterer(
                    0,
                    name,
                    email,
                    phone,
                    desc,
                    rate,
                    req.getParameter("cuisineType"),
                    "on".equalsIgnoreCase(req.getParameter("includesStaffing"))
            );
            case DECORATION -> new DecoratorVendor(
                    0,
                    name,
                    email,
                    phone,
                    desc,
                    rate,
                    req.getParameter("themeFocus"),
                    "on".equalsIgnoreCase(req.getParameter("providesFlorals"))
            );
        };
    }
}
