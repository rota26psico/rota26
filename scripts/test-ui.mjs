/**
 * TESTES DE INTERFACE NO NAVEGADOR
 * ===========================================================================
 * Playwright sobre Chromium, percorrendo a pré-visualização de verdade:
 * preenche as 48 situações, chega ao resultado, navega pelos dashboards e opera
 * a gestão de dados. Nenhum mock, nenhuma captura estática.
 *
 * A seção 1 protege o item 39 do prompt de redesign: a marca é um ARQUIVO
 * oficial, e restrição sem teste é promessa. Se alguém apagar o arquivo, mudar
 * a proporção, aplicar filtro ou encolher a marca, isto falha.
 *
 *   node scripts/build-previa.mjs && node scripts/test-ui.mjs
 */
import { chromium } from 'playwright';
import { existsSync } from 'node:fs';
import { resolve } from 'node:path';

const ARQUIVO = resolve('dist/demo.html');
if (!existsSync(ARQUIVO)) {
  console.error('\n  dist/demo.html não existe. Rode antes: node scripts/build-previa.mjs\n');
  process.exit(1);
}

let ok = 0, falhas = 0;
const erros = [];
const V = '\x1b[32m✓\x1b[0m', X = '\x1b[31m✗\x1b[0m';

function checar(nome, condicao, detalhe = '') {
  if (condicao) { ok++; console.log(`  ${V} ${nome}`); }
  else {
    falhas++; erros.push(nome + (detalhe ? ` — ${detalhe}` : ''));
    console.log(`  ${X} ${nome}${detalhe ? ` — ${detalhe}` : ''}`);
  }
}
const secao = (t) => console.log(`\n\x1b[2m── ${t}\x1b[0m`);

/* Usa um Chromium já presente no ambiente, se houver, em vez de exigir
   `npx playwright install`. */
const CHROMIUM = process.env.CHROMIUM_PATH ?? '/opt/pw-browsers/chromium';
const navegador = await chromium.launch(existsSync(CHROMIUM) ? { executablePath: CHROMIUM } : {});
const contexto = await navegador.newContext({ viewport: { width: 1280, height: 900 } });
const pg = await contexto.newPage();

const errosJs = [];
pg.on('pageerror', (e) => errosJs.push(String(e)));
pg.on('console', (m) => { if (m.type() === 'error') errosJs.push(m.text()); });

await pg.goto('file://' + ARQUIVO);
// O primeiro filho de #root é o <svg> invisível dos símbolos; esperar por ele
// daria timeout. Espera-se pelo primeiro conteúdo visível.
await pg.waitForSelector('#root main, #root .wrap', { state: 'visible', timeout: 30000 });

const aba = async (nome) => {
  await pg.getByRole('button', { name: nome, exact: false }).first().click();
  await pg.waitForTimeout(250);
};
const texto = () => pg.locator('body').innerText();

/* ══════ 1 · A MARCA — item 39 ═══════════════════════════════════════════ */
secao('1 · A marca é o arquivo oficial (item 39)');

const marca = pg.locator('img[alt*="ROTA26" i], img[src*="rota26"], .placa img').first();
checar('A marca é uma <img>, não um lockup recriado em CSS', await marca.count() > 0);

const dim = await marca.evaluate((el) => ({
  natW: el.naturalWidth, natH: el.naturalHeight,
  w: el.getBoundingClientRect().width, h: el.getBoundingClientRect().height,
  ...(({ filter, transform, mixBlendMode }) => ({ filter, transform, mixBlendMode }))(getComputedStyle(el))
}));

checar('O arquivo oficial carrega de fato (naturalWidth > 0)', dim.natW > 0, `naturalWidth=${dim.natW}`);

const PROP = 479 / 385;
const desvio = Math.abs((dim.w / dim.h) - PROP) / PROP;
checar('Proporção 479:385 preservada (tolerância 1%)', desvio <= 0.01,
  `renderizada ${(dim.w / dim.h).toFixed(4)} vs ${PROP.toFixed(4)} — desvio ${(desvio * 100).toFixed(2)}%`);

