/** Empacota a demo navegável em um único arquivo HTML autocontido. */
import { build } from 'esbuild';
import { writeFileSync, readFileSync, mkdirSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const raiz = join(dirname(fileURLToPath(import.meta.url)), '..');
const saidaJs = join(raiz, 'demo', '.bundle.js');

async function main(){
await build({
  entryPoints: [join(raiz, 'demo', 'main.tsx')],
  bundle: true, minify: true, format: 'iife', target: ['es2020'],
  jsx: 'automatic', outfile: saidaJs, logLevel: 'warning',
  define: { 'process.env.NODE_ENV': '"production"' }
});

const js = readFileSync(saidaJs, 'utf8');
const html = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Mapeamento da Diversidade de Equipes — demonstração navegável</title>
<meta name="description" content="Jung × Os Animais e a Psique × Belbin. Demonstração funcional com algoritmo determinístico e dados simulados.">
</head>
<body>
<div id="root"></div>
<script>${js}</script>
</body>
</html>`;

mkdirSync(join(raiz, 'dist'), { recursive: true });
const destino = join(raiz, 'dist', 'demo.html');
writeFileSync(destino, html);
console.log(`demo gerada: dist/demo.html (${(html.length / 1024).toFixed(0)} KB)`);
}
main();
