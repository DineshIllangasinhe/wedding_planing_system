package com.wedding.model;

import java.math.BigDecimal;

/**
 * Wedding package tiers used by the payment module.
 */
public enum PackageType {
    BASIC(new BigDecimal("2499.00")),
    STANDARD(new BigDecimal("4999.00")),
    PREMIUM(new BigDecimal("8999.00"));

    private final BigDecimal suggestedPrice;

    PackageType(BigDecimal suggestedPrice) {
        this.suggestedPrice = suggestedPrice;
    }

    public BigDecimal getSuggestedPrice() {
        return suggestedPrice;
    }
}
