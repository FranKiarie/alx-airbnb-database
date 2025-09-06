-- Partitioning Bookings by start_date (PostgreSQL RANGE partitions)
-- Safe to run multiple times; drops only the demo partitioned table.

-- 0) (Demo setup) Ensure base tables exist (users/properties already in your schema)

-- 1) Create a partitioned clone of bookings (same columns, partitioned by start_date)
DROP TABLE IF EXISTS bookings_part CASCADE;

CREATE TABLE bookings_part (
  booking_id   UUID PRIMARY KEY,
  property_id  UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  start_date   DATE NOT NULL,
  end_date     DATE NOT NULL,
  total_price  DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
  status       VARCHAR(20) NOT NULL CHECK (status IN ('pending','confirmed','cancelled')),
  created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
  CHECK (start_date < end_date)
) PARTITION BY RANGE (start_date);

-- 2) Yearly partitions (adjust or add as needed)
CREATE TABLE IF NOT EXISTS bookings_part_2023 PARTITION OF bookings_part
  FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE IF NOT EXISTS bookings_part_2024 PARTITION OF bookings_part
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE IF NOT EXISTS bookings_part_2025 PARTITION OF bookings_part
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE IF NOT EXISTS bookings_part_default PARTITION OF bookings_part DEFAULT;

-- 3) Indexes on each partition (not inherited automatically)
-- Tailor to your query patterns (user, property, status, date)
CREATE INDEX IF NOT EXISTS idx_bpart_2023_user       ON bookings_part_2023(user_id);
CREATE INDEX IF NOT EXISTS idx_bpart_2023_property   ON bookings_part_2023(property_id);
CREATE INDEX IF NOT EXISTS idx_bpart_2023_status     ON bookings_part_2023(status);
CREATE INDEX IF NOT EXISTS idx_bpart_2023_start_date ON bookings_part_2023(start_date);

CREATE INDEX IF NOT EXISTS idx_bpart_2024_user       ON bookings_part_2024(user_id);
CREATE INDEX IF NOT EXISTS idx_bpart_2024_property   ON bookings_part_2024(property_id);
CREATE INDEX IF NOT EXISTS idx_bpart_2024_status     ON bookings_part_2024(status);
CREATE INDEX IF NOT EXISTS idx_bpart_2024_start_date ON bookings_part_2024(start_date);

CREATE INDEX IF NOT EXISTS idx_bpart_2025_user       ON bookings_part_2025(user_id);
CREATE INDEX IF NOT EXISTS idx_bpart_2025_property   ON bookings_part_2025(property_id);
CREATE INDEX IF NOT EXISTS idx_bpart_2025_status     ON bookings_part_2025(status);
CREATE INDEX IF NOT EXISTS idx_bpart_2025_start_date ON bookings_part_2025(start_date);

-- 4) (Optional) Copy data from the original bookings into the partitioned table for testing
-- Comment in the range you want to copy:
-- INSERT INTO bookings_part (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
-- SELECT booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at
-- FROM bookings
-- WHERE start_date >= DATE '2023-01-01' AND start_date < DATE '2026-01-01';

-- 5) (Optional) Route writes automatically (if you want to start using bookings_part)
-- You can create a VIEW that replaces bookings, or application-level writes target bookings_part.
-- Example VIEW (read-only demo):
-- DROP VIEW IF EXISTS bookings_view;
-- CREATE VIEW bookings_view AS SELECT * FROM bookings_part;

-- 6) Performance test: partition pruning demo (adjust dates to your data)
EXPLAIN (ANALYZE, BUFFERS)
SELECT booking_id, property_id, user_id, start_date, end_date, status
FROM bookings_part
WHERE start_date BETWEEN DATE '2025-06-01' AND DATE '2025-06-30'
  AND status = 'confirmed'
ORDER BY start_date;
