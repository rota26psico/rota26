/**
 * TESTES DO MOTOR v2.0 — contra o gabarito e o adendo
 * ===========================================================================
 * Cada verificação cita a seção do documento que ela protege.
 *
 *   npx tsx scripts/test-apuracao-v2.ts
 */
import {
  apurar, aplicarDesempate, prepararDesempate, temComplementar, FAIXAS,
  type RespostaV2
} from '../src/lib/v2/apuracao';
import { QUESTOES_V2, ALTERNATIVAS_VALIDAS, TOTAL_QUESTOES } from '../src/data/v2/questoes';
import { CONFIGS, CONFIG_INFO, MAPA, ANCORAS, pesoDe, configDe, type Config } from '../src/data/v2/mapa.server';
import { ITENS_DESEMPATE, itemDoPar } from '../src/data/v2/desempate.server';

let ok = 0, falhas = 0; const erros: string[] = [];
const V = '\x1b[32m✓\x1b[0m', X = '\x1b[31m✗\x1b[0m';
function checar(nome: string, cond: boolean, det = '') {
  if (cond) { ok++; console.log(`  ${V} ${nome}`); }
  else { falhas++; erros.push(nome + (det ? ` — ${det}` : '')); console.log(`  ${X} ${nome}${det ? ` — ${det}` : ''}`); }
}
const secao = (t: string) => console.log(`\n\x1b[2m── ${t}\x1b[0m`);

let s = 20260825;
const rnd = () => { s = (s * 1103515245 + 12345) & 0x7fffffff; return s / 0x7fffffff; };

const respostasComIndice = (f: (i: number) => number): RespostaV2[] =>
  QUESTOES_V2.map((q, i) => ({ questaoId: q.id, alternativaId: q.alternativas[f(i) % 4].id }));

/* ══════ 1 · ESTRUTURA DA FONTE ═════════════════════════════════════════ */
secao('1 · Fonte oficial — 48 questões, 192 alternativas, 8 âncoras');

checar('48 questões na camada pública', QUESTOES_V2.length === 48, `${QUESTOES_V2.length}`);
checar('Todas com exatamente 4 alternativas',
  QUESTOES_V2.every(q => q.alternativas.length === 4));
checar('192 alternativas válidas', ALTERNATIVAS_VALIDAS.size === 192, `${ALTERNATIVAS_VALIDAS.size}`);
checar('O mapa confidencial cobre as 192',
  [...ALTERNATIVAS_VALIDAS].every(a => MAPA[a] !== undefined));
const porConfig = Object.fromEntries(CONFIGS.map(c => [c, 0])) as Record<Config, number>;
for (const a of ALTERNATIVAS_VALIDAS) porConfig[configDe(a)]++;
checar('Cada configuração aparece exatamente 24 vezes (gabarito 2.1)',
  CONFIGS.every(c => porConfig[c] === 24), JSON.stringify(porConfig));
checar('Oito itens-âncora, um por configuração',
  new Set(Object.values(ANCORAS)).size === 8);
checar('Cada âncora pesa 2 e aponta para a própria configuração',
  CONFIGS.every(c => pesoDe(ANCORAS[c]) === 2 && configDe(ANCORAS[c]) === c));
checar('Nenhuma outra alternativa pesa 2',
  [...ALTERNATIVAS_VALIDAS].filter(a => pesoDe(a) === 2).length === 8);

/* ══════ 2 · PONTUAÇÃO ══════════════════════════════════════════════════ */
secao('2 · Pontuação bruta, pesos e escore relativo (gabarito 2.1 e 2.2)');

const r1 = apurar(respostasComIndice(i => i));
checar('48 respostas são consideradas', r1.respostasValidas === 48);
checar('Marcado como completo', r1.completo);
checar('Total entre 48 e 56 pontos', r1.totalPontos >= 48 && r1.totalPontos <= 56, `${r1.totalPontos}`);
checar('Os escores relativos somam 100',
  Math.abs(CONFIGS.reduce((t, c) => t + r1.relativo[c], 0) - 100) < 0.6,
  `${CONFIGS.reduce((t, c) => t + r1.relativo[c], 0)}`);

// escolher todas as alternativas de UMA configuração dá o máximo dela
for (const alvo of CONFIGS) {
  const resp: RespostaV2[] = QUESTOES_V2.map(q => {
    const a = q.alternativas.find(x => configDe(x.id) === alvo);
    return { questaoId: q.id, alternativaId: (a ?? q.alternativas[0]).id };
  });
  const r = apurar(resp);
  if (alvo === 'Te') {
    checar('Escolhendo sempre a mesma configuração, ela chega a 24 seleções',
      r.bruto.Te >= 24, `${r.bruto.Te} pontos`);
  }
  if (r.predominante !== alvo) { falhas++; erros.push(`saturação de ${alvo} não a torna predominante`); }
}
checar('Saturar qualquer configuração a torna predominante (8/8)',
  !erros.some(e => e.includes('saturação')));

