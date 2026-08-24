-- ---------------------------------------------------------------------------
-- Cola local: o que o Supabase hospedado já traz pronto e o SQL do projeto
-- pressupõe. Nada aqui altera o esquema da aplicação.
-- ---------------------------------------------------------------------------

-- Papéis do PostgREST.
do $$ begin create role anon nologin noinherit; exception when duplicate_object then null; end $$;
do $$ begin create role authenticated nologin noinherit; exception when duplicate_object then null; end $$;
do $$ begin create role service_role nologin noinherit bypassrls; exception when duplicate_object then null; end $$;
do $$ begin create role authenticator login noinherit password 'postgres'; exception when duplicate_object then null; end $$;

grant anon, authenticated, service_role to authenticator;
grant usage on schema public to anon, authenticated, service_role;

-- auth.uid() e auth.jwt() idênticas às do Supabase: leem tanto o GUC legado
-- quanto o JSON completo das claims, que é o que o PostgREST 12 preenche.
create or replace function auth.uid() returns uuid
language sql stable as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid;
$$;

create or replace function auth.jwt() returns jsonb
language sql stable as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim', true), '')::jsonb,
    nullif(current_setting('request.jwt.claims', true), '')::jsonb,
    '{}'::jsonb
  );
$$;

grant usage on schema auth to anon, authenticated, service_role;
grant execute on function auth.uid(), auth.jwt() to anon, authenticated, service_role;
grant select on auth.users to service_role;
