/**
 * ETAPA 7 — ALGORITMO DETERMINÍSTICO EM DUAS TRILHAS PARALELAS (v2.0)
 * ===========================================================================
 * A IA NÃO decide perfil, animal, função, atitude, proximidade Belbin, IDF nem
 * ICF. Este módulo é puro: sem rede, sem aleatoriedade, sem IA.
 * Respostas idênticas produzem SEMPRE o mesmo resultado.
 *
 *   TRILHA A — funcionamento psicológico
 *     respostas → atitude + funções → 8 configurações → perfil principal e
 *     secundário → animal → luz e sombra
 *
 *   TRILHA B — funcionamento na equipe   (independente da trilha A)
 *     respostas → seis eixos comportamentais
 *              → dez capacidades funcionais
 *              → nove proximidades inspiradas em Belbin
 *
 * As duas trilhas partem das MESMAS 48 respostas, mas nenhuma é derivada da
 * outra. Por isso duas pessoas com o mesmo perfil junguiano podem — e
 * tipicamente vão — apresentar configurações funcionais diferentes.
 */

import {
  ALTERNATIVA_POR_ID, QUESTOES, MAXIMO_POR_EIXO, PARES_EIXO,
  PESO_TOTAL_ATITUDE, PESO_TOTAL_FUNCAO, VERSAO_INSTRUMENTO, type EixoAux
} from '../data/questions';
import {
  LINHA_POR_ALTERNATIVA, MAXIMO_CAPACIDADE, MAXIMO_BELBIN,
  CHAVES_CAPACIDADE, CHAVES_BELBIN, VERSAO_MATRIZ
} from '../data/scoringMatrix';
import {
  PERFIL_POR_ID, perfilDe, OPOSTA, NOME_FUNCAO,
  type Atitude, type Funcao, type PerfilId
} from '../data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN, type Capacidade, type PapelBelbin } from '../data/functional';

export interface Resposta { questaoId: string; alternativaId: string; }

export type Intensidade = 'Muito alta' | 'Alta' | 'Moderada' | 'Baixa' | 'Muito baixa';

/** Faixas dos rótulos de intensidade — parâmetros internos exploratórios. */
export function intensidade(v: number): Intensidade {
  if (v >= 60) return 'Muito alta';
  if (v >= 45) return 'Alta';
  if (v >= 30) return 'Moderada';
  if (v >= 18) return 'Baixa';
  return 'Muito baixa';
}

export interface EscoresJung {
  bruto: Record<'E' | 'I' | 'T' | 'F' | 'S' | 'N', number>;
  relativo: Record<'E' | 'I' | 'T' | 'F' | 'S' | 'N', number>;
}
export interface EscoresEixos {
  bruto: Record<EixoAux, number>;
  relativo: Record<EixoAux, number>;
}
export interface EscoresFuncionais {
  capacidadesBruto: Record<Capacidade, number>;
  capacidades: Record<Capacidade, number>;      // relativo 0–100
  belbinBruto: Record<PapelBelbin, number>;
  belbin: Record<PapelBelbin, number>;          // relativo 0–100
}

export interface ResultadoIndividual {
  versao: string;
  versaoMatriz: string;

  /* ── TRILHA A ── */
  escores: EscoresJung & { eixos: EscoresEixos; denominadores: { atitude: number; funcao: number } };
  atitude: Atitude;
  atitudeMargem: number;
  funcaoDominante: Funcao;
  funcaoAuxiliar: Funcao;
  funcaoMenosRepresentada: Funcao;
  funcaoInferior: Funcao;
  ordemFuncoes: Funcao[];
  perfilPrincipal: PerfilId;
  perfilSecundario: PerfilId;
  empateFuncoes: boolean;
  regraDesempate: string | null;

  /* ── TRILHA B ── */
  funcional: EscoresFuncionais;
  capacidadesOrdenadas: { id: Capacidade; nome: string; valor: number; intensidade: Intensidade }[];
  belbinOrdenado: { id: PapelBelbin; nome: string; valor: number; intensidade: Intensidade; posicao: number }[];
  top3Belbin: { id: PapelBelbin; nome: string; valor: number; intensidade: Intensidade; posicao: number }[];

  eixosAuxiliares: { par: [EixoAux, EixoAux]; polo: EixoAux | 'equilibrado'; a: number; b: number }[];

  respostasValidas: number;
  completo: boolean;
}

const zeroDe = <K extends string>(ks: readonly K[]) =>
  Object.fromEntries(ks.map(k => [k, 0])) as Record<K, number>;

const arred = (v: number) => Math.round(v * 10) / 10;
const pct = (v: number, max: number) => (max > 0 ? arred((v / max) * 100) : 0);

