import 'server-only';
/**
 * AS 48 SITUAÇÕES — CHAVE DE PONTUAÇÃO (CAMADA DE SERVIDOR)
 * ---------------------------------------------------------------------------
 * ESTE ARQUIVO É O GABARITO. Ele diz, para cada uma das 192 alternativas, qual
 * polo junguiano e qual eixo comportamental ela pontua, e quanto pesa cada item.
 *
 * `import 'server-only'` na primeira linha não é convenção: é a trava. Se algum
 * componente de cliente importar este módulo, direta ou indiretamente, o
 * `next build` FALHA. Foi assim que a v2.0 resolveu o mesmo problema, e é o
 * mesmo mecanismo aqui.
 *
 * Os textos NÃO estão duplicados: eles vivem em `questions.ts`, e este arquivo
 * apenas os complementa por id. `npm run audit:itens` confere que as duas
 * camadas cobrem exatamente o mesmo conjunto.
 */
import { QUESTOES, type EixoAux, type PoloJung, type TipoItem } from './questions';

/** Peso e tipo de cada item. Peso 2 marca as âncoras. */
export const ITEM: Record<string, { tipo: TipoItem; peso: number }> = {
  Q001: { tipo: "FUNCAO", peso: 2 },
  Q002: { tipo: "ATITUDE", peso: 1 },
  Q003: { tipo: "FUNCAO", peso: 1 },
  Q004: { tipo: "ATITUDE", peso: 1 },
  Q005: { tipo: "FUNCAO", peso: 1 },
  Q006: { tipo: "ATITUDE", peso: 2 },
  Q007: { tipo: "FUNCAO", peso: 1 },
  Q008: { tipo: "ATITUDE", peso: 1 },
  Q009: { tipo: "FUNCAO", peso: 1 },
  Q010: { tipo: "ATITUDE", peso: 1 },
  Q011: { tipo: "FUNCAO", peso: 1 },
  Q012: { tipo: "ATITUDE", peso: 1 },
  Q013: { tipo: "FUNCAO", peso: 2 },
  Q014: { tipo: "ATITUDE", peso: 1 },
  Q015: { tipo: "FUNCAO", peso: 1 },
  Q016: { tipo: "ATITUDE", peso: 1 },
  Q017: { tipo: "FUNCAO", peso: 1 },
  Q018: { tipo: "ATITUDE", peso: 1 },
  Q019: { tipo: "FUNCAO", peso: 1 },
  Q020: { tipo: "ATITUDE", peso: 1 },
  Q021: { tipo: "FUNCAO", peso: 1 },
  Q022: { tipo: "ATITUDE", peso: 1 },
  Q023: { tipo: "FUNCAO", peso: 1 },
  Q024: { tipo: "ATITUDE", peso: 1 },
  Q025: { tipo: "FUNCAO", peso: 1 },
  Q026: { tipo: "ATITUDE", peso: 2 },
  Q027: { tipo: "FUNCAO", peso: 1 },
  Q028: { tipo: "ATITUDE", peso: 1 },
  Q029: { tipo: "FUNCAO", peso: 1 },
  Q030: { tipo: "ATITUDE", peso: 1 },
  Q031: { tipo: "FUNCAO", peso: 1 },
  Q032: { tipo: "ATITUDE", peso: 1 },
  Q033: { tipo: "FUNCAO", peso: 1 },
  Q034: { tipo: "ATITUDE", peso: 1 },
  Q035: { tipo: "FUNCAO", peso: 1 },
  Q036: { tipo: "ATITUDE", peso: 1 },
  Q037: { tipo: "FUNCAO", peso: 1 },
  Q038: { tipo: "ATITUDE", peso: 1 },
  Q039: { tipo: "FUNCAO", peso: 1 },
  Q040: { tipo: "ATITUDE", peso: 1 },
  Q041: { tipo: "FUNCAO", peso: 1 },
  Q042: { tipo: "ATITUDE", peso: 2 },
  Q043: { tipo: "FUNCAO", peso: 1 },
  Q044: { tipo: "ATITUDE", peso: 1 },
  Q045: { tipo: "FUNCAO", peso: 1 },
  Q046: { tipo: "ATITUDE", peso: 1 },
  Q047: { tipo: "FUNCAO", peso: 2 },
  Q048: { tipo: "ATITUDE", peso: 1 }
};

