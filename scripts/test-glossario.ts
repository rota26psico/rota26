/**
 * COBERTURA DO GLOSSÁRIO
 * ===========================================================================
 * Uma sigla exibida sem explicação é uma promessa quebrada. Este teste varre
 * as FONTES DE VERDADE do instrumento e exige verbete para cada código que
 * chega à tela ou à planilha — perfis, funções, atitudes, eixos, capacidades e
 * papéis de Belbin.
 *
 * Se alguém acrescentar um eixo, uma capacidade ou um papel no futuro e
 * esquecer o glossário, este teste falha.
 */
import { GLOSSARIO, verbete, GRUPOS, porGrupo, NOME_GRUPO, SIGLAS_AMBIGUAS } from '../src/data/glossario';
import { PERFIS } from '../src/data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN } from '../src/data/functional';
import { NOME_EIXO } from '../src/data/questions';

let ok = 0, falhas = 0;
const t = (n: string, c: boolean, d = '') => {
  if (c) { ok++; console.log(`  ✓ ${n}${d ? ' — ' + d : ''}`); }
  else { falhas++; console.log(`  ✗ ${n}${d ? ' — ' + d : ''}`); }
};

console.log('── Cobertura: toda sigla exibida tem verbete');

const faltando = (lista: string[]) => lista.filter(x => !verbete(x));

const perfis = PERFIS.map(p => p.id);
t('Os 8 perfis têm verbete', faltando(perfis).length === 0, faltando(perfis).join(', ') || perfis.join(' · '));

const funcoes = ['T', 'F', 'S', 'N'];
t('As 4 funções têm verbete', faltando(funcoes).length === 0, funcoes.join(' · '));

const atitudes = ['E', 'I'];
t('As 2 atitudes têm verbete', faltando(atitudes).length === 0, atitudes.join(' · '));

const eixos = Object.keys(NOME_EIXO);
t('Os 6 eixos têm verbete', faltando(eixos).length === 0, eixos.join(' · '));

const caps = CAPACIDADES.map(c => c.id);
t('As 10 capacidades têm verbete', faltando(caps).length === 0, caps.join(' · '));

const papeis = PAPEIS_BELBIN.map(p => p.id);
t('Os 9 papéis de Belbin têm verbete', faltando(papeis).length === 0, papeis.join(' · '));

const indices = ['IDF', 'ICF', 'HHI', 'Complementaridade', 'n'];
t('Os índices coletivos têm verbete', faltando(indices).length === 0, indices.join(' · '));

const tecnicos = ['is_demo', 'is_test', 'RLS'];
t('Os termos técnicos têm verbete', faltando(tecnicos).length === 0, tecnicos.join(' · '));

console.log('\n── Qualidade: cada verbete responde às três perguntas');

const semPorque = GLOSSARIO.filter(v => !v.porQue || v.porQue.trim().length < 60);
t('Todo verbete explica POR QUE é assim', semPorque.length === 0,
  semPorque.map(v => v.sigla).join(', ') || `${GLOSSARIO.length} verbetes, o mais curto com ${Math.min(...GLOSSARIO.map(v => v.porQue.length))} caracteres`);

const semOQue = GLOSSARIO.filter(v => !v.oQueE || v.oQueE.trim().length < 30);
t('Todo verbete explica O QUE É', semOQue.length === 0, semOQue.map(v => v.sigla).join(', '));

const semOnde = GLOSSARIO.filter(v => !v.ondeAparece || !v.ondeAparece.trim());
t('Todo verbete diz ONDE APARECE', semOnde.length === 0, semOnde.map(v => v.sigla).join(', '));

const duplicadasExatas = GLOSSARIO.map(v => v.sigla)
  .filter((s, i, a) => a.indexOf(s) !== i);
t('Nenhuma sigla exatamente duplicada', duplicadasExatas.length === 0, duplicadasExatas.join(', '));

/* `N` (Intuição) e `n` (número de respondentes) coexistem de propósito. O que
   NÃO pode acontecer é uma busca devolver o verbete errado — foi o defeito que
   este teste encontrou na primeira execução. */
t('Siglas que diferem só pela caixa resolvem corretamente',
  verbete('N')!.nome === 'Intuição' && verbete('n')!.nome === 'Número de respondentes',
  `N → ${verbete('N')!.nome} · n → ${verbete('n')!.nome} · ambíguas: ${SIGLAS_AMBIGUAS.join(', ')}`);

const gruposVazios = GRUPOS.filter(g => porGrupo(g).length === 0);
t('Nenhum grupo do glossário está vazio', gruposVazios.length === 0,
  GRUPOS.map(g => `${NOME_GRUPO[g]} ${porGrupo(g).length}`).join(' · '));

console.log('\n── Honestidade: os parâmetros escolhidos estão declarados como escolha');

const portador = verbete('Portador')!;
t('O limiar de 50 é declarado como escolha, não medição',
  /escolhido|não medido|não veio de dados/i.test(portador.porQue),
  portador.porQue.slice(0, 90) + '…');

const escore = verbete('Escore relativo')!;
t('Escore relativo declara que NÃO é percentil',
  /não existe percentil|não foi normatizado/i.test(escore.porQue));

const anon = verbete('P00001')!;
t('A anonimização é declarada como pseudonimização',
  /pseudonimiza/i.test(anon.porQue));

const intens = verbete('Intensidade')!;
t('As faixas admitem a própria simplificação',
  /simplifica|não significa exatamente a mesma coisa/i.test(intens.porQue));

const idf = verbete('IDF')!;
t('O IDF explica por que a dispersão pesa 50%',
  /rótulo|etiqueta/i.test(idf.porQue) && !!idf.formula);

const icf = verbete('ICF')!;
t('O ICF explica por que presença pesa mais que média',
  /presen/i.test(icf.porQue) && !!icf.formula);

console.log('\n── As letras T, F, S, N explicam a convenção');
t('T explica que a inicial vem do inglês e por quê',
  /Thinking/i.test(verbete('T')!.porQue) && /colis|português/i.test(verbete('T')!.porQue));
t('N explica por que N e não I', /iNtuition/i.test(verbete('N')!.porQue));
t('F alerta que Sentimento não é emoção', /não.{0,4} emoção/i.test(verbete('F')!.porQue));

console.log(`\n RESULTADO: ${ok} aprovadas, ${falhas} falhas. ${GLOSSARIO.length} verbetes no glossário.`);
process.exit(falhas ? 1 : 0);
