/**
 * TESTE DE SIGILO — o gabarito não pode chegar ao navegador
 * ===========================================================================
 * A exigência mais dura do pedido: "o gabarito e o adendo devem permanecer
 * protegidos no servidor, sem exposição no navegador, no front-end, nos
 * arquivos públicos ou em qualquer área acessível aos participantes".
 *
 * Promessa sem teste é promessa. Este script COMPILA a aplicação e vasculha
 * tudo o que o navegador baixa, procurando qualquer vestígio do mapa
 * confidencial. Se achar, falha.
 *
 *   node scripts/test-sigilo.mjs
 */
import { execSync } from 'node:child_process';
import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const V = '\x1b[32m✓\x1b[0m', X = '\x1b[31m✗\x1b[0m';
let ok = 0, falhas = 0; const erros = [];
const checar = (nome, cond, det = '') => {
  if (cond) { ok++; console.log(`  ${V} ${nome}`); }
  else { falhas++; erros.push(nome + (det ? ` — ${det}` : '')); console.log(`  ${X} ${nome}${det ? ` — ${det}` : ''}`); }
};

/* ── 1 · a camada pública não pode conter o mapa ────────────────────── */
console.log('\n\x1b[2m── 1 · Camada pública das questões\x1b[0m');
/* Remove comentários antes de varrer: o cabeçalho do arquivo DESCREVE o que ele
   não pode conter, e essa descrição não é vazamento. O que importa é o código. */
