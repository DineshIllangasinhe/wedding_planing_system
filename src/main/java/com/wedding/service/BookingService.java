package com.wedding.service;

import com.wedding.model.Booking;
import com.wedding.model.BookingStatus;
import com.wedding.util.FileUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Booking CRUD with double-booking prevention for active statuses.
 */
public class BookingService {

    private static final String FILE = "bookings.txt";

    private final String dataDir;

    public BookingService(String dataDir) {
        this.dataDir = dataDir;
    }

    public List<Booking> listAll() throws IOException {
        List<Booking> out = new ArrayList<>();
        for (String line : FileUtil.readAllLines(dataDir, FILE)) {
            out.add(fromLine(line));
        }
        out.sort(Comparator.comparing(Booking::getEventDate).reversed());
        return out;
    }

    public List<Booking> listByUser(long userId) throws IOException {
        return listAll().stream()
                .filter(b -> b.getUserId() == userId)
                .collect(Collectors.toList());
    }

    /**
     * Confirmed/pending/completed history for dashboard (excludes cancelled unless includeCancelled).
     */
    public List<Booking> bookingHistoryForUser(long userId, boolean includeCancelled) throws IOException {
        return listByUser(userId).stream()
                .filter(b -> includeCancelled || b.getStatus() != BookingStatus.CANCELLED)
                .collect(Collectors.toList());
    }

    public Optional<Booking> findById(long id) throws IOException {
        for (Booking b : listAll()) {
            if (b.getId() == id) {
                return Optional.of(b);
            }
        }
        return Optional.empty();
    }

    public Optional<String> create(long userId, long vendorId, LocalDate eventDate, String notes) throws IOException {
        Optional<String> v = validate(eventDate, notes);
        if (v.isPresent()) {
            return v;
        }
        if (hasVendorDateConflict(vendorId, eventDate, -1)) {
            return Optional.of("This vendor is already booked on the selected date. Please choose another date or vendor.");
        }
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        long id = FileUtil.nextId(lines, 0);
        Booking b = new Booking(id, userId, vendorId, eventDate, BookingStatus.PENDING,
                notes != null ? notes.trim() : "", LocalDate.now());
        lines.add(toLine(b));
        FileUtil.writeAllLines(dataDir, FILE, lines);
        return Optional.empty();
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
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            Booking b = fromLine(line);
            if (b.getId() == bookingId) {
                found = true;
                b.setVendorId(vendorId);
                b.setEventDate(eventDate);
                b.setStatus(status);
                b.setNotes(notes != null ? notes.trim() : "");
                next.add(toLine(b));
            } else {
                next.add(line);
            }
        }
        if (!found) {
            return Optional.of("Booking not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    /**
     * Cancel booking (soft state) — frees the vendor date for re-booking.
     */
    public Optional<String> cancel(long bookingId) throws IOException {
        return updateStatus(bookingId, BookingStatus.CANCELLED);
    }

    public Optional<String> deleteHard(long bookingId) throws IOException {
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean removed = false;
        for (String line : lines) {
            Booking b = fromLine(line);
            if (b.getId() == bookingId) {
                removed = true;
            } else {
                next.add(line);
            }
        }
        if (!removed) {
            return Optional.of("Booking not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    private Optional<String> updateStatus(long bookingId, BookingStatus status) throws IOException {
        List<String> lines = FileUtil.readAllLines(dataDir, FILE);
        List<String> next = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            Booking b = fromLine(line);
            if (b.getId() == bookingId) {
                found = true;
                b.setStatus(status);
                next.add(toLine(b));
            } else {
                next.add(line);
            }
        }
        if (!found) {
            return Optional.of("Booking not found.");
        }
        FileUtil.writeAllLines(dataDir, FILE, next);
        return Optional.empty();
    }

    public boolean hasVendorDateConflict(long vendorId, LocalDate date, long excludeBookingId) throws IOException {
        for (Booking b : listAll()) {
            if (b.getId() == excludeBookingId) {
                continue;
            }
            if (b.getVendorId() == vendorId && b.getEventDate().equals(date) && b.blocksVendorOnDate()) {
                return true;
            }
        }
        return false;
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

    private static Booking fromLine(String line) {
        String[] c = FileUtil.splitRecord(line);
        return new Booking(
                Long.parseLong(c[0]),
                Long.parseLong(c[1]),
                Long.parseLong(c[2]),
                LocalDate.parse(c[3]),
                BookingStatus.valueOf(c[4]),
                c[5],
                LocalDate.parse(c[6])
        );
    }

    private static String toLine(Booking b) {
        return FileUtil.joinRecord(
                String.valueOf(b.getId()),
                String.valueOf(b.getUserId()),
                String.valueOf(b.getVendorId()),
                b.getEventDate().toString(),
                b.getStatus().name(),
                b.getNotes(),
                b.getCreatedAt().toString()
        );
    }
}
