# database-reviewer Skill

**Trigger**: "SQL", "migration", "schema", "query", "postgres", "database", "prisma", "drizzle"

**Purpose**: PostgreSQL specialist for query optimization, schema design, security, and performance.

## When to Use

MUST be used when:
- Writing SQL queries
- Creating/modifying migrations
- Designing schemas
- Adding indexes
- Implementing Row Level Security (RLS)
- Working with ORMs

## Checklist

### Query Performance (CRITICAL)
- [ ] WHERE/JOIN columns indexed
- [ ] Check `EXPLAIN ANALYZE` for Seq Scans
- [ ] Watch for N+1 patterns
- [ ] Composite index column order (equality first, then range)

### Schema Design (HIGH)
- [ ] `bigint` for IDs, `text` for strings, `timestamptz` for timestamps
- [ ] Proper constraints: PK, FK with `ON DELETE`, `NOT NULL`
- [ ] `lowercase_snake_case` identifiers

### Security (CRITICAL)
- [ ] RLS enabled on multi-tenant tables
- [ ] RLS policy columns indexed
- [ ] Least privilege access

### Anti-Patterns to Flag
- `SELECT *` in production
- `int` for IDs (use `bigint`)
- `timestamp` without timezone
- OFFSET pagination on large tables
- Unparameterized queries (SQL injection)
