/**
 * ETAPA 5 — AUDITORIA DOS ITENS (obrigatória antes da produção, item 50)
 * ---------------------------------------------------------------------------
 * Verifica automaticamente: integridade estrutural, equilíbrio entre dimensões,
 * redundância, ambiguidade, desejabilidade social, cobertura de contextos e
 * risco de resposta óbvia. Emite um relatório e falha (exit 1) em erro grave.
 */
import { VERSAO_INSTRUMENTO, NOME_EIXO, type EixoAux } from '../src/data/questions';
import {
  QUESTOES_COMPLETAS as QUESTOES, MAXIMO_POR_POLO_JUNG, MAXIMO_POR_EIXO,
  PESO_TOTAL_ATITUDE, PESO_TOTAL_FUNCAO
} from '../src/data/questions.server';
import { CAPACIDADES, MATRIZ_FUNCIONAL, AFINIDADE_BELBIN, JUSTIFICATIVAS, verificarCoberturaPossivel } from '../src/data/functional';
import { PERFIS } from '../src/data/profiles';

const CONTEXTOS_EXIGIDOS = [
  'tomada de decisão', 'problemas inesperados', 'reuniões', 'inovação', 'mudanças',
  'conflitos', 'planejamento', 'prazos', 'relacionamento', 'comunicação',
  'aprendizagem', 'pressão', 'organização', 'negociação', 'análise', 'execução',
  'conclusão', 'novas oportunidades', 'informações incompletas', 'divergências', 'prioridades'
];

/** Léxico de desejabilidade social: termos que tornam uma alternativa "obviamente melhor". */
const TERMOS_DESEJABILIDADE = [
  'sempre', 'nunca', 'melhor', 'pior', 'correto', 'errado', 'ideal', 'adequadamente',
  'perfeit', 'excelente', 'ótim', 'fracass', 'incapaz', 'preguiç', 'irresponsáv',
  'atras', 'descuid', 'neglig', 'devo ', 'tenho que', 'deveria'
];

type Nivel = 'ERRO' | 'ALERTA' | 'OK';
const achados: { nivel: Nivel; area: string; msg: string }[] = [];
const add = (nivel: Nivel, area: string, msg: string) => achados.push({ nivel, area, msg });

// ── 1. Integridade estrutural ──────────────────────────────────────────────
const ids = QUESTOES.map(q => q.id);
if (new Set(ids).size !== ids.length) add('ERRO', 'Integridade', 'IDs de questão duplicados.');
if (QUESTOES.length !== 48) add('ERRO', 'Integridade', `Esperadas 48 questões, encontradas ${QUESTOES.length}.`);

const altIds = QUESTOES.flatMap(q => q.alternativas.map(a => a.id));
if (new Set(altIds).size !== altIds.length) add('ERRO', 'Integridade', 'IDs de alternativa duplicados.');

for (const q of QUESTOES) {
  if (q.alternativas.length !== 4) add('ERRO', 'Integridade', `${q.id}: ${q.alternativas.length} alternativas (esperadas 4).`);
  const jungs = q.alternativas.map(a => a.jung).sort().join('');
  if (q.tipo === 'FUNCAO' && jungs !== 'FNST') add('ERRO', 'Chave', `${q.id} (FUNCAO): chave junguiana ${jungs}, esperada FNST.`);
  if (q.tipo === 'ATITUDE' && jungs !== 'EEII') add('ERRO', 'Chave', `${q.id} (ATITUDE): chave junguiana ${jungs}, esperada EEII.`);
  const eixos = q.alternativas.map(a => a.eixo);
  if (new Set(eixos).size !== 4) add('ALERTA', 'Chave', `${q.id}: eixos auxiliares repetidos (${eixos.join(',')}). Reduz a informação auxiliar do item.`);
  if (![1, 2].includes(q.peso)) add('ERRO', 'Peso', `${q.id}: peso ${q.peso} fora de {1,2}.`);
}

// ── 2. Equilíbrio entre dimensões (item 9) ─────────────────────────────────
const nFunc = QUESTOES.filter(q => q.tipo === 'FUNCAO').length;
const nAtit = QUESTOES.filter(q => q.tipo === 'ATITUDE').length;
if (nFunc !== nAtit) add('ALERTA', 'Equilíbrio', `Itens FUNCAO (${nFunc}) e ATITUDE (${nAtit}) desbalanceados.`);
if (PESO_TOTAL_ATITUDE % 2 === 0) add('ERRO', 'Desempate', `Peso total de atitude (${PESO_TOTAL_ATITUDE}) é par — empate E/I possível. Ajuste os itens-âncora.`);

