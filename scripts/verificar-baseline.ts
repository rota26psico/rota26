/**
 * VERIFICAÇÃO DE REGRESSÃO — itens 8 e 104 do prompt-mestre
 * ===========================================================================
 * Reexecuta EXATAMENTE os cinco conjuntos controlados e a mesma população da
 * baseline, e compara campo a campo com baseline.json.
 *
 * Qualquer divergência é falha: nesta etapa nenhuma alteração metodológica foi
 * autorizada. Melhoria de apresentação, migração de banco e redesign não podem
 * mudar um único escore.
 */
import { readFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import { montarBaseline } from './baseline';

const ARQUIVO = join(process.cwd(), 'baseline.json');
if (!existsSync(ARQUIVO)) {
  console.error('baseline.json não encontrado. Rode `npx tsx scripts/baseline.ts` ANTES de alterar o projeto.');
  process.exit(1);
}

const antes = JSON.parse(readFileSync(ARQUIVO, 'utf8'));
const agora = montarBaseline();

const divergencias: string[] = [];

/** Comparação profunda que reporta o CAMINHO exato da diferença. */
function comparar(a: any, b: any, caminho: string) {
  if (a === b) return;
  if (typeof a !== typeof b) {
    divergencias.push(`${caminho}: tipo mudou de ${typeof a} para ${typeof b}`); return;
  }
  if (a === null || b === null) {
    divergencias.push(`${caminho}: ${JSON.stringify(a)} → ${JSON.stringify(b)}`); return;
  }
  if (Array.isArray(a) || Array.isArray(b)) {
    if (!Array.isArray(a) || !Array.isArray(b)) { divergencias.push(`${caminho}: estrutura mudou`); return; }
    if (a.length !== b.length) { divergencias.push(`${caminho}: ${a.length} → ${b.length} itens`); return; }
    a.forEach((x, i) => comparar(x, b[i], `${caminho}[${i}]`));
    return;
  }
  if (typeof a === 'object') {
    const chaves = new Set([...Object.keys(a), ...Object.keys(b)]);
    for (const k of chaves) {
      if (!(k in a)) { divergencias.push(`${caminho}.${k}: campo NOVO (${JSON.stringify(b[k])})`); continue; }
      if (!(k in b)) { divergencias.push(`${caminho}.${k}: campo REMOVIDO (era ${JSON.stringify(a[k])})`); continue; }
      comparar(a[k], b[k], `${caminho}.${k}`);
    }
    return;
  }
  divergencias.push(`${caminho}: ${JSON.stringify(a)} → ${JSON.stringify(b)}`);
}

console.log('══════════════════════════════════════════════════════════════════════════════');
console.log(' TESTE DE REGRESSÃO CONTRA A BASELINE');
console.log('══════════════════════════════════════════════════════════════════════════════');
console.log(`  baseline: instrumento ${antes.versaoInstrumento} · matriz ${antes.versaoMatriz}`);
console.log(`  atual:    instrumento ${agora.versaoInstrumento} · matriz ${agora.versaoMatriz}`);
console.log('');

comparar(antes.individuais, agora.individuais, 'individuais');
comparar(antes.coletivoGeral, agora.coletivoGeral, 'coletivoGeral');
comparar(antes.coletivoPorSetor, agora.coletivoPorSetor, 'coletivoPorSetor');
comparar(antes.totalQuestoes, agora.totalQuestoes, 'totalQuestoes');
comparar(antes.totalAlternativas, agora.totalAlternativas, 'totalAlternativas');
comparar(antes.populacao, agora.populacao, 'populacao');

for (const c of agora.individuais) {
  const r = c.retrato;
  console.log(`  ${c.id} · perfil ${r.perfilPredominante}/${r.perfilSecundario} · ` +
    `E${r.escoresJungRelativo.E} I${r.escoresJungRelativo.I} ` +
    `T${r.escoresJungRelativo.T} F${r.escoresJungRelativo.F} ` +
    `S${r.escoresJungRelativo.S} N${r.escoresJungRelativo.N} · ` +
    `Belbin ${r.top3Belbin.map((x: any) => x.id).join('>')}`);
}
console.log(`  população · IDF ${agora.coletivoGeral.idf} · ICF ${agora.coletivoGeral.icf} · ` +
  `complementaridade ${agora.coletivoGeral.complementaridade.pct}%`);
console.log('');

if (divergencias.length === 0) {
  console.log('══════════════════════════════════════════════════════════════════════════════');
  console.log(' RESULTADO: nenhuma divergência. O instrumento é BIT A BIT o mesmo.');
  console.log(' Perfil, secundário, animal, E/I/T/F/S/N, seis eixos, capacidades, Belbin,');
  console.log(' IDF, ICF, complementaridade e distribuições permanecem idênticos.');
  console.log('══════════════════════════════════════════════════════════════════════════════');
  process.exit(0);
}

console.log('══════════════════════════════════════════════════════════════════════════════');
console.log(` FALHA: ${divergencias.length} divergência(s) não autorizada(s).`);
console.log('══════════════════════════════════════════════════════════════════════════════');
divergencias.slice(0, 60).forEach(d => console.log('  ✗ ' + d));
if (divergencias.length > 60) console.log(`  … e mais ${divergencias.length - 60}.`);
process.exit(1);
