# Supabase Migrations

This folder contains SQL migration scripts for the UniteUp database.

## How to Run Migrations

### Option 1: SQL Editor (Recommended for manual deployment)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project (UniteUp Prod or UniteUp Test)
3. Navigate to **SQL Editor**
4. Copy the contents of the migration file
5. Paste and click **Run**

### Option 2: Supabase CLI

```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase link --project-ref <project-id>

# Run migrations
supabase db push
```

## Migration Files

| File                              | Description                                            |
| --------------------------------- | ------------------------------------------------------ |
| `20251208_create_users_table.sql` | Creates users table with RLS and auto-creation trigger |

## Project References

| Environment | Project ID             | Dashboard                                                                |
| ----------- | ---------------------- | ------------------------------------------------------------------------ |
| Production  | `xpvlzijuritygpqxpnqs` | [Dashboard](https://supabase.com/dashboard/project/xpvlzijuritygpqxpnqs) |
| Test        | `tirmgcuolvvzjkaaykhu` | [Dashboard](https://supabase.com/dashboard/project/tirmgcuolvvzjkaaykhu) |
