# database-reviewer Skill

**Trigger**: "SQL", "migration", "schema", "query", "postgres", "database", "prisma", "drizzle", "kysely", "index", "N+1", "slow query"
**Purpose**: PostgreSQL specialist for query optimization, schema design, security, and performance.

## When to Use

MUST be used when:

- Writing SQL queries
- Creating/modifying migrations
- Designing schemas
- Adding indexes
- Implementing Row Level Security (RLS)
- Working with ORMs (Kysely, Prisma, Drizzle)
- Reviewing slow queries or performance issues

## Checklist

### Query Performance (CRITICAL)

- [ ] WHERE/JOIN columns indexed
- [ ] Run `EXPLAIN ANALYZE` — look for Seq Scan (bad), Index Scan (good)
- [ ] Watch for N+1 patterns — use JOINs or batch loading
- [ ] Composite index column order (equality first, then range)
- [ ] Avoid `SELECT *` — fetch only needed columns
- [ ] No OFFSET pagination on large tables — use cursor-based

### Schema Design (HIGH)

- [ ] `bigint` for IDs, `text` for strings, `timestamptz` for timestamps
- [ ] Proper constraints: PK, FK with `ON DELETE`, `NOT NULL`
- [ ] `lowercase_snake_case` identifiers
- [ ] Index every foreign key (joins need it)
- [ ] Partial indexes for common filtered queries

```sql
  CREATE INDEX idx_posts_published
  ON posts(published_at DESC)
  WHERE status = 'published';
```

- [ ] GIN indexes for full-text search and pgvector similarity

### Migrations (HIGH)

- [ ] Always reversible — write DOWN migration
- [ ] Never lock tables in production — use `CONCURRENTLY`

```sql
  -- Safe: doesn't lock
  CREATE INDEX CONCURRENTLY idx_posts_user_id ON posts(user_id);
  -- Unsafe: locks table
  CREATE INDEX idx_posts_user_id ON posts(user_id);
```

- [ ] PostgreSQL 11+: `ADD COLUMN ... DEFAULT` doesn't rewrite table
- [ ] Run inside transaction when possible

### Security (CRITICAL)

- [ ] RLS enabled on multi-tenant tables
- [ ] RLS policy columns indexed
- [ ] Least privilege access
- [ ] No unparameterized queries (SQL injection)

## Anti-Patterns to Flag

- `SELECT *` in production
- `int` for IDs (use `bigint`)
- `timestamp` without timezone (use `timestamptz`)
- OFFSET pagination on large tables (use cursor)
- Unparameterized queries
- Missing index on foreign keys
- `CREATE INDEX` without `CONCURRENTLY` in production migrations
- N+1 queries in application code
