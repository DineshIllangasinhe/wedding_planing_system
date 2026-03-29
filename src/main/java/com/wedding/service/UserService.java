package com.wedding.service;

import com.wedding.model.User;
import com.wedding.model.UserRole;
import com.wedding.util.FileUtil;
import com.wedding.util.PasswordUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

/**
 * User management CRUD backed by users.txt.
 */
public class UserService {

    private static final String FILE = "users.txt";

    private final String dataDir;

    public UserService(String dataDir) {
        this.dataDir = dataDir;
    }

    public List<User> listAll() throws IOException {
        List<User> out = new ArrayList<>();
        for (String line : FileUtil.readAllLines(dataDir, FILE)) {
            out.add(fromLine(line));
        }
        return out;
    }

    public Optional<User> findById(long id) throws IOException {
        for (User u : listAll()) {
            if (u.getId() == id) {
                return Optional.of(u);
            }
        }
        return Optional.empty();
    }

    public Optional<User> findByUsername(String username) throws IOException {
        if (username == null) {
            return Optional.empty();
        }
        String key = username.trim().toLowerCase(Locale.ROOT);
        for (User u : listAll()) {
            if (u.getUsername().toLowerCase(Locale.ROOT).equals(key)) {
                return Optional.of(u);
            }
        }
        return Optional.empty();
    }

    public Optional<String> register(String username, String plainPassword, String email,
                                     String fullName, String phone) throws IOException {
        Optional<String> v = validateUserFields(username, email, fullName, phone, plainPassword, true);
        if (v.isPresent()) {
            return v;
        }
        if (findByUsername(username).isPresent()) {
            return Optional.of("That username is already taken.");
        }
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        long id = FileUtil.nextId(lines, 0);
        String hash = PasswordUtil.hash(username.trim(), plainPassword);
        UserRole role = lines.isEmpty() ? UserRole.ADMIN : UserRole.CUSTOMER;
        User u = new User(id, username.trim(), hash, email.trim(), fullName.trim(), phone.trim(),
                role, LocalDate.now());
        lines.add(toLine(u));
        FileUtil.writeAllLines(dataDir, FILE, lines);
        return Optional.empty();
    }

    public Optional<String> update(long id, String email, String fullName, String phone,
                                   String newPasswordOrBlank) throws IOException {
        Optional<String> v = validateUserFields("x", email, fullName, phone, newPasswordOrBlank, false);
        if (v.isPresent()) {
            return v;
        }
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            User u = fromLine(line);
            if (u.getId() == id) {
                found = true;
                u.setEmail(email.trim());
                u.setFullName(fullName.trim());
                u.setPhone(phone.trim());
                if (newPasswordOrBlank != null && !newPasswordOrBlank.isBlank()) {
                    u.setPasswordHash(PasswordUtil.hash(u.getUsername(), newPasswordOrBlank));
                }
                next.add(toLine(u));
            } else {
                next.add(line);
            }
        }
        if (!found) {
            return Optional.of("User not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    public Optional<String> delete(long id) throws IOException {
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean removed = false;
        for (String line : lines) {
            User u = fromLine(line);
            if (u.getId() == id) {
                removed = true;
            } else {
                next.add(line);
            }
        }
        if (!removed) {
            return Optional.of("User not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    public Optional<User> authenticate(String username, String plainPassword) throws IOException {
        Optional<User> u = findByUsername(username);
        if (u.isEmpty()) {
            return Optional.empty();
        }
        if (!PasswordUtil.matches(u.get().getUsername(), plainPassword, u.get().getPasswordHash())) {
            return Optional.empty();
        }
        return u;
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

    private static User fromLine(String line) {
        String[] c = FileUtil.splitRecord(line);
        return new User(
                Long.parseLong(c[0]),
                c[1],
                c[2],
                c[3],
                c[4],
                c[5],
                UserRole.valueOf(c[6]),
                LocalDate.parse(c[7])
        );
    }

    private static String toLine(User u) {
        return FileUtil.joinRecord(
                String.valueOf(u.getId()),
                u.getUsername(),
                u.getPasswordHash(),
                u.getEmail(),
                u.getFullName(),
                u.getPhone(),
                u.getRole().name(),
                u.getCreatedAt().toString()
        );
    }
}
