# Normalization to 3NF — ALX Airbnb Database

This document shows how the current schema (Users, Properties, Bookings, Payments, Reviews, Messages) satisfies **Third Normal Form (3NF)** and notes optional refinements.

---

## 0) Notation & Keys

- Every table uses a **single-attribute UUID PK** (e.g., `users.user_id`).  
- Standard FKs:
  - `properties.host_id → users.user_id`
  - `bookings.user_id → users.user_id`
  - `bookings.property_id → properties.property_id`
  - `payments.booking_id → bookings.booking_id`
  - `reviews.user_id → users.user_id`
  - `reviews.property_id → properties.property_id`
  - `messages.sender_id → users.user_id`
  - `messages.recipient_id → users.user_id`

---

## 1) First Normal Form (1NF)

**Rules:** atomic values, no repeating groups, rows uniquely identifiable.

- **Atomic attributes:**  
  `first_name`, `last_name` (split), `start_date`, `end_date` (no multi-valued or nested fields).  
- **No repeating groups:** each fact stored once per row.  
- **Primary keys:** all tables have UUID PKs.

✅ **Conclusion:** All tables meet 1NF.

---

## 2) Second Normal Form (2NF)

**Rule:** no partial dependency of non-key attributes on part of a composite key.  
**Note:** All tables use a **single-column PK** (UUID), not composite keys → partial dependencies can’t exist.

✅ **Conclusion:** All tables meet 2NF by design.

---

## 3) Third Normal Form (3NF)

**Rule:** no transitive dependencies; non-key attributes must depend **only** on the key.

### 3.1 `users`
- **FDs:** `user_id → first_name, last_name, email, password_hash, phone_number, role, created_at`.  
- No attribute depends on another non-key attribute (e.g., `role` doesn’t determine any other column).  
✅ 3NF satisfied.

### 3.2 `properties`
- **FDs:** `property_id → host_id, name, description, location, price_per_night, created_at, updated_at`.  
- Non-key attributes do not determine each other (e.g., `host_id` does not determine `name`).  
- `location` is a free-text attribute by design (see “optional refinements”).  
✅ 3NF satisfied.

### 3.3 `bookings`
- **FDs:** `booking_id → property_id, user_id, start_date, end_date, total_price, status, created_at`.  
- `total_price` is **derivable** from nights × property price (+ fees). Keeping it is a **materialized/denormalized convenience** for performance and audit. It still functionally depends on `booking_id` only, so **3NF is not violated**.  
- `status` is constrained to (`pending`,`confirmed`,`cancelled`) and depends only on the PK.  
✅ 3NF satisfied.

### 3.4 `payments`
- **FDs:** `payment_id → booking_id, amount, payment_date, payment_method`.  
- Depends only on `payment_id`.  
- Note on duplication: if you also store `bookings.total_price`, ensure a business rule that `payments.amount` reflects actual money movement (may equal total, deposit, refund, etc.). No transitive dependency present.  
✅ 3NF satisfied.

### 3.5 `reviews`
- **FDs:** `review_id → property_id, user_id, rating, comment, created_at`.  
- `rating` depends only on `review_id`. No transitive dependencies.  
✅ 3NF satisfied.

### 3.6 `messages`
- **FDs:** `message_id → sender_id, recipient_id, message_body, sent_at`.  
- `sender_id <> recipient_id` constraint prevents self-message but doesn’t introduce dependency.  
✅ 3NF satisfied.

---

## 4) Potential Redundancies & How We Handle Them

1) **`bookings.total_price` (derivable)**  
   - Kept intentionally for performance/audit.  
   - **Rule:** treat as *materialized value*; keep app/service logic to recompute and compare if prices change.

2) **`payments.amount` vs `bookings.total_price`**  
   - Not necessarily duplication (can represent actual paid amount; bookings may have multiple payments later).  
   - For MVP 1:1 it often equals total, but we keep it to model the real payment.

3) **`properties.location` (free text)**  
   - In strict normalization you might split into `locations(city, country, …)` with FKs.  
   - **Decision:** keep as text now (fits scope). This is not a 3NF violation (still depends on PK), but normalization could improve consistency later.

---

## 5) Optional Refinements (still 3NF)

These are **nice-to-haves**, not required for 3NF:

- **Lookup tables** for constrained values
  - `roles(role)` for users  
  - `booking_statuses(status)` for bookings  
  - `payment_methods(method)` for payments  
  Pros: central validation, easier future changes; Cons: more joins.

- **Location normalization**
  - `countries`, `cities`, `properties(location_id FK)`; prevents typos in city names.

- **Unique/behavioral constraints**
  - One review per user per property (enforce via unique index on `(property_id, user_id)` if desired).
  - If you later allow **multiple payments per booking**, drop the `UNIQUE` on `payments.booking_id` and track `payment_type` (deposit, capture, refund).

---

## 6) Final Verdict

- The current schema **meets 3NF**:  
  - No repeating groups (1NF),  
  - No partial dependencies (2NF),  
  - No transitive dependencies (3NF).  
- Any “duplication” present is **intentional** (performance/audit) and still functionally dependent on the table’s PK, which remains compliant with 3NF.

---

## 7) Change Log (if you adjusted design to reach 3NF)

- _Example (fill if you changed anything):_  
  - Removed combined `name` → split into `first_name`, `last_name` (1NF).  
  - Ensured single-column UUID PKs everywhere (simplifies 2NF).  
  - Confirmed no non-key → non-key dependencies across all tables (3NF).
