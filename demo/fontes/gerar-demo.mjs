/**
 * DEMO NAVEGÁVEL DA v2.0 — percurso completo do participante
 * ===========================================================================
 * Um arquivo .html autossuficiente que executa o percurso inteiro: as 48
 * situações, a pergunta de desempate quando ela é disparada, e o relatório
 * individual do animal apurado.
 *
 * ⚠ CONFIDENCIAL. Para a apuração funcionar dentro do navegador, este arquivo
 * PRECISA carregar o mapa alternativa → configuração. Ou seja: ele contém o
 * gabarito. Não é a aplicação — na aplicação o mapa fica no servidor, com trava
 * `server-only`, e o teste `npm run test:sigilo` prova que ele não desce ao
 * cliente. Esta demo existe para VOCÊ ver o fluxo, e não deve ser aberta por
 * quem vai responder.
 *
 *   node gerar-demo.mjs
 */
import { readFileSync, writeFileSync } from 'node:fs';

const { questoes } = JSON.parse(readFileSync('q48-final.json', 'utf8'));
const { itens: desempates } = JSON.parse(readFileSync('desempate.json', 'utf8'));
const perfis = JSON.parse(readFileSync('perfis.json', 'utf8'));
const { ESTRUTURA, EFETIVO, pessoas: PESSOAS } = JSON.parse(readFileSync('populacao.json', 'utf8'));
const parte2 = readFileSync('demo-parte2.js', 'utf8');
const parte3 = readFileSync('demo-parte3.js', 'utf8');
const parte4 = readFileSync('demo-parte4.js', 'utf8');
const defsSvg = readFileSync('animais-defs.svg', 'utf8');

const L = ['A', 'B', 'C', 'D'];
const ANCORA = { Te: '39B', Ti: '14C', Fe: '36C', Fi: '20D', Se: '22B', Si: '34B', Ne: '40B', Ni: '43C' };
const ref = (n, k) => `R${String(n).padStart(3, '0')}${L[k]}`;

/* ── dados para o navegador ─────────────────────────────────────────────── */
const QUESTOES = questoes.map((q, i) => ({
  id: `R${String(i + 1).padStart(3, '0')}`,
  n: i + 1,
  e: q.enunciado,
  a: q.alternativas.map((x, k) => ({ id: ref(i + 1, k), t: x.texto }))
}));

const MAPA = {};
questoes.forEach((q, i) => q.alternativas.forEach((x, k) => { MAPA[ref(i + 1, k)] = x.p; }));

const ANCORAS = Object.fromEntries(Object.entries(ANCORA).map(([c, r]) => {
  const n = parseInt(r, 10), letra = r.slice(-1);
  return [c, `R${String(n).padStart(3, '0')}${letra}`];
}));

const DESEMPATES = desempates.map((d, i) => ({
  codigo: `D${String(i + 1).padStart(2, '0')}`,
  par: d.par, e: d.enunciado,
  a: d.alternativas.map(x => ({ p: x.p, t: x.texto }))
}));

const dados = JSON.stringify({ QUESTOES, MAPA, ANCORAS, DESEMPATES, PERFIS: perfis, ESTRUTURA, EFETIVO, PESSOAS });

