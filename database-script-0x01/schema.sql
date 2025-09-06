-- ALX Airbnb Database — Schema DDL (PostgreSQL)
-- Entities: users, properties, bookings, payments, reviews, messages

-- Extensions (UUIDs)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================
-- USERS
-- =========================
CREATE TABLE IF NOT EXISTS users (
  user_id       UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name    VARCHAR(100) NOT NULL,
  last_name     VARCHAR(100) NOT NULL,
  email         VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(256) NOT NULL,
  phone_number  VARCHAR(15),
  role          VARCHAR(20) NOT NULL CHECK (role IN ('guest','host','admin')),
  created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_users_role  ON users (role);

-- =========================
-- PROPERTIES
-- =========================
CREATE TABLE IF NOT EXISTS properties (
  property_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  host_id         UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  name            VARCHAR(200) NOT NULL,
  description     TEXT,
  location        VARCHAR(200) NOT NULL,
  price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night >= 0),
  created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_properties_host    ON properties (host_id);
CREATE INDEX IF NOT EXISTS idx_properties_location ON properties (location);
CREATE INDEX IF NOT EXISTS idx_properties_price    ON properties (price_per_night);

-- =========================
-- BOOKINGS
-- =========================
CREATE TABLE IF NOT EXISTS bookings (
  booking_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id  UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,  -- guest
  start_date   DATE NOT NULL,
  end_date     DATE NOT NULL,
  total_price  DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
  status       VARCHAR(20) NOT NULL CHECK (status IN ('pending','confirmed','cancelled')),
  created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
  CHECK (start_date < end_date)
);

CREATE INDEX IF NOT EXISTS idx_bookings_user      ON bookings (user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property  ON bookings (property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates     ON bookings (property_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status    ON bookings (status);

-- =========================
-- PAYMENTS (1:1 with booking for MVP)
-- =========================
CREATE TABLE IF NOT EXISTS payments (
  payment_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id     UUID NOT NULL UNIQUE REFERENCES bookings(booking_id) ON DELETE CASCADE,
  amount         DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  payment_date   TIMESTAMP NOT NULL DEFAULT NOW(),
  payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card','paypal','stripe'))
);

CREATE INDEX IF NOT EXISTS idx_payments_method ON payments (payment_method);
CREATE INDEX IF NOT EXISTS idx_payments_date   ON payments (payment_date);

-- =========================
-- REVIEWS
-- =========================
CREATE TABLE IF NOT EXISTS reviews (
  review_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE, -- reviewer (guest)
  rating      INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT,
  created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reviews_property ON reviews (property_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user     ON reviews (user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating   ON reviews (rating);

-- (Optional) prevent duplicate review by same user for same property in MVP
-- CREATE UNIQUE INDEX IF NOT EXISTS uq_review_per_user_property
--   ON reviews (property_id, user_id);

-- =========================
-- MESSAGES
-- =========================
CREATE TABLE IF NOT EXISTS messages (
  message_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id    UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  recipient_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  message_body TEXT NOT NULL,
  sent_at      TIMESTAMP NOT NULL DEFAULT NOW(),
  CHECK (sender_id <> recipient_id)
);

CREATE INDEX IF NOT EXISTS idx_messages_sender    ON messages (sender_id, sent_at);
CREATE INDEX IF NOT EXISTS idx_messages_recipient ON messages (recipient_id, sent_at);

-- =========================
-- NOTES
-- =========================
-- • All PKs are UUIDs for scalability.
-- • Status and method columns are constrained to allowed values.
-- • Basic indexes added for common lookups and filtering.
-- • If you later need overlapping-booking prevention, consider
--   range types + exclusion constraints (PostgreSQL feature).
