/* ═══════════════════════════════════════════════════════════════════════════
   PARTE 2 — IDENTIFICAÇÃO, ÁREA ADMINISTRATIVA E LEITURA GERENCIAL
   ═══════════════════════════════════════════════════════════════════════════
   Este bloco é injetado no HTML da demo depois do motor de apuração.
   ═══════════════════════════════════════════════════════════════════════════ */

/* ── Leitura de contribuição em linguagem simples ─────────────────────────
   O nome técnico de Belbin NUNCA aparece. A associação entre configuração e
   frase vem da tabela de afinidade do gabarito (nota ≥ 4). */
const CONTRIB = {
  Te: 'organiza e transforma decisões em plano',
  Ti: 'analisa riscos antes de decidir',
  Fe: 'facilita acordos e dá direção ao grupo',
  Fi: 'aproxima as pessoas e sustenta o vínculo',
  Se: 'impulsiona a execução',
  Si: 'cuida da qualidade e dos detalhes',
  Ne: 'gera ideias e novas possibilidades',
  Ni: 'aprofunda o assunto e antecipa consequências'
};

/* As quatro famílias saem direto das funções de Jung — sem sobreposição e
   sem categoria inventada. É o mesmo recorte que o pedido descreve. */
const FAMILIA = { T: 'Análise', F: 'Relacionamento', S: 'Execução', N: 'Inovação' };
const FAM_DESC = {
  'Análise': 'lógica, critério, exame de risco',
  'Relacionamento': 'coesão, clima, vínculo',
  'Execução': 'operação, detalhe, continuidade',
  'Inovação': 'possibilidade, futuro, mudança'
};
const familiaDe = c => FAMILIA[INFO[c].funcao];

/* Dispersão esperada ao acaso, por tamanho de equipe. Sem isso, um corte fixo
   classificaria equipe pequena como homogênea e equipe grande como diversa —
   por tamanho, não por composição. */
const REF_DISP = {5:64.1,6:63.9,7:74.5,8:75.0,9:80.6,10:81.5,11:82.7,12:84.1,13:85.4,
  14:86.8,15:88.0,16:88.6,17:89.2,18:89.8,19:90.4,20:90.9,25:93.5,30:94.7,40:96.0,60:97.4,100:98.4};
function dispEsperada(n){
  const ks = Object.keys(REF_DISP).map(Number).sort((a,b)=>a-b);
  if (n <= ks[0]) return REF_DISP[ks[0]];
  if (n >= ks[ks.length-1]) return REF_DISP[ks[ks.length-1]];
  for (let i=0;i<ks.length-1;i++){
    if (n>=ks[i] && n<=ks[i+1]){
      const t=(n-ks[i])/(ks[i+1]-ks[i]);
      return REF_DISP[ks[i]] + t*(REF_DISP[ks[i+1]]-REF_DISP[ks[i]]);
    }
  }
  return 90;
}
function entropiaNorm(contagens, k){
  const n = contagens.reduce((a,b)=>a+b,0);
  if (!n) return 0;
  const h = -contagens.filter(v=>v>0).map(v=>v/n).reduce((a,p)=>a+p*Math.log(p),0);
  return h/Math.log(k)*100;
}

/* ── Agregação da equipe ─────────────────────────────────────────────────── */
function agregar(pessoas){
  const n = pessoas.length;
  if (!n) return null;
  const conta = c => pessoas.filter(p=>p.cfg===c).length;
  const porCfg = Object.fromEntries(CONFIGS.map(c=>[c,conta(c)]));
  const porFam = {}; for (const f of Object.values(FAMILIA)) porFam[f]=0;
  for (const p of pessoas) porFam[familiaDe(p.cfg)]++;

  const media = k => pessoas.reduce((a,p)=>a+k(p),0)/n;
  const disp = entropiaNorm(CONFIGS.map(c=>porCfg[c]), 8);
  const dRel = disp / dispEsperada(n) * 100;
  const famPct = Object.fromEntries(Object.entries(porFam).map(([f,v])=>[f, v/n*100]));
  const lacunas = Object.entries(famPct).filter(([,v])=>v<15).map(([f])=>f);
  const nucleoMax = Math.max(...Object.values(famPct));
  const cfgComDupla = CONFIGS.filter(c=>porCfg[c]>=2).length;

  let classe, criterio;
  if (dRel < 70 || nucleoMax >= 50){
    classe='Predominantemente homogênea';
    criterio = nucleoMax>=50
      ? `uma única família concentra ${nucleoMax.toFixed(0)}% da equipe`
      : `dispersão ${dRel.toFixed(0)}% do esperado para ${n} pessoas`;
  } else if (dRel >= 85 && lacunas.length === 0 && cfgComDupla === 0 && n >= 6){
    classe='Fragmentada';
    criterio = 'estilos espalhados sem nenhuma configuração repetida — não há núcleo em que a equipe se reconheça';
  } else if (lacunas.length > 0){
    classe='Diversa com necessidade de alinhamento';
    criterio = `pluralidade presente, mas ${lacunas.length===1?'a família':'as famílias'} ${lacunas.join(' e ')} ${lacunas.length===1?'aparece':'aparecem'} abaixo de 15%`;
  } else {
    classe='Diversa e estratégica';
    criterio = `as quatro famílias presentes acima de 15% e dispersão em ${dRel.toFixed(0)}% do esperado`;
  }

  return { n, porCfg, porFam, famPct, disp, dRel, lacunas, nucleoMax, classe, criterio,
    fn: { T:media(p=>p.fn.T), F:media(p=>p.fn.F), S:media(p=>p.fn.S), N:media(p=>p.fn.N) },
    atE: media(p=>p.atE), atI: media(p=>p.atI),
    eixoC: media(p=>p.eixoC), eixoR: media(p=>p.eixoR),
    complementares: pessoas.filter(p=>p.complementar).length,
    desempates: pessoas.filter(p=>p.desempate).length,
    equilibradas: pessoas.filter(p=>p.classificacao==='configuracao_equilibrada').length,
    baixaAderencia: pessoas.filter(p=>p.classificacao==='baixa_aderencia').length
  };
}

