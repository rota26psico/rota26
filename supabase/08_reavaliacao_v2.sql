-- ═══════════════════════════════════════════════════════════════════════════
-- 08 · REAVALIAÇÃO v2.0 — coexistência versionada
-- ═══════════════════════════════════════════════════════════════════════════
-- RENUMERADO DE 07 PARA 08. O pacote de entrega chamava este arquivo de
-- `07_reavaliacao_v2.sql`, mas o `07_papeis.sql` deste projeto já existia e já
-- está aplicado no banco de produção. Renumerar o que já rodou seria pior do
-- que renumerar o que ainda não rodou.
-- ═══════════════════════════════════════════════════════════════════════════
-- Introduz a versão v2.0-reavaliacao SEM tocar em nada de v1.0-piloto.
--
-- POR QUE COEXISTÊNCIA, E NÃO SUBSTITUIÇÃO NO LUGAR:
-- as avaliações já coletadas apontam para as alternativas da v1.0 e guardam a
-- chave de pontuação congelada no momento da resposta. Trocar as perguntas no
-- mesmo registro tornaria esses dados ilegíveis. O schema já previa isso —
-- `avaliacoes.versao_codigo` é congelado por avaliação — e esta migração apenas
-- usa o que já existia.
--
-- CONSEQUÊNCIA QUE PRECISA ESTAR DECLARADA: resultados de v1.0 e v2.0 NÃO são
-- comparáveis entre si. São instrumentos diferentes. Por isso os indicadores
-- passam a ser filtrados por versão, nunca somados.
--
-- Nenhum DROP, nenhum DELETE, nenhum UPDATE em dado existente.
-- ═══════════════════════════════════════════════════════════════════════════

begin;

-- ─── 1 · A versão ──────────────────────────────────────────────────────────
-- peso_atitude e peso_funcao são NOT NULL desde o schema original, onde
-- codificavam o desenho da v1.0: 24 itens de atitude somando 27 pontos e 24 de
-- função somando outros 27, em conjuntos SEPARADOS. Na v2.0 não é assim — as
-- mesmas 48 respostas alimentam atitude e função ao mesmo tempo, porque cada
-- alternativa aponta uma configuração inteira. Por isso ambos valem 48: é o
-- número de itens que contribui para cada dimensão, e não mais um total fixo
-- de pontos (que aqui varia entre 48 e 56, conforme as âncoras escolhidas).
insert into versoes_instrumento (codigo, descricao, peso_atitude, peso_funcao, ativa)
values ('v2.0-reavaliacao',
        'Reavaliação — 48 situações de trabalho. Cada alternativa pontua para uma das oito configurações; oito itens-âncora de peso 2. Atitude e função são DERIVADAS da soma das configurações, não medidas por itens separados. Total de pontos varia entre 48 e 56. Fonte: ROTA26gabaritotecnicoCONFIDENCIAL.pdf.',
        48, 48,
        false)                             -- entra INATIVA: ativar é decisão de operação
on conflict (codigo) do nothing;

-- ─── 2 · Colunas de filtro: contrato e líder imediato ─────────────────────
-- Criadas ANTES da view da seção 5, que as usa.
-- Filtros exigidos: contrato, setor/equipe e líder imediato.
alter table participantes add column if not exists lider_imediato text;
alter table avaliacoes    add column if not exists contrato text;
create index if not exists participantes_lider_idx    on participantes(lider_imediato);
create index if not exists avaliacoes_contrato_idx    on avaliacoes(contrato);

comment on column participantes.lider_imediato is
  'Matrícula do líder imediato. Permite a comparação líder × equipe do dashboard sem inferir hierarquia a partir do setor.';

-- ─── 3 · Onde o resultado da v2 é gravado ──────────────────────────────────
-- Tabela própria, para não misturar com `resultados` da v1.0, que tem colunas
-- de trilha funcional (capacidades, Belbin) que a v2.0 não produz.
create table if not exists resultados_v2 (
  avaliacao_id        uuid primary key references avaliacoes(id) on delete cascade,

  bruto               jsonb not null,      -- {Te:…, Ti:…, …} pontos com pesos aplicados
  relativo            jsonb not null,      -- mesmos oito, em % do total
  total_pontos        int   not null check (total_pontos between 48 and 56),

  predominante        text  not null check (predominante in ('Te','Ti','Fe','Fi','Se','Si','Ne','Ni')),
  secundaria          text  not null check (secundaria  in ('Te','Ti','Fe','Fi','Se','Si','Ne','Ni')),
  animal              text  not null check (animal in
                        ('Lobo','Elefante','Carneiro','Baleia','Cavalo','Urso','Raposa','Onça')),

  margem_pp           numeric(5,2) not null,
  amplitude_pp        numeric(5,2) not null,
  classificacao       text not null check (classificacao in
                        ('predominancia_definida','predominancia_moderada',
                         'configuracao_equilibrada','baixa_aderencia')),

  atitude_e           int not null,
  atitude_i           int not null,
  funcao_t            int not null,
  funcao_f            int not null,
  funcao_s            int not null,
  funcao_n            int not null,
  eixo_cognitivo      numeric(5,2) not null,   -- %N − %S
  eixo_relacional     numeric(5,2) not null,   -- %F − %T
  orientacao_energia  numeric(5,2) not null,   -- %E − %I

  equilibrio_funcional boolean not null,
  equilibrio_atitude   boolean not null,
  possivel_conflito    boolean not null,
  desempate_aplicado   boolean not null default false,

  algoritmo_versao    text not null,
  calculado_em        timestamptz not null default now()
);
create index if not exists resultados_v2_predominante_idx on resultados_v2(predominante);

