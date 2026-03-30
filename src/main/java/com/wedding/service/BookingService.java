package com.wedding.service;

import com.wedding.model.Booking;
import com.wedding.model.BookingStatus;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Booking CRUD with double-booking prevention for active statuses (MySQL).
 */
public class BookingService {

    private final DataSource dataSource;

    public BookingService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Booking> listAll() throws IOException {
        String sql = "SELECT id, user_id, vendor_id, event_date, status, notes, created_at FROM bookings ORDER BY event_date DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Booking> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapRow(rs));
            }
            return out;
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public List<Booking> listByUser(long userId) throws IOException {
        return listAll().stream()
                .filter(b -> b.getUserId() == userId)
                .collect(Collectors.toList());
    }

    public List<Booking> bookingHistoryForUser(long userId, boolean includeCancelled) throws IOException {
        return listByUser(userId).stream()
                .filter(b -> includeCancelled || b.getStatus() != BookingStatus.CANCELLED)
                .collect(Collectors.toList());
    }

    public Optional<Booking> findById(long id) throws IOException {
        String sql = "SELECT id, user_id, vendor_id, event_date, status, notes, created_at FROM bookings WHERE id = ?";
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

    public Optional<String> create(long userId, long vendorId, LocalDate eventDate, String notes) throws IOException {
        Optional<String> v = validate(eventDate, notes);
        if (v.isPresent()) {
            return v;
        }
        if (hasVendorDateConflict(vendorId, eventDate, -1)) {
            return Optional.of("This vendor is already booked on the selected date. Please choose another date or vendor.");
        }
        String sql = "INSERT INTO bookings (user_id, vendor_id, event_date, status, notes, created_at) VALUES (?,?,?,?,?,?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, userId);
            ps.setLong(2, vendorId);
            ps.setDate(3, Date.valueOf(eventDate));
            ps.setString(4, BookingStatus.PENDING.name());
            ps.setString(5, notes != null ? notes.trim() : "");
            ps.setDate(6, Date.valueOf(LocalDate.now()));
            ps.executeUpdate();
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> update(long bookingId, long vendorId, LocalDate eventDate,
                                   BookingStatus status, String notes) throws IOException {
        Optional<String> v = validate(eventDate, notes);
        if (v.isPresent()) {
            return v;
        }
        if (status != BookingStatus.CANCELLED && hasVendorDateConflict(vendorId, eventDate, bookingId)) {
            return Optional.of("This vendor is already booked on the selected date.");
        }
        String sql = "UPDATE bookings SET vendor_id=?, event_date=?, status=?, notes=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, vendorId);
            ps.setDate(2, Date.valueOf(eventDate));
            ps.setString(3, status.name());
            ps.setString(4, notes != null ? notes.trim() : "");
            ps.setLong(5, bookingId);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Booking not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> cancel(long bookingId) throws IOException {
        return updateStatus(bookingId, BookingStatus.CANCELLED);
    }

    public Optional<String> deleteHard(long bookingId) throws IOException {
        String sql = "DELETE FROM bookings WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, bookingId);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Booking not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    private Optional<String> updateStatus(long bookingId, BookingStatus status) throws IOException {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setLong(2, bookingId);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Booking not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public boolean hasVendorDateConflict(long vendorId, LocalDate date, long excludeBookingId) throws IOException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE vendor_id = ? AND event_date = ? AND status <> 'CANCELLED' AND (? < 0 OR id <> ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, vendorId);
            ps.setDate(2, Date.valueOf(date));
            ps.setLong(3, excludeBookingId);
            ps.setLong(4, excludeBookingId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getLong(1) > 0;
            }
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    private Optional<String> validate(LocalDate eventDate, String notes) {
        if (eventDate == null) {
            return Optional.of("Event date is required.");
        }
        if (eventDate.isBefore(LocalDate.now())) {
            return Optional.of("Event date cannot be in the past.");
        }
        if (notes != null && notes.length() > 2000) {
            return Optional.of("Notes are too long (max 2000 characters).");
        }
        return Optional.empty();
    }

    private static Booking mapRow(ResultSet rs) throws SQLException {
        return new Booking(
                rs.getLong("id"),
                rs.getLong("user_id"),
                rs.getLong("vendor_id"),
                rs.getDate("event_date").toLocalDate(),
                BookingStatus.valueOf(rs.getString("status")),
                rs.getString("notes"),
                rs.getDate("created_at").toLocalDate()
        );
    }
}
