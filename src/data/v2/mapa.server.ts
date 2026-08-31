import 'server-only';
/**
 * REAVALIAÇÃO v2.0 — MAPA CONFIDENCIAL (CAMADA DE SERVIDOR)
 * ===========================================================================
 * ⚠ NUNCA pode chegar ao navegador. O `import 'server-only'` acima faz o build
 * FALHAR se algum componente de cliente importar este arquivo, direta ou
 * indiretamente. É a trava, não o comentário.
 *
 * Fonte oficial: ROTA26gabaritotecnicoCONFIDENCIAL.pdf — as 192 associações
 * alternativa → configuração e os oito itens-âncora de peso 2 foram conferidos
 * linha a linha contra o PDF antes de gerar este arquivo.
 */

export type Config = 'Te' | 'Ti' | 'Fe' | 'Fi' | 'Se' | 'Si' | 'Ne' | 'Ni';
export type Atitude = 'E' | 'I';
export type Funcao = 'T' | 'F' | 'S' | 'N';

export const CONFIGS: readonly Config[] = ['Te','Ti','Fe','Fi','Se','Si','Ne','Ni'] as const;

/** Identidade de cada configuração. Animal, atitude, função e função inferior. */
export const CONFIG_INFO: Record<Config, {
  animal: string; jung: string; atitude: Atitude; funcao: Funcao; inferior: Funcao; cor: string;
}> = {
  Te: { animal: 'Lobo',     jung: 'Pensamento Extrovertido', atitude: 'E', funcao: 'T', inferior: 'F', cor: '#2E6E8E' },
  Ti: { animal: 'Elefante', jung: 'Pensamento Introvertido', atitude: 'I', funcao: 'T', inferior: 'F', cor: '#1C4A62' },
  Fe: { animal: 'Carneiro', jung: 'Sentimento Extrovertido', atitude: 'E', funcao: 'F', inferior: 'T', cor: '#C1663A' },
  Fi: { animal: 'Baleia',   jung: 'Sentimento Introvertido', atitude: 'I', funcao: 'F', inferior: 'T', cor: '#8C3F33' },
  Se: { animal: 'Cavalo',   jung: 'Sensação Extrovertida',   atitude: 'E', funcao: 'S', inferior: 'N', cor: '#6E8B3D' },
  Si: { animal: 'Urso',     jung: 'Sensação Introvertida',   atitude: 'I', funcao: 'S', inferior: 'N', cor: '#47632B' },
  Ne: { animal: 'Raposa',   jung: 'Intuição Extrovertida',   atitude: 'E', funcao: 'N', inferior: 'S', cor: '#8A5AA0' },
  Ni: { animal: 'Onça',     jung: 'Intuição Introvertida',   atitude: 'I', funcao: 'N', inferior: 'S', cor: '#4E3163' }
};

/** Itens-âncora: um por configuração, peso 2. Gabarito, seção 2.1. */
export const ANCORAS: Record<Config, string> = {
  Te: 'R039B',
  Ti: 'R014C',
  Fe: 'R036C',
  Fi: 'R020D',
  Se: 'R022B',
  Si: 'R034B',
  Ne: 'R040B',
  Ni: 'R043C',
};
const CONJ_ANCORAS = new Set(Object.values(ANCORAS));

