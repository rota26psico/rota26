/**
 * DASHBOARD × EXCEL — itens 66, 67 e 100
 * ===========================================================================
 * Gera a planilha de verdade, ABRE o arquivo gerado e compara célula a célula
 * com o que a interface exibe. Não confere a intenção do código: confere o
 * conteúdo do .xlsx.
 */
import ExcelJS from 'exceljs';
import { gerarExcel, type RegistroExport } from '../src/lib/excel';
import { matrizAnimais, composicaoAnimais } from '../src/lib/animais';
import { analisarEquipe, type MembroAgregado } from '../src/lib/aggregate';
import { avaliar, vetorDe } from '../src/lib/scoring';
import { VERSAO_INSTRUMENTO } from '../src/data/questions';
import { gerarParticipantes } from './simulate';

let ok = 0, falhas = 0;
const t = (n: string, c: boolean, d = '') => {
  if (c) { ok++; console.log(`  ✓ ${n}${d ? ' — ' + d : ''}`); }
  else { falhas++; console.log(`  ✗ ${n}${d ? ' — ' + d : ''}`); }
};

(async () => {
  const pop = gerarParticipantes();
  const regs: RegistroExport[] = pop.map((p, i) => ({
    participanteId: `p-${i}`, nome: p.nome, matricula: p.matricula, setor: p.setor, email: p.email,
    concluidaEm: p.concluidoEm, versao: VERSAO_INSTRUMENTO, isDemo: false,
    respostas: p.respostas.map(x => ({ questaoId: x.questaoId, alternativaId: x.alternativaId, jung: 'E', eixo: 'EXP', peso: 1 })) as any,
    resultado: avaliar(p.respostas)
  }));
  const membros: MembroAgregado[] = regs.map(r => ({
    id: r.participanteId, setor: r.setor, ...vetorDe(r.resultado)
  }));

  // O que a INTERFACE mostra.
  const m = matrizAnimais(membros);

  // O que o ARQUIVO contém.
  const buf = await gerarExcel('completo', regs, { geradoPor: 'teste', geradoEm: '2026-01-01T00:00:00Z' });
  const wb = new ExcelJS.Workbook();
  await wb.xlsx.load(buf as any);

  console.log('── Item 61 · abas preservadas e novas abas presentes');
  const nomes = wb.worksheets.map(w => w.name);
  const esperadas = ['Participantes', 'Respostas Brutas', 'Resultados Jung', 'Resultados Funcionais',
    'Resultados Belbin', 'Oito Perfis', 'Equipes', 'Distribuição dos Perfis', 'Animais',
    'Cobertura Funcional', 'Indicadores', 'Dicionário de Dados', 'Informações da Exportação'];
  t('As 13 abas anteriores continuam existindo', esperadas.every(e => nomes.includes(e)),
    `${nomes.length} abas no arquivo`);
  t('Aba "Composição dos Animais" criada (item 62)', nomes.includes('Composição dos Animais'));
  t('Aba "Animais por Equipe" criada (item 63)', nomes.includes('Animais por Equipe'));
  t('Aba "Percentual de Animais" criada (item 64)', nomes.includes('Percentual de Animais'));

  console.log('\n── Item 65 · animal predominante na tabela individual');
  const wsP = wb.getWorksheet('Participantes')!;
  const cabP = (wsP.getRow(1).values as any[]).slice(1);
  t('Coluna "Animal predominante" presente', cabP.includes('Animal predominante'), cabP.join(' | '));
  const colAnimal = cabP.indexOf('Animal predominante') + 1;
  const primeira = wsP.getRow(2).getCell(colAnimal).value;
  t('Preenchida com o animal do participante', !!primeira, `primeira linha: ${primeira}`);

  console.log('\n── Itens 67 e 100 · o Excel repete exatamente o dashboard');
  const wsC = wb.getWorksheet('Composição dos Animais')!;
  const linhasArquivo = new Map<string, { n: number; pct: number; total: number }>();
  wsC.eachRow((row, i) => {
    if (i === 1) return;
    const v = row.values as any[];
    linhasArquivo.set(`${v[1]}|${v[2]}`, { n: Number(v[3]), pct: Number(v[4]), total: Number(v[5]) });
  });

  let confere = 0, divergem: string[] = [];
  for (const e of [...m.equipes, m.organizacao]) {
    for (const l of e.linhas) {
      const k = `${e.equipe}|${l.animal}`;
      const a = linhasArquivo.get(k);
      if (!a) { divergem.push(`${k}: ausente no arquivo`); continue; }
      if (a.n !== l.n || a.pct !== l.pct || a.total !== e.total)
        divergem.push(`${k}: tela ${l.n}/${l.pct}%/${e.total} vs arquivo ${a.n}/${a.pct}%/${a.total}`);
      else confere++;
    }
  }
  t('Todas as células de composição coincidem', divergem.length === 0,
    `${confere} combinações equipe×animal conferidas${divergem.length ? ' · ' + divergem.slice(0, 3).join(' · ') : ''}`);

  // Verificação nominal explícita, no formato do item 67.
  const eq = m.equipes[0];
  const alvo = eq.maisRepresentado!;
  const noArquivo = linhasArquivo.get(`${eq.equipe}|${alvo.animal}`)!;
  t(`Exemplo do item 67 conferido`, noArquivo.n === alvo.n && noArquivo.pct === alvo.pct,
    `Dashboard: ${eq.equipe} · ${alvo.animal} · ${alvo.n} · ${alvo.pct}%  →  Excel: ${eq.equipe} | ${alvo.animal} | ${noArquivo.n} | ${noArquivo.pct}%`);

  console.log('\n── Item 99 · soma dos animais = total de participantes válidos');
  const wsM = wb.getWorksheet('Animais por Equipe')!;
  let somasOk = true; const detalhes: string[] = [];
  wsM.eachRow((row, i) => {
    if (i === 1) return;
    const v = (row.values as any[]).slice(1);
    const equipe = v[0];
    const soma = v.slice(1, 9).reduce((s: number, x: any) => s + Number(x), 0);
    const total = Number(v[9]);
    if (soma !== total) { somasOk = false; detalhes.push(`${equipe}: ${soma} ≠ ${total}`); }
  });
  t('Cada linha da matriz soma o total da equipe', somasOk, detalhes.join(' · ') || `${wsM.rowCount - 1} linhas conferidas`);

  const wsPct = wb.getWorksheet('Percentual de Animais')!;
  let pctOk = true;
  wsPct.eachRow((row, i) => {
    if (i === 1) return;
    const v = (row.values as any[]).slice(1);
    const soma = v.slice(1, 9).reduce((s: number, x: any) => s + Number(x), 0);
    if (Math.abs(soma - 100) > 0.6) pctOk = false;   // tolerância de arredondamento
  });
  t('Cada linha percentual totaliza 100% (± arredondamento)', pctOk);

  console.log('\n── Itens 43 e 100 · indicadores do dashboard batem com a aba Indicadores');
  const a = analisarEquipe(membros);
  const wsI = wb.getWorksheet('Indicadores')!;
  const ind = new Map<string, any>();
  wsI.eachRow((row, i) => { if (i > 1) { const v = row.values as any[]; ind.set(String(v[1]), v[2]); } });
  t('IDF idêntico', Number(ind.get('IDF — Índice de Diversidade Funcional')) === a.idf,
    `dashboard ${a.idf} · Excel ${ind.get('IDF — Índice de Diversidade Funcional')}`);
  t('ICF idêntico', Number(ind.get('ICF — Índice de Cobertura Funcional')) === a.icf,
    `dashboard ${a.icf} · Excel ${ind.get('ICF — Índice de Cobertura Funcional')}`);
  t('n idêntico', Number(ind.get('Participantes com avaliação concluída')) === a.n,
    `dashboard ${a.n} · Excel ${ind.get('Participantes com avaliação concluída')}`);

  console.log(`\n RESULTADO: ${ok} aprovadas, ${falhas} falhas.`);
  process.exit(falhas ? 1 : 0);
})();
