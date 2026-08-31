/* ═══════════════════════════════════════════════════════════════════════════
   PARTE 3 — TELAS: identificação, entrada administrativa e dashboard
   ═══════════════════════════════════════════════════════════════════════════ */

let cadastro = null, admin = false, filtros = { contrato:'', setor:'', lider:'', de:'', ate:'', pessoa:'' };

const CONTRATOS = D.ESTRUTURA.map(e=>e.contrato);
const setoresDe = ct => (D.ESTRUTURA.find(e=>e.contrato===ct)?.setores) ?? [];
const lideresDe = (ct,st) => D.PESSOAS.filter(p=>p.ehLider && p.contrato===ct && (!st||p.setor===st));
const fmtData = iso => new Date(iso).toLocaleString('pt-BR',{dateStyle:'short',timeStyle:'short'});

/* ── barra de topo com as duas entradas ──────────────────────────────────── */
function barra(){
  return `<nav class="barra">
    <span class="b-marca">ROTA26</span>
    <button class="b-link ${!admin?'on':''}" id="b-part">Participante</button>
    <button class="b-link ${admin?'on':''}" id="b-adm">Área do administrador</button>
  </nav>`;
}
function ligarBarra(){
  const bp = document.getElementById('b-part'), ba = document.getElementById('b-adm');
  if (bp) bp.onclick = ()=>{ admin=false; tela = cadastro? 'questoes':'identificacao'; render(); };
  if (ba) ba.onclick = ()=>{ tela = admin? 'dashboard':'login'; render(); };
}

/* ── 1 · identificação do participante ───────────────────────────────────── */
function telaIdentificacao(){
  app.className='wrap';
  const ct = cadastro?.contrato ?? '', st = cadastro?.setor ?? '';
  app.innerHTML = barra() + topo('Reavaliação — 48 situações de trabalho','Identificação')
  + `<p style="color:var(--tinta2);max-width:58ch">Antes de começar, precisamos saber de onde você
      responde. Esses dados vinculam o seu resultado a você e compõem as análises por equipe —
      <b>você verá apenas o seu próprio resultado</b>.</p>
    <div class="form">
      <div class="campo"><label for="f-ct">Contrato</label>
        <select id="f-ct"><option value="">Selecione…</option>
          ${CONTRATOS.map(c=>`<option ${c===ct?'selected':''}>${c}</option>`).join('')}</select></div>
      <div class="campo"><label for="f-st">Setor / equipe</label>
        <select id="f-st" ${ct?'':'disabled'}><option value="">${ct?'Selecione…':'escolha o contrato primeiro'}</option>
          ${setoresDe(ct).map(s=>`<option ${s===st?'selected':''}>${s}</option>`).join('')}</select></div>
      <div class="campo"><label for="f-li">Líder imediato</label>
        <select id="f-li" ${st?'':'disabled'}><option value="">${st?'Selecione…':'escolha o setor primeiro'}</option>
          ${lideresDe(ct,st).map(l=>`<option value="${l.matricula}">${l.nome}</option>`).join('')}</select></div>
      <div class="campo"><label for="f-nm">Nome completo</label>
        <input id="f-nm" autocomplete="name" placeholder="Nome e sobrenome"></div>
      <div class="campo"><label for="f-mt">Matrícula ou identificador interno</label>
        <input id="f-mt" placeholder="Ex.: M12345"></div>
      <p class="auto">Período de resposta: <b id="agora">${fmtData(new Date().toISOString())}</b>
        — registrado automaticamente pelo sistema, não preenchido por você.</p>
    </div>
    <div class="nav"><button class="btn btn-marca" id="ir" disabled>Iniciar</button>
      <span class="direita" id="pend">preencha contrato, setor, líder e nome</span></div>`;
  ligarBarra();
  const g = id => document.getElementById(id);
  const validar = ()=>{
    const ok = g('f-ct').value && g('f-st').value && g('f-li').value && g('f-nm').value.trim().length>=3;
    g('ir').disabled = !ok;
    g('pend').textContent = ok ? 'tudo certo' : 'preencha contrato, setor, líder e nome';
  };
  g('f-ct').onchange = ()=>{ cadastro={contrato:g('f-ct').value}; tela='identificacao'; render(); };
  g('f-st').onchange = ()=>{ cadastro={contrato:g('f-ct').value, setor:g('f-st').value}; tela='identificacao'; render(); };
  ['f-li','f-nm','f-mt'].forEach(id=>{ g(id).oninput = validar; g(id).onchange = validar; });
  validar();
  g('ir').onclick = ()=>{
    cadastro = { contrato:g('f-ct').value, setor:g('f-st').value, lider:g('f-li').value,
      nome:g('f-nm').value.trim(), matricula:g('f-mt').value.trim(),
      em: new Date().toISOString() };
    tela='questoes'; i=0; respostas=[]; render();
  };
}