/** A chave: alternativa → polo junguiano e eixo comportamental. */
export const CHAVE: Record<string, { jung: PoloJung; eixo: EixoAux }> = {
  Q001A: { jung: "T", eixo: "EST" },
  Q001B: { jung: "F", eixo: "COO" },
  Q001C: { jung: "S", eixo: "EXE" },
  Q001D: { jung: "N", eixo: "EXP" },
  Q002A: { jung: "E", eixo: "FLE" },
  Q002B: { jung: "E", eixo: "COO" },
  Q002C: { jung: "I", eixo: "AUT" },
  Q002D: { jung: "I", eixo: "EST" },
  Q003A: { jung: "T", eixo: "EST" },
  Q003B: { jung: "F", eixo: "COO" },
  Q003C: { jung: "S", eixo: "EXE" },
  Q003D: { jung: "N", eixo: "EXP" },
  Q004A: { jung: "E", eixo: "COO" },
  Q004B: { jung: "E", eixo: "FLE" },
  Q004C: { jung: "I", eixo: "AUT" },
  Q004D: { jung: "I", eixo: "EST" },
  Q005A: { jung: "T", eixo: "AUT" },
  Q005B: { jung: "F", eixo: "COO" },
  Q005C: { jung: "S", eixo: "EXE" },
  Q005D: { jung: "N", eixo: "EXP" },
  Q006A: { jung: "E", eixo: "COO" },
  Q006B: { jung: "E", eixo: "EXE" },
  Q006C: { jung: "I", eixo: "AUT" },
  Q006D: { jung: "I", eixo: "EST" },
  Q007A: { jung: "T", eixo: "AUT" },
  Q007B: { jung: "F", eixo: "COO" },
  Q007C: { jung: "S", eixo: "EXE" },
  Q007D: { jung: "N", eixo: "EXP" },
  Q008A: { jung: "E", eixo: "FLE" },
  Q008B: { jung: "E", eixo: "EXP" },
  Q008C: { jung: "I", eixo: "EST" },
  Q008D: { jung: "I", eixo: "AUT" },
  Q009A: { jung: "T", eixo: "EST" },
  Q009B: { jung: "F", eixo: "COO" },
  Q009C: { jung: "S", eixo: "EXE" },
  Q009D: { jung: "N", eixo: "EXP" },
  Q010A: { jung: "E", eixo: "FLE" },
  Q010B: { jung: "E", eixo: "COO" },
  Q010C: { jung: "I", eixo: "AUT" },
  Q010D: { jung: "I", eixo: "EST" },
  Q011A: { jung: "T", eixo: "AUT" },
  Q011B: { jung: "F", eixo: "COO" },
  Q011C: { jung: "S", eixo: "EXE" },
  Q011D: { jung: "N", eixo: "EXP" },
  Q012A: { jung: "E", eixo: "EXP" },
  Q012B: { jung: "E", eixo: "COO" },
  Q012C: { jung: "I", eixo: "AUT" },
  Q012D: { jung: "I", eixo: "EST" },
  Q013A: { jung: "T", eixo: "AUT" },
  Q013B: { jung: "F", eixo: "COO" },
  Q013C: { jung: "S", eixo: "EST" },
  Q013D: { jung: "N", eixo: "EXP" },
  Q014A: { jung: "E", eixo: "COO" },
  Q014B: { jung: "E", eixo: "EXE" },
  Q014C: { jung: "I", eixo: "AUT" },
  Q014D: { jung: "I", eixo: "EST" },
  Q015A: { jung: "T", eixo: "EST" },
  Q015B: { jung: "F", eixo: "COO" },
  Q015C: { jung: "S", eixo: "EXE" },
  Q015D: { jung: "N", eixo: "FLE" },
  Q016A: { jung: "E", eixo: "COO" },
  Q016B: { jung: "E", eixo: "FLE" },
  Q016C: { jung: "I", eixo: "AUT" },
  Q016D: { jung: "I", eixo: "EST" },
  Q017A: { jung: "T", eixo: "FLE" },
  Q017B: { jung: "F", eixo: "COO" },
  Q017C: { jung: "S", eixo: "EXE" },
  Q017D: { jung: "N", eixo: "EXP" },
  Q018A: { jung: "E", eixo: "FLE" },
  Q018B: { jung: "E", eixo: "COO" },
  Q018C: { jung: "I", eixo: "EST" },
  Q018D: { jung: "I", eixo: "AUT" },
  Q019A: { jung: "T", eixo: "EST" },
  Q019B: { jung: "F", eixo: "FLE" },
  Q019C: { jung: "S", eixo: "EXE" },
  Q019D: { jung: "N", eixo: "EXP" },
  Q020A: { jung: "E", eixo: "COO" },
  Q020B: { jung: "E", eixo: "EXE" },
  Q020C: { jung: "I", eixo: "AUT" },
  Q020D: { jung: "I", eixo: "EST" },
  Q021A: { jung: "T", eixo: "EST" },
  Q021B: { jung: "F", eixo: "COO" },
  Q021C: { jung: "S", eixo: "EXE" },
  Q021D: { jung: "N", eixo: "EXP" },
  Q022A: { jung: "E", eixo: "COO" },
  Q022B: { jung: "E", eixo: "FLE" },
  Q022C: { jung: "I", eixo: "AUT" },
  Q022D: { jung: "I", eixo: "EST" },
  Q023A: { jung: "T", eixo: "AUT" },
  Q023B: { jung: "F", eixo: "EXP" },
  Q023C: { jung: "S", eixo: "EXE" },
  Q023D: { jung: "N", eixo: "FLE" },
  Q024A: { jung: "E", eixo: "COO" },
  Q024B: { jung: "E", eixo: "EXE" },
  Q024C: { jung: "I", eixo: "AUT" },
  Q024D: { jung: "I", eixo: "EST" },
  Q025A: { jung: "T", eixo: "AUT" },
  Q025B: { jung: "F", eixo: "COO" },
  Q025C: { jung: "S", eixo: "EST" },
  Q025D: { jung: "N", eixo: "EXP" },
  Q026A: { jung: "E", eixo: "COO" },
  Q026B: { jung: "E", eixo: "EXP" },
  Q026C: { jung: "I", eixo: "AUT" },
  Q026D: { jung: "I", eixo: "EST" },
  Q027A: { jung: "T", eixo: "AUT" },
  Q027B: { jung: "F", eixo: "COO" },
  Q027C: { jung: "S", eixo: "EXE" },
  Q027D: { jung: "N", eixo: "EST" },
  Q028A: { jung: "E", eixo: "FLE" },
  Q028B: { jung: "E", eixo: "EXP" },
  Q028C: { jung: "I", eixo: "AUT" },
  Q028D: { jung: "I", eixo: "EST" },
  Q029A: { jung: "T", eixo: "AUT" },
  Q029B: { jung: "F", eixo: "COO" },
  Q029C: { jung: "S", eixo: "EXE" },
  Q029D: { jung: "N", eixo: "FLE" },
  Q030A: { jung: "E", eixo: "COO" },
  Q030B: { jung: "E", eixo: "EXE" },
  Q030C: { jung: "I", eixo: "AUT" },
  Q030D: { jung: "I", eixo: "EST" },
  Q031A: { jung: "T", eixo: "AUT" },
  Q031B: { jung: "F", eixo: "COO" },
  Q031C: { jung: "S", eixo: "EXE" },
  Q031D: { jung: "N", eixo: "EXP" },
  Q032A: { jung: "E", eixo: "COO" },
  Q032B: { jung: "E", eixo: "FLE" },
  Q032C: { jung: "I", eixo: "AUT" },
  Q032D: { jung: "I", eixo: "EST" },
  Q033A: { jung: "T", eixo: "EST" },
  Q033B: { jung: "F", eixo: "COO" },
  Q033C: { jung: "S", eixo: "EXE" },
  Q033D: { jung: "N", eixo: "AUT" },
  Q034A: { jung: "E", eixo: "COO" },
  Q034B: { jung: "E", eixo: "FLE" },
  Q034C: { jung: "I", eixo: "AUT" },
  Q034D: { jung: "I", eixo: "EST" },
  Q035A: { jung: "T", eixo: "EST" },
  Q035B: { jung: "F", eixo: "FLE" },
  Q035C: { jung: "S", eixo: "EXE" },
  Q035D: { jung: "N", eixo: "EXP" },
  Q036A: { jung: "E", eixo: "FLE" },
  Q036B: { jung: "E", eixo: "COO" },
  Q036C: { jung: "I", eixo: "AUT" },
  Q036D: { jung: "I", eixo: "EST" },
  Q037A: { jung: "T", eixo: "AUT" },
  Q037B: { jung: "F", eixo: "EST" },
  Q037C: { jung: "S", eixo: "EXE" },
  Q037D: { jung: "N", eixo: "EXP" },
  Q038A: { jung: "E", eixo: "EXP" },
  Q038B: { jung: "E", eixo: "FLE" },
  Q038C: { jung: "I", eixo: "AUT" },
  Q038D: { jung: "I", eixo: "EST" },
  Q039A: { jung: "T", eixo: "AUT" },
  Q039B: { jung: "F", eixo: "COO" },
  Q039C: { jung: "S", eixo: "EXE" },
  Q039D: { jung: "N", eixo: "FLE" },
  Q040A: { jung: "E", eixo: "COO" },
  Q040B: { jung: "E", eixo: "FLE" },
  Q040C: { jung: "I", eixo: "AUT" },
  Q040D: { jung: "I", eixo: "EST" },
  Q041A: { jung: "T", eixo: "AUT" },
  Q041B: { jung: "F", eixo: "COO" },
  Q041C: { jung: "S", eixo: "EXE" },
  Q041D: { jung: "N", eixo: "EXP" },
  Q042A: { jung: "E", eixo: "COO" },
  Q042B: { jung: "E", eixo: "EXE" },
  Q042C: { jung: "I", eixo: "AUT" },
  Q042D: { jung: "I", eixo: "EST" },
  Q043A: { jung: "T", eixo: "EST" },
  Q043B: { jung: "F", eixo: "COO" },
  Q043C: { jung: "S", eixo: "EXE" },
  Q043D: { jung: "N", eixo: "FLE" },
  Q044A: { jung: "E", eixo: "COO" },
  Q044B: { jung: "E", eixo: "EXE" },
  Q044C: { jung: "I", eixo: "AUT" },
  Q044D: { jung: "I", eixo: "EST" },
  Q045A: { jung: "T", eixo: "AUT" },
  Q045B: { jung: "F", eixo: "EXP" },
  Q045C: { jung: "S", eixo: "EXE" },
  Q045D: { jung: "N", eixo: "FLE" },
  Q046A: { jung: "E", eixo: "COO" },
  Q046B: { jung: "E", eixo: "EXE" },
  Q046C: { jung: "I", eixo: "AUT" },
  Q046D: { jung: "I", eixo: "EST" },
  Q047A: { jung: "T", eixo: "AUT" },
  Q047B: { jung: "F", eixo: "COO" },
  Q047C: { jung: "S", eixo: "EXE" },
  Q047D: { jung: "N", eixo: "EXP" },
  Q048A: { jung: "E", eixo: "EXP" },
  Q048B: { jung: "E", eixo: "EXE" },
  Q048C: { jung: "I", eixo: "AUT" },
  Q048D: { jung: "I", eixo: "EST" }
};

