# Index Performance — ALX Airbnb (PostgreSQL)

This note shows **where** we added indexes and **how** to measure their impact with `EXPLAIN ANALYZE`.

---

## 1) Why these indexes?

- **users(email, role, created_at, email_trgm)**  
  Fast login lookups, admin filters, and recent-user lists. `pg_trgm` helps ILIKE searches.

- **properties(host_id, price_per_night, created_at, location_trgm)**  
  Typical host dashboards, price sorting, and location text searches.

- **bookings(user_id, property_id, (property_id, start_date, end_date), status, created_at, start_date BRIN)**  
  Common joins + date windows. Partial index for `status='confirmed'` accelerates availability checks.  
  BRIN is great for very large tables scanned by date ranges.

- **payments(payment_date, payment_method)**  
  Speed up reports and ledgers.

- **reviews(property_id, created_at)**  
  “Latest reviews for a listing” becomes index-friendly.

- **messages(sender_id, recipient_id, sent_at)**  
  Chat inbox/outbox pagination.

---

## 2) How to measure

### A) Before adding indexes
```sql
EXPLAIN ANALYZE
SELECT p.property_id, p.name, AVG(r.rating) AS avg_rating
FROM properties p
LEFT JOIN reviews r ON r.property_id = p.property_id
GROUP BY p.property_id, p.name
ORDER BY avg_rating DESC NULLS LAST
LIMIT 20;
