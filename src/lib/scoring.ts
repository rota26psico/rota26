import 'server-only';
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

import { PARES_EIXO, VERSAO_INSTRUMENTO, VERSAO_ALGORITMO, type EixoAux } from '../data/questions';
/* A chave de pontuação vem da camada de servidor. É o que impede este módulo —
   e tudo que o importa — de chegar ao navegador com o gabarito junto. */
import {
  ALTERNATIVA_POR_ID, QUESTOES_COMPLETAS as QUESTOES, MAXIMO_POR_EIXO,
  PESO_TOTAL_ATITUDE, PESO_TOTAL_FUNCAO
} from '../data/questions.server';
import {
  LINHA_POR_ALTERNATIVA, MAXIMO_CAPACIDADE, MAXIMO_BELBIN,
  CHAVES_CAPACIDADE, CHAVES_BELBIN, VERSAO_MATRIZ
} from '../data/scoringMatrix';
import {
  PERFIL_POR_ID, perfilDe, OPOSTA, NOME_FUNCAO,
  type Atitude, type Funcao, type PerfilId
} from '../data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN, type Capacidade, type PapelBelbin } from '../data/functional';

import {
  intensidade, vetorDe,
  type Resposta, type Intensidade, type EscoresJung, type EscoresEixos,
  type EscoresFuncionais, type ResultadoIndividual, type VetorParticipante
} from './resultado';
/* Reexportados para que quem já importava de `scoring` continue funcionando. */
export {
  intensidade, vetorDe,
  type Resposta, type Intensidade, type EscoresJung, type EscoresEixos,
  type EscoresFuncionais, type ResultadoIndividual, type VetorParticipante
};


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

/** Ordem canônica das funções. Último recurso do desempate e da ordenação. */
const ORDEM_CANONICA: readonly Funcao[] = ['T', 'S', 'F', 'N'] as const;

/**
 * A CASCATA DE DESEMPATE — D1 → D2 → D3
 * ---------------------------------------------------------------------------
 * Extraída de `determinarPerfil` para poder ser aplicada nos DOIS pontos em que
 * um empate decide um perfil: a função dominante (perfil principal) e a função
 * auxiliar (perfil secundário). Até `v1.0-piloto` só a dominante passava por
 * aqui; o empate da auxiliar era resolvido em silêncio pelo primeiro elemento do
 * par, sem registro nenhum — de fora, isso era indistinguível de um sorteio.
 *
 *   D1  vence a função cuja OPOSTA tem o menor escore. Entre funções empatadas,
 *       `b[f] - b[OPOSTA[f]]` mede o quanto o par está diferenciado.
 *   D2  evidência convergente nos eixos comportamentais: T e S se apoiam em
 *       Estrutura + Execução; F e N, em Cooperação + Exploração.
 *   D3  ordem canônica fixa. É arbitrário e o texto diz isso.
 *
 * Determinística por construção: sem `Math.random`, sem `sort` instável, sem
 * dependência da ordem de iteração de objeto. As mesmas respostas produzem
 * sempre o mesmo vencedor E o mesmo texto de regra.
 *
 * O texto só menciona um degrau que EFETIVAMENTE reduziu o conjunto. Antes, D2
 * era anunciado sempre que a linha rodava, inclusive quando não eliminava
 * ninguém — e o banco guardava "D2 foi aplicado" para casos resolvidos em D3.
 */