const html = `<!doctype html>
<html lang="pt-BR"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ROTA26 — Demo da reavaliação v2.0</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,600;1,8..60,400&display=swap">
<style>
/* Paleta amostrada do logotipo ROTA26: amarelo do "26" (#DCA436), sua sombra
   em bronze (#A66A17), o grafite das letras (#2B2A28), o creme da parede. */
:root{
  --fundo:#F4EEE2; --papel:#FBF8F1; --papel2:#F0E8D9;
  --tinta:#211F1C; --tinta2:#544C40; --tinta3:#7E7365;
  --linha:#DFD4BF; --linha2:#CFC2A8;
  --bronze:#A66A17; --amarelo:#DCA436; --grafite:#2B2A28; --alerta:#8C3F33;
  --e1:6px; --e2:12px; --e3:20px; --e4:32px; --e5:52px;
  --serif:"Source Serif 4",Charter,Georgia,serif;
  --sans:"Archivo","Helvetica Neue",Arial,sans-serif;
}
*{box-sizing:border-box}
html,body{margin:0}
body{background:var(--fundo);color:var(--tinta);font-family:var(--serif);
  font-size:17px;line-height:1.6;-webkit-font-smoothing:antialiased}
h1,h2,h3,h4{font-family:var(--sans);margin:0;text-wrap:balance}
p{margin:0}
button{font:inherit;cursor:pointer}
:focus-visible{outline:2px solid var(--bronze);outline-offset:3px;border-radius:2px}
@media (prefers-reduced-motion: reduce){*{transition:none!important;animation:none!important}}

.wrap{max-width:820px;margin:0 auto;padding:0 var(--e3) var(--e5)}
.larga{max-width:1060px}

/* ── faixa de aviso: esta demo carrega o gabarito ─────────────────────── */
.aviso-conf{background:var(--grafite);color:#EFE6D6;font-family:var(--sans);
  font-size:12.5px;padding:9px var(--e3);text-align:center;letter-spacing:.02em}
.aviso-conf b{color:var(--amarelo)}

/* ── cabeçalho ────────────────────────────────────────────────────────── */
header.topo{padding:var(--e4) 0 var(--e3);border-bottom:1px solid var(--linha);
  margin-bottom:var(--e4)}
.marca{font-family:var(--sans);font-size:11.5px;font-weight:700;letter-spacing:.22em;
  text-transform:uppercase;color:var(--bronze);display:flex;gap:var(--e2);align-items:center}
.marca::after{content:"";flex:1;height:1px;background:var(--linha2)}
header.topo h1{font-size:clamp(24px,3.4vw,32px);font-weight:700;letter-spacing:-.02em;margin-top:10px}
header.topo .sub{font-family:var(--sans);font-size:14px;font-weight:500;color:var(--tinta3);margin-top:4px}

/* ── progresso: a rota ────────────────────────────────────────────────── */
.rota{height:6px;background:var(--papel2);border-radius:3px;overflow:hidden;margin:var(--e3) 0 var(--e1)}
.rota i{display:block;height:100%;background:var(--amarelo);transition:width .25s ease}
.rota-rot{font-family:var(--sans);font-size:12.5px;color:var(--tinta3);
  display:flex;justify-content:space-between;font-variant-numeric:tabular-nums}

/* ── questão ──────────────────────────────────────────────────────────── */
.q-num{font-family:var(--sans);font-size:12px;font-weight:700;letter-spacing:.16em;
  text-transform:uppercase;color:var(--bronze)}
.q-enun{font-size:clamp(20px,2.6vw,25px);line-height:1.36;font-weight:600;margin-top:10px}
.alts{display:flex;flex-direction:column;gap:var(--e2);margin-top:var(--e4)}
.alt{display:flex;gap:var(--e3);align-items:baseline;text-align:left;width:100%;
  background:var(--papel);border:1px solid var(--linha);border-left:3px solid transparent;
  border-radius:2px;padding:var(--e3);color:var(--tinta2);font-family:var(--serif);
  font-size:16.5px;line-height:1.5;transition:border-color .12s ease,background .12s ease}
.alt:hover{background:var(--papel2);border-color:var(--linha2);border-left-color:var(--amarelo)}
.alt .l{font-family:var(--sans);font-size:12.5px;font-weight:700;color:var(--tinta3);flex:0 0 14px}
.nav{display:flex;gap:var(--e2);margin-top:var(--e4);align-items:center}
.btn{font-family:var(--sans);font-size:14.5px;font-weight:600;padding:11px 20px;
  border-radius:2px;border:1px solid var(--linha2);background:var(--papel);color:var(--tinta2)}
.btn:hover{background:var(--papel2)}
.btn-marca{background:var(--grafite);color:#EFE6D6;border-color:var(--grafite)}
.btn-marca:hover{background:#3d3b38}
.btn:disabled{opacity:.4;cursor:not-allowed}
.nav .direita{margin-left:auto;font-family:var(--sans);font-size:13px;color:var(--tinta3)}

/* ── desempate ────────────────────────────────────────────────────────── */
.desempate{background:var(--papel);border:1px solid var(--linha);
  border-left:3px solid var(--bronze);border-radius:2px;padding:var(--e4)}
.desempate .rot{font-family:var(--sans);font-size:11.5px;font-weight:600;letter-spacing:.16em;
  text-transform:uppercase;color:var(--bronze)}

/* ── abertura do resultado ────────────────────────────────────────────── */
.abertura{background:var(--grafite);color:#EFE6D6;border-radius:3px;padding:var(--e5) var(--e4);
  display:flex;gap:var(--e5);align-items:center;flex-wrap:wrap;margin-bottom:var(--e4)}
.disco{width:150px;height:150px;border-radius:50%;background:var(--bronze);
  display:grid;place-items:center;flex:0 0 auto}
.disco svg{width:100px;height:100px}
.abertura .txt{flex:1 1 300px}
.abertura .rot{font-family:var(--sans);font-size:11.5px;font-weight:600;letter-spacing:.18em;
  text-transform:uppercase;color:var(--amarelo)}
.abertura h2{font-size:clamp(38px,6vw,58px);font-weight:700;letter-spacing:-.025em;line-height:1;margin-top:10px}
.abertura .jung{font-family:var(--sans);font-size:16px;font-weight:500;color:#BFB5A4;margin-top:6px}
.abertura .sint{font-size:19px;line-height:1.5;font-style:italic;margin-top:var(--e3);
  padding-left:var(--e3);border-left:2px solid var(--amarelo);max-width:46ch}

/* ── blocos do relatório ──────────────────────────────────────────────── */
.bloco{margin-top:var(--e5)}
.bloco>h3{font-family:var(--sans);font-size:12px;font-weight:600;letter-spacing:.16em;
  text-transform:uppercase;color:var(--tinta3);padding-bottom:var(--e2);border-bottom:1px solid var(--linha)}
.bloco h4{font-family:var(--sans);font-size:15px;font-weight:600;color:var(--cor)}
.bloco p{color:var(--tinta2)}
.triade,.duas,.prosa{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
  gap:var(--e4);margin-top:var(--e3)}
.lista{list-style:none;padding:0;margin:var(--e3) 0 0;display:flex;flex-direction:column;gap:var(--e2)}
.lista li{position:relative;padding-left:var(--e3);color:var(--tinta2)}
.lista li::before{content:"";position:absolute;left:0;top:.62em;width:9px;height:2px;background:var(--cor)}
.lista-vazada li::before{width:8px;height:8px;top:.5em;background:none;
  border:1.5px solid var(--linha2);border-radius:50%}
.pares{margin-top:var(--e3);display:flex;flex-direction:column;gap:1px;
  background:var(--linha);border:1px solid var(--linha);border-radius:2px;overflow:hidden}
.par{display:grid;grid-template-columns:minmax(140px,1fr) 1.6fr 1.6fr;gap:1px;background:var(--linha)}
.par>div{background:var(--papel);padding:var(--e3);font-size:15.5px;color:var(--tinta2)}
.par .forca{background:var(--papel2);font-family:var(--sans);font-weight:600;color:var(--tinta);
  border-left:3px solid var(--cor)}
.par .sombra{background:var(--papel2)}
.par-rot{font-family:var(--sans);font-size:10.5px;font-weight:600;letter-spacing:.13em;
  text-transform:uppercase;display:block;margin-bottom:5px}
.par .luz .par-rot{color:var(--bronze)} .par .sombra .par-rot{color:var(--tinta3)}
.dims{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:var(--e3) var(--e4);margin-top:var(--e3)}
.dim p{font-size:15.5px}
.complemento{margin-top:var(--e4);padding:var(--e3);background:var(--papel);
  border:1px solid var(--linha);border-radius:2px}

/* ── leitura complementar ─────────────────────────────────────────────── */
.compl{margin-top:var(--e4);padding:var(--e3) var(--e4);background:var(--papel);
  border:1px solid var(--linha);border-left:3px solid var(--cor2);border-radius:2px;
  display:flex;gap:var(--e3);align-items:center;flex-wrap:wrap}
.compl svg{width:54px;height:54px;flex:0 0 auto}
.compl .t{flex:1 1 260px}
.compl h4{font-family:var(--sans);font-size:15px;font-weight:600}
.compl p{font-size:15.5px;color:var(--tinta2);margin-top:3px}

/* ── painel de bastidores, só na demo ─────────────────────────────────── */
.bastidores{margin-top:var(--e5);border:1px dashed var(--bronze);border-radius:2px;
  background:#FDF9F0;padding:var(--e3) var(--e4)}
.bastidores>h3{font-family:var(--sans);font-size:11.5px;font-weight:700;letter-spacing:.16em;
  text-transform:uppercase;color:var(--bronze)}
.bastidores .nota{font-size:14px;color:var(--tinta3);margin-top:6px}
.barras{margin-top:var(--e3);display:flex;flex-direction:column;gap:5px}
.barra{display:grid;grid-template-columns:78px 1fr 74px;gap:var(--e2);align-items:center;
  font-family:var(--sans);font-size:13px}
.barra .nome{color:var(--tinta2);font-weight:600}
.barra .trilho{height:16px;background:var(--papel2);border-radius:2px;overflow:hidden}
.barra .trilho i{display:block;height:100%;background:var(--cor)}
.barra .val{color:var(--tinta3);font-variant-numeric:tabular-nums;text-align:right}
.barra.top .nome{color:var(--tinta)}
.kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(155px,1fr));gap:var(--e2);margin-top:var(--e3)}
.kpi{background:var(--papel);border:1px solid var(--linha);border-radius:2px;padding:var(--e2) var(--e3)}
.kpi .r{font-family:var(--sans);font-size:10.5px;font-weight:600;letter-spacing:.12em;
  text-transform:uppercase;color:var(--tinta3)}
.kpi .v{font-family:var(--sans);font-size:21px;font-weight:700;margin-top:2px;
  font-variant-numeric:tabular-nums}
.kpi .d{font-size:13px;color:var(--tinta3);margin-top:2px;line-height:1.35}

.limites{margin-top:var(--e5);padding-top:var(--e3);border-top:1px solid var(--linha);
  font-size:15px;color:var(--tinta3)}
.limites p+p{margin-top:var(--e2)}


/* ── barra de navegação ───────────────────────────────────────────────── */
.barra{display:flex;gap:var(--e3);align-items:center;padding:var(--e2) 0;
  border-bottom:1px solid var(--linha)}
.b-marca{font-family:var(--sans);font-size:11.5px;font-weight:700;letter-spacing:.22em;
  text-transform:uppercase;color:var(--bronze)}
.b-link{font-family:var(--sans);font-size:13.5px;font-weight:600;background:none;border:0;
  color:var(--tinta3);padding:5px 0;border-bottom:2px solid transparent}
.b-link:hover{color:var(--tinta)}
.b-link.on{color:var(--tinta);border-bottom-color:var(--amarelo)}

/* ── formulários ──────────────────────────────────────────────────────── */
.form{margin-top:var(--e4);display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
  gap:var(--e3)}
.campo{display:flex;flex-direction:column;gap:5px}
.campo label{font-family:var(--sans);font-size:12px;font-weight:600;letter-spacing:.1em;
  text-transform:uppercase;color:var(--tinta3)}
.campo input,.campo select{font-family:var(--serif);font-size:16px;padding:10px 12px;
  border:1px solid var(--linha2);border-radius:2px;background:var(--papel);color:var(--tinta)}
.campo input:disabled,.campo select:disabled{opacity:.5}
.form .auto{grid-column:1/-1;font-size:14px;color:var(--tinta3);
  padding:var(--e2) var(--e3);background:var(--papel2);border-radius:2px}
.aviso-sim{margin-top:var(--e3);padding:var(--e3);background:#FDF4E4;
  border:1px solid var(--linha);border-left:3px solid var(--alerta);border-radius:2px;
  font-size:15.5px;color:var(--tinta2);max-width:70ch}

/* ── filtros ──────────────────────────────────────────────────────────── */
.filtros{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:var(--e2);
  align-items:end;padding:var(--e3);background:var(--papel);border:1px solid var(--linha);
  border-radius:2px;margin-bottom:var(--e4)}
.filtros .btn{align-self:end}
.vazio{padding:var(--e5) var(--e4);background:var(--papel);border:1px dashed var(--linha2);
  border-radius:2px;color:var(--tinta2);text-align:center}

/* ── seções do dashboard ──────────────────────────────────────────────── */
.secao{margin-top:var(--e5)}
.secao>h3{font-family:var(--sans);font-size:12px;font-weight:600;letter-spacing:.16em;
  text-transform:uppercase;color:var(--tinta3);padding-bottom:var(--e2);
  border-bottom:1px solid var(--linha);margin-bottom:var(--e3)}
.nota{font-size:14px;color:var(--tinta3);margin-top:var(--e3);max-width:74ch}
.sub-rot{font-family:var(--sans);font-size:11.5px;font-weight:600;letter-spacing:.12em;
  text-transform:uppercase;color:var(--tinta3);margin-bottom:var(--e2)}
.duasc{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:var(--e5)}

.barras{display:flex;flex-direction:column;gap:6px}
.barra{display:grid;grid-template-columns:150px 1fr 92px;gap:var(--e2);align-items:center;
  font-family:var(--sans);font-size:13.5px}
.barras.compacto .barra{grid-template-columns:110px 1fr 62px}
.barra .nome{color:var(--tinta2);font-weight:600;display:flex;align-items:center;gap:7px}
.barra .nome svg.mini{width:20px;height:20px;flex:0 0 auto}
.barra .trilho{height:18px;background:var(--papel2);border-radius:2px;overflow:hidden}
.barra .trilho i{display:block;height:100%;background:var(--cor)}
.barra .val{color:var(--tinta3);font-variant-numeric:tabular-nums;text-align:right}

.familias{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:var(--e2)}
.fam{background:var(--papel);border:1px solid var(--linha);border-radius:2px;padding:var(--e3)}
.fam.baixa{border-left:3px solid var(--alerta)}
.f-nome{font-family:var(--sans);font-size:14px;font-weight:600}
.f-val{font-family:var(--sans);font-size:28px;font-weight:700;line-height:1.1;
  font-variant-numeric:tabular-nums}
.f-desc{font-size:13.5px;color:var(--tinta3);margin-top:2px}
.f-trilho{height:5px;background:var(--papel2);border-radius:3px;overflow:hidden;margin-top:10px}
.f-trilho i{display:block;height:100%;background:var(--bronze)}
.f-alerta{font-family:var(--sans);font-size:11.5px;font-weight:600;color:var(--alerta);margin-top:7px}

.ei{display:flex;height:34px;border-radius:2px;overflow:hidden;font-family:var(--sans);
  font-size:12.5px;font-weight:600}
.ei-b{background:var(--amarelo);color:var(--grafite);display:grid;place-items:center}
.ei-b.i{background:var(--grafite);color:#EFE6D6}

.eixo{margin-bottom:var(--e4)}
.e-rot{font-family:var(--sans);font-size:11.5px;font-weight:600;letter-spacing:.12em;
  text-transform:uppercase;color:var(--tinta3)}
.e-tri{display:flex;justify-content:space-between;font-size:12.5px;color:var(--tinta3);margin-top:6px}
.e-linha{position:relative;height:6px;background:linear-gradient(90deg,#2B2A28,#CFC2A8,#DCA436);
  border-radius:3px;margin-top:5px}
.e-linha i{position:absolute;top:-5px;width:3px;height:16px;background:var(--tinta);
  border-radius:2px;transform:translateX(-50%)}
.e-val{font-family:var(--sans);font-size:19px;font-weight:700;margin-top:9px;
  font-variant-numeric:tabular-nums}

.kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(175px,1fr));gap:var(--e2)}
.kpi{background:var(--papel);border:1px solid var(--linha);border-radius:2px;padding:var(--e2) var(--e3)}
.kpi .r{font-family:var(--sans);font-size:10.5px;font-weight:600;letter-spacing:.12em;
  text-transform:uppercase;color:var(--tinta3)}
.kpi .v{font-family:var(--sans);font-size:24px;font-weight:700;margin-top:2px;
  font-variant-numeric:tabular-nums;line-height:1.15}
.kpi .d{font-size:13px;color:var(--tinta3);margin-top:3px;line-height:1.35}

.secao.classe{border-left:3px solid var(--cor);padding-left:var(--e3)}
.c-nome{font-family:var(--sans);font-size:clamp(22px,3vw,29px);font-weight:700;color:var(--cor);
  letter-spacing:-.015em}
.c-crit{color:var(--tinta2);margin-top:6px}
.c-hip{margin-top:var(--e3);padding:var(--e2) var(--e3);background:var(--papel);
  border:1px solid var(--linha);border-radius:2px;font-size:15.5px;color:var(--tinta2);max-width:74ch}

.lider-topo{display:flex;gap:var(--e3);align-items:center;flex-wrap:wrap}
.l-disco{width:74px;height:74px;border-radius:50%;background:var(--cor);display:grid;
  place-items:center;flex:0 0 auto}
.l-disco svg{width:50px;height:50px}
.l-rot{font-family:var(--sans);font-size:11px;font-weight:600;letter-spacing:.14em;
  text-transform:uppercase;color:var(--tinta3)}
.l-nome{font-family:var(--sans);font-size:26px;font-weight:700;color:var(--cor);line-height:1.1}
.l-sub{font-size:15px;color:var(--tinta2)}
.lista-c{list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:9px}
.lista-c li{position:relative;padding-left:var(--e3);color:var(--tinta2);font-size:15.5px}
.lista-c li::before{content:"";position:absolute;left:0;top:.62em;width:9px;height:2px;
  background:var(--bronze)}
.lista-c.vazada li::before{width:8px;height:8px;top:.5em;background:none;
  border:1.5px solid var(--linha2);border-radius:50%}
.recomenda{margin-top:var(--e4);padding:var(--e3);background:var(--papel);
  border:1px solid var(--linha);border-radius:2px}
.recomenda h4{font-family:var(--sans);font-size:11.5px;font-weight:600;letter-spacing:.14em;
  text-transform:uppercase;color:var(--tinta3);margin-bottom:var(--e2)}

.gerencial{display:flex;flex-direction:column;gap:var(--e4)}
.gerencial article{max-width:78ch}
.gerencial h4{font-family:var(--sans);font-size:15px;font-weight:600;color:var(--tinta);
  margin-bottom:6px}
.gerencial p{color:var(--tinta2);font-size:16px}

.tabela-rolo{overflow-x:auto}
table.lista-p{border-collapse:collapse;width:100%;font-size:13.5px;min-width:820px}
table.lista-p th,table.lista-p td{border-bottom:1px solid var(--linha);padding:8px 10px;
  text-align:left;vertical-align:top}
table.lista-p th{font-family:var(--sans);font-size:10.5px;font-weight:600;letter-spacing:.1em;
  text-transform:uppercase;color:var(--tinta3)}
table.lista-p td{color:var(--tinta2)}
table.lista-p .mono{font-family:var(--sans);font-variant-numeric:tabular-nums;font-size:12.5px}
.tag{font-family:var(--sans);font-size:10px;font-weight:700;letter-spacing:.08em;
  text-transform:uppercase;background:var(--amarelo);color:var(--grafite);
  padding:1px 5px;border-radius:2px}

/* ── RELATÓRIO INTEGRAL ──────────────────────────────────────────────────── */
.ri-acoes{display:flex;gap:var(--e2);margin-bottom:var(--e3)}
.relint{background:var(--papel2);border:1px solid var(--linha);padding:var(--e5) var(--e5) var(--e4)}
.ri-cab{border-bottom:2px solid var(--grafite);padding-bottom:var(--e3);margin-bottom:var(--e4)}
.ri-marca{font-family:var(--sans);font-size:11px;font-weight:700;letter-spacing:.22em;
  text-transform:uppercase;color:var(--bronze)}
.ri-cab h2{font-size:31px;line-height:1.12;margin-top:6px;text-wrap:balance}
.ri-sub{font-family:var(--sans);font-size:12.5px;color:var(--tinta3);margin-top:8px}
.ri-sec{margin-top:var(--e5)}
.ri-sec > h3{font-family:var(--sans);font-size:12px;font-weight:700;letter-spacing:.14em;
  text-transform:uppercase;color:var(--tinta2);border-bottom:1px solid var(--linha);
  padding-bottom:7px;margin-bottom:var(--e3);display:flex;align-items:baseline;gap:11px}
.ri-num{font-family:var(--sans);font-size:11px;color:var(--bronze);letter-spacing:0}
.ri-sec h5{font-family:var(--sans);font-size:13.5px;font-weight:700;margin-bottom:5px}
.ri-sec p{color:var(--tinta2);font-size:15.5px;margin-top:var(--e2);max-width:76ch}
/* A regra .ri-sec p tem especificidade maior que .sub-rot e .nota e engoliria
   as duas. Estas linhas devolvem a cada uma o seu tamanho. */
.ri-sec p.sub-rot{font-size:11.5px;color:var(--tinta3);max-width:none}
.ri-sec p.nota{font-size:14px;color:var(--tinta3);max-width:74ch}
.ri-sec p.ri-marca,.ri-sec p.ri-sub{max-width:none}
.ri-sec .kpi p{max-width:none;margin-top:0}
.ri-sec .lider-topo p{max-width:none;margin-top:0}
.ri-sec p.l-rot{font-size:11px;color:var(--tinta3)}
.ri-sec p.l-nome{font-size:26px;color:var(--cor)}
.ri-sec p.l-sub{font-size:15px}
.ri-id{display:grid;grid-template-columns:repeat(auto-fit,minmax(215px,1fr));gap:var(--e2) var(--e4)}
.ri-id dt{font-family:var(--sans);font-size:10.5px;font-weight:700;letter-spacing:.11em;
  text-transform:uppercase;color:var(--tinta3)}
.ri-id dd{font-size:16px;margin-top:2px}
.ri-tab{width:100%;border-collapse:collapse;font-size:15px;margin-top:var(--e2)}
.ri-tab th{font-family:var(--sans);font-size:10.5px;font-weight:700;letter-spacing:.11em;
  text-transform:uppercase;color:var(--tinta3);text-align:left;padding:0 9px 7px 0;
  border-bottom:1px solid var(--linha)}
.ri-tab td{padding:8px 9px 8px 0;border-bottom:1px solid var(--linha2);vertical-align:middle}
.ri-tab .num{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}
.ri-tab tr.zero td{opacity:.5}
.ri-tab .destaque{color:var(--bronze);font-weight:700}
.ri-desc{color:var(--tinta2);font-size:14px}
.barra-c{width:46%}
.barra-c i{display:block;height:9px;background:var(--bronze);max-width:100%}
.ri-idx{width:180px;white-space:nowrap}
.ri-idx span{font-family:var(--sans);font-size:12.5px;margin-left:8px;
  font-variant-numeric:tabular-nums}
.ri-tr{position:relative;display:inline-block;width:110px;height:10px;
  background:var(--linha2);vertical-align:middle}
.ri-tr i{display:block;height:100%}
.ri-tr u{position:absolute;top:-3px;width:1px;height:16px;background:var(--tinta3)}
.ri-alerta{border-left:3px solid var(--amarelo);background:var(--papel);
  padding:var(--e2) var(--e3);font-size:14.5px;color:var(--tinta2);margin-top:var(--e3)}
.ri-riscos{display:grid;grid-template-columns:repeat(auto-fit,minmax(285px,1fr));gap:var(--e3)}
.ri-riscos article{border:1px solid var(--linha);padding:var(--e3);break-inside:avoid}
.ri-recs{display:grid;grid-template-columns:repeat(auto-fit,minmax(315px,1fr));gap:var(--e4)}
.ri-recs article{break-inside:avoid}
.ri-recs h5{border-bottom:1px solid var(--linha);padding-bottom:6px;margin-bottom:var(--e2)}
.ri-rod{margin-top:var(--e5);padding-top:var(--e2);border-top:1px solid var(--linha);
  font-family:var(--sans);font-size:11px;color:var(--tinta3);letter-spacing:.05em}

@media print{
  .nao-imprime,.barra,.aviso-conf{display:none !important}
  body{background:#fff}
  .relint{border:0;padding:0;background:#fff}
  /* A seção pode atravessar a página; o que não pode é um título ficar órfão
     no pé, nem uma tabela ou um cartão partirem ao meio. */
  .ri-sec > h3{break-after:avoid;page-break-after:avoid}
  .ri-tab,.kpis,.ri-riscos article,.ri-recs article,.lider-topo,.ri-alerta{
    break-inside:avoid;page-break-inside:avoid}
  .ri-tab tr{break-inside:avoid}
  p{orphans:3;widows:3}
  .wrap.larga{max-width:none;padding:0}
  a[href]::after{content:""}
}
@media (max-width:700px){
  .relint{padding:var(--e3)}
  .ri-idx{width:auto}
  .ri-tr{width:64px}
}

@media (max-width:700px){
  .barra{grid-template-columns:110px 1fr 74px}
  .lider-topo{gap:var(--e2)}
}

@media (max-width:700px){
  .par{grid-template-columns:1fr}
  .abertura{gap:var(--e3);padding:var(--e4) var(--e3)}
  .disco{width:110px;height:110px}.disco svg{width:74px;height:74px}
}
</style></head>
<body>

<div class="aviso-conf">
  Demo confidencial — este arquivo carrega o gabarito para poder apurar no navegador.
  <b>Na aplicação real o mapa fica no servidor.</b> Não abrir com quem vai responder.
</div>

<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>${defsSvg}</defs></svg>

<div id="app"></div>

<script>
const D = ${dados};

/* ═══════════════════════════════════════════════════════════════════════
   MOTOR — porta fiel de src/lib/v2/apuracao.ts.
   A equivalência entre os dois é verificada por comparação direta: o script
   verifica-demo.mjs roda milhares de conjuntos nos dois e exige resultado
   idêntico. Se divergirem, a demo estaria mostrando outra coisa.
   ═══════════════════════════════════════════════════════════════════════ */
const CONFIGS = ['Te','Ti','Fe','Fi','Se','Si','Ne','Ni'];
const INFO = {
  Te:{atitude:'E',funcao:'T',inferior:'F'}, Ti:{atitude:'I',funcao:'T',inferior:'F'},
  Fe:{atitude:'E',funcao:'F',inferior:'T'}, Fi:{atitude:'I',funcao:'F',inferior:'T'},
  Se:{atitude:'E',funcao:'S',inferior:'N'}, Si:{atitude:'I',funcao:'S',inferior:'N'},
  Ne:{atitude:'E',funcao:'N',inferior:'S'}, Ni:{atitude:'I',funcao:'N',inferior:'S'}
};
const FAIXAS = { DEFINIDA_ESCORE:27, DEFINIDA_MARGEM:8, MODERADA_ESCORE:24,
  MODERADA_MARGEM:2, HIBRIDO_MARGEM:2, BAIXA_AMPLITUDE:14,
  EQUILIBRIO_FUNCOES:6, EQUILIBRIO_ATITUDE:10, CONFLITO_MARGEM:3 };
const ANC = new Set(Object.values(D.ANCORAS));
const arred = n => Math.round(n*10)/10;
const zeros = ks => Object.fromEntries(ks.map(k=>[k,0]));

function ordenar(bruto){
  const fn = zeros(['T','F','S','N']), at = {E:0,I:0};
  for (const c of CONFIGS){ fn[INFO[c].funcao]+=bruto[c]; at[INFO[c].atitude]+=bruto[c]; }
  return [...CONFIGS].sort((x,y)=>
    bruto[y]-bruto[x]
    || fn[INFO[y].funcao]-fn[INFO[x].funcao]
    || at[INFO[y].atitude]-at[INFO[x].atitude]
    || CONFIGS.indexOf(x)-CONFIGS.indexOf(y));
}
function auxiliarDe(dom, bruto){
  const fd = INFO[dom].funcao;
  const oposto = (fd==='T'||fd==='F') ? ['S','N'] : ['T','F'];
  return CONFIGS.filter(c=>oposto.includes(INFO[c].funcao))
    .sort((x,y)=>bruto[y]-bruto[x] || CONFIGS.indexOf(x)-CONFIGS.indexOf(y))[0];
}
function apurar(respostas){
  const porQ = new Map();
  for (const r of respostas){
    if (!D.MAPA[r.alternativaId]) continue;
    if (!r.alternativaId.startsWith(r.questaoId)) continue;
    porQ.set(r.questaoId, r.alternativaId);
  }
  const esc = [...porQ.values()];
  const bruto = zeros(CONFIGS);
  for (const a of esc) bruto[D.MAPA[a]] += (ANC.has(a) ? 2 : 1);
  const total = Object.values(bruto).reduce((a,b)=>a+b,0);
  const rel = zeros(CONFIGS);
  if (total>0) for (const c of CONFIGS) rel[c] = arred(bruto[c]/total*100);

  const at = {E:0,I:0}, fn = zeros(['T','F','S','N']);
  for (const c of CONFIGS){ at[INFO[c].atitude]+=bruto[c]; fn[INFO[c].funcao]+=bruto[c]; }
  const pct = n => total>0 ? arred(n/total*100) : 0;
  const fnRel = zeros(['T','F','S','N']);
  for (const f of ['T','F','S','N']) fnRel[f] = pct(fn[f]);

  const ordem = ordenar(bruto);
  const p1 = ordem[0], p2 = ordem[1];
  const margem = arred(rel[p1]-rel[p2]);
  const amplitude = arred(rel[p1]-rel[ordem[7]]);
  const empateBruto = bruto[p1]===bruto[p2];
  const classificacao =
    margem<=FAIXAS.HIBRIDO_MARGEM ? 'configuracao_equilibrada'
    : (rel[p1]>=FAIXAS.DEFINIDA_ESCORE && margem>=FAIXAS.DEFINIDA_MARGEM) ? 'predominancia_definida'
    : (rel[p1]<FAIXAS.MODERADA_ESCORE && amplitude<FAIXAS.BAIXA_AMPLITUDE) ? 'baixa_aderencia'
    : 'predominancia_moderada';
  const vf = ['T','F','S','N'].map(f=>fnRel[f]);
  const a1 = INFO[p1], b1 = INFO[p2];
  const exigeDesempate = empateBruto || margem<=FAIXAS.HIBRIDO_MARGEM;

  return {
    respostasValidas: esc.length, completo: esc.length===48,
    bruto, relativo: rel, totalPontos: total, ordem,
    atitudes:{E:at.E,I:at.I,relativoE:pct(at.E),relativoI:pct(at.I),
      dominante: at.E>at.I?'E':at.I>at.E?'I':INFO[ordem[0]].atitude},
    funcoes: fn, funcoesRelativas: fnRel,
    eixoCognitivo: arred(fnRel.N-fnRel.S),
    eixoRelacional: arred(fnRel.F-fnRel.T),
    orientacaoEnergia: arred(pct(at.E)-pct(at.I)),
    predominante: p1, secundaria: auxiliarDe(p1,bruto), margem, amplitude, classificacao,
    equilibrioFuncional: Math.max(...vf)-Math.min(...vf) <= FAIXAS.EQUILIBRIO_FUNCOES,
    equilibrioAtitude: Math.abs(pct(at.E)-pct(at.I)) <= FAIXAS.EQUILIBRIO_ATITUDE,
    possivelConflito: a1.atitude!==b1.atitude && a1.funcao===b1.inferior && margem<=FAIXAS.CONFLITO_MARGEM,
    empateBruto, exigeDesempate,
    emDisputa: exigeDesempate ? [p1,p2] : null,
    desempateAplicado: false
  };
}
function aplicarDesempate(ap, escolhida){
  const outra = ap.emDisputa[0]===escolhida ? ap.emDisputa[1] : ap.emDisputa[0];
  return {...ap, predominante: escolhida, secundaria: auxiliarDe(escolhida, ap.bruto),
    ordem: [escolhida, outra, ...ap.ordem.filter(c=>c!==escolhida&&c!==outra)],
    exigeDesempate:false, desempateAplicado:true};
}
const temComplementar = ap =>
  ap.classificacao==='configuracao_equilibrada' || ap.margem <= FAIXAS.MODERADA_MARGEM*2;

const chavePar = (a,b)=>[a,b].sort().join('|');
const POR_PAR = Object.fromEntries(D.DESEMPATES.map(i=>[chavePar(i.par[0],i.par[1]),i]));
const PERFIL = Object.fromEntries(D.PERFIS.map(p=>[p.id,p]));
const ID_ANIMAL = {Lobo:'a-lobo',Elefante:'a-elefante',Carneiro:'a-carneiro',Baleia:'a-baleia',
  Cavalo:'a-cavalo',Urso:'a-urso',Raposa:'a-raposa','Onça':'a-onca'};

/* ═══════════════════════════════════════════════════════════════════════
   ESTADO E TELAS
   ═══════════════════════════════════════════════════════════════════════ */
let tela = 'identificacao', i = 0, respostas = [], ap = null, prep = null, registro = null;
const app = document.getElementById('app');
const esc = s => String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
const animalSvg = (nome, cls='') =>
  \`<svg viewBox="0 0 64 64" class="\${cls}" role="img" aria-label="\${esc(nome)}"><use href="#\${ID_ANIMAL[nome]}"/></svg>\`;

const topo = (t, s) => \`<header class="topo"><p class="marca">ROTA26</p>
  <h1>\${t}</h1><p class="sub">\${s}</p></header>\`;

function render(){
  if (tela==='identificacao') return telaIdentificacao();
  if (tela==='login')        return telaLogin();
  if (tela==='dashboard')    return telaDashboard();
  if (tela==='relatorio')    return telaRelatorio();
  if (tela==='questoes')     return telaQuestao();
  if (tela==='desempate')    return telaDesempate();
  if (tela==='resultado')    return telaResultado();
}

function telaAberturaAntiga(){
  app.className='wrap';
  app.innerHTML = topo('Reavaliação — 48 situações de trabalho','Demonstração do percurso do participante')
  + \`<p style="font-size:19px;color:var(--tinta2);max-width:58ch">São 48 situações do dia a dia de
      trabalho. Em cada uma, quatro alternativas descrevem maneiras diferentes de reagir.
      <b>Não há alternativa certa ou errada</b>: todas descrevem recursos úteis.</p>
    <p style="color:var(--tinta2);max-width:58ch;margin-top:var(--e3)">Escolha uma alternativa por
      situação — a que mais se aproxima do que você costuma fazer de fato, e não do que considera
      o ideal. Leva cerca de 12 minutos.</p>
    <div class="nav">
      <button class="btn btn-marca" id="ir">Iniciar</button>
      <button class="btn" id="auto">Preencher ao acaso (demo)</button>
      <span class="direita">o preenchimento automático ajuda a ver o desempate disparar</span>
    </div>\`;
  document.getElementById('ir').onclick = ()=>{ tela='questoes'; i=0; respostas=[]; render(); };
  document.getElementById('auto').onclick = ()=>{
    respostas = D.QUESTOES.map(q=>({questaoId:q.id, alternativaId:q.a[Math.floor(Math.random()*4)].id}));
    concluir();
  };
}

function telaQuestao(){
  const q = D.QUESTOES[i];
  const escolhida = respostas.find(r=>r.questaoId===q.id);
  const feitas = respostas.length;
  app.className='wrap';
  app.innerHTML = barra() + topo('Reavaliação','48 situações de trabalho')
  + \`<div class="rota"><i style="width:\${feitas/48*100}%"></i></div>
     <div class="rota-rot"><span>Situação \${q.n} de 48</span><span>\${feitas} respondidas</span></div>
     <p class="q-num" style="margin-top:var(--e4)">Situação \${q.n}</p>
     <p class="q-enun">\${esc(q.e)}</p>
     <div class="alts">\${q.a.map((a,k)=>
       \`<button class="alt" data-id="\${a.id}"
          style="\${escolhida&&escolhida.alternativaId===a.id?'border-left-color:var(--amarelo);background:var(--papel2)':''}">
          <span class="l">\${'ABCD'[k]}</span><span>\${esc(a.t)}</span></button>\`).join('')}</div>
     <div class="nav">
       <button class="btn" id="ant" \${i===0?'disabled':''}>Anterior</button>
       <button class="btn btn-marca" id="ver" \${feitas<48?'disabled':''}>Ver meu resultado</button>
       <span class="direita">\${feitas<48?\`faltam \${48-feitas}\`:'todas respondidas'}</span>
     </div>\`;
  app.querySelectorAll('.alt').forEach(b=>b.onclick=()=>{
    respostas = respostas.filter(r=>r.questaoId!==q.id);
    respostas.push({questaoId:q.id, alternativaId:b.dataset.id});
    if (i<47){ i++; render(); } else render();
  });
  ligarBarra();
  document.getElementById('ant').onclick = ()=>{ if(i>0){i--;render();} };
  document.getElementById('ver').onclick = concluir;
}

function concluir(){
  ap = apurar(respostas);
  if (ap.exigeDesempate){
    const item = POR_PAR[chavePar(ap.emDisputa[0], ap.emDisputa[1])];
    const inverter = Math.random()<0.5;
    const [x,y] = inverter ? [item.a[1],item.a[0]] : item.a;
    prep = { item, mostra:[x,y], mapa:{A:x.p,B:y.p} };
    tela='desempate';
  } else { registro=null; tela='resultado'; }
  render();
}

function telaDesempate(){
  app.className='wrap';
  app.innerHTML = barra() + topo('Mais uma situação','Antes de mostrar o seu resultado')
  + \`<div class="desempate">
      <p class="rot">Situação final</p>
      <p class="q-enun" style="margin-top:10px">\${esc(prep.item.e)}</p>
      <div class="alts">\${prep.mostra.map((a,k)=>
        \`<button class="alt" data-i="\${'AB'[k]}">
           <span class="l">\${'AB'[k]}</span><span>\${esc(a.t)}</span></button>\`).join('')}</div>
     </div>\`;
  ligarBarra();
  app.querySelectorAll('.alt').forEach(b=>b.onclick=()=>{
    const pos = b.dataset.i, escolhida = prep.mapa[pos];
    registro = {
      item: prep.item.codigo, configA: ap.emDisputa[0], configB: ap.emDisputa[1],
      pontosA: ap.bruto[ap.emDisputa[0]], pontosB: ap.bruto[ap.emDisputa[1]],
      margem: ap.margem, alternativa: pos, escolhida, posicaoA: prep.mapa.A
    };
    ap = aplicarDesempate(ap, escolhida);
    tela='resultado'; render();
  });
}

function telaResultado(){
  const p = PERFIL[ap.predominante];
  const p2 = PERFIL[ap.secundaria];
  const compl = temComplementar(ap);
  app.className='wrap larga';
  app.innerHTML = barra() + topo('Seu resultado','Reavaliação ROTA26')
  + \`<section class="abertura">
      <div class="disco">\${animalSvg(p.animal)}</div>
      <div class="txt">
        <p class="rot">Sua maior correspondência simbólica</p>
        <h2>\${esc(p.animal)}</h2>
        <p class="jung">\${esc(p.nomeJung)}</p>
        <p class="sint">\${esc(p.sintese)}</p>
      </div>
     </section>\`
  + (compl ? \`<div class="compl" style="--cor2:\${p2.cor}">
        \${animalSvg(p2.animal)}
        <div class="t"><h4>Leitura complementar: \${esc(p2.animal)}</h4>
        <p>\${esc(p2.nomeJung)} — \${esc(p2.sintese)} Esta segunda configuração aparece porque
        seus escores ficaram próximos; ela acompanha a leitura sem substituir a principal.</p></div>
      </div>\` : '')
  + bloco(p,'Como funciona', \`<div class="triade">
      <div><h4>Percebe</h4><p>\${esc(p.estrutura.percebe)}</p></div>
      <div><h4>Decide</h4><p>\${esc(p.estrutura.decide)}</p></div>
      <div><h4>Relaciona-se</h4><p>\${esc(p.estrutura.relaciona)}</p></div></div>\`)
  + bloco(p,'Potências no trabalho',
      \`<ul class="lista">\${p.potencias.map(x=>\`<li>\${esc(x)}</li>\`).join('')}</ul>\`)
  + bloco(p,'Luz e sombra', \`
      <p style="margin-top:var(--e3);font-size:15px;color:var(--tinta3);max-width:64ch">Cada sombra é a
      <b>mesma força</b> da coluna à esquerda, levada além do ponto em que ainda servia. Não é lista de
      defeitos: é o custo do próprio recurso quando deixa de ser dosado.</p>
      <div class="pares">\${p.luzSombra.map(x=>\`<div class="par">
        <div class="forca">\${esc(x.forca)}</div>
        <div class="luz"><span class="par-rot">Equilibrada</span>\${esc(x.equilibrada)}</div>
        <div class="sombra"><span class="par-rot">Em excesso</span>\${esc(x.excessiva)}</div>
      </div>\`).join('')}</div>
      <div class="prosa">
        <div><h4>Em equilíbrio</h4><p>\${esc(p.luz)}</p></div>
        <div><h4>Quando a função inferior assume</h4>
          <p style="font-family:var(--sans);font-size:13px;color:var(--tinta3);margin-bottom:6px">Função inferior: <b>\${esc(p.funcaoInferiorNome)}</b></p>
          <p>\${esc(p.sombra)}</p></div>
      </div>\`)
  + bloco(p,'Dentro de uma equipe', \`<div class="duas">
      <div><h4>O que acrescenta</h4><ul class="lista">\${p.contribuicoes.map(x=>\`<li>\${esc(x)}</li>\`).join('')}</ul></div>
      <div><h4>Recursos menos espontâneos</h4><ul class="lista lista-vazada">\${p.menosEspontaneos.map(x=>\`<li>\${esc(x)}</li>\`).join('')}</ul></div>
      </div>
      <div class="complemento"><h4 style="font-size:11.5px;letter-spacing:.14em;text-transform:uppercase;color:var(--tinta3);margin-bottom:8px">Com o que se complementa</h4>
      <p>\${esc(p.complementaridade)}</p></div>\`)
  + bloco(p,'Em nove situações de trabalho', \`<div class="dims">\${
      [['decisao','Decisão'],['comunicacao','Comunicação'],['execucao','Execução'],
       ['mudanca','Mudança'],['conflitos','Conflitos'],['relacionamento','Relacionamento'],
       ['pressao','Pressão'],['inovacao','Inovação'],['organizacao','Organização']]
      .map(([k,r])=>\`<div class="dim"><h4>\${r}</h4><p>\${esc(p.trabalho[k])}</p></div>\`).join('')}</div>\`)
  + \`<div class="limites">
      <p>Este resultado representa tendências de autorrelato em um momento específico, com escores
      internos e não percentis. Os animais são metáforas didáticas: descrevem um padrão predominante,
      não a pessoa inteira, e não constituem diagnóstico psicológico.</p>
      <p>Nenhuma configuração é melhor que outra, e este resultado não deve ser usado para seleção,
      promoção, transferência ou desligamento.</p>
     </div>\`
  + bastidores()
  + \`<div class="nav"><button class="btn" id="de-novo">Responder de novo</button></div>\`;
  ligarBarra();
  document.getElementById('de-novo').onclick = ()=>{ cadastro=null; tela='identificacao'; render(); window.scrollTo(0,0); };
  window.scrollTo(0,0);
}

const bloco = (p,t,c) => \`<section class="bloco" style="--cor:\${p.cor}"><h3>\${t}</h3>\${c}</section>\`;

const ROTULO_CLASS = {
  predominancia_definida:'Predominância definida',
  predominancia_moderada:'Predominância moderada',
  configuracao_equilibrada:'Configuração equilibrada',
  baixa_aderencia:'Baixa aderência'
};

function bastidores(){
  const max = Math.max(...CONFIGS.map(c=>ap.relativo[c]));
  return \`<section class="bastidores">
    <h3>Bastidores — não visível ao participante</h3>
    <p class="nota">O que o motor apurou. Na aplicação isto fica no servidor e no dashboard do
      administrador; aparece aqui só para você conferir a lógica.</p>
    <div class="barras">\${ap.ordem.map(c=>{
      const P = PERFIL[c];
      return \`<div class="barra \${c===ap.predominante?'top':''}" style="--cor:\${P.cor}">
        <span class="nome">\${c} · \${P.animal}</span>
        <span class="trilho"><i style="width:\${ap.relativo[c]/max*100}%"></i></span>
        <span class="val">\${ap.bruto[c]} pt · \${ap.relativo[c].toFixed(1)}%</span></div>\`;
    }).join('')}</div>
    <div class="kpis">
      <div class="kpi"><p class="r">Classificação</p><p class="v" style="font-size:15px">\${ROTULO_CLASS[ap.classificacao]}</p>
        <p class="d">margem \${ap.margem.toFixed(1)} pp · amplitude \${ap.amplitude.toFixed(1)} pp</p></div>
      <div class="kpi"><p class="r">Total de pontos</p><p class="v">\${ap.totalPontos}</p>
        <p class="d">48 base + âncoras de peso 2</p></div>
      <div class="kpi"><p class="r">Eixo cognitivo</p><p class="v">\${ap.eixoCognitivo>0?'+':''}\${ap.eixoCognitivo.toFixed(1)}</p>
        <p class="d">%Intuição − %Sensação</p></div>
      <div class="kpi"><p class="r">Eixo relacional</p><p class="v">\${ap.eixoRelacional>0?'+':''}\${ap.eixoRelacional.toFixed(1)}</p>
        <p class="d">%Sentimento − %Pensamento</p></div>
      <div class="kpi"><p class="r">Energia</p><p class="v">\${ap.orientacaoEnergia>0?'+':''}\${ap.orientacaoEnergia.toFixed(1)}</p>
        <p class="d">%Extroversão − %Introversão</p></div>
      <div class="kpi"><p class="r">Funções</p><p class="v" style="font-size:14px">T \${ap.funcoesRelativas.T.toFixed(0)} · F \${ap.funcoesRelativas.F.toFixed(0)} · S \${ap.funcoesRelativas.S.toFixed(0)} · N \${ap.funcoesRelativas.N.toFixed(0)}</p>
        <p class="d">\${ap.equilibrioFuncional?'equilíbrio funcional':'sem equilíbrio funcional'}</p></div>
    </div>
    \${registro ? \`<div class="kpi" style="margin-top:var(--e3);border-left:3px solid var(--bronze)">
      <p class="r">Desempate acionado — registro de auditoria</p>
      <p class="d" style="font-size:14px;margin-top:6px">
        item <b>\${registro.item}</b> · disputa <b>\${registro.configA}</b> (\${registro.pontosA} pt)
        vs <b>\${registro.configB}</b> (\${registro.pontosB} pt) · margem \${registro.margem.toFixed(1)} pp<br>
        alternativa escolhida: <b>\${registro.alternativa}</b> · resolveu para <b>\${registro.escolhida}</b>
        · na posição A estava <b>\${registro.posicaoA}</b><br>
        <span style="color:var(--alerta)">A classificação permanece \${ROTULO_CLASS[ap.classificacao].toLowerCase()}:
        o desempate define o totem, não converte equilíbrio em predominância.</span>
      </p></div>\` : \`<p class="nota" style="margin-top:var(--e3)">Não houve desempate — a margem entre
        as duas primeiras foi de \${ap.margem.toFixed(1)} pp, acima do corte de 2 pp.</p>\`}
  </section>\`;
}

${parte2}

${parte4}
${parte3}

render();
</script>
</body></html>`;

writeFileSync('ROTA26-demo-v2.html', html);
console.log(`  ROTA26-demo-v2.html — ${(html.length / 1024).toFixed(0)} KB`);
