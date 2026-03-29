package com.wedding.model;

import java.math.BigDecimal;
import java.util.Objects;

/**
 * Base vendor entity. Subclasses override polymorphic behavior for category-specific offerings.
 */
public abstract class Vendor {

    protected long id;
    protected VendorType type;
    protected String businessName;
    protected String contactEmail;
    protected String contactPhone;
    protected String description;
    /** Base daily rate for services (simplified pricing model). */
    protected BigDecimal dailyRate;

    protected Vendor() {
    }

    protected Vendor(long id, VendorType type, String businessName, String contactEmail,
                     String contactPhone, String description, BigDecimal dailyRate) {
        this.id = id;
        this.type = type;
        this.businessName = businessName;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;
        this.description = description;
        this.dailyRate = dailyRate;
    }

    /**
     * Polymorphic: human-readable specialty line for listings.
     */
    public abstract String getSpecialtySummary();

    /**
     * Polymorphic: detailed line for vendor detail card.
     */
    public abstract String getServiceDetails();

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public VendorType getType() {
        return type;
    }

    public void setType(VendorType type) {
        this.type = type;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getDailyRate() {
        return dailyRate;
    }

    public void setDailyRate(BigDecimal dailyRate) {
        this.dailyRate = dailyRate;
    }

    public String getTypeDisplayName() {
        return switch (type) {
            case PHOTOGRAPHER -> "Photographer";
            case CATERING -> "Catering";
            case DECORATION -> "Decoration";
        };
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Vendor vendor = (Vendor) o;
        return id == vendor.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
