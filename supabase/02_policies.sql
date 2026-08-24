-- ============================================================================
-- POLÍTICAS DE SEGURANÇA (RLS) — itens 44, 45 e 49 do prompt-mestre
-- ----------------------------------------------------------------------------
-- Três níveis de acesso:
--   PARTICIPANTE  — vê e responde APENAS a própria avaliação. Não acessa
--                   dashboards, resultados de colegas nem dados agregados.
--   ADMIN_SETOR   — vê participantes, resultados e agregados do PRÓPRIO setor.
--   MASTER        — vê tudo e administra o instrumento.
--
-- A separação é feita no banco, não na aplicação: mesmo que o frontend seja
-- contornado, a chave anônima do Supabase não retorna dados de terceiros.
-- ============================================================================

alter table setores              enable row level security;
alter table versoes_instrumento  enable row level security;
alter table questoes             enable row level security;
alter table alternativas         enable row level security;
alter table perfis               enable row level security;
alter table matriz_funcional     enable row level security;
alter table afinidade_belbin     enable row level security;
alter table participantes        enable row level security;
alter table administradores      enable row level security;
alter table avaliacoes           enable row level security;
alter table respostas            enable row level security;
alter table escores              enable row level security;
alter table resultados           enable row level security;
alter table log_auditoria        enable row level security;

-- ─── Conteúdo público autenticado: instrumento e matrizes ───────────────────
-- Qualquer usuário autenticado precisa ler as questões para responder e as
-- matrizes para ver o próprio resultado. Escrita: apenas MASTER.
drop policy if exists setores_leitura on setores;
create policy setores_leitura on setores for select to authenticated using (true);
drop policy if exists setores_escrita on setores;
create policy setores_escrita on setores for all to authenticated using (eh_master()) with check (eh_master());

drop policy if exists versoes_leitura on versoes_instrumento;
create policy versoes_leitura on versoes_instrumento for select to authenticated using (true);
drop policy if exists versoes_escrita on versoes_instrumento;
create policy versoes_escrita on versoes_instrumento for all to authenticated using (eh_master()) with check (eh_master());

drop policy if exists questoes_leitura on questoes;
create policy questoes_leitura on questoes for select to authenticated using (true);
drop policy if exists questoes_escrita on questoes;
create policy questoes_escrita on questoes for all to authenticated using (eh_master()) with check (eh_master());

drop policy if exists alternativas_leitura on alternativas;
create policy alternativas_leitura on alternativas for select to authenticated using (true);
drop policy if exists alternativas_escrita on alternativas;
create policy alternativas_escrita on alternativas for all to authenticated using (eh_master()) with check (eh_master());

drop policy if exists perfis_leitura on perfis;
create policy perfis_leitura on perfis for select to authenticated using (true);
drop policy if exists perfis_escrita on perfis;
create policy perfis_escrita on perfis for all to authenticated using (eh_master()) with check (eh_master());

drop policy if exists matriz_leitura on matriz_funcional;
create policy matriz_leitura on matriz_funcional for select to authenticated using (true);
drop policy if exists matriz_escrita on matriz_funcional;
create policy matriz_escrita on matriz_funcional for all to authenticated using (eh_master()) with check (eh_master());

drop policy if exists belbin_leitura on afinidade_belbin;
create policy belbin_leitura on afinidade_belbin for select to authenticated using (true);
drop policy if exists belbin_escrita on afinidade_belbin;
create policy belbin_escrita on afinidade_belbin for all to authenticated using (eh_master()) with check (eh_master());

-- ─── Participantes ──────────────────────────────────────────────────────────
drop policy if exists participantes_self on participantes;
create policy participantes_self on participantes for select to authenticated
  using (
    user_id = auth.uid()
    or eh_master()
    or (setor_id = setor_do_admin())
  );

drop policy if exists participantes_insere_self on participantes;
create policy participantes_insere_self on participantes for insert to authenticated
  with check (user_id = auth.uid() or eh_master());

drop policy if exists participantes_atualiza on participantes;
create policy participantes_atualiza on participantes for update to authenticated
  using (user_id = auth.uid() or eh_master())
  with check (user_id = auth.uid() or eh_master());

-- ─── Administradores: só MASTER enxerga e gerencia ──────────────────────────
drop policy if exists admins_leitura on administradores;
create policy admins_leitura on administradores for select to authenticated
  using (user_id = auth.uid() or eh_master());
drop policy if exists admins_escrita on administradores;
create policy admins_escrita on administradores for all to authenticated
  using (eh_master()) with check (eh_master());

