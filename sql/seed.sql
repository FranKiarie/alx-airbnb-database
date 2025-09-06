-- Sample data 

-- Users
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role) VALUES
('Wanjiru','Njeri','njeri@example.com','hashed_pw1','+254711111111','host'),
('Brian','Otieno','otieno@example.com','hashed_pw2','+254722222222','host'),
('Francis','Kiarie','francis@example.com','hashed_pw3','+254733333333','guest'),
('Amina','Yusuf','amina@example.com','hashed_pw4','+254744444444','guest');

-- Properties
INSERT INTO properties (host_id, name, description, location, price_per_night)
SELECT user_id, 'Sunny Apartment', '2-bed apartment in Nairobi', 'Nairobi, Kenya', 9500
FROM users WHERE email='njeri@example.com';

INSERT INTO properties (host_id, name, description, location, price_per_night)
SELECT user_id, 'Lake Cottage', 'Cozy cottage by Lake Naivasha', 'Naivasha, Kenya', 12000
FROM users WHERE email='otieno@example.com';

-- Bookings
INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
SELECT p.property_id, u.user_id, '2025-09-20', '2025-09-23', 28500, 'confirmed'
FROM properties p JOIN users u ON u.email='francis@example.com'
WHERE p.name='Sunny Apartment';

-- Payments
INSERT INTO payments (booking_id, amount, payment_method)
SELECT booking_id, 28500, 'credit_card'
FROM bookings LIMIT 1;

-- Reviews
INSERT INTO reviews (property_id, user_id, rating, comment)
SELECT p.property_id, u.user_id, 5, 'Excellent stay, very clean!'
FROM properties p JOIN users u ON u.email='francis@example.com'
WHERE p.name='Sunny Apartment';

-- Messages
INSERT INTO messages (sender_id, recipient_id, message_body)
SELECT u1.user_id, u2.user_id, 'Hi, is the cottage available in October?'
FROM users u1, users u2
WHERE u1.email='francis@example.com' AND u2.email='otieno@example.com';
