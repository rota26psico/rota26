-- ============================================================================
-- ETAPA 7 — ESQUEMA DO BANCO (PostgreSQL / Supabase)
-- Mapeamento da Diversidade Psicológica, Comportamental e Funcional de Equipes
-- ----------------------------------------------------------------------------
-- Princípios obrigatórios implementados aqui:
--  * item 27 — banco persistente; nada depende de localStorage.
--  * item 28 — as RESPOSTAS BRUTAS são preservadas item a item, com a chave de
--    pontuação congelada no momento da resposta, permitindo recálculo futuro.
--  * item 49 — alterar perguntas NÃO altera avaliações históricas: as respostas
--    guardam o código do item e a versão do instrumento, não uma FK mutável.
--  * item 52 — o formato das respostas permite análise psicométrica posterior
--    (alfa de Cronbach, ômega, correlação item-total, análise fatorial).
-- ============================================================================

create extension if not exists "pgcrypto";

-- ─── Domínios ───────────────────────────────────────────────────────────────
do $$ begin
  create type papel_admin as enum ('MASTER', 'ADMIN_SETOR');
exception when duplicate_object then null; end $$;

do $$ begin
  create type status_avaliacao as enum ('EM_ANDAMENTO', 'CONCLUIDA', 'INVALIDADA');
exception when duplicate_object then null; end $$;

do $$ begin
  create type polo_jung as enum ('E', 'I', 'T', 'F', 'S', 'N');
exception when duplicate_object then null; end $$;

do $$ begin
  create type eixo_aux as enum ('EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST');
exception when duplicate_object then null; end $$;

do $$ begin
  create type tipo_item as enum ('FUNCAO', 'ATITUDE');
exception when duplicate_object then null; end $$;

-- ─── Setores (item 26 — administrador Master pode adicionar novos) ──────────
create table if not exists setores (
  id          uuid primary key default gen_random_uuid(),
  codigo      text not null unique,
  nome        text not null,
  ativo       boolean not null default true,
  criado_em   timestamptz not null default now()
);

-- ─── Versões do instrumento (item 49 — histórico preservado) ────────────────
create table if not exists versoes_instrumento (
  id           uuid primary key default gen_random_uuid(),
  codigo       text not null unique,          -- ex.: 'v1.0-piloto'
  descricao    text,
  peso_atitude int  not null,                 -- denominador dos escores E/I
  peso_funcao  int  not null,                 -- denominador dos escores T/F/S/N
  ativa        boolean not null default false,
  publicada_em timestamptz,
  criado_em    timestamptz not null default now()
);
-- Apenas uma versão ativa por vez.
create unique index if not exists versoes_uma_ativa
  on versoes_instrumento ((ativa)) where ativa;

-- ─── Banco fixo de questões (item 13) ───────────────────────────────────────
create table if not exists questoes (
  id         uuid primary key default gen_random_uuid(),
  versao_id  uuid not null references versoes_instrumento(id) on delete cascade,
  codigo     text not null,                   -- 'Q001' … 'Q048'
  tipo       tipo_item not null,
  peso       int  not null check (peso between 1 and 3),
  contexto   text not null,
  enunciado  text not null,
  ordem      int  not null,
  ativa      boolean not null default true,
  unique (versao_id, codigo)
);

create table if not exists alternativas (
  id         uuid primary key default gen_random_uuid(),
  questao_id uuid not null references questoes(id) on delete cascade,
  codigo     text not null,                   -- 'Q001A' …
  texto      text not null,
  jung       polo_jung not null,              -- CHAVE DE PONTUAÇÃO
  eixo       eixo_aux  not null,              -- CHAVE DE PONTUAÇÃO
  ordem      int not null,                    -- ordem canônica; a exibição é randomizada
  unique (questao_id, codigo)
);

-- ─── Matrizes teóricas (Etapas 2 e 3) ───────────────────────────────────────
create table if not exists perfis (
  codigo            text primary key,          -- 'Te','Ti','Fe','Fi','Se','Si','Ne','Ni'
  ordem             int  not null,
  atitude           polo_jung not null,
  funcao            polo_jung not null,
  nome_jung         text not null,
  animal            text not null,
  cor               text not null,
  funcao_inferior   polo_jung not null,
  sintese           text not null,
  conteudo          jsonb not null             -- jung, livro, estrutura, luz, sombra, trabalho…
);

create table if not exists matriz_funcional (
  perfil_codigo text not null references perfis(codigo) on delete cascade,
  capacidade    text not null,
  valor         int  not null check (valor between 0 and 5),
  justificativa text,
  primary key (perfil_codigo, capacidade)
);

create table if not exists afinidade_belbin (
  perfil_codigo text not null references perfis(codigo) on delete cascade,
  papel         text not null,
  valor         int  not null check (valor between 0 and 5),
  primary key (perfil_codigo, papel)
);

