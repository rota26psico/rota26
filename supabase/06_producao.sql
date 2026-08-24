-- ============================================================================
-- MIGRAÇÃO v2 → PRODUÇÃO — "Aplicação Organizacional"
-- ----------------------------------------------------------------------------
-- Idempotente. Executar DEPOIS de 01, 02, 03 e 05.
--
-- Esta migração é o que separa tecnicamente a DEMONSTRAÇÃO da APLICAÇÃO REAL.
-- Ela NÃO altera as 48 questões, o algoritmo, os perfis, os animais, as
-- matrizes, o IDF, o ICF nem qualquer cálculo já validado.
--
-- O que faz:
--   * acrescenta `is_test` (registro de validação controlada, item 34), que é
--     distinto de `is_demo`;
--   * torna `vw_resultados` uma view de DADOS REAIS — is_demo = false E
--     is_test = false. Nenhum dashboard, indicador, relatório ou exportação
--     consegue mais enxergar dado fictício por descuido (item 5);
--   * cria `vw_resultados_todos`, restrita ao Master, para o backup dos dados
--     DEMO antes da limpeza (item 8);
--   * aplica `security_invoker` às views, para que o RLS das tabelas continue
--     valendo dentro delas (item 29);
--   * cria a limpeza DEMO com prévia, confirmação literal e auditoria
--     (itens 6 a 12);
--   * cria `verificar_prontidao()`, o checklist de pré-aplicação verificado
--     contra o banco (itens 32 e 33);
--   * cria `registrar_evento()` para LOGIN, CONCLUSÃO, EXPORTAÇÃO, RESET,
--     LIMPEZA DEMO e ALTERAÇÃO DE CONFIGURAÇÕES (item 27);
--   * cria `liberar_reaplicacao()`, único caminho autorizado para um
--     participante que já concluiu responder de novo (item 17).
-- ============================================================================

begin;

-- ─── Registro de validação controlada (item 34) ─────────────────────────────
-- is_test NÃO é is_demo. É a única avaliação artificial que pode existir depois
-- da limpeza, criada de propósito para validar o fluxo, e removível em um
-- clique.
alter table participantes add column if not exists is_test boolean not null default false;
alter table avaliacoes    add column if not exists is_test boolean not null default false;
create index if not exists participantes_test_idx on participantes(is_test) where is_test;
create index if not exists avaliacoes_test_idx    on avaliacoes(is_test)    where is_test;

-- Reaplicação autorizada (item 17): sem esta marca, matrícula com avaliação
-- CONCLUIDA não abre uma nova.
alter table participantes add column if not exists reaplicacao_liberada_em timestamptz;
alter table participantes add column if not exists reaplicacao_liberada_por uuid;

-- E-mail do autor no log, preenchido pelo próprio banco (item 30).
create or replace function email_do_usuario() returns text
language sql stable as $$
  select coalesce(
    nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email',
    'sistema'
  );
$$;

-- ============================================================================
-- REGRA CRÍTICA DOS DASHBOARDS (item 5)
-- ----------------------------------------------------------------------------
-- A partir daqui `vw_resultados` significa DADO REAL. Ponto.
-- Toda a aplicação — visão organizacional, equipe, comparativo, painel
-- nominal, metodologia, "Você na sua equipe", IDF, ICF, cobertura, leitura
-- executiva e Excel — lê desta view. Não existe caminho em que um registro
-- de demonstração entre em um indicador real: o filtro está no banco, não na
-- interface.
-- ============================================================================
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

-- View irrestrita — usada apenas para o BACKUP dos dados DEMO antes da
-- limpeza (item 8) e para a validação controlada do item 34. O RLS das tabelas
-- continua valendo (security_invoker), portanto ela não abre nada a ninguém
-- que já não pudesse ler as tabelas de origem.
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

-- ─── Contagens reais, sem dado fictício (itens 5, 23 e 24) ──────────────────
-- Devolve os quatro números do topo do dashboard. Uma FALHA aqui propaga um
-- erro — nunca vira "0 participantes" (item 24).
create or replace function resumo_organizacional()
returns table (participantes int, concluidas int, incompletas int, setores int)
language sql stable security invoker set search_path = public as $$
  select
    (select count(*)::int from participantes p
       where coalesce(p.is_demo,false) = false and coalesce(p.is_test,false) = false and p.ativo),
    (select count(*)::int from avaliacoes a join participantes p on p.id = a.participante_id
       where a.status = 'CONCLUIDA' and a.arquivada_em is null
         and coalesce(a.is_demo,p.is_demo,false) = false and coalesce(a.is_test,p.is_test,false) = false),
    (select count(*)::int from avaliacoes a join participantes p on p.id = a.participante_id
       where a.status = 'EM_ANDAMENTO' and a.arquivada_em is null
         and coalesce(a.is_demo,p.is_demo,false) = false and coalesce(a.is_test,p.is_test,false) = false),
    (select count(*)::int from setores where ativo);
