/**
 * VERIFICAÇÃO DO DASHBOARD E DA IDENTIFICAÇÃO
 * ===========================================================================
 *   node verifica-dashboard.mjs
 */
import pw from 'playwright';
const { chromium } = pw;
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

/* Caminhos resolvidos a partir deste arquivo, e não fixos na máquina de origem:
   o pacote vinha com /home/claude/app embutido. O Chromium segue a mesma
   convenção que scripts/test-ui.mjs já usava neste projeto. */
const RAIZ = fileURLToPath(new URL('../..', import.meta.url));
const CHROMIUM = process.env.CHROMIUM_PATH ?? '/opt/pw-browsers/chromium';


const V = '\x1b[32m✓\x1b[0m', X = '\x1b[31m✗\x1b[0m';
let ok = 0, falhas = 0; const erros = [];
const checar = (n, c, d = '') => {
  if (c) { ok++; console.log(`  ${V} ${n}`); }
  else { falhas++; erros.push(n + (d ? ` — ${d}` : '')); console.log(`  ${X} ${n}${d ? ` — ${d}` : ''}`); }
};
const secao = t => console.log(`\n\x1b[2m── ${t}\x1b[0m`);

const nav = await chromium.launch({ executablePath: CHROMIUM });
const pg = await (await nav.newContext({ viewport: { width: 1240, height: 950 } })).newPage();
const errosJs = [];
pg.on('pageerror', e => errosJs.push(String(e)));
/* O Google Fonts não carrega neste ambiente isolado; isso é da rede, não da página. */
pg.on('console', m => { if (m.type() === 'error' && !/ERR_TUNNEL|fonts\.googleapis/.test(m.text())) errosJs.push(m.text()); });

await pg.goto('file://' + resolve('ROTA26-demo-v2.html'));
await pg.waitForSelector('#app .barra');

/* ══════ 1 · IDENTIFICAÇÃO ══════════════════════════════════════════════ */
secao('1 · Identificação obrigatória do participante');

checar('A demo abre na identificação, antes de qualquer questão',
  await pg.locator('#f-ct').count() === 1);
const CONTRATOS = ['MEC','MDHC','MM','MS','ANTT','HUMAN POWER','TERRACAP','AGSUS/AGESUS',
  'MONITORIA','FINANCEIRO','DH','JURÍDICO','DAP','SESMT','INFRAESTRUTURA','PLANEJAMENTO'];
const opts = await pg.locator('#f-ct option').allInnerTexts();
checar('Os 16 contratos exigidos estão na lista',
  CONTRATOS.every(c => opts.includes(c)), CONTRATOS.filter(c => !opts.includes(c)).join(', '));

checar('Setor começa desabilitado até haver contrato', await pg.locator('#f-st').isDisabled());
checar('Líder começa desabilitado até haver setor', await pg.locator('#f-li').isDisabled());
checar('O botão de início começa bloqueado',
  await pg.getByRole('button', { name: 'Iniciar' }).isDisabled());
checar('O período de resposta é declarado como automático',
  /registrado automaticamente pelo sistema, não preenchido por você/i.test(await pg.locator('.form').innerText()));

await pg.locator('#f-ct').selectOption('ANTT'); await pg.waitForTimeout(150);
checar('Escolher contrato libera e povoa o setor',
  !(await pg.locator('#f-st').isDisabled()) && (await pg.locator('#f-st option').count()) > 1);
const setores = await pg.locator('#f-st option').allInnerTexts();
checar('Os setores são os do contrato escolhido (cascata)',
  setores.includes('Fiscalização') && setores.includes('Concessões') && !setores.includes('Engenharia'),
  setores.join(', '));

await pg.locator('#f-st').selectOption('Fiscalização'); await pg.waitForTimeout(150);
checar('Escolher setor libera e povoa o líder imediato',
  !(await pg.locator('#f-li').isDisabled()) && (await pg.locator('#f-li option').count()) > 1);

await pg.locator('#f-li').selectOption({ index: 1 });
await pg.locator('#f-nm').fill('Participante de Teste');
await pg.locator('#f-mt').fill('M99999');
await pg.waitForTimeout(150);
checar('Com tudo preenchido, o início libera',
  await pg.getByRole('button', { name: 'Iniciar' }).isEnabled());

/* ══════ 2 · O PARTICIPANTE NÃO ALCANÇA DADOS COLETIVOS ═════════════════ */
secao('2 · O que o participante vê no percurso');

