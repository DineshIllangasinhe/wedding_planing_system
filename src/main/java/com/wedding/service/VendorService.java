package com.wedding.service;

import com.wedding.model.Caterer;
import com.wedding.model.DecoratorVendor;
import com.wedding.model.Photographer;
import com.wedding.model.Vendor;
import com.wedding.model.VendorType;
import com.wedding.util.FileUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Vendor CRUD with polymorphic persistence in vendors.txt.
 */
public class VendorService {

    private static final String FILE = "vendors.txt";

    private final String dataDir;

    public VendorService(String dataDir) {
        this.dataDir = dataDir;
    }

    public List<Vendor> listAll() throws IOException {
        List<Vendor> out = new ArrayList<>();
        for (String line : FileUtil.readAllLines(dataDir, FILE)) {
            out.add(fromLine(line));
        }
        return out;
    }

    public Optional<Vendor> findById(long id) throws IOException {
        for (Vendor v : listAll()) {
            if (v.getId() == id) {
                return Optional.of(v);
            }
        }
        return Optional.empty();
    }

    /**
     * Search by name/description and optional category filter.
     */
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
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        long id = FileUtil.nextId(lines, 0);
        vendor.setId(id);
        lines.add(toLine(vendor));
        FileUtil.writeAllLines(dataDir, FILE, lines);
        return Optional.empty();
    }

    public Optional<String> update(Vendor vendor) throws IOException {
        Optional<String> err = validate(vendor);
        if (err.isPresent()) {
            return err;
        }
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            Vendor existing = fromLine(line);
            if (existing.getId() == vendor.getId()) {
                found = true;
                next.add(toLine(vendor));
            } else {
                next.add(line);
            }
        }
        if (!found) {
            return Optional.of("Vendor not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    public Optional<String> delete(long id) throws IOException {
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean removed = false;
        for (String line : lines) {
            Vendor v = fromLine(line);
            if (v.getId() == id) {
                removed = true;
            } else {
                next.add(line);
            }
        }
        if (!removed) {
            return Optional.of("Vendor not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
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

    /**
     * Record layout:
     * id|TYPE|businessName|email|phone|description|dailyRate|typeSpecific...
     */
    private Vendor fromLine(String line) {
        String[] c = FileUtil.splitRecord(line);
        long id = Long.parseLong(c[0]);
        VendorType type = VendorType.valueOf(c[1]);
        String name = c[2];
        String email = c[3];
        String phone = c[4];
        String desc = c[5];
        BigDecimal rate = new BigDecimal(c[6]);
        return switch (type) {
            case PHOTOGRAPHER -> new Photographer(id, name, email, phone, desc, rate, c[7], Integer.parseInt(c[8]));
            case CATERING -> new Caterer(id, name, email, phone, desc, rate, c[7], Boolean.parseBoolean(c[8]));
            case DECORATION -> new DecoratorVendor(id, name, email, phone, desc, rate, c[7], Boolean.parseBoolean(c[8]));
        };
    }

    private String toLine(Vendor v) {
        return switch (v.getType()) {
            case PHOTOGRAPHER -> {
                Photographer p = (Photographer) v;
                yield FileUtil.joinRecord(
                        String.valueOf(p.getId()),
                        p.getType().name(),
                        p.getBusinessName(),
                        p.getContactEmail(),
                        p.getContactPhone(),
                        p.getDescription(),
                        p.getDailyRate().toPlainString(),
                        p.getShootingStyle(),
                        String.valueOf(p.getIncludedHours())
                );
            }
            case CATERING -> {
                Caterer c = (Caterer) v;
                yield FileUtil.joinRecord(
                        String.valueOf(c.getId()),
                        c.getType().name(),
                        c.getBusinessName(),
                        c.getContactEmail(),
                        c.getContactPhone(),
                        c.getDescription(),
                        c.getDailyRate().toPlainString(),
                        c.getCuisineType(),
                        String.valueOf(c.isIncludesStaffing())
                );
            }
            case DECORATION -> {
                DecoratorVendor d = (DecoratorVendor) v;
                yield FileUtil.joinRecord(
                        String.valueOf(d.getId()),
                        d.getType().name(),
                        d.getBusinessName(),
                        d.getContactEmail(),
                        d.getContactPhone(),
                        d.getDescription(),
                        d.getDailyRate().toPlainString(),
                        d.getThemeFocus(),
                        String.valueOf(d.isProvidesFlorals())
                );
            }
        };
    }
}
