/**
 * Gera 03_seed.sql (instrumento + matrizes + setores) e 04_demo_seed.sql
 * (coorte simulada com respostas brutas) A PARTIR DA MESMA FONTE DE VERDADE
 * em TypeScript. Isso garante que banco, aplicação e demo nunca divirjam.
 *
 *   npm run gen:sql
 */
import { writeFileSync, mkdirSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { QUESTOES, VERSAO_INSTRUMENTO, PESO_TOTAL_ATITUDE, PESO_TOTAL_FUNCAO } from '../src/data/questions';
import { PERFIS } from '../src/data/profiles';
import { MATRIZ_FUNCIONAL, AFINIDADE_BELBIN, JUSTIFICATIVAS, CAPACIDADES, PAPEIS_BELBIN } from '../src/data/functional';
import { avaliar } from '../src/lib/scoring';
import { VERSAO_MATRIZ } from '../src/data/scoringMatrix';
import { gerarParticipantes, SETORES } from './simulate';

const dir = join(dirname(fileURLToPath(import.meta.url)), '..', 'supabase');
mkdirSync(dir, { recursive: true });

const s = (v: string | null | undefined) => (v == null ? 'null' : `'${String(v).replace(/'/g, "''")}'`);
const j = (v: unknown) => `'${JSON.stringify(v).replace(/'/g, "''")}'::jsonb`;

// ═══════════════════════════════ 03_seed.sql ═══════════════════════════════
const L: string[] = [];
L.push(`-- ============================================================================
-- SEED DO INSTRUMENTO — gerado automaticamente por scripts/gen-sql.ts
-- NÃO EDITE À MÃO. Altere src/data/*.ts e rode: npm run gen:sql
-- Instrumento: ${VERSAO_INSTRUMENTO}
-- ============================================================================
begin;
`);

L.push('-- ─── Setores (item 26) ───────────────────────────────────────────────────');
L.push('insert into setores (codigo, nome) values');
L.push(SETORES.map(c => `  (${s(c)}, ${s(c)})`).join(',\n') + '\non conflict (codigo) do nothing;\n');

L.push('-- ─── Versão do instrumento ───────────────────────────────────────────────');
L.push(`insert into versoes_instrumento (codigo, descricao, peso_atitude, peso_funcao, ativa, publicada_em)
values (${s(VERSAO_INSTRUMENTO)}, ${s('Versão piloto com 48 itens situacionais de escolha forçada. Aprovada na auditoria estrutural (0 erros, 0 alertas). NÃO validada psicometricamente — ver Etapas 51 e 52.')}, ${PESO_TOTAL_ATITUDE}, ${PESO_TOTAL_FUNCAO}, true, now())
on conflict (codigo) do update set ativa = true;\n`);

L.push('-- ─── Perfis (Etapa 2) ────────────────────────────────────────────────────');
for (const p of PERFIS) {
  const { id, ordem, atitude, funcao, nomeJung, animal, cor, funcaoInferior, sintese, ...resto } = p;
  L.push(`insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  (${s(id)}, ${ordem}, ${s(atitude)}, ${s(funcao)}, ${s(nomeJung)}, ${s(animal)}, ${s(cor)}, ${s(funcaoInferior)}, ${s(sintese)}, ${j(resto)})
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;`);
}
L.push('');

L.push('-- ─── Matriz funcional (Etapa 3) ──────────────────────────────────────────');
L.push('insert into matriz_funcional (perfil_codigo, capacidade, valor, justificativa) values');
L.push(PERFIS.flatMap(p => CAPACIDADES.map(c =>
  `  (${s(p.id)}, ${s(c.id)}, ${MATRIZ_FUNCIONAL[p.id][c.id]}, ${s(JUSTIFICATIVAS[`${p.id}.${c.id}`] ?? null)})`
)).join(',\n') + `
on conflict (perfil_codigo, capacidade) do update set valor = excluded.valor, justificativa = excluded.justificativa;\n`);

L.push('-- ─── Afinidade com os papéis de Belbin ───────────────────────────────────');
L.push('insert into afinidade_belbin (perfil_codigo, papel, valor) values');
L.push(PERFIS.flatMap(p => PAPEIS_BELBIN.map(b =>
  `  (${s(p.id)}, ${s(b.id)}, ${AFINIDADE_BELBIN[p.id][b.id]})`
)).join(',\n') + `
on conflict (perfil_codigo, papel) do update set valor = excluded.valor;\n`);

L.push('-- ─── Banco fixo de questões e alternativas (item 13) ─────────────────────');
L.push(`do $seed$
declare v_versao uuid; v_questao uuid;
begin
  select id into v_versao from versoes_instrumento where codigo = ${s(VERSAO_INSTRUMENTO)};
`);
QUESTOES.forEach((q, i) => {
  L.push(`  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, ${s(q.id)}, ${s(q.tipo)}::tipo_item, ${q.peso}, ${s(q.contexto)}, ${s(q.enunciado)}, ${i + 1})
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;`);
  q.alternativas.forEach((a, k) => {
    L.push(`  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, ${s(a.id)}, ${s(a.texto)}, ${s(a.jung)}::polo_jung, ${s(a.eixo)}::eixo_aux, ${k + 1})
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;`);
  });
});
L.push('end $seed$;\n');
L.push('commit;');
writeFileSync(join(dir, '03_seed.sql'), L.join('\n'));

// ════════════════════════════ 04_demo_seed.sql ═════════════════════════════
const D: string[] = [];
const participantes = gerarParticipantes();

D.push(`-- ============================================================================
-- ⚠️  ARQUIVO DE DESENVOLVIMENTO — NÃO EXECUTE EM AMBIENTE DE APLICAÇÃO REAL
-- ============================================================================
-- SEED DE DEMONSTRAÇÃO — ${participantes.length} participantes simulados, ${SETORES.length} setores
-- gerado por scripts/gen-sql.ts (determinístico: mesma semente, mesmos dados)
-- REQUER 05_migracao_v2.sql aplicado antes (tabelas resultados_funcionais e resultados_belbin).
--
-- Todos os registros aqui recebem is_demo = true. A aplicação em produção NUNCA
-- os executa: nenhum código da aplicação chama este arquivo, e a view
-- vw_resultados os exclui por definição. Se algum dia ele tiver sido aplicado
-- por engano, use  Gestão de dados → Preparar aplicação → LIMPAR DADOS DA
-- DEMONSTRAÇÃO,  ou  select limpar_dados_demo('LIMPAR DADOS DEMO');
-- ----------------------------------------------------------------------------
-- Inclui as RESPOSTAS BRUTAS item a item (${participantes.length} × 48 = ${participantes.length * 48} linhas),
-- exatamente como o sistema grava em produção — permitindo testar recálculo,
-- dashboards e análise psicométrica desde o primeiro minuto.
--
-- Estes participantes NÃO têm user_id (não existem em auth.users): são registros
-- de demonstração. Para removê-los depois:
--   delete from participantes where email like '%@exemplo.gov.br';
-- ============================================================================
begin;
`);

D.push(`do $demo$
declare v_part uuid; v_aval uuid; v_setor uuid;
begin`);

for (const p of participantes) {
  const r = avaliar(p.respostas);
  D.push(`
  select id into v_setor from setores where codigo = ${s(p.setor)};
  insert into participantes (nome, matricula, email, setor_id, is_demo)
    values (${s(p.nome)}, ${s(p.matricula)}, ${s(p.email)}, v_setor, true)
    on conflict (matricula) do update set nome = excluded.nome, is_demo = true
    returning id into v_part;

  insert into avaliacoes (participante_id, versao_codigo, status, iniciada_em, concluida_em, origem, is_demo)
    values (v_part, ${s(VERSAO_INSTRUMENTO)}, 'CONCLUIDA', ${s(p.concluidoEm)}::timestamptz - interval '14 minutes', ${s(p.concluidoEm)}::timestamptz, 'seed-demo', true)
    returning id into v_aval;

  insert into respostas (avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso, posicao_exibida) values`);
  D.push(p.respostas.map((resp, idx) => {
    const q = QUESTOES.find(x => x.id === resp.questaoId)!;
    const a = q.alternativas.find(x => x.id === resp.alternativaId)!;
    return `    (v_aval, ${s(q.id)}, ${s(a.id)}, ${s(a.jung)}::polo_jung, ${s(a.eixo)}::eixo_aux, ${q.peso}, ${(idx % 4) + 1})`;
  }).join(',\n') + ';');

  D.push(`  insert into escores (avaliacao_id, bruto, relativo) values (v_aval, ${j(r.escores.bruto)}, ${j(r.escores.relativo)});`);
  D.push(`  insert into resultados (avaliacao_id, atitude, funcao_dominante, funcao_auxiliar, funcao_menos_representada,
    funcao_inferior, perfil_principal, perfil_secundario, empate_funcoes, regra_desempate, ordem_funcoes, algoritmo_versao)
    values (v_aval, ${s(r.atitude)}, ${s(r.funcaoDominante)}, ${s(r.funcaoAuxiliar)}, ${s(r.funcaoMenosRepresentada)},
    ${s(r.funcaoInferior)}, ${s(r.perfilPrincipal)}, ${s(r.perfilSecundario)}, ${r.empateFuncoes}, ${s(r.regraDesempate)},
    ARRAY[${r.ordemFuncoes.map(f => s(f)).join(',')}]::text[], ${s(VERSAO_INSTRUMENTO)});`);

  D.push(`  insert into resultados_funcionais (avaliacao_id, eixos_bruto, eixos, cap_bruto, capacidades, ordem_capacidades, versao_matriz)
    values (v_aval, ${j(r.escores.eixos.bruto)}, ${j(r.escores.eixos.relativo)}, ${j(r.funcional.capacidadesBruto)}, ${j(r.funcional.capacidades)},
    ARRAY[${r.capacidadesOrdenadas.map(c => s(c.id)).join(',')}]::text[], ${s(VERSAO_MATRIZ)});`);

  const t3 = r.top3Belbin;
  D.push(`  insert into resultados_belbin (avaliacao_id, bruto, relativo, top1, top1_valor, top1_intensidade,
    top2, top2_valor, top2_intensidade, top3, top3_valor, top3_intensidade, versao_matriz)
    values (v_aval, ${j(r.funcional.belbinBruto)}, ${j(r.funcional.belbin)},
    ${s(t3[0].id)}, ${t3[0].valor}, ${s(t3[0].intensidade)},
    ${s(t3[1].id)}, ${t3[1].valor}, ${s(t3[1].intensidade)},
    ${s(t3[2].id)}, ${t3[2].valor}, ${s(t3[2].intensidade)}, ${s(VERSAO_MATRIZ)});`);
}
D.push(`end $demo$;

commit;`);
writeFileSync(join(dir, '04_demo_seed.sql'), D.join('\n'));

// ════════════════════════════════ relatório ════════════════════════════════
const sz = (f: string) => (require('node:fs').statSync(join(dir, f)).size / 1024).toFixed(0);
console.log('SQL gerado em supabase/');
console.log(`  03_seed.sql ........ ${sz('03_seed.sql')} KB — ${QUESTOES.length} questões, ${QUESTOES.length * 4} alternativas, ${PERFIS.length} perfis,`);
console.log(`                        ${PERFIS.length * CAPACIDADES.length} células da matriz funcional, ${PERFIS.length * PAPEIS_BELBIN.length} de afinidade Belbin, ${SETORES.length} setores`);
console.log(`  04_demo_seed.sql ... ${sz('04_demo_seed.sql')} KB — ${participantes.length} participantes, ${participantes.length * 48} respostas brutas`);
