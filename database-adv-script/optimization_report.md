# Optimization Report — Complex Booking Query

## 1) Initial Query
- Joined **bookings + users + properties + payments** with broad SELECT and no strong filters.
- On large datasets this tends to produce:
  - High row counts through the plan
  - Seq Scans on `bookings` and `properties`
  - Expensive sorts for ORDER BY

**Plan to collect**:
```sql
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
WITH booking_details AS ( ...initial query... )
SELECT * FROM booking_details
ORDER BY booking_created_at DESC, booking_id
LIMIT 200;
