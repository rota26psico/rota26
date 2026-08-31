/* ═══════════════════════════════════════════════════════════════════════════
   PARTE 4 — RELATÓRIO INTEGRAL DE DIVERSIDADE DA EQUIPE
   ═══════════════════════════════════════════════════════════════════════════
   Cruza as três referências do instrumento em um documento único, destinado
   ao administrador e aos gestores autorizados. Nenhum nome técnico de papel
   de equipe aparece; nenhuma pessoa é descrita como melhor ou pior que outra.
   ═══════════════════════════════════════════════════════════════════════════ */

/* ── As nove contribuições ────────────────────────────────────────────────
   De onde elas vêm: o gabarito técnico já traz, para cada uma das oito
   configurações, os estilos de contribuição de que ela fica próxima. Esta
   tabela é a transcrição daquela — em linguagem simples, e só isso.

   Uma configuração fica próxima de mais de um estilo. O peso da pessoa é
   dividido igualmente entre os estilos daquela configuração; nada é
   duplicado e nada é descartado.                                          */
const PAPEIS = {
  Te: ['direcionamento','organizacao','execucao'],
  Ti: ['riscos','tecnico'],
  Fe: ['colaboracao','organizacao'],
  Fi: ['colaboracao'],
  Se: ['execucao','direcionamento'],
  Si: ['execucao','qualidade','riscos','tecnico'],
  Ne: ['estrategia','ideias'],
  Ni: ['ideias','riscos','tecnico']
};

const NOVE = [
  ['ideias',        'Ideias',                'propõe caminhos que ainda não estavam na mesa'],
  ['estrategia',    'Estratégia',            'lê o ambiente, busca fora e amplia as opções disponíveis'],
  ['organizacao',   'Organização',           'define quem faz o quê, em que ordem e até quando'],
  ['riscos',        'Análise de riscos',     'examina onde a proposta pode não se sustentar'],
  ['execucao',      'Execução',              'tira do papel e mantém o trabalho andando'],
  ['qualidade',     'Qualidade',             'confere até o fim e devolve o que ficou faltando'],
  ['colaboracao',   'Colaboração',           'sustenta o vínculo e mantém o grupo disposto a continuar'],
  ['tecnico',       'Conhecimento técnico',  'aprofunda o assunto e vira referência interna'],
  ['direcionamento','Direcionamento',        'imprime rumo e sustenta a decisão diante da pressão']
];
const NOME9 = Object.fromEntries(NOVE.map(([k,n])=>[k,n]));
const DESC9 = Object.fromEntries(NOVE.map(([k,,d])=>[k,d]));
const CHAVES9 = NOVE.map(([k])=>k);

/* Os cinco domínios que o relatório pede. Agrupam as nove; a composição de
   cada um é mostrada na tela, para o gestor ver o que entrou em cada caixa. */
const DOMINIO = {
  estrategia:'Estratégia', riscos:'Estratégia', tecnico:'Estratégia',
  organizacao:'Organização', direcionamento:'Organização',
  execucao:'Execução', qualidade:'Execução',
  ideias:'Inovação', colaboracao:'Relacionamento'
};
const CINCO = ['Estratégia','Execução','Inovação','Organização','Relacionamento'];

/* ── Linha de base ────────────────────────────────────────────────────────
   AS NOVE NÃO SÃO IGUALMENTE ALCANÇÁVEIS. Uma equipe com as oito
   configurações em partes iguais não produz 11,1% em cada contribuição:
   produz 18,8% de Colaboração e 3,1% de Qualidade, porque três configurações
   tocam colaboração e apenas uma toca qualidade.

   Sem essa correção, TODA equipe apareceria com excesso de colaboração e
   falta de qualidade — o que seria uma propriedade da tabela, não da equipe.
   Por isso o relatório lê índice: 100 = exatamente o que uma equipe
   perfeitamente distribuída produziria. Abaixo de 100 é escassez real.     */
const BASE9 = (() => {
  const b = Object.fromEntries(CHAVES9.map(k=>[k,0]));
  for (const c of CONFIGS) for (const r of PAPEIS[c]) b[r] += 12.5 / PAPEIS[c].length;
  return b;
})();
const BASE5 = (() => {
  const b = Object.fromEntries(CINCO.map(d=>[d,0]));
  for (const k of CHAVES9) b[DOMINIO[k]] += BASE9[k];
  return b;
})();

/** Perfil de contribuição de UMA pessoa, a partir do escore relativo dela. */
function contribuicaoDe(p){
  const v = Object.fromEntries(CHAVES9.map(k=>[k,0]));
  for (const c of CONFIGS){
    const parte = (p.rel[c] ?? 0) / PAPEIS[c].length;
    for (const r of PAPEIS[c]) v[r] += parte;
  }
  return v;
}

/** Perfil de contribuição da equipe: média das pessoas, mais o índice. */
function contribuicoesEquipe(pessoas){
  const soma = Object.fromEntries(CHAVES9.map(k=>[k,0]));
  for (const p of pessoas){
    const v = contribuicaoDe(p);
    for (const k of CHAVES9) soma[k] += v[k];
  }
  const tot = Object.values(soma).reduce((a,b)=>a+b,0) || 1;
  const pct = Object.fromEntries(CHAVES9.map(k=>[k, soma[k]/tot*100]));
  const idx = Object.fromEntries(CHAVES9.map(k=>[k, pct[k]/BASE9[k]*100]));

  const dom = Object.fromEntries(CINCO.map(d=>[d,0]));
  for (const k of CHAVES9) dom[DOMINIO[k]] += pct[k];
  const domIdx = Object.fromEntries(CINCO.map(d=>[d, dom[d]/BASE5[d]*100]));

  const ord = CHAVES9.slice().sort((a,b)=>idx[b]-idx[a]);
  return { pct, idx, dom, domIdx, fortes: ord.slice(0,3), fracas: ord.slice(-3).reverse() };
}

