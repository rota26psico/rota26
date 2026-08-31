/**
 * O MOTOR DA DEMO É O MESMO MOTOR?
 * ===========================================================================
 * A demo roda uma porta em JavaScript de `src/lib/v2/apuracao.ts`. Se as duas
 * divergirem, a demo estaria mostrando um instrumento que não existe.
 *
 * Este script extrai o motor de dentro do HTML gerado, roda os DOIS sobre
 * milhares de conjuntos de respostas e exige resultado idêntico campo a campo.
 *
 *   node verifica-demo.mjs
 */
import { readFileSync } from 'node:fs';
import { execSync } from 'node:child_process';
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

/* ── 1 · o motor real, em Node, sob a condição de servidor ────────────── */
console.log('\n\x1b[2m── 1 · Gerando os casos com o motor real (TypeScript)\x1b[0m');
const script = `
import { apurar, aplicarDesempate, temComplementar } from '../src/lib/v2/apuracao';
import { QUESTOES_V2 } from '../src/data/v2/questoes';
let s = 424242; const rnd = () => { s = (s*1103515245+12345)&0x7fffffff; return s/0x7fffffff; };
const casos: any[] = [];
for (let n = 0; n < 4000; n++) {
  const idx = QUESTOES_V2.map(() => Math.floor(rnd()*4));
  const resp = QUESTOES_V2.map((q,i) => ({ questaoId:q.id, alternativaId:q.alternativas[idx[i]].id }));
  let r: any = apurar(resp);
  const escolha = r.exigeDesempate ? r.emDisputa[Math.floor(rnd()*2)] : null;
  if (escolha) r = aplicarDesempate(r, escolha);
  casos.push({ idx, escolha, saida: {
    bruto:r.bruto, relativo:r.relativo, totalPontos:r.totalPontos, ordem:r.ordem,
    predominante:r.predominante, secundaria:r.secundaria, margem:r.margem,
    amplitude:r.amplitude, classificacao:r.classificacao,
    atitudes:r.atitudes, funcoesRelativas:r.funcoesRelativas,
    eixoCognitivo:r.eixoCognitivo, eixoRelacional:r.eixoRelacional,
    orientacaoEnergia:r.orientacaoEnergia,
    equilibrioFuncional:r.equilibrioFuncional, equilibrioAtitude:r.equilibrioAtitude,
    possivelConflito:r.possivelConflito, empateBruto:r.empateBruto,
    desempateAplicado:r.desempateAplicado, complementar:temComplementar(r)
  }});
}
console.log(JSON.stringify(casos));
`;
execSync(`cat > ${RAIZ}scripts/_ref.ts <<'FIM'\n${script}\nFIM`);
const bruto = execSync('npx tsx --conditions=react-server scripts/_ref.ts',
  { cwd: RAIZ, encoding: 'utf8', maxBuffer: 200 * 1024 * 1024 });
execSync(`rm -f ${RAIZ}scripts/_ref.ts`);
const casos = JSON.parse(bruto.trim().split('\n').pop());
checar(`${casos.length} casos gerados pelo motor real`, casos.length === 4000);
const comDesempate = casos.filter(c => c.escolha).length;
console.log(`     ${comDesempate} deles (${(comDesempate / casos.length * 100).toFixed(1)}%) dispararam desempate`);

/* ── 2 · o motor da demo, dentro do navegador ─────────────────────────── */
console.log('\n\x1b[2m── 2 · Rodando os mesmos casos dentro da demo\x1b[0m');
const nav = await chromium.launch({ executablePath: CHROMIUM });
const pg = await (await nav.newContext()).newPage();
const errosJs = [];
pg.on('pageerror', e => errosJs.push(String(e)));
await pg.goto('file://' + resolve('ROTA26-demo-v2.html'));
await pg.waitForSelector('#app .barra', { timeout: 20000 });
checar('A demo carrega e renderiza a abertura', true);
checar('Nenhum erro de JavaScript ao carregar', errosJs.length === 0, errosJs[0] ?? '');

const saidas = await pg.evaluate((casos) => casos.map(c => {
  const resp = D.QUESTOES.map((q, i) => ({ questaoId: q.id, alternativaId: q.a[c.idx[i]].id }));
  let r = apurar(resp);
  if (c.escolha) r = aplicarDesempate(r, c.escolha);
  return {
    bruto: r.bruto, relativo: r.relativo, totalPontos: r.totalPontos, ordem: r.ordem,
    predominante: r.predominante, secundaria: r.secundaria, margem: r.margem,
    amplitude: r.amplitude, classificacao: r.classificacao,
    atitudes: r.atitudes, funcoesRelativas: r.funcoesRelativas,
    eixoCognitivo: r.eixoCognitivo, eixoRelacional: r.eixoRelacional,
    orientacaoEnergia: r.orientacaoEnergia,
    equilibrioFuncional: r.equilibrioFuncional, equilibrioAtitude: r.equilibrioAtitude,
    possivelConflito: r.possivelConflito, empateBruto: r.empateBruto,
    desempateAplicado: r.desempateAplicado, complementar: temComplementar(r)
  };
}), casos);

