-- Advanced Join Queries — ALX Airbnb Database (PostgreSQL)
-- Tables expected: users, properties, bookings, payments, reviews, messages

-- =========================================================
-- 1) INNER JOIN: All bookings with the user who made them
--    Returns ONLY rows where a booking has a matching user.
-- =========================================================
SELECT
  b.booking_id,
  b.property_id,
  b.user_id            AS guest_id,
  u.first_name         AS guest_first_name,
  u.last_name          AS guest_last_name,
  u.email              AS guest_email,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status,
  b.created_at         AS booking_created_at
FROM bookings b
INNER JOIN users u
  ON u.user_id = b.user_id
ORDER BY b.created_at DESC;

-- =========================================================
-- 2) LEFT JOIN: All properties and their reviews
--    Includes properties that have NO reviews (review columns NULL).
-- =========================================================
SELECT
  p.property_id,
  p.name               AS property_name,
  p.location,
  p.price_per_night,
  r.review_id,
  r.user_id            AS reviewer_id,
  r.rating,
  r.comment,
  r.created_at         AS review_created_at
FROM properties p
LEFT JOIN reviews r
  ON r.property_id = p.property_id
ORDER BY p.name, r.created_at NULLS LAST;

-- (Optional aggregation view of the same idea)
-- SELECT
--   p.property_id,
--   p.name AS property_name,
--   COUNT(r.review_id) AS review_count,
--   AVG(r.rating)::numeric(3,2) AS avg_rating
-- FROM properties p
-- LEFT JOIN reviews r ON r.property_id = p.property_id
-- GROUP BY p.property_id, p.name
-- ORDER BY review_count DESC, avg_rating DESC NULLS LAST;

-- =========================================================
-- 3) FULL OUTER JOIN: All users and all bookings
--    Even if a user has NO booking or (hypothetically) a booking
--    is not linked to a user. In our schema, orphan bookings
--    shouldn't exist due to FK, but this demonstrates the pattern.
-- =========================================================
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.status,
  COALESCE(u.created_at, b.created_at) AS created_at_any
FROM users u
FULL OUTER JOIN bookings b
  ON b.user_id = u.user_id
ORDER BY created_at_any DESC;

-- =========================================================
-- Bonus examples (keep if you want)
-- ---------------------------------------------------------
-- a) LEFT JOIN users→properties (show hosts and their listings, include hosts with 0 listings)
-- SELECT
--   u.user_id AS host_id, u.first_name, u.last_name, u.email,
--   p.property_id, p.name AS property_name, p.location
-- FROM users u
-- LEFT JOIN properties p ON p.host_id = u.user_id
-- WHERE u.role = 'host'
-- ORDER BY u.last_name, p.name NULLS LAST;

-- b) INNER JOIN chain: booking → property → host (who owns the property) → guest
-- SELECT
--   b.booking_id, b.start_date, b.end_date, b.status,
--   guest.email    AS guest_email,
--   host.email     AS host_email,
--   p.name         AS property_name,
--   p.location
-- FROM bookings b
-- JOIN properties p      ON p.property_id = b.property_id
-- JOIN users host        ON host.user_id = p.host_id
-- JOIN users guest       ON guest.user_id = b.user_id
-- ORDER BY b.start_date DESC;
