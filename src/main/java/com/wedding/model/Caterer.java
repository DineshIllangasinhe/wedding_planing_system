package com.wedding.model;

import java.math.BigDecimal;

/**
 * Catering vendor — menu and service style exposed via polymorphic methods.
 */
public class Caterer extends Vendor {

    private String cuisineType;
    private boolean includesStaffing;

    public Caterer() {
        setType(VendorType.CATERING);
    }

    public Caterer(long id, String businessName, String contactEmail, String contactPhone,
                   String description, BigDecimal dailyRate, String cuisineType, boolean includesStaffing) {
        super(id, VendorType.CATERING, businessName, contactEmail, contactPhone, description, dailyRate);
        this.cuisineType = cuisineType;
        this.includesStaffing = includesStaffing;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public boolean isIncludesStaffing() {
        return includesStaffing;
    }

    public void setIncludesStaffing(boolean includesStaffing) {
        this.includesStaffing = includesStaffing;
    }

    @Override
    public String getSpecialtySummary() {
        return cuisineType + (includesStaffing ? " • staffed service" : " • drop-off");
    }

    @Override
    public String getServiceDetails() {
        return "Cuisine focus: " + cuisineType + ". Staffing included: " + (includesStaffing ? "yes" : "no") + ".";
    }
}
