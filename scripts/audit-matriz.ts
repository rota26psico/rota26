/**
 * ETAPA 6 — AUDITORIA DA MATRIZ DE PONTUAÇÃO (192 alternativas)
 * ---------------------------------------------------------------------------
 * Verifica se a nova camada funcional é utilizável e, sobretudo, se ela é
 * INDEPENDENTE do polo junguiano — que é a razão de existir da v2.0.
 * Falha (exit 1) em erro grave.
 */
import { QUESTOES, NOME_EIXO } from '../src/data/questions';
import {
  MATRIZ_PONTUACAO, LINHA_POR_ALTERNATIVA, MAXIMO_CAPACIDADE, MAXIMO_BELBIN,
  CHAVES_CAPACIDADE, CHAVES_BELBIN, VERSAO_MATRIZ
} from '../src/data/scoringMatrix';
import { CAPACIDADES, PAPEIS_BELBIN } from '../src/data/functional';

type Nivel = 'ERRO' | 'ALERTA';
const achados: { nivel: Nivel; area: string; msg: string }[] = [];
const add = (n: Nivel, a: string, m: string) => achados.push({ nivel: n, area: a, msg: m });

console.log('═'.repeat(78));
console.log(`AUDITORIA DA MATRIZ DE PONTUAÇÃO — ${VERSAO_MATRIZ}`);
console.log('═'.repeat(78));

// ── 1. Cobertura ───────────────────────────────────────────────────────────
if (MATRIZ_PONTUACAO.length !== 192) add('ERRO', 'Cobertura', `${MATRIZ_PONTUACAO.length} linhas (esperadas 192).`);
for (const q of QUESTOES) for (const a of q.alternativas)
  if (!LINHA_POR_ALTERNATIVA[a.id]) add('ERRO', 'Cobertura', `${a.id} sem linha na matriz.`);

const contCap: Record<string, number> = {}, contBel: Record<string, number> = {};
for (const l of MATRIZ_PONTUACAO) {
  for (const [k, v] of Object.entries(l.capacidades)) contCap[k] = (contCap[k] ?? 0) + (v as number);
  for (const [k, v] of Object.entries(l.belbin)) contBel[k] = (contBel[k] ?? 0) + (v as number);
}
for (const c of CHAVES_CAPACIDADE) if (!contCap[c]) add('ERRO', 'Cobertura', `Capacidade ${c} nunca pontuada.`);
for (const b of CHAVES_BELBIN) if (!contBel[b]) add('ERRO', 'Cobertura', `Papel ${b} nunca pontuado.`);

// ── 2. Equilíbrio de oportunidade ──────────────────────────────────────────
const mc = Object.values(MAXIMO_CAPACIDADE), mb = Object.values(MAXIMO_BELBIN);
const razao = (v: number[]) => Math.max(...v) / Math.max(1, Math.min(...v));
if (razao(mc) > 2.5) add('ALERTA', 'Equilíbrio', `Máximos por capacidade desiguais (razão ${razao(mc).toFixed(1)}). Os escores são normalizados por esse máximo, então não há viés — mas a precisão das capacidades com menor oportunidade é menor.`);
if (razao(mb) > 2.5) add('ALERTA', 'Equilíbrio', `Máximos por papel Belbin desiguais (razão ${razao(mb).toFixed(1)}).`);

// ── 3. Nenhuma alternativa pode dominar ────────────────────────────────────
for (const l of MATRIZ_PONTUACAO) {
  const sc = Object.values(l.capacidades).reduce((a, b) => a + (b as number), 0);
  const sb = Object.values(l.belbin).reduce((a, b) => a + (b as number), 0);
  if (sc < 3 || sc > 4) add('ALERTA', 'Peso', `${l.alternativaId}: soma de capacidades ${sc} (esperado 3–4).`);
  if (sb < 3 || sb > 4) add('ALERTA', 'Peso', `${l.alternativaId}: soma de papéis ${sb} (esperado 3–4).`);
  if (Object.keys(l.capacidades).length < 2) add('ALERTA', 'Riqueza', `${l.alternativaId}: só ${Object.keys(l.capacidades).length} capacidade(s).`);
  if (Object.keys(l.belbin).length < 2) add('ALERTA', 'Riqueza', `${l.alternativaId}: só ${Object.keys(l.belbin).length} papel(éis).`);
}

