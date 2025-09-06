# Database Seed (DML)

This folder contains `seed.sql`, which populates the **ALX Airbnb Database** with realistic sample data.

## What it includes
- **Users**: 2 hosts, 2 guests, 1 admin
- **Properties**: 3 listings (Nairobi, Naivasha, Nakuru)
- **Bookings**: multiple bookings by guests, with different statuses
- **Payments**: payments for confirmed bookings
- **Reviews**: guest reviews for properties
- **Messages**: conversation between guest and host

## How to run (PostgreSQL)
Run after applying the schema from `database-script-0x01/schema.sql`.

```bash
psql -d alx_airbnb -f database-script-0x02/seed.sql
