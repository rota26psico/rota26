/**
 * Gerador determinístico de participantes simulados.
 * Usado tanto pelo seed de demonstração do Supabase quanto pela demo navegável,
 * garantindo que os dois mostrem exatamente os mesmos resultados.
 *
 * Determinístico por construção: PRNG com semente fixa (nada de Math.random),
 * de modo que o mesmo comando produz sempre o mesmo conjunto de dados.
 */
import { QUESTOES } from '../src/data/questions';
import { avaliar, type Resposta } from '../src/lib/scoring';
import type { PerfilId } from '../src/data/profiles';

/** mulberry32 — PRNG determinístico de 32 bits. */
export function prng(seed: number) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6D2B79F5) >>> 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export const SETORES = [
  'MM', 'MDHC', 'MS', 'MEC', 'ANTT', 'HUMAN POWER', 'TERRACAP', 'AGSUS',
  'MONITORIA', 'FINANCEIRO', 'DH', 'JURÍDICO', 'DAP', 'SESMT',
  'INFRAESTRUTURA', 'PLANEJAMENTO'
];

const NOMES = ['Ana', 'Bruno', 'Carla', 'Diego', 'Elisa', 'Fábio', 'Gabriela', 'Henrique', 'Isabela', 'João', 'Karina', 'Lucas', 'Mariana', 'Nuno', 'Olívia', 'Paulo', 'Queila', 'Rafael', 'Sofia', 'Tiago', 'Úrsula', 'Vinícius', 'William', 'Xênia', 'Yuri', 'Zilda', 'Amanda', 'Bernardo', 'Cecília', 'Daniel'];
const SOBRENOMES = ['Almeida', 'Barbosa', 'Cardoso', 'Duarte', 'Esteves', 'Ferreira', 'Gomes', 'Henriques', 'Import', 'Jardim', 'Klein', 'Lima', 'Martins', 'Nogueira', 'Oliveira', 'Pereira', 'Quintela', 'Ribeiro', 'Santos', 'Teixeira', 'Uchôa', 'Vieira', 'Weber', 'Xavier'];

/**
 * Gera respostas com viés controlado para um polo junguiano alvo.
 * `forca` (0..1) controla o quanto o respondente adere ao polo alvo — valores
 * intermediários produzem perfis realistas, com escores próximos entre funções.
 */
export function respostasComVies(
  rand: () => number,
  alvoAtitude: 'E' | 'I',
  alvoFuncao: 'T' | 'F' | 'S' | 'N',
  forca: number
): Resposta[] {
  return QUESTOES.map(q => {
    const alvo = q.tipo === 'ATITUDE' ? alvoAtitude : alvoFuncao;
    const preferidas = q.alternativas.filter(a => a.jung === alvo);
    const outras = q.alternativas.filter(a => a.jung !== alvo);
    const pool = rand() < forca && preferidas.length ? preferidas : outras.length ? outras : preferidas;
    const escolhida = pool[Math.floor(rand() * pool.length)];
    return { questaoId: q.id, alternativaId: escolhida.id };
  });
}

export interface ParticipanteSimulado {
  matricula: string;
  nome: string;
  setor: string;
  email: string;
  respostas: Resposta[];
  perfil: PerfilId;
  perfilSecundario: PerfilId;
  atitude: 'E' | 'I';
  funcaoDominante: 'T' | 'F' | 'S' | 'N';
  relativo: Record<string, number>;
  concluidoEm: string;
}

/**
 * Perfil-alvo por setor: cada setor recebe uma "personalidade" plausível para
 * que os dashboards mostrem contrastes reais (um setor de execução, um de
 * análise, um homogêneo, um diverso), permitindo testar toda a interpretação.
 */
