# Optimization Report — Complex Booking Query

## 1. Initial Query
The initial query retrieves:
- Bookings
- User (guest) details
- Property details
- Payment details

It joins **4 tables** and uses `SELECT *`-style output.  
Without filters, this forces PostgreSQL to scan large parts of the **bookings** table and sort a lot of rows.

---

## 2. Performance Analysis
Run with:
```sql
EXPLAIN ANALYZE
-- initial query (see perfomance.sql)
