-- ============================================================================
-- ⚠️  ARQUIVO DE DESENVOLVIMENTO — NÃO EXECUTE EM AMBIENTE DE APLICAÇÃO REAL
-- ============================================================================
-- SEED DE DEMONSTRAÇÃO — 96 participantes simulados, 16 setores
-- gerado por scripts/gen-sql.ts (determinístico: mesma semente, mesmos dados)
-- REQUER 05_migracao_v2.sql aplicado antes (tabelas resultados_funcionais e resultados_belbin).
--
-- Todos os registros aqui recebem is_demo = true. A aplicação em produção NUNCA
-- os executa: nenhum código da aplicação chama este arquivo, e a view
-- vw_resultados os exclui por definição. Se algum dia ele tiver sido aplicado
-- por engano, use  Gestão de dados → Preparar aplicação → LIMPAR DADOS DA
-- DEMONSTRAÇÃO,  ou  select limpar_dados_demo('LIMPAR DADOS DEMO');
-- ----------------------------------------------------------------------------
-- Inclui as RESPOSTAS BRUTAS item a item (96 × 48 = 4608 linhas),
-- exatamente como o sistema grava em produção — permitindo testar recálculo,
-- dashboards e análise psicométrica desde o primeiro minuto.
--
-- Estes participantes NÃO têm user_id (não existem em auth.users): são registros
-- de demonstração. Para removê-los depois:
--   delete from participantes where email like '%@exemplo.gov.br';
-- ============================================================================
begin;