/* ── 2 · entrada administrativa (SIMULADA) ───────────────────────────────── */
function telaLogin(){
  app.className='wrap';
  app.innerHTML = barra() + topo('Área do administrador','Acesso restrito')
  + `<div class="aviso-sim">
      <b>Nesta demo o acesso é simulado.</b> Um arquivo HTML aberto no navegador não tem como
      esconder nada: qualquer pessoa vê o código-fonte. A autenticação de verdade está na
      aplicação Next.js — sessão de administrador, Row Level Security por papel no banco e o
      gabarito preso ao servidor. Aqui a tela existe para você ver a <b>estrutura</b> do painel.
     </div>
    <div class="form" style="max-width:420px">
      <div class="campo"><label for="l-us">Administrador</label>
        <input id="l-us" value="master@rota26" autocomplete="username"></div>
      <div class="campo"><label for="l-pw">Senha</label>
        <input id="l-pw" type="password" value="demo" autocomplete="current-password"></div>
    </div>
    <div class="nav"><button class="btn btn-marca" id="entrar">Entrar</button></div>`;
  ligarBarra();
  document.getElementById('entrar').onclick = ()=>{ admin=true; tela='dashboard'; render(); };
}

/* ── 3 · dashboard ───────────────────────────────────────────────────────── */
function filtrar(){
  return D.PESSOAS.filter(p=>{
    if (filtros.contrato && p.contrato!==filtros.contrato) return false;
    if (filtros.setor && p.setor!==filtros.setor) return false;
    if (filtros.lider && p.lider!==filtros.lider && p.matricula!==filtros.lider) return false;
    if (filtros.pessoa && p.matricula!==filtros.pessoa) return false;
    if (filtros.de && p.em < filtros.de) return false;
    if (filtros.ate && p.em > filtros.ate + 'T23:59:59Z') return false;
    return true;
  });
}

function telaDashboard(){
  const pessoas = filtrar();
  const ag = agregar(pessoas);
  /* A comparação líder × equipe só faz sentido quando o recorte tem UMA liderança.
     Com vários líderes no recorte, escolher "o primeiro" apresentaria como retrato da
     equipe inteira o resultado de uma pessoa arbitrária. Aqui isso não é feito. */
  const lideresNoRecorte = pessoas.filter(p=>p.ehLider);
  const lider = lideresNoRecorte.length === 1 ? lideresNoRecorte[0] : null;
  app.className='wrap larga';

  const lideresF = D.PESSOAS.filter(p=>p.ehLider
    && (!filtros.contrato || p.contrato===filtros.contrato)
    && (!filtros.setor || p.setor===filtros.setor));

  app.innerHTML = barra() + topo('Dashboard da equipe','Leitura de diversidade e complementaridade')
  + `<section class="filtros">
      <div class="campo"><label for="x-ct">Contrato</label>
        <select id="x-ct"><option value="">Todos</option>
          ${CONTRATOS.map(c=>`<option ${c===filtros.contrato?'selected':''}>${c}</option>`).join('')}</select></div>
      <div class="campo"><label for="x-st">Setor / equipe</label>
        <select id="x-st"><option value="">Todos</option>
          ${setoresDe(filtros.contrato).map(s=>`<option ${s===filtros.setor?'selected':''}>${s}</option>`).join('')}</select></div>
      <div class="campo"><label for="x-li">Líder imediato</label>
        <select id="x-li"><option value="">Todos</option>
          ${lideresF.map(l=>`<option value="${l.matricula}" ${l.matricula===filtros.lider?'selected':''}>${l.nome}</option>`).join('')}</select></div>
      <div class="campo"><label for="x-de">Respondido de</label><input type="date" id="x-de" value="${filtros.de.slice(0,10)}"></div>
      <div class="campo"><label for="x-ate">até</label><input type="date" id="x-ate" value="${filtros.ate.slice(0,10)}"></div>
      <div class="campo"><label for="x-ps">Participante</label>
        <select id="x-ps"><option value="">Todos</option>
          ${pessoas.slice(0,400).map(p=>`<option value="${p.matricula}" ${p.matricula===filtros.pessoa?'selected':''}>${p.nome} · ${p.matricula}</option>`).join('')}</select></div>
      <button class="btn" id="x-limpar">Limpar filtros</button>
      <button class="btn btn-marca" id="x-rel">Relatório integral</button>
     </section>`
  + (!ag ? `<div class="vazio">Nenhum respondente com esses filtros.</div>`
     : ag.n < 5 ? `<div class="vazio"><b>${ag.n} respondente(s).</b> Abaixo de cinco, os indicadores
        coletivos não são exibidos — com amostra tão pequena, um único resultado moveria a leitura
        inteira, e a pessoa deixaria de ser anônima dentro do grupo.</div>`
     : painel(ag, pessoas, lider));

  ligarBarra();
  const g = id=>document.getElementById(id);
  g('x-ct').onchange = ()=>{ filtros.contrato=g('x-ct').value; filtros.setor=''; filtros.lider=''; filtros.pessoa=''; render(); };
  g('x-st').onchange = ()=>{ filtros.setor=g('x-st').value; filtros.lider=''; filtros.pessoa=''; render(); };
  g('x-li').onchange = ()=>{ filtros.lider=g('x-li').value; filtros.pessoa=''; render(); };
  g('x-de').onchange = ()=>{ filtros.de=g('x-de').value; render(); };
  g('x-ate').onchange = ()=>{ filtros.ate=g('x-ate').value; render(); };
  g('x-ps').onchange = ()=>{ filtros.pessoa=g('x-ps').value; render(); };
  g('x-limpar').onclick = ()=>{ filtros={contrato:'',setor:'',lider:'',de:'',ate:'',pessoa:''}; render(); };
  g('x-rel').onclick = ()=>{ tela='relatorio'; render(); };
  window.scrollTo(0,0);
}