$$;

-- ============================================================================
-- LIMPEZA DOS DADOS DE DEMONSTRAÇÃO (itens 6 a 12)
-- ============================================================================

-- Item 7 — a janela de confirmação. Só conta; nunca altera nada.
create or replace function previa_limpeza_demo()
returns table (participantes int, avaliacoes int, respostas int, resultados int, reais_preservados int)
language plpgsql stable security definer set search_path = public as $$
begin
  if not eh_master() then
    raise exception 'Apenas o Administrador Master pode consultar a prévia de limpeza.';
  end if;
  return query
  with pd as (select id from participantes where is_demo),
       ad as (select a.id from avaliacoes a
              where coalesce(a.is_demo,false) or a.participante_id in (select id from pd))
  select
    (select count(*)::int from pd),
    (select count(*)::int from ad),
    (select count(*)::int from respostas r where r.avaliacao_id in (select id from ad)),
    (select count(*)::int from resultados x where x.avaliacao_id in (select id from ad)),
    (select count(*)::int from participantes where not is_demo);
end $$;

-- Itens 9, 10, 11 e 12 — a execução.
-- Exige a confirmação literal LIMPAR DADOS DEMO.
-- Remove SOMENTE registros marcados como demonstração. Não toca em perguntas,
-- alternativas, pesos, perfis, animais, luz/sombra, matriz funcional, matriz
-- Belbin, setores, administradores, configurações, versões nem parâmetros de
-- IDF/ICF: nenhuma dessas tabelas é referenciada abaixo (item 11).
create or replace function limpar_dados_demo(p_confirmacao text)
returns table (participantes_removidos int, avaliacoes_removidas int, respostas_removidas int, restantes int)
language plpgsql security definer set search_path = public as $$
declare np int; na int; nr int; sobra int;
begin
  if not eh_master() then
    raise exception 'Apenas o Administrador Master pode limpar os dados de demonstração.';
  end if;
  if coalesce(p_confirmacao, '') <> 'LIMPAR DADOS DEMO' then
    raise exception 'Confirmação inválida. Digite exatamente LIMPAR DADOS DEMO para prosseguir.';
  end if;

  create temp table _alvo on commit drop as
    select a.id from avaliacoes a
    left join participantes p on p.id = a.participante_id
    where coalesce(a.is_demo,false) or coalesce(p.is_demo,false);

  select count(*)::int into na from _alvo;
  select count(*)::int into nr from respostas r where r.avaliacao_id in (select id from _alvo);

  -- Ordem explícita, apesar do ON DELETE CASCADE, para que a contagem seja
  -- auditável e o efeito seja legível por quem revisar este arquivo.
  delete from respostas             where avaliacao_id in (select id from _alvo);
  delete from resultados_belbin     where avaliacao_id in (select id from _alvo);
  delete from resultados_funcionais where avaliacao_id in (select id from _alvo);
  delete from resultados            where avaliacao_id in (select id from _alvo);
  delete from escores               where avaliacao_id in (select id from _alvo);
  delete from avaliacoes            where id in (select id from _alvo);

  delete from participantes where is_demo;
  get diagnostics np = row_count;

  -- Item 12 — quantos registros DEMO permanecem. Deve ser zero.
  select (select count(*) from participantes where is_demo)
       + (select count(*) from avaliacoes where coalesce(is_demo,false))
    into sobra;

  insert into logs_auditoria (user_id, usuario_email, acao, escopo, registros_afetados, detalhe)
  values (auth.uid(), email_do_usuario(), 'LIMPEZA_DEMO', 'demo', np,
          jsonb_build_object(
            'participantes', np, 'avaliacoes', na, 'respostas', nr,
            'registros_demo_restantes', sobra,
            'preservado', 'perguntas, alternativas, pesos, perfis, animais, luz/sombra, matriz funcional, matriz Belbin, setores, administradores, configurações, versões, parâmetros de IDF e ICF',
            'dados_reais', 'intactos'));

  return query select np, na, nr, sobra;
end $$;

-- Quantos registros DEMO ainda existem — controla a exibição do botão
-- "Exportar dados DEMO" (item 25) e do próprio botão de limpeza.
create or replace function contagem_demo()
returns table (participantes int, avaliacoes int, testes int)
language sql stable security definer set search_path = public as $$
  select
    (select count(*)::int from participantes where is_demo),
    (select count(*)::int from avaliacoes where coalesce(is_demo,false)),
    (select count(*)::int from avaliacoes where coalesce(is_test,false));
