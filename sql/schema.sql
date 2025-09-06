-- Airbnb-like Database Schema
-- PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================
-- USER
-- =====================
CREATE TABLE users (
    user_id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    password_hash   VARCHAR(256) NOT NULL,
    phone_number    VARCHAR(15),
    role            VARCHAR(20) NOT NULL CHECK (role IN ('guest', 'host', 'admin')),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- =====================
-- PROPERTY
-- =====================
CREATE TABLE properties (
    property_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id         UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    name            VARCHAR(200) NOT NULL,
    description     TEXT,
    location        VARCHAR(200) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- =====================
-- BOOKING
-- =====================
CREATE TABLE bookings (
    booking_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id     UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    total_price     DECIMAL(10,2) NOT NULL,
    status          VARCHAR(20) NOT NULL CHECK (status IN ('pending','confirmed','cancelled')),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (start_date < end_date)
);

-- =====================
-- PAYMENT
-- =====================
CREATE TABLE payments (
    payment_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id      UUID NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    amount          DECIMAL(10,2) NOT NULL,
    payment_date    TIMESTAMP NOT NULL DEFAULT NOW(),
    payment_method  VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card','paypal','stripe'))
);

-- =====================
-- REVIEW
-- =====================
CREATE TABLE reviews (
    review_id       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id     UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    rating          INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- =====================
-- MESSAGE
-- =====================
CREATE TABLE messages (
    message_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id       UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    recipient_id    UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    message_body    TEXT NOT NULL,
    sent_at         TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (sender_id <> recipient_id)
);
