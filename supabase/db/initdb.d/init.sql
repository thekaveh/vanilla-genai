-- Enable extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create users table as per example
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create app user if not exists
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${SUPABASE_DB_APP_USER}') THEN
    CREATE USER "${SUPABASE_DB_APP_USER}" WITH PASSWORD '${SUPABASE_DB_APP_PASSWORD}';
  END IF;
END
$$;

-- Grant privileges to app user
GRANT CONNECT ON DATABASE "${SUPABASE_DB_NAME}" TO "${SUPABASE_DB_APP_USER}";
GRANT USAGE ON SCHEMA public TO "${SUPABASE_DB_APP_USER}";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "${SUPABASE_DB_APP_USER}";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "${SUPABASE_DB_APP_USER}";