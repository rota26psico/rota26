import 'server-only';
/**
 * REAVALIAÇÃO v2.0 — MOTOR DE APURAÇÃO
 * ===========================================================================
 * Implementa exatamente as regras de ROTA26gabaritotecnicoCONFIDENCIAL.pdf e de
 * ROTA26adendodesempateCONFIDENCIAL.pdf. Nenhum limiar foi inventado aqui: todos
 * os números têm a seção do documento anotada ao lado.
 *
 * ⚠ Servidor apenas. Depende do mapa confidencial.
 *
 * O QUE ESTE MOTOR **NÃO** FAZ, e por quê:
 * o modelo da reavaliação associa cada alternativa a UMA configuração, e não
 * carrega assinatura funcional própria. Por isso ele não produz as dez
 * capacidades nem os nove papéis por pessoa, como fazia a v1.0 a partir de uma
 * matriz independente de 192 linhas. A leitura de contribuição da v2.0 é
 * derivada da configuração — e o resultado declara isso em tela, em vez de
 * apresentá-la como se tivesse sido medida.
 */
import {
  CONFIGS, CONFIG_INFO, configDe, pesoDe,
  type Config, type Atitude, type Funcao
} from '@/data/v2/mapa.server';
import { itemDoPar, type ItemDesempate } from '@/data/v2/desempate.server';
import { ALTERNATIVAS_VALIDAS, TOTAL_QUESTOES } from '@/data/v2/questoes';

export const VERSAO_ALGORITMO = 'apuracao-v2.0';

/* ════════════════════════════════════════════════════════════════════════
   FAIXAS — gabarito, seção 4.1. Calibradas contra 20.000 respondentes ao
   acaso: o acaso produz maior escore com mediana 19,6% e p95 24,5%, e margem
   mediana de 2,0 pp. Os cortes ficam ACIMA disso de propósito.
   ══════════════════════════════════════════════════════════════════════ */
export const FAIXAS = {
  DEFINIDA_ESCORE: 27,      // maior escore ≥ 27%
  DEFINIDA_MARGEM: 8,       // e margem ≥ 8 pp
  MODERADA_ESCORE: 24,      // 24% a 27%
  MODERADA_MARGEM: 2,       // ou margem entre 2 e 8 pp
  HIBRIDO_MARGEM: 2,        // margem ≤ 2 pp  → híbrido (e dispara desempate)
  BAIXA_AMPLITUDE: 14,      // amplitude 1º–8º < 14 pp com maior escore < 24%
  EQUILIBRIO_FUNCOES: 6,    // seção 4.3
  EQUILIBRIO_ATITUDE: 10,
  CONFLITO_MARGEM: 3
} as const;

export type Classificacao =
  | 'predominancia_definida' | 'predominancia_moderada'
  | 'configuracao_equilibrada' | 'baixa_aderencia';

export interface RespostaV2 { questaoId: string; alternativaId: string }

export interface Apuracao {
  versao: string;
  versaoAlgoritmo: string;
  respostasValidas: number;
  completo: boolean;

  bruto: Record<Config, number>;
  relativo: Record<Config, number>;
  totalPontos: number;
  ordem: Config[];

  atitudes: { E: number; I: number; relativoE: number; relativoI: number; dominante: Atitude };
  funcoes: Record<Funcao, number>;
  funcoesRelativas: Record<Funcao, number>;

  eixoCognitivo: number;   // %Intuição − %Sensação   (seção 6.3)
  eixoRelacional: number;  // %Sentimento − %Pensamento
  orientacaoEnergia: number; // %Extroversão − %Introversão

  predominante: Config;
  secundaria: Config;
  margem: number;
  amplitude: number;
  classificacao: Classificacao;

  equilibrioFuncional: boolean;
  equilibrioAtitude: boolean;
  possivelConflito: boolean;

  /** Empate exato no primeiro lugar, antes de qualquer desempate. */
  empateBruto: boolean;
  /** O adendo manda perguntar? (empate OU margem ≤ 2 pp) */
  exigeDesempate: boolean;
  /** As duas em disputa, quando exigeDesempate. */
  emDisputa: [Config, Config] | null;

  /** Preenchidos quando o desempate já ocorreu. */
  desempateAplicado: boolean;
  animal: string;
}

const zeros = <T extends string>(ks: readonly T[]) =>
  Object.fromEntries(ks.map(k => [k, 0])) as Record<T, number>;

const arred = (n: number) => Math.round(n * 10) / 10;

/* ════════════════════════════════════════════════════════════════════════
   APURAÇÃO
   ══════════════════════════════════════════════════════════════════════ */