const CLASSE_COR = {
  'Diversa e estratégica':'#47632B',
  'Diversa com necessidade de alinhamento':'#A66A17',
  'Predominantemente homogênea':'#1C4A62',
  'Fragmentada':'#8C3F33'
};

function painel(ag, pessoas, lider){
  const lideresNoRecorte = pessoas.filter(p=>p.ehLider);
  const pct = v => (v/ag.n*100);
  const ordAnimais = CONFIGS.slice().sort((a,b)=>ag.porCfg[b]-ag.porCfg[a]);
  const maxA = Math.max(...CONFIGS.map(c=>ag.porCfg[c]));

  const kpi = (r,v,d) => `<div class="kpi"><p class="r">${r}</p><p class="v">${v}</p><p class="d">${d}</p></div>`;

  const eixo = (rot, val, esq, dir) => `
    <div class="eixo">
      <p class="e-rot">${rot}</p>
      <div class="e-tri"><span class="e-esq">${esq}</span><span class="e-dir">${dir}</span></div>
      <div class="e-linha"><i style="left:calc(50% + ${Math.max(-49,Math.min(49,val/2))}%)"></i></div>
      <p class="e-val">${val>0?'+':''}${val.toFixed(1)}</p>
    </div>`;

  return `
  <section class="secao"><h3>Visão geral</h3>
    <div class="kpis">
      ${kpi('Respondentes', ag.n, 'no recorte filtrado')}
      ${kpi('Configurações presentes', `${CONFIGS.filter(c=>ag.porCfg[c]>0).length}/8`, 'quantos dos oito animais aparecem')}
      ${kpi('Com leitura complementar', `${pct(ag.complementares).toFixed(0)}%`, 'segunda configuração próxima o bastante para ser lida junto')}
      ${kpi('Precisaram de desempate', ag.desempates, `${pct(ag.desempates).toFixed(0)}% — as duas primeiras ficaram a ≤ 2 pp`)}
      ${kpi('Configuração equilibrada', ag.equilibradas, 'sem predominância destacada do acaso')}
      ${kpi('Baixa aderência', ag.baixaAderencia, 'resultado achatado — não ler como perfil')}
    </div>
  </section>

  <section class="secao"><h3>Distribuição dos oito animais</h3>
    <div class="barras">${ordAnimais.map(c=>{
      const P = PERFIL[c], v = ag.porCfg[c];
      return `<div class="barra" style="--cor:${P.cor}">
        <span class="nome">${animalSvg(P.animal,'mini')} ${P.animal}</span>
        <span class="trilho"><i style="width:${maxA? v/maxA*100:0}%"></i></span>
        <span class="val">${v} · ${pct(v).toFixed(0)}%</span></div>`;
    }).join('')}</div>
    <p class="nota">As configurações em zero permanecem visíveis: a ausência é informação de gestão.</p>
  </section>

  <section class="secao"><h3>Famílias de contribuição</h3>
    <div class="familias">${Object.entries(ag.famPct).sort((a,b)=>b[1]-a[1]).map(([f,v])=>`
      <div class="fam ${v<15?'baixa':''}">
        <p class="f-nome">${f}</p>
        <p class="f-val">${v.toFixed(0)}%</p>
        <p class="f-desc">${FAM_DESC[f]}</p>
        <div class="f-trilho"><i style="width:${v}%"></i></div>
        ${v<15?'<p class="f-alerta">abaixo de 15% — lacuna</p>':''}
      </div>`).join('')}</div>
    <p class="nota">As quatro famílias saem direto das funções de Jung: Pensamento → Análise,
      Sentimento → Relacionamento, Sensação → Execução, Intuição → Inovação. Sem sobreposição
      e sem categoria inventada.</p>
  </section>

  <section class="secao"><h3>Funções, atitude e eixos</h3>
    <div class="duasc">
      <div>
        <p class="sub-rot">Funções de Jung — média da equipe</p>
        <div class="barras compacto">${[['T','Pensamento','#2B2A28'],['F','Sentimento','#A66A17'],
          ['S','Sensação','#8A7C61'],['N','Intuição','#DCA436']].map(([k,n,cor])=>`
          <div class="barra" style="--cor:${cor}"><span class="nome">${n}</span>
            <span class="trilho"><i style="width:${ag.fn[k]/50*100}%"></i></span>
            <span class="val">${ag.fn[k].toFixed(1)}%</span></div>`).join('')}</div>
        <p class="sub-rot" style="margin-top:var(--e4)">Extroversão e introversão</p>
        <div class="ei"><div class="ei-b" style="width:${ag.atE}%">E ${ag.atE.toFixed(0)}%</div>
          <div class="ei-b i" style="width:${ag.atI}%">I ${ag.atI.toFixed(0)}%</div></div>
      </div>
      <div>
        ${eixo('Eixo cognitivo', ag.eixoC, 'concreto · o que está presente', 'possibilidade · o que ainda não é')}
        ${eixo('Eixo relacional', ag.eixoR, 'critério impessoal · tarefa', 'valor humano · pessoas')}
        <p class="nota">Cada eixo vai de −100 a +100 e é a diferença entre dois polos opostos.
          Balanceados por construção: o instrumento oferta 48 alternativas por função.</p>
      </div>
    </div>
  </section>

  <section class="secao classe" style="--cor:${CLASSE_COR[ag.classe]}">
    <h3>Configuração da equipe</h3>
    <p class="c-nome">${ag.classe}</p>
    <p class="c-crit">Critério aplicado: ${ag.criterio}.</p>
    <p class="c-hip"><b>Isto é hipótese de gestão, não julgamento.</b> A classificação descreve
      composição — não diz que a equipe é boa ou ruim, nem que alguém está no lugar errado.
      Serve para orientar onde buscar contraponto e como distribuir responsabilidade.</p>
    <p class="nota">Dispersão observada ${ag.disp.toFixed(0)} · esperada ao acaso para ${ag.n} pessoas
      ${dispEsperada(ag.n).toFixed(0)} · <b>relativa ${ag.dRel.toFixed(0)}%</b>. A relativização evita
      classificar equipe pequena como homogênea só por ser pequena.</p>
  </section>

  ${lider ? blocoLider(ag, pessoas, lider) : `<section class="secao"><h3>Comparação líder × equipe</h3>
    <p class="nota">${lideresNoRecorte.length > 1
      ? `Este recorte reúne <b>${lideresNoRecorte.length} lideranças</b> e, portanto, várias equipes.
         A comparação é feita entre uma liderança e a sua própria equipe: filtre por setor/equipe
         — ou por líder — para vê-la. Nenhuma média entre líderes é apresentada no lugar dela.`
      : `A liderança deste recorte ainda não respondeu ao instrumento, ou o filtro atual não a inclui.
         Sem o resultado dela, a comparação não é feita — e não é estimada.`}</p></section>`}

  <section class="secao"><h3>Leitura gerencial</h3>
    <div class="gerencial">${relatorioGerencial(ag, pessoas, lider).map(([t,c])=>`
      <article><h4>${t}</h4><p>${c}</p></article>`).join('')}</div>
    <p class="nota">Texto gerado a partir dos números deste recorte. Nenhum nome técnico de Belbin
      aparece — as contribuições são descritas pelo que a pessoa faz.</p>
  </section>

  <section class="secao"><h3>Respondentes do recorte</h3>
    <div class="tabela-rolo"><table class="lista-p">
      <tr><th>Nome</th><th>Matrícula</th><th>Contrato</th><th>Setor</th><th>Animal</th>
        <th>Complementar</th><th>Desempate</th><th>Período de resposta</th></tr>
      ${pessoas.slice(0,60).map(p=>`<tr>
        <td>${p.nome}${p.ehLider?' <span class="tag">líder</span>':''}</td>
        <td class="mono">${p.matricula}</td><td>${p.contrato}</td><td>${p.setor}</td>
        <td style="color:${PERFIL[p.cfg].cor};font-weight:600">${p.animal}</td>
        <td>${p.complementar?PERFIL[p.sec].animal:'—'}</td>
        <td>${p.desempate?`sim · margem ${p.desempate.margem.toFixed(1)} pp`:'não'}</td>
        <td class="mono">${fmtData(p.em)}</td></tr>`).join('')}
    </table></div>
    ${pessoas.length>60?`<p class="nota">Mostrando 60 de ${pessoas.length}. Refine os filtros para ver o restante.</p>`:''}
  </section>`;
}

