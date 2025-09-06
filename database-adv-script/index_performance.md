# Index Performance — ALX Airbnb (PostgreSQL)

This note documents indexes we added **and** a before/after measurement using **EXPLAIN ANALYZE**.

---

## Index targets (high-usage columns)
- **users**: `email` (login lookups), `role` (admin filters), `created_at` (recent users)
- **properties**: `host_id` (host dashboards), `price_per_night` (sorting), `created_at`
- **bookings**: `user_id`, `property_id`, `status`, `created_at`, `(property_id, start_date, end_date)` for date-window searches

See `database_index.sql` for the `CREATE INDEX` SQL.

---

## Measure performance: BEFORE indexes
Run this **before** applying indexes:

```sql
EXPLAIN ANALYZE
SELECT p.property_id, p.name, COUNT(b.booking_id) AS bookings
FROM properties p
LEFT JOIN bookings b ON b.property_id = p.property_id
GROUP BY p.property_id, p.name
ORDER BY bookings DESC
LIMIT 20;