export function apurar(respostas: RespostaV2[]): Apuracao {
  /* Uma resposta por questão, e só alternativas que existem. Duplicatas ficam
     com a última — a interface já impede, mas o motor não confia nela. */
  const porQuestao = new Map<string, string>();
  for (const r of respostas) {
    if (!ALTERNATIVAS_VALIDAS.has(r.alternativaId)) continue;
    if (!r.alternativaId.startsWith(r.questaoId)) continue;   // alternativa de outra questão
    porQuestao.set(r.questaoId, r.alternativaId);
  }
  const escolhidas = [...porQuestao.values()];

  /* ── 1 · pontos brutos, com os pesos dos itens-âncora (seção 2.1) ───── */
  const bruto = zeros(CONFIGS);
  for (const alt of escolhidas) bruto[configDe(alt)] += pesoDe(alt);
  const totalPontos = Object.values(bruto).reduce((a, b) => a + b, 0);

  /* ── 2 · escore relativo (seção 2.2) ─────────────────────────────────── */
  const relativo = zeros(CONFIGS);
  if (totalPontos > 0)
    for (const c of CONFIGS) relativo[c] = arred((bruto[c] / totalPontos) * 100);

  /* ── 3 · atitudes e funções, por soma (seção 2.3) ────────────────────── */
  const atit = { E: 0, I: 0 };
  const funcoes = zeros(['T', 'F', 'S', 'N'] as const);
  for (const c of CONFIGS) {
    atit[CONFIG_INFO[c].atitude] += bruto[c];
    funcoes[CONFIG_INFO[c].funcao] += bruto[c];
  }
  const pct = (n: number) => (totalPontos > 0 ? arred((n / totalPontos) * 100) : 0);
  const funcoesRelativas = zeros(['T', 'F', 'S', 'N'] as const);
  for (const f of ['T', 'F', 'S', 'N'] as const) funcoesRelativas[f] = pct(funcoes[f]);

  /* Empate de atitude é possível neste modelo (ao contrário da v1.0, cuja soma
     ímpar o impedia). Resolve-se pela função dominante, não por convenção. */
  const dominanteAtitude: Atitude =
    atit.E > atit.I ? 'E' : atit.I > atit.E ? 'I' : (
      CONFIG_INFO[ordenar(bruto)[0]].atitude
    );

  /* ── 4 · ordem e faixas (seção 4) ────────────────────────────────────── */
  const ordem = ordenar(bruto);
  const primeiro = ordem[0], segundo = ordem[1];
  const margem = arred(relativo[primeiro] - relativo[segundo]);
  const amplitude = arred(relativo[primeiro] - relativo[ordem[7]]);
  const empateBruto = bruto[primeiro] === bruto[segundo];

  const classificacao: Classificacao =
    margem <= FAIXAS.HIBRIDO_MARGEM ? 'configuracao_equilibrada'
    : relativo[primeiro] >= FAIXAS.DEFINIDA_ESCORE && margem >= FAIXAS.DEFINIDA_MARGEM
      ? 'predominancia_definida'
    : relativo[primeiro] < FAIXAS.MODERADA_ESCORE && amplitude < FAIXAS.BAIXA_AMPLITUDE
      ? 'baixa_aderencia'
    : 'predominancia_moderada';

  /* ── 5 · secundária: par oposto obrigatório (seção 4.2) ──────────────── */
  const secundaria = auxiliarDe(primeiro, bruto);

  /* ── 6 · equilíbrio e conflito (seção 4.3) ───────────────────────────── */
  const vf = (['T', 'F', 'S', 'N'] as const).map(f => funcoesRelativas[f]);
  const equilibrioFuncional = Math.max(...vf) - Math.min(...vf) <= FAIXAS.EQUILIBRIO_FUNCOES;
  const equilibrioAtitude = Math.abs(pct(atit.E) - pct(atit.I)) <= FAIXAS.EQUILIBRIO_ATITUDE;
  const a = CONFIG_INFO[primeiro], b = CONFIG_INFO[segundo];
  const possivelConflito =
    a.atitude !== b.atitude && a.funcao === b.inferior && margem <= FAIXAS.CONFLITO_MARGEM;

  /* ── 7 · o adendo: precisa perguntar? ────────────────────────────────── */
  const exigeDesempate = empateBruto || margem <= FAIXAS.HIBRIDO_MARGEM;

  return {
    versao: 'v2.0-reavaliacao', versaoAlgoritmo: VERSAO_ALGORITMO,
    respostasValidas: escolhidas.length,
    completo: escolhidas.length === TOTAL_QUESTOES,
    bruto, relativo, totalPontos, ordem,
    atitudes: { E: atit.E, I: atit.I, relativoE: pct(atit.E), relativoI: pct(atit.I), dominante: dominanteAtitude },
    funcoes, funcoesRelativas,
    eixoCognitivo: arred(funcoesRelativas.N - funcoesRelativas.S),
    eixoRelacional: arred(funcoesRelativas.F - funcoesRelativas.T),
    orientacaoEnergia: arred(pct(atit.E) - pct(atit.I)),
    predominante: primeiro, secundaria, margem, amplitude, classificacao,
    equilibrioFuncional, equilibrioAtitude, possivelConflito,
    empateBruto, exigeDesempate,
    emDisputa: exigeDesempate ? [primeiro, segundo] : null,
    desempateAplicado: false,
    animal: CONFIG_INFO[primeiro].animal
  };
}

