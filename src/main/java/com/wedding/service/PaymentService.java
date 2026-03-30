package com.wedding.service;

import com.wedding.model.PackageType;
import com.wedding.model.Payment;
import com.wedding.model.PaymentStatus;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
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
 * Payment / package CRUD backed by MySQL.
 */
public class PaymentService {

    private final DataSource dataSource;

    public PaymentService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Payment> listAll() throws IOException {
        String sql = "SELECT id, booking_id, user_id, package_type, amount, status, created_at FROM payments ORDER BY created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Payment> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapRow(rs));
            }
            return out;
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public List<Payment> listByUser(long userId) throws IOException {
        return listAll().stream().filter(p -> p.getUserId() == userId).collect(Collectors.toList());
    }

    public Optional<Payment> findById(long id) throws IOException {
        String sql = "SELECT id, booking_id, user_id, package_type, amount, status, created_at FROM payments WHERE id = ?";
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

    public Optional<String> create(long bookingId, long userId, PackageType packageType, BigDecimal amount) throws IOException {
        Optional<String> v = validate(amount, packageType);
        if (v.isPresent()) {
            return v;
        }
        String sql = "INSERT INTO payments (booking_id, user_id, package_type, amount, status, created_at) VALUES (?,?,?,?,?,?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, bookingId);
            ps.setLong(2, userId);
            ps.setString(3, packageType.name());
            ps.setBigDecimal(4, amount);
            ps.setString(5, PaymentStatus.PENDING.name());
            ps.setDate(6, Date.valueOf(LocalDate.now()));
            ps.executeUpdate();
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> update(long paymentId, PackageType packageType, BigDecimal amount, PaymentStatus status) throws IOException {
        Optional<String> v = validate(amount, packageType);
        if (v.isPresent()) {
            return v;
        }
        String sql = "UPDATE payments SET package_type=?, amount=?, status=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, packageType.name());
            ps.setBigDecimal(2, amount);
            ps.setString(3, status.name());
            ps.setLong(4, paymentId);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Payment not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> delete(long paymentId) throws IOException {
        String sql = "DELETE FROM payments WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, paymentId);
            if (ps.executeUpdate() == 0) {
                return Optional.of("Payment not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    private Optional<String> validate(BigDecimal amount, PackageType packageType) {
        if (packageType == null) {
            return Optional.of("Package type is required.");
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return Optional.of("Amount must be greater than zero.");
        }
        return Optional.empty();
    }

    private static Payment mapRow(ResultSet rs) throws SQLException {
        return new Payment(
                rs.getLong("id"),
                rs.getLong("booking_id"),
                rs.getLong("user_id"),
                PackageType.valueOf(rs.getString("package_type")),
                rs.getBigDecimal("amount"),
                PaymentStatus.valueOf(rs.getString("status")),
                rs.getDate("created_at").toLocalDate()
        );
    }
}