const TENDENCIA_SETOR: Record<string, { at: ('E' | 'I')[]; fn: ('T' | 'F' | 'S' | 'N')[]; forca: number; n: number }> = {
  'MEC':            { at: ['E', 'E', 'I'], fn: ['S', 'S', 'T', 'F'], forca: 0.72, n: 11 }, // execução/organização, pouca intuição
  'MM':             { at: ['E', 'I'],      fn: ['T', 'S', 'T', 'N'], forca: 0.68, n: 9 },
  'MS':             { at: ['I', 'E'],      fn: ['N', 'F', 'N', 'T'], forca: 0.70, n: 8 },
  'MDHC':           { at: ['E', 'E', 'I'], fn: ['F', 'F', 'N', 'S'], forca: 0.66, n: 7 },
  'ANTT':           { at: ['I', 'I', 'E'], fn: ['T', 'T', 'S'],      forca: 0.78, n: 6 }, // homogêneo, muito pensamento
  'HUMAN POWER':    { at: ['E'],           fn: ['F', 'N', 'S', 'T'], forca: 0.62, n: 6 },
  'TERRACAP':       { at: ['E', 'I'],      fn: ['S', 'T', 'F', 'N'], forca: 0.60, n: 5 }, // diverso
  'AGSUS':          { at: ['I', 'E'],      fn: ['S', 'S', 'F'],      forca: 0.74, n: 5 },
  'MONITORIA':      { at: ['I', 'I'],      fn: ['S', 'T'],           forca: 0.80, n: 4 }, // abaixo do mínimo: testa o aviso
  'FINANCEIRO':     { at: ['I', 'I', 'E'], fn: ['T', 'S', 'T'],      forca: 0.76, n: 6 },
  'DH':             { at: ['E', 'E'],      fn: ['F', 'F', 'N'],      forca: 0.72, n: 5 },
  'JURÍDICO':       { at: ['I', 'E'],      fn: ['T', 'T', 'F'],      forca: 0.74, n: 5 },
  'DAP':            { at: ['E', 'I'],      fn: ['S', 'F', 'T'],      forca: 0.68, n: 4 },
  'SESMT':          { at: ['E', 'I'],      fn: ['S', 'S', 'T'],      forca: 0.72, n: 3 }, // grupo muito pequeno
  'INFRAESTRUTURA': { at: ['E', 'E', 'I'], fn: ['S', 'S', 'T', 'N'], forca: 0.70, n: 6 },
  'PLANEJAMENTO':   { at: ['I', 'E', 'I'], fn: ['N', 'T', 'N', 'F'], forca: 0.70, n: 6 }
};

export function gerarParticipantes(seed = 20260816): ParticipanteSimulado[] {
  const rand = prng(seed);
  const out: ParticipanteSimulado[] = [];
  let n = 0;

  for (const setor of SETORES) {
    const cfg = TENDENCIA_SETOR[setor];
    for (let i = 0; i < cfg.n; i++) {
      n++;
      const at = cfg.at[Math.floor(rand() * cfg.at.length)];
      const fn = cfg.fn[Math.floor(rand() * cfg.fn.length)];
      const forca = Math.min(0.92, Math.max(0.45, cfg.forca + (rand() - 0.5) * 0.22));
      const respostas = respostasComVies(rand, at, fn, forca);
      const r = avaliar(respostas);
      const nome = `${NOMES[Math.floor(rand() * NOMES.length)]} ${SOBRENOMES[Math.floor(rand() * SOBRENOMES.length)]}`;
      const dia = 1 + Math.floor(rand() * 28);
      out.push({
        matricula: String(100000 + n * 7),
        nome,
        setor,
        email: `demo${String(n).padStart(3, '0')}@exemplo.gov.br`,
        respostas,
        perfil: r.perfilPrincipal,
        perfilSecundario: r.perfilSecundario,
        atitude: r.atitude,
        funcaoDominante: r.funcaoDominante,
        relativo: r.escores.relativo as unknown as Record<string, number>,
        concluidoEm: `2026-07-${String(dia).padStart(2, '0')}T13:${String(10 + (n % 45)).padStart(2, '0')}:00Z`
      });
    }
  }
  return out;
}