-- ─── Pessoas ────────────────────────────────────────────────────────────────
create table if not exists participantes (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid unique references auth.users(id) on delete set null,
  nome       text not null,
  matricula  text not null unique,
  email      text,
  setor_id   uuid not null references setores(id),
  ativo      boolean not null default true,
  criado_em  timestamptz not null default now()
);
create index if not exists participantes_setor_idx on participantes(setor_id);

create table if not exists administradores (
  user_id   uuid primary key references auth.users(id) on delete cascade,
  papel     papel_admin not null,
  setor_id  uuid references setores(id),        -- obrigatório para ADMIN_SETOR
  nome      text,
  criado_em timestamptz not null default now(),
  constraint admin_setor_coerente
    check ((papel = 'MASTER' and setor_id is null) or (papel = 'ADMIN_SETOR' and setor_id is not null))
);

-- ─── Avaliações ─────────────────────────────────────────────────────────────
create table if not exists avaliacoes (
  id              uuid primary key default gen_random_uuid(),
  participante_id uuid not null references participantes(id) on delete cascade,
  versao_codigo   text not null,               -- congelado (não é FK mutável)
  status          status_avaliacao not null default 'EM_ANDAMENTO',
  iniciada_em     timestamptz not null default now(),
  concluida_em    timestamptz,
  origem          text default 'web'
);
create index if not exists avaliacoes_participante_idx on avaliacoes(participante_id);
create index if not exists avaliacoes_status_idx on avaliacoes(status);

-- ─── RESPOSTAS BRUTAS (item 28 — obrigatório) ───────────────────────────────
-- A chave de pontuação é COPIADA para cá no momento da resposta. Se o banco de
-- questões for editado depois, este registro histórico permanece íntegro e o
-- resultado continua reproduzível.
create table if not exists respostas (
  id                  uuid primary key default gen_random_uuid(),
  avaliacao_id        uuid not null references avaliacoes(id) on delete cascade,
  questao_codigo      text not null,
  alternativa_codigo  text not null,
  jung                polo_jung not null,
  eixo                eixo_aux  not null,
  peso                int  not null,
  posicao_exibida     int,                     -- posição em que a alternativa apareceu (randomização)
  respondida_em       timestamptz not null default now(),
  unique (avaliacao_id, questao_codigo)        -- uma resposta por item
);
create index if not exists respostas_avaliacao_idx on respostas(avaliacao_id);
create index if not exists respostas_item_idx on respostas(questao_codigo, alternativa_codigo);

-- ─── Escores e resultados (derivados, sempre recalculáveis) ─────────────────
create table if not exists escores (
  avaliacao_id uuid primary key references avaliacoes(id) on delete cascade,
  bruto        jsonb not null,
  relativo     jsonb not null,
  calculado_em timestamptz not null default now()
);

create table if not exists resultados (
  avaliacao_id             uuid primary key references avaliacoes(id) on delete cascade,
  atitude                  polo_jung not null,
  funcao_dominante         polo_jung not null,
  funcao_auxiliar          polo_jung not null,
  funcao_menos_representada polo_jung not null,
  funcao_inferior          polo_jung not null,
  perfil_principal         text not null references perfis(codigo),
  perfil_secundario        text not null references perfis(codigo),
  empate_funcoes           boolean not null default false,
  regra_desempate          text,
  ordem_funcoes            text[] not null,
  algoritmo_versao         text not null,
  calculado_em             timestamptz not null default now()
);
create index if not exists resultados_perfil_idx on resultados(perfil_principal);

-- ─── Auditoria ──────────────────────────────────────────────────────────────
create table if not exists log_auditoria (
  id         bigserial primary key,
  user_id    uuid,
  acao       text not null,
  entidade   text,
  entidade_id text,
  detalhe    jsonb,
  criado_em  timestamptz not null default now()
);

-- ─── Funções auxiliares de autorização ──────────────────────────────────────
create or replace function eh_master() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from administradores a where a.user_id = auth.uid() and a.papel = 'MASTER');
$$;

create or replace function setor_do_admin() returns uuid
language sql stable security definer set search_path = public as $$
  select a.setor_id from administradores a where a.user_id = auth.uid() and a.papel = 'ADMIN_SETOR' limit 1;
$$;

create or replace function eh_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from administradores a where a.user_id = auth.uid());
$$;

create or replace function meu_participante_id() returns uuid
language sql stable security definer set search_path = public as $$
  select p.id from participantes p where p.user_id = auth.uid() limit 1;
$$;

-- ─── VIEW agregadora usada pelos dashboards ─────────────────────────────────
-- Expõe apenas o necessário para as análises coletivas.
create or replace view vw_resultados as
select
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula,
  s.id                as setor_id,
  s.codigo            as setor,
  a.versao_codigo,
  a.concluida_em,
  r.atitude, r.funcao_dominante, r.funcao_auxiliar,
  r.perfil_principal, r.perfil_secundario, r.empate_funcoes,
  e.relativo
from avaliacoes a
join participantes p on p.id = a.participante_id
join setores s on s.id = p.setor_id
join resultados r on r.avaliacao_id = a.id
join escores e on e.avaliacao_id = a.id
where a.status = 'CONCLUIDA';
