# Supabase Migrations

This folder contains SQL migration scripts for the UniteUp database.

## Local Development Setup

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [Supabase CLI](https://supabase.com/docs/guides/cli) installed (`npm install -g supabase`)

### Start Local Supabase

```bash
# Start local Supabase (from project root)
supabase start

# Stop local Supabase
supabase stop

# Reset database (applies all migrations from scratch)
supabase db reset
```

### Local Development URLs

| Service     | URL                                                     |
| ----------- | ------------------------------------------------------- |
| API         | http://127.0.0.1:54321                                  |
| Studio (UI) | http://127.0.0.1:54323                                  |
| Database    | postgresql://postgres:postgres@127.0.0.1:54322/postgres |
| Mailpit     | http://127.0.0.1:54324                                  |

### Environment Configuration

Use `.env.local` for local development:

```bash
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=<your-local-anon-key>
```

The anon key is displayed when running `supabase start`.

---

## How to Run Migrations

### Option 1: Local Development (Recommended)

Migrations are automatically applied when running `supabase start` or `supabase db reset`.

To create a new migration:

```bash
supabase migration new <migration_name>
```

### Option 2: SQL Editor (For remote deployment)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project (UniteUp Prod or UniteUp Test)
3. Navigate to **SQL Editor**
4. Copy the contents of the migration file
5. Paste and click **Run**

### Option 3: Push to Remote

```bash
# Link to your project (one-time setup)
supabase link --project-ref <project-id>

# Push migrations to remote
supabase db push

# Push config
supabase config push
```

## Migration Files

| File                                                  | Description                                            |
| ----------------------------------------------------- | ------------------------------------------------------ |
| `20251208000000_create_users_table.sql`               | Creates users table with RLS and auto-creation trigger |
| `20251208000001_create_challenges_tables.sql`         | Creates challenges, goals, members, events tables      |
| `20251209000000_enable_realtime_challenge_events.sql` | Enables realtime for challenge events                  |

## Project References

| Environment | Project ID             | Dashboard                                                                |
| ----------- | ---------------------- | ------------------------------------------------------------------------ |
| Production  | `xpvlzijuritygpqxpnqs` | [Dashboard](https://supabase.com/dashboard/project/xpvlzijuritygpqxpnqs) |
| Test        | `tirmgcuolvvzjkaaykhu` | [Dashboard](https://supabase.com/dashboard/project/tirmgcuolvvzjkaaykhu) |
| Local       | N/A                    | [Studio](http://127.0.0.1:54323)                                         |
