-- Database Indexes — ALX Airbnb (PostgreSQL)

-- Users
CREATE INDEX IF NOT EXISTS idx_users_email       ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role        ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at  ON users(created_at);

-- Properties
CREATE INDEX IF NOT EXISTS idx_properties_host       ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_price      ON properties(price_per_night);
CREATE INDEX IF NOT EXISTS idx_properties_created_at ON properties(created_at);

-- Bookings
CREATE INDEX IF NOT EXISTS idx_bookings_user         ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property     ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status       ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at   ON bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_bookings_dates
  ON bookings(property_id, start_date, end_date);