await pg.getByRole('button', { name: 'Iniciar' }).click();
await pg.waitForTimeout(250);
const noQuestionario = await pg.locator('body').innerText();
checar('Na tela de questões não há nome de outro respondente',
  !/M1000\d|M2000\d/.test(noQuestionario));
checar('Não há dashboard nem indicador coletivo em tela',
  !/dispersão|homofilia|classificação da equipe/i.test(noQuestionario));

for (let n = 0; n < 48; n++) {
  const antes = await pg.locator('.rota-rot').innerText();
  for (let t = 0; t < 8; t++) {
    await pg.locator('.alt').nth((n * 3) % 4).click().catch(() => {});
    await pg.waitForTimeout(22);
    if (await pg.locator('.rota-rot').innerText() !== antes) break;
  }
}
await pg.getByRole('button', { name: /ver meu resultado/i }).click();
await pg.waitForTimeout(400);
if (await pg.locator('.desempate').count()) {
  await pg.locator('.desempate .alt').first().click();
  await pg.waitForTimeout(400);
}
const noResultado = await pg.locator('body').innerText();
checar('O resultado individual traz um único animal',
  (await pg.locator('.abertura h2').count()) === 1);
checar('O resultado não expõe equipe, líder nem outros respondentes',
  !/homofilia|comparação líder|respondentes do recorte/i.test(noResultado));

/* ══════ 3 · DASHBOARD ══════════════════════════════════════════════════ */
secao('3 · Área do administrador');

await pg.getByRole('button', { name: /área do administrador/i }).click();
await pg.waitForTimeout(200);
checar('A entrada administrativa declara que o acesso é simulado nesta demo',
  /nesta demo o acesso é simulado/i.test(await pg.locator('.aviso-sim').innerText()));
await pg.getByRole('button', { name: 'Entrar' }).click();
await pg.waitForTimeout(400);

const d = await pg.locator('body').innerText();
checar('O dashboard abre com os filtros exigidos',
  ['#x-ct','#x-st','#x-li','#x-de','#x-ate','#x-ps'].every(async () => true)
  && (await pg.locator('#x-ct').count()) === 1 && (await pg.locator('#x-st').count()) === 1
  && (await pg.locator('#x-li').count()) === 1 && (await pg.locator('#x-de').count()) === 1
  && (await pg.locator('#x-ate').count()) === 1 && (await pg.locator('#x-ps').count()) === 1);

for (const t of ['Visão geral','Distribuição dos oito animais','Famílias de contribuição',
                 'Funções, atitude e eixos','Configuração da equipe','Comparação líder × equipe',
                 'Leitura gerencial','Respondentes do recorte']) {
  checar(`Seção presente: ${t}`, new RegExp(t.replace(/[.*+?^${}()|[\]\\]/g,'\\$&'), 'i').test(d));
}
checar('Os oito animais aparecem na distribuição',
  ['Lobo','Elefante','Carneiro','Baleia','Cavalo','Urso','Raposa','Onça']
    .every(a => new RegExp(`\\b${a}\\b`).test(d)));
checar('As quatro famílias de contribuição aparecem',
  ['Análise','Relacionamento','Execução','Inovação'].every(f => d.includes(f)));
checar('Os dois eixos aparecem', /eixo cognitivo/i.test(d) && /eixo relacional/i.test(d));
checar('Extroversão e introversão aparecem', /\bE \d+%/.test(d) && /\bI \d+%/.test(d));
checar('Percentual com leitura complementar aparece', /leitura complementar/i.test(d));
checar('Contagem de desempates aparece', /precisaram de desempate/i.test(d));
checar('Sem filtro de equipe, nenhum líder isolado é apresentado como o da equipe inteira',
  (await pg.locator('.l-nome').count()) === 0 && /reúne\s+\d+\s+lideranças/i.test(d));

/* ══════ 4 · CLASSIFICAÇÃO E LINGUAGEM ══════════════════════════════════ */
secao('4 · Classificação e linguagem');

const CLASSES = ['Diversa e estratégica','Diversa com necessidade de alinhamento',
  'Predominantemente homogênea','Fragmentada'];
const classeAtual = await pg.locator('.c-nome').innerText();
checar('A equipe recebe uma das quatro classificações previstas',
  CLASSES.includes(classeAtual.trim()), classeAtual);
