---
name: innotrafik-db
description: Query the innotrafik PostgreSQL/TimescaleDB databases from the terminal. Use whenever you need to run SQL against the local dev DB or production (read-only) — pi has no postgres MCP, so go through psql wrapped in the env-injection tooling. Triggers on "query the database", "check prod data", "run this SQL", "what's in table X", debugging data issues, or inspecting schema at runtime.
---

# innotrafik database access (terminal / psql)

pi has **no MCP**, so unlike Claude Code there are no `postgres_dev`/`postgres_prod` MCP tools. Query via `psql`, but connection strings are **not** in the ambient shell — they are injected by `innoenv` (or `infisical`). Always wrap psql in one of those.

## Connection env keys

| Key | Points at | Use for |
|-----|-----------|---------|
| `DATABASE_URL` | local dev DB (`postgres://postgres:postgres@localhost:<port>/local`) | everyday dev, read/write, expensive test queries |
| `PRODUCTION_DATABASE_URL_READONLY` | production, read-only credentials | prod analytics, debugging — **prefer this for prod** |
| `PRODUCTION_DATABASE_URL_ROOT` | production, root credentials | rare; only when a write/DDL on prod is genuinely required |

These resolve from `env.toml` + the encrypted Infisical vault. They are injected into a child process — they are NOT exported into your interactive shell.

## How to run queries

**Local dev DB** (Docker must be up — `pnpm devctl services start`):

```bash
innoenv run platform -- bash -c 'psql "$DATABASE_URL" -c "SELECT 1"'
```

**Production, read-only** (the documented fallback when MCP is unavailable):

```bash
infisical run --env=dev -- bash -c 'psql "$PRODUCTION_DATABASE_URL_READONLY" -c "SELECT now()"'
```

`innoenv run <project> -- <cmd>` also works for prod keys if the project lists them (e.g. the migrate/seed scripts list `PRODUCTION_DATABASE_URL_READONLY`). When unsure which project exposes a key, `infisical run --env=dev` is the reliable wrapper.

## Rules (carry over from the repo's CLAUDE.md)

1. **Check the schema first** in `packages/db-drizzle/src/schema/`. Drizzle uses camelCase in TS but maps to **snake_case** in SQL — get column names right before querying.
2. **Always time-bound queries on TimescaleDB hypertables**: `WHERE time > NOW() - INTERVAL '...'`. Unbounded scans over hypertables are expensive.
3. **Default to read-only on prod.** Use `PRODUCTION_DATABASE_URL_READONLY`, never `_ROOT`, unless a write is explicitly required and confirmed.
4. For multi-statement or script-shaped work, prefer `psql "$URL" -f file.sql` over cramming into `-c`.

## Quick recipes

```bash
# List tables
innoenv run platform -- bash -c 'psql "$DATABASE_URL" -c "\dt"'

# Describe a table
innoenv run platform -- bash -c 'psql "$DATABASE_URL" -c "\d+ incidents"'

# Recent rows from a hypertable (time-bounded)
infisical run --env=dev -- bash -c \
  'psql "$PRODUCTION_DATABASE_URL_READONLY" -c "SELECT * FROM telemetry_signal WHERE time > NOW() - INTERVAL '"'"'1 hour'"'"' LIMIT 20"'
```