const semAncora = apurar(QUESTOES_V2.map(q => {
  const a = q.alternativas.find(x => pesoDe(x.id) === 1)!;
  return { questaoId: q.id, alternativaId: a.id };
}));
checar('Sem nenhuma âncora escolhida, o total é exatamente 48',
  semAncora.totalPontos === 48, `${semAncora.totalPontos}`);

/* ══════ 3 · ATITUDES, FUNÇÕES E EIXOS ══════════════════════════════════ */
secao('3 · Atitudes, funções e eixos (gabarito 2.3 e 6.3)');

checar('E + I igualam o total de pontos',
  r1.atitudes.E + r1.atitudes.I === r1.totalPontos);
checar('T + F + S + N igualam o total de pontos',
  (['T', 'F', 'S', 'N'] as const).reduce((t, f) => t + r1.funcoes[f], 0) === r1.totalPontos);
checar('Eixo cognitivo = %Intuição − %Sensação',
  Math.abs(r1.eixoCognitivo - (r1.funcoesRelativas.N - r1.funcoesRelativas.S)) < 0.11);
checar('Eixo relacional = %Sentimento − %Pensamento',
  Math.abs(r1.eixoRelacional - (r1.funcoesRelativas.F - r1.funcoesRelativas.T)) < 0.11);
checar('Ambos os eixos ficam entre −100 e +100',
  Math.abs(r1.eixoCognitivo) <= 100 && Math.abs(r1.eixoRelacional) <= 100);

/* ══════ 4 · SECUNDÁRIA VEM DO PAR OPOSTO ═══════════════════════════════ */
secao('4 · Configuração secundária (gabarito 4.2)');

let violacoes = 0;
for (let n = 0; n < 3000; n++) {
  const r = apurar(respostasComIndice(() => Math.floor(rnd() * 4)));
  const fd = CONFIG_INFO[r.predominante].funcao;
  const fs_ = CONFIG_INFO[r.secundaria].funcao;
  const mesmoPar = (fd === 'T' || fd === 'F') ? (fs_ === 'T' || fs_ === 'F') : (fs_ === 'S' || fs_ === 'N');
  if (mesmoPar) violacoes++;
}
checar('A secundária NUNCA vem do mesmo par da dominante (3.000 casos)',
  violacoes === 0, `${violacoes} violações`);

/* ══════ 5 · FAIXAS E DESEMPATE ═════════════════════════════════════════ */
secao('5 · Faixas e disparo do desempate (gabarito 4.1 · adendo 1)');

let disparos = 0, equilibradas = 0, definidas = 0, incoerentes = 0;
const N = 20000;
for (let n = 0; n < N; n++) {
  const r = apurar(respostasComIndice(() => Math.floor(rnd() * 4)));
  if (r.exigeDesempate) disparos++;
  if (r.classificacao === 'configuracao_equilibrada') equilibradas++;
  if (r.classificacao === 'predominancia_definida') definidas++;
  // coerência: margem ≤ 2 ⇒ equilibrada ⇒ exige desempate
  if (r.margem <= FAIXAS.HIBRIDO_MARGEM && !(r.classificacao === 'configuracao_equilibrada' && r.exigeDesempate))
    incoerentes++;
  if (r.margem > FAIXAS.HIBRIDO_MARGEM && !r.empateBruto && r.exigeDesempate) incoerentes++;
}
checar('Margem ≤ 2 pp implica equilibrada E dispara desempate; acima disso, não dispara',
  incoerentes === 0, `${incoerentes} casos incoerentes`);
checar('Predominância definida é rara ao acaso (< 5%)',
  definidas / N < 0.05, `${(definidas / N * 100).toFixed(1)}%`);
console.log(`     ao acaso: desempate em ${(disparos / N * 100).toFixed(1)}% · ` +
  `equilibrada ${(equilibradas / N * 100).toFixed(1)}% · definida ${(definidas / N * 100).toFixed(1)}%`);

/* ══════ 6 · OS 28 ITENS ════════════════════════════════════════════════ */
secao('6 · Itens de desempate (adendo 4)');

checar('28 itens', ITENS_DESEMPATE.length === 28);
let paresOk = 0;
for (const x of CONFIGS) for (const y of CONFIGS) {
  if (x >= y) continue;
  try { const it = itemDoPar(x, y); if (it.par.includes(x) && it.par.includes(y)) paresOk++; } catch { /* conta abaixo */ }
}
checar('Existe item para todos os 28 pares possíveis', paresOk === 28, `${paresOk}/28`);
checar('Cada configuração participa de exatamente 7 itens',
  CONFIGS.every(c => ITENS_DESEMPATE.filter(i => i.par.includes(c)).length === 7));

/* ══════ 7 · APLICAÇÃO DO DESEMPATE ═════════════════════════════════════ */
secao('7 · Efeito do desempate (adendo 2)');

