# Index Performance — ALX Airbnb

This document shows the indexes we created and how to measure performance before and after using them.

---

## 1. Indexes Created
We identified high-usage columns in **users**, **properties**, and **bookings**.  
See `database_index.sql` for the full SQL with `CREATE INDEX` commands:

```sql
CREATE INDEX idx_users_email       ON users(email);
CREATE INDEX idx_users_role        ON users(role);
CREATE INDEX idx_properties_host   ON properties(host_id);
CREATE INDEX idx_properties_price  ON properties(price_per_night);
CREATE INDEX idx_bookings_user     ON bookings(user_id);
CREATE INDEX idx_bookings_property ON bookings(property_id);
CREATE INDEX idx_bookings_status   ON bookings(status);