function blocoLider(ag, pessoas, lider){
  const equipe = pessoas.filter(p=>!p.ehLider);
  const iguais = equipe.filter(p=>p.cfg===lider.cfg);
  const mesmaFam = equipe.filter(p=>familiaDe(p.cfg)===familiaDe(lider.cfg));
  const pctI = equipe.length? iguais.length/equipe.length*100 : 0;
  const complementares = CONFIGS.filter(c=>ag.porCfg[c]>0 && familiaDe(c)!==familiaDe(lider.cfg));
  const ausentes = CONFIGS.filter(c=>ag.porCfg[c]===0);
  const faixa = pctI>=40 ? ['Alta','#8C3F33'] : pctI>=20 ? ['Moderada','#A66A17'] : ['Baixa','#47632B'];

  return `<section class="secao"><h3>Comparação líder × equipe</h3>
    <div class="lider-topo" style="--cor:${PERFIL[lider.cfg].cor}">
      <div class="l-disco">${animalSvg(PERFIL[lider.cfg].animal)}</div>
      <div>
        <p class="l-rot">Configuração predominante de quem lidera</p>
        <p class="l-nome">${PERFIL[lider.cfg].animal}</p>
        <p class="l-sub">${lider.nome} · ${PERFIL[lider.cfg].nomeJung} — ${CONTRIB[lider.cfg]}</p>
      </div>
    </div>
    <div class="kpis" style="margin-top:var(--e3)">
      <div class="kpi"><p class="r">Mesma configuração</p><p class="v">${iguais.length}/${equipe.length}</p>
        <p class="d">${pctI.toFixed(0)}% da equipe compartilha o animal do líder</p></div>
      <div class="kpi"><p class="r">Mesma família</p><p class="v">${mesmaFam.length}/${equipe.length}</p>
        <p class="d">compartilham ${familiaDe(lider.cfg)}</p></div>
      <div class="kpi" style="border-left:3px solid ${faixa[1]}"><p class="r">Tendência de homofilia</p>
        <p class="v" style="font-size:17px">${faixa[0]}</p>
        <p class="d">≥40% alta · 20–40% moderada · &lt;20% baixa</p></div>
    </div>
    <div class="duasc" style="margin-top:var(--e4)">
      <div><p class="sub-rot">Contribuições complementares presentes</p>
        <ul class="lista-c">${complementares.length? complementares.map(c=>
          `<li><b>${PERFIL[c].animal}</b> (${ag.porCfg[c]}) — ${CONTRIB[c]}</li>`).join('')
          : '<li>Nenhuma: toda a equipe está na mesma família do líder.</li>'}</ul></div>
      <div><p class="sub-rot">Contribuições ausentes ou pouco representadas</p>
        <ul class="lista-c vazada">${ausentes.length? ausentes.map(c=>
          `<li><b>${PERFIL[c].animal}</b> — ${CONTRIB[c]}</li>`).join('')
          : `<li>Todas as oito têm ao menos um representante. A menos presente é
             <b>${PERFIL[CONFIGS.slice().sort((a,b)=>ag.porCfg[a]-ag.porCfg[b])[0]].animal}</b>.</li>`}</ul></div>
    </div>
    <div class="recomenda">
      <h4>Recomendações práticas</h4>
      <ul class="lista-c">
        <li>Ao distribuir responsabilidade, buscar deliberadamente quem ${
          complementares.length? CONTRIB[complementares[0]] : 'traga um ângulo diferente do seu'} —
          é o recurso que a equipe tem e que menos se parece com o de quem lidera.</li>
        <li>${ausentes.length
          ? `Nomear alguém para cobrir <b>${ausentes.map(c=>CONTRIB[c]).join('; ')}</b>, convidar outra área, ou assumir a lacuna conscientemente.`
          : `Dar espaço às configurações menos representadas: quem está sozinho no seu tipo de contribuição tende a ser sobrecarregado ou ignorado.`}</li>
        <li>${pctI>=40
          ? 'Com concentração alta, convém pedir contraponto de forma explícita — quando líder e maioria enxergam igual, a divergência não aparece sozinha.'
          : 'A diferença de estilo entre liderança e equipe é um recurso: exige mais tradução, e em troca amplia o repertório disponível.'}</li>
      </ul>
      <p class="nota">Leitura de complementaridade e gestão. Nenhum perfil vale mais nem menos que
        outro — o que se descreve é composição e o que ela facilita ou dificulta.</p>
    </div>
  </section>`;
}