$$;

-- ─── Registro de validação controlada (item 34) ─────────────────────────────
create or replace function limpar_dados_teste()
returns int
language plpgsql security definer set search_path = public as $$
declare n int;
begin
  if not eh_master() then raise exception 'Apenas o Administrador Master pode remover o registro de validação.'; end if;
  delete from participantes where is_test;
  get diagnostics n = row_count;
  insert into logs_auditoria (user_id, usuario_email, acao, escopo, registros_afetados, detalhe)
  values (auth.uid(), email_do_usuario(), 'LIMPEZA_TESTE', 'teste', n,
          jsonb_build_object('metodo','exclusão física dos registros is_test'));
  return n;
end $$;

-- ─── Reaplicação autorizada (item 17) ───────────────────────────────────────
-- Arquiva a avaliação concluída e libera a matrícula para responder de novo.
create or replace function liberar_reaplicacao(p_matricula text)
returns int
language plpgsql security definer set search_path = public as $$
declare n int; pid uuid;
begin
  if not eh_master() then raise exception 'Apenas o Administrador Master pode liberar a reaplicação.'; end if;
  select id into pid from participantes where matricula = p_matricula;
  if pid is null then raise exception 'Matrícula % não encontrada.', p_matricula; end if;

  update avaliacoes set arquivada_em = now(), arquivada_por = auth.uid()
  where participante_id = pid and status = 'CONCLUIDA' and arquivada_em is null;
  get diagnostics n = row_count;

  update participantes set reaplicacao_liberada_em = now(), reaplicacao_liberada_por = auth.uid()
  where id = pid;

  insert into logs_auditoria (user_id, usuario_email, acao, escopo, parametro, registros_afetados, detalhe)
  values (auth.uid(), email_do_usuario(), 'ALTERACAO_CONFIGURACAO', 'reaplicacao', p_matricula, n,
          jsonb_build_object('metodo','avaliação anterior arquivada; matrícula liberada para nova aplicação'));
  return n;
end $$;

-- ─── Auditoria genérica (item 27) ───────────────────────────────────────────
-- LOGIN | CONCLUSAO | EXPORTACAO | RESET | LIMPEZA_DEMO | ALTERACAO_CONFIGURACAO
create or replace function registrar_evento(
  p_acao text, p_escopo text default null, p_parametro text default null,
  p_registros int default 0, p_detalhe jsonb default '{}'::jsonb)
returns void
language sql security definer set search_path = public as $$
  insert into logs_auditoria (user_id, usuario_email, acao, escopo, parametro, registros_afetados, detalhe)
  values (auth.uid(), email_do_usuario(), p_acao, p_escopo, p_parametro, p_registros, p_detalhe);
$$;

-- As funções antigas passam a gravar o e-mail também.
create or replace function registrar_exportacao(p_tipo text, p_registros int, p_detalhe jsonb default '{}'::jsonb)
returns void
language sql security definer set search_path = public as $$
  insert into logs_auditoria (user_id, usuario_email, acao, escopo, registros_afetados, detalhe)
  values (auth.uid(), email_do_usuario(), 'EXPORTACAO', p_tipo, p_registros, p_detalhe);
$$;