/* ---- Índices derivados (algoritmo e auditoria) ---- */

export interface AlternativaCompleta {
  id: string; texto: string; jung: PoloJung; eixo: EixoAux;
}
export interface QuestaoCompleta {
  id: string; tipo: TipoItem; peso: number; contexto: string; enunciado: string;
  alternativas: AlternativaCompleta[];
}

/** As 48 questões com a chave reunida — o que a v1.0 tinha antes da separação. */
export const QUESTOES_COMPLETAS: QuestaoCompleta[] = QUESTOES.map(x => ({
  id: x.id, tipo: ITEM[x.id].tipo, peso: ITEM[x.id].peso,
  contexto: x.contexto, enunciado: x.enunciado,
  alternativas: x.alternativas.map(a => ({ id: a.id, texto: a.texto, jung: CHAVE[a.id].jung, eixo: CHAVE[a.id].eixo }))
}));

export const QUESTAO_COMPLETA_POR_ID: Record<string, QuestaoCompleta> =
  Object.fromEntries(QUESTOES_COMPLETAS.map(x => [x.id, x]));

export const ALTERNATIVA_POR_ID: Record<string, AlternativaCompleta & { questaoId: string; peso: number }> =
  Object.fromEntries(
    QUESTOES_COMPLETAS.flatMap(x => x.alternativas.map(a => [a.id, { ...a, questaoId: x.id, peso: x.peso }]))
  );

