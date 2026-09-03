-- ═══════════════════════════════════════════════════════════════════════════
-- 09 · APLICAÇÕES NUMERADAS, HISTÓRICO E DESEMPATE DECLARADO DA AUXILIAR
-- ═══════════════════════════════════════════════════════════════════════════
-- Aplicar DEPOIS de 08_reavaliacao_v2.sql. Aditivo e idempotente.
-- Nenhum DROP de tabela, nenhum DELETE, nenhum dado perdido.
--
-- Três assuntos, e cada um responde a um problema concreto:
--
--  1. `avaliacoes.numero_aplicacao` — o ordinal da aplicação, por participante.
--     O schema NUNCA impediu mais de uma avaliação por pessoa: não existe
--     `unique (participante_id)`, só um índice comum. O que faltava era o
--     ordinal e uma forma de ler o histórico; a distinção entre a 1ª e a 2ª
--     aplicação dependia de ordenar por `iniciada_em` e adivinhar.
--
--  2. `vw_aplicacoes` — o histórico, INCLUINDO as arquivadas. `vw_resultados`
--     continua sendo a view dos indicadores e continua enxergando só a
--     aplicação vigente; quem quer a linha do tempo de uma pessoa lê aqui.
--
--  3. As duas colunas do desempate da função AUXILIAR, mais a policy que torna
--     o recálculo possível. Ver a seção 4.
-- ═══════════════════════════════════════════════════════════════════════════

begin;

-- ─── 1 · O ordinal da aplicação ────────────────────────────────────────────
-- Calculado NO BANCO, por trigger, e não em `abrirAvaliacao` — aquela função
-- roda no navegador do participante e dois cliques concorrentes produziriam o
-- mesmo número. Aqui o `unique` abaixo é a rede: na corrida, uma das duas
-- transações falha em vez de gravar duas aplicações 02.
alter table avaliacoes add column if not exists numero_aplicacao int;

comment on column avaliacoes.numero_aplicacao is
  'Ordinal da aplicação dentro do participante, começando em 1. Conta TAMBÉM as arquivadas: depois de uma reaplicação liberada, a nova avaliação é a 02 e a anterior continua sendo a 01.';

-- Backfill por ordem de início. `iniciada_em` é NOT NULL desde o schema
-- original, e o desempate por `id` mantém o resultado estável se duas
-- avaliações do mesmo participante tiverem o mesmo instante.
with numeradas as (
  select id, row_number() over (partition by participante_id order by iniciada_em, id) as n
  from avaliacoes
)
update avaliacoes a set numero_aplicacao = numeradas.n
from numeradas
where numeradas.id = a.id and a.numero_aplicacao is null;

alter table avaliacoes alter column numero_aplicacao set not null;

do $$ begin
  alter table avaliacoes add constraint avaliacoes_aplicacao_unica
    unique (participante_id, numero_aplicacao);
exception when duplicate_table or duplicate_object then null;
end $$;

create or replace function proximo_numero_aplicacao() returns trigger
language plpgsql as $$
begin
  if new.numero_aplicacao is null then
    select coalesce(max(numero_aplicacao), 0) + 1 into new.numero_aplicacao
    from avaliacoes where participante_id = new.participante_id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_numero_aplicacao on avaliacoes;
create trigger trg_numero_aplicacao before insert on avaliacoes
  for each row execute function proximo_numero_aplicacao();

-- ─── 2 · O histórico de aplicações ─────────────────────────────────────────
-- `security_invoker = true`: o RLS das tabelas continua valendo DENTRO da view.
-- Participante vê as próprias aplicações, ADMIN_SETOR as do seu setor, MASTER
-- todas — sem que nenhuma tela precise filtrar. É a mesma decisão de
-- `vw_resultados`, pelo mesmo motivo.
--
-- Diferença deliberada em relação a `vw_resultados`: esta view NÃO filtra
-- `arquivada_em`, e não filtra status. Uma aplicação arquivada sai dos
-- indicadores — é o que arquivar significa — mas continua sendo parte da
-- história da pessoa, e é exatamente isso que se quer poder consultar.
-- Continua filtrando `is_demo` e `is_test`, porque dado fictício não é história
-- de ninguém.
drop view if exists vw_aplicacoes;
create view vw_aplicacoes with (security_invoker = true) as
select
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula,
  s.codigo            as setor,
  a.numero_aplicacao,
  a.versao_codigo,
  a.status::text      as status,
  a.iniciada_em,
  a.concluida_em,
  a.arquivada_em,
  (a.arquivada_em is null and a.status = 'CONCLUIDA') as vigente,
  r.perfil_principal,
  r.perfil_secundario,
  r.empate_funcoes,
  r.regra_desempate,
  r.algoritmo_versao,
  (select count(*) from respostas x where x.avaliacao_id = a.id) as respostas_gravadas
from avaliacoes a
join participantes p on p.id = a.participante_id
join setores s       on s.id = p.setor_id
left join resultados r on r.avaliacao_id = a.id
where coalesce(a.is_demo, p.is_demo, false) = false
  and coalesce(a.is_test, p.is_test, false) = false;

comment on view vw_aplicacoes is
  'Histórico de aplicações por participante, INCLUINDO arquivadas e em andamento. Rastreabilidade e leitura da linha do tempo. Os indicadores continuam lendo vw_resultados, que enxerga apenas a aplicação vigente.';