-- ─── 4 · Auditoria do desempate (adendo, seção 3) ──────────────────────────
create table if not exists desempates (
  id                uuid primary key default gen_random_uuid(),
  avaliacao_id      uuid not null references avaliacoes(id) on delete cascade,
  item_codigo       text not null,                          -- D01 … D28
  config_a          text not null check (config_a in ('Te','Ti','Fe','Fi','Se','Si','Ne','Ni')),
  config_b          text not null check (config_b in ('Te','Ti','Fe','Fi','Se','Si','Ne','Ni')),
  pontos_a          int  not null,
  pontos_b          int  not null,
  margem_pp         numeric(5,2) not null,
  alternativa       text not null check (alternativa in ('A','B')),   -- como foi exibida
  config_escolhida  text not null check (config_escolhida in ('Te','Ti','Fe','Fi','Se','Si','Ne','Ni')),
  posicao_a         text not null check (posicao_a in ('Te','Ti','Fe','Fi','Se','Si','Ne','Ni')),
  respondido_em     timestamptz not null default now(),
  constraint desempate_unico_por_avaliacao unique (avaliacao_id),
  constraint desempate_configs_distintas   check (config_a <> config_b),
  constraint desempate_escolhida_no_par    check (config_escolhida in (config_a, config_b))
);
create index if not exists desempates_par_idx on desempates(config_a, config_b);

comment on table desempates is
  'Auditoria da pergunta adicional de desempate. Guarda quais configurações disputaram, com que margem, qual alternativa foi escolhida e em que posição ela foi exibida — esta última para permitir detectar viés de posição.';

-- ─── 5 · Visões por versão ─────────────────────────────────────────────────
-- A regra de sigilo vale aqui também: nenhuma view expõe a associação
-- alternativa → configuração. Elas devolvem resultado, nunca gabarito.

create or replace view vw_resultados_v2
with (security_invoker = true) as
select
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula, p.email,
  s.id     as setor_id,
  s.codigo as setor,
  p.lider_imediato,
  a.contrato,
  a.concluida_em,
  a.versao_codigo,
  r.predominante, r.secundaria, r.animal,
  r.classificacao, r.margem_pp, r.amplitude_pp,
  r.eixo_cognitivo, r.eixo_relacional, r.orientacao_energia,
  r.atitude_e, r.atitude_i, r.funcao_t, r.funcao_f, r.funcao_s, r.funcao_n,
  r.equilibrio_funcional, r.equilibrio_atitude, r.possivel_conflito,
  r.desempate_aplicado,
  r.bruto, r.relativo
from avaliacoes a
join participantes p on p.id = a.participante_id
join setores       s on s.id = p.setor_id
join resultados_v2 r on r.avaliacao_id = a.id
where a.status = 'CONCLUIDA'
  and a.versao_codigo = 'v2.0-reavaliacao'
  and a.is_demo = false and a.is_test = false
  and p.is_demo = false and p.is_test = false;

comment on view vw_resultados_v2 is
  'Resultados REAIS da v2.0. O filtro por versão está aqui, na definição da view, e não em cláusula de tela: nenhum painel consegue somar v1.0 com v2.0 por descuido de código.';

-- ─── 6 · RLS ───────────────────────────────────────────────────────────────
-- Usa os helpers que o schema já define (eh_master, setor_do_admin,
-- meu_participante_id). Reimplementar a checagem de papel aqui criaria uma
-- segunda fonte de verdade sobre quem pode ver o quê.
alter table resultados_v2 enable row level security;
alter table desempates    enable row level security;

-- Participante: exclusivamente o próprio resultado. Nada de equipe, nada de
-- outra pessoa, nada de líder.
drop policy if exists resultados_v2_proprio on resultados_v2;
create policy resultados_v2_proprio on resultados_v2 for select to authenticated using (
  exists (select 1 from avaliacoes a
          where a.id = resultados_v2.avaliacao_id
            and a.participante_id = meu_participante_id())
);