/**
 * Ordena as oito por pontos brutos. O critério de desempate da ORDEM segue a
 * cascata do gabarito (seção 5): D1 função, D2 atitude, D3 âncora, D4 ordem
 * canônica. Serve para haver uma ordem determinística; a disputa pelo primeiro
 * lugar é resolvida pela pergunta do adendo, não por aqui.
 */
function ordenar(bruto: Record<Config, number>): Config[] {
  const funcoes = zeros(['T', 'F', 'S', 'N'] as const);
  const atit = { E: 0, I: 0 };
  for (const c of CONFIGS) {
    funcoes[CONFIG_INFO[c].funcao] += bruto[c];
    atit[CONFIG_INFO[c].atitude] += bruto[c];
  }
  const canonica = (c: Config) => CONFIGS.indexOf(c);
  return [...CONFIGS].sort((x, y) =>
    bruto[y] - bruto[x]                                                  // pontos
    || funcoes[CONFIG_INFO[y].funcao] - funcoes[CONFIG_INFO[x].funcao]   // D1
    || atit[CONFIG_INFO[y].atitude] - atit[CONFIG_INFO[x].atitude]       // D2
    || canonica(x) - canonica(y));                                       // D4
}

/** Seção 4.2 — a auxiliar vem obrigatoriamente do par oposto ao da dominante. */
function auxiliarDe(dominante: Config, bruto: Record<Config, number>): Config {
  const fd = CONFIG_INFO[dominante].funcao;
  const parOposto: Funcao[] = fd === 'T' || fd === 'F' ? ['S', 'N'] : ['T', 'F'];
  const candidatas = CONFIGS.filter(c => parOposto.includes(CONFIG_INFO[c].funcao));
  return candidatas.sort((x, y) => bruto[y] - bruto[x] || CONFIGS.indexOf(x) - CONFIGS.indexOf(y))[0];
}

/* ════════════════════════════════════════════════════════════════════════
   DESEMPATE — adendo, seções 1 e 2
   ══════════════════════════════════════════════════════════════════════ */

export interface DesempateParaCliente {
  codigo: string;
  enunciado: string;
  /** Ordem SORTEADA. O cliente nunca sabe qual configuração cada uma pontua. */
  alternativas: { id: 'A' | 'B'; texto: string }[];
}

/**
 * Monta o item para exibição. A ordem é sorteada e devolvida em separado, para
 * ser gravada na auditoria — o adendo pede que a posição exibida seja
 * registrada, justamente para poder detectar viés de posição depois.
 */
export function prepararDesempate(ap: Apuracao, sorteio: number = Math.random()): {
  paraCliente: DesempateParaCliente;
  /** Só o servidor guarda: qual configuração está em cada posição. */
  mapaInterno: { A: Config; B: Config };
  item: ItemDesempate;
} {
  if (!ap.exigeDesempate || !ap.emDisputa)
    throw new Error('desempate solicitado sem disputa aberta');

  const item = itemDoPar(ap.emDisputa[0], ap.emDisputa[1]);
  const inverter = sorteio < 0.5;
  const [p, q] = inverter ? [item.alternativas[1], item.alternativas[0]] : item.alternativas;

  return {
    paraCliente: {
      codigo: item.codigo,
      enunciado: item.enunciado,
      alternativas: [{ id: 'A', texto: p.texto }, { id: 'B', texto: q.texto }]
    },
    mapaInterno: { A: p.p, B: q.p },
    item
  };
}

/**
 * Aplica a escolha. A configuração escolhida passa a ser a predominante — e é
 * ela que define o animal do totem.
 *
 * A classificação NÃO muda: se era `configuracao_equilibrada`, continua sendo.
 * O adendo é explícito quanto a isso — o desempate decide a entrega, não
 * converte equilíbrio em predominância.
 */
export function aplicarDesempate(
  ap: Apuracao,
  escolhida: Config
): Apuracao {
  if (!ap.emDisputa) throw new Error('não havia disputa a resolver');
  if (!ap.emDisputa.includes(escolhida))
    throw new Error(`${escolhida} não estava em disputa`);

  const outra = ap.emDisputa[0] === escolhida ? ap.emDisputa[1] : ap.emDisputa[0];
  return {
    ...ap,
    predominante: escolhida,
    secundaria: auxiliarDe(escolhida, ap.bruto),
    animal: CONFIG_INFO[escolhida].animal,
    ordem: [escolhida, outra, ...ap.ordem.filter(c => c !== escolhida && c !== outra)],
    exigeDesempate: false,
    desempateAplicado: true
  };
}

/**
 * A segunda configuração merece aparecer como leitura complementar?
 * Gabarito seção 4.1 + adendo seção 2: sim quando a margem é pequena.
 */
export function temComplementar(ap: Apuracao): boolean {
  return ap.classificacao === 'configuracao_equilibrada'
    || ap.margem <= FAIXAS.MODERADA_MARGEM * 2;   // ≤ 4 pp
}