for (const p of ['E', 'I', 'T', 'F', 'S', 'N'] as const) {
  const esperado = p === 'E' || p === 'I' ? PESO_TOTAL_ATITUDE : PESO_TOTAL_FUNCAO;
  if (MAXIMO_POR_POLO_JUNG[p] !== esperado)
    add('ERRO', 'Equilíbrio', `Polo ${p}: máximo ${MAXIMO_POR_POLO_JUNG[p]}, esperado ${esperado}.`);
}

const eixosVals = Object.values(MAXIMO_POR_EIXO);
const minE = Math.min(...eixosVals), maxE = Math.max(...eixosVals);
if (maxE / Math.max(1, minE) > 2.2)
  add('ALERTA', 'Equilíbrio', `Eixos auxiliares desbalanceados (mín ${minE}, máx ${maxE}). Não enviesa os escores — eles são normalizados pelo máximo de cada polo —, mas reduz a precisão dos eixos menos representados.`);

// ── 3. Cobertura de contextos (item 9) ─────────────────────────────────────
const contextos = new Set(QUESTOES.map(q => q.contexto));
const faltando = CONTEXTOS_EXIGIDOS.filter(c => !contextos.has(c));
if (faltando.length) add('ALERTA', 'Contextos', `Contextos exigidos ausentes: ${faltando.join(', ')}.`);

// ── 4. Desejabilidade social (item 11) ─────────────────────────────────────
for (const q of QUESTOES) {
  for (const a of q.alternativas) {
    const t = a.texto.toLowerCase();
    const hits = TERMOS_DESEJABILIDADE.filter(x => t.includes(x));
    if (hits.length) add('ALERTA', 'Desejabilidade', `${a.id}: termo de valência assimétrica "${hits.join('/')}" — "${a.texto.slice(0, 60)}…"`);
  }
}

// ── 5. Assimetria de comprimento (alternativa longa = mais elaborada = mais escolhida) ──
for (const q of QUESTOES) {
  const lens = q.alternativas.map(a => a.texto.length);
  const r = Math.max(...lens) / Math.min(...lens);
  if (r > 2.2) add('ALERTA', 'Formato', `${q.id}: alternativas com comprimentos muito desiguais (razão ${r.toFixed(1)}). Pode induzir escolha pela mais detalhada.`);
}

// ── 6. Redundância entre itens ─────────────────────────────────────────────
const tok = (s: string) => new Set(s.toLowerCase().replace(/[^\wàâãáéêíóôõúç\s]/g, '').split(/\s+/).filter(w => w.length > 4));
const jaccard = (a: Set<string>, b: Set<string>) => {
  const inter = [...a].filter(x => b.has(x)).length;
  return inter / (a.size + b.size - inter);
};
for (let i = 0; i < QUESTOES.length; i++) {
  for (let j = i + 1; j < QUESTOES.length; j++) {
    const s = jaccard(tok(QUESTOES[i].enunciado), tok(QUESTOES[j].enunciado));
    if (s > 0.5) add('ALERTA', 'Redundância', `${QUESTOES[i].id} e ${QUESTOES[j].id}: enunciados com sobreposição léxica de ${(s * 100).toFixed(0)}%.`);
  }
}
// redundância dentro do item (duas alternativas quase iguais → ambiguidade)
for (const q of QUESTOES) {
  for (let i = 0; i < 4; i++) for (let j = i + 1; j < 4; j++) {
    const s = jaccard(tok(q.alternativas[i].texto), tok(q.alternativas[j].texto));
    if (s > 0.45) add('ALERTA', 'Ambiguidade', `${q.id}: alternativas ${'ABCD'[i]} e ${'ABCD'[j]} muito semelhantes (${(s * 100).toFixed(0)}%). Risco de escolha arbitrária.`);
  }
}

// ── 7. Clareza ─────────────────────────────────────────────────────────────
for (const q of QUESTOES) {
  if (q.enunciado.length > 220) add('ALERTA', 'Clareza', `${q.id}: enunciado longo (${q.enunciado.length} caracteres).`);
  for (const a of q.alternativas) {
    if (a.texto.length > 130) add('ALERTA', 'Clareza', `${a.id}: alternativa longa (${a.texto.length} caracteres).`);
    if (!/[.!?]$/.test(a.texto.trim())) add('ALERTA', 'Formato', `${a.id}: alternativa sem pontuação final.`);
  }
}