-- Master vê tudo; administrador de setor vê o próprio setor.
drop policy if exists resultados_v2_admin on resultados_v2;
create policy resultados_v2_admin on resultados_v2 for select to authenticated using (
  eh_master() or exists (
    select 1 from avaliacoes a join participantes p on p.id = a.participante_id
    where a.id = resultados_v2.avaliacao_id and p.setor_id = setor_do_admin())
);

-- O desempate é auditoria e revela QUAIS configurações disputaram — isso é
-- gabarito. Nenhum participante o lê, nem o próprio.
drop policy if exists desempates_admin on desempates;
create policy desempates_admin on desempates for select to authenticated using (
  eh_master() or exists (
    select 1 from avaliacoes a join participantes p on p.id = a.participante_id
    where a.id = desempates.avaliacao_id and p.setor_id = setor_do_admin())
);

-- ─── 7 · POR ONDE O RESULTADO DA v2.0 É GRAVADO ────────────────────────────
-- Não há policy de INSERT nem de UPDATE em `resultados_v2` e `desempates`, e
-- isso é decisão, não esquecimento.
--
-- A v1.0 grava do NAVEGADOR: `concluirAvaliacao` roda em componente de cliente,
-- e por isso `02_policies.sql` precisou de `resultados_grava` e `escores_grava`.
-- O preço disso é que a chave de pontuação da v1.0 precisa estar no bundle —
-- e está.
--
-- Na v2.0 esse caminho é impossível por construção: o gabarito vive em
-- `src/data/v2/mapa.server.ts`, com `import 'server-only'`. A apuração só pode
-- acontecer no servidor, e portanto a gravação também. Ela passa por rota de
-- servidor com `SUPABASE_SERVICE_ROLE_KEY`, que ignora RLS — nenhuma policy de
-- escrita é necessária, e a ausência delas é uma garantia a mais: mesmo de
-- posse da chave anônima, ninguém forja o próprio resultado.
--
-- Se alguma tela futura tentar gravar do cliente, o RLS vai recusar. É o
-- comportamento desejado; não "conserte" acrescentando policy.

-- ─── 8 · CONTAGEM POR VERSÃO (o topo do dashboard) ─────────────────────────
-- `resumo_organizacional()`, de 06_producao.sql, conta avaliações SEM filtrar
-- versão. Enquanto só existe a v1.0 isso é inofensivo. No dia em que a v2.0 for
-- ativada, os quatro números do topo passariam a somar as duas versões,
-- enquanto todos os painéis — que leem `vw_resultados`, com junção na tabela
-- `resultados` da v1.0 — continuariam mostrando só a v1.0. Topo e painel
-- discordando, sem que nada estivesse quebrado.
--
-- A correção é contar sempre pela versão ATIVA. Com a v1.0 ativa, os números
-- são exatamente os de hoje.
create or replace function resumo_organizacional()
returns table (participantes int, concluidas int, incompletas int, setores int)
language sql stable security invoker set search_path = public as $$
  with v as (select codigo from versoes_instrumento where ativa limit 1)
  select
    (select count(*)::int from participantes p
       where coalesce(p.is_demo,false) = false and coalesce(p.is_test,false) = false and p.ativo),
    (select count(*)::int from avaliacoes a join participantes p on p.id = a.participante_id
       where a.status = 'CONCLUIDA' and a.arquivada_em is null
         and a.versao_codigo = (select codigo from v)
         and coalesce(a.is_demo,p.is_demo,false) = false and coalesce(a.is_test,p.is_test,false) = false),
    (select count(*)::int from avaliacoes a join participantes p on p.id = a.participante_id
       where a.status = 'EM_ANDAMENTO' and a.arquivada_em is null
         and a.versao_codigo = (select codigo from v)
         and coalesce(a.is_demo,p.is_demo,false) = false and coalesce(a.is_test,p.is_test,false) = false),
    (select count(*)::int from setores where ativo);
$$;

grant execute on function resumo_organizacional() to authenticated;

commit;

-- ═══════════════════════════════════════════════════════════════════════════
-- O QUE ESTA MIGRAÇÃO NÃO FAZ, DE PROPÓSITO
-- ═══════════════════════════════════════════════════════════════════════════
-- · Não ativa a v2.0. `ativa = false`. Ativar é operação consciente:
--       update versoes_instrumento set ativa = false where codigo = 'v1.0-piloto';
--       update versoes_instrumento set ativa = true  where codigo = 'v2.0-reavaliacao';
--   Faça o backup antes. Depois disso, novas avaliações usam as 48 novas.
--
-- · Não apaga, não converte e não recalcula nenhuma avaliação de v1.0.
--   Elas continuam legíveis, com seus resultados originais, sob a versão delas.
--
-- · Não grava o mapa alternativa → configuração no banco. O gabarito vive
--   apenas em `src/data/v2/mapa.server.ts`, com trava de servidor. Se ele
--   estivesse em tabela, qualquer falha de RLS o exporia.
-- ═══════════════════════════════════════════════════════════════════════════
