/**
 * MATRIZ DE PONTUAÇÃO — CAMADA PÚBLICA
 * ---------------------------------------------------------------------------
 * Só o número da versão, o formato de uma linha e as listas de identificadores.
 * A matriz em si — que diz quanto cada alternativa soma em cada capacidade e em
 * cada proximidade Belbin — é chave de pontuação e vive em `scoringMatrix.ts`,
 * que é `server-only`.
 *
 * Os identificadores (`ANALISAR`, `MONITOR`, …) não revelam nada: eles nomeiam
 * as capacidades e os papéis, que já aparecem no glossário e nos relatórios.
 * O que era preciso proteger é a associação alternativa → peso.
 */
import type { Capacidade, PapelBelbin } from './functional';
import type { EixoAux, PoloJung } from './questions';

export const VERSAO_MATRIZ = 'v2.0';

export interface LinhaMatriz {
  questaoId: string;
  alternativaId: string;
  texto: string;
  peso: number;
  tipo: 'FUNCAO' | 'ATITUDE';
  contexto: string;
  jung: PoloJung;
  eixo: EixoAux;
  capacidades: Partial<Record<Capacidade, number>>;
  belbin: Partial<Record<PapelBelbin, number>>;
}

export const CHAVES_CAPACIDADE = [
  'CRIAR', 'EXPLORAR', 'ANALISAR', 'DECIDIR', 'ORGANIZAR',
  'EXECUTAR', 'RELACIONAR', 'COORDENAR', 'FINALIZAR', 'ESPECIALIZAR'
] as const;

export const CHAVES_BELBIN = [
  'PLANTA', 'INV_RECURSOS', 'COORDENADOR', 'FORMADOR', 'MONITOR',
  'IMPLEMENTADOR', 'TRAB_EQUIPE', 'FINALIZADOR', 'ESPECIALISTA'
] as const;

/**
 * Máximo teórico por capacidade e por papel — denominadores dos escores
 * relativos. São AGREGADOS: dizem quanto uma dimensão pode somar no
 * instrumento inteiro, não quanto cada alternativa contribui. Por isso podem
 * ficar aqui, na camada pública, e serem lidos pelas telas.
 *
 * São literais e não cálculo porque calcular exigiria a matriz. Para que não
 * possam divergir dela em silêncio, `npm run audit:matriz` recalcula os dois a
 * partir da matriz real e falha se algum número não bater.
 */
export const MAXIMO_CAPACIDADE: Record<string, number> = {
  CRIAR: 63, EXPLORAR: 58, ANALISAR: 78, DECIDIR: 41, ORGANIZAR: 53,
  EXECUTAR: 55, RELACIONAR: 84, COORDENAR: 61, FINALIZAR: 47, ESPECIALIZAR: 49
};

export const MAXIMO_BELBIN: Record<string, number> = {
  PLANTA: 74, INV_RECURSOS: 53, COORDENADOR: 56, FORMADOR: 41, MONITOR: 73,
  IMPLEMENTADOR: 72, TRAB_EQUIPE: 82, FINALIZADOR: 50, ESPECIALISTA: 58
};
