package com.wedding.service;

import com.wedding.model.PackageType;
import com.wedding.model.Payment;
import com.wedding.model.PaymentStatus;
import com.wedding.util.FileUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Payment / package CRUD backed by payments.txt.
 */
public class PaymentService {

    private static final String FILE = "payments.txt";

    private final String dataDir;

    public PaymentService(String dataDir) {
        this.dataDir = dataDir;
    }

    public List<Payment> listAll() throws IOException {
        List<Payment> out = new ArrayList<>();
        for (String line : FileUtil.readAllLines(dataDir, FILE)) {
            out.add(fromLine(line));
        }
        out.sort(Comparator.comparing(Payment::getCreatedAt).reversed());
        return out;
    }

    public List<Payment> listByUser(long userId) throws IOException {
        return listAll().stream().filter(p -> p.getUserId() == userId).collect(Collectors.toList());
    }

    public Optional<Payment> findById(long id) throws IOException {
        for (Payment p : listAll()) {
            if (p.getId() == id) {
                return Optional.of(p);
            }
        }
        return Optional.empty();
    }

    public Optional<String> create(long bookingId, long userId, PackageType packageType, BigDecimal amount) throws IOException {
        Optional<String> v = validate(amount, packageType);
        if (v.isPresent()) {
            return v;
        }
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        long id = FileUtil.nextId(lines, 0);
        Payment p = new Payment(id, bookingId, userId, packageType, amount, PaymentStatus.PENDING, LocalDate.now());
        lines.add(toLine(p));
        FileUtil.writeAllLines(dataDir, FILE, lines);
        return Optional.empty();
    }

    public Optional<String> update(long paymentId, PackageType packageType, BigDecimal amount, PaymentStatus status) throws IOException {
        Optional<String> v = validate(amount, packageType);
        if (v.isPresent()) {
            return v;
        }
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            Payment p = fromLine(line);
            if (p.getId() == paymentId) {
                found = true;
                p.setPackageType(packageType);
                p.setAmount(amount);
                p.setStatus(status);
                next.add(toLine(p));
            } else {
                next.add(line);
            }
        }
        if (!found) {
            return Optional.of("Payment not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    public Optional<String> delete(long paymentId) throws IOException {
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean removed = false;
        for (String line : lines) {
            Payment p = fromLine(line);
            if (p.getId() == paymentId) {
                removed = true;
            } else {
                next.add(line);
            }
        }
        if (!removed) {
            return Optional.of("Payment not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
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

    private static Payment fromLine(String line) {
        String[] c = FileUtil.splitRecord(line);
        return new Payment(
                Long.parseLong(c[0]),
                Long.parseLong(c[1]),
                Long.parseLong(c[2]),
                PackageType.valueOf(c[3]),
                new BigDecimal(c[4]),
                PaymentStatus.valueOf(c[5]),
                LocalDate.parse(c[6])
        );
    }

    private static String toLine(Payment p) {
        return FileUtil.joinRecord(
                String.valueOf(p.getId()),
                String.valueOf(p.getBookingId()),
                String.valueOf(p.getUserId()),
                p.getPackageType().name(),
                p.getAmount().toPlainString(),
                p.getStatus().name(),
                p.getCreatedAt().toString()
        );
    }
}
