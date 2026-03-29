package com.wedding.model;

import java.math.BigDecimal;

/**
 * Decoration vendor (named DecoratorVendor to avoid confusion with the Decorator design pattern).
 */
public class DecoratorVendor extends Vendor {

    private String themeFocus;
    private boolean providesFlorals;

    public DecoratorVendor() {
        setType(VendorType.DECORATION);
    }

    public DecoratorVendor(long id, String businessName, String contactEmail, String contactPhone,
                           String description, BigDecimal dailyRate, String themeFocus, boolean providesFlorals) {
        super(id, VendorType.DECORATION, businessName, contactEmail, contactPhone, description, dailyRate);
        this.themeFocus = themeFocus;
        this.providesFlorals = providesFlorals;
    }

    public String getThemeFocus() {
        return themeFocus;
    }

    public void setThemeFocus(String themeFocus) {
        this.themeFocus = themeFocus;
    }

    public boolean isProvidesFlorals() {
        return providesFlorals;
    }

    public void setProvidesFlorals(boolean providesFlorals) {
        this.providesFlorals = providesFlorals;
    }

    @Override
    public String getSpecialtySummary() {
        return themeFocus + (providesFlorals ? " • florals" : " • décor only");
    }

    @Override
    public String getServiceDetails() {
        return "Design focus: " + themeFocus + ". Floral design included: " + (providesFlorals ? "yes" : "no") + ".";
    }
}