/**
 * Máximo teórico por polo = soma dos pesos dos itens em que o polo aparece.
 * Usado para converter contagem bruta em ESCORE RELATIVO INTERNO (item 17).
 * Calcular a partir do banco elimina qualquer viés de desbalanceamento: um polo
 * que aparece em menos itens não é penalizado.
 */
export const MAXIMO_POR_POLO_JUNG: Record<PoloJung, number> = (() => {
  const m: Record<string, number> = { E: 0, I: 0, T: 0, F: 0, S: 0, N: 0 };
  for (const qq of QUESTOES_COMPLETAS) {
    for (const p of new Set(qq.alternativas.map(a => a.jung))) m[p] += qq.peso;
  }
  return m as Record<PoloJung, number>;
})();

export const MAXIMO_POR_EIXO: Record<EixoAux, number> = (() => {
  const m: Record<string, number> = { EXP: 0, EXE: 0, AUT: 0, COO: 0, FLE: 0, EST: 0 };
  for (const qq of QUESTOES_COMPLETAS) {
    for (const p of new Set(qq.alternativas.map(a => a.eixo))) m[p] += qq.peso;
  }
  return m as Record<EixoAux, number>;
})();

/** Total de pesos por tipo de item — denominador dos escores junguianos. */
export const PESO_TOTAL_FUNCAO = QUESTOES_COMPLETAS.filter(x => x.tipo === 'FUNCAO').reduce((s, x) => s + x.peso, 0);
export const PESO_TOTAL_ATITUDE = QUESTOES_COMPLETAS.filter(x => x.tipo === 'ATITUDE').reduce((s, x) => s + x.peso, 0);
