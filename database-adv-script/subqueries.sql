-- Subqueries — ALX Airbnb Database (PostgreSQL)
-- Demonstrates non-correlated and correlated subqueries.

-- =========================================================
-- 1) Non-correlated subquery:
-- Find all properties where the average rating is greater than 4.0.
-- =========================================================
SELECT
  p.property_id,
  p.name           AS property_name,
  p.location,
  p.price_per_night
FROM properties p
WHERE p.property_id IN (
  SELECT r.property_id
  FROM reviews r
  GROUP BY r.property_id
  HAVING AVG(r.rating) > 4.0
)
ORDER BY p.name;

-- =========================================================
-- 2) Correlated subquery:
-- Find users (guests) who have made more than 3 bookings.
-- =========================================================
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.user_id
  ) AS booking_count
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM bookings b
    WHERE b.user_id = u.user_id
) > 3
ORDER BY booking_count DESC;
