# ERD Requirements — ALX Airbnb Database

This document describes the entities, attributes, and relationships you must include in your ER diagram for an Airbnb-like system.

---

## 1) Entities & Attributes (minimum)

Use plural table names and UUID primary keys.

### 1.1 Users
- `user_id` (UUID, PK)
- `first_name` (varchar(100), NOT NULL)
- `last_name` (varchar(100), NOT NULL)
- `email` (varchar(100), NOT NULL, UNIQUE)
- `password_hash` (varchar(256), NOT NULL)
- `phone_number` (varchar(15))
- `role` (enum: `guest` | `host` | `admin`, NOT NULL)
- `created_at` (timestamp, NOT NULL)

### 1.2 Properties
- `property_id` (UUID, PK)
- `host_id` (UUID, FK → Users.user_id, NOT NULL)
- `name` (varchar(200), NOT NULL)
- `description` (text)
- `location` (varchar(200), NOT NULL)
- `price_per_night` (decimal(10,2), NOT NULL)
- `created_at` (timestamp, NOT NULL)
- `updated_at` (timestamp, NOT NULL)

### 1.3 Bookings
- `booking_id` (UUID, PK)
- `property_id` (UUID, FK → Properties.property_id, NOT NULL)
- `user_id` (UUID, FK → Users.user_id, NOT NULL)  <!-- guest -->
- `start_date` (date, NOT NULL)
- `end_date` (date, NOT NULL; must be > start_date)
- `total_price` (decimal(10,2), NOT NULL)
- `status` (enum: `pending` | `confirmed` | `cancelled`, NOT NULL)
- `created_at` (timestamp, NOT NULL)

### 1.4 Payments
- `payment_id` (UUID, PK)
- `booking_id` (UUID, FK → Bookings.booking_id, NOT NULL)  <!-- 1:1 in MVP -->
- `amount` (decimal(10,2), NOT NULL)
- `payment_date` (timestamp, NOT NULL)
- `payment_method` (enum: `credit_card` | `paypal` | `stripe`, NOT NULL)

### 1.5 Reviews
- `review_id` (UUID, PK)
- `property_id` (UUID, FK → Properties.property_id, NOT NULL)
- `user_id` (UUID, FK → Users.user_id, NOT NULL)  <!-- reviewer (guest) -->
- `rating` (int, 1..5, NOT NULL)
- `comment` (text)
- `created_at` (timestamp, NOT NULL)

### 1.6 Messages
- `message_id` (UUID, PK)
- `sender_id` (UUID, FK → Users.user_id, NOT NULL)
- `recipient_id` (UUID, FK → Users.user_id, NOT NULL; must be <> sender_id)
- `message_body` (text, NOT NULL)
- `sent_at` (timestamp, NOT NULL)

> Optional later: reference tables (e.g., Amenity, PropertyPhotos) can be added without changing the core ERD.

---

## 2) Relationships (cardinality & notes)

- **Users (host) 1 — N Properties**
  - Each property is owned by exactly one host (`Properties.host_id → Users.user_id`).

- **Users (guest) 1 — N Bookings**
  - A guest can make many bookings (`Bookings.user_id → Users.user_id`).

- **Properties 1 — N Bookings**
  - A property can have many bookings (`Bookings.property_id → Properties.property_id`).

- **Bookings 1 — 1 Payments** (MVP)
  - One payment per booking (`Payments.booking_id → Bookings.booking_id`).
  - Can be extended to 1—N in future (split deposits/refunds).

- **Properties 1 — N Reviews**
  - Many reviews per property (`Reviews.property_id → Properties.property_id`).

- **Users 1 — N Reviews**
  - A user (guest) can write many reviews (`Reviews.user_id → Users.user_id`).

- **Users 1 — N Messages (as sender)**
  - `Messages.sender_id → Users.user_id`

- **Users 1 — N Messages (as recipient)**
  - `Messages.recipient_id → Users.user_id`
  - Constraint: `sender_id <> recipient_id`

**Business rules (capture as notes in the diagram):**
- Only users with `role = 'host'` can own properties.
- `end_date` must be after `start_date`.
- `rating` must be 1..5.
- Allowed `status`: `pending | confirmed | cancelled`.
- Allowed `payment_method`: `credit_card | paypal | stripe`.

---

# 3) Acceptance Checklist

- [ ] All six entities present with required attributes.  
- [ ] PKs and FKs labeled in the diagram.  
- [ ] Relationships drawn with correct cardinalities.  
- [ ] Business rules noted (status, payment_method, rating, end_date > start_date, host owns property).  
- [ ] Diagram exported and committed to `ERD/erd.png` or `ERD/erd.pdf`.



https://miro.com/app/board/uXjVJQKDO-4=/?share_link_id=367318560059
