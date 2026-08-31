/**
 * BASELINE METODOLÓGICA — itens 7, 8 e 104 do prompt-mestre
 * ===========================================================================
 * Congela o resultado produzido pela versão ATUAL do instrumento para cinco
 * conjuntos controlados de 48 respostas, mais a agregação de uma população
 * fixa (IDF, ICF, complementaridade, distribuições).
 *
 * O arquivo gerado — baseline.json — é a prova de que a refatoração NÃO
 * mudou o instrumento. Depois das alterações, `verificar-baseline.ts` reexecuta
 * exatamente os mesmos conjuntos e exige igualdade byte a byte.
 *
 * MESMAS RESPOSTAS = MESMOS RESULTADOS.
 *
 * Uso:
 *   npx tsx scripts/baseline.ts            # grava baseline.json (só uma vez)
 *   npx tsx scripts/baseline.ts --forcar   # regrava (exige justificativa)
 */
import { writeFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { QUESTOES_COMPLETAS as QUESTOES } from '../src/data/questions.server';
import { avaliar, vetorDe, type Resposta } from '../src/lib/scoring';
import { analisarEquipe, type MembroAgregado } from '../src/lib/aggregate';
import { gerarParticipantes } from './simulate';

const ARQUIVO = join(process.cwd(), 'baseline.json');

/**
 * Cinco conjuntos controlados e determinísticos. As regras de escolha são
 * fixas e legíveis — não há aleatoriedade, e qualquer pessoa pode reproduzi-las
 * à mão a partir de src/data/questions.ts.
 */
export const CONJUNTOS: { id: string; descricao: string; escolher: (i: number) => number }[] = [
  { id: 'C1', descricao: 'Sempre a primeira alternativa apresentada', escolher: () => 0 },
  { id: 'C2', descricao: 'Sempre a segunda alternativa', escolher: () => 1 },
  { id: 'C3', descricao: 'Rotação simples: i módulo 4', escolher: i => i % 4 },
  { id: 'C4', descricao: 'Rotação invertida: 3 menos (i módulo 4)', escolher: i => 3 - (i % 4) },
  { id: 'C5', descricao: 'Alternância por blocos de três: floor(i/3) módulo 4', escolher: i => Math.floor(i / 3) % 4 }
];

export function respostasDoConjunto(c: typeof CONJUNTOS[number]): Resposta[] {
  return QUESTOES.map((q, i) => ({
    questaoId: q.id,
    alternativaId: q.alternativas[c.escolher(i) % q.alternativas.length].id
  }));
}

/** Extrai TUDO o que o item 7 exige registrar, em forma comparável. */
export function retratoIndividual(r: ReturnType<typeof avaliar>) {
  return {
    perfilPredominante: r.perfilPrincipal,
    perfilSecundario: r.perfilSecundario,
    atitude: r.atitude,
    atitudeMargem: r.atitudeMargem,
    funcaoDominante: r.funcaoDominante,
    funcaoAuxiliar: r.funcaoAuxiliar,
    funcaoMenosRepresentada: r.funcaoMenosRepresentada,
    funcaoInferior: r.funcaoInferior,
    ordemFuncoes: r.ordemFuncoes,
    empateFuncoes: r.empateFuncoes,
    regraDesempate: r.regraDesempate,
    escoresJungBruto: r.escores.bruto,
    escoresJungRelativo: r.escores.relativo,
    denominadores: r.escores.denominadores,
    eixosBruto: r.escores.eixos.bruto,
    eixosRelativo: r.escores.eixos.relativo,
    eixosAuxiliares: r.eixosAuxiliares,
    capacidadesBruto: r.funcional.capacidadesBruto,
    capacidades: r.funcional.capacidades,
    capacidadesOrdenadas: r.capacidadesOrdenadas,
    belbinBruto: r.funcional.belbinBruto,
    belbin: r.funcional.belbin,
    belbinOrdenado: r.belbinOrdenado,
    top3Belbin: r.top3Belbin,
    versaoAlgoritmo: r.versao,
    versaoMatriz: r.versaoMatriz,
    respostasValidas: r.respostasValidas,
    completo: r.completo
  };
}

/** Agregação de uma população fixa: IDF, ICF, complementaridade, distribuições. */
export function retratoColetivo(membros: MembroAgregado[]) {
  const a = analisarEquipe(membros);
  return {
    n: a.n,
    idf: a.idf, idfFaixa: a.idfFaixa, idfComponentes: a.idfComponentes,
    icf: a.icf, icfFaixa: a.icfFaixa,
    complementaridade: a.complementaridade,
    concentracao: a.concentracao,
    distribuicaoPerfis: a.distribuicaoPerfis,
    distribuicaoFuncoes: a.distribuicaoFuncoes,
    distribuicaoAtitudes: a.distribuicaoAtitudes,
    distribuicaoEixos: a.distribuicaoEixos,
    cobertura: a.cobertura,
    belbinEquipe: a.belbinEquipe
  };
}

export function montarBaseline() {
  const individuais = CONJUNTOS.map(c => ({
    id: c.id,
    descricao: c.descricao,
    retrato: retratoIndividual(avaliar(respostasDoConjunto(c)))
  }));

  // População fixa e determinística — a mesma semente de sempre.
  const pop = gerarParticipantes();
  const membros: MembroAgregado[] = pop.map((p, i) => ({
    id: `p-${i}`, setor: p.setor, ...vetorDe(avaliar(p.respostas))
  }));

  const porSetor: Record<string, ReturnType<typeof retratoColetivo>> = {};
  const setores = Array.from(new Set(membros.map(m => m.setor))).sort();
  for (const s of setores) porSetor[s] = retratoColetivo(membros.filter(m => m.setor === s));

  return {
    geradoPor: 'scripts/baseline.ts',
    versaoInstrumento: individuais[0].retrato.versaoAlgoritmo,
    versaoMatriz: individuais[0].retrato.versaoMatriz,
    totalQuestoes: QUESTOES.length,
    totalAlternativas: QUESTOES.reduce((s, q) => s + q.alternativas.length, 0),
    individuais,
    populacao: { n: membros.length, setores },
    coletivoGeral: retratoColetivo(membros),
    coletivoPorSetor: porSetor
  };
}

// Só executa quando chamado diretamente (e não quando importado pelo verificador).
if (/(^|[\\/])baseline\.ts$/.test(process.argv[1] ?? '')) {
  const forcar = process.argv.includes('--forcar');
  if (existsSync(ARQUIVO) && !forcar) {
    console.log('baseline.json já existe. A baseline é congelada de propósito:');
    console.log('regravá-la apagaria a prova de que o instrumento não mudou.');
    console.log('Use --forcar apenas se a alteração do instrumento tiver sido autorizada.');
    process.exit(0);
  }
  const b = montarBaseline();
  writeFileSync(ARQUIVO, JSON.stringify(b, null, 2));
  console.log('BASELINE CONGELADA — baseline.json');
  console.log(`  instrumento ${b.versaoInstrumento} · matriz ${b.versaoMatriz}`);
  console.log(`  ${b.totalQuestoes} questões · ${b.totalAlternativas} alternativas`);
  console.log('');
  for (const c of b.individuais) {
    const r = c.retrato;
    console.log(`  ${c.id} — ${c.descricao}`);
    console.log(`     perfil ${r.perfilPredominante} · secundário ${r.perfilSecundario} · atitude ${r.atitude}`);
    console.log(`     E${r.escoresJungRelativo.E} I${r.escoresJungRelativo.I} T${r.escoresJungRelativo.T} F${r.escoresJungRelativo.F} S${r.escoresJungRelativo.S} N${r.escoresJungRelativo.N}`);
    console.log(`     Belbin top3: ${r.top3Belbin.map(x => `${x.id} ${x.valor}`).join(' · ')}`);
  }
  console.log('');
  console.log(`  população de referência: ${b.populacao.n} participantes em ${b.populacao.setores.length} setores`);
  console.log(`  geral: IDF ${b.coletivoGeral.idf} · ICF ${b.coletivoGeral.icf} · complementaridade ${b.coletivoGeral.complementaridade.pct}%`);
}