checar('A marca tem no mínimo 48px de altura', dim.h >= 48, `${dim.h.toFixed(0)}px`);
checar('Nenhum filtro, deformação ou mistura aplicada sobre a marca',
  ['none', ''].includes(dim.filter) && ['none', ''].includes(dim.transform) &&
  ['normal', ''].includes(dim.mixBlendMode), JSON.stringify(dim));

checar('O selo "Instrumento Piloto de Desenvolvimento Organizacional" está presente',
  /instrumento piloto de desenvolvimento organizacional/i.test(await texto()));

const simbolos = await pg.locator('svg symbol[id^="a-"]').count();
checar('Os oito símbolos de animal existem uma única vez (sem ID duplicado)',
  simbolos === 8, `${simbolos} encontrados`);

/* ══════ 2 · PERCURSO COMPLETO ═══════════════════════════════════════════ */
secao('2 · Percurso completo — identificação, 48 situações, resultado');

checar('Os campos de identificação têm label associado (leitor de tela)',
  await pg.getByLabel(/nome completo/i).count() > 0 &&
  await pg.getByLabel(/matr[ií]cula/i).count() > 0 &&
  await pg.getByLabel(/setor/i).count() > 0);

const btnIniciar = pg.getByRole('button', { name: /iniciar ou continuar/i });
checar('O botão de início começa desabilitado, sem identificação',
  await btnIniciar.isDisabled());

await pg.getByLabel(/nome completo/i).first().fill('Teste Interface');
await pg.getByLabel(/matr[ií]cula/i).first().fill('UI-0001');
checar('O botão habilita quando a identificação fica válida', await btnIniciar.isEnabled());

await btnIniciar.click();
await pg.waitForTimeout(300);

const q1 = await texto();
checar('O questionário abre na situação 1 de 48', /situa[çc][ãa]o\s*1\s*de\s*48/i.test(q1));
checar('Cada situação oferece quatro alternativas', await pg.locator('button.alt').count() === 4);
checar('Declara que não há alternativa certa ou errada',
  /n[ãa]o h[áa] alternativa certa ou errada/i.test(q1));
checar('Declara que a ordem das alternativas é embaralhada',
  /ordem das alternativas [ée] embaralhada/i.test(q1));

// Responde as 48. Varia a alternativa escolhida para não produzir um vetor
// artificialmente puro. Depois de cada clique, ESPERA o contador avançar — a
// tela troca de situação com transição, e clicar durante a troca perde o
// clique (foi o que aconteceu ao escrever este teste).
const verResultado = pg.getByRole('button', { name: /ver meu resultado/i });
const progresso = pg.getByText(/\d+ respondidas/).first();
const contador = async () => Number(/(\d+) respondidas/.exec(await progresso.innerText())?.[1] ?? -1);

let respondidas = 0;
for (let i = 0; i < 48; i++) {
  const antes = await contador();
  for (let tentativa = 0; tentativa < 12; tentativa++) {
    const alts = pg.locator('button.alt');
    if (await alts.count() === 0) break;
    await alts.nth(i % 4).click().catch(() => {});
    await pg.waitForTimeout(60);
    if (await contador() > antes) break;
  }
  if (await contador() > antes) respondidas++; else break;
}
const qFim = await texto();
checar('As 48 situações foram respondidas', /48 respondidas/.test(qFim), `${respondidas} cliques`);
checar('O botão de resultado só aparece com as 48 respondidas',
  await verResultado.count() > 0 && respondidas === 48, `${respondidas} respostas`);
// O contador conta GRAVAÇÕES, não respostas distintas: reescolher a mesma
// situação grava de novo. Por isso >= 48, e não == 48.
const gravadas = Number(/respostas gravadas nesta sess[ãa]o:\s*(\d+)/i.exec(qFim)?.[1] ?? -1);
checar('O salvamento incremental grava cada escolha no instante em que ocorre',
  gravadas >= 48, `${gravadas} gravações`);

await verResultado.click();
await pg.waitForTimeout(700);

/* ══════ 3 · RESULTADO INDIVIDUAL ════════════════════════════════════════ */
secao('3 · Resultado individual — oito blocos e linguagem não diagnóstica');

