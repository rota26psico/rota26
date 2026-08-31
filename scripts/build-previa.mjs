/**
 * GERADOR DA PRÉ-VISUALIZAÇÃO — dist/demo.html
 * ===========================================================================
 * Empacota `demo/main.tsx` em UM único arquivo .html autossuficiente: React,
 * ExcelJS, o algoritmo, as telas, os estilos e a marca embutida em data URI.
 * Não depende de servidor, de rede nem de node_modules para abrir — serve para
 * enviar a alguém que só quer ver o instrumento funcionando.
 *
 * Não é a aplicação. A aplicação é o Next.js com Supabase; isto é a mesma
 * árvore de componentes rodando sobre um repositório em memória.
 *
 *   node scripts/build-previa.mjs
 */
import { build } from 'esbuild';
import { writeFileSync, mkdirSync, readFileSync } from 'node:fs';

const SAIDA = 'dist/demo.html';

/* O título sai de src/lib/env.ts, a fonte única da marca. Lido por regex em vez
   de importado, para que este script rode com `node` puro, sem transpilador. */
const TITULO =
  /tituloCurto:\s*'([^']+)'/.exec(readFileSync('src/lib/env.ts', 'utf8'))?.[1]
  ?? 'ROTA26';

/* A demo calcula no próprio navegador — é a natureza dela — e por isso importa
   a chave de pontuação, que na aplicação é `server-only`. Aqui esse guarda é
   neutralizado de propósito: `dist/` é artefato de desenvolvimento, está no
   `.vercelignore` e no `.gitignore`, e nunca é publicado. Se um dia a demo
   precisar ir a público, este atalho precisa cair junto. */
const neutralizarServerOnly = {
  name: 'server-only-vazio',
  setup(b) {
    b.onResolve({ filter: /^server-only$/ }, () => ({ path: 'server-only', namespace: 'vazio' }));
    b.onLoad({ filter: /.*/, namespace: 'vazio' }, () => ({ contents: 'export {};', loader: 'js' }));
  }
};

const resultado = await build({
  plugins: [neutralizarServerOnly],
  entryPoints: ['demo/main.tsx'],
  bundle: true,
  write: false,
  format: 'iife',
  platform: 'browser',
  target: ['chrome110', 'firefox110', 'safari16'],
  jsx: 'automatic',
  minify: true,
  loader: { '.png': 'dataurl', '.webp': 'dataurl', '.svg': 'dataurl' },
  define: { 'process.env.NODE_ENV': '"production"' },
  logLevel: 'info'
});

const js = resultado.outputFiles[0].text;

mkdirSync('dist', { recursive: true });
writeFileSync(SAIDA, `<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${TITULO}</title>
</head>
<body>
<div id="root"></div>
<script>${js}</script>
</body>
</html>
`);

console.log(`\n  ${SAIDA} — ${(Buffer.byteLength(js) / 1024 / 1024).toFixed(2)} MB de bundle\n`);