-- ─── Avaliações ─────────────────────────────────────────────────────────────
drop policy if exists avaliacoes_acesso on avaliacoes;
create policy avaliacoes_acesso on avaliacoes for select to authenticated
  using (
    participante_id = meu_participante_id()
    or eh_master()
    or exists (select 1 from participantes p where p.id = avaliacoes.participante_id and p.setor_id = setor_do_admin())
  );

drop policy if exists avaliacoes_cria on avaliacoes;
create policy avaliacoes_cria on avaliacoes for insert to authenticated
  with check (participante_id = meu_participante_id());

drop policy if exists avaliacoes_atualiza on avaliacoes;
create policy avaliacoes_atualiza on avaliacoes for update to authenticated
  using (participante_id = meu_participante_id() or eh_master())
  with check (participante_id = meu_participante_id() or eh_master());

-- ─── Respostas brutas: o participante NUNCA lê as de outro ──────────────────
-- Nem o ADMIN_SETOR: respostas item a item são dado sensível e só interessam à
-- análise psicométrica, restrita ao MASTER.
drop policy if exists respostas_acesso on respostas;
create policy respostas_acesso on respostas for select to authenticated
  using (
    exists (select 1 from avaliacoes a where a.id = respostas.avaliacao_id and a.participante_id = meu_participante_id())
    or eh_master()
  );

drop policy if exists respostas_insere on respostas;
create policy respostas_insere on respostas for insert to authenticated
  with check (exists (
    select 1 from avaliacoes a
    where a.id = respostas.avaliacao_id
      and a.participante_id = meu_participante_id()
      and a.status = 'EM_ANDAMENTO'          -- não é possível alterar avaliação concluída
  ));

-- Sem policy de UPDATE/DELETE: respostas brutas são imutáveis após gravadas.

-- ─── Escores e resultados ───────────────────────────────────────────────────
drop policy if exists escores_acesso on escores;
create policy escores_acesso on escores for select to authenticated
  using (
    exists (select 1 from avaliacoes a where a.id = escores.avaliacao_id and a.participante_id = meu_participante_id())
    or eh_master()
    or exists (
      select 1 from avaliacoes a join participantes p on p.id = a.participante_id
      where a.id = escores.avaliacao_id and p.setor_id = setor_do_admin()
    )
  );
drop policy if exists escores_grava on escores;
create policy escores_grava on escores for insert to authenticated
  with check (exists (select 1 from avaliacoes a where a.id = escores.avaliacao_id and a.participante_id = meu_participante_id()) or eh_master());

drop policy if exists resultados_acesso on resultados;
create policy resultados_acesso on resultados for select to authenticated
  using (
    exists (select 1 from avaliacoes a where a.id = resultados.avaliacao_id and a.participante_id = meu_participante_id())
    or eh_master()
    or exists (
      select 1 from avaliacoes a join participantes p on p.id = a.participante_id
      where a.id = resultados.avaliacao_id and p.setor_id = setor_do_admin()
    )
  );
drop policy if exists resultados_grava on resultados;
create policy resultados_grava on resultados for insert to authenticated
  with check (exists (select 1 from avaliacoes a where a.id = resultados.avaliacao_id and a.participante_id = meu_participante_id()) or eh_master());

-- ─── Log ────────────────────────────────────────────────────────────────────
drop policy if exists log_leitura on log_auditoria;
create policy log_leitura on log_auditoria for select to authenticated using (eh_master());
drop policy if exists log_escrita on log_auditoria;
create policy log_escrita on log_auditoria for insert to authenticated with check (true);

-- ─── Trava adicional: impedir conclusão sem as 48 respostas ─────────────────
create or replace function valida_conclusao() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  esperadas int;
  obtidas   int;
begin
  if new.status = 'CONCLUIDA' and (old.status is distinct from 'CONCLUIDA') then
    select count(*) into esperadas
      from questoes q join versoes_instrumento v on v.id = q.versao_id
     where v.codigo = new.versao_codigo and q.ativa;
    select count(*) into obtidas from respostas r where r.avaliacao_id = new.id;
    if obtidas < esperadas then
      raise exception 'Avaliação incompleta: % de % respostas.', obtidas, esperadas;
    end if;
    new.concluida_em := coalesce(new.concluida_em, now());
  end if;
  return new;
end $$;

drop trigger if exists trg_valida_conclusao on avaliacoes;
create trigger trg_valida_conclusao before update on avaliacoes
for each row execute function valida_conclusao();