/* ═══════════════════════════════════════════════════════════════════════════
   RELATÓRIO INTEGRAL DE DIVERSIDADE — tela do administrador
   ═══════════════════════════════════════════════════════════════════════════
   Mesma restrição de acesso do dashboard e mesma amostra mínima. Respeita os
   filtros vigentes: o relatório é sempre do recorte que está na tela.        */
function telaRelatorio(){
  const pessoas = filtrar();
  const ag = agregar(pessoas);
  const lideres = pessoas.filter(p=>p.ehLider);
  const lider = lideres.length === 1 ? lideres[0] : null;
  app.className = 'wrap larga';

  if (!ag || ag.n < 5){
    app.innerHTML = barra() + topo('Relatório integral de diversidade','')
      + `<div class="vazio">${!ag ? 'Nenhum respondente com esses filtros.'
        : `<b>${ag.n} respondente(s).</b> Abaixo de cinco, o relatório não é emitido — com
           amostra tão pequena, cada leitura coletiva identificaria as pessoas.`}</div>
        <div class="nav"><button class="btn" id="r-voltar">Voltar ao dashboard</button></div>`;
    ligarBarra();
    document.getElementById('r-voltar').onclick = ()=>{ tela='dashboard'; render(); };
    window.scrollTo(0,0);
    return;
  }

  const secoes = relatorioIntegral(pessoas, ag, lider, filtros);
  app.innerHTML = barra()
    + `<div class="ri-acoes nao-imprime">
        <button class="btn" id="r-voltar">← Dashboard</button>
        <button class="btn btn-marca" id="r-print">Gerar PDF / imprimir</button>
       </div>
       <article class="relint">
         <header class="ri-cab">
           <p class="ri-marca">ROTA26</p>
           <h2>Relatório integral de diversidade da equipe</h2>
           <p class="ri-sub">Documento de gestão · acesso restrito ao administrador e aos
             gestores autorizados</p>
         </header>
         ${secoes.map(([t,c],i)=>`<section class="ri-sec">
            <h3><span class="ri-num">${String(i+1).padStart(2,'0')}</span>${t}</h3>
            ${c}</section>`).join('')}
         <footer class="ri-rod">ROTA26 · Reavaliação v2.0 — documento interno.
           Não distribuir a participantes.</footer>
       </article>`;

  ligarBarra();
  document.getElementById('r-voltar').onclick = ()=>{ tela='dashboard'; render(); };
  document.getElementById('r-print').onclick = ()=>window.print();
  window.scrollTo(0,0);
}