/** Quem, nominalmente, mais sustenta uma contribuição escassa. */
function quemSustenta(pessoas, chave, quantos = 3){
  return pessoas
    .map(p => ({ p, v: contribuicaoDe(p)[chave] }))
    .sort((a,b) => b.v - a.v)
    .slice(0, quantos)
    .filter(x => x.v > 0)
    .map(x => x.p);
}

/* ── Adesão ───────────────────────────────────────────────────────────────
   Na demo o efetivo vem do arquivo de população. Na aplicação real vem do
   cadastro de participantes: convidados do recorte × concluídos.          */
function adesaoDo(pessoas){
  const chaves = new Set(pessoas.map(p=>p.contrato+'§'+p.setor));
  let efetivo = 0;
  for (const k of chaves) efetivo += (D.EFETIVO?.[k] ?? 0);
  return { efetivo, respondentes: pessoas.length,
           pct: efetivo ? pessoas.length/efetivo*100 : null };
}

/* ── Período analisado ────────────────────────────────────────────────────── */
function periodoDe(pessoas){
  const ds = pessoas.map(p=>new Date(p.em)).sort((a,b)=>a-b);
  const f = d => d.toLocaleDateString('pt-BR');
  return ds.length ? { de: f(ds[0]), ate: f(ds[ds.length-1]) } : null;
}

/* ── Pares de contraponto ─────────────────────────────────────────────────
   Duas configurações são contraponto uma da outra quando diferem NA ATITUDE
   E NA FUNÇÃO. São quatro pares. Ter os dois lados de um par presentes é o
   sinal mais direto de que a equipe tem quem discorde por construção, e não
   por temperamento.                                                        */
const OPOSTO = { Te:'Fi', Fi:'Te', Ti:'Fe', Fe:'Ti', Se:'Ni', Ni:'Se', Si:'Ne', Ne:'Si' };
const PARES = [['Te','Fi'],['Ti','Fe'],['Se','Ni'],['Si','Ne']];

function contrapontos(ag){
  const completos = PARES.filter(([a,b]) => ag.porCfg[a] > 0 && ag.porCfg[b] > 0);
  const meios     = PARES.filter(([a,b]) => (ag.porCfg[a] > 0) !== (ag.porCfg[b] > 0));
  return { completos, meios, ausentes: PARES.filter(([a,b]) => !ag.porCfg[a] && !ag.porCfg[b]) };
}

/* ═══════════════════════════════════════════════════════════════════════════
   O RELATÓRIO
   ═══════════════════════════════════════════════════════════════════════════ */