export function desempatar(
  candidatas: Funcao[],
  bruto: Record<'E' | 'I' | 'T' | 'F' | 'S' | 'N', number>,
  eixos: Record<EixoAux, number>
): { vencedora: Funcao; regra: string | null } {
  if (candidatas.length === 1) return { vencedora: candidatas[0], regra: null };

  const degraus: string[] = [];
  let cand = candidatas;

  // D1 — diferenciação em relação à função oposta.
  const dist = (f: Funcao) => bruto[f] - bruto[OPOSTA[f]];
  const maxDist = Math.max(...cand.map(dist));
  const aposD1 = cand.filter(f => dist(f) === maxDist);
  if (aposD1.length < cand.length) {
    degraus.push('D1: vence a função cuja oposta tem o menor escore (maior diferenciação).');
    cand = aposD1;
  }

  // D2 — evidência convergente nos eixos comportamentais.
  if (cand.length > 1) {
    const afim = (f: Funcao) => (f === 'T' || f === 'S'
      ? eixos.EST + eixos.EXE
      : eixos.COO + eixos.EXP);
    const maxAfim = Math.max(...cand.map(afim));
    const aposD2 = cand.filter(f => afim(f) === maxAfim);
    if (aposD2.length < cand.length) {
      degraus.push('D2: desempate por evidência convergente nos eixos comportamentais.');
      cand = aposD2;
    }
  }

  // D3 — ordem canônica. Sempre resolve, por isso fecha a cascata.
  if (cand.length > 1) {
    degraus.push('D3: ordem canônica fixa (critério arbitrário de último recurso).');
    cand = [ORDEM_CANONICA.find(f => cand.includes(f))!];
  }

  return { vencedora: cand[0], regra: degraus.join(' ') };
}

/**
 * Regras de determinação do perfil.
 * Atitude: maior bruto. E+I é ímpar por construção do banco, logo não há empate
 *   — `audit:itens` falha se o peso total de atitude virar par.
 * Função dominante: maior bruto; empate resolvido por D1 → D2 → D3.
 * Auxiliar: melhor função do OUTRO par de opostos (regra junguiana); empate
 *   resolvido pela MESMA cascata, e declarado — ver `desempatar`.
 */
export function determinarPerfil(escores: ReturnType<typeof calcularEscores>) {
  const b = escores.bruto;
  const eixos = escores.eixos.bruto;
  const atitude: Atitude = b.E > b.I ? 'E' : b.I > b.E ? 'I' : 'E';
  const funcoes: Funcao[] = ['T', 'F', 'S', 'N'];

  const max = Math.max(...funcoes.map(f => b[f]));
  const empatadas = funcoes.filter(f => b[f] === max);
  const empateFuncoes = empatadas.length > 1;
  const d = desempatar(empatadas, b, eixos);
  const dominante = d.vencedora;
  const regraDesempate = d.regra;

  /* A auxiliar vem obrigatoriamente do par de opostos que NÃO contém a
     dominante — é a regra junguiana, não uma escolha de implementação. */
  const outroPar: Funcao[] = dominante === 'T' || dominante === 'F' ? ['S', 'N'] : ['T', 'F'];
  const maxAux = Math.max(...outroPar.map(f => b[f]));
  const empatadasAux = outroPar.filter(f => b[f] === maxAux);
  const empateAuxiliar = empatadasAux.length > 1;
  const dAux = desempatar(empatadasAux, b, eixos);
  const auxiliar = dAux.vencedora;
  const regraDesempateAuxiliar = dAux.regra;

  const ordemFuncoes = [...funcoes].sort((x, y) =>
    b[y] - b[x] || (ORDEM_CANONICA.indexOf(x) - ORDEM_CANONICA.indexOf(y)));

  return {
    atitude, atitudeMargem: Math.abs(b.E - b.I),
    funcaoDominante: dominante, funcaoAuxiliar: auxiliar,
    funcaoMenosRepresentada: ordemFuncoes[3], funcaoInferior: OPOSTA[dominante],
    ordemFuncoes,
    perfilPrincipal: perfilDe(atitude, dominante).id,
    perfilSecundario: perfilDe(atitude, auxiliar).id,
    empateFuncoes, regraDesempate,
    empateAuxiliar, regraDesempateAuxiliar
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
    versao: VERSAO_INSTRUMENTO, versaoAlgoritmo: VERSAO_ALGORITMO, versaoMatriz: VERSAO_MATRIZ,
    escores, ...perfil,
    funcional, capacidadesOrdenadas, belbinOrdenado,
    top3Belbin: belbinOrdenado.slice(0, 3),
    eixosAuxiliares,
    respostasValidas: validas,
    completo: validas === QUESTOES.length
  };
}


export { CAPACIDADES, PAPEIS_BELBIN, PERFIL_POR_ID, NOME_FUNCAO };