/** alternativa → configuração que ela pontua. As 192. */
export const MAPA: Record<string, Config> = {
  R001A: 'Ni', R001B: 'Ne', R001C: 'Se', R001D: 'Ti',
  R002A: 'Fi', R002B: 'Ti', R002C: 'Ne', R002D: 'Fe',
  R003A: 'Ni', R003B: 'Te', R003C: 'Ne', R003D: 'Si',
  R004A: 'Ti', R004B: 'Si', R004C: 'Fe', R004D: 'Ni',
  R005A: 'Te', R005B: 'Fi', R005C: 'Ti', R005D: 'Se',
  R006A: 'Se', R006B: 'Fe', R006C: 'Si', R006D: 'Ni',
  R007A: 'Se', R007B: 'Si', R007C: 'Fi', R007D: 'Ni',
  R008A: 'Te', R008B: 'Fi', R008C: 'Fe', R008D: 'Se',
  R009A: 'Fe', R009B: 'Ni', R009C: 'Si', R009D: 'Te',
  R010A: 'Se', R010B: 'Si', R010C: 'Ne', R010D: 'Te',
  R011A: 'Te', R011B: 'Fi', R011C: 'Fe', R011D: 'Si',
  R012A: 'Si', R012B: 'Ni', R012C: 'Ti', R012D: 'Fi',
  R013A: 'Ni', R013B: 'Fi', R013C: 'Se', R013D: 'Fe',
  R014A: 'Ni', R014B: 'Se', R014C: 'Ti', R014D: 'Ne',
  R015A: 'Se', R015B: 'Fe', R015C: 'Ni', R015D: 'Te',
  R016A: 'Se', R016B: 'Si', R016C: 'Fi', R016D: 'Ne',
  R017A: 'Ne', R017B: 'Si', R017C: 'Te', R017D: 'Fe',
  R018A: 'Fi', R018B: 'Ni', R018C: 'Ti', R018D: 'Se',
  R019A: 'Ti', R019B: 'Si', R019C: 'Fi', R019D: 'Ne',
  R020A: 'Te', R020B: 'Ni', R020C: 'Fe', R020D: 'Fi',
  R021A: 'Fi', R021B: 'Te', R021C: 'Ti', R021D: 'Ne',
  R022A: 'Ni', R022B: 'Se', R022C: 'Ne', R022D: 'Ti',
  R023A: 'Fe', R023B: 'Fi', R023C: 'Ti', R023D: 'Se',
  R024A: 'Si', R024B: 'Te', R024C: 'Fe', R024D: 'Ni',
  R025A: 'Ne', R025B: 'Si', R025C: 'Fi', R025D: 'Te',
  R026A: 'Se', R026B: 'Fe', R026C: 'Ti', R026D: 'Ni',
  R027A: 'Ti', R027B: 'Fi', R027C: 'Ne', R027D: 'Si',
  R028A: 'Ne', R028B: 'Fe', R028C: 'Te', R028D: 'Fi',
  R029A: 'Fe', R029B: 'Ni', R029C: 'Se', R029D: 'Ti',
  R030A: 'Ne', R030B: 'Si', R030C: 'Fe', R030D: 'Fi',
  R031A: 'Fe', R031B: 'Te', R031C: 'Ne', R031D: 'Ni',
  R032A: 'Fi', R032B: 'Te', R032C: 'Ne', R032D: 'Si',
  R033A: 'Ti', R033B: 'Fi', R033C: 'Te', R033D: 'Ne',
  R034A: 'Ni', R034B: 'Si', R034C: 'Ne', R034D: 'Ti',
  R035A: 'Fe', R035B: 'Te', R035C: 'Ti', R035D: 'Ne',
  R036A: 'Ti', R036B: 'Te', R036C: 'Fe', R036D: 'Fi',
  R037A: 'Se', R037B: 'Ni', R037C: 'Te', R037D: 'Si',
  R038A: 'Se', R038B: 'Si', R038C: 'Ne', R038D: 'Ti',
  R039A: 'Ne', R039B: 'Te', R039C: 'Ti', R039D: 'Se',
  R040A: 'Si', R040B: 'Ne', R040C: 'Se', R040D: 'Ti',
  R041A: 'Se', R041B: 'Fe', R041C: 'Te', R041D: 'Ni',
  R042A: 'Si', R042B: 'Se', R042C: 'Fe', R042D: 'Ni',
  R043A: 'Te', R043B: 'Fi', R043C: 'Ni', R043D: 'Se',
  R044A: 'Ti', R044B: 'Ni', R044C: 'Ne', R044D: 'Si',
  R045A: 'Si', R045B: 'Fe', R045C: 'Fi', R045D: 'Se',
  R046A: 'Si', R046B: 'Te', R046C: 'Fi', R046D: 'Ne',
  R047A: 'Te', R047B: 'Ti', R047C: 'Fe', R047D: 'Fi',
  R048A: 'Ni', R048B: 'Se', R048C: 'Fe', R048D: 'Ti',
};

/** Peso da alternativa: 2 se for âncora, 1 caso contrário. */
export function pesoDe(alternativaId: string): 1 | 2 {
  return CONJ_ANCORAS.has(alternativaId) ? 2 : 1;
}

/** Configuração para a qual a alternativa pontua. Lança se não existir. */
export function configDe(alternativaId: string): Config {
  const c = MAPA[alternativaId];
  if (!c) throw new Error(`alternativa desconhecida: ${alternativaId}`);
  return c;
}

/* ── Conferências estruturais, executadas na carga do módulo ────────────── */
{
  const n = Object.keys(MAPA).length;
  if (n !== 192) throw new Error(`mapa deveria ter 192 alternativas, tem ${n}`);
  const porConfig: Record<string, number> = {};
  for (const c of Object.values(MAPA)) porConfig[c] = (porConfig[c] ?? 0) + 1;
  for (const c of CONFIGS) {
    if (porConfig[c] !== 24)
      throw new Error(`${c} aparece ${porConfig[c]} vezes; o gabarito exige 24`);
  }
  if (CONJ_ANCORAS.size !== 8) throw new Error('deveriam existir 8 itens-âncora');
  for (const c of CONFIGS) {
    if (MAPA[ANCORAS[c]] !== c)
      throw new Error(`âncora de ${c} aponta para ${MAPA[ANCORAS[c]]}`);
  }
}