checar('A classificação é apresentada como hipótese, não julgamento',
  /hipótese de gestão, não julgamento/i.test(d));
checar('O critério aplicado é mostrado ao gestor', /critério aplicado/i.test(d));

const PROIBIDO = ['Planta','Implementador','Monitor Avaliador','Investigador de Recursos',
  'Trabalhador em Equipe','Finalizador','Formador','Coordenador','Especialista'];
const vazou = PROIBIDO.filter(t => new RegExp(`\\b${t}\\b`).test(d));
checar('Nenhum nome técnico de Belbin aparece no dashboard', vazou.length === 0, vazou.join(', '));

const JULGAMENTO = [/\bmelhor\b/i, /\bpior\b/i, /\binadequad/i, /\badequad[oa]s?\b/i];
const julga = JULGAMENTO.filter(r => r.test(d));
checar('Não usa melhor, pior, adequado ou inadequado', julga.length === 0, julga.join(' '));

/* ══════ 5 · FILTROS ════════════════════════════════════════════════════ */
secao('5 · Filtros');

const totalGeral = Number((/Respondentes\s+(\d+)/i.exec(d) ?? [])[1] ?? 0);
checar('A visão sem filtro mostra a população inteira', totalGeral > 100, `${totalGeral}`);

await pg.locator('#x-ct').selectOption('ANTT'); await pg.waitForTimeout(300);
const d2 = await pg.locator('body').innerText();
const nAntt = Number((/Respondentes\s+(\d+)/i.exec(d2) ?? [])[1] ?? 0);
checar('Filtrar por contrato reduz o recorte', nAntt > 0 && nAntt < totalGeral, `${nAntt} de ${totalGeral}`);
checar('A tabela só mostra o contrato filtrado',
  !(await pg.locator('table.lista-p').innerText()).includes('TERRACAP'));

await pg.locator('#x-st').selectOption('Fiscalização'); await pg.waitForTimeout(300);
const nSetor = Number((/Respondentes\s+(\d+)/i.exec(await pg.locator('body').innerText()) ?? [])[1] ?? 0);
checar('Filtrar por setor reduz mais ainda', nSetor > 0 && nSetor <= nAntt, `${nSetor}`);
checar('Com setor único, a comparação líder × equipe traz o líder de fato',
  (await pg.locator('.l-nome').count()) === 1);

await pg.locator('#x-limpar').click(); await pg.waitForTimeout(300);
const nVolta = Number((/Respondentes\s+(\d+)/i.exec(await pg.locator('body').innerText()) ?? [])[1] ?? 0);
checar('Limpar filtros devolve a população inteira', nVolta === totalGeral, `${nVolta}`);

/* ══════ 6 · AMOSTRA MÍNIMA ═════════════════════════════════════════════ */
secao('6 · Amostra mínima');

await pg.locator('#x-ps').selectOption({ index: 1 }); await pg.waitForTimeout(300);
checar('Com um único respondente, os indicadores coletivos NÃO são exibidos',
  (await pg.locator('.vazio').count()) === 1 && /abaixo de cinco/i.test(await pg.locator('.vazio').innerText()));
await pg.locator('#x-limpar').click(); await pg.waitForTimeout(250);

/* ══════ 8 · RELATÓRIO INTEGRAL DE DIVERSIDADE ══════════════════════════ */
secao('8 · Relatório integral de diversidade');

/* Recorte de uma equipe só, que é onde o relatório fica completo. */
await pg.locator('#x-ct').selectOption('ANTT'); await pg.waitForTimeout(250);
await pg.locator('#x-st').selectOption('Fiscalização'); await pg.waitForTimeout(250);
await pg.getByRole('button', { name: 'Relatório integral' }).click();
await pg.waitForTimeout(500);

const r = await pg.locator('body').innerText();
const secoesR = (await pg.locator('.ri-sec > h3').allInnerTexts()).map(t => t.replace(/\s+/g, ' ').trim());
for (const t of ['Recorte analisado','Participação','Distribuição dos animais predominantes',
  'Atitudes e funções de Jung','Contribuições de equipe','Forças predominantes',
  'Lacunas e contribuições pouco representadas','Equilíbrio entre estratégia',
  'Riscos de composição','Complementaridade entre os membros',
  'Comparação entre a liderança','Homofilia','Recomendações práticas','Limites de uso'])
  checar(`Seção exigida presente: ${t}`,
    secoesR.some(h => h.toLowerCase().includes(t.toLowerCase())), secoesR.join(' | ').slice(0,120));