do $demo$
declare v_part uuid; v_aval uuid; v_setor uuid;
begin

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Ana Ferreira', '100007', 'demo001@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-21T13:11:00Z'::timestamptz - interval '14 minutes', '2026-07-21T13:11:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":20,"F":2,"S":1,"N":4}'::jsonb, '{"E":70.4,"I":29.6,"T":74.1,"F":7.4,"S":3.7,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'N', 'S',
    'F', 'Te', 'Ne', false, null,
    false, null,
    ARRAY['T','N','F','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":7,"AUT":15,"COO":7,"FLE":6,"EST":14}'::jsonb, '{"EXP":17.9,"EXE":20,"AUT":34.1,"COO":15.6,"FLE":27.3,"EST":33.3}'::jsonb, '{"CRIAR":14,"EXPLORAR":10,"ANALISAR":37,"DECIDIR":25,"ORGANIZAR":22,"EXECUTAR":14,"RELACIONAR":17,"COORDENAR":9,"FINALIZAR":9,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":17.2,"ANALISAR":47.4,"DECIDIR":61,"ORGANIZAR":41.5,"EXECUTAR":25.5,"RELACIONAR":20.2,"COORDENAR":14.8,"FINALIZAR":19.1,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','ORGANIZAR','EXECUTAR','CRIAR','RELACIONAR','FINALIZAR','EXPLORAR','ESPECIALIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":15,"INV_RECURSOS":11,"COORDENADOR":13,"FORMADOR":24,"MONITOR":37,"IMPLEMENTADOR":29,"TRAB_EQUIPE":12,"FINALIZADOR":10,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":20.3,"INV_RECURSOS":20.8,"COORDENADOR":23.2,"FORMADOR":58.5,"MONITOR":50.7,"IMPLEMENTADOR":40.3,"TRAB_EQUIPE":14.6,"FINALIZADOR":20,"ESPECIALISTA":19}'::jsonb,
    'FORMADOR', 58.5, 'Alta',
    'MONITOR', 50.7, 'Alta',
    'IMPLEMENTADOR', 40.3, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Vinícius Klein', '100014', 'demo002@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:12:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:12:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":9,"I":18,"T":3,"F":3,"S":18,"N":3}'::jsonb, '{"E":33.3,"I":66.7,"T":11.1,"F":11.1,"S":66.7,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'N',
    'N', 'Si', 'Ti', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":20,"AUT":9,"COO":5,"FLE":1,"EST":14}'::jsonb, '{"EXP":17.9,"EXE":57.1,"AUT":20.5,"COO":11.1,"FLE":4.5,"EST":33.3}'::jsonb, '{"CRIAR":10,"EXPLORAR":13,"ANALISAR":27,"DECIDIR":6,"ORGANIZAR":21,"EXECUTAR":28,"RELACIONAR":13,"COORDENAR":9,"FINALIZAR":24,"ESPECIALIZAR":20}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":22.4,"ANALISAR":34.6,"DECIDIR":14.6,"ORGANIZAR":39.6,"EXECUTAR":50.9,"RELACIONAR":15.5,"COORDENAR":14.8,"FINALIZAR":51.1,"ESPECIALIZAR":40.8}'::jsonb,
    ARRAY['FINALIZAR','EXECUTAR','ESPECIALIZAR','ORGANIZAR','ANALISAR','EXPLORAR','CRIAR','RELACIONAR','COORDENAR','DECIDIR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":10,"COORDENADOR":8,"FORMADOR":5,"MONITOR":23,"IMPLEMENTADOR":41,"TRAB_EQUIPE":14,"FINALIZADOR":27,"ESPECIALISTA":24}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":18.9,"COORDENADOR":14.3,"FORMADOR":12.2,"MONITOR":31.5,"IMPLEMENTADOR":56.9,"TRAB_EQUIPE":17.1,"FINALIZADOR":54,"ESPECIALISTA":41.4}'::jsonb,
    'IMPLEMENTADOR', 56.9, 'Alta',
    'FINALIZADOR', 54, 'Alta',
    'ESPECIALISTA', 41.4, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('William Gomes', '100021', 'demo003@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:13:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:13:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":11,"I":16,"T":3,"F":4,"S":1,"N":19}'::jsonb, '{"E":40.7,"I":59.3,"T":11.1,"F":14.8,"S":3.7,"N":70.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'F', 'S',
    'S', 'Ni', 'Fi', false, null,
    false, null,
    ARRAY['N','F','T','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":16,"EXE":4,"AUT":15,"COO":7,"FLE":6,"EST":6}'::jsonb, '{"EXP":57.1,"EXE":11.4,"AUT":34.1,"COO":15.6,"FLE":27.3,"EST":14.3}'::jsonb, '{"CRIAR":37,"EXPLORAR":28,"ANALISAR":28,"DECIDIR":6,"ORGANIZAR":8,"EXECUTAR":14,"RELACIONAR":15,"COORDENAR":11,"FINALIZAR":6,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":58.7,"EXPLORAR":48.3,"ANALISAR":35.9,"DECIDIR":14.6,"ORGANIZAR":15.1,"EXECUTAR":25.5,"RELACIONAR":17.9,"COORDENAR":18,"FINALIZAR":12.8,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','ANALISAR','EXECUTAR','ESPECIALIZAR','COORDENAR','RELACIONAR','ORGANIZAR','DECIDIR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":40,"INV_RECURSOS":25,"COORDENADOR":10,"FORMADOR":4,"MONITOR":27,"IMPLEMENTADOR":19,"TRAB_EQUIPE":15,"FINALIZADOR":7,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":54.1,"INV_RECURSOS":47.2,"COORDENADOR":17.9,"FORMADOR":9.8,"MONITOR":37,"IMPLEMENTADOR":26.4,"TRAB_EQUIPE":18.3,"FINALIZADOR":14,"ESPECIALISTA":25.9}'::jsonb,
    'PLANTA', 54.1, 'Alta',
    'INV_RECURSOS', 47.2, 'Alta',
    'MONITOR', 37, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Paulo Pereira', '100028', 'demo004@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-15T13:14:00Z'::timestamptz - interval '14 minutes', '2026-07-15T13:14:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":16,"I":11,"T":3,"F":1,"S":18,"N":5}'::jsonb, '{"E":59.3,"I":40.7,"T":11.1,"F":3.7,"S":66.7,"N":18.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'F',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":17,"AUT":9,"COO":6,"FLE":6,"EST":9}'::jsonb, '{"EXP":25,"EXE":48.6,"AUT":20.5,"COO":13.3,"FLE":27.3,"EST":21.4}'::jsonb, '{"CRIAR":15,"EXPLORAR":19,"ANALISAR":26,"DECIDIR":16,"ORGANIZAR":8,"EXECUTAR":20,"RELACIONAR":13,"COORDENAR":8,"FINALIZAR":17,"ESPECIALIZAR":27}'::jsonb, '{"CRIAR":23.8,"EXPLORAR":32.8,"ANALISAR":33.3,"DECIDIR":39,"ORGANIZAR":15.1,"EXECUTAR":36.4,"RELACIONAR":15.5,"COORDENAR":13.1,"FINALIZAR":36.2,"ESPECIALIZAR":55.1}'::jsonb,
    ARRAY['ESPECIALIZAR','DECIDIR','EXECUTAR','FINALIZAR','ANALISAR','EXPLORAR','CRIAR','RELACIONAR','ORGANIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":20,"INV_RECURSOS":17,"COORDENADOR":9,"FORMADOR":18,"MONITOR":20,"IMPLEMENTADOR":23,"TRAB_EQUIPE":10,"FINALIZADOR":16,"ESPECIALISTA":29}'::jsonb, '{"PLANTA":27,"INV_RECURSOS":32.1,"COORDENADOR":16.1,"FORMADOR":43.9,"MONITOR":27.4,"IMPLEMENTADOR":31.9,"TRAB_EQUIPE":12.2,"FINALIZADOR":32,"ESPECIALISTA":50}'::jsonb,
    'ESPECIALISTA', 50, 'Alta',
    'FORMADOR', 43.9, 'Moderada',
    'INV_RECURSOS', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Nogueira', '100035', 'demo005@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-21T13:15:00Z'::timestamptz - interval '14 minutes', '2026-07-21T13:15:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":19,"F":4,"S":3,"N":1}'::jsonb, '{"E":44.4,"I":55.6,"T":70.4,"F":14.8,"S":11.1,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','F','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":5,"AUT":18,"COO":10,"FLE":4,"EST":16}'::jsonb, '{"EXP":3.6,"EXE":14.3,"AUT":40.9,"COO":22.2,"FLE":18.2,"EST":38.1}'::jsonb, '{"CRIAR":4,"EXPLORAR":7,"ANALISAR":41,"DECIDIR":22,"ORGANIZAR":19,"EXECUTAR":13,"RELACIONAR":23,"COORDENAR":9,"FINALIZAR":16,"ESPECIALIZAR":13}'::jsonb, '{"CRIAR":6.3,"EXPLORAR":12.1,"ANALISAR":52.6,"DECIDIR":53.7,"ORGANIZAR":35.8,"EXECUTAR":23.6,"RELACIONAR":27.4,"COORDENAR":14.8,"FINALIZAR":34,"ESPECIALIZAR":26.5}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','ORGANIZAR','FINALIZAR','RELACIONAR','ESPECIALIZAR','EXECUTAR','COORDENAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":6,"INV_RECURSOS":6,"COORDENADOR":12,"FORMADOR":20,"MONITOR":40,"IMPLEMENTADOR":26,"TRAB_EQUIPE":20,"FINALIZADOR":15,"ESPECIALISTA":17}'::jsonb, '{"PLANTA":8.1,"INV_RECURSOS":11.3,"COORDENADOR":21.4,"FORMADOR":48.8,"MONITOR":54.8,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":24.4,"FINALIZADOR":30,"ESPECIALISTA":29.3}'::jsonb,
    'MONITOR', 54.8, 'Alta',
    'FORMADOR', 48.8, 'Alta',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Tiago Henriques', '100042', 'demo006@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-22T13:16:00Z'::timestamptz - interval '14 minutes', '2026-07-22T13:16:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":19,"F":3,"S":1,"N":4}'::jsonb, '{"E":77.8,"I":22.2,"T":70.4,"F":11.1,"S":3.7,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'N', 'S',
    'F', 'Te', 'Ne', false, null,
    false, null,
    ARRAY['T','N','F','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":5,"AUT":12,"COO":12,"FLE":6,"EST":12}'::jsonb, '{"EXP":25,"EXE":14.3,"AUT":27.3,"COO":26.7,"FLE":27.3,"EST":28.6}'::jsonb, '{"CRIAR":9,"EXPLORAR":20,"ANALISAR":35,"DECIDIR":19,"ORGANIZAR":15,"EXECUTAR":11,"RELACIONAR":27,"COORDENAR":13,"FINALIZAR":5,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":34.5,"ANALISAR":44.9,"DECIDIR":46.3,"ORGANIZAR":28.3,"EXECUTAR":20,"RELACIONAR":32.1,"COORDENAR":21.3,"FINALIZAR":10.6,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','EXPLORAR','RELACIONAR','ORGANIZAR','ESPECIALIZAR','COORDENAR','EXECUTAR','CRIAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":23,"COORDENADOR":14,"FORMADOR":17,"MONITOR":36,"IMPLEMENTADOR":19,"TRAB_EQUIPE":24,"FINALIZADOR":7,"ESPECIALISTA":13}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":43.4,"COORDENADOR":25,"FORMADOR":41.5,"MONITOR":49.3,"IMPLEMENTADOR":26.4,"TRAB_EQUIPE":29.3,"FINALIZADOR":14,"ESPECIALISTA":22.4}'::jsonb,
    'MONITOR', 49.3, 'Alta',
    'INV_RECURSOS', 43.4, 'Moderada',
    'FORMADOR', 41.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Xavier', '100049', 'demo007@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-16T13:17:00Z'::timestamptz - interval '14 minutes', '2026-07-16T13:17:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":8,"I":19,"T":2,"F":3,"S":3,"N":19}'::jsonb, '{"E":29.6,"I":70.4,"T":7.4,"F":11.1,"S":11.1,"N":70.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'F', 'T',
    'S', 'Ni', 'Fi', false, null,
    false, null,
    ARRAY['N','S','F','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":15,"EXE":3,"AUT":17,"COO":6,"FLE":6,"EST":7}'::jsonb, '{"EXP":53.6,"EXE":8.6,"AUT":38.6,"COO":13.3,"FLE":27.3,"EST":16.7}'::jsonb, '{"CRIAR":44,"EXPLORAR":27,"ANALISAR":26,"DECIDIR":7,"ORGANIZAR":9,"EXECUTAR":8,"RELACIONAR":11,"COORDENAR":9,"FINALIZAR":6,"ESPECIALIZAR":19}'::jsonb, '{"CRIAR":69.8,"EXPLORAR":46.6,"ANALISAR":33.3,"DECIDIR":17.1,"ORGANIZAR":17,"EXECUTAR":14.5,"RELACIONAR":13.1,"COORDENAR":14.8,"FINALIZAR":12.8,"ESPECIALIZAR":38.8}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','ESPECIALIZAR','ANALISAR','DECIDIR','ORGANIZAR','COORDENAR','EXECUTAR','RELACIONAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":49,"INV_RECURSOS":22,"COORDENADOR":7,"FORMADOR":7,"MONITOR":23,"IMPLEMENTADOR":15,"TRAB_EQUIPE":12,"FINALIZADOR":6,"ESPECIALISTA":21}'::jsonb, '{"PLANTA":66.2,"INV_RECURSOS":41.5,"COORDENADOR":12.5,"FORMADOR":17.1,"MONITOR":31.5,"IMPLEMENTADOR":20.8,"TRAB_EQUIPE":14.6,"FINALIZADOR":12,"ESPECIALISTA":36.2}'::jsonb,
    'PLANTA', 66.2, 'Muito alta',
    'INV_RECURSOS', 41.5, 'Moderada',
    'ESPECIALISTA', 36.2, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Amanda Xavier', '100056', 'demo008@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-09T13:18:00Z'::timestamptz - interval '14 minutes', '2026-07-09T13:18:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":22,"I":5,"T":3,"F":3,"S":21,"N":0}'::jsonb, '{"E":81.5,"I":18.5,"T":11.1,"F":11.1,"S":77.8,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":0,"EXE":24,"AUT":4,"COO":14,"FLE":6,"EST":6}'::jsonb, '{"EXP":0,"EXE":68.6,"AUT":9.1,"COO":31.1,"FLE":27.3,"EST":14.3}'::jsonb, '{"CRIAR":4,"EXPLORAR":6,"ANALISAR":21,"DECIDIR":16,"ORGANIZAR":9,"EXECUTAR":34,"RELACIONAR":28,"COORDENAR":15,"FINALIZAR":27,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":6.3,"EXPLORAR":10.3,"ANALISAR":26.9,"DECIDIR":39,"ORGANIZAR":17,"EXECUTAR":61.8,"RELACIONAR":33.3,"COORDENAR":24.6,"FINALIZAR":57.4,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['EXECUTAR','FINALIZAR','DECIDIR','RELACIONAR','ANALISAR','COORDENAR','ORGANIZAR','ESPECIALIZAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":3,"INV_RECURSOS":7,"COORDENADOR":18,"FORMADOR":15,"MONITOR":14,"IMPLEMENTADOR":40,"TRAB_EQUIPE":23,"FINALIZADOR":28,"ESPECIALISTA":14}'::jsonb, '{"PLANTA":4.1,"INV_RECURSOS":13.2,"COORDENADOR":32.1,"FORMADOR":36.6,"MONITOR":19.2,"IMPLEMENTADOR":55.6,"TRAB_EQUIPE":28,"FINALIZADOR":56,"ESPECIALISTA":24.1}'::jsonb,
    'FINALIZADOR', 56, 'Alta',
    'IMPLEMENTADOR', 55.6, 'Alta',
    'FORMADOR', 36.6, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MM';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Carla Nogueira', '100063', 'demo009@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-07T13:19:00Z'::timestamptz - interval '14 minutes', '2026-07-07T13:19:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":20,"I":7,"T":6,"F":3,"S":16,"N":2}'::jsonb, '{"E":74.1,"I":25.9,"T":22.2,"F":11.1,"S":59.3,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":16,"AUT":5,"COO":13,"FLE":2,"EST":12}'::jsonb, '{"EXP":21.4,"EXE":45.7,"AUT":11.4,"COO":28.9,"FLE":9.1,"EST":28.6}'::jsonb, '{"CRIAR":7,"EXPLORAR":17,"ANALISAR":26,"DECIDIR":10,"ORGANIZAR":12,"EXECUTAR":27,"RELACIONAR":25,"COORDENAR":16,"FINALIZAR":18,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":11.1,"EXPLORAR":29.3,"ANALISAR":33.3,"DECIDIR":24.4,"ORGANIZAR":22.6,"EXECUTAR":49.1,"RELACIONAR":29.8,"COORDENAR":26.2,"FINALIZAR":38.3,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['EXECUTAR','FINALIZAR','ANALISAR','RELACIONAR','EXPLORAR','COORDENAR','DECIDIR','ORGANIZAR','ESPECIALIZAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":17,"COORDENADOR":16,"FORMADOR":10,"MONITOR":21,"IMPLEMENTADOR":32,"TRAB_EQUIPE":22,"FINALIZADOR":19,"ESPECIALISTA":16}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":32.1,"COORDENADOR":28.6,"FORMADOR":24.4,"MONITOR":28.8,"IMPLEMENTADOR":44.4,"TRAB_EQUIPE":26.8,"FINALIZADOR":38,"ESPECIALISTA":27.6}'::jsonb,
    'IMPLEMENTADOR', 44.4, 'Moderada',
    'FINALIZADOR', 38, 'Moderada',
    'INV_RECURSOS', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Sofia Cardoso', '100070', 'demo010@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-10T13:20:00Z'::timestamptz - interval '14 minutes', '2026-07-10T13:20:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":24,"I":3,"T":3,"F":3,"S":2,"N":19}'::jsonb, '{"E":88.9,"I":11.1,"T":11.1,"F":11.1,"S":7.4,"N":70.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'F', 'S',
    'S', 'Ne', 'Fe', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['N','T','F','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":18,"EXE":6,"AUT":3,"COO":15,"FLE":7,"EST":5}'::jsonb, '{"EXP":64.3,"EXE":17.1,"AUT":6.8,"COO":33.3,"FLE":31.8,"EST":11.9}'::jsonb, '{"CRIAR":36,"EXPLORAR":37,"ANALISAR":7,"DECIDIR":13,"ORGANIZAR":7,"EXECUTAR":14,"RELACIONAR":32,"COORDENAR":15,"FINALIZAR":5,"ESPECIALIZAR":0}'::jsonb, '{"CRIAR":57.1,"EXPLORAR":63.8,"ANALISAR":9,"DECIDIR":31.7,"ORGANIZAR":13.2,"EXECUTAR":25.5,"RELACIONAR":38.1,"COORDENAR":24.6,"FINALIZAR":10.6,"ESPECIALIZAR":0}'::jsonb,
    ARRAY['EXPLORAR','CRIAR','RELACIONAR','DECIDIR','EXECUTAR','COORDENAR','ORGANIZAR','FINALIZAR','ANALISAR','ESPECIALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":40,"INV_RECURSOS":30,"COORDENADOR":18,"FORMADOR":13,"MONITOR":9,"IMPLEMENTADOR":20,"TRAB_EQUIPE":27,"FINALIZADOR":5,"ESPECIALISTA":0}'::jsonb, '{"PLANTA":54.1,"INV_RECURSOS":56.6,"COORDENADOR":32.1,"FORMADOR":31.7,"MONITOR":12.3,"IMPLEMENTADOR":27.8,"TRAB_EQUIPE":32.9,"FINALIZADOR":10,"ESPECIALISTA":0}'::jsonb,
    'INV_RECURSOS', 56.6, 'Alta',
    'PLANTA', 54.1, 'Alta',
    'TRAB_EQUIPE', 32.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Paulo Pereira', '100077', 'demo011@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-02T13:21:00Z'::timestamptz - interval '14 minutes', '2026-07-02T13:21:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":7,"I":20,"T":2,"F":23,"S":0,"N":2}'::jsonb, '{"E":25.9,"I":74.1,"T":7.4,"F":85.2,"S":0,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'N', 'S',
    'T', 'Fi', 'Ni', false, null,
    false, null,
    ARRAY['F','T','N','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":1,"AUT":13,"COO":23,"FLE":3,"EST":11}'::jsonb, '{"EXP":10.7,"EXE":2.9,"AUT":29.5,"COO":51.1,"FLE":13.6,"EST":26.2}'::jsonb, '{"CRIAR":13,"EXPLORAR":6,"ANALISAR":12,"DECIDIR":8,"ORGANIZAR":16,"EXECUTAR":5,"RELACIONAR":43,"COORDENAR":36,"FINALIZAR":7,"ESPECIALIZAR":21}'::jsonb, '{"CRIAR":20.6,"EXPLORAR":10.3,"ANALISAR":15.4,"DECIDIR":19.5,"ORGANIZAR":30.2,"EXECUTAR":9.1,"RELACIONAR":51.2,"COORDENAR":59,"FINALIZAR":14.9,"ESPECIALIZAR":42.9}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','ESPECIALIZAR','ORGANIZAR','CRIAR','DECIDIR','ANALISAR','FINALIZAR','EXPLORAR','EXECUTAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":16,"INV_RECURSOS":5,"COORDENADOR":29,"FORMADOR":6,"MONITOR":11,"IMPLEMENTADOR":20,"TRAB_EQUIPE":47,"FINALIZADOR":5,"ESPECIALISTA":23}'::jsonb, '{"PLANTA":21.6,"INV_RECURSOS":9.4,"COORDENADOR":51.8,"FORMADOR":14.6,"MONITOR":15.1,"IMPLEMENTADOR":27.8,"TRAB_EQUIPE":57.3,"FINALIZADOR":10,"ESPECIALISTA":39.7}'::jsonb,
    'TRAB_EQUIPE', 57.3, 'Alta',
    'COORDENADOR', 51.8, 'Alta',
    'ESPECIALISTA', 39.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Nuno Nogueira', '100084', 'demo012@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-03T13:22:00Z'::timestamptz - interval '14 minutes', '2026-07-03T13:22:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":8,"I":19,"T":1,"F":0,"S":24,"N":2}'::jsonb, '{"E":29.6,"I":70.4,"T":3.7,"F":0,"S":88.9,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":22,"AUT":11,"COO":5,"FLE":3,"EST":12}'::jsonb, '{"EXP":3.6,"EXE":62.9,"AUT":25,"COO":11.1,"FLE":13.6,"EST":28.6}'::jsonb, '{"CRIAR":12,"EXPLORAR":6,"ANALISAR":34,"DECIDIR":9,"ORGANIZAR":20,"EXECUTAR":27,"RELACIONAR":12,"COORDENAR":3,"FINALIZAR":28,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":19,"EXPLORAR":10.3,"ANALISAR":43.6,"DECIDIR":22,"ORGANIZAR":37.7,"EXECUTAR":49.1,"RELACIONAR":14.3,"COORDENAR":4.9,"FINALIZAR":59.6,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['FINALIZAR','EXECUTAR','ANALISAR','ORGANIZAR','ESPECIALIZAR','DECIDIR','CRIAR','RELACIONAR','EXPLORAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":15,"INV_RECURSOS":6,"COORDENADOR":6,"FORMADOR":8,"MONITOR":25,"IMPLEMENTADOR":40,"TRAB_EQUIPE":7,"FINALIZADOR":32,"ESPECIALISTA":23}'::jsonb, '{"PLANTA":20.3,"INV_RECURSOS":11.3,"COORDENADOR":10.7,"FORMADOR":19.5,"MONITOR":34.2,"IMPLEMENTADOR":55.6,"TRAB_EQUIPE":8.5,"FINALIZADOR":64,"ESPECIALISTA":39.7}'::jsonb,
    'FINALIZADOR', 64, 'Muito alta',
    'IMPLEMENTADOR', 55.6, 'Alta',
    'ESPECIALISTA', 39.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Ferreira', '100091', 'demo013@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-21T13:23:00Z'::timestamptz - interval '14 minutes', '2026-07-21T13:23:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":18,"I":9,"T":5,"F":16,"S":3,"N":3}'::jsonb, '{"E":66.7,"I":33.3,"T":18.5,"F":59.3,"S":11.1,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'N',
    'T', 'Fe', 'Ne', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":6,"AUT":4,"COO":21,"FLE":4,"EST":12}'::jsonb, '{"EXP":25,"EXE":17.1,"AUT":9.1,"COO":46.7,"FLE":18.2,"EST":28.6}'::jsonb, '{"CRIAR":7,"EXPLORAR":16,"ANALISAR":19,"DECIDIR":12,"ORGANIZAR":10,"EXECUTAR":12,"RELACIONAR":33,"COORDENAR":36,"FINALIZAR":8,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":11.1,"EXPLORAR":27.6,"ANALISAR":24.4,"DECIDIR":29.3,"ORGANIZAR":18.9,"EXECUTAR":21.8,"RELACIONAR":39.3,"COORDENAR":59,"FINALIZAR":17,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','DECIDIR','EXPLORAR','ESPECIALIZAR','ANALISAR','EXECUTAR','ORGANIZAR','FINALIZAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":11,"INV_RECURSOS":14,"COORDENADOR":30,"FORMADOR":12,"MONITOR":19,"IMPLEMENTADOR":14,"TRAB_EQUIPE":38,"FINALIZADOR":8,"ESPECIALISTA":16}'::jsonb, '{"PLANTA":14.9,"INV_RECURSOS":26.4,"COORDENADOR":53.6,"FORMADOR":29.3,"MONITOR":26,"IMPLEMENTADOR":19.4,"TRAB_EQUIPE":46.3,"FINALIZADOR":16,"ESPECIALISTA":27.6}'::jsonb,
    'COORDENADOR', 53.6, 'Alta',
    'TRAB_EQUIPE', 46.3, 'Alta',
    'FORMADOR', 29.3, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Lucas Vieira', '100098', 'demo014@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-19T13:24:00Z'::timestamptz - interval '14 minutes', '2026-07-19T13:24:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":1,"F":4,"S":1,"N":21}'::jsonb, '{"E":70.4,"I":29.6,"T":3.7,"F":14.8,"S":3.7,"N":77.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'F', 'S',
    'S', 'Ne', 'Fe', false, null,
    false, null,
    ARRAY['N','F','T','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":17,"EXE":7,"AUT":7,"COO":9,"FLE":9,"EST":5}'::jsonb, '{"EXP":60.7,"EXE":20,"AUT":15.9,"COO":20,"FLE":40.9,"EST":11.9}'::jsonb, '{"CRIAR":40,"EXPLORAR":32,"ANALISAR":12,"DECIDIR":14,"ORGANIZAR":6,"EXECUTAR":14,"RELACIONAR":23,"COORDENAR":12,"FINALIZAR":5,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":63.5,"EXPLORAR":55.2,"ANALISAR":15.4,"DECIDIR":34.1,"ORGANIZAR":11.3,"EXECUTAR":25.5,"RELACIONAR":27.4,"COORDENAR":19.7,"FINALIZAR":10.6,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','DECIDIR','RELACIONAR','EXECUTAR','COORDENAR','ESPECIALIZAR','ANALISAR','ORGANIZAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":45,"INV_RECURSOS":24,"COORDENADOR":16,"FORMADOR":14,"MONITOR":13,"IMPLEMENTADOR":18,"TRAB_EQUIPE":18,"FINALIZADOR":5,"ESPECIALISTA":9}'::jsonb, '{"PLANTA":60.8,"INV_RECURSOS":45.3,"COORDENADOR":28.6,"FORMADOR":34.1,"MONITOR":17.8,"IMPLEMENTADOR":25,"TRAB_EQUIPE":22,"FINALIZADOR":10,"ESPECIALISTA":15.5}'::jsonb,
    'PLANTA', 60.8, 'Muito alta',
    'INV_RECURSOS', 45.3, 'Alta',
    'FORMADOR', 34.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('João Oliveira', '100105', 'demo015@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-19T13:25:00Z'::timestamptz - interval '14 minutes', '2026-07-19T13:25:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":17,"I":10,"T":6,"F":19,"S":1,"N":1}'::jsonb, '{"E":63,"I":37,"T":22.2,"F":70.4,"S":3.7,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'N',
    'T', 'Fe', 'Ne', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":3,"AUT":10,"COO":22,"FLE":8,"EST":6}'::jsonb, '{"EXP":17.9,"EXE":8.6,"AUT":22.7,"COO":48.9,"FLE":36.4,"EST":14.3}'::jsonb, '{"CRIAR":7,"EXPLORAR":11,"ANALISAR":25,"DECIDIR":15,"ORGANIZAR":9,"EXECUTAR":13,"RELACIONAR":45,"COORDENAR":32,"FINALIZAR":7,"ESPECIALIZAR":2}'::jsonb, '{"CRIAR":11.1,"EXPLORAR":19,"ANALISAR":32.1,"DECIDIR":36.6,"ORGANIZAR":17,"EXECUTAR":23.6,"RELACIONAR":53.6,"COORDENAR":52.5,"FINALIZAR":14.9,"ESPECIALIZAR":4.1}'::jsonb,
    ARRAY['RELACIONAR','COORDENAR','DECIDIR','ANALISAR','EXECUTAR','EXPLORAR','ORGANIZAR','FINALIZAR','CRIAR','ESPECIALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":12,"COORDENADOR":27,"FORMADOR":16,"MONITOR":23,"IMPLEMENTADOR":18,"TRAB_EQUIPE":46,"FINALIZADOR":8,"ESPECIALISTA":2}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":22.6,"COORDENADOR":48.2,"FORMADOR":39,"MONITOR":31.5,"IMPLEMENTADOR":25,"TRAB_EQUIPE":56.1,"FINALIZADOR":16,"ESPECIALISTA":3.4}'::jsonb,
    'TRAB_EQUIPE', 56.1, 'Alta',
    'COORDENADOR', 48.2, 'Alta',
    'FORMADOR', 39, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MDHC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Henrique Ribeiro', '100112', 'demo016@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-03T13:26:00Z'::timestamptz - interval '14 minutes', '2026-07-03T13:26:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":4,"F":17,"S":2,"N":4}'::jsonb, '{"E":70.4,"I":29.6,"T":14.8,"F":63,"S":7.4,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'S',
    'T', 'Fe', 'Ne', false, null,
    false, null,
    ARRAY['F','T','N','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":7,"AUT":6,"COO":23,"FLE":6,"EST":6}'::jsonb, '{"EXP":21.4,"EXE":20,"AUT":13.6,"COO":51.1,"FLE":27.3,"EST":14.3}'::jsonb, '{"CRIAR":10,"EXPLORAR":17,"ANALISAR":17,"DECIDIR":11,"ORGANIZAR":7,"EXECUTAR":14,"RELACIONAR":43,"COORDENAR":35,"FINALIZAR":2,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":29.3,"ANALISAR":21.8,"DECIDIR":26.8,"ORGANIZAR":13.2,"EXECUTAR":25.5,"RELACIONAR":51.2,"COORDENAR":57.4,"FINALIZAR":4.3,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','EXPLORAR','DECIDIR','EXECUTAR','ANALISAR','ESPECIALIZAR','CRIAR','ORGANIZAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":15,"COORDENADOR":28,"FORMADOR":10,"MONITOR":18,"IMPLEMENTADOR":19,"TRAB_EQUIPE":49,"FINALIZADOR":3,"ESPECIALISTA":8}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":28.3,"COORDENADOR":50,"FORMADOR":24.4,"MONITOR":24.7,"IMPLEMENTADOR":26.4,"TRAB_EQUIPE":59.8,"FINALIZADOR":6,"ESPECIALISTA":13.8}'::jsonb,
    'TRAB_EQUIPE', 59.8, 'Alta',
    'COORDENADOR', 50, 'Alta',
    'INV_RECURSOS', 28.3, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Nuno Almeida', '100119', 'demo017@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-22T13:27:00Z'::timestamptz - interval '14 minutes', '2026-07-22T13:27:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":25,"I":2,"T":1,"F":3,"S":1,"N":22}'::jsonb, '{"E":92.6,"I":7.4,"T":3.7,"F":11.1,"S":3.7,"N":81.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'F', 'S',
    'S', 'Ne', 'Fe', false, null,
    false, null,
    ARRAY['N','F','T','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":18,"EXE":4,"AUT":2,"COO":17,"FLE":12,"EST":1}'::jsonb, '{"EXP":64.3,"EXE":11.4,"AUT":4.5,"COO":37.8,"FLE":54.5,"EST":2.4}'::jsonb, '{"CRIAR":41,"EXPLORAR":40,"ANALISAR":7,"DECIDIR":11,"ORGANIZAR":2,"EXECUTAR":13,"RELACIONAR":31,"COORDENAR":19,"FINALIZAR":0,"ESPECIALIZAR":2}'::jsonb, '{"CRIAR":65.1,"EXPLORAR":69,"ANALISAR":9,"DECIDIR":26.8,"ORGANIZAR":3.8,"EXECUTAR":23.6,"RELACIONAR":36.9,"COORDENAR":31.1,"FINALIZAR":0,"ESPECIALIZAR":4.1}'::jsonb,
    ARRAY['EXPLORAR','CRIAR','RELACIONAR','COORDENAR','DECIDIR','EXECUTAR','ANALISAR','ESPECIALIZAR','ORGANIZAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":47,"INV_RECURSOS":37,"COORDENADOR":23,"FORMADOR":11,"MONITOR":6,"IMPLEMENTADOR":14,"TRAB_EQUIPE":22,"FINALIZADOR":0,"ESPECIALISTA":2}'::jsonb, '{"PLANTA":63.5,"INV_RECURSOS":69.8,"COORDENADOR":41.1,"FORMADOR":26.8,"MONITOR":8.2,"IMPLEMENTADOR":19.4,"TRAB_EQUIPE":26.8,"FINALIZADOR":0,"ESPECIALISTA":3.4}'::jsonb,
    'INV_RECURSOS', 69.8, 'Muito alta',
    'PLANTA', 63.5, 'Muito alta',
    'COORDENADOR', 41.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Sofia Xavier', '100126', 'demo018@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-25T13:28:00Z'::timestamptz - interval '14 minutes', '2026-07-25T13:28:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":4,"I":23,"T":0,"F":7,"S":2,"N":18}'::jsonb, '{"E":14.8,"I":85.2,"T":0,"F":25.9,"S":7.4,"N":66.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'F', 'T',
    'S', 'Ni', 'Fi', false, null,
    false, null,
    ARRAY['N','F','S','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":15,"EXE":2,"AUT":11,"COO":7,"FLE":5,"EST":14}'::jsonb, '{"EXP":53.6,"EXE":5.7,"AUT":25,"COO":15.6,"FLE":22.7,"EST":33.3}'::jsonb, '{"CRIAR":33,"EXPLORAR":25,"ANALISAR":18,"DECIDIR":7,"ORGANIZAR":20,"EXECUTAR":5,"RELACIONAR":18,"COORDENAR":10,"FINALIZAR":10,"ESPECIALIZAR":19}'::jsonb, '{"CRIAR":52.4,"EXPLORAR":43.1,"ANALISAR":23.1,"DECIDIR":17.1,"ORGANIZAR":37.7,"EXECUTAR":9.1,"RELACIONAR":21.4,"COORDENAR":16.4,"FINALIZAR":21.3,"ESPECIALIZAR":38.8}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','ESPECIALIZAR','ORGANIZAR','ANALISAR','RELACIONAR','FINALIZAR','DECIDIR','COORDENAR','EXECUTAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":39,"INV_RECURSOS":20,"COORDENADOR":8,"FORMADOR":6,"MONITOR":17,"IMPLEMENTADOR":22,"TRAB_EQUIPE":17,"FINALIZADOR":11,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":52.7,"INV_RECURSOS":37.7,"COORDENADOR":14.3,"FORMADOR":14.6,"MONITOR":23.3,"IMPLEMENTADOR":30.6,"TRAB_EQUIPE":20.7,"FINALIZADOR":22,"ESPECIALISTA":37.9}'::jsonb,
    'PLANTA', 52.7, 'Alta',
    'ESPECIALISTA', 37.9, 'Moderada',
    'INV_RECURSOS', 37.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Mariana Santos', '100133', 'demo019@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:29:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:29:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":23,"I":4,"T":2,"F":1,"S":1,"N":23}'::jsonb, '{"E":85.2,"I":14.8,"T":7.4,"F":3.7,"S":3.7,"N":85.2}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    false, null,
    ARRAY['N','T','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":17,"EXE":6,"AUT":7,"COO":13,"FLE":10,"EST":1}'::jsonb, '{"EXP":60.7,"EXE":17.1,"AUT":15.9,"COO":28.9,"FLE":45.5,"EST":2.4}'::jsonb, '{"CRIAR":45,"EXPLORAR":35,"ANALISAR":14,"DECIDIR":11,"ORGANIZAR":2,"EXECUTAR":14,"RELACIONAR":27,"COORDENAR":15,"FINALIZAR":1,"ESPECIALIZAR":1}'::jsonb, '{"CRIAR":71.4,"EXPLORAR":60.3,"ANALISAR":17.9,"DECIDIR":26.8,"ORGANIZAR":3.8,"EXECUTAR":25.5,"RELACIONAR":32.1,"COORDENAR":24.6,"FINALIZAR":2.1,"ESPECIALIZAR":2}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','RELACIONAR','DECIDIR','EXECUTAR','COORDENAR','ANALISAR','ORGANIZAR','FINALIZAR','ESPECIALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":53,"INV_RECURSOS":28,"COORDENADOR":19,"FORMADOR":12,"MONITOR":12,"IMPLEMENTADOR":14,"TRAB_EQUIPE":21,"FINALIZADOR":2,"ESPECIALISTA":1}'::jsonb, '{"PLANTA":71.6,"INV_RECURSOS":52.8,"COORDENADOR":33.9,"FORMADOR":29.3,"MONITOR":16.4,"IMPLEMENTADOR":19.4,"TRAB_EQUIPE":25.6,"FINALIZADOR":4,"ESPECIALISTA":1.7}'::jsonb,
    'PLANTA', 71.6, 'Muito alta',
    'INV_RECURSOS', 52.8, 'Alta',
    'COORDENADOR', 33.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Daniel Duarte', '100140', 'demo020@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-10T13:30:00Z'::timestamptz - interval '14 minutes', '2026-07-10T13:30:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":20,"I":7,"T":0,"F":19,"S":4,"N":4}'::jsonb, '{"E":74.1,"I":25.9,"T":0,"F":70.4,"S":14.8,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'T',
    'T', 'Fe', 'Ne', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['F','S','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":9,"EXE":8,"AUT":5,"COO":24,"FLE":6,"EST":2}'::jsonb, '{"EXP":32.1,"EXE":22.9,"AUT":11.4,"COO":53.3,"FLE":27.3,"EST":4.8}'::jsonb, '{"CRIAR":14,"EXPLORAR":21,"ANALISAR":6,"DECIDIR":12,"ORGANIZAR":5,"EXECUTAR":10,"RELACIONAR":50,"COORDENAR":35,"FINALIZAR":6,"ESPECIALIZAR":7}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":36.2,"ANALISAR":7.7,"DECIDIR":29.3,"ORGANIZAR":9.4,"EXECUTAR":18.2,"RELACIONAR":59.5,"COORDENAR":57.4,"FINALIZAR":12.8,"ESPECIALIZAR":14.3}'::jsonb,
    ARRAY['RELACIONAR','COORDENAR','EXPLORAR','DECIDIR','CRIAR','EXECUTAR','ESPECIALIZAR','FINALIZAR','ORGANIZAR','ANALISAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":17,"INV_RECURSOS":19,"COORDENADOR":32,"FORMADOR":10,"MONITOR":4,"IMPLEMENTADOR":13,"TRAB_EQUIPE":50,"FINALIZADOR":7,"ESPECIALISTA":10}'::jsonb, '{"PLANTA":23,"INV_RECURSOS":35.8,"COORDENADOR":57.1,"FORMADOR":24.4,"MONITOR":5.5,"IMPLEMENTADOR":18.1,"TRAB_EQUIPE":61,"FINALIZADOR":14,"ESPECIALISTA":17.2}'::jsonb,
    'TRAB_EQUIPE', 61, 'Muito alta',
    'COORDENADOR', 57.1, 'Alta',
    'INV_RECURSOS', 35.8, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Zilda Xavier', '100147', 'demo021@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-15T13:31:00Z'::timestamptz - interval '14 minutes', '2026-07-15T13:31:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":0,"F":2,"S":2,"N":23}'::jsonb, '{"E":77.8,"I":22.2,"T":0,"F":7.4,"S":7.4,"N":85.2}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'F', 'T',
    'S', 'Ne', 'Fe', false, null,
    false, null,
    ARRAY['N','S','F','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":17,"EXE":8,"AUT":6,"COO":10,"FLE":11,"EST":2}'::jsonb, '{"EXP":60.7,"EXE":22.9,"AUT":13.6,"COO":22.2,"FLE":50,"EST":4.8}'::jsonb, '{"CRIAR":45,"EXPLORAR":37,"ANALISAR":10,"DECIDIR":13,"ORGANIZAR":3,"EXECUTAR":14,"RELACIONAR":20,"COORDENAR":15,"FINALIZAR":2,"ESPECIALIZAR":7}'::jsonb, '{"CRIAR":71.4,"EXPLORAR":63.8,"ANALISAR":12.8,"DECIDIR":31.7,"ORGANIZAR":5.7,"EXECUTAR":25.5,"RELACIONAR":23.8,"COORDENAR":24.6,"FINALIZAR":4.3,"ESPECIALIZAR":14.3}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','DECIDIR','EXECUTAR','COORDENAR','RELACIONAR','ESPECIALIZAR','ANALISAR','ORGANIZAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":51,"INV_RECURSOS":29,"COORDENADOR":15,"FORMADOR":14,"MONITOR":10,"IMPLEMENTADOR":16,"TRAB_EQUIPE":18,"FINALIZADOR":3,"ESPECIALISTA":6}'::jsonb, '{"PLANTA":68.9,"INV_RECURSOS":54.7,"COORDENADOR":26.8,"FORMADOR":34.1,"MONITOR":13.7,"IMPLEMENTADOR":22.2,"TRAB_EQUIPE":22,"FINALIZADOR":6,"ESPECIALISTA":10.3}'::jsonb,
    'PLANTA', 68.9, 'Muito alta',
    'INV_RECURSOS', 54.7, 'Alta',
    'FORMADOR', 34.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Ana Uchôa', '100154', 'demo022@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-28T13:32:00Z'::timestamptz - interval '14 minutes', '2026-07-28T13:32:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":9,"I":18,"T":8,"F":0,"S":3,"N":16}'::jsonb, '{"E":33.3,"I":66.7,"T":29.6,"F":0,"S":11.1,"N":59.3}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'T', 'F',
    'S', 'Ni', 'Ti', false, null,
    false, null,
    ARRAY['N','T','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":16,"EXE":4,"AUT":20,"COO":3,"FLE":3,"EST":8}'::jsonb, '{"EXP":57.1,"EXE":11.4,"AUT":45.5,"COO":6.7,"FLE":13.6,"EST":19}'::jsonb, '{"CRIAR":35,"EXPLORAR":29,"ANALISAR":34,"DECIDIR":12,"ORGANIZAR":13,"EXECUTAR":10,"RELACIONAR":8,"COORDENAR":6,"FINALIZAR":5,"ESPECIALIZAR":13}'::jsonb, '{"CRIAR":55.6,"EXPLORAR":50,"ANALISAR":43.6,"DECIDIR":29.3,"ORGANIZAR":24.5,"EXECUTAR":18.2,"RELACIONAR":9.5,"COORDENAR":9.8,"FINALIZAR":10.6,"ESPECIALIZAR":26.5}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','ANALISAR','DECIDIR','ESPECIALIZAR','ORGANIZAR','EXECUTAR','FINALIZAR','COORDENAR','RELACIONAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":41,"INV_RECURSOS":22,"COORDENADOR":7,"FORMADOR":11,"MONITOR":33,"IMPLEMENTADOR":18,"TRAB_EQUIPE":7,"FINALIZADOR":7,"ESPECIALISTA":16}'::jsonb, '{"PLANTA":55.4,"INV_RECURSOS":41.5,"COORDENADOR":12.5,"FORMADOR":26.8,"MONITOR":45.2,"IMPLEMENTADOR":25,"TRAB_EQUIPE":8.5,"FINALIZADOR":14,"ESPECIALISTA":27.6}'::jsonb,
    'PLANTA', 55.4, 'Alta',
    'MONITOR', 45.2, 'Alta',
    'INV_RECURSOS', 41.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Úrsula Duarte', '100161', 'demo023@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-12T13:33:00Z'::timestamptz - interval '14 minutes', '2026-07-12T13:33:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":16,"I":11,"T":3,"F":0,"S":4,"N":20}'::jsonb, '{"E":59.3,"I":40.7,"T":11.1,"F":0,"S":14.8,"N":74.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    false, null,
    ARRAY['N','S','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":16,"EXE":7,"AUT":10,"COO":7,"FLE":8,"EST":6}'::jsonb, '{"EXP":57.1,"EXE":20,"AUT":22.7,"COO":15.6,"FLE":36.4,"EST":14.3}'::jsonb, '{"CRIAR":37,"EXPLORAR":31,"ANALISAR":18,"DECIDIR":10,"ORGANIZAR":11,"EXECUTAR":14,"RELACIONAR":18,"COORDENAR":9,"FINALIZAR":10,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":58.7,"EXPLORAR":53.4,"ANALISAR":23.1,"DECIDIR":24.4,"ORGANIZAR":20.8,"EXECUTAR":25.5,"RELACIONAR":21.4,"COORDENAR":14.8,"FINALIZAR":21.3,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','EXECUTAR','DECIDIR','ANALISAR','RELACIONAR','FINALIZAR','ORGANIZAR','ESPECIALIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":43,"INV_RECURSOS":24,"COORDENADOR":10,"FORMADOR":8,"MONITOR":16,"IMPLEMENTADOR":24,"TRAB_EQUIPE":15,"FINALIZADOR":11,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":58.1,"INV_RECURSOS":45.3,"COORDENADOR":17.9,"FORMADOR":19.5,"MONITOR":21.9,"IMPLEMENTADOR":33.3,"TRAB_EQUIPE":18.3,"FINALIZADOR":22,"ESPECIALISTA":19}'::jsonb,
    'PLANTA', 58.1, 'Alta',
    'INV_RECURSOS', 45.3, 'Alta',
    'IMPLEMENTADOR', 33.3, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Yuri Cardoso', '100168', 'demo024@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-22T13:34:00Z'::timestamptz - interval '14 minutes', '2026-07-22T13:34:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":1,"F":17,"S":4,"N":5}'::jsonb, '{"E":44.4,"I":55.6,"T":3.7,"F":63,"S":14.8,"N":18.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'N', 'T',
    'T', 'Fi', 'Ni', false, null,
    false, null,
    ARRAY['F','N','S','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":6,"AUT":6,"COO":18,"FLE":6,"EST":11}'::jsonb, '{"EXP":25,"EXE":17.1,"AUT":13.6,"COO":40,"FLE":27.3,"EST":26.2}'::jsonb, '{"CRIAR":14,"EXPLORAR":16,"ANALISAR":13,"DECIDIR":9,"ORGANIZAR":18,"EXECUTAR":15,"RELACIONAR":34,"COORDENAR":31,"FINALIZAR":7,"ESPECIALIZAR":10}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":27.6,"ANALISAR":16.7,"DECIDIR":22,"ORGANIZAR":34,"EXECUTAR":27.3,"RELACIONAR":40.5,"COORDENAR":50.8,"FINALIZAR":14.9,"ESPECIALIZAR":20.4}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','ORGANIZAR','EXPLORAR','EXECUTAR','CRIAR','DECIDIR','ESPECIALIZAR','ANALISAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":18,"INV_RECURSOS":15,"COORDENADOR":26,"FORMADOR":8,"MONITOR":11,"IMPLEMENTADOR":30,"TRAB_EQUIPE":34,"FINALIZADOR":9,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":24.3,"INV_RECURSOS":28.3,"COORDENADOR":46.4,"FORMADOR":19.5,"MONITOR":15.1,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":41.5,"FINALIZADOR":18,"ESPECIALISTA":19}'::jsonb,
    'COORDENADOR', 46.4, 'Alta',
    'IMPLEMENTADOR', 41.7, 'Moderada',
    'TRAB_EQUIPE', 41.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('João Teixeira', '100175', 'demo025@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-22T13:35:00Z'::timestamptz - interval '14 minutes', '2026-07-22T13:35:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":13,"I":14,"T":6,"F":15,"S":4,"N":2}'::jsonb, '{"E":48.1,"I":51.9,"T":22.2,"F":55.6,"S":14.8,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'S', 'N',
    'T', 'Fi', 'Si', false, null,
    false, null,
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":5,"AUT":9,"COO":19,"FLE":2,"EST":13}'::jsonb, '{"EXP":21.4,"EXE":14.3,"AUT":20.5,"COO":42.2,"FLE":9.1,"EST":31}'::jsonb, '{"CRIAR":9,"EXPLORAR":9,"ANALISAR":19,"DECIDIR":9,"ORGANIZAR":18,"EXECUTAR":13,"RELACIONAR":35,"COORDENAR":30,"FINALIZAR":11,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":15.5,"ANALISAR":24.4,"DECIDIR":22,"ORGANIZAR":34,"EXECUTAR":23.6,"RELACIONAR":41.7,"COORDENAR":49.2,"FINALIZAR":23.4,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','ORGANIZAR','ANALISAR','EXECUTAR','FINALIZAR','ESPECIALIZAR','DECIDIR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":8,"COORDENADOR":25,"FORMADOR":10,"MONITOR":16,"IMPLEMENTADOR":26,"TRAB_EQUIPE":39,"FINALIZADOR":12,"ESPECIALISTA":14}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":15.1,"COORDENADOR":44.6,"FORMADOR":24.4,"MONITOR":21.9,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":47.6,"FINALIZADOR":24,"ESPECIALISTA":24.1}'::jsonb,
    'TRAB_EQUIPE', 47.6, 'Alta',
    'COORDENADOR', 44.6, 'Moderada',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Úrsula Esteves', '100182', 'demo026@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-03T13:36:00Z'::timestamptz - interval '14 minutes', '2026-07-03T13:36:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":20,"I":7,"T":2,"F":1,"S":21,"N":3}'::jsonb, '{"E":74.1,"I":25.9,"T":7.4,"F":3.7,"S":77.8,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'F',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":23,"AUT":2,"COO":13,"FLE":3,"EST":9}'::jsonb, '{"EXP":14.3,"EXE":65.7,"AUT":4.5,"COO":28.9,"FLE":13.6,"EST":21.4}'::jsonb, '{"CRIAR":5,"EXPLORAR":17,"ANALISAR":25,"DECIDIR":13,"ORGANIZAR":10,"EXECUTAR":25,"RELACIONAR":23,"COORDENAR":13,"FINALIZAR":20,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":7.9,"EXPLORAR":29.3,"ANALISAR":32.1,"DECIDIR":31.7,"ORGANIZAR":18.9,"EXECUTAR":45.5,"RELACIONAR":27.4,"COORDENAR":21.3,"FINALIZAR":42.6,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['EXECUTAR','FINALIZAR','ESPECIALIZAR','ANALISAR','DECIDIR','EXPLORAR','RELACIONAR','COORDENAR','ORGANIZAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":6,"INV_RECURSOS":19,"COORDENADOR":14,"FORMADOR":14,"MONITOR":18,"IMPLEMENTADOR":29,"TRAB_EQUIPE":17,"FINALIZADOR":21,"ESPECIALISTA":24}'::jsonb, '{"PLANTA":8.1,"INV_RECURSOS":35.8,"COORDENADOR":25,"FORMADOR":34.1,"MONITOR":24.7,"IMPLEMENTADOR":40.3,"TRAB_EQUIPE":20.7,"FINALIZADOR":42,"ESPECIALISTA":41.4}'::jsonb,
    'FINALIZADOR', 42, 'Moderada',
    'ESPECIALISTA', 41.4, 'Moderada',
    'IMPLEMENTADOR', 40.3, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Gabriela Uchôa', '100189', 'demo027@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-16T13:37:00Z'::timestamptz - interval '14 minutes', '2026-07-16T13:37:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":24,"F":1,"S":2,"N":0}'::jsonb, '{"E":70.4,"I":29.6,"T":88.9,"F":3.7,"S":7.4,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'N',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":9,"AUT":19,"COO":9,"FLE":3,"EST":12}'::jsonb, '{"EXP":7.1,"EXE":25.7,"AUT":43.2,"COO":20,"FLE":13.6,"EST":28.6}'::jsonb, '{"CRIAR":6,"EXPLORAR":6,"ANALISAR":41,"DECIDIR":26,"ORGANIZAR":16,"EXECUTAR":20,"RELACIONAR":16,"COORDENAR":12,"FINALIZAR":11,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":9.5,"EXPLORAR":10.3,"ANALISAR":52.6,"DECIDIR":63.4,"ORGANIZAR":30.2,"EXECUTAR":36.4,"RELACIONAR":19,"COORDENAR":19.7,"FINALIZAR":23.4,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','EXECUTAR','ORGANIZAR','ESPECIALIZAR','FINALIZAR','COORDENAR','RELACIONAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":6,"INV_RECURSOS":6,"COORDENADOR":15,"FORMADOR":26,"MONITOR":42,"IMPLEMENTADOR":27,"TRAB_EQUIPE":13,"FINALIZADOR":12,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":8.1,"INV_RECURSOS":11.3,"COORDENADOR":26.8,"FORMADOR":63.4,"MONITOR":57.5,"IMPLEMENTADOR":37.5,"TRAB_EQUIPE":15.9,"FINALIZADOR":24,"ESPECIALISTA":25.9}'::jsonb,
    'FORMADOR', 63.4, 'Muito alta',
    'MONITOR', 57.5, 'Alta',
    'IMPLEMENTADOR', 37.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Henrique Xavier', '100196', 'demo028@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-01T13:38:00Z'::timestamptz - interval '14 minutes', '2026-07-01T13:38:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":22,"I":5,"T":19,"F":1,"S":2,"N":5}'::jsonb, '{"E":81.5,"I":18.5,"T":70.4,"F":3.7,"S":7.4,"N":18.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'N', 'F',
    'F', 'Te', 'Ne', false, null,
    false, null,
    ARRAY['T','N','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":9,"EXE":4,"AUT":13,"COO":12,"FLE":6,"EST":10}'::jsonb, '{"EXP":32.1,"EXE":11.4,"AUT":29.5,"COO":26.7,"FLE":27.3,"EST":23.8}'::jsonb, '{"CRIAR":16,"EXPLORAR":19,"ANALISAR":33,"DECIDIR":15,"ORGANIZAR":15,"EXECUTAR":16,"RELACIONAR":25,"COORDENAR":16,"FINALIZAR":5,"ESPECIALIZAR":9}'::jsonb, '{"CRIAR":25.4,"EXPLORAR":32.8,"ANALISAR":42.3,"DECIDIR":36.6,"ORGANIZAR":28.3,"EXECUTAR":29.1,"RELACIONAR":29.8,"COORDENAR":26.2,"FINALIZAR":10.6,"ESPECIALIZAR":18.4}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','EXPLORAR','RELACIONAR','EXECUTAR','ORGANIZAR','COORDENAR','CRIAR','ESPECIALIZAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":18,"INV_RECURSOS":17,"COORDENADOR":18,"FORMADOR":16,"MONITOR":32,"IMPLEMENTADOR":22,"TRAB_EQUIPE":23,"FINALIZADOR":5,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":24.3,"INV_RECURSOS":32.1,"COORDENADOR":32.1,"FORMADOR":39,"MONITOR":43.8,"IMPLEMENTADOR":30.6,"TRAB_EQUIPE":28,"FINALIZADOR":10,"ESPECIALISTA":19}'::jsonb,
    'MONITOR', 43.8, 'Moderada',
    'FORMADOR', 39, 'Moderada',
    'INV_RECURSOS', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Sofia Santos', '100203', 'demo029@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-02T13:39:00Z'::timestamptz - interval '14 minutes', '2026-07-02T13:39:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":4,"F":3,"S":13,"N":7}'::jsonb, '{"E":44.4,"I":55.6,"T":14.8,"F":11.1,"S":48.1,"N":25.9}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":12,"AUT":14,"COO":10,"FLE":3,"EST":8}'::jsonb, '{"EXP":25,"EXE":34.3,"AUT":31.8,"COO":22.2,"FLE":13.6,"EST":19}'::jsonb, '{"CRIAR":18,"EXPLORAR":18,"ANALISAR":30,"DECIDIR":12,"ORGANIZAR":10,"EXECUTAR":13,"RELACIONAR":23,"COORDENAR":10,"FINALIZAR":21,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":28.6,"EXPLORAR":31,"ANALISAR":38.5,"DECIDIR":29.3,"ORGANIZAR":18.9,"EXECUTAR":23.6,"RELACIONAR":27.4,"COORDENAR":16.4,"FINALIZAR":44.7,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['FINALIZAR','ANALISAR','EXPLORAR','DECIDIR','CRIAR','RELACIONAR','EXECUTAR','ESPECIALIZAR','ORGANIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":20,"INV_RECURSOS":15,"COORDENADOR":12,"FORMADOR":12,"MONITOR":23,"IMPLEMENTADOR":20,"TRAB_EQUIPE":22,"FINALIZADOR":22,"ESPECIALISTA":16}'::jsonb, '{"PLANTA":27,"INV_RECURSOS":28.3,"COORDENADOR":21.4,"FORMADOR":29.3,"MONITOR":31.5,"IMPLEMENTADOR":27.8,"TRAB_EQUIPE":26.8,"FINALIZADOR":44,"ESPECIALISTA":27.6}'::jsonb,
    'FINALIZADOR', 44, 'Moderada',
    'MONITOR', 31.5, 'Moderada',
    'FORMADOR', 29.3, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Bruno Henriques', '100210', 'demo030@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-09T13:40:00Z'::timestamptz - interval '14 minutes', '2026-07-09T13:40:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":22,"I":5,"T":3,"F":2,"S":18,"N":4}'::jsonb, '{"E":81.5,"I":18.5,"T":11.1,"F":7.4,"S":66.7,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'F',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":20,"AUT":2,"COO":6,"FLE":11,"EST":9}'::jsonb, '{"EXP":21.4,"EXE":57.1,"AUT":4.5,"COO":13.3,"FLE":50,"EST":21.4}'::jsonb, '{"CRIAR":12,"EXPLORAR":17,"ANALISAR":24,"DECIDIR":19,"ORGANIZAR":12,"EXECUTAR":35,"RELACIONAR":20,"COORDENAR":5,"FINALIZAR":17,"ESPECIALIZAR":7}'::jsonb, '{"CRIAR":19,"EXPLORAR":29.3,"ANALISAR":30.8,"DECIDIR":46.3,"ORGANIZAR":22.6,"EXECUTAR":63.6,"RELACIONAR":23.8,"COORDENAR":8.2,"FINALIZAR":36.2,"ESPECIALIZAR":14.3}'::jsonb,
    ARRAY['EXECUTAR','DECIDIR','FINALIZAR','ANALISAR','EXPLORAR','RELACIONAR','ORGANIZAR','CRIAR','ESPECIALIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":16,"INV_RECURSOS":18,"COORDENADOR":5,"FORMADOR":21,"MONITOR":17,"IMPLEMENTADOR":38,"TRAB_EQUIPE":15,"FINALIZADOR":18,"ESPECIALISTA":14}'::jsonb, '{"PLANTA":21.6,"INV_RECURSOS":34,"COORDENADOR":8.9,"FORMADOR":51.2,"MONITOR":23.3,"IMPLEMENTADOR":52.8,"TRAB_EQUIPE":18.3,"FINALIZADOR":36,"ESPECIALISTA":24.1}'::jsonb,
    'IMPLEMENTADOR', 52.8, 'Alta',
    'FORMADOR', 51.2, 'Alta',
    'FINALIZADOR', 36, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Rafael Cardoso', '100217', 'demo031@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-04T13:41:00Z'::timestamptz - interval '14 minutes', '2026-07-04T13:41:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":1,"F":6,"S":15,"N":5}'::jsonb, '{"E":70.4,"I":29.6,"T":3.7,"F":22.2,"S":55.6,"N":18.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'F', 'T',
    'N', 'Se', 'Fe', false, null,
    false, null,
    ARRAY['S','F','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":16,"AUT":6,"COO":14,"FLE":5,"EST":6}'::jsonb, '{"EXP":25,"EXE":45.7,"AUT":13.6,"COO":31.1,"FLE":22.7,"EST":14.3}'::jsonb, '{"CRIAR":12,"EXPLORAR":14,"ANALISAR":26,"DECIDIR":11,"ORGANIZAR":7,"EXECUTAR":25,"RELACIONAR":26,"COORDENAR":21,"FINALIZAR":14,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":19,"EXPLORAR":24.1,"ANALISAR":33.3,"DECIDIR":26.8,"ORGANIZAR":13.2,"EXECUTAR":45.5,"RELACIONAR":31,"COORDENAR":34.4,"FINALIZAR":29.8,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['EXECUTAR','COORDENAR','ANALISAR','RELACIONAR','FINALIZAR','DECIDIR','ESPECIALIZAR','EXPLORAR','CRIAR','ORGANIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":16,"COORDENADOR":18,"FORMADOR":12,"MONITOR":21,"IMPLEMENTADOR":26,"TRAB_EQUIPE":26,"FINALIZADOR":16,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":30.2,"COORDENADOR":32.1,"FORMADOR":29.3,"MONITOR":28.8,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":31.7,"FINALIZADOR":32,"ESPECIALISTA":25.9}'::jsonb,
    'IMPLEMENTADOR', 36.1, 'Moderada',
    'COORDENADOR', 32.1, 'Moderada',
    'FINALIZADOR', 32, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Karina Xavier', '100224', 'demo032@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-11T13:42:00Z'::timestamptz - interval '14 minutes', '2026-07-11T13:42:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":18,"I":9,"T":4,"F":2,"S":20,"N":1}'::jsonb, '{"E":66.7,"I":33.3,"T":14.8,"F":7.4,"S":74.1,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":22,"AUT":9,"COO":8,"FLE":5,"EST":7}'::jsonb, '{"EXP":10.7,"EXE":62.9,"AUT":20.5,"COO":17.8,"FLE":22.7,"EST":16.7}'::jsonb, '{"CRIAR":11,"EXPLORAR":15,"ANALISAR":31,"DECIDIR":13,"ORGANIZAR":10,"EXECUTAR":22,"RELACIONAR":17,"COORDENAR":8,"FINALIZAR":23,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":17.5,"EXPLORAR":25.9,"ANALISAR":39.7,"DECIDIR":31.7,"ORGANIZAR":18.9,"EXECUTAR":40,"RELACIONAR":20.2,"COORDENAR":13.1,"FINALIZAR":48.9,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['FINALIZAR','EXECUTAR','ANALISAR','ESPECIALIZAR','DECIDIR','EXPLORAR','RELACIONAR','ORGANIZAR','CRIAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":14,"INV_RECURSOS":14,"COORDENADOR":10,"FORMADOR":11,"MONITOR":23,"IMPLEMENTADOR":28,"TRAB_EQUIPE":12,"FINALIZADOR":25,"ESPECIALISTA":25}'::jsonb, '{"PLANTA":18.9,"INV_RECURSOS":26.4,"COORDENADOR":17.9,"FORMADOR":26.8,"MONITOR":31.5,"IMPLEMENTADOR":38.9,"TRAB_EQUIPE":14.6,"FINALIZADOR":50,"ESPECIALISTA":43.1}'::jsonb,
    'FINALIZADOR', 50, 'Alta',
    'ESPECIALISTA', 43.1, 'Moderada',
    'IMPLEMENTADOR', 38.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Úrsula Teixeira', '100231', 'demo033@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-14T13:43:00Z'::timestamptz - interval '14 minutes', '2026-07-14T13:43:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":18,"I":9,"T":18,"F":2,"S":5,"N":2}'::jsonb, '{"E":66.7,"I":33.3,"T":66.7,"F":7.4,"S":18.5,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'N',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":4,"AUT":14,"COO":12,"FLE":8,"EST":14}'::jsonb, '{"EXP":7.1,"EXE":11.4,"AUT":31.8,"COO":26.7,"FLE":36.4,"EST":33.3}'::jsonb, '{"CRIAR":14,"EXPLORAR":3,"ANALISAR":40,"DECIDIR":17,"ORGANIZAR":17,"EXECUTAR":4,"RELACIONAR":28,"COORDENAR":15,"FINALIZAR":16,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":5.2,"ANALISAR":51.3,"DECIDIR":41.5,"ORGANIZAR":32.1,"EXECUTAR":7.3,"RELACIONAR":33.3,"COORDENAR":24.6,"FINALIZAR":34,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','FINALIZAR','RELACIONAR','ORGANIZAR','COORDENAR','ESPECIALIZAR','CRIAR','EXECUTAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":16,"INV_RECURSOS":3,"COORDENADOR":18,"FORMADOR":17,"MONITOR":36,"IMPLEMENTADOR":16,"TRAB_EQUIPE":23,"FINALIZADOR":16,"ESPECIALISTA":17}'::jsonb, '{"PLANTA":21.6,"INV_RECURSOS":5.7,"COORDENADOR":32.1,"FORMADOR":41.5,"MONITOR":49.3,"IMPLEMENTADOR":22.2,"TRAB_EQUIPE":28,"FINALIZADOR":32,"ESPECIALISTA":29.3}'::jsonb,
    'MONITOR', 49.3, 'Alta',
    'FORMADOR', 41.5, 'Moderada',
    'COORDENADOR', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Import', '100238', 'demo034@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-28T13:44:00Z'::timestamptz - interval '14 minutes', '2026-07-28T13:44:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":8,"I":19,"T":1,"F":19,"S":5,"N":2}'::jsonb, '{"E":29.6,"I":70.4,"T":3.7,"F":70.4,"S":18.5,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'S', 'T',
    'T', 'Fi', 'Si', false, null,
    false, null,
    ARRAY['F','S','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":6,"AUT":10,"COO":22,"FLE":3,"EST":11}'::jsonb, '{"EXP":7.1,"EXE":17.1,"AUT":22.7,"COO":48.9,"FLE":13.6,"EST":26.2}'::jsonb, '{"CRIAR":7,"EXPLORAR":8,"ANALISAR":16,"DECIDIR":6,"ORGANIZAR":17,"EXECUTAR":10,"RELACIONAR":40,"COORDENAR":32,"FINALIZAR":16,"ESPECIALIZAR":14}'::jsonb, '{"CRIAR":11.1,"EXPLORAR":13.8,"ANALISAR":20.5,"DECIDIR":14.6,"ORGANIZAR":32.1,"EXECUTAR":18.2,"RELACIONAR":47.6,"COORDENAR":52.5,"FINALIZAR":34,"ESPECIALIZAR":28.6}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','FINALIZAR','ORGANIZAR','ESPECIALIZAR','ANALISAR','EXECUTAR','DECIDIR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":8,"COORDENADOR":26,"FORMADOR":4,"MONITOR":15,"IMPLEMENTADOR":22,"TRAB_EQUIPE":43,"FINALIZADOR":17,"ESPECIALISTA":18}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":15.1,"COORDENADOR":46.4,"FORMADOR":9.8,"MONITOR":20.5,"IMPLEMENTADOR":30.6,"TRAB_EQUIPE":52.4,"FINALIZADOR":34,"ESPECIALISTA":31}'::jsonb,
    'TRAB_EQUIPE', 52.4, 'Alta',
    'COORDENADOR', 46.4, 'Alta',
    'FINALIZADOR', 34, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MEC';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Ana Duarte', '100245', 'demo035@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-03T13:45:00Z'::timestamptz - interval '14 minutes', '2026-07-03T13:45:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":23,"I":4,"T":0,"F":25,"S":2,"N":0}'::jsonb, '{"E":85.2,"I":14.8,"T":0,"F":92.6,"S":7.4,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'S', 'N',
    'T', 'Fe', 'Se', false, null,
    false, null,
    ARRAY['F','S','T','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":6,"AUT":1,"COO":32,"FLE":7,"EST":4}'::jsonb, '{"EXP":14.3,"EXE":17.1,"AUT":2.3,"COO":71.1,"FLE":31.8,"EST":9.5}'::jsonb, '{"CRIAR":4,"EXPLORAR":15,"ANALISAR":3,"DECIDIR":13,"ORGANIZAR":8,"EXECUTAR":11,"RELACIONAR":61,"COORDENAR":44,"FINALIZAR":2,"ESPECIALIZAR":6}'::jsonb, '{"CRIAR":6.3,"EXPLORAR":25.9,"ANALISAR":3.8,"DECIDIR":31.7,"ORGANIZAR":15.1,"EXECUTAR":20,"RELACIONAR":72.6,"COORDENAR":72.1,"FINALIZAR":4.3,"ESPECIALIZAR":12.2}'::jsonb,
    ARRAY['RELACIONAR','COORDENAR','DECIDIR','EXPLORAR','EXECUTAR','ORGANIZAR','ESPECIALIZAR','CRIAR','FINALIZAR','ANALISAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":5,"INV_RECURSOS":18,"COORDENADOR":38,"FORMADOR":14,"MONITOR":3,"IMPLEMENTADOR":16,"TRAB_EQUIPE":59,"FINALIZADOR":3,"ESPECIALISTA":6}'::jsonb, '{"PLANTA":6.8,"INV_RECURSOS":34,"COORDENADOR":67.9,"FORMADOR":34.1,"MONITOR":4.1,"IMPLEMENTADOR":22.2,"TRAB_EQUIPE":72,"FINALIZADOR":6,"ESPECIALISTA":10.3}'::jsonb,
    'TRAB_EQUIPE', 72, 'Muito alta',
    'COORDENADOR', 67.9, 'Muito alta',
    'FORMADOR', 34.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'ANTT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Rafael Almeida', '100252', 'demo036@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-26T13:46:00Z'::timestamptz - interval '14 minutes', '2026-07-26T13:46:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":7,"I":20,"T":20,"F":0,"S":5,"N":2}'::jsonb, '{"E":25.9,"I":74.1,"T":74.1,"F":0,"S":18.5,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'F',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','N','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":6,"AUT":20,"COO":5,"FLE":2,"EST":19}'::jsonb, '{"EXP":7.1,"EXE":17.1,"AUT":45.5,"COO":11.1,"FLE":9.1,"EST":45.2}'::jsonb, '{"CRIAR":10,"EXPLORAR":3,"ANALISAR":54,"DECIDIR":13,"ORGANIZAR":24,"EXECUTAR":6,"RELACIONAR":10,"COORDENAR":8,"FINALIZAR":19,"ESPECIALIZAR":20}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":5.2,"ANALISAR":69.2,"DECIDIR":31.7,"ORGANIZAR":45.3,"EXECUTAR":10.9,"RELACIONAR":11.9,"COORDENAR":13.1,"FINALIZAR":40.4,"ESPECIALIZAR":40.8}'::jsonb,
    ARRAY['ANALISAR','ORGANIZAR','ESPECIALIZAR','FINALIZAR','DECIDIR','CRIAR','COORDENAR','RELACIONAR','EXECUTAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":11,"INV_RECURSOS":3,"COORDENADOR":9,"FORMADOR":11,"MONITOR":51,"IMPLEMENTADOR":27,"TRAB_EQUIPE":8,"FINALIZADOR":20,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":14.9,"INV_RECURSOS":5.7,"COORDENADOR":16.1,"FORMADOR":26.8,"MONITOR":69.9,"IMPLEMENTADOR":37.5,"TRAB_EQUIPE":9.8,"FINALIZADOR":40,"ESPECIALISTA":37.9}'::jsonb,
    'MONITOR', 69.9, 'Muito alta',
    'FINALIZADOR', 40, 'Moderada',
    'ESPECIALISTA', 37.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'ANTT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Karina Almeida', '100259', 'demo037@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:47:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:47:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":10,"I":17,"T":3,"F":2,"S":18,"N":4}'::jsonb, '{"E":37,"I":63,"T":11.1,"F":7.4,"S":66.7,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":19,"AUT":6,"COO":6,"FLE":4,"EST":16}'::jsonb, '{"EXP":10.7,"EXE":54.3,"AUT":13.6,"COO":13.3,"FLE":18.2,"EST":38.1}'::jsonb, '{"CRIAR":14,"EXPLORAR":7,"ANALISAR":28,"DECIDIR":11,"ORGANIZAR":28,"EXECUTAR":20,"RELACIONAR":10,"COORDENAR":9,"FINALIZAR":24,"ESPECIALIZAR":17}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":12.1,"ANALISAR":35.9,"DECIDIR":26.8,"ORGANIZAR":52.8,"EXECUTAR":36.4,"RELACIONAR":11.9,"COORDENAR":14.8,"FINALIZAR":51.1,"ESPECIALIZAR":34.7}'::jsonb,
    ARRAY['ORGANIZAR','FINALIZAR','EXECUTAR','ANALISAR','ESPECIALIZAR','DECIDIR','CRIAR','COORDENAR','EXPLORAR','RELACIONAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":16,"INV_RECURSOS":6,"COORDENADOR":7,"FORMADOR":10,"MONITOR":24,"IMPLEMENTADOR":42,"TRAB_EQUIPE":11,"FINALIZADOR":26,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":21.6,"INV_RECURSOS":11.3,"COORDENADOR":12.5,"FORMADOR":24.4,"MONITOR":32.9,"IMPLEMENTADOR":58.3,"TRAB_EQUIPE":13.4,"FINALIZADOR":52,"ESPECIALISTA":34.5}'::jsonb,
    'IMPLEMENTADOR', 58.3, 'Alta',
    'FINALIZADOR', 52, 'Alta',
    'ESPECIALISTA', 34.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'ANTT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Isabela Klein', '100266', 'demo038@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-22T13:48:00Z'::timestamptz - interval '14 minutes', '2026-07-22T13:48:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":9,"I":18,"T":21,"F":2,"S":1,"N":3}'::jsonb, '{"E":33.3,"I":66.7,"T":77.8,"F":7.4,"S":3.7,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'N', 'S',
    'F', 'Ti', 'Ni', false, null,
    false, null,
    ARRAY['T','N','F','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":6,"AUT":22,"COO":5,"FLE":2,"EST":17}'::jsonb, '{"EXP":7.1,"EXE":17.1,"AUT":50,"COO":11.1,"FLE":9.1,"EST":40.5}'::jsonb, '{"CRIAR":15,"EXPLORAR":3,"ANALISAR":42,"DECIDIR":17,"ORGANIZAR":27,"EXECUTAR":12,"RELACIONAR":11,"COORDENAR":7,"FINALIZAR":14,"ESPECIALIZAR":17}'::jsonb, '{"CRIAR":23.8,"EXPLORAR":5.2,"ANALISAR":53.8,"DECIDIR":41.5,"ORGANIZAR":50.9,"EXECUTAR":21.8,"RELACIONAR":13.1,"COORDENAR":11.5,"FINALIZAR":29.8,"ESPECIALIZAR":34.7}'::jsonb,
    ARRAY['ANALISAR','ORGANIZAR','DECIDIR','ESPECIALIZAR','FINALIZAR','CRIAR','EXECUTAR','RELACIONAR','COORDENAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":16,"INV_RECURSOS":2,"COORDENADOR":8,"FORMADOR":16,"MONITOR":43,"IMPLEMENTADOR":32,"TRAB_EQUIPE":8,"FINALIZADOR":17,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":21.6,"INV_RECURSOS":3.8,"COORDENADOR":14.3,"FORMADOR":39,"MONITOR":58.9,"IMPLEMENTADOR":44.4,"TRAB_EQUIPE":9.8,"FINALIZADOR":34,"ESPECIALISTA":34.5}'::jsonb,
    'MONITOR', 58.9, 'Alta',
    'IMPLEMENTADOR', 44.4, 'Moderada',
    'FORMADOR', 39, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'ANTT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Henrique Henriques', '100273', 'demo039@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:49:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:49:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":13,"I":14,"T":18,"F":3,"S":4,"N":2}'::jsonb, '{"E":48.1,"I":51.9,"T":66.7,"F":11.1,"S":14.8,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":7,"AUT":21,"COO":9,"FLE":5,"EST":10}'::jsonb, '{"EXP":7.1,"EXE":20,"AUT":47.7,"COO":20,"FLE":22.7,"EST":23.8}'::jsonb, '{"CRIAR":13,"EXPLORAR":6,"ANALISAR":41,"DECIDIR":20,"ORGANIZAR":17,"EXECUTAR":15,"RELACIONAR":18,"COORDENAR":9,"FINALIZAR":14,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":20.6,"EXPLORAR":10.3,"ANALISAR":52.6,"DECIDIR":48.8,"ORGANIZAR":32.1,"EXECUTAR":27.3,"RELACIONAR":21.4,"COORDENAR":14.8,"FINALIZAR":29.8,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','ESPECIALIZAR','ORGANIZAR','FINALIZAR','EXECUTAR','RELACIONAR','CRIAR','COORDENAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":14,"INV_RECURSOS":7,"COORDENADOR":12,"FORMADOR":17,"MONITOR":40,"IMPLEMENTADOR":26,"TRAB_EQUIPE":14,"FINALIZADOR":12,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":18.9,"INV_RECURSOS":13.2,"COORDENADOR":21.4,"FORMADOR":41.5,"MONITOR":54.8,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":17.1,"FINALIZADOR":24,"ESPECIALISTA":34.5}'::jsonb,
    'MONITOR', 54.8, 'Alta',
    'FORMADOR', 41.5, 'Moderada',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'ANTT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Nuno Xavier', '100280', 'demo040@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-01T13:50:00Z'::timestamptz - interval '14 minutes', '2026-07-01T13:50:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":16,"I":11,"T":20,"F":2,"S":3,"N":2}'::jsonb, '{"E":59.3,"I":40.7,"T":74.1,"F":7.4,"S":11.1,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'N',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":8,"AUT":16,"COO":11,"FLE":4,"EST":14}'::jsonb, '{"EXP":3.6,"EXE":22.9,"AUT":36.4,"COO":24.4,"FLE":18.2,"EST":33.3}'::jsonb, '{"CRIAR":11,"EXPLORAR":5,"ANALISAR":44,"DECIDIR":16,"ORGANIZAR":21,"EXECUTAR":12,"RELACIONAR":19,"COORDENAR":16,"FINALIZAR":8,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":17.5,"EXPLORAR":8.6,"ANALISAR":56.4,"DECIDIR":39,"ORGANIZAR":39.6,"EXECUTAR":21.8,"RELACIONAR":22.6,"COORDENAR":26.2,"FINALIZAR":17,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['ANALISAR','ORGANIZAR','DECIDIR','ESPECIALIZAR','COORDENAR','RELACIONAR','EXECUTAR','CRIAR','FINALIZAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":6,"COORDENADOR":17,"FORMADOR":15,"MONITOR":44,"IMPLEMENTADOR":26,"TRAB_EQUIPE":16,"FINALIZADOR":8,"ESPECIALISTA":18}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":11.3,"COORDENADOR":30.4,"FORMADOR":36.6,"MONITOR":60.3,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":19.5,"FINALIZADOR":16,"ESPECIALISTA":31}'::jsonb,
    'MONITOR', 60.3, 'Muito alta',
    'FORMADOR', 36.6, 'Moderada',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'ANTT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Olívia Almeida', '100287', 'demo041@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-28T13:51:00Z'::timestamptz - interval '14 minutes', '2026-07-28T13:51:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":5,"F":0,"S":21,"N":1}'::jsonb, '{"E":77.8,"I":22.2,"T":18.5,"F":0,"S":77.8,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'F',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','N','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":22,"AUT":3,"COO":11,"FLE":5,"EST":11}'::jsonb, '{"EXP":7.1,"EXE":62.9,"AUT":6.8,"COO":24.4,"FLE":22.7,"EST":26.2}'::jsonb, '{"CRIAR":8,"EXPLORAR":12,"ANALISAR":35,"DECIDIR":15,"ORGANIZAR":13,"EXECUTAR":27,"RELACIONAR":18,"COORDENAR":11,"FINALIZAR":20,"ESPECIALIZAR":10}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":20.7,"ANALISAR":44.9,"DECIDIR":36.6,"ORGANIZAR":24.5,"EXECUTAR":49.1,"RELACIONAR":21.4,"COORDENAR":18,"FINALIZAR":42.6,"ESPECIALIZAR":20.4}'::jsonb,
    ARRAY['EXECUTAR','ANALISAR','FINALIZAR','DECIDIR','ORGANIZAR','RELACIONAR','EXPLORAR','ESPECIALIZAR','COORDENAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":14,"COORDENADOR":13,"FORMADOR":16,"MONITOR":27,"IMPLEMENTADOR":30,"TRAB_EQUIPE":13,"FINALIZADOR":22,"ESPECIALISTA":18}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":26.4,"COORDENADOR":23.2,"FORMADOR":39,"MONITOR":37,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":15.9,"FINALIZADOR":44,"ESPECIALISTA":31}'::jsonb,
    'FINALIZADOR', 44, 'Moderada',
    'IMPLEMENTADOR', 41.7, 'Moderada',
    'FORMADOR', 39, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'HUMAN POWER';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Carla Teixeira', '100294', 'demo042@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-09T13:52:00Z'::timestamptz - interval '14 minutes', '2026-07-09T13:52:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":14,"I":13,"T":1,"F":4,"S":1,"N":21}'::jsonb, '{"E":51.9,"I":48.1,"T":3.7,"F":14.8,"S":3.7,"N":77.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'F', 'S',
    'S', 'Ne', 'Fe', false, null,
    false, null,
    ARRAY['N','F','T','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":18,"EXE":8,"AUT":11,"COO":6,"FLE":6,"EST":5}'::jsonb, '{"EXP":64.3,"EXE":22.9,"AUT":25,"COO":13.3,"FLE":27.3,"EST":11.9}'::jsonb, '{"CRIAR":44,"EXPLORAR":32,"ANALISAR":16,"DECIDIR":16,"ORGANIZAR":8,"EXECUTAR":15,"RELACIONAR":12,"COORDENAR":7,"FINALIZAR":4,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":69.8,"EXPLORAR":55.2,"ANALISAR":20.5,"DECIDIR":39,"ORGANIZAR":15.1,"EXECUTAR":27.3,"RELACIONAR":14.3,"COORDENAR":11.5,"FINALIZAR":8.5,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','DECIDIR','EXECUTAR','ESPECIALIZAR','ANALISAR','ORGANIZAR','RELACIONAR','COORDENAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":46,"INV_RECURSOS":27,"COORDENADOR":7,"FORMADOR":13,"MONITOR":17,"IMPLEMENTADOR":21,"TRAB_EQUIPE":12,"FINALIZADOR":4,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":62.2,"INV_RECURSOS":50.9,"COORDENADOR":12.5,"FORMADOR":31.7,"MONITOR":23.3,"IMPLEMENTADOR":29.2,"TRAB_EQUIPE":14.6,"FINALIZADOR":8,"ESPECIALISTA":25.9}'::jsonb,
    'PLANTA', 62.2, 'Muito alta',
    'INV_RECURSOS', 50.9, 'Alta',
    'FORMADOR', 31.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'HUMAN POWER';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Mariana Jardim', '100301', 'demo043@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:53:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:53:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":4,"F":3,"S":4,"N":16}'::jsonb, '{"E":55.6,"I":44.4,"T":14.8,"F":11.1,"S":14.8,"N":59.3}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    false, null,
    ARRAY['N','T','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":13,"EXE":6,"AUT":10,"COO":11,"FLE":5,"EST":9}'::jsonb, '{"EXP":46.4,"EXE":17.1,"AUT":22.7,"COO":24.4,"FLE":22.7,"EST":21.4}'::jsonb, '{"CRIAR":29,"EXPLORAR":29,"ANALISAR":21,"DECIDIR":8,"ORGANIZAR":16,"EXECUTAR":11,"RELACIONAR":26,"COORDENAR":8,"FINALIZAR":8,"ESPECIALIZAR":9}'::jsonb, '{"CRIAR":46,"EXPLORAR":50,"ANALISAR":26.9,"DECIDIR":19.5,"ORGANIZAR":30.2,"EXECUTAR":20,"RELACIONAR":31,"COORDENAR":13.1,"FINALIZAR":17,"ESPECIALIZAR":18.4}'::jsonb,
    ARRAY['EXPLORAR','CRIAR','RELACIONAR','ORGANIZAR','ANALISAR','EXECUTAR','DECIDIR','ESPECIALIZAR','FINALIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":34,"INV_RECURSOS":25,"COORDENADOR":11,"FORMADOR":8,"MONITOR":21,"IMPLEMENTADOR":22,"TRAB_EQUIPE":21,"FINALIZADOR":10,"ESPECIALISTA":10}'::jsonb, '{"PLANTA":45.9,"INV_RECURSOS":47.2,"COORDENADOR":19.6,"FORMADOR":19.5,"MONITOR":28.8,"IMPLEMENTADOR":30.6,"TRAB_EQUIPE":25.6,"FINALIZADOR":20,"ESPECIALISTA":17.2}'::jsonb,
    'INV_RECURSOS', 47.2, 'Alta',
    'PLANTA', 45.9, 'Alta',
    'IMPLEMENTADOR', 30.6, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'HUMAN POWER';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('João Ribeiro', '100308', 'demo044@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-28T13:54:00Z'::timestamptz - interval '14 minutes', '2026-07-28T13:54:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":15,"F":0,"S":8,"N":4}'::jsonb, '{"E":55.6,"I":44.4,"T":55.6,"F":0,"S":29.6,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'F',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','S','N','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":6,"AUT":14,"COO":8,"FLE":5,"EST":16}'::jsonb, '{"EXP":17.9,"EXE":17.1,"AUT":31.8,"COO":17.8,"FLE":22.7,"EST":38.1}'::jsonb, '{"CRIAR":12,"EXPLORAR":11,"ANALISAR":33,"DECIDIR":12,"ORGANIZAR":24,"EXECUTAR":13,"RELACIONAR":17,"COORDENAR":9,"FINALIZAR":17,"ESPECIALIZAR":21}'::jsonb, '{"CRIAR":19,"EXPLORAR":19,"ANALISAR":42.3,"DECIDIR":29.3,"ORGANIZAR":45.3,"EXECUTAR":23.6,"RELACIONAR":20.2,"COORDENAR":14.8,"FINALIZAR":36.2,"ESPECIALIZAR":42.9}'::jsonb,
    ARRAY['ORGANIZAR','ESPECIALIZAR','ANALISAR','FINALIZAR','DECIDIR','EXECUTAR','RELACIONAR','CRIAR','EXPLORAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":14,"INV_RECURSOS":10,"COORDENADOR":11,"FORMADOR":13,"MONITOR":27,"IMPLEMENTADOR":27,"TRAB_EQUIPE":14,"FINALIZADOR":16,"ESPECIALISTA":30}'::jsonb, '{"PLANTA":18.9,"INV_RECURSOS":18.9,"COORDENADOR":19.6,"FORMADOR":31.7,"MONITOR":37,"IMPLEMENTADOR":37.5,"TRAB_EQUIPE":17.1,"FINALIZADOR":32,"ESPECIALISTA":51.7}'::jsonb,
    'ESPECIALISTA', 51.7, 'Alta',
    'IMPLEMENTADOR', 37.5, 'Moderada',
    'MONITOR', 37, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'HUMAN POWER';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Paulo Xavier', '100315', 'demo045@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-10T13:10:00Z'::timestamptz - interval '14 minutes', '2026-07-10T13:10:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":1,"F":1,"S":6,"N":19}'::jsonb, '{"E":77.8,"I":22.2,"T":3.7,"F":3.7,"S":22.2,"N":70.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    true, 'D3: ordem canônica fixa (critério arbitrário de último recurso).',
    ARRAY['N','S','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":17,"EXE":13,"AUT":3,"COO":4,"FLE":9,"EST":8}'::jsonb, '{"EXP":60.7,"EXE":37.1,"AUT":6.8,"COO":8.9,"FLE":40.9,"EST":19}'::jsonb, '{"CRIAR":34,"EXPLORAR":30,"ANALISAR":13,"DECIDIR":20,"ORGANIZAR":8,"EXECUTAR":26,"RELACIONAR":9,"COORDENAR":7,"FINALIZAR":12,"ESPECIALIZAR":7}'::jsonb, '{"CRIAR":54,"EXPLORAR":51.7,"ANALISAR":16.7,"DECIDIR":48.8,"ORGANIZAR":15.1,"EXECUTAR":47.3,"RELACIONAR":10.7,"COORDENAR":11.5,"FINALIZAR":25.5,"ESPECIALIZAR":14.3}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','DECIDIR','EXECUTAR','FINALIZAR','ANALISAR','ORGANIZAR','ESPECIALIZAR','COORDENAR','RELACIONAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":37,"INV_RECURSOS":28,"COORDENADOR":8,"FORMADOR":21,"MONITOR":9,"IMPLEMENTADOR":30,"TRAB_EQUIPE":7,"FINALIZADOR":13,"ESPECIALISTA":9}'::jsonb, '{"PLANTA":50,"INV_RECURSOS":52.8,"COORDENADOR":14.3,"FORMADOR":51.2,"MONITOR":12.3,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":8.5,"FINALIZADOR":26,"ESPECIALISTA":15.5}'::jsonb,
    'INV_RECURSOS', 52.8, 'Alta',
    'FORMADOR', 51.2, 'Alta',
    'PLANTA', 50, 'Alta', 'v2.0');

  select id into v_setor from setores where codigo = 'HUMAN POWER';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Nuno Teixeira', '100322', 'demo046@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-11T13:11:00Z'::timestamptz - interval '14 minutes', '2026-07-11T13:11:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":4,"F":2,"S":7,"N":14}'::jsonb, '{"E":70.4,"I":29.6,"T":14.8,"F":7.4,"S":25.9,"N":51.9}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    false, null,
    ARRAY['N','S','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":10,"EXE":11,"AUT":7,"COO":11,"FLE":9,"EST":6}'::jsonb, '{"EXP":35.7,"EXE":31.4,"AUT":15.9,"COO":24.4,"FLE":40.9,"EST":14.3}'::jsonb, '{"CRIAR":28,"EXPLORAR":28,"ANALISAR":17,"DECIDIR":16,"ORGANIZAR":8,"EXECUTAR":20,"RELACIONAR":22,"COORDENAR":12,"FINALIZAR":7,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":44.4,"EXPLORAR":48.3,"ANALISAR":21.8,"DECIDIR":39,"ORGANIZAR":15.1,"EXECUTAR":36.4,"RELACIONAR":26.2,"COORDENAR":19.7,"FINALIZAR":14.9,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['EXPLORAR','CRIAR','DECIDIR','EXECUTAR','RELACIONAR','ESPECIALIZAR','ANALISAR','COORDENAR','ORGANIZAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":32,"INV_RECURSOS":22,"COORDENADOR":15,"FORMADOR":17,"MONITOR":18,"IMPLEMENTADOR":23,"TRAB_EQUIPE":16,"FINALIZADOR":7,"ESPECIALISTA":12}'::jsonb, '{"PLANTA":43.2,"INV_RECURSOS":41.5,"COORDENADOR":26.8,"FORMADOR":41.5,"MONITOR":24.7,"IMPLEMENTADOR":31.9,"TRAB_EQUIPE":19.5,"FINALIZADOR":14,"ESPECIALISTA":20.7}'::jsonb,
    'PLANTA', 43.2, 'Moderada',
    'INV_RECURSOS', 41.5, 'Moderada',
    'FORMADOR', 41.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'HUMAN POWER';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Lucas Pereira', '100329', 'demo047@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-05T13:12:00Z'::timestamptz - interval '14 minutes', '2026-07-05T13:12:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":23,"I":4,"T":4,"F":20,"S":3,"N":0}'::jsonb, '{"E":85.2,"I":14.8,"T":14.8,"F":74.1,"S":11.1,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'S', 'N',
    'T', 'Fe', 'Se', false, null,
    false, null,
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":6,"AUT":3,"COO":30,"FLE":5,"EST":6}'::jsonb, '{"EXP":14.3,"EXE":17.1,"AUT":6.8,"COO":66.7,"FLE":22.7,"EST":14.3}'::jsonb, '{"CRIAR":5,"EXPLORAR":14,"ANALISAR":11,"DECIDIR":13,"ORGANIZAR":6,"EXECUTAR":12,"RELACIONAR":54,"COORDENAR":43,"FINALIZAR":6,"ESPECIALIZAR":4}'::jsonb, '{"CRIAR":7.9,"EXPLORAR":24.1,"ANALISAR":14.1,"DECIDIR":31.7,"ORGANIZAR":11.3,"EXECUTAR":21.8,"RELACIONAR":64.3,"COORDENAR":70.5,"FINALIZAR":12.8,"ESPECIALIZAR":8.2}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','DECIDIR','EXPLORAR','EXECUTAR','ANALISAR','FINALIZAR','ORGANIZAR','ESPECIALIZAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":7,"INV_RECURSOS":13,"COORDENADOR":38,"FORMADOR":11,"MONITOR":10,"IMPLEMENTADOR":17,"TRAB_EQUIPE":54,"FINALIZADOR":6,"ESPECIALISTA":6}'::jsonb, '{"PLANTA":9.5,"INV_RECURSOS":24.5,"COORDENADOR":67.9,"FORMADOR":26.8,"MONITOR":13.7,"IMPLEMENTADOR":23.6,"TRAB_EQUIPE":65.9,"FINALIZADOR":12,"ESPECIALISTA":10.3}'::jsonb,
    'COORDENADOR', 67.9, 'Muito alta',
    'TRAB_EQUIPE', 65.9, 'Muito alta',
    'FORMADOR', 26.8, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'TERRACAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Karina Esteves', '100336', 'demo048@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-06T13:13:00Z'::timestamptz - interval '14 minutes', '2026-07-06T13:13:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":14,"I":13,"T":7,"F":5,"S":11,"N":4}'::jsonb, '{"E":51.9,"I":48.1,"T":25.9,"F":18.5,"S":40.7,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":10,"AUT":14,"COO":10,"FLE":6,"EST":8}'::jsonb, '{"EXP":21.4,"EXE":28.6,"AUT":31.8,"COO":22.2,"FLE":27.3,"EST":19}'::jsonb, '{"CRIAR":18,"EXPLORAR":13,"ANALISAR":30,"DECIDIR":14,"ORGANIZAR":8,"EXECUTAR":16,"RELACIONAR":20,"COORDENAR":15,"FINALIZAR":15,"ESPECIALIZAR":17}'::jsonb, '{"CRIAR":28.6,"EXPLORAR":22.4,"ANALISAR":38.5,"DECIDIR":34.1,"ORGANIZAR":15.1,"EXECUTAR":29.1,"RELACIONAR":23.8,"COORDENAR":24.6,"FINALIZAR":31.9,"ESPECIALIZAR":34.7}'::jsonb,
    ARRAY['ANALISAR','ESPECIALIZAR','DECIDIR','FINALIZAR','EXECUTAR','CRIAR','COORDENAR','RELACIONAR','EXPLORAR','ORGANIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":19,"INV_RECURSOS":14,"COORDENADOR":14,"FORMADOR":13,"MONITOR":26,"IMPLEMENTADOR":17,"TRAB_EQUIPE":20,"FINALIZADOR":14,"ESPECIALISTA":25}'::jsonb, '{"PLANTA":25.7,"INV_RECURSOS":26.4,"COORDENADOR":25,"FORMADOR":31.7,"MONITOR":35.6,"IMPLEMENTADOR":23.6,"TRAB_EQUIPE":24.4,"FINALIZADOR":28,"ESPECIALISTA":43.1}'::jsonb,
    'ESPECIALISTA', 43.1, 'Moderada',
    'MONITOR', 35.6, 'Moderada',
    'FORMADOR', 31.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'TERRACAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Henrique Jardim', '100343', 'demo049@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-10T13:14:00Z'::timestamptz - interval '14 minutes', '2026-07-10T13:14:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":4,"F":2,"S":19,"N":2}'::jsonb, '{"E":77.8,"I":22.2,"T":14.8,"F":7.4,"S":70.4,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":22,"AUT":7,"COO":9,"FLE":5,"EST":6}'::jsonb, '{"EXP":17.9,"EXE":62.9,"AUT":15.9,"COO":20,"FLE":22.7,"EST":14.3}'::jsonb, '{"CRIAR":9,"EXPLORAR":12,"ANALISAR":33,"DECIDIR":14,"ORGANIZAR":10,"EXECUTAR":28,"RELACIONAR":23,"COORDENAR":8,"FINALIZAR":21,"ESPECIALIZAR":9}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":20.7,"ANALISAR":42.3,"DECIDIR":34.1,"ORGANIZAR":18.9,"EXECUTAR":50.9,"RELACIONAR":27.4,"COORDENAR":13.1,"FINALIZAR":44.7,"ESPECIALIZAR":18.4}'::jsonb,
    ARRAY['EXECUTAR','FINALIZAR','ANALISAR','DECIDIR','RELACIONAR','EXPLORAR','ORGANIZAR','ESPECIALIZAR','CRIAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":12,"COORDENADOR":11,"FORMADOR":15,"MONITOR":24,"IMPLEMENTADOR":31,"TRAB_EQUIPE":19,"FINALIZADOR":23,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":22.6,"COORDENADOR":19.6,"FORMADOR":36.6,"MONITOR":32.9,"IMPLEMENTADOR":43.1,"TRAB_EQUIPE":23.2,"FINALIZADOR":46,"ESPECIALISTA":25.9}'::jsonb,
    'FINALIZADOR', 46, 'Alta',
    'IMPLEMENTADOR', 43.1, 'Moderada',
    'FORMADOR', 36.6, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'TERRACAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Úrsula Henriques', '100350', 'demo050@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-23T13:15:00Z'::timestamptz - interval '14 minutes', '2026-07-23T13:15:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":18,"F":4,"S":4,"N":1}'::jsonb, '{"E":44.4,"I":55.6,"T":66.7,"F":14.8,"S":14.8,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":8,"AUT":21,"COO":9,"FLE":3,"EST":11}'::jsonb, '{"EXP":7.1,"EXE":22.9,"AUT":47.7,"COO":20,"FLE":13.6,"EST":26.2}'::jsonb, '{"CRIAR":8,"EXPLORAR":10,"ANALISAR":44,"DECIDIR":19,"ORGANIZAR":17,"EXECUTAR":15,"RELACIONAR":16,"COORDENAR":10,"FINALIZAR":10,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":17.2,"ANALISAR":56.4,"DECIDIR":46.3,"ORGANIZAR":32.1,"EXECUTAR":27.3,"RELACIONAR":19,"COORDENAR":16.4,"FINALIZAR":21.3,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','ESPECIALIZAR','ORGANIZAR','EXECUTAR','FINALIZAR','RELACIONAR','EXPLORAR','COORDENAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":11,"COORDENADOR":8,"FORMADOR":17,"MONITOR":44,"IMPLEMENTADOR":27,"TRAB_EQUIPE":15,"FINALIZADOR":10,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":20.8,"COORDENADOR":14.3,"FORMADOR":41.5,"MONITOR":60.3,"IMPLEMENTADOR":37.5,"TRAB_EQUIPE":18.3,"FINALIZADOR":20,"ESPECIALISTA":34.5}'::jsonb,
    'MONITOR', 60.3, 'Muito alta',
    'FORMADOR', 41.5, 'Moderada',
    'IMPLEMENTADOR', 37.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'TERRACAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Gabriela Xavier', '100357', 'demo051@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:16:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:16:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":2,"F":2,"S":16,"N":7}'::jsonb, '{"E":55.6,"I":44.4,"T":7.4,"F":7.4,"S":59.3,"N":25.9}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'F',
    'N', 'Se', 'Te', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":16,"AUT":3,"COO":9,"FLE":6,"EST":14}'::jsonb, '{"EXP":21.4,"EXE":45.7,"AUT":6.8,"COO":20,"FLE":27.3,"EST":33.3}'::jsonb, '{"CRIAR":12,"EXPLORAR":23,"ANALISAR":24,"DECIDIR":10,"ORGANIZAR":13,"EXECUTAR":18,"RELACIONAR":18,"COORDENAR":10,"FINALIZAR":26,"ESPECIALIZAR":15}'::jsonb, '{"CRIAR":19,"EXPLORAR":39.7,"ANALISAR":30.8,"DECIDIR":24.4,"ORGANIZAR":24.5,"EXECUTAR":32.7,"RELACIONAR":21.4,"COORDENAR":16.4,"FINALIZAR":55.3,"ESPECIALIZAR":30.6}'::jsonb,
    ARRAY['FINALIZAR','EXPLORAR','EXECUTAR','ANALISAR','ESPECIALIZAR','ORGANIZAR','DECIDIR','RELACIONAR','CRIAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":14,"INV_RECURSOS":23,"COORDENADOR":11,"FORMADOR":10,"MONITOR":17,"IMPLEMENTADOR":25,"TRAB_EQUIPE":14,"FINALIZADOR":28,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":18.9,"INV_RECURSOS":43.4,"COORDENADOR":19.6,"FORMADOR":24.4,"MONITOR":23.3,"IMPLEMENTADOR":34.7,"TRAB_EQUIPE":17.1,"FINALIZADOR":56,"ESPECIALISTA":34.5}'::jsonb,
    'FINALIZADOR', 56, 'Alta',
    'INV_RECURSOS', 43.4, 'Moderada',
    'IMPLEMENTADOR', 34.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'TERRACAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Sofia Uchôa', '100364', 'demo052@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-21T13:17:00Z'::timestamptz - interval '14 minutes', '2026-07-21T13:17:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":10,"I":17,"T":1,"F":5,"S":15,"N":6}'::jsonb, '{"E":37,"I":63,"T":3.7,"F":18.5,"S":55.6,"N":22.2}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'F', 'T',
    'N', 'Si', 'Fi', false, null,
    false, null,
    ARRAY['S','N','F','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":14,"AUT":9,"COO":7,"FLE":5,"EST":12}'::jsonb, '{"EXP":25,"EXE":40,"AUT":20.5,"COO":15.6,"FLE":22.7,"EST":28.6}'::jsonb, '{"CRIAR":14,"EXPLORAR":18,"ANALISAR":24,"DECIDIR":7,"ORGANIZAR":10,"EXECUTAR":20,"RELACIONAR":18,"COORDENAR":9,"FINALIZAR":26,"ESPECIALIZAR":22}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":31,"ANALISAR":30.8,"DECIDIR":17.1,"ORGANIZAR":18.9,"EXECUTAR":36.4,"RELACIONAR":21.4,"COORDENAR":14.8,"FINALIZAR":55.3,"ESPECIALIZAR":44.9}'::jsonb,
    ARRAY['FINALIZAR','ESPECIALIZAR','EXECUTAR','EXPLORAR','ANALISAR','CRIAR','RELACIONAR','ORGANIZAR','DECIDIR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":17,"INV_RECURSOS":19,"COORDENADOR":9,"FORMADOR":7,"MONITOR":17,"IMPLEMENTADOR":26,"TRAB_EQUIPE":15,"FINALIZADOR":25,"ESPECIALISTA":27}'::jsonb, '{"PLANTA":23,"INV_RECURSOS":35.8,"COORDENADOR":16.1,"FORMADOR":17.1,"MONITOR":23.3,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":18.3,"FINALIZADOR":50,"ESPECIALISTA":46.6}'::jsonb,
    'FINALIZADOR', 50, 'Alta',
    'ESPECIALISTA', 46.6, 'Alta',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'AGSUS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Mariana Pereira', '100371', 'demo053@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:18:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:18:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":24,"I":3,"T":1,"F":4,"S":19,"N":3}'::jsonb, '{"E":88.9,"I":11.1,"T":3.7,"F":14.8,"S":70.4,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'F', 'T',
    'N', 'Se', 'Fe', false, null,
    false, null,
    ARRAY['S','F','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":22,"AUT":3,"COO":19,"FLE":3,"EST":2}'::jsonb, '{"EXP":17.9,"EXE":62.9,"AUT":6.8,"COO":42.2,"FLE":13.6,"EST":4.8}'::jsonb, '{"CRIAR":11,"EXPLORAR":17,"ANALISAR":21,"DECIDIR":11,"ORGANIZAR":3,"EXECUTAR":28,"RELACIONAR":34,"COORDENAR":23,"FINALIZAR":10,"ESPECIALIZAR":9}'::jsonb, '{"CRIAR":17.5,"EXPLORAR":29.3,"ANALISAR":26.9,"DECIDIR":26.8,"ORGANIZAR":5.7,"EXECUTAR":50.9,"RELACIONAR":40.5,"COORDENAR":37.7,"FINALIZAR":21.3,"ESPECIALIZAR":18.4}'::jsonb,
    ARRAY['EXECUTAR','RELACIONAR','COORDENAR','EXPLORAR','ANALISAR','DECIDIR','FINALIZAR','ESPECIALIZAR','CRIAR','ORGANIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":16,"COORDENADOR":22,"FORMADOR":11,"MONITOR":18,"IMPLEMENTADOR":28,"TRAB_EQUIPE":33,"FINALIZADOR":11,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":30.2,"COORDENADOR":39.3,"FORMADOR":26.8,"MONITOR":24.7,"IMPLEMENTADOR":38.9,"TRAB_EQUIPE":40.2,"FINALIZADOR":22,"ESPECIALISTA":19}'::jsonb,
    'TRAB_EQUIPE', 40.2, 'Moderada',
    'COORDENADOR', 39.3, 'Moderada',
    'IMPLEMENTADOR', 38.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'AGSUS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Bruno Cardoso', '100378', 'demo054@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-23T13:19:00Z'::timestamptz - interval '14 minutes', '2026-07-23T13:19:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":2,"I":25,"T":3,"F":1,"S":22,"N":1}'::jsonb, '{"E":7.4,"I":92.6,"T":11.1,"F":3.7,"S":81.5,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'N',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":21,"AUT":16,"COO":2,"FLE":1,"EST":13}'::jsonb, '{"EXP":3.6,"EXE":60,"AUT":36.4,"COO":4.4,"FLE":4.5,"EST":31}'::jsonb, '{"CRIAR":5,"EXPLORAR":5,"ANALISAR":37,"DECIDIR":6,"ORGANIZAR":18,"EXECUTAR":31,"RELACIONAR":6,"COORDENAR":3,"FINALIZAR":27,"ESPECIALIZAR":31}'::jsonb, '{"CRIAR":7.9,"EXPLORAR":8.6,"ANALISAR":47.4,"DECIDIR":14.6,"ORGANIZAR":34,"EXECUTAR":56.4,"RELACIONAR":7.1,"COORDENAR":4.9,"FINALIZAR":57.4,"ESPECIALIZAR":63.3}'::jsonb,
    ARRAY['ESPECIALIZAR','FINALIZAR','EXECUTAR','ANALISAR','ORGANIZAR','DECIDIR','EXPLORAR','CRIAR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":7,"INV_RECURSOS":5,"COORDENADOR":3,"FORMADOR":4,"MONITOR":32,"IMPLEMENTADOR":41,"TRAB_EQUIPE":6,"FINALIZADOR":29,"ESPECIALISTA":35}'::jsonb, '{"PLANTA":9.5,"INV_RECURSOS":9.4,"COORDENADOR":5.4,"FORMADOR":9.8,"MONITOR":43.8,"IMPLEMENTADOR":56.9,"TRAB_EQUIPE":7.3,"FINALIZADOR":58,"ESPECIALISTA":60.3}'::jsonb,
    'ESPECIALISTA', 60.3, 'Muito alta',
    'FINALIZADOR', 58, 'Alta',
    'IMPLEMENTADOR', 56.9, 'Alta', 'v2.0');

  select id into v_setor from setores where codigo = 'AGSUS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('João Almeida', '100385', 'demo055@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-05T13:20:00Z'::timestamptz - interval '14 minutes', '2026-07-05T13:20:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":10,"I":17,"T":3,"F":2,"S":16,"N":6}'::jsonb, '{"E":37,"I":63,"T":11.1,"F":7.4,"S":59.3,"N":22.2}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":18,"AUT":10,"COO":5,"FLE":3,"EST":12}'::jsonb, '{"EXP":21.4,"EXE":51.4,"AUT":22.7,"COO":11.1,"FLE":13.6,"EST":28.6}'::jsonb, '{"CRIAR":14,"EXPLORAR":11,"ANALISAR":26,"DECIDIR":11,"ORGANIZAR":19,"EXECUTAR":27,"RELACIONAR":11,"COORDENAR":7,"FINALIZAR":21,"ESPECIALIZAR":21}'::jsonb, '{"CRIAR":22.2,"EXPLORAR":19,"ANALISAR":33.3,"DECIDIR":26.8,"ORGANIZAR":35.8,"EXECUTAR":49.1,"RELACIONAR":13.1,"COORDENAR":11.5,"FINALIZAR":44.7,"ESPECIALIZAR":42.9}'::jsonb,
    ARRAY['EXECUTAR','FINALIZAR','ESPECIALIZAR','ORGANIZAR','ANALISAR','DECIDIR','CRIAR','EXPLORAR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":18,"INV_RECURSOS":8,"COORDENADOR":7,"FORMADOR":10,"MONITOR":22,"IMPLEMENTADOR":42,"TRAB_EQUIPE":11,"FINALIZADOR":21,"ESPECIALISTA":23}'::jsonb, '{"PLANTA":24.3,"INV_RECURSOS":15.1,"COORDENADOR":12.5,"FORMADOR":24.4,"MONITOR":30.1,"IMPLEMENTADOR":58.3,"TRAB_EQUIPE":13.4,"FINALIZADOR":42,"ESPECIALISTA":39.7}'::jsonb,
    'IMPLEMENTADOR', 58.3, 'Alta',
    'FINALIZADOR', 42, 'Moderada',
    'ESPECIALISTA', 39.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'AGSUS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Diego Teixeira', '100392', 'demo056@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-05T13:21:00Z'::timestamptz - interval '14 minutes', '2026-07-05T13:21:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":4,"I":23,"T":4,"F":1,"S":19,"N":3}'::jsonb, '{"E":14.8,"I":85.2,"T":14.8,"F":3.7,"S":70.4,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','T','N','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":17,"AUT":21,"COO":3,"FLE":3,"EST":8}'::jsonb, '{"EXP":7.1,"EXE":48.6,"AUT":47.7,"COO":6.7,"FLE":13.6,"EST":19}'::jsonb, '{"CRIAR":19,"EXPLORAR":4,"ANALISAR":41,"DECIDIR":14,"ORGANIZAR":14,"EXECUTAR":17,"RELACIONAR":7,"COORDENAR":3,"FINALIZAR":18,"ESPECIALIZAR":30}'::jsonb, '{"CRIAR":30.2,"EXPLORAR":6.9,"ANALISAR":52.6,"DECIDIR":34.1,"ORGANIZAR":26.4,"EXECUTAR":30.9,"RELACIONAR":8.3,"COORDENAR":4.9,"FINALIZAR":38.3,"ESPECIALIZAR":61.2}'::jsonb,
    ARRAY['ESPECIALIZAR','ANALISAR','FINALIZAR','DECIDIR','EXECUTAR','CRIAR','ORGANIZAR','RELACIONAR','EXPLORAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":22,"INV_RECURSOS":3,"COORDENADOR":4,"FORMADOR":10,"MONITOR":34,"IMPLEMENTADOR":25,"TRAB_EQUIPE":6,"FINALIZADOR":19,"ESPECIALISTA":39}'::jsonb, '{"PLANTA":29.7,"INV_RECURSOS":5.7,"COORDENADOR":7.1,"FORMADOR":24.4,"MONITOR":46.6,"IMPLEMENTADOR":34.7,"TRAB_EQUIPE":7.3,"FINALIZADOR":38,"ESPECIALISTA":67.2}'::jsonb,
    'ESPECIALISTA', 67.2, 'Muito alta',
    'MONITOR', 46.6, 'Alta',
    'FINALIZADOR', 38, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'AGSUS';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Cardoso', '100399', 'demo057@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-12T13:22:00Z'::timestamptz - interval '14 minutes', '2026-07-12T13:22:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":1,"F":19,"S":3,"N":4}'::jsonb, '{"E":55.6,"I":44.4,"T":3.7,"F":70.4,"S":11.1,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'T',
    'T', 'Fe', 'Ne', false, null,
    false, null,
    ARRAY['F','N','S','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":6,"AUT":5,"COO":24,"FLE":4,"EST":8}'::jsonb, '{"EXP":25,"EXE":17.1,"AUT":11.4,"COO":53.3,"FLE":18.2,"EST":19}'::jsonb, '{"CRIAR":8,"EXPLORAR":13,"ANALISAR":11,"DECIDIR":13,"ORGANIZAR":8,"EXECUTAR":12,"RELACIONAR":38,"COORDENAR":37,"FINALIZAR":14,"ESPECIALIZAR":13}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":22.4,"ANALISAR":14.1,"DECIDIR":31.7,"ORGANIZAR":15.1,"EXECUTAR":21.8,"RELACIONAR":45.2,"COORDENAR":60.7,"FINALIZAR":29.8,"ESPECIALIZAR":26.5}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','DECIDIR','FINALIZAR','ESPECIALIZAR','EXPLORAR','EXECUTAR','ORGANIZAR','ANALISAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":14,"COORDENADOR":32,"FORMADOR":11,"MONITOR":8,"IMPLEMENTADOR":19,"TRAB_EQUIPE":40,"FINALIZADOR":12,"ESPECIALISTA":17}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":26.4,"COORDENADOR":57.1,"FORMADOR":26.8,"MONITOR":11,"IMPLEMENTADOR":26.4,"TRAB_EQUIPE":48.8,"FINALIZADOR":24,"ESPECIALISTA":29.3}'::jsonb,
    'COORDENADOR', 57.1, 'Alta',
    'TRAB_EQUIPE', 48.8, 'Alta',
    'ESPECIALISTA', 29.3, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'MONITORIA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Vinícius Pereira', '100406', 'demo058@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-07T13:23:00Z'::timestamptz - interval '14 minutes', '2026-07-07T13:23:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":3,"I":24,"T":1,"F":0,"S":25,"N":1}'::jsonb, '{"E":11.1,"I":88.9,"T":3.7,"F":0,"S":92.6,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','T','N','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":22,"AUT":16,"COO":2,"FLE":1,"EST":12}'::jsonb, '{"EXP":3.6,"EXE":62.9,"AUT":36.4,"COO":4.4,"FLE":4.5,"EST":28.6}'::jsonb, '{"CRIAR":15,"EXPLORAR":5,"ANALISAR":44,"DECIDIR":4,"ORGANIZAR":18,"EXECUTAR":21,"RELACIONAR":5,"COORDENAR":0,"FINALIZAR":26,"ESPECIALIZAR":30}'::jsonb, '{"CRIAR":23.8,"EXPLORAR":8.6,"ANALISAR":56.4,"DECIDIR":9.8,"ORGANIZAR":34,"EXECUTAR":38.2,"RELACIONAR":6,"COORDENAR":0,"FINALIZAR":55.3,"ESPECIALIZAR":61.2}'::jsonb,
    ARRAY['ESPECIALIZAR','ANALISAR','FINALIZAR','EXECUTAR','ORGANIZAR','CRIAR','DECIDIR','EXPLORAR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":21,"INV_RECURSOS":4,"COORDENADOR":2,"FORMADOR":2,"MONITOR":32,"IMPLEMENTADOR":32,"TRAB_EQUIPE":3,"FINALIZADOR":29,"ESPECIALISTA":37}'::jsonb, '{"PLANTA":28.4,"INV_RECURSOS":7.5,"COORDENADOR":3.6,"FORMADOR":4.9,"MONITOR":43.8,"IMPLEMENTADOR":44.4,"TRAB_EQUIPE":3.7,"FINALIZADOR":58,"ESPECIALISTA":63.8}'::jsonb,
    'ESPECIALISTA', 63.8, 'Muito alta',
    'FINALIZADOR', 58, 'Alta',
    'IMPLEMENTADOR', 44.4, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MONITORIA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Henrique Ribeiro', '100413', 'demo059@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-04T13:24:00Z'::timestamptz - interval '14 minutes', '2026-07-04T13:24:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":6,"I":21,"T":15,"F":4,"S":5,"N":3}'::jsonb, '{"E":22.2,"I":77.8,"T":55.6,"F":14.8,"S":18.5,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":6,"AUT":19,"COO":6,"FLE":3,"EST":17}'::jsonb, '{"EXP":10.7,"EXE":17.1,"AUT":43.2,"COO":13.3,"FLE":13.6,"EST":40.5}'::jsonb, '{"CRIAR":16,"EXPLORAR":5,"ANALISAR":40,"DECIDIR":13,"ORGANIZAR":29,"EXECUTAR":10,"RELACIONAR":15,"COORDENAR":9,"FINALIZAR":14,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":25.4,"EXPLORAR":8.6,"ANALISAR":51.3,"DECIDIR":31.7,"ORGANIZAR":54.7,"EXECUTAR":18.2,"RELACIONAR":17.9,"COORDENAR":14.8,"FINALIZAR":29.8,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['ORGANIZAR','ANALISAR','ESPECIALIZAR','DECIDIR','FINALIZAR','CRIAR','EXECUTAR','RELACIONAR','COORDENAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":18,"INV_RECURSOS":5,"COORDENADOR":7,"FORMADOR":11,"MONITOR":39,"IMPLEMENTADOR":30,"TRAB_EQUIPE":16,"FINALIZADOR":16,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":24.3,"INV_RECURSOS":9.4,"COORDENADOR":12.5,"FORMADOR":26.8,"MONITOR":53.4,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":19.5,"FINALIZADOR":32,"ESPECIALISTA":34.5}'::jsonb,
    'MONITOR', 53.4, 'Alta',
    'IMPLEMENTADOR', 41.7, 'Moderada',
    'ESPECIALISTA', 34.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MONITORIA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Karina Barbosa', '100420', 'demo060@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-05T13:25:00Z'::timestamptz - interval '14 minutes', '2026-07-05T13:25:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":9,"I":18,"T":22,"F":1,"S":3,"N":1}'::jsonb, '{"E":33.3,"I":66.7,"T":81.5,"F":3.7,"S":11.1,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":5,"AUT":27,"COO":5,"FLE":1,"EST":13}'::jsonb, '{"EXP":10.7,"EXE":14.3,"AUT":61.4,"COO":11.1,"FLE":4.5,"EST":31}'::jsonb, '{"CRIAR":11,"EXPLORAR":7,"ANALISAR":50,"DECIDIR":16,"ORGANIZAR":27,"EXECUTAR":10,"RELACIONAR":11,"COORDENAR":8,"FINALIZAR":7,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":17.5,"EXPLORAR":12.1,"ANALISAR":64.1,"DECIDIR":39,"ORGANIZAR":50.9,"EXECUTAR":18.2,"RELACIONAR":13.1,"COORDENAR":13.1,"FINALIZAR":14.9,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['ANALISAR','ORGANIZAR','DECIDIR','ESPECIALIZAR','EXECUTAR','CRIAR','FINALIZAR','RELACIONAR','COORDENAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":13,"INV_RECURSOS":6,"COORDENADOR":9,"FORMADOR":16,"MONITOR":50,"IMPLEMENTADOR":26,"TRAB_EQUIPE":10,"FINALIZADOR":9,"ESPECIALISTA":23}'::jsonb, '{"PLANTA":17.6,"INV_RECURSOS":11.3,"COORDENADOR":16.1,"FORMADOR":39,"MONITOR":68.5,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":12.2,"FINALIZADOR":18,"ESPECIALISTA":39.7}'::jsonb,
    'MONITOR', 68.5, 'Muito alta',
    'ESPECIALISTA', 39.7, 'Moderada',
    'FORMADOR', 39, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'MONITORIA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Carla Xavier', '100427', 'demo061@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-16T13:26:00Z'::timestamptz - interval '14 minutes', '2026-07-16T13:26:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":3,"I":24,"T":21,"F":2,"S":1,"N":3}'::jsonb, '{"E":11.1,"I":88.9,"T":77.8,"F":7.4,"S":3.7,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'N', 'S',
    'F', 'Ti', 'Ni', false, null,
    false, null,
    ARRAY['T','N','F','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":2,"AUT":25,"COO":3,"FLE":2,"EST":19}'::jsonb, '{"EXP":10.7,"EXE":5.7,"AUT":56.8,"COO":6.7,"FLE":9.1,"EST":45.2}'::jsonb, '{"CRIAR":18,"EXPLORAR":6,"ANALISAR":50,"DECIDIR":16,"ORGANIZAR":27,"EXECUTAR":5,"RELACIONAR":6,"COORDENAR":5,"FINALIZAR":14,"ESPECIALIZAR":19}'::jsonb, '{"CRIAR":28.6,"EXPLORAR":10.3,"ANALISAR":64.1,"DECIDIR":39,"ORGANIZAR":50.9,"EXECUTAR":9.1,"RELACIONAR":7.1,"COORDENAR":8.2,"FINALIZAR":29.8,"ESPECIALIZAR":38.8}'::jsonb,
    ARRAY['ANALISAR','ORGANIZAR','DECIDIR','ESPECIALIZAR','FINALIZAR','CRIAR','EXPLORAR','EXECUTAR','COORDENAR','RELACIONAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":21,"INV_RECURSOS":4,"COORDENADOR":5,"FORMADOR":14,"MONITOR":48,"IMPLEMENTADOR":26,"TRAB_EQUIPE":6,"FINALIZADOR":16,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":28.4,"INV_RECURSOS":7.5,"COORDENADOR":8.9,"FORMADOR":34.1,"MONITOR":65.8,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":7.3,"FINALIZADOR":32,"ESPECIALISTA":37.9}'::jsonb,
    'MONITOR', 65.8, 'Muito alta',
    'ESPECIALISTA', 37.9, 'Moderada',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'FINANCEIRO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Cecília Ferreira', '100434', 'demo062@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-24T13:27:00Z'::timestamptz - interval '14 minutes', '2026-07-24T13:27:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":2,"F":3,"S":19,"N":3}'::jsonb, '{"E":55.6,"I":44.4,"T":7.4,"F":11.1,"S":70.4,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'F', 'T',
    'N', 'Se', 'Fe', false, null,
    false, null,
    ARRAY['S','F','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":20,"AUT":9,"COO":6,"FLE":4,"EST":8}'::jsonb, '{"EXP":25,"EXE":57.1,"AUT":20.5,"COO":13.3,"FLE":18.2,"EST":19}'::jsonb, '{"CRIAR":12,"EXPLORAR":14,"ANALISAR":33,"DECIDIR":13,"ORGANIZAR":13,"EXECUTAR":23,"RELACIONAR":12,"COORDENAR":12,"FINALIZAR":20,"ESPECIALIZAR":15}'::jsonb, '{"CRIAR":19,"EXPLORAR":24.1,"ANALISAR":42.3,"DECIDIR":31.7,"ORGANIZAR":24.5,"EXECUTAR":41.8,"RELACIONAR":14.3,"COORDENAR":19.7,"FINALIZAR":42.6,"ESPECIALIZAR":30.6}'::jsonb,
    ARRAY['FINALIZAR','ANALISAR','EXECUTAR','DECIDIR','ESPECIALIZAR','ORGANIZAR','EXPLORAR','COORDENAR','CRIAR','RELACIONAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":17,"INV_RECURSOS":14,"COORDENADOR":11,"FORMADOR":11,"MONITOR":23,"IMPLEMENTADOR":32,"TRAB_EQUIPE":11,"FINALIZADOR":21,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":23,"INV_RECURSOS":26.4,"COORDENADOR":19.6,"FORMADOR":26.8,"MONITOR":31.5,"IMPLEMENTADOR":44.4,"TRAB_EQUIPE":13.4,"FINALIZADOR":42,"ESPECIALISTA":37.9}'::jsonb,
    'IMPLEMENTADOR', 44.4, 'Moderada',
    'FINALIZADOR', 42, 'Moderada',
    'ESPECIALISTA', 37.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'FINANCEIRO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('João Vieira', '100441', 'demo063@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:28:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:28:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":22,"F":4,"S":0,"N":1}'::jsonb, '{"E":44.4,"I":55.6,"T":81.5,"F":14.8,"S":0,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'N', 'S',
    'F', 'Ti', 'Ni', false, null,
    false, null,
    ARRAY['T','F','N','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":1,"AUT":21,"COO":5,"FLE":6,"EST":15}'::jsonb, '{"EXP":21.4,"EXE":2.9,"AUT":47.7,"COO":11.1,"FLE":27.3,"EST":35.7}'::jsonb, '{"CRIAR":6,"EXPLORAR":10,"ANALISAR":45,"DECIDIR":16,"ORGANIZAR":20,"EXECUTAR":15,"RELACIONAR":17,"COORDENAR":11,"FINALIZAR":15,"ESPECIALIZAR":12}'::jsonb, '{"CRIAR":9.5,"EXPLORAR":17.2,"ANALISAR":57.7,"DECIDIR":39,"ORGANIZAR":37.7,"EXECUTAR":27.3,"RELACIONAR":20.2,"COORDENAR":18,"FINALIZAR":31.9,"ESPECIALIZAR":24.5}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','ORGANIZAR','FINALIZAR','EXECUTAR','ESPECIALIZAR','RELACIONAR','COORDENAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":7,"INV_RECURSOS":10,"COORDENADOR":10,"FORMADOR":17,"MONITOR":45,"IMPLEMENTADOR":29,"TRAB_EQUIPE":17,"FINALIZADOR":14,"ESPECIALISTA":13}'::jsonb, '{"PLANTA":9.5,"INV_RECURSOS":18.9,"COORDENADOR":17.9,"FORMADOR":41.5,"MONITOR":61.6,"IMPLEMENTADOR":40.3,"TRAB_EQUIPE":20.7,"FINALIZADOR":28,"ESPECIALISTA":22.4}'::jsonb,
    'MONITOR', 61.6, 'Muito alta',
    'FORMADOR', 41.5, 'Moderada',
    'IMPLEMENTADOR', 40.3, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'FINANCEIRO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Bernardo Klein', '100448', 'demo064@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-10T13:29:00Z'::timestamptz - interval '14 minutes', '2026-07-10T13:29:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":22,"I":5,"T":23,"F":1,"S":3,"N":0}'::jsonb, '{"E":81.5,"I":18.5,"T":85.2,"F":3.7,"S":11.1,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'N',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":7,"AUT":15,"COO":12,"FLE":6,"EST":12}'::jsonb, '{"EXP":7.1,"EXE":20,"AUT":34.1,"COO":26.7,"FLE":27.3,"EST":28.6}'::jsonb, '{"CRIAR":8,"EXPLORAR":9,"ANALISAR":37,"DECIDIR":24,"ORGANIZAR":18,"EXECUTAR":13,"RELACIONAR":21,"COORDENAR":16,"FINALIZAR":11,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":15.5,"ANALISAR":47.4,"DECIDIR":58.5,"ORGANIZAR":34,"EXECUTAR":23.6,"RELACIONAR":25,"COORDENAR":26.2,"FINALIZAR":23.4,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','ORGANIZAR','COORDENAR','RELACIONAR','EXECUTAR','FINALIZAR','ESPECIALIZAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":8,"COORDENADOR":18,"FORMADOR":24,"MONITOR":38,"IMPLEMENTADOR":23,"TRAB_EQUIPE":18,"FINALIZADOR":11,"ESPECIALISTA":12}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":15.1,"COORDENADOR":32.1,"FORMADOR":58.5,"MONITOR":52.1,"IMPLEMENTADOR":31.9,"TRAB_EQUIPE":22,"FINALIZADOR":22,"ESPECIALISTA":20.7}'::jsonb,
    'FORMADOR', 58.5, 'Alta',
    'MONITOR', 52.1, 'Alta',
    'COORDENADOR', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'FINANCEIRO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Carla Ribeiro', '100455', 'demo065@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:30:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:30:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":14,"I":13,"T":2,"F":4,"S":19,"N":2}'::jsonb, '{"E":51.9,"I":48.1,"T":7.4,"F":14.8,"S":70.4,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'F', 'N',
    'N', 'Se', 'Fe', false, null,
    false, null,
    ARRAY['S','F','T','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":18,"AUT":7,"COO":9,"FLE":7,"EST":11}'::jsonb, '{"EXP":7.1,"EXE":51.4,"AUT":15.9,"COO":20,"FLE":31.8,"EST":26.2}'::jsonb, '{"CRIAR":9,"EXPLORAR":10,"ANALISAR":28,"DECIDIR":16,"ORGANIZAR":11,"EXECUTAR":22,"RELACIONAR":19,"COORDENAR":11,"FINALIZAR":30,"ESPECIALIZAR":14}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":17.2,"ANALISAR":35.9,"DECIDIR":39,"ORGANIZAR":20.8,"EXECUTAR":40,"RELACIONAR":22.6,"COORDENAR":18,"FINALIZAR":63.8,"ESPECIALIZAR":28.6}'::jsonb,
    ARRAY['FINALIZAR','EXECUTAR','DECIDIR','ANALISAR','ESPECIALIZAR','RELACIONAR','ORGANIZAR','COORDENAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":10,"COORDENADOR":11,"FORMADOR":15,"MONITOR":21,"IMPLEMENTADOR":30,"TRAB_EQUIPE":18,"FINALIZADOR":30,"ESPECIALISTA":18}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":18.9,"COORDENADOR":19.6,"FORMADOR":36.6,"MONITOR":28.8,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":22,"FINALIZADOR":60,"ESPECIALISTA":31}'::jsonb,
    'FINALIZADOR', 60, 'Muito alta',
    'IMPLEMENTADOR', 41.7, 'Moderada',
    'FORMADOR', 36.6, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'FINANCEIRO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Ribeiro', '100462', 'demo066@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-06T13:31:00Z'::timestamptz - interval '14 minutes', '2026-07-06T13:31:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":16,"I":11,"T":8,"F":4,"S":14,"N":1}'::jsonb, '{"E":59.3,"I":40.7,"T":29.6,"F":14.8,"S":51.9,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":18,"AUT":9,"COO":6,"FLE":6,"EST":11}'::jsonb, '{"EXP":14.3,"EXE":51.4,"AUT":20.5,"COO":13.3,"FLE":27.3,"EST":26.2}'::jsonb, '{"CRIAR":9,"EXPLORAR":14,"ANALISAR":28,"DECIDIR":17,"ORGANIZAR":14,"EXECUTAR":27,"RELACIONAR":13,"COORDENAR":9,"FINALIZAR":19,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":24.1,"ANALISAR":35.9,"DECIDIR":41.5,"ORGANIZAR":26.4,"EXECUTAR":49.1,"RELACIONAR":15.5,"COORDENAR":14.8,"FINALIZAR":40.4,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['EXECUTAR','DECIDIR','FINALIZAR','ANALISAR','ESPECIALIZAR','ORGANIZAR','EXPLORAR','RELACIONAR','COORDENAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":15,"COORDENADOR":9,"FORMADOR":17,"MONITOR":25,"IMPLEMENTADOR":32,"TRAB_EQUIPE":11,"FINALIZADOR":21,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":28.3,"COORDENADOR":16.1,"FORMADOR":41.5,"MONITOR":34.2,"IMPLEMENTADOR":44.4,"TRAB_EQUIPE":13.4,"FINALIZADOR":42,"ESPECIALISTA":37.9}'::jsonb,
    'IMPLEMENTADOR', 44.4, 'Moderada',
    'FINALIZADOR', 42, 'Moderada',
    'FORMADOR', 41.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'FINANCEIRO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Nuno Nogueira', '100469', 'demo067@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-04T13:32:00Z'::timestamptz - interval '14 minutes', '2026-07-04T13:32:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":23,"I":4,"T":16,"F":6,"S":4,"N":1}'::jsonb, '{"E":85.2,"I":14.8,"T":59.3,"F":22.2,"S":14.8,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'N',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','F','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":0,"EXE":9,"AUT":7,"COO":16,"FLE":9,"EST":13}'::jsonb, '{"EXP":0,"EXE":25.7,"AUT":15.9,"COO":35.6,"FLE":40.9,"EST":31}'::jsonb, '{"CRIAR":9,"EXPLORAR":8,"ANALISAR":35,"DECIDIR":20,"ORGANIZAR":11,"EXECUTAR":16,"RELACIONAR":30,"COORDENAR":22,"FINALIZAR":6,"ESPECIALIZAR":10}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":13.8,"ANALISAR":44.9,"DECIDIR":48.8,"ORGANIZAR":20.8,"EXECUTAR":29.1,"RELACIONAR":35.7,"COORDENAR":36.1,"FINALIZAR":12.8,"ESPECIALIZAR":20.4}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','COORDENAR','RELACIONAR','EXECUTAR','ORGANIZAR','ESPECIALIZAR','CRIAR','EXPLORAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":10,"COORDENADOR":23,"FORMADOR":21,"MONITOR":33,"IMPLEMENTADOR":20,"TRAB_EQUIPE":25,"FINALIZADOR":6,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":18.9,"COORDENADOR":41.1,"FORMADOR":51.2,"MONITOR":45.2,"IMPLEMENTADOR":27.8,"TRAB_EQUIPE":30.5,"FINALIZADOR":12,"ESPECIALISTA":25.9}'::jsonb,
    'FORMADOR', 51.2, 'Alta',
    'MONITOR', 45.2, 'Alta',
    'COORDENADOR', 41.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DH';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Úrsula Klein', '100476', 'demo068@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:33:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:33:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":5,"F":17,"S":4,"N":1}'::jsonb, '{"E":55.6,"I":44.4,"T":18.5,"F":63,"S":14.8,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'S', 'N',
    'T', 'Fe', 'Se', false, null,
    false, null,
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":9,"AUT":7,"COO":21,"FLE":4,"EST":10}'::jsonb, '{"EXP":10.7,"EXE":25.7,"AUT":15.9,"COO":46.7,"FLE":18.2,"EST":23.8}'::jsonb, '{"CRIAR":6,"EXPLORAR":11,"ANALISAR":18,"DECIDIR":12,"ORGANIZAR":11,"EXECUTAR":17,"RELACIONAR":38,"COORDENAR":30,"FINALIZAR":10,"ESPECIALIZAR":15}'::jsonb, '{"CRIAR":9.5,"EXPLORAR":19,"ANALISAR":23.1,"DECIDIR":29.3,"ORGANIZAR":20.8,"EXECUTAR":30.9,"RELACIONAR":45.2,"COORDENAR":49.2,"FINALIZAR":21.3,"ESPECIALIZAR":30.6}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','EXECUTAR','ESPECIALIZAR','DECIDIR','ANALISAR','FINALIZAR','ORGANIZAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":8,"INV_RECURSOS":10,"COORDENADOR":23,"FORMADOR":12,"MONITOR":18,"IMPLEMENTADOR":25,"TRAB_EQUIPE":42,"FINALIZADOR":9,"ESPECIALISTA":15}'::jsonb, '{"PLANTA":10.8,"INV_RECURSOS":18.9,"COORDENADOR":41.1,"FORMADOR":29.3,"MONITOR":24.7,"IMPLEMENTADOR":34.7,"TRAB_EQUIPE":51.2,"FINALIZADOR":18,"ESPECIALISTA":25.9}'::jsonb,
    'TRAB_EQUIPE', 51.2, 'Alta',
    'COORDENADOR', 41.1, 'Moderada',
    'IMPLEMENTADOR', 34.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DH';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('João Pereira', '100483', 'demo069@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-26T13:34:00Z'::timestamptz - interval '14 minutes', '2026-07-26T13:34:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":2,"F":22,"S":1,"N":2}'::jsonb, '{"E":70.4,"I":29.6,"T":7.4,"F":81.5,"S":3.7,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'S',
    'T', 'Fe', 'Ne', false, null,
    false, null,
    ARRAY['F','T','N','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":7,"AUT":5,"COO":24,"FLE":9,"EST":6}'::jsonb, '{"EXP":10.7,"EXE":20,"AUT":11.4,"COO":53.3,"FLE":40.9,"EST":14.3}'::jsonb, '{"CRIAR":10,"EXPLORAR":12,"ANALISAR":7,"DECIDIR":16,"ORGANIZAR":10,"EXECUTAR":21,"RELACIONAR":45,"COORDENAR":36,"FINALIZAR":6,"ESPECIALIZAR":5}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":20.7,"ANALISAR":9,"DECIDIR":39,"ORGANIZAR":18.9,"EXECUTAR":38.2,"RELACIONAR":53.6,"COORDENAR":59,"FINALIZAR":12.8,"ESPECIALIZAR":10.2}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','DECIDIR','EXECUTAR','EXPLORAR','ORGANIZAR','CRIAR','FINALIZAR','ESPECIALIZAR','ANALISAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":12,"COORDENADOR":29,"FORMADOR":19,"MONITOR":7,"IMPLEMENTADOR":26,"TRAB_EQUIPE":48,"FINALIZADOR":6,"ESPECIALISTA":6}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":22.6,"COORDENADOR":51.8,"FORMADOR":46.3,"MONITOR":9.6,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":58.5,"FINALIZADOR":12,"ESPECIALISTA":10.3}'::jsonb,
    'TRAB_EQUIPE', 58.5, 'Alta',
    'COORDENADOR', 51.8, 'Alta',
    'FORMADOR', 46.3, 'Alta', 'v2.0');

  select id into v_setor from setores where codigo = 'DH';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Karina Duarte', '100490', 'demo070@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-08T13:35:00Z'::timestamptz - interval '14 minutes', '2026-07-08T13:35:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":16,"I":11,"T":1,"F":6,"S":6,"N":14}'::jsonb, '{"E":59.3,"I":40.7,"T":3.7,"F":22.2,"S":22.2,"N":51.9}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'F', 'T',
    'S', 'Ne', 'Fe', false, null,
    false, null,
    ARRAY['N','S','F','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":11,"EXE":12,"AUT":5,"COO":9,"FLE":10,"EST":7}'::jsonb, '{"EXP":39.3,"EXE":34.3,"AUT":11.4,"COO":20,"FLE":45.5,"EST":16.7}'::jsonb, '{"CRIAR":24,"EXPLORAR":24,"ANALISAR":21,"DECIDIR":18,"ORGANIZAR":7,"EXECUTAR":17,"RELACIONAR":21,"COORDENAR":14,"FINALIZAR":12,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":38.1,"EXPLORAR":41.4,"ANALISAR":26.9,"DECIDIR":43.9,"ORGANIZAR":13.2,"EXECUTAR":30.9,"RELACIONAR":25,"COORDENAR":23,"FINALIZAR":25.5,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['DECIDIR','EXPLORAR','CRIAR','EXECUTAR','ANALISAR','FINALIZAR','RELACIONAR','COORDENAR','ESPECIALIZAR','ORGANIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":28,"INV_RECURSOS":19,"COORDENADOR":13,"FORMADOR":17,"MONITOR":20,"IMPLEMENTADOR":20,"TRAB_EQUIPE":20,"FINALIZADOR":12,"ESPECIALISTA":13}'::jsonb, '{"PLANTA":37.8,"INV_RECURSOS":35.8,"COORDENADOR":23.2,"FORMADOR":41.5,"MONITOR":27.4,"IMPLEMENTADOR":27.8,"TRAB_EQUIPE":24.4,"FINALIZADOR":24,"ESPECIALISTA":22.4}'::jsonb,
    'FORMADOR', 41.5, 'Moderada',
    'PLANTA', 37.8, 'Moderada',
    'INV_RECURSOS', 35.8, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DH';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Duarte', '100497', 'demo071@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:36:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:36:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":15,"I":12,"T":3,"F":18,"S":4,"N":2}'::jsonb, '{"E":55.6,"I":44.4,"T":11.1,"F":66.7,"S":14.8,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'S', 'N',
    'T', 'Fe', 'Se', false, null,
    false, null,
    ARRAY['F','S','T','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":5,"EXE":9,"AUT":8,"COO":20,"FLE":3,"EST":9}'::jsonb, '{"EXP":17.9,"EXE":25.7,"AUT":18.2,"COO":44.4,"FLE":13.6,"EST":21.4}'::jsonb, '{"CRIAR":9,"EXPLORAR":9,"ANALISAR":23,"DECIDIR":9,"ORGANIZAR":13,"EXECUTAR":22,"RELACIONAR":38,"COORDENAR":32,"FINALIZAR":5,"ESPECIALIZAR":8}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":15.5,"ANALISAR":29.5,"DECIDIR":22,"ORGANIZAR":24.5,"EXECUTAR":40,"RELACIONAR":45.2,"COORDENAR":52.5,"FINALIZAR":10.6,"ESPECIALIZAR":16.3}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','EXECUTAR','ANALISAR','ORGANIZAR','DECIDIR','ESPECIALIZAR','EXPLORAR','CRIAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":10,"COORDENADOR":27,"FORMADOR":9,"MONITOR":21,"IMPLEMENTADOR":27,"TRAB_EQUIPE":41,"FINALIZADOR":6,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":18.9,"COORDENADOR":48.2,"FORMADOR":22,"MONITOR":28.8,"IMPLEMENTADOR":37.5,"TRAB_EQUIPE":50,"FINALIZADOR":12,"ESPECIALISTA":19}'::jsonb,
    'TRAB_EQUIPE', 50, 'Alta',
    'COORDENADOR', 48.2, 'Alta',
    'IMPLEMENTADOR', 37.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DH';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Fábio Henriques', '100504', 'demo072@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-26T13:37:00Z'::timestamptz - interval '14 minutes', '2026-07-26T13:37:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":19,"I":8,"T":4,"F":21,"S":1,"N":1}'::jsonb, '{"E":70.4,"I":29.6,"T":14.8,"F":77.8,"S":3.7,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'N',
    'T', 'Fe', 'Ne', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":5,"AUT":6,"COO":26,"FLE":3,"EST":7}'::jsonb, '{"EXP":25,"EXE":14.3,"AUT":13.6,"COO":57.8,"FLE":13.6,"EST":16.7}'::jsonb, '{"CRIAR":7,"EXPLORAR":11,"ANALISAR":16,"DECIDIR":9,"ORGANIZAR":12,"EXECUTAR":11,"RELACIONAR":46,"COORDENAR":40,"FINALIZAR":3,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":11.1,"EXPLORAR":19,"ANALISAR":20.5,"DECIDIR":22,"ORGANIZAR":22.6,"EXECUTAR":20,"RELACIONAR":54.8,"COORDENAR":65.6,"FINALIZAR":6.4,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','ORGANIZAR','ESPECIALIZAR','DECIDIR','ANALISAR','EXECUTAR','EXPLORAR','CRIAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":12,"COORDENADOR":34,"FORMADOR":8,"MONITOR":14,"IMPLEMENTADOR":19,"TRAB_EQUIPE":50,"FINALIZADOR":3,"ESPECIALISTA":13}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":22.6,"COORDENADOR":60.7,"FORMADOR":19.5,"MONITOR":19.2,"IMPLEMENTADOR":26.4,"TRAB_EQUIPE":61,"FINALIZADOR":6,"ESPECIALISTA":22.4}'::jsonb,
    'TRAB_EQUIPE', 61, 'Muito alta',
    'COORDENADOR', 60.7, 'Muito alta',
    'IMPLEMENTADOR', 26.4, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'JURÍDICO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Diego Martins', '100511', 'demo073@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-14T13:38:00Z'::timestamptz - interval '14 minutes', '2026-07-14T13:38:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":18,"I":9,"T":1,"F":22,"S":2,"N":2}'::jsonb, '{"E":66.7,"I":33.3,"T":3.7,"F":81.5,"S":7.4,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'N', 'T',
    'T', 'Fe', 'Ne', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['F','S','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":8,"EXE":10,"AUT":4,"COO":20,"FLE":4,"EST":8}'::jsonb, '{"EXP":28.6,"EXE":28.6,"AUT":9.1,"COO":44.4,"FLE":18.2,"EST":19}'::jsonb, '{"CRIAR":8,"EXPLORAR":16,"ANALISAR":9,"DECIDIR":15,"ORGANIZAR":9,"EXECUTAR":25,"RELACIONAR":39,"COORDENAR":35,"FINALIZAR":6,"ESPECIALIZAR":5}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":27.6,"ANALISAR":11.5,"DECIDIR":36.6,"ORGANIZAR":17,"EXECUTAR":45.5,"RELACIONAR":46.4,"COORDENAR":57.4,"FINALIZAR":12.8,"ESPECIALIZAR":10.2}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','EXECUTAR','DECIDIR','EXPLORAR','ORGANIZAR','FINALIZAR','CRIAR','ANALISAR','ESPECIALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":14,"COORDENADOR":27,"FORMADOR":14,"MONITOR":9,"IMPLEMENTADOR":30,"TRAB_EQUIPE":45,"FINALIZADOR":8,"ESPECIALISTA":6}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":26.4,"COORDENADOR":48.2,"FORMADOR":34.1,"MONITOR":12.3,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":54.9,"FINALIZADOR":16,"ESPECIALISTA":10.3}'::jsonb,
    'TRAB_EQUIPE', 54.9, 'Alta',
    'COORDENADOR', 48.2, 'Alta',
    'IMPLEMENTADOR', 41.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'JURÍDICO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Gabriela Duarte', '100518', 'demo074@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-20T13:39:00Z'::timestamptz - interval '14 minutes', '2026-07-20T13:39:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":25,"I":2,"T":2,"F":23,"S":2,"N":0}'::jsonb, '{"E":92.6,"I":7.4,"T":7.4,"F":85.2,"S":7.4,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'F', 'S', 'N',
    'T', 'Fe', 'Se', false, null,
    false, null,
    ARRAY['F','T','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":4,"AUT":2,"COO":29,"FLE":8,"EST":5}'::jsonb, '{"EXP":21.4,"EXE":11.4,"AUT":4.5,"COO":64.4,"FLE":36.4,"EST":11.9}'::jsonb, '{"CRIAR":4,"EXPLORAR":16,"ANALISAR":7,"DECIDIR":9,"ORGANIZAR":5,"EXECUTAR":14,"RELACIONAR":57,"COORDENAR":47,"FINALIZAR":5,"ESPECIALIZAR":2}'::jsonb, '{"CRIAR":6.3,"EXPLORAR":27.6,"ANALISAR":9,"DECIDIR":22,"ORGANIZAR":9.4,"EXECUTAR":25.5,"RELACIONAR":67.9,"COORDENAR":77,"FINALIZAR":10.6,"ESPECIALIZAR":4.1}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','EXPLORAR','EXECUTAR','DECIDIR','FINALIZAR','ORGANIZAR','ANALISAR','CRIAR','ESPECIALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":6,"INV_RECURSOS":16,"COORDENADOR":42,"FORMADOR":9,"MONITOR":5,"IMPLEMENTADOR":18,"TRAB_EQUIPE":57,"FINALIZADOR":5,"ESPECIALISTA":4}'::jsonb, '{"PLANTA":8.1,"INV_RECURSOS":30.2,"COORDENADOR":75,"FORMADOR":22,"MONITOR":6.8,"IMPLEMENTADOR":25,"TRAB_EQUIPE":69.5,"FINALIZADOR":10,"ESPECIALISTA":6.9}'::jsonb,
    'COORDENADOR', 75, 'Muito alta',
    'TRAB_EQUIPE', 69.5, 'Muito alta',
    'INV_RECURSOS', 30.2, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'JURÍDICO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Henriques', '100525', 'demo075@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-04T13:40:00Z'::timestamptz - interval '14 minutes', '2026-07-04T13:40:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":16,"I":11,"T":20,"F":4,"S":1,"N":2}'::jsonb, '{"E":59.3,"I":40.7,"T":74.1,"F":14.8,"S":3.7,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'N', 'S',
    'F', 'Te', 'Ne', false, null,
    false, null,
    ARRAY['T','F','N','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":8,"AUT":18,"COO":7,"FLE":6,"EST":13}'::jsonb, '{"EXP":7.1,"EXE":22.9,"AUT":40.9,"COO":15.6,"FLE":27.3,"EST":31}'::jsonb, '{"CRIAR":11,"EXPLORAR":7,"ANALISAR":39,"DECIDIR":26,"ORGANIZAR":18,"EXECUTAR":19,"RELACIONAR":13,"COORDENAR":10,"FINALIZAR":8,"ESPECIALIZAR":14}'::jsonb, '{"CRIAR":17.5,"EXPLORAR":12.1,"ANALISAR":50,"DECIDIR":63.4,"ORGANIZAR":34,"EXECUTAR":34.5,"RELACIONAR":15.5,"COORDENAR":16.4,"FINALIZAR":17,"ESPECIALIZAR":28.6}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','EXECUTAR','ORGANIZAR','ESPECIALIZAR','CRIAR','FINALIZAR','COORDENAR','RELACIONAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":8,"COORDENADOR":10,"FORMADOR":23,"MONITOR":39,"IMPLEMENTADOR":31,"TRAB_EQUIPE":12,"FINALIZADOR":9,"ESPECIALISTA":18}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":15.1,"COORDENADOR":17.9,"FORMADOR":56.1,"MONITOR":53.4,"IMPLEMENTADOR":43.1,"TRAB_EQUIPE":14.6,"FINALIZADOR":18,"ESPECIALISTA":31}'::jsonb,
    'FORMADOR', 56.1, 'Alta',
    'MONITOR', 53.4, 'Alta',
    'IMPLEMENTADOR', 43.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'JURÍDICO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Xavier', '100532', 'demo076@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-20T13:41:00Z'::timestamptz - interval '14 minutes', '2026-07-20T13:41:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":3,"I":24,"T":20,"F":3,"S":4,"N":0}'::jsonb, '{"E":11.1,"I":88.9,"T":74.1,"F":11.1,"S":14.8,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":0,"EXE":6,"AUT":25,"COO":3,"FLE":2,"EST":18}'::jsonb, '{"EXP":0,"EXE":17.1,"AUT":56.8,"COO":6.7,"FLE":9.1,"EST":42.9}'::jsonb, '{"CRIAR":8,"EXPLORAR":2,"ANALISAR":57,"DECIDIR":16,"ORGANIZAR":22,"EXECUTAR":11,"RELACIONAR":7,"COORDENAR":6,"FINALIZAR":17,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":3.4,"ANALISAR":73.1,"DECIDIR":39,"ORGANIZAR":41.5,"EXECUTAR":20,"RELACIONAR":8.3,"COORDENAR":9.8,"FINALIZAR":36.2,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['ANALISAR','ORGANIZAR','DECIDIR','ESPECIALIZAR','FINALIZAR','EXECUTAR','CRIAR','COORDENAR','RELACIONAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":10,"INV_RECURSOS":2,"COORDENADOR":5,"FORMADOR":12,"MONITOR":57,"IMPLEMENTADOR":25,"TRAB_EQUIPE":8,"FINALIZADOR":18,"ESPECIALISTA":25}'::jsonb, '{"PLANTA":13.5,"INV_RECURSOS":3.8,"COORDENADOR":8.9,"FORMADOR":29.3,"MONITOR":78.1,"IMPLEMENTADOR":34.7,"TRAB_EQUIPE":9.8,"FINALIZADOR":36,"ESPECIALISTA":43.1}'::jsonb,
    'MONITOR', 78.1, 'Muito alta',
    'ESPECIALISTA', 43.1, 'Moderada',
    'FINALIZADOR', 36, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'JURÍDICO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Daniel Gomes', '100539', 'demo077@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-18T13:42:00Z'::timestamptz - interval '14 minutes', '2026-07-18T13:42:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":8,"I":19,"T":0,"F":21,"S":1,"N":5}'::jsonb, '{"E":29.6,"I":70.4,"T":0,"F":77.8,"S":3.7,"N":18.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'N', 'T',
    'T', 'Fi', 'Ni', false, null,
    false, null,
    ARRAY['F','N','S','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":1,"AUT":11,"COO":23,"FLE":4,"EST":9}'::jsonb, '{"EXP":21.4,"EXE":2.9,"AUT":25,"COO":51.1,"FLE":18.2,"EST":21.4}'::jsonb, '{"CRIAR":19,"EXPLORAR":14,"ANALISAR":16,"DECIDIR":3,"ORGANIZAR":11,"EXECUTAR":4,"RELACIONAR":37,"COORDENAR":37,"FINALIZAR":6,"ESPECIALIZAR":19}'::jsonb, '{"CRIAR":30.2,"EXPLORAR":24.1,"ANALISAR":20.5,"DECIDIR":7.3,"ORGANIZAR":20.8,"EXECUTAR":7.3,"RELACIONAR":44,"COORDENAR":60.7,"FINALIZAR":12.8,"ESPECIALIZAR":38.8}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','ESPECIALIZAR','CRIAR','EXPLORAR','ORGANIZAR','ANALISAR','FINALIZAR','DECIDIR','EXECUTAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":21,"INV_RECURSOS":12,"COORDENADOR":31,"FORMADOR":4,"MONITOR":14,"IMPLEMENTADOR":12,"TRAB_EQUIPE":42,"FINALIZADOR":6,"ESPECIALISTA":20}'::jsonb, '{"PLANTA":28.4,"INV_RECURSOS":22.6,"COORDENADOR":55.4,"FORMADOR":9.8,"MONITOR":19.2,"IMPLEMENTADOR":16.7,"TRAB_EQUIPE":51.2,"FINALIZADOR":12,"ESPECIALISTA":34.5}'::jsonb,
    'COORDENADOR', 55.4, 'Alta',
    'TRAB_EQUIPE', 51.2, 'Alta',
    'ESPECIALISTA', 34.5, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Cecília Barbosa', '100546', 'demo078@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-23T13:43:00Z'::timestamptz - interval '14 minutes', '2026-07-23T13:43:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":14,"I":13,"T":4,"F":6,"S":14,"N":3}'::jsonb, '{"E":51.9,"I":48.1,"T":14.8,"F":22.2,"S":51.9,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'F', 'N',
    'N', 'Se', 'Fe', false, null,
    false, null,
    ARRAY['S','F','T','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":15,"AUT":11,"COO":10,"FLE":5,"EST":9}'::jsonb, '{"EXP":14.3,"EXE":42.9,"AUT":25,"COO":22.2,"FLE":22.7,"EST":21.4}'::jsonb, '{"CRIAR":10,"EXPLORAR":14,"ANALISAR":28,"DECIDIR":10,"ORGANIZAR":11,"EXECUTAR":19,"RELACIONAR":20,"COORDENAR":16,"FINALIZAR":20,"ESPECIALIZAR":19}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":24.1,"ANALISAR":35.9,"DECIDIR":24.4,"ORGANIZAR":20.8,"EXECUTAR":34.5,"RELACIONAR":23.8,"COORDENAR":26.2,"FINALIZAR":42.6,"ESPECIALIZAR":38.8}'::jsonb,
    ARRAY['FINALIZAR','ESPECIALIZAR','ANALISAR','EXECUTAR','COORDENAR','DECIDIR','EXPLORAR','RELACIONAR','ORGANIZAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":11,"INV_RECURSOS":12,"COORDENADOR":14,"FORMADOR":10,"MONITOR":25,"IMPLEMENTADOR":26,"TRAB_EQUIPE":21,"FINALIZADOR":22,"ESPECIALISTA":21}'::jsonb, '{"PLANTA":14.9,"INV_RECURSOS":22.6,"COORDENADOR":25,"FORMADOR":24.4,"MONITOR":34.2,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":25.6,"FINALIZADOR":44,"ESPECIALISTA":36.2}'::jsonb,
    'FINALIZADOR', 44, 'Moderada',
    'ESPECIALISTA', 36.2, 'Moderada',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Olívia Uchôa', '100553', 'demo079@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-23T13:44:00Z'::timestamptz - interval '14 minutes', '2026-07-23T13:44:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":3,"F":14,"S":3,"N":7}'::jsonb, '{"E":44.4,"I":55.6,"T":11.1,"F":51.9,"S":11.1,"N":25.9}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'N', 'S',
    'T', 'Fi', 'Ni', false, null,
    false, null,
    ARRAY['F','N','T','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":5,"AUT":8,"COO":16,"FLE":7,"EST":12}'::jsonb, '{"EXP":21.4,"EXE":14.3,"AUT":18.2,"COO":35.6,"FLE":31.8,"EST":28.6}'::jsonb, '{"CRIAR":17,"EXPLORAR":20,"ANALISAR":16,"DECIDIR":8,"ORGANIZAR":15,"EXECUTAR":11,"RELACIONAR":31,"COORDENAR":26,"FINALIZAR":14,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":27,"EXPLORAR":34.5,"ANALISAR":20.5,"DECIDIR":19.5,"ORGANIZAR":28.3,"EXECUTAR":20,"RELACIONAR":36.9,"COORDENAR":42.6,"FINALIZAR":29.8,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','EXPLORAR','FINALIZAR','ORGANIZAR','CRIAR','ESPECIALIZAR','ANALISAR','EXECUTAR','DECIDIR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":18,"INV_RECURSOS":17,"COORDENADOR":22,"FORMADOR":7,"MONITOR":16,"IMPLEMENTADOR":23,"TRAB_EQUIPE":33,"FINALIZADOR":15,"ESPECIALISTA":11}'::jsonb, '{"PLANTA":24.3,"INV_RECURSOS":32.1,"COORDENADOR":39.3,"FORMADOR":17.1,"MONITOR":21.9,"IMPLEMENTADOR":31.9,"TRAB_EQUIPE":40.2,"FINALIZADOR":30,"ESPECIALISTA":19}'::jsonb,
    'TRAB_EQUIPE', 40.2, 'Moderada',
    'COORDENADOR', 39.3, 'Moderada',
    'INV_RECURSOS', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Fábio Pereira', '100560', 'demo080@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-06T13:45:00Z'::timestamptz - interval '14 minutes', '2026-07-06T13:45:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":13,"I":14,"T":4,"F":17,"S":6,"N":0}'::jsonb, '{"E":48.1,"I":51.9,"T":14.8,"F":63,"S":22.2,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'F', 'S', 'N',
    'T', 'Fi', 'Si', false, null,
    false, null,
    ARRAY['F','S','T','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":8,"AUT":8,"COO":18,"FLE":4,"EST":10}'::jsonb, '{"EXP":21.4,"EXE":22.9,"AUT":18.2,"COO":40,"FLE":18.2,"EST":23.8}'::jsonb, '{"CRIAR":6,"EXPLORAR":12,"ANALISAR":24,"DECIDIR":7,"ORGANIZAR":17,"EXECUTAR":14,"RELACIONAR":33,"COORDENAR":29,"FINALIZAR":9,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":9.5,"EXPLORAR":20.7,"ANALISAR":30.8,"DECIDIR":17.1,"ORGANIZAR":32.1,"EXECUTAR":25.5,"RELACIONAR":39.3,"COORDENAR":47.5,"FINALIZAR":19.1,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['COORDENAR','RELACIONAR','ESPECIALIZAR','ORGANIZAR','ANALISAR','EXECUTAR','EXPLORAR','FINALIZAR','DECIDIR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":6,"INV_RECURSOS":13,"COORDENADOR":24,"FORMADOR":6,"MONITOR":22,"IMPLEMENTADOR":24,"TRAB_EQUIPE":36,"FINALIZADOR":12,"ESPECIALISTA":19}'::jsonb, '{"PLANTA":8.1,"INV_RECURSOS":24.5,"COORDENADOR":42.9,"FORMADOR":14.6,"MONITOR":30.1,"IMPLEMENTADOR":33.3,"TRAB_EQUIPE":43.9,"FINALIZADOR":24,"ESPECIALISTA":32.8}'::jsonb,
    'TRAB_EQUIPE', 43.9, 'Moderada',
    'COORDENADOR', 42.9, 'Moderada',
    'IMPLEMENTADOR', 33.3, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'DAP';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Mariana Weber', '100567', 'demo081@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-06T13:46:00Z'::timestamptz - interval '14 minutes', '2026-07-06T13:46:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":14,"I":13,"T":5,"F":4,"S":14,"N":4}'::jsonb, '{"E":51.9,"I":48.1,"T":18.5,"F":14.8,"S":51.9,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'S', 'T', 'N',
    'N', 'Se', 'Te', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":15,"AUT":7,"COO":12,"FLE":5,"EST":11}'::jsonb, '{"EXP":14.3,"EXE":42.9,"AUT":15.9,"COO":26.7,"FLE":22.7,"EST":26.2}'::jsonb, '{"CRIAR":10,"EXPLORAR":15,"ANALISAR":26,"DECIDIR":8,"ORGANIZAR":18,"EXECUTAR":22,"RELACIONAR":24,"COORDENAR":14,"FINALIZAR":15,"ESPECIALIZAR":19}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":25.9,"ANALISAR":33.3,"DECIDIR":19.5,"ORGANIZAR":34,"EXECUTAR":40,"RELACIONAR":28.6,"COORDENAR":23,"FINALIZAR":31.9,"ESPECIALIZAR":38.8}'::jsonb,
    ARRAY['EXECUTAR','ESPECIALIZAR','ORGANIZAR','ANALISAR','FINALIZAR','RELACIONAR','EXPLORAR','COORDENAR','DECIDIR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":9,"INV_RECURSOS":18,"COORDENADOR":14,"FORMADOR":8,"MONITOR":22,"IMPLEMENTADOR":35,"TRAB_EQUIPE":19,"FINALIZADOR":15,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":12.2,"INV_RECURSOS":34,"COORDENADOR":25,"FORMADOR":19.5,"MONITOR":30.1,"IMPLEMENTADOR":48.6,"TRAB_EQUIPE":23.2,"FINALIZADOR":30,"ESPECIALISTA":37.9}'::jsonb,
    'IMPLEMENTADOR', 48.6, 'Alta',
    'ESPECIALISTA', 37.9, 'Moderada',
    'INV_RECURSOS', 34, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'SESMT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Henriques', '100574', 'demo082@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-21T13:47:00Z'::timestamptz - interval '14 minutes', '2026-07-21T13:47:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":22,"F":2,"S":1,"N":2}'::jsonb, '{"E":77.8,"I":22.2,"T":81.5,"F":7.4,"S":3.7,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'N', 'S',
    'F', 'Te', 'Ne', false, null,
    false, null,
    ARRAY['T','F','N','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":6,"AUT":17,"COO":9,"FLE":8,"EST":11}'::jsonb, '{"EXP":10.7,"EXE":17.1,"AUT":38.6,"COO":20,"FLE":36.4,"EST":26.2}'::jsonb, '{"CRIAR":10,"EXPLORAR":12,"ANALISAR":39,"DECIDIR":29,"ORGANIZAR":16,"EXECUTAR":16,"RELACIONAR":16,"COORDENAR":13,"FINALIZAR":5,"ESPECIALIZAR":9}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":20.7,"ANALISAR":50,"DECIDIR":70.7,"ORGANIZAR":30.2,"EXECUTAR":29.1,"RELACIONAR":19,"COORDENAR":21.3,"FINALIZAR":10.6,"ESPECIALIZAR":18.4}'::jsonb,
    ARRAY['DECIDIR','ANALISAR','ORGANIZAR','EXECUTAR','COORDENAR','EXPLORAR','RELACIONAR','ESPECIALIZAR','CRIAR','FINALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":11,"INV_RECURSOS":15,"COORDENADOR":12,"FORMADOR":29,"MONITOR":40,"IMPLEMENTADOR":25,"TRAB_EQUIPE":13,"FINALIZADOR":5,"ESPECIALISTA":12}'::jsonb, '{"PLANTA":14.9,"INV_RECURSOS":28.3,"COORDENADOR":21.4,"FORMADOR":70.7,"MONITOR":54.8,"IMPLEMENTADOR":34.7,"TRAB_EQUIPE":15.9,"FINALIZADOR":10,"ESPECIALISTA":20.7}'::jsonb,
    'FORMADOR', 70.7, 'Muito alta',
    'MONITOR', 54.8, 'Alta',
    'IMPLEMENTADOR', 34.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'SESMT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('William Quintela', '100581', 'demo083@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-26T13:48:00Z'::timestamptz - interval '14 minutes', '2026-07-26T13:48:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":12,"I":15,"T":14,"F":6,"S":6,"N":1}'::jsonb, '{"E":44.4,"I":55.6,"T":51.9,"F":22.2,"S":22.2,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":10,"AUT":15,"COO":8,"FLE":5,"EST":13}'::jsonb, '{"EXP":10.7,"EXE":28.6,"AUT":34.1,"COO":17.8,"FLE":22.7,"EST":31}'::jsonb, '{"CRIAR":9,"EXPLORAR":9,"ANALISAR":36,"DECIDIR":14,"ORGANIZAR":18,"EXECUTAR":17,"RELACIONAR":16,"COORDENAR":10,"FINALIZAR":14,"ESPECIALIZAR":22}'::jsonb, '{"CRIAR":14.3,"EXPLORAR":15.5,"ANALISAR":46.2,"DECIDIR":34.1,"ORGANIZAR":34,"EXECUTAR":30.9,"RELACIONAR":19,"COORDENAR":16.4,"FINALIZAR":29.8,"ESPECIALIZAR":44.9}'::jsonb,
    ARRAY['ANALISAR','ESPECIALIZAR','DECIDIR','ORGANIZAR','EXECUTAR','FINALIZAR','RELACIONAR','COORDENAR','EXPLORAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":11,"INV_RECURSOS":9,"COORDENADOR":10,"FORMADOR":14,"MONITOR":34,"IMPLEMENTADOR":26,"TRAB_EQUIPE":16,"FINALIZADOR":15,"ESPECIALISTA":27}'::jsonb, '{"PLANTA":14.9,"INV_RECURSOS":17,"COORDENADOR":17.9,"FORMADOR":34.1,"MONITOR":46.6,"IMPLEMENTADOR":36.1,"TRAB_EQUIPE":19.5,"FINALIZADOR":30,"ESPECIALISTA":46.6}'::jsonb,
    'MONITOR', 46.6, 'Alta',
    'ESPECIALISTA', 46.6, 'Alta',
    'IMPLEMENTADOR', 36.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'SESMT';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Karina Cardoso', '100588', 'demo084@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-02T13:49:00Z'::timestamptz - interval '14 minutes', '2026-07-02T13:49:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":8,"I":19,"T":1,"F":2,"S":22,"N":2}'::jsonb, '{"E":29.6,"I":70.4,"T":3.7,"F":7.4,"S":81.5,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'F', 'T',
    'N', 'Si', 'Fi', false, null,
    false, null,
    ARRAY['S','F','N','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":2,"EXE":20,"AUT":10,"COO":7,"FLE":3,"EST":12}'::jsonb, '{"EXP":7.1,"EXE":57.1,"AUT":22.7,"COO":15.6,"FLE":13.6,"EST":28.6}'::jsonb, '{"CRIAR":15,"EXPLORAR":5,"ANALISAR":34,"DECIDIR":11,"ORGANIZAR":18,"EXECUTAR":17,"RELACIONAR":14,"COORDENAR":9,"FINALIZAR":27,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":23.8,"EXPLORAR":8.6,"ANALISAR":43.6,"DECIDIR":26.8,"ORGANIZAR":34,"EXECUTAR":30.9,"RELACIONAR":16.7,"COORDENAR":14.8,"FINALIZAR":57.4,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['FINALIZAR','ANALISAR','ESPECIALIZAR','ORGANIZAR','EXECUTAR','DECIDIR','CRIAR','RELACIONAR','COORDENAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":16,"INV_RECURSOS":5,"COORDENADOR":9,"FORMADOR":9,"MONITOR":25,"IMPLEMENTADOR":31,"TRAB_EQUIPE":12,"FINALIZADOR":30,"ESPECIALISTA":25}'::jsonb, '{"PLANTA":21.6,"INV_RECURSOS":9.4,"COORDENADOR":16.1,"FORMADOR":22,"MONITOR":34.2,"IMPLEMENTADOR":43.1,"TRAB_EQUIPE":14.6,"FINALIZADOR":60,"ESPECIALISTA":43.1}'::jsonb,
    'FINALIZADOR', 60, 'Muito alta',
    'IMPLEMENTADOR', 43.1, 'Moderada',
    'ESPECIALISTA', 43.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'INFRAESTRUTURA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Paulo Nogueira', '100595', 'demo085@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-16T13:50:00Z'::timestamptz - interval '14 minutes', '2026-07-16T13:50:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":23,"I":4,"T":3,"F":1,"S":1,"N":22}'::jsonb, '{"E":85.2,"I":14.8,"T":11.1,"F":3.7,"S":3.7,"N":81.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    false, null,
    ARRAY['N','T','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":19,"EXE":8,"AUT":5,"COO":9,"FLE":10,"EST":3}'::jsonb, '{"EXP":67.9,"EXE":22.9,"AUT":11.4,"COO":20,"FLE":45.5,"EST":7.1}'::jsonb, '{"CRIAR":39,"EXPLORAR":36,"ANALISAR":10,"DECIDIR":13,"ORGANIZAR":6,"EXECUTAR":22,"RELACIONAR":20,"COORDENAR":13,"FINALIZAR":3,"ESPECIALIZAR":3}'::jsonb, '{"CRIAR":61.9,"EXPLORAR":62.1,"ANALISAR":12.8,"DECIDIR":31.7,"ORGANIZAR":11.3,"EXECUTAR":40,"RELACIONAR":23.8,"COORDENAR":21.3,"FINALIZAR":6.4,"ESPECIALIZAR":6.1}'::jsonb,
    ARRAY['EXPLORAR','CRIAR','EXECUTAR','DECIDIR','RELACIONAR','COORDENAR','ANALISAR','ORGANIZAR','FINALIZAR','ESPECIALIZAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":43,"INV_RECURSOS":29,"COORDENADOR":14,"FORMADOR":15,"MONITOR":11,"IMPLEMENTADOR":25,"TRAB_EQUIPE":18,"FINALIZADOR":4,"ESPECIALISTA":3}'::jsonb, '{"PLANTA":58.1,"INV_RECURSOS":54.7,"COORDENADOR":25,"FORMADOR":36.6,"MONITOR":15.1,"IMPLEMENTADOR":34.7,"TRAB_EQUIPE":22,"FINALIZADOR":8,"ESPECIALISTA":5.2}'::jsonb,
    'PLANTA', 58.1, 'Alta',
    'INV_RECURSOS', 54.7, 'Alta',
    'FORMADOR', 36.6, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'INFRAESTRUTURA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Bruno Santos', '100602', 'demo086@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-01T13:51:00Z'::timestamptz - interval '14 minutes', '2026-07-01T13:51:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":11,"I":16,"T":4,"F":4,"S":17,"N":2}'::jsonb, '{"E":40.7,"I":59.3,"T":14.8,"F":14.8,"S":63,"N":7.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'N',
    'N', 'Si', 'Ti', false, null,
    true, 'D2: desempate por evidência convergente nos eixos comportamentais.',
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":15,"AUT":11,"COO":8,"FLE":5,"EST":11}'::jsonb, '{"EXP":14.3,"EXE":42.9,"AUT":25,"COO":17.8,"FLE":22.7,"EST":26.2}'::jsonb, '{"CRIAR":7,"EXPLORAR":11,"ANALISAR":36,"DECIDIR":7,"ORGANIZAR":10,"EXECUTAR":25,"RELACIONAR":21,"COORDENAR":10,"FINALIZAR":24,"ESPECIALIZAR":18}'::jsonb, '{"CRIAR":11.1,"EXPLORAR":19,"ANALISAR":46.2,"DECIDIR":17.1,"ORGANIZAR":18.9,"EXECUTAR":45.5,"RELACIONAR":25,"COORDENAR":16.4,"FINALIZAR":51.1,"ESPECIALIZAR":36.7}'::jsonb,
    ARRAY['FINALIZAR','ANALISAR','EXECUTAR','ESPECIALIZAR','RELACIONAR','EXPLORAR','ORGANIZAR','DECIDIR','COORDENAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":8,"INV_RECURSOS":14,"COORDENADOR":12,"FORMADOR":7,"MONITOR":29,"IMPLEMENTADOR":30,"TRAB_EQUIPE":17,"FINALIZADOR":23,"ESPECIALISTA":22}'::jsonb, '{"PLANTA":10.8,"INV_RECURSOS":26.4,"COORDENADOR":21.4,"FORMADOR":17.1,"MONITOR":39.7,"IMPLEMENTADOR":41.7,"TRAB_EQUIPE":20.7,"FINALIZADOR":46,"ESPECIALISTA":37.9}'::jsonb,
    'FINALIZADOR', 46, 'Alta',
    'IMPLEMENTADOR', 41.7, 'Moderada',
    'MONITOR', 39.7, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'INFRAESTRUTURA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Bernardo Jardim', '100609', 'demo087@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-20T13:52:00Z'::timestamptz - interval '14 minutes', '2026-07-20T13:52:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":5,"I":22,"T":4,"F":1,"S":16,"N":6}'::jsonb, '{"E":18.5,"I":81.5,"T":14.8,"F":3.7,"S":59.3,"N":22.2}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'F',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','N','T','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":7,"EXE":16,"AUT":13,"COO":1,"FLE":2,"EST":15}'::jsonb, '{"EXP":25,"EXE":45.7,"AUT":29.5,"COO":2.2,"FLE":9.1,"EST":35.7}'::jsonb, '{"CRIAR":17,"EXPLORAR":11,"ANALISAR":39,"DECIDIR":7,"ORGANIZAR":21,"EXECUTAR":22,"RELACIONAR":8,"COORDENAR":2,"FINALIZAR":17,"ESPECIALIZAR":22}'::jsonb, '{"CRIAR":27,"EXPLORAR":19,"ANALISAR":50,"DECIDIR":17.1,"ORGANIZAR":39.6,"EXECUTAR":40,"RELACIONAR":9.5,"COORDENAR":3.3,"FINALIZAR":36.2,"ESPECIALIZAR":44.9}'::jsonb,
    ARRAY['ANALISAR','ESPECIALIZAR','EXECUTAR','ORGANIZAR','FINALIZAR','CRIAR','EXPLORAR','DECIDIR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":20,"INV_RECURSOS":9,"COORDENADOR":2,"FORMADOR":7,"MONITOR":35,"IMPLEMENTADOR":37,"TRAB_EQUIPE":8,"FINALIZADOR":19,"ESPECIALISTA":25}'::jsonb, '{"PLANTA":27,"INV_RECURSOS":17,"COORDENADOR":3.6,"FORMADOR":17.1,"MONITOR":47.9,"IMPLEMENTADOR":51.4,"TRAB_EQUIPE":9.8,"FINALIZADOR":38,"ESPECIALISTA":43.1}'::jsonb,
    'IMPLEMENTADOR', 51.4, 'Alta',
    'MONITOR', 47.9, 'Alta',
    'ESPECIALISTA', 43.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'INFRAESTRUTURA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Amanda Almeida', '100616', 'demo088@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-27T13:53:00Z'::timestamptz - interval '14 minutes', '2026-07-27T13:53:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":5,"I":22,"T":21,"F":1,"S":2,"N":3}'::jsonb, '{"E":18.5,"I":81.5,"T":77.8,"F":3.7,"S":7.4,"N":11.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'N', 'F',
    'F', 'Ti', 'Ni', false, null,
    false, null,
    ARRAY['T','N','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":4,"EXE":3,"AUT":17,"COO":2,"FLE":3,"EST":25}'::jsonb, '{"EXP":14.3,"EXE":8.6,"AUT":38.6,"COO":4.4,"FLE":13.6,"EST":59.5}'::jsonb, '{"CRIAR":12,"EXPLORAR":7,"ANALISAR":43,"DECIDIR":16,"ORGANIZAR":34,"EXECUTAR":6,"RELACIONAR":6,"COORDENAR":4,"FINALIZAR":18,"ESPECIALIZAR":22}'::jsonb, '{"CRIAR":19,"EXPLORAR":12.1,"ANALISAR":55.1,"DECIDIR":39,"ORGANIZAR":64.2,"EXECUTAR":10.9,"RELACIONAR":7.1,"COORDENAR":6.6,"FINALIZAR":38.3,"ESPECIALIZAR":44.9}'::jsonb,
    ARRAY['ORGANIZAR','ANALISAR','ESPECIALIZAR','DECIDIR','FINALIZAR','CRIAR','EXPLORAR','EXECUTAR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":12,"INV_RECURSOS":6,"COORDENADOR":5,"FORMADOR":13,"MONITOR":44,"IMPLEMENTADOR":32,"TRAB_EQUIPE":6,"FINALIZADOR":17,"ESPECIALISTA":27}'::jsonb, '{"PLANTA":16.2,"INV_RECURSOS":11.3,"COORDENADOR":8.9,"FORMADOR":31.7,"MONITOR":60.3,"IMPLEMENTADOR":44.4,"TRAB_EQUIPE":7.3,"FINALIZADOR":34,"ESPECIALISTA":46.6}'::jsonb,
    'MONITOR', 60.3, 'Muito alta',
    'ESPECIALISTA', 46.6, 'Alta',
    'IMPLEMENTADOR', 44.4, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'INFRAESTRUTURA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Xavier', '100623', 'demo089@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-14T13:54:00Z'::timestamptz - interval '14 minutes', '2026-07-14T13:54:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013C', 'S'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047C', 'S'::polo_jung, 'EXE'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":8,"I":19,"T":3,"F":1,"S":23,"N":0}'::jsonb, '{"E":29.6,"I":70.4,"T":11.1,"F":3.7,"S":85.2,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'S', 'T', 'N',
    'N', 'Si', 'Ti', false, null,
    false, null,
    ARRAY['S','T','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":23,"AUT":12,"COO":4,"FLE":1,"EST":13}'::jsonb, '{"EXP":3.6,"EXE":65.7,"AUT":27.3,"COO":8.9,"FLE":4.5,"EST":31}'::jsonb, '{"CRIAR":8,"EXPLORAR":5,"ANALISAR":36,"DECIDIR":11,"ORGANIZAR":22,"EXECUTAR":24,"RELACIONAR":9,"COORDENAR":4,"FINALIZAR":27,"ESPECIALIZAR":22}'::jsonb, '{"CRIAR":12.7,"EXPLORAR":8.6,"ANALISAR":46.2,"DECIDIR":26.8,"ORGANIZAR":41.5,"EXECUTAR":43.6,"RELACIONAR":10.7,"COORDENAR":6.6,"FINALIZAR":57.4,"ESPECIALIZAR":44.9}'::jsonb,
    ARRAY['FINALIZAR','ANALISAR','ESPECIALIZAR','EXECUTAR','ORGANIZAR','DECIDIR','CRIAR','RELACIONAR','EXPLORAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":8,"INV_RECURSOS":5,"COORDENADOR":5,"FORMADOR":9,"MONITOR":28,"IMPLEMENTADOR":38,"TRAB_EQUIPE":8,"FINALIZADOR":29,"ESPECIALISTA":32}'::jsonb, '{"PLANTA":10.8,"INV_RECURSOS":9.4,"COORDENADOR":8.9,"FORMADOR":22,"MONITOR":38.4,"IMPLEMENTADOR":52.8,"TRAB_EQUIPE":9.8,"FINALIZADOR":58,"ESPECIALISTA":55.2}'::jsonb,
    'FINALIZADOR', 58, 'Alta',
    'ESPECIALISTA', 55.2, 'Alta',
    'IMPLEMENTADOR', 52.8, 'Alta', 'v2.0');

  select id into v_setor from setores where codigo = 'INFRAESTRUTURA';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Weber', '100630', 'demo090@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-13T13:10:00Z'::timestamptz - interval '14 minutes', '2026-07-13T13:10:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":5,"I":22,"T":4,"F":2,"S":3,"N":18}'::jsonb, '{"E":18.5,"I":81.5,"T":14.8,"F":7.4,"S":11.1,"N":66.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'T', 'F',
    'S', 'Ni', 'Ti', false, null,
    false, null,
    ARRAY['N','T','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":13,"EXE":5,"AUT":16,"COO":3,"FLE":6,"EST":11}'::jsonb, '{"EXP":46.4,"EXE":14.3,"AUT":36.4,"COO":6.7,"FLE":27.3,"EST":26.2}'::jsonb, '{"CRIAR":40,"EXPLORAR":21,"ANALISAR":21,"DECIDIR":10,"ORGANIZAR":18,"EXECUTAR":11,"RELACIONAR":9,"COORDENAR":4,"FINALIZAR":10,"ESPECIALIZAR":23}'::jsonb, '{"CRIAR":63.5,"EXPLORAR":36.2,"ANALISAR":26.9,"DECIDIR":24.4,"ORGANIZAR":34,"EXECUTAR":20,"RELACIONAR":10.7,"COORDENAR":6.6,"FINALIZAR":21.3,"ESPECIALIZAR":46.9}'::jsonb,
    ARRAY['CRIAR','ESPECIALIZAR','EXPLORAR','ORGANIZAR','ANALISAR','DECIDIR','FINALIZAR','EXECUTAR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":45,"INV_RECURSOS":17,"COORDENADOR":5,"FORMADOR":7,"MONITOR":21,"IMPLEMENTADOR":23,"TRAB_EQUIPE":8,"FINALIZADOR":8,"ESPECIALISTA":28}'::jsonb, '{"PLANTA":60.8,"INV_RECURSOS":32.1,"COORDENADOR":8.9,"FORMADOR":17.1,"MONITOR":28.8,"IMPLEMENTADOR":31.9,"TRAB_EQUIPE":9.8,"FINALIZADOR":16,"ESPECIALISTA":48.3}'::jsonb,
    'PLANTA', 60.8, 'Muito alta',
    'ESPECIALISTA', 48.3, 'Alta',
    'INV_RECURSOS', 32.1, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'PLANEJAMENTO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Yuri Duarte', '100637', 'demo091@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-07T13:11:00Z'::timestamptz - interval '14 minutes', '2026-07-07T13:11:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035B', 'F'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":3,"I":24,"T":2,"F":4,"S":2,"N":19}'::jsonb, '{"E":11.1,"I":88.9,"T":7.4,"F":14.8,"S":7.4,"N":70.4}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'F', 'S',
    'S', 'Ni', 'Fi', false, null,
    false, null,
    ARRAY['N','F','T','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":12,"EXE":2,"AUT":17,"COO":4,"FLE":8,"EST":11}'::jsonb, '{"EXP":42.9,"EXE":5.7,"AUT":38.6,"COO":8.9,"FLE":36.4,"EST":26.2}'::jsonb, '{"CRIAR":35,"EXPLORAR":26,"ANALISAR":33,"DECIDIR":8,"ORGANIZAR":13,"EXECUTAR":4,"RELACIONAR":14,"COORDENAR":5,"FINALIZAR":12,"ESPECIALIZAR":16}'::jsonb, '{"CRIAR":55.6,"EXPLORAR":44.8,"ANALISAR":42.3,"DECIDIR":19.5,"ORGANIZAR":24.5,"EXECUTAR":7.3,"RELACIONAR":16.7,"COORDENAR":8.2,"FINALIZAR":25.5,"ESPECIALIZAR":32.7}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','ANALISAR','ESPECIALIZAR','FINALIZAR','ORGANIZAR','DECIDIR','RELACIONAR','COORDENAR','EXECUTAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":44,"INV_RECURSOS":18,"COORDENADOR":5,"FORMADOR":6,"MONITOR":31,"IMPLEMENTADOR":14,"TRAB_EQUIPE":13,"FINALIZADOR":13,"ESPECIALISTA":18}'::jsonb, '{"PLANTA":59.5,"INV_RECURSOS":34,"COORDENADOR":8.9,"FORMADOR":14.6,"MONITOR":42.5,"IMPLEMENTADOR":19.4,"TRAB_EQUIPE":15.9,"FINALIZADOR":26,"ESPECIALISTA":31}'::jsonb,
    'PLANTA', 59.5, 'Alta',
    'MONITOR', 42.5, 'Moderada',
    'INV_RECURSOS', 34, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'PLANEJAMENTO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Queila Duarte', '100644', 'demo092@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-15T13:12:00Z'::timestamptz - interval '14 minutes', '2026-07-15T13:12:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026B', 'E'::polo_jung, 'EXP'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045B', 'F'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":21,"I":6,"T":16,"F":6,"S":4,"N":1}'::jsonb, '{"E":77.8,"I":22.2,"T":59.3,"F":22.2,"S":14.8,"N":3.7}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'S', 'N',
    'F', 'Te', 'Se', false, null,
    false, null,
    ARRAY['T','F','S','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":6,"EXE":6,"AUT":10,"COO":13,"FLE":7,"EST":12}'::jsonb, '{"EXP":21.4,"EXE":17.1,"AUT":22.7,"COO":28.9,"FLE":31.8,"EST":28.6}'::jsonb, '{"CRIAR":6,"EXPLORAR":18,"ANALISAR":29,"DECIDIR":11,"ORGANIZAR":20,"EXECUTAR":20,"RELACIONAR":27,"COORDENAR":15,"FINALIZAR":8,"ESPECIALIZAR":11}'::jsonb, '{"CRIAR":9.5,"EXPLORAR":31,"ANALISAR":37.2,"DECIDIR":26.8,"ORGANIZAR":37.7,"EXECUTAR":36.4,"RELACIONAR":32.1,"COORDENAR":24.6,"FINALIZAR":17,"ESPECIALIZAR":22.4}'::jsonb,
    ARRAY['ORGANIZAR','ANALISAR','EXECUTAR','RELACIONAR','EXPLORAR','DECIDIR','COORDENAR','ESPECIALIZAR','FINALIZAR','CRIAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":7,"INV_RECURSOS":19,"COORDENADOR":13,"FORMADOR":13,"MONITOR":29,"IMPLEMENTADOR":33,"TRAB_EQUIPE":27,"FINALIZADOR":8,"ESPECIALISTA":13}'::jsonb, '{"PLANTA":9.5,"INV_RECURSOS":35.8,"COORDENADOR":23.2,"FORMADOR":31.7,"MONITOR":39.7,"IMPLEMENTADOR":45.8,"TRAB_EQUIPE":32.9,"FINALIZADOR":16,"ESPECIALISTA":22.4}'::jsonb,
    'IMPLEMENTADOR', 45.8, 'Alta',
    'MONITOR', 39.7, 'Moderada',
    'INV_RECURSOS', 35.8, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'PLANEJAMENTO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Fábio Vieira', '100651', 'demo093@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-16T13:13:00Z'::timestamptz - interval '14 minutes', '2026-07-16T13:13:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008B', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042B', 'E'::polo_jung, 'EXE'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":14,"I":13,"T":4,"F":1,"S":2,"N":20}'::jsonb, '{"E":51.9,"I":48.1,"T":14.8,"F":3.7,"S":7.4,"N":74.1}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'N', 'T', 'F',
    'S', 'Ne', 'Te', false, null,
    false, null,
    ARRAY['N','T','S','F']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":16,"EXE":6,"AUT":7,"COO":6,"FLE":7,"EST":12}'::jsonb, '{"EXP":57.1,"EXE":17.1,"AUT":15.9,"COO":13.3,"FLE":31.8,"EST":28.6}'::jsonb, '{"CRIAR":33,"EXPLORAR":32,"ANALISAR":22,"DECIDIR":12,"ORGANIZAR":13,"EXECUTAR":13,"RELACIONAR":16,"COORDENAR":6,"FINALIZAR":5,"ESPECIALIZAR":15}'::jsonb, '{"CRIAR":52.4,"EXPLORAR":55.2,"ANALISAR":28.2,"DECIDIR":29.3,"ORGANIZAR":24.5,"EXECUTAR":23.6,"RELACIONAR":19,"COORDENAR":9.8,"FINALIZAR":10.6,"ESPECIALIZAR":30.6}'::jsonb,
    ARRAY['EXPLORAR','CRIAR','ESPECIALIZAR','DECIDIR','ANALISAR','ORGANIZAR','EXECUTAR','RELACIONAR','FINALIZAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":38,"INV_RECURSOS":27,"COORDENADOR":6,"FORMADOR":13,"MONITOR":24,"IMPLEMENTADOR":20,"TRAB_EQUIPE":14,"FINALIZADOR":3,"ESPECIALISTA":17}'::jsonb, '{"PLANTA":51.4,"INV_RECURSOS":50.9,"COORDENADOR":10.7,"FORMADOR":31.7,"MONITOR":32.9,"IMPLEMENTADOR":27.8,"TRAB_EQUIPE":17.1,"FINALIZADOR":6,"ESPECIALISTA":29.3}'::jsonb,
    'PLANTA', 51.4, 'Alta',
    'INV_RECURSOS', 50.9, 'Alta',
    'MONITOR', 32.9, 'Moderada', 'v2.0');

  select id into v_setor from setores where codigo = 'PLANEJAMENTO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Xênia Oliveira', '100658', 'demo094@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-21T13:14:00Z'::timestamptz - interval '14 minutes', '2026-07-21T13:14:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013B', 'F'::polo_jung, 'COO'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027D', 'N'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045D', 'N'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047D', 'N'::polo_jung, 'EXP'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":7,"I":20,"T":0,"F":4,"S":1,"N":22}'::jsonb, '{"E":25.9,"I":74.1,"T":0,"F":14.8,"S":3.7,"N":81.5}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'N', 'F', 'T',
    'S', 'Ni', 'Fi', false, null,
    false, null,
    ARRAY['N','F','S','T']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":15,"EXE":3,"AUT":9,"COO":6,"FLE":9,"EST":12}'::jsonb, '{"EXP":53.6,"EXE":8.6,"AUT":20.5,"COO":13.3,"FLE":40.9,"EST":28.6}'::jsonb, '{"CRIAR":41,"EXPLORAR":33,"ANALISAR":16,"DECIDIR":6,"ORGANIZAR":14,"EXECUTAR":11,"RELACIONAR":12,"COORDENAR":7,"FINALIZAR":12,"ESPECIALIZAR":14}'::jsonb, '{"CRIAR":65.1,"EXPLORAR":56.9,"ANALISAR":20.5,"DECIDIR":14.6,"ORGANIZAR":26.4,"EXECUTAR":20,"RELACIONAR":14.3,"COORDENAR":11.5,"FINALIZAR":25.5,"ESPECIALIZAR":28.6}'::jsonb,
    ARRAY['CRIAR','EXPLORAR','ESPECIALIZAR','ORGANIZAR','FINALIZAR','ANALISAR','EXECUTAR','DECIDIR','RELACIONAR','COORDENAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":46,"INV_RECURSOS":28,"COORDENADOR":7,"FORMADOR":6,"MONITOR":15,"IMPLEMENTADOR":21,"TRAB_EQUIPE":12,"FINALIZADOR":10,"ESPECIALISTA":17}'::jsonb, '{"PLANTA":62.2,"INV_RECURSOS":52.8,"COORDENADOR":12.5,"FORMADOR":14.6,"MONITOR":20.5,"IMPLEMENTADOR":29.2,"TRAB_EQUIPE":14.6,"FINALIZADOR":20,"ESPECIALISTA":29.3}'::jsonb,
    'PLANTA', 62.2, 'Muito alta',
    'INV_RECURSOS', 52.8, 'Alta',
    'ESPECIALISTA', 29.3, 'Baixa', 'v2.0');

  select id into v_setor from setores where codigo = 'PLANEJAMENTO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Rafael Ferreira', '100665', 'demo095@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-16T13:15:00Z'::timestamptz - interval '14 minutes', '2026-07-16T13:15:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007C', 'S'::polo_jung, 'EXE'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008D', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012A', 'E'::polo_jung, 'EXP'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017A', 'T'::polo_jung, 'FLE'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025C', 'S'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037B', 'F'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042C', 'I'::polo_jung, 'AUT'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":10,"I":17,"T":22,"F":2,"S":3,"N":0}'::jsonb, '{"E":37,"I":63,"T":81.5,"F":7.4,"S":11.1,"N":0}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'I', 'T', 'S', 'N',
    'F', 'Ti', 'Si', false, null,
    false, null,
    ARRAY['T','S','F','N']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":1,"EXE":5,"AUT":23,"COO":5,"FLE":3,"EST":17}'::jsonb, '{"EXP":3.6,"EXE":14.3,"AUT":52.3,"COO":11.1,"FLE":13.6,"EST":40.5}'::jsonb, '{"CRIAR":10,"EXPLORAR":2,"ANALISAR":51,"DECIDIR":21,"ORGANIZAR":22,"EXECUTAR":8,"RELACIONAR":15,"COORDENAR":8,"FINALIZAR":6,"ESPECIALIZAR":23}'::jsonb, '{"CRIAR":15.9,"EXPLORAR":3.4,"ANALISAR":65.4,"DECIDIR":51.2,"ORGANIZAR":41.5,"EXECUTAR":14.5,"RELACIONAR":17.9,"COORDENAR":13.1,"FINALIZAR":12.8,"ESPECIALIZAR":46.9}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','ESPECIALIZAR','ORGANIZAR','RELACIONAR','CRIAR','EXECUTAR','COORDENAR','FINALIZAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":15,"INV_RECURSOS":2,"COORDENADOR":9,"FORMADOR":19,"MONITOR":49,"IMPLEMENTADOR":21,"TRAB_EQUIPE":14,"FINALIZADOR":6,"ESPECIALISTA":27}'::jsonb, '{"PLANTA":20.3,"INV_RECURSOS":3.8,"COORDENADOR":16.1,"FORMADOR":46.3,"MONITOR":67.1,"IMPLEMENTADOR":29.2,"TRAB_EQUIPE":17.1,"FINALIZADOR":12,"ESPECIALISTA":46.6}'::jsonb,
    'MONITOR', 67.1, 'Muito alta',
    'ESPECIALISTA', 46.6, 'Alta',
    'FORMADOR', 46.3, 'Alta', 'v2.0');

  select id into v_setor from setores where codigo = 'PLANEJAMENTO';
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values ('Gabriela Xavier', '100672', 'demo096@exemplo.gov.br', v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, 'v1.0-piloto', 'CONCLUIDA', '2026-07-01T13:16:00Z'::timestamptz - interval '14 minutes', '2026-07-01T13:16:00Z'::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values
    (v_aval, 'Q001', 'Q001A', 'T'::polo_jung, 'EST'::eixo_aux, 2, 1),
    (v_aval, 'Q002', 'Q002A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q003', 'Q003A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q004', 'Q004A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q005', 'Q005A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q006', 'Q006D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q007', 'Q007A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q008', 'Q008C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q009', 'Q009A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 1),
    (v_aval, 'Q010', 'Q010A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q011', 'Q011A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q012', 'Q012B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q013', 'Q013A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 1),
    (v_aval, 'Q014', 'Q014B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 2),
    (v_aval, 'Q015', 'Q015B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q016', 'Q016A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q017', 'Q017D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q018', 'Q018C', 'I'::polo_jung, 'EST'::eixo_aux, 1, 2),
    (v_aval, 'Q019', 'Q019A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q020', 'Q020D', 'I'::polo_jung, 'EST'::eixo_aux, 1, 4),
    (v_aval, 'Q021', 'Q021D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q022', 'Q022C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q023', 'Q023A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q024', 'Q024C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 4),
    (v_aval, 'Q025', 'Q025A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q026', 'Q026A', 'E'::polo_jung, 'COO'::eixo_aux, 2, 2),
    (v_aval, 'Q027', 'Q027A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q028', 'Q028A', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q029', 'Q029A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q030', 'Q030C', 'I'::polo_jung, 'AUT'::eixo_aux, 1, 2),
    (v_aval, 'Q031', 'Q031A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q032', 'Q032B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q033', 'Q033D', 'N'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q034', 'Q034A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q035', 'Q035A', 'T'::polo_jung, 'EST'::eixo_aux, 1, 3),
    (v_aval, 'Q036', 'Q036B', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q037', 'Q037D', 'N'::polo_jung, 'EXP'::eixo_aux, 1, 1),
    (v_aval, 'Q038', 'Q038B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 2),
    (v_aval, 'Q039', 'Q039A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 3),
    (v_aval, 'Q040', 'Q040B', 'E'::polo_jung, 'FLE'::eixo_aux, 1, 4),
    (v_aval, 'Q041', 'Q041A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q042', 'Q042D', 'I'::polo_jung, 'EST'::eixo_aux, 2, 2),
    (v_aval, 'Q043', 'Q043B', 'F'::polo_jung, 'COO'::eixo_aux, 1, 3),
    (v_aval, 'Q044', 'Q044A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 4),
    (v_aval, 'Q045', 'Q045A', 'T'::polo_jung, 'AUT'::eixo_aux, 1, 1),
    (v_aval, 'Q046', 'Q046A', 'E'::polo_jung, 'COO'::eixo_aux, 1, 2),
    (v_aval, 'Q047', 'Q047A', 'T'::polo_jung, 'AUT'::eixo_aux, 2, 3),
    (v_aval, 'Q048', 'Q048B', 'E'::polo_jung, 'EXE'::eixo_aux, 1, 4);
  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, '{"E":17,"I":10,"T":21,"F":2,"S":0,"N":4}'::jsonb, '{"E":63,"I":37,"T":77.8,"F":7.4,"S":0,"N":14.8}'::jsonb);
  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate,
    empate_auxiliar, regra_desempate_auxiliar, ordem_funcoes, algoritmo_versao)
    values (v_aval, 'E', 'T', 'N', 'S',
    'F', 'Te', 'Ne', false, null,
    false, null,
    ARRAY['T','N','F','S']::text[], 'v1.1-desempate-auxiliar');
  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, '{"EXP":3,"EXE":2,"AUT":19,"COO":11,"FLE":6,"EST":13}'::jsonb, '{"EXP":10.7,"EXE":5.7,"AUT":43.2,"COO":24.4,"FLE":27.3,"EST":31}'::jsonb, '{"CRIAR":11,"EXPLORAR":9,"ANALISAR":42,"DECIDIR":21,"ORGANIZAR":16,"EXECUTAR":9,"RELACIONAR":25,"COORDENAR":10,"FINALIZAR":15,"ESPECIALIZAR":10}'::jsonb, '{"CRIAR":17.5,"EXPLORAR":15.5,"ANALISAR":53.8,"DECIDIR":51.2,"ORGANIZAR":30.2,"EXECUTAR":16.4,"RELACIONAR":29.8,"COORDENAR":16.4,"FINALIZAR":31.9,"ESPECIALIZAR":20.4}'::jsonb,
    ARRAY['ANALISAR','DECIDIR','FINALIZAR','ORGANIZAR','RELACIONAR','ESPECIALIZAR','CRIAR','EXECUTAR','COORDENAR','EXPLORAR']::text[], 'v2.0');
  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, '{"PLANTA":11,"INV_RECURSOS":8,"COORDENADOR":14,"FORMADOR":20,"MONITOR":44,"IMPLEMENTADOR":17,"TRAB_EQUIPE":21,"FINALIZADOR":13,"ESPECIALISTA":14}'::jsonb, '{"PLANTA":14.9,"INV_RECURSOS":15.1,"COORDENADOR":25,"FORMADOR":48.8,"MONITOR":60.3,"IMPLEMENTADOR":23.6,"TRAB_EQUIPE":25.6,"FINALIZADOR":26,"ESPECIALISTA":24.1}'::jsonb,
    'MONITOR', 60.3, 'Muito alta',
    'FORMADOR', 48.8, 'Alta',
    'FINALIZADOR', 26, 'Baixa', 'v2.0');
end $demo$;

commit;