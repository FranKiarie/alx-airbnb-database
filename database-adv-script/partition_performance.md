# Partition Performance Report — bookings by start_date

## Setup
- Created `bookings_part` partitioned by `RANGE (start_date)`
- Partitions: 2024, 2025, 2026 + DEFAULT
- Added per-partition indexes on (`user_id`, `property_id`, `status`, `start_date`)

## Test Query
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM bookings_part
WHERE start_date BETWEEN DATE '2025-06-01' AND DATE '2025-06-30'
  AND status = 'confirmed'
ORDER BY start_date;