/** Normaliza as respostas: uma por questão, chave válida, sem duplicatas. */
function respostasValidas(respostas: Resposta[]) {
  const vistas = new Set<string>();
  const out: { questaoId: string; alternativaId: string; peso: number }[] = [];
  for (const r of respostas) {
    const alt = ALTERNATIVA_POR_ID[r.alternativaId];
    if (!alt || alt.questaoId !== r.questaoId) continue;
    if (vistas.has(r.questaoId)) continue;
    vistas.add(r.questaoId);
    out.push({ questaoId: r.questaoId, alternativaId: r.alternativaId, peso: alt.peso });
  }
  return out;
}

/* ═══════════════════════ TRILHA A — psicológica ═══════════════════════════ */

export function calcularEscores(respostas: Resposta[]) {
  const validas = respostasValidas(respostas);
  const jung = zeroDe(['E', 'I', 'T', 'F', 'S', 'N'] as const);
  const eixos = zeroDe(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const);

  for (const v of validas) {
    const alt = ALTERNATIVA_POR_ID[v.alternativaId];
    jung[alt.jung] += v.peso;
    eixos[alt.eixo] += v.peso;
  }

  const relJung = {
    E: pct(jung.E, PESO_TOTAL_ATITUDE), I: pct(jung.I, PESO_TOTAL_ATITUDE),
    T: pct(jung.T, PESO_TOTAL_FUNCAO), F: pct(jung.F, PESO_TOTAL_FUNCAO),
    S: pct(jung.S, PESO_TOTAL_FUNCAO), N: pct(jung.N, PESO_TOTAL_FUNCAO)
  };
  const relEixos = Object.fromEntries(
    (Object.keys(eixos) as EixoAux[]).map(e => [e, pct(eixos[e], MAXIMO_POR_EIXO[e])])
  ) as Record<EixoAux, number>;

  return {
    bruto: jung, relativo: relJung,
    eixos: { bruto: eixos, relativo: relEixos },
    denominadores: { atitude: PESO_TOTAL_ATITUDE, funcao: PESO_TOTAL_FUNCAO }
  };
}

/**
 * Regras de determinação do perfil (inalteradas na v2.0 — preservadas).
 * Atitude: maior bruto. E+I é ímpar por construção do banco, logo não há empate.
 * Função dominante: maior bruto; empate resolvido por D1 → D2 → D3 (ver abaixo).
 * Auxiliar: melhor função do OUTRO par de opostos (regra junguiana).
 */
export function determinarPerfil(escores: ReturnType<typeof calcularEscores>) {
  const b = escores.bruto;
  const atitude: Atitude = b.E > b.I ? 'E' : b.I > b.E ? 'I' : 'E';
  const funcoes: Funcao[] = ['T', 'F', 'S', 'N'];
  const max = Math.max(...funcoes.map(f => b[f]));
  const empatadas = funcoes.filter(f => b[f] === max);

  let dominante = empatadas[0];
  let regraDesempate: string | null = null;
  const empateFuncoes = empatadas.length > 1;

  if (empateFuncoes) {
    const dist = (f: Funcao) => b[f] - b[OPOSTA[f]];
    const maxDist = Math.max(...empatadas.map(dist));
    let cand = empatadas.filter(f => dist(f) === maxDist);
    regraDesempate = 'D1: vence a função cuja oposta tem o menor escore (maior diferenciação).';
    if (cand.length > 1) {
      const afim = (f: Funcao) => (f === 'T' || f === 'S'
        ? escores.eixos.bruto.EST + escores.eixos.bruto.EXE
        : escores.eixos.bruto.COO + escores.eixos.bruto.EXP);
      const maxAfim = Math.max(...cand.map(afim));
      cand = cand.filter(f => afim(f) === maxAfim);
      regraDesempate += ' D2: desempate por evidência convergente nos eixos comportamentais.';
    }
    if (cand.length > 1) {
      const ordem: Funcao[] = ['T', 'S', 'F', 'N'];
      cand = [ordem.find(f => cand.includes(f))!];
      regraDesempate += ' D3: ordem canônica fixa (critério arbitrário de último recurso).';
    }
    dominante = cand[0];
  }

  const outroPar: Funcao[] = dominante === 'T' || dominante === 'F' ? ['S', 'N'] : ['T', 'F'];
  const auxiliar: Funcao = b[outroPar[0]] >= b[outroPar[1]] ? outroPar[0] : outroPar[1];
  const ordemFuncoes = [...funcoes].sort((x, y) =>
    b[y] - b[x] || (['T', 'S', 'F', 'N'].indexOf(x) - ['T', 'S', 'F', 'N'].indexOf(y)));

  return {
    atitude, atitudeMargem: Math.abs(b.E - b.I),
    funcaoDominante: dominante, funcaoAuxiliar: auxiliar,
    funcaoMenosRepresentada: ordemFuncoes[3], funcaoInferior: OPOSTA[dominante],
    ordemFuncoes,
    perfilPrincipal: perfilDe(atitude, dominante).id,
    perfilSecundario: perfilDe(atitude, auxiliar).id,
    empateFuncoes, regraDesempate
  };
}

