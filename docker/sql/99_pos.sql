-- ---------------------------------------------------------------------------
-- No Supabase hospedado, anon/authenticated/service_role já recebem privilégio
-- por default privileges. Aqui isso é explícito. O RLS continua sendo quem
-- decide o que cada papel enxerga — GRANT é só a porta de entrada do PostgREST.
-- ---------------------------------------------------------------------------
grant select, insert, update, delete on all tables in schema public to authenticated, service_role;
grant select on all tables in schema public to anon;
grant usage, select on all sequences in schema public to authenticated, service_role;
grant execute on all functions in schema public to anon, authenticated, service_role;

alter default privileges in schema public grant all on tables to authenticated, service_role;
alter default privileges in schema public grant execute on functions to anon, authenticated, service_role;
