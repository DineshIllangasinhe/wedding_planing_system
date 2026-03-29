package com.wedding.model;

import java.time.LocalDate;
import java.util.Objects;

/**
 * Links a user to a vendor on a specific event date. Persisted to bookings.txt.
 */
public class Booking {

    private long id;
    private long userId;
    private long vendorId;
    private LocalDate eventDate;
    private BookingStatus status;
    private String notes;
    private LocalDate createdAt;

    public Booking() {
    }

    public Booking(long id, long userId, long vendorId, LocalDate eventDate, BookingStatus status,
                   String notes, LocalDate createdAt) {
        this.id = id;
        this.userId = userId;
        this.vendorId = vendorId;
        this.eventDate = eventDate;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public LocalDate getEventDate() {
        return eventDate;
    }

    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }

    public BookingStatus getStatus() {
        return status;
    }

    public void setStatus(BookingStatus status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public boolean blocksVendorOnDate() {
        return status != BookingStatus.CANCELLED;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Booking booking = (Booking) o;
        return id == booking.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
