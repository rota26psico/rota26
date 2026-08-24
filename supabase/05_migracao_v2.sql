-- ============================================================================
-- MIGRAÇÃO v1 → v2 — ETAPA 8 (itens 52 a 56, 61 a 65, 75)
-- ----------------------------------------------------------------------------
-- Idempotente: pode ser executada em instalação nova (depois de 01, 02 e 03)
-- ou sobre uma base v1 já existente. Não destrói nada.
--
-- O que acrescenta:
--   * resultados_funcionais e resultados_belbin — a trilha funcional passa a
--     ter armazenamento próprio, separado da trilha junguiana;
--   * is_demo em participantes e avaliações (item 75);
--   * arquivamento (soft delete) em vez de exclusão física (item 64);
--   * logs_auditoria com o formato exigido no item 65;
--   * retomada de avaliação: índice e política que permitem ler o que já foi
--     salvo (itens 53 e 54);
--   * funções de reset controlado com prévia e contagem (itens 61 a 63).
-- ============================================================================

begin;

-- ─── Marcação de dados de demonstração (item 75) ────────────────────────────
alter table participantes add column if not exists is_demo boolean not null default false;
alter table avaliacoes    add column if not exists is_demo boolean not null default false;
create index if not exists participantes_demo_idx on participantes(is_demo) where is_demo;
create index if not exists avaliacoes_demo_idx    on avaliacoes(is_demo) where is_demo;

-- ─── Arquivamento em vez de exclusão (item 64) ──────────────────────────────
alter table avaliacoes add column if not exists arquivada_em timestamptz;
alter table avaliacoes add column if not exists arquivada_por uuid;
create index if not exists avaliacoes_ativas_idx on avaliacoes(status) where arquivada_em is null;

-- ─── Trilha funcional: armazenamento próprio (item 56) ──────────────────────
create table if not exists resultados_funcionais (
  avaliacao_id  uuid primary key references avaliacoes(id) on delete cascade,
  eixos_bruto   jsonb not null,
  eixos         jsonb not null,   -- escores relativos internos
  cap_bruto     jsonb not null,
  capacidades   jsonb not null,   -- escores relativos internos
  ordem_capacidades text[] not null,
  versao_matriz text not null,
  calculado_em  timestamptz not null default now()
);

create table if not exists resultados_belbin (
  avaliacao_id  uuid primary key references avaliacoes(id) on delete cascade,
  bruto         jsonb not null,
  relativo      jsonb not null,   -- escores relativos internos por papel
  top1          text not null,
  top1_valor    numeric not null,
  top1_intensidade text not null,
  top2          text not null,
  top2_valor    numeric not null,
  top2_intensidade text not null,
  top3          text not null,
  top3_valor    numeric not null,
  top3_intensidade text not null,
  versao_matriz text not null,
  calculado_em  timestamptz not null default now()
);

-- Compatibilidade de nome com o item 56 (resultados_jung).
do $$ begin
  if exists (select 1 from information_schema.tables where table_name='resultados')
     and not exists (select 1 from information_schema.views where table_name='resultados_jung') then
    execute 'create view resultados_jung as select * from resultados';
  end if;
end $$;

-- ─── Auditoria no formato exigido (item 65) ─────────────────────────────────
create table if not exists logs_auditoria (
  id                bigserial primary key,
  user_id           uuid,
  usuario_email     text,
  acao              text not null,          -- RESET | EXCLUSAO | EXPORTACAO | EDICAO_PERGUNTA | ALTERACAO_PESO | ALTERACAO_VERSAO
  escopo            text,
  parametro         text,
  registros_afetados int not null default 0,
  detalhe           jsonb,
  criado_em         timestamptz not null default now()
);
create index if not exists logs_auditoria_data_idx on logs_auditoria(criado_em desc);

-- ─── RLS das novas tabelas ──────────────────────────────────────────────────
alter table resultados_funcionais enable row level security;
alter table resultados_belbin     enable row level security;
alter table logs_auditoria        enable row level security;