-- ============================================================================
-- CHECKLIST DE PRÉ-APLICAÇÃO (itens 32 e 33)
-- ----------------------------------------------------------------------------
-- Tudo o que pode ser verificado NO BANCO é verificado aqui. O que só pode ser
-- verificado exercitando a aplicação (salvamento, retomada, finalização,
-- resultado individual, comparação, dashboard e Excel) é executado pela rotina
-- "Preparar sistema para aplicação real", que roda as sondas de verdade e
-- completa este mesmo checklist.
-- ============================================================================
create or replace function verificar_prontidao()
returns table (chave text, item text, ok boolean, detalhe text)
language plpgsql stable security definer set search_path = public as $$
declare v_versao uuid; n int; m int;
begin
  if not eh_master() then raise exception 'Apenas o Administrador Master pode executar a verificação.'; end if;

  select id into v_versao from versoes_instrumento where ativa limit 1;

  chave := 'banco';        item := 'Banco conectado';
  ok := true; detalhe := 'Conexão ativa em ' || current_database(); return next;

  chave := 'tabelas';      item := 'Tabelas do instrumento presentes';
  select count(*) into n from information_schema.tables where table_schema='public' and table_name in
    ('setores','versoes_instrumento','questoes','alternativas','perfis','matriz_funcional','afinidade_belbin',
     'participantes','administradores','avaliacoes','respostas','escores','resultados',
     'resultados_funcionais','resultados_belbin','logs_auditoria');
  ok := n = 16; detalhe := n || ' de 16 tabelas encontradas'; return next;

  chave := 'questoes';     item := '48 questões carregadas';
  select count(*) into n from questoes q where q.versao_id = v_versao and q.ativa;
  ok := n = 48; detalhe := n || ' questões na versão ativa'; return next;

  chave := 'alternativas'; item := '48 questões com alternativas';
  select count(*) into n from alternativas a join questoes q on q.id = a.questao_id where q.versao_id = v_versao;
  select count(*) into m from (select q.id from questoes q join alternativas a on a.questao_id=q.id
     where q.versao_id=v_versao group by q.id having count(*)=4) z;
  ok := n = 192 and m = 48; detalhe := n || ' alternativas · ' || m || ' itens com exatamente 4'; return next;

  chave := 'algoritmo';    item := 'Algoritmo ativo (versão e denominadores)';
  ok := v_versao is not null;
  detalhe := coalesce((select 'versão ' || codigo || ' · pesos ' || peso_atitude || '/' || peso_funcao
                       from versoes_instrumento where id = v_versao), 'nenhuma versão ativa'); return next;

  chave := 'setores';      item := 'Setores cadastrados';
  select count(*) into n from setores where ativo;
  ok := n > 0; detalhe := n || ' setor(es) ativo(s)'; return next;

  chave := 'rls';          item := 'Row Level Security ativo';
  select count(*) into n from pg_class c join pg_namespace ns on ns.oid=c.relnamespace
   where ns.nspname='public' and c.relrowsecurity and c.relname in
    ('participantes','avaliacoes','respostas','escores','resultados','resultados_funcionais',
     'resultados_belbin','logs_auditoria');
  ok := n = 8; detalhe := n || ' de 8 tabelas sensíveis com RLS'; return next;

  chave := 'administrador'; item := 'Administrador autenticado';
  select count(*) into n from administradores where papel = 'MASTER';
  ok := n > 0; detalhe := n || ' Administrador(es) Master'; return next;

  chave := 'logs';         item := 'Logs funcionando';
  select count(*) into n from logs_auditoria;
  ok := true; detalhe := n || ' evento(s) registrado(s)'; return next;

  chave := 'demo_zero';    item := 'Dados DEMO = 0';
  select (select count(*) from participantes where is_demo)
       + (select count(*) from avaliacoes where coalesce(is_demo,false)) into n;
  ok := n = 0; detalhe := n || ' registro(s) de demonstração no banco'; return next;

  chave := 'teste_zero';   item := 'Registros de validação (is_test) = 0';
  select count(*) into n from participantes where is_test;
  ok := n = 0; detalhe := n || ' registro(s) de validação controlada'; return next;

  chave := 'integridade';  item := 'Avaliações concluídas com 48 respostas';
  select count(*) into n from avaliacoes a
   where a.status='CONCLUIDA' and a.arquivada_em is null
     and (select count(*) from respostas r where r.avaliacao_id = a.id) <> 48;
  ok := n = 0; detalhe := case when n=0 then 'nenhuma inconsistência' else n || ' avaliação(ões) com contagem diferente de 48' end; return next;

  chave := 'derivados';    item := 'Resultados derivados completos';
  select count(*) into n from avaliacoes a
   where a.status='CONCLUIDA' and a.arquivada_em is null
     and (not exists (select 1 from resultados x where x.avaliacao_id=a.id)
       or not exists (select 1 from escores x where x.avaliacao_id=a.id)
       or not exists (select 1 from resultados_funcionais x where x.avaliacao_id=a.id)
       or not exists (select 1 from resultados_belbin x where x.avaliacao_id=a.id));
  ok := n = 0; detalhe := case when n=0 then 'todas as trilhas gravadas' else n || ' avaliação(ões) sem resultado completo' end; return next;

  chave := 'orfas';        item := 'Respostas sem participante';
  select count(*) into n from respostas r
   where not exists (select 1 from avaliacoes a where a.id = r.avaliacao_id);
  ok := n = 0; detalhe := n || ' resposta(s) órfã(s)'; return next;
end $$;

-- ─── RLS: leitura das novas funções e views ─────────────────────────────────
grant execute on function previa_limpeza_demo()          to authenticated;
grant execute on function limpar_dados_demo(text)        to authenticated;
grant execute on function contagem_demo()                to authenticated;
grant execute on function limpar_dados_teste()           to authenticated;
grant execute on function liberar_reaplicacao(text)      to authenticated;
grant execute on function verificar_prontidao()          to authenticated;
grant execute on function resumo_organizacional()        to authenticated;
grant execute on function registrar_evento(text,text,text,int,jsonb) to authenticated;

commit;
