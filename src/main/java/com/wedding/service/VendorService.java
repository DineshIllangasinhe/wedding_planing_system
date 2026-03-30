package com.wedding.service;

import com.wedding.model.Caterer;
import com.wedding.model.DecoratorVendor;
import com.wedding.model.Photographer;
import com.wedding.model.Vendor;
import com.wedding.model.VendorType;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Vendor CRUD with polymorphic rows in MySQL.
 */
public class VendorService {

    private final DataSource dataSource;

    public VendorService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Vendor> listAll() throws IOException {
        String sql = "SELECT id, vendor_type, business_name, contact_email, contact_phone, description, daily_rate, extra1, extra2 FROM vendors ORDER BY id";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Vendor> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapRow(rs));
            }
            return out;
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<Vendor> findById(long id) throws IOException {
        String sql = "SELECT id, vendor_type, business_name, contact_email, contact_phone, description, daily_rate, extra1, extra2 FROM vendors WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public List<Vendor> search(String query, VendorType typeFilter) throws IOException {
        String q = query == null ? "" : query.trim().toLowerCase(Locale.ROOT);
        return listAll().stream()
                .filter(v -> typeFilter == null || v.getType() == typeFilter)
                .filter(v -> q.isEmpty()
                        || v.getBusinessName().toLowerCase(Locale.ROOT).contains(q)
                        || v.getDescription().toLowerCase(Locale.ROOT).contains(q)
                        || v.getSpecialtySummary().toLowerCase(Locale.ROOT).contains(q))
                .collect(Collectors.toList());
    }

    public Optional<String> create(Vendor vendor) throws IOException {
        Optional<String> err = validate(vendor);
        if (err.isPresent()) {
            return err;
        }
        String sql = "INSERT INTO vendors (vendor_type, business_name, contact_email, contact_phone, description, daily_rate, extra1, extra2) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindVendor(ps, vendor, false);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    vendor.setId(keys.getLong(1));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> update(Vendor vendor) throws IOException {
        Optional<String> err = validate(vendor);
        if (err.isPresent()) {
            return err;
        }
        String sql = "UPDATE vendors SET vendor_type=?, business_name=?, contact_email=?, contact_phone=?, description=?, daily_rate=?, extra1=?, extra2=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindVendor(ps, vendor, true);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Vendor not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> delete(long id) throws IOException {
        String sql = "DELETE FROM vendors WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Vendor not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    private void bindVendor(PreparedStatement ps, Vendor v, boolean includeId) throws SQLException {
        ps.setString(1, v.getType().name());
        ps.setString(2, v.getBusinessName());
        ps.setString(3, v.getContactEmail());
        ps.setString(4, v.getContactPhone());
        ps.setString(5, v.getDescription());
        ps.setBigDecimal(6, v.getDailyRate());
        switch (v.getType()) {
            case PHOTOGRAPHER -> {
                Photographer p = (Photographer) v;
                ps.setString(7, p.getShootingStyle());
                ps.setString(8, String.valueOf(p.getIncludedHours()));
            }
            case CATERING -> {
                Caterer c = (Caterer) v;
                ps.setString(7, c.getCuisineType());
                ps.setString(8, String.valueOf(c.isIncludesStaffing()));
            }
            case DECORATION -> {
                DecoratorVendor d = (DecoratorVendor) v;
                ps.setString(7, d.getThemeFocus());
                ps.setString(8, String.valueOf(d.isProvidesFlorals()));
            }
        }
        if (includeId) {
            ps.setLong(9, v.getId());
        }
    }

    private Optional<String> validate(Vendor v) {
        if (v.getBusinessName() == null || v.getBusinessName().isBlank()) {
            return Optional.of("Business name is required.");
        }
        if (v.getContactEmail() == null || v.getContactEmail().isBlank() || !v.getContactEmail().contains("@")) {
            return Optional.of("Valid contact email is required.");
        }
        if (v.getContactPhone() == null || v.getContactPhone().isBlank()) {
            return Optional.of("Contact phone is required.");
        }
        if (v.getDescription() == null || v.getDescription().isBlank()) {
            return Optional.of("Description is required.");
        }
        if (v.getDailyRate() == null || v.getDailyRate().compareTo(BigDecimal.ZERO) <= 0) {
            return Optional.of("Daily rate must be greater than zero.");
        }
        return Optional.empty();
    }

    private Vendor mapRow(ResultSet rs) throws SQLException {
        long id = rs.getLong("id");
        VendorType type = VendorType.valueOf(rs.getString("vendor_type"));
        String name = rs.getString("business_name");
        String email = rs.getString("contact_email");
        String phone = rs.getString("contact_phone");
        String desc = rs.getString("description");
        BigDecimal rate = rs.getBigDecimal("daily_rate");
        String e1 = rs.getString("extra1");
        String e2 = rs.getString("extra2");
        return switch (type) {
            case PHOTOGRAPHER -> new Photographer(id, name, email, phone, desc, rate, e1, Integer.parseInt(e2));
            case CATERING -> new Caterer(id, name, email, phone, desc, rate, e1, Boolean.parseBoolean(e2));
            case DECORATION -> new DecoratorVendor(id, name, email, phone, desc, rate, e1, Boolean.parseBoolean(e2));
        };
    }
}