drop policy if exists rf_acesso on resultados_funcionais;
create policy rf_acesso on resultados_funcionais for select to authenticated using (
  exists (select 1 from avaliacoes a where a.id = resultados_funcionais.avaliacao_id and a.participante_id = meu_participante_id())
  or eh_master()
  or exists (select 1 from avaliacoes a join participantes p on p.id = a.participante_id
             where a.id = resultados_funcionais.avaliacao_id and p.setor_id = setor_do_admin())
);
drop policy if exists rf_grava on resultados_funcionais;
create policy rf_grava on resultados_funcionais for insert to authenticated with check (
  exists (select 1 from avaliacoes a where a.id = resultados_funcionais.avaliacao_id and a.participante_id = meu_participante_id())
  or eh_master()
);

drop policy if exists rb_acesso on resultados_belbin;
create policy rb_acesso on resultados_belbin for select to authenticated using (
  exists (select 1 from avaliacoes a where a.id = resultados_belbin.avaliacao_id and a.participante_id = meu_participante_id())
  or eh_master()
  or exists (select 1 from avaliacoes a join participantes p on p.id = a.participante_id
             where a.id = resultados_belbin.avaliacao_id and p.setor_id = setor_do_admin())
);
drop policy if exists rb_grava on resultados_belbin;
create policy rb_grava on resultados_belbin for insert to authenticated with check (
  exists (select 1 from avaliacoes a where a.id = resultados_belbin.avaliacao_id and a.participante_id = meu_participante_id())
  or eh_master()
);

drop policy if exists logs_leitura2 on logs_auditoria;
create policy logs_leitura2 on logs_auditoria for select to authenticated using (eh_master());
drop policy if exists logs_escrita2 on logs_auditoria;
create policy logs_escrita2 on logs_auditoria for insert to authenticated with check (eh_admin());

-- ─── View consolidada usada por dashboards e exportação (item 74) ──────────
-- FONTE ÚNICA: dashboards, comparativo, painel nominal e Excel leem daqui, o
-- que garante que os números coincidam entre os módulos.
-- (drop antes do create: a v2 acrescenta colunas e o Postgres não permite
--  alterar a lista de colunas de uma view com CREATE OR REPLACE.)
drop view if exists vw_resultados;
create view vw_resultados as
select
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula, p.email,
  s.id                as setor_id,
  s.codigo            as setor,
  a.versao_codigo,
  a.concluida_em,
  coalesce(a.is_demo, p.is_demo, false) as is_demo,
  r.atitude, r.funcao_dominante, r.funcao_auxiliar, r.funcao_menos_representada,
  r.funcao_inferior, r.perfil_principal, r.perfil_secundario,
  r.empate_funcoes, r.regra_desempate, r.ordem_funcoes,
  e.bruto             as jung_bruto,
  e.relativo          as jung,
  f.eixos             as eixos,
  f.capacidades       as capacidades,
  b.relativo          as belbin,
  b.top1, b.top1_valor, b.top1_intensidade,
  b.top2, b.top2_valor, b.top2_intensidade,
  b.top3, b.top3_valor, b.top3_intensidade
from avaliacoes a
join participantes p on p.id = a.participante_id
join setores s       on s.id = p.setor_id
join resultados r    on r.avaliacao_id = a.id
join escores e       on e.avaliacao_id = a.id
left join resultados_funcionais f on f.avaliacao_id = a.id
left join resultados_belbin b     on b.avaliacao_id = a.id
where a.status = 'CONCLUIDA' and a.arquivada_em is null;

-- ─── Retomada da avaliação (itens 53 e 54) ─────────────────────────────────
-- Retorna a avaliação em andamento do participante logado e as respostas já
-- salvas, para que a aplicação continue exatamente do ponto em que parou.
create or replace function avaliacao_em_andamento()
returns table (avaliacao_id uuid, versao_codigo text, questao_codigo text, alternativa_codigo text)
language sql stable security definer set search_path = public as $$
  select a.id, a.versao_codigo, r.questao_codigo, r.alternativa_codigo
  from avaliacoes a
  left join respostas r on r.avaliacao_id = a.id
  where a.participante_id = meu_participante_id()
    and a.status = 'EM_ANDAMENTO'
    and a.arquivada_em is null
  order by a.iniciada_em desc;
$$;

