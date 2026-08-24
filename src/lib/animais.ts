/**
 * COMPOSIÇÃO SIMBÓLICA DAS EQUIPES — Partes I, J e item 66
 * ===========================================================================
 * FONTE ÚNICA DE AGREGAÇÃO DOS ANIMAIS.
 *
 * O dashboard, a matriz organizacional e as três abas novas do Excel chamam
 * EXATAMENTE estas funções. Não existe uma segunda contagem em lugar nenhum —
 * é isso que garante o item 67: se a tela mostra "MEC · Raposa · 8 · 20%", a
 * planilha mostra a mesma linha, com o mesmo arredondamento.
 *
 * NADA AQUI ALTERA CÁLCULO METODOLÓGICO. A associação perfil → animal, o
 * perfil predominante de cada pessoa e as cores são lidos de `src/data/profiles.ts`
 * sem modificação. Esta camada apenas CONTA e apresenta.
 *
 * Regras do prompt implementadas:
 *   item 50 — os oito animais já definidos, nenhum novo;
 *   item 51 — quantidade e percentual por animal;
 *   item 53 — categorias com zero continuam aparecendo;
 *   item 54 — maior representação relativa;
 *   item 55 — MENOR REPRESENTAÇÃO RELATIVA (nunca a palavra "lacuna");
 *   item 56 — a soma dos oito animais tem de bater com o total de avaliações
 *             válidas da equipe; se não bater, o sistema sinaliza.
 */
import { PERFIS, type PerfilId } from '../data/profiles';
import type { MembroAgregado } from './aggregate';

/** Arredondamento idêntico ao de aggregate.ts — uma casa decimal. */
const arred = (v: number) => Math.round(v * 10) / 10;

export interface LinhaAnimal {
  perfil: PerfilId;
  animal: string;
  /** Nome junguiano da configuração — ex.: 'Intuição Extrovertida'. */
  nomeJung: string;
  cor: string;
  n: number;
  pct: number;
}

export interface ComposicaoAnimais {
  equipe: string;
  /** Total de avaliações válidas concluídas da equipe. */
  total: number;
  /** Os OITO animais, sempre — inclusive os que estão em zero (item 53). */
  linhas: LinhaAnimal[];
  /** Item 54 — maior representação relativa. Nulo quando não há respondentes. */
  maisRepresentado: LinhaAnimal | null;
  /**
   * Item 55 — MENOR representação relativa entre os oito, incluindo zeros.
   * Deliberadamente NÃO se chama "lacuna": ausência de um animal não é falta.
   */
  menosRepresentado: LinhaAnimal | null;
  /** Item 56 — a soma bate com o total? */
  somaConfere: boolean;
  somaAnimais: number;
  /** Mensagem de inconsistência, quando `somaConfere` é falso. */
  inconsistencia: string | null;
}

/**
 * Composição de UMA equipe (ou da organização inteira, se receber todos os
 * membros). Os oito animais aparecem sempre, na ordem canônica dos perfis.
 */
export function composicaoAnimais(membros: MembroAgregado[], equipe = 'Organização'): ComposicaoAnimais {
  const total = membros.length;
  const cont: Record<string, number> = Object.fromEntries(PERFIS.map(p => [p.id, 0]));
  for (const m of membros) if (m.perfil in cont) cont[m.perfil]++;

  const linhas: LinhaAnimal[] = PERFIS.map(p => ({
    perfil: p.id,
    animal: p.animal,
    nomeJung: p.nomeJung,
    cor: p.cor,
    n: cont[p.id],
    pct: total ? arred((cont[p.id] / total) * 100) : 0
  }));

  const somaAnimais = linhas.reduce((s, l) => s + l.n, 0);
  const somaConfere = somaAnimais === total;

  // Maior e menor representação relativa. Empate resolvido pela ordem canônica
  // dos perfis, que é fixa — a leitura nunca muda de uma execução para outra.
  const ordenadas = [...linhas].sort((a, b) => b.n - a.n || a.perfil.localeCompare(b.perfil));
  const maisRepresentado = total ? ordenadas[0] : null;
  const menosRepresentado = total ? ordenadas[ordenadas.length - 1] : null;

  return {
    equipe, total, linhas, maisRepresentado, menosRepresentado, somaAnimais, somaConfere,
    inconsistencia: somaConfere ? null :
      `Inconsistência: a soma dos oito animais (${somaAnimais}) não coincide com o total de ` +
      `avaliações válidas da equipe ${equipe} (${total}). Verifique se há resultado com perfil ` +
      `fora dos oito perfis definidos.`
  };
}

export interface MatrizAnimais {
  /** Cabeçalho na ordem canônica dos perfis. */
  animais: { perfil: PerfilId; animal: string; cor: string }[];
  /** Uma linha por equipe, mais a linha de total organizacional. */
  equipes: ComposicaoAnimais[];
  organizacao: ComposicaoAnimais;
  /** Alguma equipe com soma inconsistente? */
  inconsistencias: string[];
}

/**
 * Matriz Equipe × Animal (Parte J). A ordem das equipes é alfabética, para que
 * a tela e a planilha listem na mesma sequência.
 */
export function matrizAnimais(membros: MembroAgregado[]): MatrizAnimais {
  const porEquipe: Record<string, MembroAgregado[]> = {};
  for (const m of membros) (porEquipe[m.setor] ||= []).push(m);

  const equipes = Object.keys(porEquipe).sort()
    .map(s => composicaoAnimais(porEquipe[s], s));
  const organizacao = composicaoAnimais(membros, 'Organização');

  return {
    animais: PERFIS.map(p => ({ perfil: p.id, animal: p.animal, cor: p.cor })),
    equipes,
    organizacao,
    inconsistencias: [...equipes, organizacao].map(e => e.inconsistencia).filter(Boolean) as string[]
  };
}

/**
 * Linhas planas para a aba "Composição dos Animais" do Excel (item 62).
 * Formato: Equipe | Animal | Quantidade | Percentual | Total da Equipe.
 */
export function linhasComposicaoParaExcel(m: MatrizAnimais) {
  const out: (string | number)[][] = [];
  for (const e of [...m.equipes, m.organizacao]) {
    for (const l of e.linhas) out.push([e.equipe, l.animal, l.n, l.pct, e.total]);
  }
  return out;
}

/** Linhas da matriz para o Excel (itens 63 e 64). `modo` escolhe o conteúdo. */
export function linhasMatrizParaExcel(m: MatrizAnimais, modo: 'quantidade' | 'percentual') {
  return [...m.equipes, m.organizacao].map(e => [
    e.equipe,
    ...e.linhas.map(l => (modo === 'quantidade' ? l.n : l.pct)),
    modo === 'quantidade' ? e.total : 100
  ]);
}

/** Cabeçalho da matriz, compartilhado entre tela e planilha. */
export function cabecalhoMatriz(m: MatrizAnimais) {
  return ['Equipe', ...m.animais.map(a => a.animal), 'Total'];
}