/* ── Relatório gerencial escrito ─────────────────────────────────────────── */
function relatorioGerencial(ag, pessoas, lider){
  const ord = CONFIGS.filter(c=>ag.porCfg[c]>0).sort((a,b)=>ag.porCfg[b]-ag.porCfg[a]);
  const ausentes = CONFIGS.filter(c=>ag.porCfg[c]===0);
  const pc = c => (ag.porCfg[c]/ag.n*100).toFixed(0);
  const nm = c => PERFIL[c].animal;
  const famOrd = Object.entries(ag.famPct).sort((a,b)=>b[1]-a[1]);

  const P = [];

  P.push(['Síntese da composição',
    `A equipe reúne <b>${ag.n} respondentes</b> distribuídos em <b>${ord.length} das oito configurações</b>. ` +
    `A mais presente é <b>${nm(ord[0])}</b> (${pc(ord[0])}%), que ${CONTRIB[ord[0]]}` +
    (ord[1] ? `, seguida de <b>${nm(ord[1])}</b> (${pc(ord[1])}%), que ${CONTRIB[ord[1]]}.` : '.') +
    ` Em famílias de contribuição, o peso maior está em <b>${famOrd[0][0]}</b> (${famOrd[0][1].toFixed(0)}%) ` +
    `e o menor em <b>${famOrd[3][0]}</b> (${famOrd[3][1].toFixed(0)}%).`]);

  P.push(['Forças coletivas',
    `O que esta equipe tem de sobra: ` +
    ord.slice(0,3).map(c=>`gente que <b>${CONTRIB[c]}</b>`).join('; ') + `. ` +
    `Em situações que dependam desses recursos, a equipe responde sem precisar buscar fora.`]);

  P.push(['Recursos menos presentes',
    ausentes.length
      ? `Nenhum respondente aparece como <b>${ausentes.map(nm).join(', ')}</b>. Na prática, falta com quem contar para ` +
        ausentes.map(c=>CONTRIB[c]).join('; ') + `. Isso não é defeito da equipe — é o mapa de onde ela precisa buscar apoio.`
      : `As oito configurações têm ao menos um representante. O que varia é o peso: ` +
        `<b>${nm(ord[ord.length-1])}</b> aparece em apenas ${pc(ord[ord.length-1])}%, ` +
        `então quem ${CONTRIB[ord[ord.length-1]]} está isolado e pode ficar sobrecarregado.`]);

  const eq = Object.values(ag.famPct);
  const amplitudeFam = Math.max(...eq) - Math.min(...eq);
  P.push(['Equilíbrio entre análise, relacionamento, execução e inovação',
    amplitudeFam <= 15
      ? `As quatro famílias ficam dentro de ${amplitudeFam.toFixed(0)} pontos percentuais entre si — a equipe cobre as quatro frentes sem depender de uma só.`
      : `A diferença entre a família mais presente (<b>${famOrd[0][0]}</b>, ${famOrd[0][1].toFixed(0)}%) e a menos presente ` +
        `(<b>${famOrd[3][0]}</b>, ${famOrd[3][1].toFixed(0)}%) é de <b>${amplitudeFam.toFixed(0)} pontos percentuais</b>. ` +
        `A equipe pende para ${famOrd[0][0].toLowerCase()} e tende a chegar mais tarde ao que depende de ${famOrd[3][0].toLowerCase()}.`]);

  /* Riscos de unilateralidade — só os que os números sustentam. */
  const R = [];
  const f = ag.famPct;
  if (f['Execução'] >= 40 && f['Inovação'] < 15)
    R.push('<b>Muita execução, pouca inovação.</b> A equipe entrega bem o que já está definido, e tende a repetir a forma conhecida quando o problema muda de natureza.');
  if (f['Análise'] >= 40 && f['Relacionamento'] < 15)
    R.push('<b>Muita análise, pouca atenção ao clima.</b> As decisões tendem a ser tecnicamente sólidas e a custar mais em adesão do que o previsto.');
  if (f['Inovação'] >= 40 && f['Execução'] < 15)
    R.push('<b>Muitas ideias, pouca estrutura de implementação.</b> O risco é abrir mais frentes do que a equipe consegue concluir.');
  if (f['Relacionamento'] >= 40 && f['Análise'] < 15)
    R.push('<b>Muito cuidado com o vínculo, pouco contraditório.</b> O grupo tende a evitar o desacordo que ajudaria a decisão.');
  if (ag.nucleoMax >= 50)
    R.push(`<b>Concentração alta.</b> Metade ou mais da equipe está na mesma família (${famOrd[0][0]}), o que reduz o contraponto disponível internamente.`);
  if (!R.length)
    R.push('Nenhum desequilíbrio acentuado aparece nos números: as quatro famílias têm representação, e nenhuma domina a ponto de suprimir as outras.');
  P.push(['Riscos de unilateralidade', R.join('<br><br>')]);

  P.push(['Pontos de atenção no dia a dia',
    `<b>Comunicação.</b> A equipe está em ${ag.atE >= 55 ? 'maioria extrovertida' : ag.atI >= 55 ? 'maioria introvertida' : 'equilíbrio entre extroversão e introversão'} ` +
    `(${ag.atE.toFixed(0)}% / ${ag.atI.toFixed(0)}%). ` +
    (ag.atE >= 55 ? 'Decisões tendem a se formar falando; quem processa por dentro pode não alcançar a palavra a tempo.'
     : ag.atI >= 55 ? 'Muito se decide fora da reunião; convém abrir espaço explícito para posições que não foram ditas.'
     : 'Convivem os dois ritmos, o que ajuda desde que a reunião respeite os dois.') +
    `<br><br><b>Decisão e conflito.</b> ${f['Análise'] >= f['Relacionamento']
      ? 'O critério impessoal pesa mais que o custo humano — o conflito tende a ser tratado pelo mérito, e a forma pode machucar.'
      : 'O valor humano pesa mais que o critério impessoal — o conflito tende a ser suavizado, e o desacordo real pode demorar a aparecer.'}` +
    `<br><br><b>Execução e inovação.</b> ${f['Execução'] >= f['Inovação']
      ? 'A equipe se apoia no que já funciona; mudanças precisam de justificativa concreta para pegar.'
      : 'A equipe se move por possibilidade; o desafio é fechar e sustentar o que foi aberto.'}`]);

  /* Distribuição de papéis — sugestão prática, ancorada em quem existe. */
  const sug = ord.slice(0,4).map(c =>
    `<b>${nm(c)}</b> (${ag.porCfg[c]} pessoa${ag.porCfg[c]>1?'s':''}) — apoiar-se nessa configuração quando o trabalho pedir ${CONTRIB[c]}.`);
  const faltando = ausentes.length ? ausentes : [ord[ord.length-1]];
  P.push(['Distribuição de responsabilidades',
    sug.join('<br>') +
    `<br><br>Onde buscar contraponto: o que a equipe menos tem é ${faltando.map(c=>CONTRIB[c]).join('; ')}. ` +
    `Vale designar isso explicitamente a alguém, convidar outra área, ou assumir a lacuna de forma consciente — ` +
    `o risco maior é ela ficar sem dono e aparecer só quando o custo já foi pago.`]);

  if (lider){
    const semelhantes = pessoas.filter(p=>!p.ehLider && p.cfg===lider.cfg).length;
    const equipe = pessoas.filter(p=>!p.ehLider).length;
    const pctL = equipe ? semelhantes/equipe*100 : 0;
    const mesmaFam = pessoas.filter(p=>!p.ehLider && familiaDe(p.cfg)===familiaDe(lider.cfg)).length;
    P.push(['Liderança e composição',
      `A configuração predominante de <b>${lider.nome}</b> é <b>${nm(lider.cfg)}</b> — quem ${CONTRIB[lider.cfg]}. ` +
      `<b>${semelhantes} de ${equipe}</b> integrantes (${pctL.toFixed(0)}%) compartilham essa mesma configuração, e ` +
      `<b>${mesmaFam}</b> compartilham a família <b>${familiaDe(lider.cfg)}</b>. ` +
      (pctL >= 40
        ? `Concentração alta. Vale considerar como <b>hipótese de gestão</b> — não como conclusão — que a semelhança de estilo esteja influenciando composição ou delegação. O contraponto tende a ficar escasso quando líder e maioria enxergam o problema pelo mesmo ângulo.`
        : pctL >= 20
        ? `Concentração moderada: há afinidade de estilo, e há diferença suficiente para o contraponto existir.`
        : `Concentração baixa: a equipe difere bastante do estilo de quem lidera, o que amplia o repertório disponível e exige mais tradução entre as partes.`)]);
  }

  return P;
}
