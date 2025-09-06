-- Database Indexes — ALX Airbnb (PostgreSQL)

-- Optional extensions for better text search performance
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- =========================
-- USERS
-- =========================
-- Frequent lookups: login by email, filtering by role, created_at sorting
CREATE INDEX IF NOT EXISTS idx_users_email             ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role              ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at        ON users(created_at);

-- Case-insensitive email search (use if you query with ILIKE)
CREATE INDEX IF NOT EXISTS idx_users_email_ilike_trgm  ON users USING gin (email gin_trgm_ops);

-- =========================
-- PROPERTIES
-- =========================
-- Common filters: by host, by location text, price sorting
CREATE INDEX IF NOT EXISTS idx_properties_host             ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_price            ON properties(price_per_night);
CREATE INDEX IF NOT EXISTS idx_properties_created_at       ON properties(created_at);

-- Text search on location (supports ILIKE '%naivasha%')
CREATE INDEX IF NOT EXISTS idx_properties_location_trgm    ON properties USING gin (location gin_trgm_ops);

-- =========================
-- BOOKINGS
-- =========================
-- Frequent joins and date-range filters
CREATE INDEX IF NOT EXISTS idx_bookings_user                    ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property                ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates                   ON bookings(property_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status                  ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at              ON bookings(created_at);

-- If most queries target confirmed bookings, a partial index helps:
CREATE INDEX IF NOT EXISTS idx_bookings_confirmed_only
  ON bookings(property_id, start_date, end_date)
  WHERE status = 'confirmed';

-- For large, time-ordered tables, BRIN index is lightweight and fast for ranges
CREATE INDEX IF NOT EXISTS idx_bookings_start_date_brin
  ON bookings USING brin (start_date);

-- =========================
-- PAYMENTS
-- =========================
CREATE INDEX IF NOT EXISTS idx_payments_date               ON payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_payments_method             ON payments(payment_method);

-- =========================
-- REVIEWS
-- =========================
CREATE INDEX IF NOT EXISTS idx_reviews_property_created    ON reviews(property_id, created_at);
CREATE INDEX IF NOT EXISTS idx_reviews_user                ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating              ON reviews(rating);

-- =========================
-- MESSAGES
-- =========================
CREATE INDEX IF NOT EXISTS idx_messages_sender_time        ON messages(sender_id, sent_at);
CREATE INDEX IF NOT EXISTS idx_messages_recipient_time     ON messages(recipient_id, sent_at);