/* ═══════════════════════ TRILHA B — funcional ═════════════════════════════ */

/**
 * Calcula capacidades e proximidades Belbin A PARTIR DAS RESPOSTAS.
 * Nenhuma consulta ao perfil junguiano acontece aqui — é o ponto central da
 * refatoração. Cada alternativa escolhida soma suas próprias contribuições,
 * multiplicadas pelo peso do item; o total é normalizado pelo máximo obtenível.
 */
export function calcularFuncional(respostas: Resposta[]): EscoresFuncionais {
  const validas = respostasValidas(respostas);
  const cap = zeroDe(CHAVES_CAPACIDADE);
  const bel = zeroDe(CHAVES_BELBIN);

  for (const v of validas) {
    const linha = LINHA_POR_ALTERNATIVA[v.alternativaId];
    if (!linha) continue;
    for (const [k, w] of Object.entries(linha.capacidades)) cap[k as Capacidade] += (w as number) * v.peso;
    for (const [k, w] of Object.entries(linha.belbin)) bel[k as PapelBelbin] += (w as number) * v.peso;
  }

  return {
    capacidadesBruto: cap,
    capacidades: Object.fromEntries(CHAVES_CAPACIDADE.map(k =>
      [k, pct(cap[k], MAXIMO_CAPACIDADE[k])])) as Record<Capacidade, number>,
    belbinBruto: bel,
    belbin: Object.fromEntries(CHAVES_BELBIN.map(k =>
      [k, pct(bel[k], MAXIMO_BELBIN[k])])) as Record<PapelBelbin, number>
  };
}

/* ═════════════════════════ Pipeline completo ══════════════════════════════ */

export function avaliar(respostas: Resposta[]): ResultadoIndividual {
  const escores = calcularEscores(respostas);
  const perfil = determinarPerfil(escores);
  const funcional = calcularFuncional(respostas);

  const capacidadesOrdenadas = CAPACIDADES
    .map(c => ({ id: c.id, nome: c.nome, valor: funcional.capacidades[c.id], intensidade: intensidade(funcional.capacidades[c.id]) }))
    // desempate estável por ordem canônica das capacidades — mantém determinismo
    .sort((a, b) => b.valor - a.valor || CAPACIDADES.findIndex(c => c.id === a.id) - CAPACIDADES.findIndex(c => c.id === b.id));

  const belbinOrdenado = PAPEIS_BELBIN
    .map(p => ({ id: p.id, nome: p.nome, valor: funcional.belbin[p.id], intensidade: intensidade(funcional.belbin[p.id]) }))
    .sort((a, b) => b.valor - a.valor || PAPEIS_BELBIN.findIndex(p => p.id === a.id) - PAPEIS_BELBIN.findIndex(p => p.id === b.id))
    .map((x, i) => ({ ...x, posicao: i + 1 }));

  const eixosAuxiliares = PARES_EIXO.map(([x, y]) => {
    const a = escores.eixos.relativo[x], c = escores.eixos.relativo[y];
    return { par: [x, y] as [EixoAux, EixoAux], polo: (a > c ? x : c > a ? y : 'equilibrado') as EixoAux | 'equilibrado', a, b: c };
  });

  const validas = respostasValidas(respostas).length;

  return {
    versao: VERSAO_INSTRUMENTO, versaoMatriz: VERSAO_MATRIZ,
    escores, ...perfil,
    funcional, capacidadesOrdenadas, belbinOrdenado,
    top3Belbin: belbinOrdenado.slice(0, 3),
    eixosAuxiliares,
    respostasValidas: validas,
    completo: validas === QUESTOES.length
  };
}

/** Vetor completo do participante — base da agregação por equipe (item 38). */
export interface VetorParticipante {
  perfil: PerfilId; perfilSecundario: PerfilId; atitude: Atitude; funcaoDominante: Funcao;
  jung: Record<'E' | 'I' | 'T' | 'F' | 'S' | 'N', number>;
  eixos: Record<EixoAux, number>;
  capacidades: Record<Capacidade, number>;
  belbin: Record<PapelBelbin, number>;
}

export const vetorDe = (r: ResultadoIndividual): VetorParticipante => ({
  perfil: r.perfilPrincipal, perfilSecundario: r.perfilSecundario,
  atitude: r.atitude, funcaoDominante: r.funcaoDominante,
  jung: r.escores.relativo, eixos: r.escores.eixos.relativo,
  capacidades: r.funcional.capacidades, belbin: r.funcional.belbin
});

export { CAPACIDADES, PAPEIS_BELBIN, PERFIL_POR_ID, NOME_FUNCAO };