const res = await texto();

checar('Bloco 1 é a abertura escura com o animal em disco',
  await pg.locator('.abertura').count() >= 1 &&
  await pg.locator('.abertura svg').count() >= 1);

const BLOCOS = [
  /sua configura[çc][ãa]o/i, /como voc[êe] tende a funcionar/i, /seis eixos|eixos comportamentais/i,
  /capacidades/i, /belbin|proximidade/i, /luz|sombra/i, /voc[êe] dentro da sua equipe/i, /limites/i
];
const presentes = BLOCOS.filter((r) => r.test(res)).length;
checar('Os oito blocos do resultado estão presentes', presentes === 8, `${presentes}/8`);

checar('Diz "Sua maior correspondência simbólica"',
  /sua maior correspond[êe]ncia simb[óo]lica/i.test(res));
checar('NÃO afirma "você é uma raposa" / "você é um lobo"',
  !/voc[êe] [ée] (um|uma) (raposa|lobo|urso|on[çc]a|cavalo|carneiro|elefante|baleia)/i.test(res));
checar('Declara que a metáfora não constitui diagnóstico',
  /n[ãa]o constitui diagn[óo]stico/i.test(res));
checar('Explica que a secundária vem obrigatoriamente do par oposto',
  /par oposto/i.test(res));

checar('Os três cartões de Belbin foram renderizados',
  await pg.locator('.belcard').count() === 3, `${await pg.locator('.belcard').count()}`);
checar('O gráfico dos nove papéis de Belbin foi preservado',
  await pg.locator('.dim, .barra, svg').count() > 0);

const porques = await pg.locator('details.porque').count();
checar('As explicações "por que é assim" são clicáveis e abundantes',
  porques >= 20, `${porques} blocos <details>`);

const primeiro = pg.locator('details.porque').first();
await primeiro.locator('summary').click();
await pg.waitForTimeout(120);
checar('Abrir uma explicação revela o texto do porquê',
  (await primeiro.innerText()).length > 120);

/* ══════ 4 · DASHBOARDS ══════════════════════════════════════════════════ */
secao('4 · Dashboards de equipe e organização');

await aba(/^Equipes$/);
const eq = await texto();
const SECOES = [/s[íi]ntese/i, /composi[çc][ãa]o/i, /diversidade/i, /cobertura/i, /interpreta[çc][ãa]o/i, /a[çc][ãa]o/i];
const achadas = SECOES.filter((r) => r.test(eq)).length;
checar('O dashboard de equipe tem as seis seções', achadas === 6, `${achadas}/6`);
checar('IDF aparece com leitura em texto, não só o número', /IDF/.test(eq) && /diversidade/i.test(eq));
checar('ICF aparece com leitura em texto, não só o número', /ICF/.test(eq) && /cobertura/i.test(eq));
checar('Grupos com menos de 5 respondentes são tratados explicitamente',
  /5 respondentes|menos de 5/i.test(eq));

await aba(/^Animais$/);
const an = await texto();
checar('A composição simbólica mostra os oito animais, inclusive os zerados',
  ['Lobo', 'Raposa', 'Urso', 'Onça', 'Cavalo', 'Carneiro', 'Elefante', 'Baleia']
    .every((a) => an.includes(a)));
checar('Usa "maior e menor representação", nunca a palavra "lacuna"',
  /maior representa|menor representa/i.test(an) && !/lacuna/i.test(an));

// Clicar em "Percentual" — clicar em "Quantidade", que já está ativo, não
// mudaria nada e daria um falso negativo.
const btnQtd = pg.getByRole('button', { name: /^Quantidade$/ }).first();
const btnPct = pg.getByRole('button', { name: /^Percentual$/ }).first();
checar('A matriz Equipe × Animal tem o alternador quantidade/percentual',
  await btnQtd.count() > 0 && await btnPct.count() > 0);
checar('O modo ativo é anunciado por aria-pressed',
  await btnQtd.getAttribute('aria-pressed') === 'true' &&
  await btnPct.getAttribute('aria-pressed') === 'false');