-- ─── 3 · Rede de segurança: uma pessoa, uma linha nos indicadores ──────────
-- `avaliacoes_cria` (02_policies) não verifica se já existe avaliação
-- concluída — o bloqueio é aplicacional, no `if/else` de Fluxo.tsx. Quem
-- contornar a interface abre uma segunda avaliação, conclui, e a partir daí a
-- pessoa aparecia DUAS VEZES em vw_resultados: participantes, IDF, ICF,
-- animais, distribuições, Excel, tudo contando alguém duas vezes.
--
-- O `distinct on` fecha isso no banco: sempre a aplicação concluída mais
-- recente, uma linha por pessoa. Não muda um único número hoje, porque
-- `liberar_reaplicacao` arquiva a anterior e portanto só existe uma vigente.
-- Ele transforma "considera sempre o último resultado respondido" em garantia
-- estrutural, em vez de consequência de um UPDATE ter rodado.
--
-- A definição abaixo é a de 07_papeis.sql com o distinct on acrescentado; as
-- colunas e os filtros são idênticos, campo a campo.
drop view if exists vw_resultados;
create view vw_resultados with (security_invoker = true) as
select distinct on (p.id)
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula, p.email,
  s.id                as setor_id,
  s.codigo            as setor,
  a.versao_codigo,
  a.concluida_em,
  a.numero_aplicacao,
  false               as is_demo,
  false               as is_test,
  eh_conta_administrativa(p.user_id) as eh_administrador,
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
where a.status = 'CONCLUIDA'
  and a.arquivada_em is null
  and coalesce(a.is_demo, false) = false
  and coalesce(p.is_demo, false) = false
  and coalesce(a.is_test, false) = false
  and coalesce(p.is_test, false) = false
order by p.id, a.concluida_em desc, a.numero_aplicacao desc;

comment on view vw_resultados is
  'Somente dados reais e somente a aplicação VIGENTE de cada pessoa — a concluída mais recente, não arquivada. Uma linha por participante, sempre. Tudo que a aplicação lê como indicador passa por aqui.';

-- Mesmo problema em `resumo_organizacional`: contava AVALIAÇÕES concluídas, de
-- modo que duas aplicações vigentes fariam o painel reportar mais concluídas
-- que participantes. Passa a contar PESSOAS distintas. Mantém o recorte pela
-- versão ativa introduzido em 08.
create or replace function resumo_organizacional()
returns table (participantes int, concluidas int, incompletas int, setores int)
language sql stable security invoker set search_path = public as $$
  with v as (select codigo from versoes_instrumento where ativa limit 1)
  select
    (select count(*)::int from participantes p
       where coalesce(p.is_demo,false) = false and coalesce(p.is_test,false) = false and p.ativo),
    (select count(distinct a.participante_id)::int
       from avaliacoes a join participantes p on p.id = a.participante_id
       where a.status = 'CONCLUIDA' and a.arquivada_em is null
         and a.versao_codigo = (select codigo from v)
         and coalesce(a.is_demo,p.is_demo,false) = false and coalesce(a.is_test,p.is_test,false) = false),
    (select count(distinct a.participante_id)::int
       from avaliacoes a join participantes p on p.id = a.participante_id
       where a.status = 'EM_ANDAMENTO' and a.arquivada_em is null
         and a.versao_codigo = (select codigo from v)
         and coalesce(a.is_demo,p.is_demo,false) = false and coalesce(a.is_test,p.is_test,false) = false),
    (select count(*)::int from setores where ativo);
$$;

-- ─── 4 · Desempate declarado da função auxiliar ────────────────────────────
-- Até `v1.0-piloto` o empate da função AUXILIAR — que decide o PERFIL
-- SECUNDÁRIO — era resolvido em silêncio pelo primeiro elemento do par, sem
-- registro. Era o único desempate do instrumento que o sistema não declarava,
-- e de fora isso é indistinguível de um sorteio. Em `v1.1-desempate-auxiliar`
-- ele passa pela mesma cascata D1 → D2 → D3 da dominante, e o degrau aplicado
-- é gravado aqui, do mesmo jeito que `regra_desempate` já fazia.
alter table resultados add column if not exists empate_auxiliar boolean not null default false;
alter table resultados add column if not exists regra_desempate_auxiliar text;

comment on column resultados.empate_auxiliar is
  'Verdadeiro quando as duas funções do par auxiliar tiveram o mesmo escore e a cascata de desempate foi acionada para decidir o perfil secundário.';
comment on column resultados.regra_desempate_auxiliar is
  'Qual degrau da cascata (D1, D2, D3) resolveu o empate da função auxiliar. Só lista degraus que EFETIVAMENTE reduziram o conjunto de candidatas.';

-- `resultados` só tinha policy de INSERT (02_policies.sql) — respostas e
-- derivados são imutáveis, e isso continua valendo para o participante. Mas
-- uma mudança de algoritmo exige regravar os derivados das avaliações já
-- coletadas, senão o painel mostra o perfil secundário antigo enquanto a
-- devolutiva, que recalcula das respostas, mostra o novo.
--
-- A permissão é dada ao MASTER e só a ele. A alternativa seria uma segunda
-- rota com a chave de serviço; esta é menor, é RLS nativo, e mantém a chave de
-- serviço restrita ao único lugar onde ela já vivia.
drop policy if exists resultados_atualiza_master on resultados;
create policy resultados_atualiza_master on resultados for update to authenticated
  using (eh_master()) with check (eh_master());

commit;