/* ── 3 · comparação campo a campo ─────────────────────────────────────── */
console.log('\n\x1b[2m── 3 · Comparação campo a campo\x1b[0m');
const divergencias = [];
for (let i = 0; i < casos.length; i++) {
  const a = JSON.stringify(casos[i].saida), b = JSON.stringify(saidas[i]);
  if (a !== b) {
    if (divergencias.length < 3) {
      const ka = casos[i].saida, kb = saidas[i];
      const campo = Object.keys(ka).find(k => JSON.stringify(ka[k]) !== JSON.stringify(kb[k]));
      divergencias.push(`caso ${i}, campo "${campo}": real=${JSON.stringify(ka[campo])} demo=${JSON.stringify(kb[campo])}`);
    } else divergencias.push('…');
  }
}
checar(`Os dois motores concordam nos ${casos.length} casos`,
  divergencias.length === 0, divergencias.slice(0, 3).join(' | '));

/* ── 4 · percurso de verdade, clicando ────────────────────────────────── */
console.log('\n\x1b[2m── 4 · Percurso completo, clicando na tela\x1b[0m');
await pg.reload(); await pg.waitForSelector('#app .barra');
/* Desde a seção 8 a demo abre na identificação: é preciso preenchê-la antes. */
await pg.locator('#f-ct').selectOption('ANTT'); await pg.waitForTimeout(150);
await pg.locator('#f-st').selectOption({ index: 1 }); await pg.waitForTimeout(150);
await pg.locator('#f-li').selectOption({ index: 1 });
await pg.locator('#f-nm').fill('Participante de Teste');
await pg.locator('#f-mt').fill('M99999');
await pg.waitForTimeout(150);
await pg.getByRole('button', { name: 'Iniciar' }).click();
await pg.waitForTimeout(200);
checar('A primeira situação abre com quatro alternativas',
  (await pg.locator('.alt').count()) === 4);
checar('O botão de resultado começa desabilitado',
  await pg.getByRole('button', { name: /ver meu resultado/i }).isDisabled());

for (let n = 0; n < 48; n++) {
  const antes = await pg.locator('.rota-rot').innerText();
  for (let t = 0; t < 8; t++) {
    await pg.locator('.alt').nth(n % 4).click().catch(() => {});
    await pg.waitForTimeout(25);
    if (await pg.locator('.rota-rot').innerText() !== antes) break;
  }
}
const fim = await pg.locator('.rota-rot').innerText();
checar('As 48 foram respondidas pela interface', /48 respondidas/.test(fim), fim);
checar('O botão de resultado habilita ao completar',
  await pg.getByRole('button', { name: /ver meu resultado/i }).isEnabled());

await pg.getByRole('button', { name: /ver meu resultado/i }).click();
await pg.waitForTimeout(400);

const temDesempate = await pg.locator('.desempate').count() > 0;
if (temDesempate) {
  console.log('     (este percurso disparou o desempate)');
  checar('A tela de desempate mostra exatamente duas alternativas',
    (await pg.locator('.desempate .alt').count()) === 2);
  const txt = await pg.locator('.desempate').innerText();
  checar('A tela de desempate não revela animal, teoria nem finalidade',
    !/\b(Lobo|Elefante|Carneiro|Baleia|Cavalo|Urso|Raposa|Onça|Jung|Belbin|empate|desempate|configura)/i.test(txt));
  await pg.locator('.desempate .alt').first().click();
  await pg.waitForTimeout(400);
}

const res = await pg.locator('body').innerText();
/* Sem /i estas buscas falham: `.rot` e `.bloco>h3` têm text-transform:uppercase,
   e innerText devolve o texto RENDERIZADO, ou seja, em maiúsculas. */
checar('Chega ao relatório individual', /sua maior correspondência simbólica/i.test(res));
const animais = ['Lobo','Elefante','Carneiro','Baleia','Cavalo','Urso','Raposa','Onça'];
const naAbertura = await pg.locator('.abertura h2').innerText();
checar('Exibe UM animal como resultado principal', animais.includes(naAbertura.trim()), naAbertura);
checar('A abertura traz a marca do animal apurado',
  (await pg.locator('.abertura .disco svg use').getAttribute('href')) ===
  '#' + { Lobo:'a-lobo',Elefante:'a-elefante',Carneiro:'a-carneiro',Baleia:'a-baleia',
          Cavalo:'a-cavalo',Urso:'a-urso',Raposa:'a-raposa','Onça':'a-onca' }[naAbertura.trim()]);
checar('O relatório traz os blocos do modelo aprovado',
  ['Como funciona','Potências no trabalho','Luz e sombra','Dentro de uma equipe','Em nove situações']
    .every(t => new RegExp(t.replace(/[.*+?^${}()|[\]\\]/g,'\\$&'),'i').test(res)));
checar('Mantém a declaração de limites',
  /não constituem diagnóstico psicológico/.test(res) && /não deve ser usado para seleção/.test(res));
checar('O painel de bastidores está marcado como não visível ao participante',
  /não visível ao participante/i.test(res));
checar('Nenhum erro de JavaScript no percurso inteiro', errosJs.length === 0, errosJs[0] ?? '');

/* ── 5 · responsividade ───────────────────────────────────────────────── */
console.log('\n\x1b[2m── 5 · Responsividade\x1b[0m');
await pg.setViewportSize({ width: 390, height: 844 });
await pg.waitForTimeout(300);
const excesso = await pg.evaluate(() =>
  document.documentElement.scrollWidth - document.documentElement.clientWidth);
checar('Sem rolagem horizontal em 390px', excesso <= 1, `${excesso}px`);

await nav.close();
console.log('\n' + '═'.repeat(74));
console.log(` DEMO: ${ok} aprovadas, ${falhas} falhas.`);
if (falhas) console.log('\n' + erros.map(e => '  • ' + e).join('\n'));
console.log('═'.repeat(74) + '\n');
process.exit(falhas ? 1 : 0);