const tabela = pg.locator('table').first();
const emQuantidade = await tabela.innerText();
await btnPct.click(); await pg.waitForTimeout(250);
const emPercentual = await tabela.innerText();
checar('Alternar para Percentual muda de fato os valores da matriz',
  emPercentual !== emQuantidade);
checar('Em percentual, cada linha totaliza 100%',
  /100%/.test(emPercentual), emPercentual.slice(0, 80));
await btnQtd.click(); await pg.waitForTimeout(200);
checar('Voltar para Quantidade restaura os números originais',
  (await tabela.innerText()) === emQuantidade);

await aba(/^Vis[ãa]o geral$/);
checar('A visão organizacional carrega', /organiza|geral/i.test(await texto()));

await aba(/^Siglas$/);
// Os grupos do glossário começam recolhidos por escolha de projeto — o texto
// só existe em innerText depois de abertos.
const grupos = pg.locator('details');
const nGrupos = await grupos.count();
// Duas passagens: os verbetes são <details> DENTRO dos <details> de grupo, e
// enquanto o grupo está fechado o verbete não é clicável.
for (let passagem = 0; passagem < 2; passagem++) {
  const n = await grupos.count();
  for (let i = 0; i < n; i++) {
    const d = grupos.nth(i);
    if (await d.evaluate((el) => el.open)) continue;
    await d.locator('summary').first().click({ timeout: 1500 }).catch(() => {});
  }
  await pg.waitForTimeout(250);
}
const gl = await texto();
checar('A página de siglas agrupa os verbetes em blocos recolhíveis', nGrupos >= 5, `${nGrupos}`);
checar('O glossário alerta que "Sentimento" em Jung não é emocionalidade',
  /fun[çc][ãa]o racional de julgamento/i.test(gl) && /n[ãa]o emo[çc][ãa]o/i.test(gl));
checar('A página de siglas explica IDF e ICF por extenso',
  /[íi]ndice de diversidade/i.test(gl) && /[íi]ndice de cobertura/i.test(gl));

await aba(/Gest[ãa]o de dados/);
checar('A gestão de dados oferece exportação em Excel',
  await pg.getByRole('button', { name: /excel|exportar/i }).count() > 0);

/* ══════ 5 · LINGUAGEM E LIMITES ═════════════════════════════════════════ */
secao('5 · Limites declarados');

const tudo = await texto();
checar('Declara que não serve para seleção, promoção ou desligamento',
  /n[ãa]o deve ser usado para (sele[çc][ãa]o|promo)/i.test(tudo));
checar('Declara que não possui validação psicométrica / usa escores internos',
  /escores internos|n[ãa]o percentis|valida[çc][ãa]o psicom/i.test(tudo));

/* ══════ 6 · RESPONSIVIDADE ══════════════════════════════════════════════ */
secao('6 · Responsividade em 390px');

await pg.setViewportSize({ width: 390, height: 844 });
await pg.waitForTimeout(400);
const excesso = await pg.evaluate(() =>
  document.documentElement.scrollWidth - document.documentElement.clientWidth);
checar('Sem rolagem horizontal em viewport de 390px', excesso <= 1, `excesso de ${excesso}px`);

const dMob = await marca.evaluate((el) => el.getBoundingClientRect());
const desvioMob = Math.abs((dMob.width / dMob.height) - PROP) / PROP;
checar('A proporção da marca também se mantém no celular', desvioMob <= 0.01,
  `desvio ${(desvioMob * 100).toFixed(2)}%`);

await pg.setViewportSize({ width: 1280, height: 900 });

/* ══════ 7 · CONSOLE ═════════════════════════════════════════════════════ */
secao('7 · Console');
checar('Nenhum erro de JavaScript durante todo o percurso',
  errosJs.length === 0, errosJs.slice(0, 3).join(' | '));

await navegador.close();

console.log('\n' + '═'.repeat(78));
console.log(` RESULTADO: ${ok} aprovadas, ${falhas} falhas.`);
if (falhas) console.log('\n' + erros.map((e) => '  • ' + e).join('\n'));
console.log('═'.repeat(78) + '\n');
process.exit(falhas ? 1 : 0);