function relatorioIntegral(pessoas, ag, lider, filtros){
  const n = ag.n;
  const C = contribuicoesEquipe(pessoas);
  const ad = adesaoDo(pessoas);
  const per = periodoDe(pessoas);
  const cp = contrapontos(ag);
  const pc = (v, d = 1) => v.toFixed(d).replace('.', ',');
  const ix = v => Math.round(v);
  const nomeCfg = c => PERFIL[c].animal;

  /* barra de índice, centrada em 100 */
  const barraIdx = v => {
    const larg = Math.min(100, v / 2);
    const cor = v >= 125 ? '#47632B' : v <= 75 ? '#8C3F33' : '#A66A17';
    return `<span class="ri-tr"><i style="width:${larg}%;background:${cor}"></i>
      <u style="left:50%"></u></span>`;
  };

  const S = [];   /* seções */

  /* ── 1 · identificação ────────────────────────────────────────────────── */
  const lideresDoRecorte = [...new Set(pessoas.filter(p=>p.ehLider).map(p=>p.nome))];
  S.push(['Recorte analisado', `
    <dl class="ri-id">
      <div><dt>Contrato</dt><dd>${filtros.contrato || 'todos os contratos'}</dd></div>
      <div><dt>Setor / equipe</dt><dd>${filtros.setor || 'todos os setores do recorte'}</dd></div>
      <div><dt>Líder imediato</dt><dd>${
        filtros.lider || (lideresDoRecorte.length === 1 ? lideresDoRecorte[0]
          : lideresDoRecorte.length ? `${lideresDoRecorte.length} lideranças no recorte`
          : 'nenhuma liderança respondeu neste recorte')}</dd></div>
      <div><dt>Período analisado</dt><dd>${per ? `${per.de} a ${per.ate}` : '—'}</dd></div>
      <div><dt>Instrumento</dt><dd>Reavaliação v2.0 · 48 situações</dd></div>
      <div><dt>Emitido em</dt><dd>${new Date().toLocaleString('pt-BR',{dateStyle:'short',timeStyle:'short'})}</dd></div>
    </dl>`]);

  /* ── 2 · participação ─────────────────────────────────────────────────── */
  S.push(['Participação', `
    <div class="kpis">
      <div class="kpi"><p class="r">Responderam</p><p class="v">${n}</p>
        <p class="d">pessoas no recorte</p></div>
      <div class="kpi"><p class="r">Efetivo do recorte</p><p class="v">${ad.efetivo || '—'}</p>
        <p class="d">pessoas cadastradas</p></div>
      <div class="kpi"><p class="r">Adesão</p><p class="v">${ad.pct===null?'—':pc(ad.pct,0)+'%'}</p>
        <p class="d">${ad.pct===null ? 'efetivo não informado'
          : ad.pct >= 80 ? 'cobertura ampla' : ad.pct >= 50
          ? 'metade ou mais do efetivo' : 'parcela do efetivo — leia o restante com essa ressalva'}</p></div>
      <div class="kpi"><p class="r">Configurações presentes</p>
        <p class="v">${CONFIGS.filter(c=>ag.porCfg[c]>0).length}/8</p>
        <p class="d">quantos dos oito animais aparecem</p></div>
    </div>
    ${ad.pct !== null && ad.pct < 60 ? `<p class="ri-alerta">Com adesão de ${pc(ad.pct,0)}%,
      a composição descrita é a de quem respondeu — não necessariamente a da equipe inteira.
      Quem não respondeu pode concentrar justamente o que aqui aparece como lacuna.</p>` : ''}`]);

  /* ── 3 · animais ──────────────────────────────────────────────────────── */
  const ordAnimais = CONFIGS.slice().sort((a,b)=>ag.porCfg[b]-ag.porCfg[a]);
  S.push(['Distribuição dos animais predominantes', `
    <table class="ri-tab">
      <tr><th>Animal</th><th>Configuração de Jung</th><th class="num">Pessoas</th><th class="num">%</th></tr>
      ${ordAnimais.map(c=>`<tr${ag.porCfg[c]?'':' class="zero"'}>
        <td><b style="color:${PERFIL[c].cor}">${nomeCfg(c)}</b></td>
        <td>${PERFIL[c].nomeJung}</td>
        <td class="num">${ag.porCfg[c]}</td>
        <td class="num">${pc(ag.porCfg[c]/n*100,0)}%</td></tr>`).join('')}
    </table>
    <p class="nota">As configurações sem ninguém permanecem na tabela. A ausência é
      informação de gestão — é o contraponto que a equipe não tem de quem procurar fora.</p>`]);

  /* ── 4 · Jung ─────────────────────────────────────────────────────────── */
  const fnNome = { T:'Pensamento', F:'Sentimento', S:'Sensação', N:'Intuição' };
  S.push(['Atitudes e funções de Jung', `
    <div class="duasc">
      <div>
        <p class="sub-rot">Funções — média da equipe</p>
        <table class="ri-tab">
          ${['T','F','S','N'].map(f=>`<tr><td>${fnNome[f]}</td>
            <td class="barra-c"><i style="width:${ag.fn[f]*2}%"></i></td>
            <td class="num">${pc(ag.fn[f])}%</td></tr>`).join('')}
        </table>
        <p class="nota">Cada função soma o quanto ela apareceu nas 48 escolhas, em média.
          Uma equipe perfeitamente distribuída marcaria 25% em cada.</p>
      </div>
      <div>
        <p class="sub-rot">Atitude — média da equipe</p>
        <table class="ri-tab">
          <tr><td>Extroversão</td><td class="barra-c"><i style="width:${ag.atE}%"></i></td>
            <td class="num">${pc(ag.atE)}%</td></tr>
          <tr><td>Introversão</td><td class="barra-c"><i style="width:${ag.atI}%"></i></td>
            <td class="num">${pc(ag.atI)}%</td></tr>
        </table>
        <p class="sub-rot" style="margin-top:var(--e3)">Eixos</p>
        <table class="ri-tab">
          <tr><td>Cognitivo <span class="nota">concreto ↔ possibilidade</span></td>
            <td class="num">${ag.eixoC>0?'+':''}${pc(ag.eixoC)}</td></tr>
          <tr><td>Relacional <span class="nota">tarefa ↔ pessoas</span></td>
            <td class="num">${ag.eixoR>0?'+':''}${pc(ag.eixoR)}</td></tr>
        </table>
        <p class="nota">Cada eixo vai de −100 a +100. Perto de zero significa que os dois
          polos circulam na equipe, não que ninguém tem posição.</p>
      </div>
    </div>`]);

  /* ── 5 · as nove contribuições ────────────────────────────────────────── */
  S.push(['Contribuições de equipe', `
    <table class="ri-tab ri-nove">
      <tr><th>Contribuição</th><th>O que a pessoa faz</th><th class="num">Presença</th>
        <th class="num">Esperado</th><th>Índice</th></tr>
      ${CHAVES9.slice().sort((a,b)=>C.idx[b]-C.idx[a]).map(k=>`<tr>
        <td><b>${NOME9[k]}</b></td><td class="ri-desc">${DESC9[k]}</td>
        <td class="num">${pc(C.pct[k])}%</td>
        <td class="num nota">${pc(BASE9[k])}%</td>
        <td class="ri-idx">${barraIdx(C.idx[k])}<span>${ix(C.idx[k])}</span></td></tr>`).join('')}
    </table>
    <p class="nota"><b>Por que há duas colunas de percentual.</b> As nove contribuições não são
      igualmente alcançáveis pelo instrumento: três das oito configurações passam por
      Colaboração e apenas uma passa por Qualidade. Uma equipe perfeitamente distribuída
      produziria ${pc(BASE9.colaboracao)}% de Colaboração e ${pc(BASE9.qualidade)}% de Qualidade —
      e não 11,1% em cada. Ler só a presença faria toda equipe parecer forte em Colaboração e
      carente de Qualidade, o que seria propriedade da tabela e não da equipe. Por isso o
      índice: <b>100 é exatamente o esperado</b>; abaixo de 100 é escassez de fato.</p>`]);

  /* ── 6 · forças ───────────────────────────────────────────────────────── */
  S.push(['Forças predominantes', `
    <ul class="lista-c">
      ${C.fortes.map(k=>`<li><b>${NOME9[k]}</b> — índice ${ix(C.idx[k])}${
        C.idx[k] >= 125 ? ', bem acima do esperado' : C.idx[k] >= 105 ? ', acima do esperado'
        : ' — é o ângulo mais disponível deste recorte, ainda que próximo do esperado'}.
        Aqui a equipe ${DESC9[k]}.
        ${(() => { const q = quemSustenta(pessoas, k, 3);
          return q.length ? `Mais presente em ${q.map(p=>p.nome).join(', ')}.` : ''; })()}</li>`).join('')}
    </ul>
    <p class="nota">Força aqui significa disponibilidade: é o recurso que a equipe consegue
      mobilizar sem procurar fora. Não significa que essas pessoas contribuam mais que as demais.</p>`]);

  /* ── 7 · lacunas ──────────────────────────────────────────────────────── */
  const escassas = C.fracas.filter(k => C.idx[k] < 85);
  S.push(['Lacunas e contribuições pouco representadas', escassas.length ? `
    <ul class="lista-c vazada">
      ${escassas.map(k=>{
        const q = quemSustenta(pessoas, k, 2);
        return `<li><b>${NOME9[k]}</b> — índice ${ix(C.idx[k])}: presença de ${pc(C.pct[k])}%
          onde ${pc(BASE9[k])}% seriam o esperado.
          Quem ${DESC9[k]} aparece pouco neste recorte.
          ${q.length ? `Quem mais sustenta hoje: ${q.map(p=>p.nome).join(' e ')} — e convém
            verificar se essa carga está recaindo sobre ${q.length===1?'uma pessoa só':'poucas pessoas'}.` : ''}</li>`;
      }).join('')}
    </ul>
    <p class="ri-alerta">Lacuna não é defeito da equipe: é um ângulo que ninguém aqui traz por
      inclinação. As saídas são três — designar explicitamente a alguém, convidar outra área,
      ou assumir a lacuna de forma consciente. O que não funciona é deixá-la sem dono.</p>`
    : `<p>Nenhuma das nove contribuições ficou abaixo de 85 no índice. O repertório da equipe
       cobre os nove ângulos em proporção próxima da esperada.</p>`]);

  /* ── 8 · equilíbrio entre os cinco domínios ───────────────────────────── */
  const composicao = {
    'Estratégia':'Estratégia + Análise de riscos + Conhecimento técnico',
    'Execução':'Execução + Qualidade', 'Inovação':'Ideias',
    'Organização':'Organização + Direcionamento', 'Relacionamento':'Colaboração'
  };
  const ordDom = CINCO.slice().sort((a,b)=>C.domIdx[b]-C.domIdx[a]);
  const amplitudeDom = C.domIdx[ordDom[0]] - C.domIdx[ordDom[4]];
  S.push(['Equilíbrio entre estratégia, execução, inovação, organização e relacionamento', `
    <table class="ri-tab">
      <tr><th>Domínio</th><th>Reúne</th><th class="num">Presença</th>
        <th class="num">Esperado</th><th>Índice</th></tr>
      ${ordDom.map(d=>`<tr><td><b>${d}</b></td><td class="ri-desc">${composicao[d]}</td>
        <td class="num">${pc(C.dom[d])}%</td><td class="num nota">${pc(BASE5[d])}%</td>
        <td class="ri-idx">${barraIdx(C.domIdx[d])}<span>${ix(C.domIdx[d])}</span></td></tr>`).join('')}
    </table>
    <p>${amplitudeDom < 30
      ? `Os cinco domínios ficam a menos de 30 pontos de índice uns dos outros: a equipe não
         pende de forma marcada para nenhum deles. Decisões tendem a ser negociadas entre
         ângulos diferentes, o que costuma custar tempo e render solidez.`
      : `A distância entre <b>${ordDom[0]}</b> (${ix(C.domIdx[ordDom[0]])}) e
         <b>${ordDom[4]}</b> (${ix(C.domIdx[ordDom[4]])}) é de ${ix(amplitudeDom)} pontos de índice.
         A equipe entra nos assuntos preferencialmente por ${ordDom[0].toLowerCase()}, e o que
         depende de ${ordDom[4].toLowerCase()} tende a precisar de alguém designado para não
         ficar de fora da conversa.`}</p>
    <p class="nota">O agrupamento das nove em cinco está declarado na coluna "Reúne", para que
      o gestor veja o que entrou em cada domínio em vez de receber um rótulo fechado.</p>`]);

  /* ── 9 · riscos de composição ─────────────────────────────────────────── */
  const riscos = [];
  if (ag.nucleoMax >= 50)
    riscos.push([`Concentração em uma única família`,
      `${pc(ag.nucleoMax,0)}% da equipe está na mesma família de contribuição. O alinhamento
       tende a ser rápido — e o ângulo que falta não aparece sozinho, porque ninguém sente falta dele.`]);
  if (ag.dRel < 70)
    riscos.push([`Repertório estreito para o tamanho da equipe`,
      `A dispersão observada é ${pc(ag.dRel,0)}% da esperada para ${n} pessoas. Não é efeito do
       tamanho: uma equipe deste porte costuma apresentar variedade maior.`]);
  const domAlto = ordDom[0], domBaixo = ordDom[4];
  if (C.domIdx[domAlto] >= 130 && C.domIdx[domBaixo] <= 70)
    riscos.push([`Unilateralidade entre ${domAlto} e ${domBaixo}`,
      `${domAlto} aparece em ${ix(C.domIdx[domAlto])} e ${domBaixo} em ${ix(C.domIdx[domBaixo])}.
       Reuniões tendem a girar em torno de ${domAlto.toLowerCase()}, e questões de
       ${domBaixo.toLowerCase()} tendem a entrar tarde, quando já custam mais caro.`]);
  if (cp.completos.length === 0)
    riscos.push([`Ausência de contraponto estrutural`,
      `Nenhum dos quatro pares de contraponto tem os dois lados presentes. A equipe pode
       concordar por semelhança de leitura, e não por convergência examinada.`]);
  else if (cp.completos.length === 1)
    riscos.push([`Contraponto concentrado em um único par`,
      `Apenas o par ${nomeCfg(cp.completos[0][0])} ↔ ${nomeCfg(cp.completos[0][1])} está completo.
       A divergência produtiva depende de poucas pessoas — e some quando elas faltam.`]);
  if (Math.abs(ag.eixoR) >= 25)
    riscos.push([`Eixo relacional deslocado`,
      `O eixo relacional da equipe está em ${ag.eixoR>0?'+':''}${pc(ag.eixoR)}, ou seja, deslocado
       para ${ag.eixoR>0?'o efeito sobre pessoas':'o critério impessoal'}. O outro polo tende a
       aparecer como objeção isolada, e não como parte natural da conversa.`]);
  if (ag.baixaAderencia > 0)
    riscos.push([`${ag.baixaAderencia} resultado${ag.baixaAderencia>1?'s':''} de baixa aderência`,
      `Nesses casos o resultado ficou achatado — as oito configurações pontuaram de forma
       parecida. Eles entram na contagem, mas não devem ser lidos como perfil da pessoa.`]);

  S.push(['Riscos de composição', riscos.length ? `
    <div class="ri-riscos">${riscos.map(([t,c])=>`
      <article><h5>${t}</h5><p>${c}</p></article>`).join('')}</div>
    <p class="nota">Risco aqui é probabilidade de um ângulo ficar de fora — não julgamento
      sobre a equipe nem sobre quem a integra.</p>`
    : `<p>Nenhum dos indicadores de unilateralidade, homogeneidade excessiva ou ausência de
       contraponto foi acionado neste recorte: a composição distribui os ângulos e mantém os
       polos opostos representados.</p>`]);

  /* ── 10 · complementaridade ───────────────────────────────────────────── */
  S.push(['Complementaridade entre os membros', `
    <div class="kpis">
      <div class="kpi"><p class="r">Pares de contraponto completos</p>
        <p class="v">${cp.completos.length}/4</p>
        <p class="d">os dois lados presentes na equipe</p></div>
      <div class="kpi"><p class="r">Leitura complementar</p>
        <p class="v">${pc(ag.complementares/n*100,0)}%</p>
        <p class="d">pessoas cuja segunda configuração ficou próxima da primeira</p></div>
      <div class="kpi"><p class="r">Configurações com mais de uma pessoa</p>
        <p class="v">${CONFIGS.filter(c=>ag.porCfg[c]>=2).length}/8</p>
        <p class="d">onde há dupla, ninguém sustenta o ângulo sozinho</p></div>
    </div>
    <div class="duasc" style="margin-top:var(--e3)">
      <div><p class="sub-rot">Pares completos — divergência disponível por construção</p>
        <ul class="lista-c">${cp.completos.length ? cp.completos.map(([a,b])=>
          `<li><b>${nomeCfg(a)}</b> (${ag.porCfg[a]}) ↔ <b>${nomeCfg(b)}</b> (${ag.porCfg[b]}) —
            ${CONTRIB[a]} diante de quem ${CONTRIB[b]}.</li>`).join('')
          : '<li>Nenhum par completo neste recorte.</li>'}</ul></div>
      <div><p class="sub-rot">Pares pela metade — o contraponto que falta</p>
        <ul class="lista-c vazada">${cp.meios.length ? cp.meios.map(([a,b])=>{
          const falta = ag.porCfg[a] ? b : a, tem = ag.porCfg[a] ? a : b;
          return `<li>Há quem ${CONTRIB[tem]} (<b>${nomeCfg(tem)}</b>), e não há quem
            ${CONTRIB[falta]} (<b>${nomeCfg(falta)}</b>).</li>`; }).join('')
          : '<li>Nenhum par está pela metade.</li>'}</ul></div>
    </div>
    <p class="nota">Contraponto significa diferir na atitude e na função ao mesmo tempo. São
      quatro pares possíveis. Ter os dois lados é o indício mais direto de que a discordância
      na equipe vem da composição, e não de atrito pessoal.</p>`]);

  /* ── 11 e 12 · líder e homofilia ──────────────────────────────────────── */
  if (lider){
    const equipe = pessoas.filter(p=>!p.ehLider);
    const iguais = equipe.filter(p=>p.cfg===lider.cfg).length;
    const mesmaFam = equipe.filter(p=>familiaDe(p.cfg)===familiaDe(lider.cfg)).length;
    const pctI = equipe.length ? iguais/equipe.length*100 : 0;
    const pctF = equipe.length ? mesmaFam/equipe.length*100 : 0;
    const faixa = pctI>=40 ? 'alta' : pctI>=20 ? 'moderada' : 'baixa';
    const cL = contribuicaoDe(lider);
    const totL = Object.values(cL).reduce((a,b)=>a+b,0) || 1;
    const idxL = Object.fromEntries(CHAVES9.map(k=>[k, cL[k]/totL*100/BASE9[k]*100]));
    const distantes = CHAVES9.slice()
      .sort((a,b) => (C.idx[b]-idxL[b]) - (C.idx[a]-idxL[a])).slice(0,2);
    const oposta = OPOSTO[lider.cfg];

    S.push(['Comparação entre a liderança e a composição da equipe', `
      <div class="lider-topo" style="--cor:${PERFIL[lider.cfg].cor}">
        <div class="l-disco">${animalSvg(PERFIL[lider.cfg].animal)}</div>
        <div><p class="l-rot">Configuração predominante de quem lidera</p>
          <p class="l-nome">${nomeCfg(lider.cfg)}</p>
          <p class="l-sub">${lider.nome} · ${PERFIL[lider.cfg].nomeJung} — ${CONTRIB[lider.cfg]}</p></div>
      </div>
      <table class="ri-tab" style="margin-top:var(--e3)">
        <tr><th>Contribuição</th><th class="num">Índice da liderança</th>
          <th class="num">Índice da equipe</th><th class="num">Diferença</th></tr>
        ${CHAVES9.slice().sort((a,b)=>idxL[b]-idxL[a]).map(k=>`<tr>
          <td>${NOME9[k]}</td><td class="num">${ix(idxL[k])}</td>
          <td class="num">${ix(C.idx[k])}</td>
          <td class="num ${Math.abs(C.idx[k]-idxL[k])>=40?'destaque':''}">${
            C.idx[k]-idxL[k]>0?'+':''}${ix(C.idx[k]-idxL[k])}</td></tr>`).join('')}
      </table>
      <p>A equipe traz, acima do que a liderança traz por inclinação,
        <b>${distantes.map(k=>NOME9[k]).join('</b> e <b>')}</b>. É onde a delegação rende mais:
        são ângulos que já existem na equipe e que não precisam vir de quem lidera.</p>
      ${ag.porCfg[oposta] ? `<p>O contraponto direto da liderança — <b>${nomeCfg(oposta)}</b>,
        quem ${CONTRIB[oposta]} — está presente com ${ag.porCfg[oposta]}
        ${ag.porCfg[oposta]>1?'pessoas':'pessoa'}. É o ângulo mais distante do de quem lidera,
        e por isso o mais fácil de ser descartado sem intenção.`
        : `<p>O contraponto direto da liderança — <b>${nomeCfg(oposta)}</b>, quem
        ${CONTRIB[oposta]} — não está presente na equipe. Nada nesta composição puxa a decisão
        para o lado oposto ao da liderança.`}</p>`]);

    S.push(['Homofilia', `
      <div class="kpis">
        <div class="kpi"><p class="r">Mesma configuração da liderança</p>
          <p class="v">${iguais}/${equipe.length}</p><p class="d">${pc(pctI,0)}% da equipe</p></div>
        <div class="kpi"><p class="r">Mesma família</p>
          <p class="v">${mesmaFam}/${equipe.length}</p><p class="d">${pc(pctF,0)}% da equipe</p></div>
        <div class="kpi"><p class="r">Tendência</p><p class="v" style="font-size:17px">${faixa}</p>
          <p class="d">≥40% alta · 20–40% moderada · &lt;20% baixa</p></div>
      </div>
      <p>${pctI>=40
        ? `Concentração <b>alta</b>: ${pc(pctI,0)}% da equipe compartilha a configuração de quem
           lidera. Equipes assim se entendem depressa e discordam pouco — e o pouco que discorda
           tende a ser lido como ruído. Vale pedir contraponto de forma explícita e nominal, para
           que ele não dependa de alguém se dispor a levantar a mão.`
        : pctI>=20
        ? `Concentração <b>moderada</b>: ${pc(pctI,0)}% compartilha a configuração da liderança.
           Há semelhança suficiente para alinhamento rápido e diferença suficiente para que o
           contraponto exista sem ser forçado.`
        : `Concentração <b>baixa</b>: ${pc(pctI,0)}% compartilha a configuração da liderança. A
           equipe enxerga por ângulos diferentes do de quem a conduz. Isso amplia o repertório e
           cobra mais tradução — o que é claro para a liderança não chega claro por si só.`}</p>
      <p class="nota">Homofilia descreve semelhança de estilo entre quem lidera e quem é
        liderado. Não avalia a liderança nem a equipe.</p>`]);
  } else {
    S.push(['Comparação entre a liderança e a composição da equipe',
      `<p class="nota">${lideresDoRecorte.length > 1
        ? `Este recorte reúne ${lideresDoRecorte.length} lideranças e, portanto, várias equipes.
           A comparação é feita entre uma liderança e a sua própria equipe: filtre por
           setor/equipe para obtê-la. Nenhuma média entre líderes é apresentada no lugar dela.`
        : `A liderança deste recorte não respondeu ao instrumento, ou o filtro atual não a inclui.
           Sem o resultado dela, a comparação e a leitura de homofilia não são feitas — e não
           são estimadas.`}</p>`]);
  }

  /* ── 13 · recomendações práticas, por tema ────────────────────────────── */
  const escassa = escassas[0] ?? C.fracas[0];
  const forte = C.fortes[0];
  const R = [];

  R.push(['Distribuição de responsabilidades', [
    `Ao dividir o trabalho, ${forte === 'execucao' || forte === 'qualidade'
      ? 'a equipe cobre bem a etapa de fazer e conferir — a atenção vale para o que vem antes: quem decide o rumo e quem examina o risco.'
      : `apoiar-se em ${NOME9[forte].toLowerCase()} (índice ${ix(C.idx[forte])}), que é o recurso mais disponível aqui.`}`,
    `Designar nominalmente <b>${NOME9[escassa]}</b> — ${DESC9[escassa]} — em cada frente de
     trabalho. Índice ${ix(C.idx[escassa])} significa que, sem dono declarado, esse ângulo
     tende a não aparecer.`,
    CONFIGS.filter(c=>ag.porCfg[c]===1).length
      ? `Quem está sozinho na própria configuração — ${CONFIGS.filter(c=>ag.porCfg[c]===1)
          .map(c=>nomeCfg(c)).join(', ')} — tende a acumular todas as demandas daquele tipo.
         Vale verificar a carga dessas pessoas antes de acrescentar frentes.`
      : `Nenhuma configuração depende de uma única pessoa: cada ângulo presente tem ao menos
         duas pessoas capazes de sustentá-lo.`
  ]]);

  R.push(['Comunicação', [
    ag.atE - ag.atI >= 15
      ? `A equipe pende para a extroversão (${pc(ag.atE,0)}% contra ${pc(ag.atI,0)}%). Em reunião,
         o que é formulado em voz alta domina o registro. Quem elabora por dentro precisa de
         pergunta dirigida ou de um canal escrito para que a contribuição chegue.`
      : ag.atI - ag.atE >= 15
      ? `A equipe pende para a introversão (${pc(ag.atI,0)}% contra ${pc(ag.atE,0)}%). Reuniões
         tendem a render menos que material enviado antes, com tempo para leitura. O silêncio
         aqui costuma ser elaboração, não concordância.`
      : `Extroversão e introversão estão próximas (${pc(ag.atE,0)}% / ${pc(ag.atI,0)}%). Alternar
         entre discussão aberta e material escrito atende aos dois modos sem privilegiar nenhum.`,
    Math.abs(ag.eixoR) >= 20
      ? `Com o eixo relacional em ${ag.eixoR>0?'+':''}${pc(ag.eixoR)}, comunicados que tratam só
         ${ag.eixoR>0?'de números e prazos':'do efeito sobre as pessoas'} tendem a ser recebidos
         como incompletos. Vale incluir as duas leituras na mesma mensagem.`
      : `Com o eixo relacional próximo de zero (${ag.eixoR>0?'+':''}${pc(ag.eixoR)}), a equipe
         acomoda tanto o argumento por critério quanto o argumento por efeito sobre pessoas.`
  ]]);

  R.push(['Gestão de conflitos', [
    cp.completos.length >= 2
      ? `A equipe tem ${cp.completos.length} pares de contraponto completos. Boa parte do atrito
         aqui é diferença de leitura, não desentendimento pessoal. Nomear qual é a divergência
         de fundo costuma resolver mais rápido do que mediar o clima.`
      : `Com ${cp.completos.length} par${cp.completos.length===1?'':'es'} de contraponto completo,
         a discordância depende de poucas pessoas. Quando ela aparece, tende a ser lida como
         resistência individual — vale tratá-la como informação antes de tratá-la como atrito.`,
    C.idx.colaboracao >= 115
      ? `Colaboração está em ${ix(C.idx.colaboracao)}. A equipe protege o vínculo, e o custo
         disso é o desacordo demorar a aparecer. Perguntar diretamente "o que não está sendo
         dito" costuma render mais que esperar a objeção espontânea.`
      : C.idx.colaboracao <= 85
      ? `Colaboração está em ${ix(C.idx.colaboracao)}. O desacordo aparece cedo, o que é útil, e
         a manutenção do vínculo depois dele precisa ser feita deliberadamente por alguém.`
      : `Colaboração em ${ix(C.idx.colaboracao)}: a equipe sustenta desacordo sem que o vínculo
         entre em risco a cada episódio.`
  ]]);

  R.push(['Tomada de decisão', [
    `O caminho natural de decisão aqui passa pelo domínio <b>${ordDom[0]}</b>
     (índice ${ix(C.domIdx[ordDom[0]])} no agrupamento dos cinco). ${ordDom[0]==='Execução'
      ? 'A equipe tende a decidir fazendo — o que acelera, e cobra que alguém pergunte se o rumo é o certo antes do detalhamento.'
      : ordDom[0]==='Estratégia'
      ? 'A equipe tende a examinar antes de mover — o que dá solidez, e cobra um prazo declarado para o exame não virar adiamento.'
      : ordDom[0]==='Relacionamento'
      ? 'A equipe tende a decidir buscando acordo — o que sustenta a adesão, e cobra que o critério técnico apareça explicitamente na mesa.'
      : ordDom[0]==='Inovação'
      ? 'A equipe tende a decidir pelo campo de possibilidades — o que amplia as opções, e cobra que alguém feche a escolha e organize quem faz o quê.'
      : 'A equipe tende a decidir estruturando — o que dá previsibilidade, e cobra espaço para a alternativa que não cabia na estrutura existente.'}`,
    C.idx.riscos <= 85
      ? `Análise de riscos em ${ix(C.idx.riscos)}: convém incluir formalmente a pergunta
         "onde isto pode não se sustentar" no rito de decisão, porque ela não surge sozinha.`
      : `Análise de riscos em ${ix(C.idx.riscos)}: a pergunta pelo que pode falhar já circula na
         equipe. O cuidado é o oposto — garantir prazo para a decisão fechar.`,
    ag.equilibradas > 0
      ? `${ag.equilibradas} ${ag.equilibradas>1?'pessoas transitam':'pessoa transita'} entre
         configurações sem predominância destacada. Elas costumam traduzir bem entre posições
         opostas em impasse.`
      : `Não há, neste recorte, resultado sem predominância destacada — a tradução entre
         posições opostas precisa ser feita deliberadamente por quem conduz.`
  ]]);

  R.push(['Inovação', [
    C.idx.ideias >= 115
      ? `Ideias em ${ix(C.idx.ideias)}: a geração de alternativas não é o gargalo. O gargalo
         provável é a triagem — dar número, prazo e responsável para a ideia virar discutível.`
      : C.idx.ideias <= 85
      ? `Ideias em ${ix(C.idx.ideias)}: a equipe tende a melhorar o que existe em vez de propor
         outro caminho. Trazer estímulo de fora — outra área, um caso externo — costuma render
         mais do que pedir criatividade em reunião interna.`
      : `Ideias em ${ix(C.idx.ideias)}: a equipe propõe alternativas em proporção próxima da
         esperada. Mantê-las vivas depende de haver quem as registre e retome.`,
    C.idx.estrategia <= 85
      ? `Estratégia em ${ix(C.idx.estrategia)}: a busca por referência fora da equipe é o ângulo
         mais escasso. Vale institucionalizá-la — alguém encarregado de trazer o que outras
         áreas já resolveram — em vez de esperar que aconteça.`
      : `Estratégia em ${ix(C.idx.estrategia)}: há quem traga material de fora. Convém que esse
         material chegue à decisão, e não só à conversa.`
  ]]);

  R.push(['Organização', [
    C.idx.organizacao >= 115
      ? `Organização em ${ix(C.idx.organizacao)}: a estrutura aparece com facilidade. O risco é
         o processo virar a resposta para problemas que são de conteúdo.`
      : C.idx.organizacao <= 85
      ? `Organização em ${ix(C.idx.organizacao)}: definir quem faz o quê e até quando é o que
         menos surge espontaneamente. Fechar cada reunião com responsável e prazo declarados
         compensa a maior parte dessa lacuna.`
      : `Organização em ${ix(C.idx.organizacao)}: a estrutura surge quando é pedida, e não
         precisa ser imposta.`,
    C.idx.qualidade <= 85
      ? `Qualidade em ${ix(C.idx.qualidade)}: a etapa de conferir até o fim tende a ser a
         primeira sacrificada sob pressa. Uma checagem declarada no fluxo, com responsável,
         sustenta o padrão que o simples pedido de atenção não sustenta.`
      : `Qualidade em ${ix(C.idx.qualidade)}: há quem sustente a conferência mesmo sob pressa —
         convém que essa checagem esteja no fluxo, e não dependa de a pessoa estar disponível.`
  ]]);

  R.push(['Desenvolvimento da equipe', [
    `Os ângulos mais escassos — ${C.fracas.map(k=>NOME9[k]).join(', ')} — indicam onde a
     formação rende mais, e também que tipo de perfil complementaria a equipe em uma futura
     composição. São indicações de desenvolvimento, não de substituição de pessoas.`,
    `As pessoas com leitura complementar (${pc(ag.complementares/n*100,0)}% do recorte) transitam
     entre duas configurações próximas. São candidatas naturais a papéis de articulação entre
     frentes que hoje não se conversam.`,
    `A devolutiva individual deve ser feita em termos de tendência e de contexto de trabalho.
     O instrumento descreve preferência de atuação em um momento — não capacidade, não potencial
     e não desempenho.`
  ]]);

  S.push(['Recomendações práticas', `
    <div class="ri-recs">${R.map(([t,itens])=>`
      <article><h5>${t}</h5><ul class="lista-c">${itens.map(i=>`<li>${i}</li>`).join('')}</ul></article>`).join('')}</div>`]);

  /* ── limites ──────────────────────────────────────────────────────────── */
  S.push(['Limites de uso deste relatório', `
    <ul class="lista-c vazada">
      <li>O relatório descreve <b>maneira preferencial de atuação no trabalho</b>, apurada por
        autorrelato, em um momento determinado. Ela muda com contexto, função e tempo.</li>
      <li>Nenhuma configuração vale mais nem menos que outra. Não há composição de equipe
        superior a outra: há composições que facilitam certas coisas e dificultam outras.</li>
      <li>Não constitui diagnóstico psicológico nem avaliação clínica.</li>
      <li>Não deve ser usado para seleção, promoção, desligamento ou avaliação de desempenho.</li>
      <li>As leituras aqui são <b>hipóteses de gestão</b>, para serem verificadas na convivência
        com a equipe — não conclusões sobre as pessoas.</li>
    </ul>`]);

  return S;
}