let comDisputa = null as ReturnType<typeof apurar> | null;
for (let n = 0; n < 20000 && !comDisputa; n++) {
  const r = apurar(respostasComIndice(() => Math.floor(rnd() * 4)));
  if (r.exigeDesempate) comDisputa = r;
}
checar('Encontrado um caso real que exige desempate', comDisputa !== null);

if (comDisputa) {
  const [a, b] = comDisputa.emDisputa!;
  const prep = prepararDesempate(comDisputa, 0.9);
  checar('O item preparado compara exatamente as duas em disputa',
    prep.item.par.includes(a) && prep.item.par.includes(b));
  checar('O que vai ao cliente NÃO carrega a configuração de cada alternativa',
    !JSON.stringify(prep.paraCliente).match(/\b(Te|Ti|Fe|Fi|Se|Si|Ne|Ni)\b/));
  checar('O cliente recebe exatamente duas alternativas', prep.paraCliente.alternativas.length === 2);

  const invertido = prepararDesempate(comDisputa, 0.1);
  checar('O sorteio realmente troca a ordem exibida',
    invertido.mapaInterno.A !== prep.mapaInterno.A);

  const escolhida = comDisputa.emDisputa![1];
  const dep = aplicarDesempate(comDisputa, escolhida);
  checar('A configuração escolhida vira a predominante', dep.predominante === escolhida);
  checar('O animal do totem acompanha a escolha',
    dep.animal === CONFIG_INFO[escolhida].animal);
  checar('Marcado como desempate aplicado', dep.desempateAplicado && !dep.exigeDesempate);
  checar('A CLASSIFICAÇÃO não muda — equilibrada continua equilibrada (adendo 2)',
    dep.classificacao === comDisputa.classificacao);
  checar('Os escores brutos permanecem intactos',
    JSON.stringify(dep.bruto) === JSON.stringify(comDisputa.bruto));
  checar('A secundária é recalculada pelo par oposto da nova predominante',
    (() => { const fd = CONFIG_INFO[dep.predominante].funcao, fs2 = CONFIG_INFO[dep.secundaria].funcao;
      return (fd === 'T' || fd === 'F') ? (fs2 === 'S' || fs2 === 'N') : (fs2 === 'T' || fs2 === 'F'); })());
  checar('Escolher configuração fora da disputa é recusado',
    (() => { const fora = CONFIGS.find(c => !comDisputa!.emDisputa!.includes(c))!;
      try { aplicarDesempate(comDisputa!, fora); return false; } catch { return true; } })());
  checar('Quando houve desempate, o resultado tem leitura complementar',
    temComplementar(dep));
}

/* ══════ 8 · DETERMINISMO E ROBUSTEZ ════════════════════════════════════ */
secao('8 · Determinismo e entrada inválida');

const base = respostasComIndice(i => (i * 3) % 4);
checar('Mesmas respostas produzem exatamente o mesmo resultado',
  JSON.stringify(apurar(base)) === JSON.stringify(apurar(base)));
checar('A ordem em que as respostas chegam não altera o resultado',
  JSON.stringify(apurar(base)) === JSON.stringify(apurar([...base].reverse())));
checar('Alternativa inexistente é ignorada, não quebra',
  apurar([...base, { questaoId: 'R001', alternativaId: 'INEXISTENTE' }]).respostasValidas === 48);
checar('Alternativa de outra questão é recusada',
  apurar([{ questaoId: 'R001', alternativaId: 'R002A' }]).respostasValidas === 0);
checar('Resposta repetida na mesma questão conta uma vez só',
  apurar([{ questaoId: 'R001', alternativaId: 'R001A' },
          { questaoId: 'R001', alternativaId: 'R001B' }]).respostasValidas === 1);
checar('Questionário incompleto não é marcado como completo',
  !apurar(base.slice(0, 47)).completo);
checar('Sem respostas, não quebra e não inventa predominância',
  apurar([]).totalPontos === 0);

/* ══════ 9 · TODOS OS OITO ANIMAIS SÃO ALCANÇÁVEIS ══════════════════════ */
secao('9 · Cobertura dos oito animais');

const vistos = new Set<string>();
for (let n = 0; n < 40000; n++) {
  vistos.add(apurar(respostasComIndice(() => Math.floor(rnd() * 4))).predominante);
  if (vistos.size === 8) break;
}
checar('Os oito aparecem como predominante em respostas aleatórias',
  vistos.size === 8, `${vistos.size}/8 — ${[...vistos].join(' ')}`);

console.log('\n' + '═'.repeat(74));
console.log(` RESULTADO: ${ok} aprovadas, ${falhas} falhas.`);
if (falhas) console.log('\n' + erros.map(e => '  • ' + e).join('\n'));
console.log('═'.repeat(74) + '\n');
process.exit(falhas ? 1 : 0);
