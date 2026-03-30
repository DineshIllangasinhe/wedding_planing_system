-- Wedding planning app — run once against MySQL (creates DB `wedding`, tables, demo seed).
--
-- MySQL Workbench shows "Not connected" when THIS EDITOR TAB is not logged into a server.
-- That is normal for a file opened from disk. Fix:
--   1) Go to the Workbench home screen (SQL tabs can be closed).
--   2) Double-click your saved connection (e.g. "Local instance MySQL80"), enter password.
--   3) In the NEW tab that opens (status shows connected), use File -> Open SQL Script -> pick this file.
--   4) Click the lightning Execute icon (or Ctrl+Shift+Enter).
-- Do not rely on a tab that only opened the .sql file from Explorer without a live connection.
--
CREATE DATABASE IF NOT EXISTS wedding;
USE wedding;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(64) NOT NULL,
    `role` VARCHAR(32) NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS vendors (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    vendor_type VARCHAR(32) NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(64) NOT NULL,
    description TEXT NOT NULL,
    daily_rate DECIMAL(12, 2) NOT NULL,
    extra1 VARCHAR(255) NOT NULL,
    extra2 VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS bookings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    vendor_id BIGINT NOT NULL,
    event_date DATE NOT NULL,
    status VARCHAR(32) NOT NULL,
    notes TEXT NOT NULL,
    created_at DATE NOT NULL,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_vendor FOREIGN KEY (vendor_id) REFERENCES vendors (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    package_type VARCHAR(32) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(32) NOT NULL,
    created_at DATE NOT NULL,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES bookings (id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

-- Demo seed (passwords: admin / admin123, couple1 / wedding2026 — same SHA-256 as file seeds)
INSERT INTO users (id, username, password_hash, email, full_name, phone, `role`, created_at) VALUES
(1, 'admin', 'a9741fa463e7c05beb48797235f1db6ba1ededc64257a71683cf651ea012f605', 'planner@wedding-suite.com', 'System Administrator', '555-0100', 'ADMIN', '2025-01-15'),
(2, 'couple1', '4234d42cdf1c9b3c3b4b9172232148dacd0c5e5e8116982111c8642999274bed', 'jamie.alex@example.com', 'Jamie & Alex Morgan', '555-0142', 'CUSTOMER', '2025-02-01');

INSERT INTO vendors (id, vendor_type, business_name, contact_email, contact_phone, description, daily_rate, extra1, extra2) VALUES
(1, 'PHOTOGRAPHER', 'Lumière Studios', 'hello@lumiereweddings.com', '555-0201', 'Editorial and candid wedding photography with same-day previews.', 1800.00, 'Editorial natural light', '10'),
(2, 'CATERING', 'Tuscany Table Catering', 'events@tuscanytable.com', '555-0202', 'Family-style Italian feasts with seasonal antipasti and plated mains.', 4200.00, 'Italian', 'true'),
(3, 'DECORATION', 'Bloom & Lattice', 'studio@bloomlattice.com', '555-0203', 'Modern arches, candlescapes, and statement floral moments.', 2200.00, 'Modern minimalist', 'true'),
(4, 'PHOTOGRAPHER', 'Silver Frame Collective', 'booking@silverframe.co', '555-0204', 'Documentary storytelling with gentle direction for portraits.', 2100.00, 'Photojournalism', '8');

INSERT INTO bookings (id, user_id, vendor_id, event_date, status, notes, created_at) VALUES
(1, 2, 1, '2026-09-12', 'CONFIRMED', 'Ceremony and reception coverage at Riverside Estate.', '2025-03-01'),
(2, 2, 2, '2026-09-13', 'PENDING', 'Evening reception for 120 guests — tasting completed.', '2025-03-02');

INSERT INTO payments (id, booking_id, user_id, package_type, amount, status, created_at) VALUES
(1, 1, 2, 'STANDARD', 4999.00, 'PENDING', '2025-03-05'),
(2, 2, 2, 'BASIC', 2499.00, 'PAID', '2025-03-06');
