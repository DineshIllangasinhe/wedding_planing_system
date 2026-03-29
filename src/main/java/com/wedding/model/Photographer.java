package com.wedding.model;

import java.math.BigDecimal;

/**
 * Photographer vendor — overrides polymorphic hooks with imaging-specific behavior.
 */
public class Photographer extends Vendor {

    private String shootingStyle;
    private int includedHours;

    public Photographer() {
        setType(VendorType.PHOTOGRAPHER);
    }

    public Photographer(long id, String businessName, String contactEmail, String contactPhone,
                        String description, BigDecimal dailyRate, String shootingStyle, int includedHours) {
        super(id, VendorType.PHOTOGRAPHER, businessName, contactEmail, contactPhone, description, dailyRate);
        this.shootingStyle = shootingStyle;
        this.includedHours = includedHours;
    }

    public String getShootingStyle() {
        return shootingStyle;
    }

    public void setShootingStyle(String shootingStyle) {
        this.shootingStyle = shootingStyle;
    }

    public int getIncludedHours() {
        return includedHours;
    }

    public void setIncludedHours(int includedHours) {
        this.includedHours = includedHours;
    }

    @Override
    public String getSpecialtySummary() {
        return shootingStyle + " • " + includedHours + "h coverage/day";
    }

    @Override
    public String getServiceDetails() {
        return "Photography style: " + shootingStyle + ". Included hours per booking day: " + includedHours + ".";
    }
}