// ── 8. Matriz funcional ────────────────────────────────────────────────────
for (const p of PERFIS) {
  for (const c of CAPACIDADES) {
    const v = MATRIZ_FUNCIONAL[p.id][c.id];
    if (v < 0 || v > 5) add('ERRO', 'Matriz', `${p.id}.${c.id}: valor ${v} fora de 0–5.`);
    if ((v >= 4 || v <= 1) && !JUSTIFICATIVAS[`${p.id}.${c.id}`])
      add('ALERTA', 'Matriz', `${p.id}.${c.id} = ${v} (extremo) sem justificativa registrada.`);
  }
  const soma = CAPACIDADES.reduce((s, c) => s + MATRIZ_FUNCIONAL[p.id][c.id], 0);
  if (soma < 20 || soma > 40) add('ALERTA', 'Matriz', `${p.id}: soma de afinidades = ${soma}. Perfis muito acima ou abaixo da faixa distorcem o ICF.`);
}
for (const { capacidade, portadores } of verificarCoberturaPossivel()) {
  if (portadores.length === 0) add('ERRO', 'Matriz', `Capacidade ${capacidade} não tem nenhum perfil com afinidade ≥4 — seria estruturalmente impossível cobri-la.`);
}

// ── Relatório ──────────────────────────────────────────────────────────────
const erros = achados.filter(a => a.nivel === 'ERRO');
const alertas = achados.filter(a => a.nivel === 'ALERTA');

console.log('═'.repeat(78));
console.log(`RELATÓRIO DE AUDITORIA DOS ITENS — instrumento ${VERSAO_INSTRUMENTO}`);
console.log('═'.repeat(78));
console.log(`\nESTRUTURA`);
console.log(`  Itens ......................... ${QUESTOES.length} (${nFunc} FUNCAO + ${nAtit} ATITUDE)`);
console.log(`  Alternativas .................. ${altIds.length}`);
console.log(`  Itens-âncora (peso 2) ......... ${QUESTOES.filter(q => q.peso === 2).map(q => q.id).join(', ')}`);
console.log(`  Peso total atitude (E+I) ...... ${PESO_TOTAL_ATITUDE} ${PESO_TOTAL_ATITUDE % 2 ? '(ímpar — empate impossível)' : '(PAR — empate possível!)'}`);
console.log(`  Peso total funções (T+F+S+N) .. ${PESO_TOTAL_FUNCAO}`);
console.log(`  Contextos cobertos ............ ${contextos.size} de ${CONTEXTOS_EXIGIDOS.length} exigidos`);

console.log(`\nMÁXIMO TEÓRICO POR POLO (denominador do escore relativo interno)`);
console.log('  Jung : ' + Object.entries(MAXIMO_POR_POLO_JUNG).map(([k, v]) => `${k}=${v}`).join('  '));
console.log('  Eixos: ' + (Object.keys(MAXIMO_POR_EIXO) as EixoAux[]).map(k => `${NOME_EIXO[k]}=${MAXIMO_POR_EIXO[k]}`).join('  '));

console.log(`\nDISTRIBUIÇÃO POR CONTEXTO`);
const porCtx: Record<string, number> = {};
QUESTOES.forEach(q => { porCtx[q.contexto] = (porCtx[q.contexto] || 0) + 1; });
Object.entries(porCtx).sort().forEach(([c, n]) => console.log(`  ${c.padEnd(24)} ${'▪'.repeat(n)} ${n}`));

console.log(`\nACHADOS`);
if (!achados.length) console.log('  Nenhum achado.');
for (const nivel of ['ERRO', 'ALERTA'] as const) {
  const lista = achados.filter(a => a.nivel === nivel);
  if (!lista.length) continue;
  console.log(`\n  ${nivel} (${lista.length})`);
  const porArea: Record<string, string[]> = {};
  lista.forEach(a => { (porArea[a.area] ||= []).push(a.msg); });
  for (const [area, msgs] of Object.entries(porArea)) {
    console.log(`   ${area}:`);
    msgs.slice(0, 12).forEach(m => console.log(`     - ${m}`));
    if (msgs.length > 12) console.log(`     … e mais ${msgs.length - 12}.`);
  }
}

console.log('\n' + '─'.repeat(78));
console.log(`VEREDITO: ${erros.length} erro(s), ${alertas.length} alerta(s).`);
console.log(erros.length
  ? 'INSTRUMENTO BLOQUEADO PARA PRODUÇÃO — corrija os erros antes de aplicar.'
  : 'ESTRUTURA APROVADA para aplicação PILOTO. Os alertas devem ser revisados por\n' +
    'especialista humano e reavaliados após o piloto com dados empíricos (Etapa 51).\n' +
    'O instrumento NÃO deve ser chamado de validado antes da análise psicométrica.');
console.log('─'.repeat(78));

process.exit(erros.length ? 1 : 0);
