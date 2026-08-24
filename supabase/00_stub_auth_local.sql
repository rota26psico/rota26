-- ============================================================================
-- APENAS PARA VALIDAÇÃO LOCAL EM POSTGRESQL PURO.
-- NÃO EXECUTE ESTE ARQUIVO NO SUPABASE — lá o schema `auth` já existe.
-- ----------------------------------------------------------------------------
-- Reproduz o mínimo do schema `auth` do Supabase (tabela users, auth.uid() e
-- auth.jwt()) para que 01 a 06 possam ser aplicados e testados sem nuvem.
-- ============================================================================
create schema if not exists auth;

create table if not exists auth.users (
  id    uuid primary key default gen_random_uuid(),
  email text
);

create or replace function auth.uid() returns uuid
language sql stable as $$
  select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$;

create or replace function auth.jwt() returns jsonb
language sql stable as $$
  select coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb, '{}'::jsonb);
$$;

do $$ begin
  create role authenticated;
exception when duplicate_object then null; end $$;
