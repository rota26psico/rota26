/**
 * O FORMATO DO RESULTADO — CAMADA LIVRE DE CHAVE
 * ---------------------------------------------------------------------------
 * Só tipos e duas funções puras: `intensidade`, que é uma faixa sobre um número,
 * e `vetorDe`, que é uma projeção de um resultado já calculado. Nada aqui sabe
 * o que cada alternativa pontua.
 *
 * Existe separado de `scoring.ts` por um motivo concreto: aquele módulo importa
 * a chave e por isso é `server-only`. As telas e a agregação precisam do
 * FORMATO do resultado, não do que o produz — e é isso que mora aqui, podendo
 * chegar ao navegador sem levar o gabarito junto.
 */
import type { Atitude, Funcao, PerfilId } from '../data/profiles';
import type { EixoAux } from '../data/questions';
import type { Capacidade, PapelBelbin } from '../data/functional';

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