const semComentarios = (t) => t.replace(/\/\*[\s\S]*?\*\//g, '').replace(/^\s*\/\/.*$/gm, '');
const pub = semComentarios(readFileSync('src/data/v2/questoes.ts', 'utf8'));
checar('questoes.ts não menciona nenhum código de configuração',
  !/['"](Te|Ti|Fe|Fi|Se|Si|Ne|Ni)['"]/.test(pub));
checar('questoes.ts não menciona peso nem âncora',
  !/\bpeso\b|\bancora\b|\bâncora\b/i.test(pub));
/* Com fronteira de palavra e sensível a caixa: os nomes dos animais são nomes
   próprios no gabarito, e sem \b a busca pega "recursos", "discurso", "curso". */
checar('questoes.ts não menciona animal, Jung ou Belbin',
  !/\b(Lobo|Elefante|Carneiro|Baleia|Cavalo|Urso|Raposa|Onça|Jung|Belbin)\b/.test(pub));

/* ── 1-A · a MESMA regra vale para a v1.0, que está coletando ────────── */
console.log('\n\x1b[2m── 1-A · Camada pública das questões da v1.0\x1b[0m');
const pubV1 = semComentarios(readFileSync('src/data/questions.ts', 'utf8'));
/* O que vazava: cada alternativa carregava o polo junguiano e o eixo ao lado do
   texto, e o item carregava o peso. Medido no endereço publicado antes da
   correção: 191 das 192 alternativas baixáveis sem login. */
checar('questions.ts não traz polo junguiano por alternativa',
  !/['"](jung)['"]\s*:|,\s*['"][ETFSNI]['"]\s*,\s*['"](EXP|EXE|AUT|COO|FLE|EST)['"]/.test(pubV1));
checar('questions.ts não traz eixo comportamental por alternativa',
  !/\beixo\s*:/.test(pubV1));
checar('questions.ts não traz peso nem tipo por item',
  !/\bpeso\s*:|\btipo\s*:\s*['"](FUNCAO|ATITUDE)['"]/.test(pubV1));

/* ── 2 · os arquivos confidenciais precisam da trava ────────────────── */
console.log('\n\x1b[2m── 2 · Trava server-only nos arquivos confidenciais\x1b[0m');
for (const f of ['src/data/v2/mapa.server.ts', 'src/data/v2/desempate.server.ts',
                 'src/lib/v2/apuracao.ts',
                 /* v1.0 — a chave que estava no bundle até esta correção */
                 'src/data/questions.server.ts', 'src/data/scoringMatrix.ts',
                 'src/lib/scoring.ts', 'src/lib/repo-servidor.ts']) {
  checar(`${f} começa com import 'server-only'`,
    readFileSync(f, 'utf8').trimStart().startsWith("import 'server-only'"));
}

/* ── 3 · nenhum componente de cliente pode importá-los ──────────────── */
console.log('\n\x1b[2m── 3 · Nenhum componente de cliente importa o confidencial\x1b[0m');
const arquivos = [];
(function varrer(d) {
  for (const e of readdirSync(d)) {
    const p = join(d, e);
    if (statSync(p).isDirectory()) { if (e !== 'node_modules') varrer(p); }
    else if (/\.(ts|tsx|js|jsx|mjs)$/.test(e)) arquivos.push(p);
  }
})('src');
const clientes = arquivos.filter(p => /^\s*['"]use client['"]/m.test(readFileSync(p, 'utf8')));
const infratores = clientes.filter(p =>
  /from\s+['"][^'"]*(mapa\.server|desempate\.server|v2\/apuracao|questions\.server|scoringMatrix|lib\/scoring|repo-servidor)['"]/.test(readFileSync(p, 'utf8')));
checar(`Nenhum dos ${clientes.length} componentes 'use client' importa o mapa`,
  infratores.length === 0, infratores.join(', '));

/* ── 4 · o bundle que o navegador baixa ─────────────────────────────── */
console.log('\n\x1b[2m── 4 · Bundle servido ao navegador\x1b[0m');
console.log('     compilando…');
try {
  execSync('npx next build', { stdio: 'pipe', encoding: 'utf8' });
  checar('A aplicação compila', true);
} catch (e) {
  checar('A aplicação compila', false, String(e.stdout ?? e).split('\n').slice(-14).join(' | '));
}

if (existsSync('.next/static')) {
  const estaticos = [];
  (function varrer(d) {
    for (const e of readdirSync(d)) {
      const p = join(d, e);
      if (statSync(p).isDirectory()) varrer(p);
      else if (/\.(js|json|css|txt|map)$/.test(e)) estaticos.push(p);
    }
  })('.next/static');

  const conteudo = estaticos.map(p => readFileSync(p, 'utf8')).join('\n');
  console.log(`     ${estaticos.length} arquivos estáticos, ${(conteudo.length / 1024 / 1024).toFixed(1)} MB`);

  // O achado que mataria o sigilo: um id de alternativa colado a uma configuração.
  const mapaVazado = /R\d{3}[A-D]\s*[:=]\s*["']?(Te|Ti|Fe|Fi|Se|Si|Ne|Ni)\b/.exec(conteudo);
  checar('Nenhuma associação alternativa → configuração no bundle',
    !mapaVazado, mapaVazado ? mapaVazado[0] : '');

  const ANCORAS = ['R039B', 'R014C', 'R036C', 'R020D', 'R022B', 'R034B', 'R040B', 'R043C'];
  const ancVazada = ANCORAS.filter(a => new RegExp(`${a}["']?\\s*[:=]`).test(conteudo));
  checar('Nenhum item-âncora identificado como tal no bundle',
    ancVazada.length === 0, ancVazada.join(', '));

  checar('Nenhum código de item de desempate (D01…D28) no bundle',
    !/\bD(0[1-9]|1\d|2[0-8])\b\s*["']?\s*[:=]/.test(conteudo));

  // Textos dos itens de desempate: só podem existir no servidor.
  const trecho = 'Escrevo a versão corrigida do procedimento';
  checar('Os enunciados de desempate não estão no bundle do cliente',
    !conteudo.includes(trecho));

  /* ── o mesmo, para a v1.0 que está coletando ─────────────────────── */
  // Era este o vazamento: texto, polo e eixo lado a lado. 191 ocorrências no
  // endereço publicado, sem login, antes da separação em camadas.
  const v1Vazada = conteudo.match(/\["[^"]{15,90}","[ETFSNI]","(EXP|EXE|AUT|COO|FLE|EST)"\]/g) ?? [];
  checar('Nenhuma alternativa da v1.0 com polo e eixo no bundle',
    v1Vazada.length === 0,
    v1Vazada.length ? `${v1Vazada.length} ocorrência(s), ex.: ${v1Vazada[0].slice(0, 60)}` : '');

  const jungVazado = /Q\d{3}[A-D]["']?\s*[:=]\s*\{?\s*jung\s*:/.exec(conteudo);
  checar('Nenhuma associação alternativa → polo junguiano no bundle',
    !jungVazado, jungVazado ? jungVazado[0] : '');

  // A matriz funcional é chave tanto quanto o polo: uma linha por alternativa.
  const matrizVazada = /Q\d{3}[A-D]["']?\s*:\s*\[["'][A-Z]+\d/.exec(conteudo);
  checar('A matriz de pontuação funcional não está no bundle',
    !matrizVazada, matrizVazada ? matrizVazada[0] : '');

  // Sanidade invertida: os textos das 48 DEVEM estar (o participante os lê).
  const q1 = 'Pedem que você contribua com um projeto ainda em fase de ideia';
  const temPergunta = conteudo.includes(q1);
  console.log(`     (as 48 perguntas ${temPergunta ? 'estão' : 'NÃO estão'} no bundle — ` +
    `esperado quando a tela do participante já foi ligada)`);
} else {
  checar('Existe bundle estático para inspecionar', false, '.next/static ausente');
}

console.log('\n' + '═'.repeat(74));
console.log(` SIGILO: ${ok} aprovadas, ${falhas} falhas.`);
if (falhas) console.log('\n' + erros.map(e => '  • ' + e).join('\n'));
console.log('═'.repeat(74) + '\n');
process.exit(falhas ? 1 : 0);
