-- =========================
-- MESSAGES
-- =========================
CREATE INDEX IF NOT EXISTS idx_messages_sender_time    ON messages(sender_id, sent_at);
CREATE INDEX IF NOT EXISTS idx_messages_recipient_time ON messages(recipient_id, sent_at);

-- =========================
-- PERFORMANCE TEST (demo)
-- =========================
-- Measure query performance before and after indexes
-- Example: check how bookings join properties
EXPLAIN ANALYZE
SELECT p.property_id, p.name, COUNT(b.booking_id) AS booking_count
FROM properties p
LEFT JOIN bookings b ON b.property_id = p.property_id
GROUP BY p.property_id, p.name
ORDER BY booking_count DESC
LIMIT 10;
