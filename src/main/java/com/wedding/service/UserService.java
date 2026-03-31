package com.wedding.service;

import com.wedding.model.User;
import com.wedding.model.UserRole;
import com.wedding.util.PasswordUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;

/**
 * User service (CRUD + authentication).
 *
 * <p>Viva note:
 * this layer encapsulates user-related business rules (validation, password hashing,
 * role assignment) and keeps servlet controllers thin.</p>
 */
public class UserService {

    private final DataSource dataSource;

    public UserService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<User> listAll() throws IOException {
        String sql = "SELECT id, username, password_hash, email, full_name, phone, `role`, created_at FROM users ORDER BY id";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<User> out = new ArrayList<>();
            while (rs.next()) {
                out.add(mapRow(rs));
            }
            return out;
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<User> findById(long id) throws IOException {
        String sql = "SELECT id, username, password_hash, email, full_name, phone, `role`, created_at FROM users WHERE id = ?";
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

    public Optional<User> findByUsername(String username) throws IOException {
        if (username == null) {
            return Optional.empty();
        }
        String key = username.trim().toLowerCase(Locale.ROOT);
        String sql = "SELECT id, username, password_hash, email, full_name, phone, `role`, created_at FROM users WHERE LOWER(username) = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
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

    public Optional<String> register(String username, String plainPassword, String email,
                                     String fullName, String phone) throws IOException {
        // Shared validation before CREATE.
        Optional<String> v = validateUserFields(username, email, fullName, phone, plainPassword, true);
        if (v.isPresent()) {
            return v;
        }
        if (findByUsername(username).isPresent()) {
            return Optional.of("That username is already taken.");
        }
        UserRole role;
        try (Connection conn = dataSource.getConnection();
             PreparedStatement countPs = conn.prepareStatement("SELECT COUNT(*) FROM users");
             ResultSet crs = countPs.executeQuery()) {
            crs.next();
            // First user bootstrap rule: first account becomes ADMIN.
            role = crs.getLong(1) == 0 ? UserRole.ADMIN : UserRole.CUSTOMER;
        } catch (SQLException e) {
            throw new IOException(e);
        }
        String hash = PasswordUtil.hash(username.trim(), plainPassword);
        // Security: persist hash only (never plain-text password).
        String sql = "INSERT INTO users (username, password_hash, email, full_name, phone, `role`, created_at) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username.trim());
            ps.setString(2, hash);
            ps.setString(3, email.trim());
            ps.setString(4, fullName.trim());
            ps.setString(5, phone.trim());
            ps.setString(6, role.name());
            ps.setDate(7, Date.valueOf(LocalDate.now()));
            ps.executeUpdate();
            return Optional.empty();
        } catch (SQLIntegrityConstraintViolationException e) {
            return Optional.of("That username is already taken.");
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> update(long id, String email, String fullName, String phone,
                                   String newPasswordOrBlank) throws IOException {
        // Reuse validation for UPDATE to keep consistency with CREATE rules.
        Optional<String> v = validateUserFields("x", email, fullName, phone, newPasswordOrBlank, false);
        if (v.isPresent()) {
            return v;
        }
        Optional<User> existing = findById(id);
        if (existing.isEmpty()) {
            return Optional.of("User not found.");
        }
        User u = existing.get();
        boolean changePw = newPasswordOrBlank != null && !newPasswordOrBlank.isBlank();
        // Dynamic SQL: include password update only when user entered a new one.
        String sql = changePw
                ? "UPDATE users SET email=?, full_name=?, phone=?, password_hash=? WHERE id=?"
                : "UPDATE users SET email=?, full_name=?, phone=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setString(2, fullName.trim());
            ps.setString(3, phone.trim());
            if (changePw) {
                ps.setString(4, PasswordUtil.hash(u.getUsername(), newPasswordOrBlank));
                ps.setLong(5, id);
            } else {
                ps.setLong(4, id);
            }
            if (ps.executeUpdate() == 0) {
                return Optional.of("User not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<String> delete(long id) throws IOException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            if (ps.executeUpdate() == 0) {
                return Optional.of("User not found.");
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new IOException(e);
        }
    }

    public Optional<User> authenticate(String username, String plainPassword) throws IOException {
        // Auth flow: fetch by username then verify salted hash.
        Optional<User> u = findByUsername(username);
        if (u.isEmpty()) {
            return Optional.empty();
        }
        if (!PasswordUtil.matches(u.get().getUsername(), plainPassword, u.get().getPasswordHash())) {
            return Optional.empty();
        }
        return u;
    }

    private static User mapRow(ResultSet rs) throws SQLException {
        String roleStr = rs.getString("role");
        if (roleStr == null || roleStr.isBlank()) {
            throw new SQLException("users.role is null or blank for id=" + rs.getLong("id"));
        }
        UserRole role;
        try {
            role = UserRole.valueOf(roleStr.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new SQLException("Invalid users.role value: " + roleStr, ex);
        }
        java.sql.Date created = rs.getDate("created_at");
        if (created == null) {
            throw new SQLException("users.created_at is null for id=" + rs.getLong("id"));
        }
        return new User(
                rs.getLong("id"),
                Objects.requireNonNullElse(rs.getString("username"), ""),
                Objects.requireNonNullElse(rs.getString("password_hash"), ""),
                Objects.requireNonNullElse(rs.getString("email"), ""),
                Objects.requireNonNullElse(rs.getString("full_name"), ""),
                Objects.requireNonNullElse(rs.getString("phone"), ""),
                role,
                created.toLocalDate()
        );
    }

    private Optional<String> validateUserFields(String username, String email, String fullName,
                                                String phone, String password, boolean requirePassword) {
        if (requirePassword) {
            if (username == null || username.isBlank()) {
                return Optional.of("Username is required.");
            }
            if (username.length() < 3) {
                return Optional.of("Username must be at least 3 characters.");
            }
            if (password == null || password.length() < 6) {
                return Optional.of("Password must be at least 6 characters.");
            }
        }
        if (email == null || email.isBlank() || !email.contains("@")) {
            return Optional.of("A valid email is required.");
        }
        if (fullName == null || fullName.isBlank()) {
            return Optional.of("Full name is required.");
        }
        if (phone == null || phone.isBlank()) {
            return Optional.of("Phone number is required.");
        }
        return Optional.empty();
    }
}
