-- Enable extensions if not already enabled
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create llms table to store model information
create table public.llms (
  id bigint generated by default as identity not null,
  active boolean not null default false,
  vision boolean not null default false,
  content boolean not null default false,
  structured_content boolean not null default false,
  embeddings boolean not null default false,
  provider character varying not null,
  name character varying not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint llms_pkey primary key (id),
  constraint llms_id_key unique (id),
  constraint llms_name_key unique (name)
) TABLESPACE pg_default;

-- Insert default Ollama models
INSERT INTO llms (name, provider, active, embeddings, content) VALUES
    ('mxbai-embed-large', 'ollama', true, true, false),
    ('deepseek-r1:1.5b', 'ollama', true, false, true);

-- Add authentication entry to pg_hba.conf to allow all connections
\connect postgres
\set pgdata `echo "$PGDATA"`
\set hba_path :pgdata '/pg_hba.conf'
\! echo "host all all 0.0.0.0/0 trust" >> /var/lib/postgresql/data/pg_hba.conf
SELECT pg_reload_conf();