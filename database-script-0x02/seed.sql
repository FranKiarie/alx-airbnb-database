-- ALX Airbnb Database — Seed Data (PostgreSQL)

-- ================
-- USERS
-- ================
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role)
VALUES
('Wanjiru','Njeri','njeri@example.com','hashed_pw1','+254711111111','host'),
('Brian','Otieno','otieno@example.com','hashed_pw2','+254722222222','host'),
('Francis','Kiarie','francis@example.com','hashed_pw3','+254733333333','guest'),
('Amina','Yusuf','amina@example.com','hashed_pw4','+254744444444','guest'),
('Admin','User','admin@example.com','hashed_pw5','+254700000000','admin')
ON CONFLICT DO NOTHING;

-- ================
-- PROPERTIES
-- ================
INSERT INTO properties (host_id, name, description, location, price_per_night)
SELECT user_id, 'Sunny Apartment', '2-bed apartment in Nairobi, ideal for business travelers.', 'Nairobi, Kenya', 9500
FROM users WHERE email='njeri@example.com';

INSERT INTO properties (host_id, name, description, location, price_per_night)
SELECT user_id, 'Lake Cottage', 'Cozy cottage by Lake Naivasha with garden and fireplace.', 'Naivasha, Kenya', 12000
FROM users WHERE email='otieno@example.com';

INSERT INTO properties (host_id, name, description, location, price_per_night)
SELECT user_id, 'Milimani Bungalow', 'Family-friendly home with workspace and garden.', 'Nakuru, Kenya', 8000
FROM users WHERE email='otieno@example.com';

-- ================
-- BOOKINGS
-- ================
-- Francis books Sunny Apartment
INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
SELECT p.property_id, u.user_id, DATE '2025-09-20', DATE '2025-09-23', 28500, 'confirmed'
FROM properties p JOIN users u ON u.email='francis@example.com'
WHERE p.name='Sunny Apartment';

-- Amina books Lake Cottage
INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
SELECT p.property_id, u.user_id, DATE '2025-10-05', DATE '2025-10-08', 36000, 'pending'
FROM properties p JOIN users u ON u.email='amina@example.com'
WHERE p.name='Lake Cottage';

-- Francis books Milimani Bungalow
INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
SELECT p.property_id, u.user_id, DATE '2025-11-15', DATE '2025-11-18', 24000, 'confirmed'
FROM properties p JOIN users u ON u.email='francis@example.com'
WHERE p.name='Milimani Bungalow';

-- ================
-- PAYMENTS
-- ================
-- Payment for Francis’s confirmed booking at Sunny Apartment
INSERT INTO payments (booking_id, amount, payment_method)
SELECT b.booking_id, b.total_price, 'credit_card'
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
JOIN users u ON b.user_id = u.user_id
WHERE u.email='francis@example.com' AND p.name='Sunny Apartment'
ON CONFLICT DO NOTHING;

-- Payment for Francis’s confirmed booking at Milimani Bungalow
INSERT INTO payments (booking_id, amount, payment_method)
SELECT b.booking_id, b.total_price, 'paypal'
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
JOIN users u ON b.user_id = u.user_id
WHERE u.email='francis@example.com' AND p.name='Milimani Bungalow'
ON CONFLICT DO NOTHING;

-- ================
-- REVIEWS
-- ================
INSERT INTO reviews (property_id, user_id, rating, comment)
SELECT p.property_id, u.user_id, 5, 'Fantastic stay — very clean and well located!'
FROM properties p JOIN users u ON u.email='francis@example.com'
WHERE p.name='Sunny Apartment'
ON CONFLICT DO NOTHING;

INSERT INTO reviews (property_id, user_id, rating, comment)
SELECT p.property_id, u.user_id, 4, 'Great cottage, but WiFi could be faster.'
FROM properties p JOIN users u ON u.email='amina@example.com'
WHERE p.name='Lake Cottage'
ON CONFLICT DO NOTHING;

-- ================
-- MESSAGES
-- ================
-- Guest Francis asks Host Otieno about Lake Cottage
INSERT INTO messages (sender_id, recipient_id, message_body)
SELECT u1.user_id, u2.user_id, 'Hi Brian, is Lake Cottage available in December?'
FROM users u1, users u2
WHERE u1.email='francis@example.com' AND u2.email='otieno@example.com';

-- Host replies
INSERT INTO messages (sender_id, recipient_id, message_body)
SELECT u2.user_id, u1.user_id, 'Hi Francis, yes it will be available then!'
FROM users u1, users u2
WHERE u1.email='francis@example.com' AND u2.email='otieno@example.com';
