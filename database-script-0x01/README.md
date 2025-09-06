# Database Schema (DDL)

This folder contains the SQL to create the **ALX Airbnb** database tables, constraints, and indexes.

## Files
- `schema.sql` — creates all tables (users, properties, bookings, payments, reviews, messages), primary/foreign keys, checks, and helpful indexes.

## How to run (PostgreSQL)
```bash
# 1) Create a database (once)
createdb alx_airbnb

# 2) Apply schema
psql -d alx_airbnb -f database-script-0x01/schema.sql
