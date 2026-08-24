/**
 * Teste da composição simbólica — itens 51 a 56, 66, 67 e 99.
 * Prova que a soma dos oito animais bate com o total, que os zeros aparecem, e
 * que tela e planilha saem da MESMA rotina.
 */
import { composicaoAnimais, matrizAnimais, linhasComposicaoParaExcel, linhasMatrizParaExcel, cabecalhoMatriz } from '../src/lib/animais';
import { analisarEquipe, type MembroAgregado } from '../src/lib/aggregate';
import { avaliar, vetorDe } from '../src/lib/scoring';
import { PERFIS } from '../src/data/profiles';
import { gerarParticipantes } from './simulate';

let ok = 0, falhas = 0;
const t = (n: string, c: boolean, d = '') => {
  if (c) { ok++; console.log(`  ✓ ${n}${d ? ' — ' + d : ''}`); }
  else { falhas++; console.log(`  ✗ ${n}${d ? ' — ' + d : ''}`); }
};

const pop = gerarParticipantes();
const membros: MembroAgregado[] = pop.map((p, i) => ({
  id: `p-${i}`, setor: p.setor, ...vetorDe(avaliar(p.respostas))
}));

console.log('── Itens 50 a 53 · os oito animais, com zeros');
const m = matrizAnimais(membros);
t('Exatamente oito animais, sem inventar nenhum', m.animais.length === 8,
  m.animais.map(a => a.animal).join(', '));
t('Os oito animais são os já definidos no instrumento',
  m.animais.every(a => PERFIS.some(p => p.animal === a.animal && p.id === a.perfil)));
const comZero = m.equipes.filter(e => e.linhas.some(l => l.n === 0));
t('Categorias vazias continuam aparecendo', m.equipes.every(e => e.linhas.length === 8),
  `${comZero.length} equipe(s) têm ao menos um animal em zero, e ele é exibido`);

console.log('\n── Item 56 e 99 · a soma tem de bater');
t('Soma dos animais = total de avaliações válidas, em TODA equipe',
  m.equipes.every(e => e.somaConfere),
  m.equipes.map(e => `${e.equipe} ${e.somaAnimais}/${e.total}`).slice(0, 5).join(' · ') + ' …');
t('Soma organizacional confere', m.organizacao.somaConfere,
  `${m.organizacao.somaAnimais} de ${m.organizacao.total}`);
t('Nenhuma inconsistência sinalizada', m.inconsistencias.length === 0);

// Inconsistência é DETECTADA quando existe de verdade.
const corrompido = [...membros.slice(0, 5), { ...membros[0], perfil: 'ZZ' as any }];
const c = composicaoAnimais(corrompido, 'TESTE');
t('Perfil fora dos oito é detectado como inconsistência', !c.somaConfere && !!c.inconsistencia,
  c.inconsistencia?.slice(0, 80));

console.log('\n── Itens 54 e 55 · mais e menos representado');
const mec = m.equipes[0];
t('Mais representado identificado', !!mec.maisRepresentado,
  `${mec.equipe}: ${mec.maisRepresentado?.animal} ${mec.maisRepresentado?.n} (${mec.maisRepresentado?.pct}%)`);
t('Menos representado identificado', !!mec.menosRepresentado,
  `${mec.equipe}: ${mec.menosRepresentado?.animal} ${mec.menosRepresentado?.n} (${mec.menosRepresentado?.pct}%)`);
t('Mais representado tem n maior ou igual ao menos representado',
  (mec.maisRepresentado?.n ?? 0) >= (mec.menosRepresentado?.n ?? 0));

console.log('\n── Itens 66 e 67 · dashboard e Excel na mesma rotina');
const a = analisarEquipe(membros.filter(x => x.setor === mec.equipe));
const daAnalise = a.distribuicaoPerfis.map(p => `${p.animal}:${p.n}:${p.pct}`).sort().join('|');
const daComposicao = mec.linhas.map(l => `${l.animal}:${l.n}:${l.pct}`).sort().join('|');
t('Composição bate com a distribuição de perfis já existente no dashboard',
  daAnalise === daComposicao, `${mec.linhas.length} animais conferidos, quantidade e percentual`);

const planas = linhasComposicaoParaExcel(m);
t('Aba "Composição dos Animais" cobre todas as equipes + organização',
  planas.length === (m.equipes.length + 1) * 8, `${planas.length} linhas`);
const linhaExcel = planas.find(l => l[0] === mec.equipe && l[1] === mec.maisRepresentado!.animal)!;
t('Linha do Excel idêntica ao que a tela mostra',
  linhaExcel[2] === mec.maisRepresentado!.n && linhaExcel[3] === mec.maisRepresentado!.pct,
  `${linhaExcel[0]} | ${linhaExcel[1]} | ${linhaExcel[2]} | ${linhaExcel[3]}%`);

const cab = cabecalhoMatriz(m);
const mq = linhasMatrizParaExcel(m, 'quantidade');
const mp = linhasMatrizParaExcel(m, 'percentual');
t('Matriz tem cabeçalho Equipe + 8 animais + Total', cab.length === 10, cab.join(' | '));
t('Matriz por quantidade: cada linha soma o total da equipe',
  mq.every(l => (l.slice(1, 9) as number[]).reduce((s, v) => s + v, 0) === l[9]));
t('Matriz por percentual disponível', mp.length === mq.length && mp[0].length === 10);

console.log(`\n RESULTADO: ${ok} aprovadas, ${falhas} falhas.`);
process.exit(falhas ? 1 : 0);