// ── 4. Cada questão deve oferecer escolhas funcionalmente distintas ────────
for (const q of QUESTOES) {
  const assinaturas = q.alternativas.map(a => JSON.stringify(LINHA_POR_ALTERNATIVA[a.id].capacidades));
  if (new Set(assinaturas).size < 4)
    add('ALERTA', 'Discriminação', `${q.id}: duas alternativas têm a MESMA assinatura de capacidades — o item não discrimina funcionalmente entre elas.`);
  const capsDoItem = new Set(q.alternativas.flatMap(a => Object.keys(LINHA_POR_ALTERNATIVA[a.id].capacidades)));
  if (capsDoItem.size < 4) add('ALERTA', 'Discriminação', `${q.id}: as 4 alternativas cobrem apenas ${capsDoItem.size} capacidades distintas.`);
}

// ── 5. INDEPENDÊNCIA JUNG × FUNCIONAL (a razão de ser da v2.0) ────────────
// Para cada polo junguiano, quantas assinaturas funcionais DIFERENTES existem?
// Se um polo sempre levasse à mesma assinatura, a trilha funcional seria de
// novo um rótulo do perfil — exatamente o defeito que se está corrigindo.
console.log('\nINDEPENDÊNCIA ENTRE AS DUAS TRILHAS');
console.log('  polo Jung → assinaturas funcionais distintas entre as alternativas daquele polo');
let colapsado = false;
for (const polo of ['E', 'I', 'T', 'F', 'S', 'N'] as const) {
  const linhas = MATRIZ_PONTUACAO.filter(l => l.jung === polo);
  const assin = new Set(linhas.map(l => Object.keys(l.capacidades).sort().join('+')));
  const assinB = new Set(linhas.map(l => Object.keys(l.belbin).sort().join('+')));
  console.log(`   ${polo}: ${linhas.length} alternativas → ${assin.size} combinações de capacidades, ${assinB.size} de papéis`);
  if (assin.size < 4) { colapsado = true; add('ERRO', 'Independência', `Polo ${polo} produz apenas ${assin.size} combinações funcionais — a trilha funcional está colapsada sobre a junguiana.`); }
}
if (!colapsado) console.log('   → nenhum polo colapsa a trilha funcional. Independência preservada.');

// A mesma checagem para o par (jung, eixo): mesmo fixando os dois, deve haver variedade.
const porPar: Record<string, Set<string>> = {};
for (const l of MATRIZ_PONTUACAO) {
  const k = `${l.jung}/${l.eixo}`;
  (porPar[k] ||= new Set()).add(Object.keys(l.capacidades).sort().join('+'));
}
const paresRicos = Object.entries(porPar).filter(([, s]) => s.size > 1).length;
console.log(`  ${paresRicos} de ${Object.keys(porPar).length} pares (Jung, eixo) produzem mais de uma configuração funcional.`);

// ── 6. Distribuição ────────────────────────────────────────────────────────
console.log('\nOPORTUNIDADE MÁXIMA POR CAPACIDADE (denominador do escore relativo)');
for (const c of CAPACIDADES) {
  const v = MAXIMO_CAPACIDADE[c.id];
  console.log(`  ${c.nome.padEnd(18)} ${String(v).padStart(3)}  ${'▪'.repeat(Math.round(v / 4))}`);
}
console.log('\nOPORTUNIDADE MÁXIMA POR PAPEL DE BELBIN');
for (const b of PAPEIS_BELBIN) {
  const v = MAXIMO_BELBIN[b.id];
  console.log(`  ${b.nome.padEnd(26)} ${String(v).padStart(3)}  ${'▪'.repeat(Math.round(v / 4))}`);
}

// ── Relatório ──────────────────────────────────────────────────────────────
const erros = achados.filter(a => a.nivel === 'ERRO');
const alertas = achados.filter(a => a.nivel === 'ALERTA');
console.log('\nACHADOS');
if (!achados.length) console.log('  Nenhum achado.');
for (const nv of ['ERRO', 'ALERTA'] as const) {
  const l = achados.filter(a => a.nivel === nv);
  if (!l.length) continue;
  console.log(`\n  ${nv} (${l.length})`);
  l.slice(0, 20).forEach(a => console.log(`   [${a.area}] ${a.msg}`));
  if (l.length > 20) console.log(`   … e mais ${l.length - 20}.`);
}
console.log('\n' + '─'.repeat(78));
console.log(`VEREDITO: ${erros.length} erro(s), ${alertas.length} alerta(s).`);
console.log(erros.length ? 'MATRIZ BLOQUEADA.' : 'MATRIZ APROVADA para uso no algoritmo.');
console.log('─'.repeat(78));
process.exit(erros.length ? 1 : 0);