-- ─── Reset controlado: prévia e execução (itens 61 a 64) ───────────────────
-- A prévia NUNCA altera dados: serve à confirmação exigida no item 63.
create or replace function previa_reset(p_escopo text, p_param text default null)
returns table (participantes int, avaliacoes int, respostas int)
language plpgsql stable security definer set search_path = public as $$
begin
  if not eh_master() then raise exception 'Apenas o Administrador Master pode executar esta operação.'; end if;
  return query
  with alvo as (
    select a.id, a.participante_id
    from avaliacoes a
    join participantes p on p.id = a.participante_id
    join setores s on s.id = p.setor_id
    where a.arquivada_em is null and (
      (p_escopo = 'participante' and p.matricula = p_param) or
      (p_escopo = 'setor'        and s.codigo   = p_param) or
      (p_escopo = 'periodo'      and a.concluida_em::date <= p_param::date) or
      (p_escopo = 'demo'         and coalesce(a.is_demo, p.is_demo, false)) or
      (p_escopo = 'tudo')
    )
  )
  select
    (select count(distinct participante_id)::int from alvo),
    (select count(*)::int from alvo),
    (select coalesce(count(r.id), 0)::int from respostas r where r.avaliacao_id in (select id from alvo));
end $$;

-- Arquiva (soft delete). NÃO remove perguntas, alternativas, matrizes, perfis,
-- animais, parâmetros funcionais, setores, administradores nem versões (item 62).
create or replace function executar_reset(p_escopo text, p_param text default null, p_confirmacao text default null)
returns int
language plpgsql security definer set search_path = public as $$
declare afetadas int;
begin
  if not eh_master() then raise exception 'Apenas o Administrador Master pode executar esta operação.'; end if;
  if p_escopo = 'tudo' and coalesce(p_confirmacao, '') <> 'ZERAR RESULTADOS' then
    raise exception 'Reset geral exige a confirmação literal ZERAR RESULTADOS.';
  end if;

  with alvo as (
    select a.id
    from avaliacoes a
    join participantes p on p.id = a.participante_id
    join setores s on s.id = p.setor_id
    where a.arquivada_em is null and (
      (p_escopo = 'participante' and p.matricula = p_param) or
      (p_escopo = 'setor'        and s.codigo   = p_param) or
      (p_escopo = 'periodo'      and a.concluida_em::date <= p_param::date) or
      (p_escopo = 'demo'         and coalesce(a.is_demo, p.is_demo, false)) or
      (p_escopo = 'tudo')
    )
  )
  update avaliacoes set arquivada_em = now(), arquivada_por = auth.uid()
  where id in (select id from alvo);
  get diagnostics afetadas = row_count;

  insert into logs_auditoria (user_id, acao, escopo, parametro, registros_afetados, detalhe)
  values (auth.uid(), 'RESET', p_escopo, p_param, afetadas,
          jsonb_build_object('metodo', 'arquivamento (soft delete)', 'preservado',
            'perguntas, alternativas, matrizes, perfis, animais, parâmetros funcionais, setores, administradores, versões'));
  return afetadas;
end $$;

-- Exclusão física apenas dos dados DEMO, quando o Master quiser limpar de vez.
create or replace function excluir_demo_definitivo()
returns int
language plpgsql security definer set search_path = public as $$
declare afetadas int;
begin
  if not eh_master() then raise exception 'Apenas o Administrador Master pode executar esta operação.'; end if;
  delete from participantes p where p.is_demo;
  get diagnostics afetadas = row_count;
  insert into logs_auditoria (user_id, acao, escopo, registros_afetados, detalhe)
  values (auth.uid(), 'EXCLUSAO', 'demo', afetadas, jsonb_build_object('metodo', 'exclusão física de participantes is_demo'));
  return afetadas;
end $$;

-- Registro de exportação (item 65).
create or replace function registrar_exportacao(p_tipo text, p_registros int, p_detalhe jsonb default '{}'::jsonb)
returns void
language sql security definer set search_path = public as $$
  insert into logs_auditoria (user_id, acao, escopo, registros_afetados, detalhe)
  values (auth.uid(), 'EXPORTACAO', p_tipo, p_registros, p_detalhe);
$$;

commit;
