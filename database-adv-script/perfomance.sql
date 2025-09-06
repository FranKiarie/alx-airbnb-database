-- Performance Test Queries — ALX Airbnb Database (PostgreSQL)

-- =======================================
-- Initial Query: retrieves bookings + user + property + payment details
-- =======================================
EXPLAIN ANALYZE
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.status,
  b.total_price,
  u.user_id      AS guest_id,
  u.first_name   AS guest_first_name,
  u.last_name    AS guest_last_name,
  u.email        AS guest_email,
  p.property_id,
  p.name         AS property_name,
  p.location,
  p.price_per_night,
  pay.payment_id,
  pay.amount     AS paid_amount,
  pay.payment_method,
  pay.payment_date
FROM bookings b
JOIN users u       ON u.user_id = b.user_id
JOIN properties p  ON p.property_id = b.property_id
LEFT JOIN payments pay ON pay.booking_id = b.booking_id
ORDER BY b.created_at DESC
LIMIT 200;

-- =======================================
-- Optimized Query: filters + narrower columns
-- =======================================
EXPLAIN ANALYZE
WITH recent_bookings AS (
  SELECT booking_id, user_id, property_id, start_date, end_date, status, total_price, created_at
  FROM bookings
  WHERE created_at >= NOW() - INTERVAL '365 days'
    AND status IN ('confirmed','pending')
  ORDER BY created_at DESC
  LIMIT 1000
)
SELECT
  rb.booking_id,
  rb.start_date,
  rb.end_date,
  rb.status,
  rb.total_price,
  u.first_name AS guest_first_name,
  u.last_name  AS guest_last_name,
  p.name       AS property_name,
  p.location,
  pay.amount   AS paid_amount,
  pay.payment_method
FROM recent_bookings rb
JOIN users u      ON u.user_id = rb.user_id
JOIN properties p ON p.property_id = rb.property_id
LEFT JOIN payments pay ON pay.booking_id = rb.booking_id
ORDER BY rb.created_at DESC;
