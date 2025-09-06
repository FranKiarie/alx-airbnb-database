# Performance Monitoring & Refinement — ALX Airbnb (PostgreSQL)

This document shows how we **measure**, **identify bottlenecks**, **apply fixes** (indexes / query refactors), and **report improvements**.

> Note: `SHOW PROFILE` is a MySQL feature. For PostgreSQL, prefer `EXPLAIN (ANALYZE, BUFFERS)` and `pg_stat_statements`.

---

## 1) Tools & Setup

### 1.1 One-off plan inspection
Use for any query you care about:
```sql
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT ...;  -- your query here
