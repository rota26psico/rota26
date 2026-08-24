-- ============================================================================
-- SEPARAÇÃO ENTRE ADMINISTRAÇÃO E RESPONDENTE — complementa os itens 44 e 45
-- ----------------------------------------------------------------------------
-- Aplicar DEPOIS de 06_producao.sql. Idempotente.
--
-- Três coisas, todas nascidas de uma verificação com JWT real contra o RLS:
--
--  1. `eh_conta_administrativa(uuid)` — diz se um user_id está em
--     `administradores`. É SECURITY DEFINER de propósito: a policy
--     `admins_leitura` só deixa o ADMIN_SETOR enxergar a PRÓPRIA linha, então
--     uma subconsulta comum dentro de uma view `security_invoker` marcaria
--     todo mundo como não-administrador para ele. A função responde a mesma
--     coisa para os três papéis, e não expõe nada além do sim/não sobre uma
--     pessoa cujo resultado o solicitante já podia ler.
--
--  2. `eh_administrador` nas duas views de resultado. A conta que administra o
--     instrumento PODE responder às 48 situações — mas o resultado dela fica
--     sinalizado no painel nominal e na exportação, para que ninguém leia o
--     mapa da equipe sem saber que uma das linhas é de quem opera a
--     ferramenta. É marcação, não exclusão: o participante-administrador
--     continua contando nos indicadores.
--
--  3. Trigger que impede o participante de mexer nas colunas de marcação do
--     próprio cadastro. A policy `participantes_atualiza` libera o UPDATE da
--     própria linha, e RLS no PostgreSQL não distingue coluna: sem esta trava
--     um participante comum consegue, pela API, marcar-se `is_demo` e sumir de
--     `vw_resultados` — isto é, apagar-se de todo indicador, relatório e
--     planilha sem apagar nada. Verificado: `PATCH /participantes` devolvia
--     204 e a linha saía dos relatórios.
-- ============================================================================

-- ─── 1. Quem é conta administrativa ─────────────────────────────────────────
create or replace function eh_conta_administrativa(p_user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select p_user is not null
     and exists (select 1 from administradores a where a.user_id = p_user);
$$;

grant execute on function eh_conta_administrativa(uuid) to authenticated;

-- ─── 2. A marcação nas views ────────────────────────────────────────────────
-- Mesma definição de 06_producao.sql, acrescida de uma coluna derivada.
-- Nenhum filtro, nenhuma junção e nenhum escore mudam.
drop view if exists vw_resultados;
create view vw_resultados with (security_invoker = true) as
select
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula, p.email,
  s.id                as setor_id,
  s.codigo            as setor,
  a.versao_codigo,
  a.concluida_em,
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
  and coalesce(p.is_test, false) = false;

drop view if exists vw_resultados_todos;
create view vw_resultados_todos with (security_invoker = true) as
select
  a.id                as avaliacao_id,
  p.id                as participante_id,
  p.nome, p.matricula, p.email,
  s.id                as setor_id,
  s.codigo            as setor,
  a.versao_codigo,
  a.concluida_em,
  coalesce(a.is_demo, p.is_demo, false) as is_demo,
  coalesce(a.is_test, p.is_test, false) as is_test,
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
where a.status = 'CONCLUIDA' and a.arquivada_em is null;

-- ─── 3. Colunas de marcação fora do alcance do participante ─────────────────
-- Falha alto e explícito em vez de ignorar em silêncio: se alguma tela um dia
-- tentar escrever essas colunas com sessão de participante, o erro aparece.
-- A administração continua livre para marcar (limpeza DEMO, sonda `is_test`,
-- desativação de cadastro). A trava vale para o papel `authenticated`, que é
-- sob o qual o PostgREST executa a sessão de qualquer pessoa logada; a chave
-- de serviço roda como `service_role` e a manutenção como `postgres`, e
-- nenhuma das duas é sessão de participante.
-- SECURITY INVOKER de propósito: dentro de uma função SECURITY DEFINER o
-- `current_user` passa a ser o DONO da função, e o teste abaixo nunca seria
-- verdadeiro. Como invoker, `current_user` é o papel que o PostgREST assumiu
-- para a requisição — que é exatamente o que se quer distinguir.
create or replace function participantes_protege_marcacao() returns trigger
language plpgsql set search_path = public as $$
begin
  if current_user is distinct from 'authenticated' or eh_admin() then
    return new;
  end if;
  if new.is_demo is distinct from old.is_demo
     or new.is_test is distinct from old.is_test
     or new.ativo   is distinct from old.ativo then
    raise exception
      'Marcação e situação do cadastro são alteradas apenas pela administração.';
  end if;
  return new;
end $$;

drop trigger if exists trg_participantes_protege_marcacao on participantes;
create trigger trg_participantes_protege_marcacao before update on participantes
for each row execute function participantes_protege_marcacao();