checar('Traz contrato, setor, líder e período do recorte',
  /Contrato/i.test(r) && /ANTT/.test(r) && /Fiscalização/.test(r) &&
  /Líder imediato/i.test(r) && /Período analisado/i.test(r));
checar('Traz número de participantes e percentual de adesão',
  /Responderam/i.test(r) && /Adesão/i.test(r) && /\d+%/.test(r));
checar('Distribuição dos animais é nominal E percentual',
  /Pessoas/i.test(r) && /Pensamento Extrovertido/i.test(r));
checar('Traz as quatro funções e as duas atitudes de Jung',
  ['Pensamento','Sentimento','Sensação','Intuição','Extroversão','Introversão']
    .every(t => new RegExp(t, 'i').test(r)));

const NOVE_EXIGIDAS = ['Ideias','Estratégia','Organização','Análise de riscos','Execução',
  'Qualidade','Colaboração','Conhecimento técnico','Direcionamento'];
const faltando9 = NOVE_EXIGIDAS.filter(t => !new RegExp(t.replace(/[.*+?^${}()|[\]\\]/g,'\\$&'), 'i').test(r));
checar('As nove contribuições de equipe aparecem', faltando9.length === 0, faltando9.join(', '));

checar('Cada contribuição é lida contra o esperado, não só em percentual',
  /Esperado/i.test(r) && /Índice/i.test(r) &&
  (await pg.locator('.ri-idx').count()) >= 9);
checar('O relatório explica por que existem duas colunas de percentual',
  /não são\s+igualmente alcançáveis/i.test(r.replace(/\s+/g,' ')));
checar('Os cinco domínios do equilíbrio aparecem, com o que cada um reúne',
  ['Estratégia','Execução','Inovação','Organização','Relacionamento'].every(d => r.includes(d))
  && /Reúne/i.test(r));
checar('Traz complementaridade entre membros com pares de contraponto',
  /contraponto/i.test(r) && /\d\/4/.test(r));
checar('Traz a declaração de limites de uso',
  /não constitui diagnóstico psicológico/i.test(r) &&
  /não deve ser usado para seleção/i.test(r));

const vazouR = PROIBIDO.filter(t => new RegExp(`\\b${t}\\b`).test(r));
checar('Nenhum nome técnico de Belbin aparece no relatório', vazouR.length === 0, vazouR.join(', '));
const julgaR = JULGAMENTO.filter(re => re.test(r));
checar('O relatório não usa melhor, pior, adequado ou inadequado',
  julgaR.length === 0, julgaR.join(' '));

/* O relatório obedece à mesma amostra mínima do painel. */
await pg.getByRole('button', { name: /dashboard/i }).click(); await pg.waitForTimeout(300);
await pg.locator('#x-ps').selectOption({ index: 1 }); await pg.waitForTimeout(300);
await pg.getByRole('button', { name: 'Relatório integral' }).click();
await pg.waitForTimeout(400);
checar('Com menos de cinco pessoas, o relatório não é emitido',
  (await pg.locator('.vazio').count()) === 1 && (await pg.locator('.ri-sec').count()) === 0);
await pg.getByRole('button', { name: /dashboard/i }).click(); await pg.waitForTimeout(300);
await pg.locator('#x-limpar').click(); await pg.waitForTimeout(300);

/* ══════ 7 · CONSOLE E RESPONSIVIDADE ═══════════════════════════════════ */
secao('7 · Console e responsividade');
checar('Nenhum erro de JavaScript em todo o percurso', errosJs.length === 0, errosJs.slice(0,2).join(' | '));
await pg.setViewportSize({ width: 390, height: 844 }); await pg.waitForTimeout(400);
const excesso = await pg.evaluate(() =>
  document.documentElement.scrollWidth - document.documentElement.clientWidth);
checar('Sem rolagem horizontal em 390px', excesso <= 1, `${excesso}px`);

await nav.close();
console.log('\n' + '═'.repeat(74));
console.log(` DASHBOARD: ${ok} aprovadas, ${falhas} falhas.`);
if (falhas) console.log('\n' + erros.map(e => '  • ' + e).join('\n'));
console.log('═'.repeat(74) + '\n');
process.exit(falhas ? 1 : 0);
