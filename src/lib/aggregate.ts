/**
 * NÍVEL 3 — ANÁLISE DA EQUIPE (v2.0)
 * ===========================================================================
 * MUDANÇA OBRIGATÓRIA DA v2.0 (item 38): a equipe NÃO é mais calculada apenas
 * pelo rótulo do perfil predominante. A agregação usa os VETORES COMPLETOS de
 * cada participante — escores das quatro funções, das duas atitudes, dos seis
 * eixos, das dez capacidades e das nove proximidades Belbin.
 *
 * Assim, duas pessoas ambas "Intuição Extrovertida" — uma com Pensamento 73 e
 * outra com Sentimento 71 — deixam de contar como funcionalmente iguais.
 *
 * Determinístico, sem IA. Diversidade NÃO é qualidade (item 79).
 */

import { PERFIS, PERFIL_POR_ID, NOME_FUNCAO, NOME_ATITUDE, type PerfilId, type Funcao, type Atitude } from '../data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN, type Capacidade, type PapelBelbin } from '../data/functional';
import { NOME_EIXO, PARES_EIXO, type EixoAux } from '../data/questions';
import { intensidade, type Intensidade, type VetorParticipante } from './resultado';

export interface MembroAgregado extends VetorParticipante {
  id: string;
  setor: string;
}

export const MIN_PARTICIPANTES_INTERPRETACAO = 5;

/** Limiar para considerar alguém "portador" de uma capacidade (escore relativo). */
export const LIMIAR_PORTADOR = 50;

export type Faixa = 'baixa' | 'moderada' | 'alta';
export type NivelCobertura = 'forte' | 'adequada' | 'moderada' | 'baixa';

export interface AnaliseEquipe {
  n: number;
  amostraSuficiente: boolean;
  avisoAmostra: string | null;

  idf: number; idfFaixa: Faixa;
  idfComponentes: { perfis: number; funcoes: number; dispersaoVetorial: number };

  icf: number; icfFaixa: Faixa;
  cobertura: {
    capacidade: Capacidade; nome: string; valor: number; nivel: NivelCobertura;
    portadores: number; media: number; belbin: string; desc: string;
  }[];

  distribuicaoPerfis: { perfil: PerfilId; animal: string; nome: string; cor: string; n: number; pct: number }[];
  distribuicaoFuncoes: { funcao: Funcao; nome: string; n: number; pct: number; media: number }[];
  distribuicaoAtitudes: { atitude: Atitude; nome: string; n: number; pct: number; media: number }[];
  distribuicaoEixos: { eixo: EixoAux; nome: string; media: number }[];
  belbinEquipe: { id: PapelBelbin; nome: string; media: number; intensidade: Intensidade; portadores: number; dimensao: string }[];

  concentracao: { hhi: number; maiorPerfil: PerfilId | null; maiorPerfilPct: number; perfisPresentes: number };
  complementaridade: { pct: number; capacidadesCobertas: number; total: number };

  potencias: { titulo: string; evidencia: string }[];
  sombraColetiva: { titulo: string; potencia: string[]; sombra: string[] }[];
  pontosAtencao: { titulo: string; evidencia: string }[];
  lacunas: { capacidade: Capacidade; nome: string; valor: number; interpretacao: string }[];
  recomendacoes: { tipo: string; texto: string }[];
  acoesLideranca: { titulo: string; itens: string[] }[];
  leituraBelbin: string[];
}

/* ── utilitários ─────────────────────────────────────────────────────────── */

const media = (v: number[]) => (v.length ? v.reduce((a, b) => a + b, 0) / v.length : 0);
const dp = (v: number[]) => {
  if (v.length < 2) return 0;
  const m = media(v);
  return Math.sqrt(v.reduce((s, x) => s + (x - m) ** 2, 0) / (v.length - 1));
};
const arred = (v: number) => Math.round(v * 10) / 10;

function entropiaNormalizada(cont: number[]): number {
  const t = cont.reduce((a, b) => a + b, 0), k = cont.length;
  if (!t || k <= 1) return 0;
  let h = 0;
  for (const c of cont) if (c > 0) { const p = c / t; h -= p * Math.log2(p); }
  return h / Math.log2(k);
}

const faixa = (v: number, b: number, a: number): Faixa => (v < b ? 'baixa' : v > a ? 'alta' : 'moderada');
const nivelCob = (v: number): NivelCobertura => v >= 70 ? 'forte' : v >= 55 ? 'adequada' : v >= 40 ? 'moderada' : 'baixa';

/* ── análise ─────────────────────────────────────────────────────────────── */

export function analisarEquipe(membros: MembroAgregado[]): AnaliseEquipe {
  const n = membros.length;
  const pctN = (v: number) => (n ? arred((v / n) * 100) : 0);

  const contPerfil = Object.fromEntries(PERFIS.map(p => [p.id, 0])) as Record<PerfilId, number>;
  const contFuncao: Record<Funcao, number> = { T: 0, F: 0, S: 0, N: 0 };
  const contAtitude: Record<Atitude, number> = { E: 0, I: 0 };
  for (const m of membros) { contPerfil[m.perfil]++; contFuncao[m.funcaoDominante]++; contAtitude[m.atitude]++; }

  const distribuicaoPerfis = PERFIS.map(p => ({
    perfil: p.id, animal: p.animal, nome: p.nomeJung, cor: p.cor,
    n: contPerfil[p.id], pct: pctN(contPerfil[p.id])
  }));
  const distribuicaoFuncoes = (['T', 'F', 'S', 'N'] as Funcao[]).map(f => ({
    funcao: f, nome: NOME_FUNCAO[f], n: contFuncao[f], pct: pctN(contFuncao[f]),
    media: arred(media(membros.map(m => m.jung[f])))
  }));
  const distribuicaoAtitudes = (['E', 'I'] as Atitude[]).map(a => ({
    atitude: a, nome: NOME_ATITUDE[a], n: contAtitude[a], pct: pctN(contAtitude[a]),
    media: arred(media(membros.map(m => m.jung[a])))
  }));
  const distribuicaoEixos = (['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as EixoAux[]).map(e => ({
    eixo: e, nome: NOME_EIXO[e], media: arred(media(membros.map(m => m.eixos[e])))
  }));

  /* ── IDF — Índice de Diversidade Funcional ────────────────────────────────
   * Fórmula documentada (item 40). Três componentes, todos 0–1:
   *   P — entropia normalizada da distribuição dos 8 perfis        (peso 0,25)
   *   F — entropia normalizada da distribuição das 4 funções       (peso 0,25)
   *   D — DISPERSÃO VETORIAL: desvio-padrão médio, entre os 22
   *       escores contínuos (6 Jung + 6 eixos + 10 capacidades),
   *       normalizado por 25 pontos e limitado a 1                 (peso 0,50)
   * O componente D é a correção pedida: mede a variedade REAL dos escores, e
   * não apenas quantos rótulos diferentes existem. Duas equipes com os mesmos
   * 8 rótulos mas escores muito distintos deixam de ter o mesmo IDF.
   * As faixas são parâmetros internos exploratórios, não normas populacionais.
   */
  const dims: number[][] = [];
  for (const k of ['E', 'I', 'T', 'F', 'S', 'N'] as const) dims.push(membros.map(m => m.jung[k]));
  for (const k of ['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as EixoAux[]) dims.push(membros.map(m => m.eixos[k]));
  for (const c of CAPACIDADES) dims.push(membros.map(m => m.capacidades[c.id]));
  const dispersao = n >= 2 ? media(dims.map(d => Math.min(1, dp(d) / 25))) : 0;

  const cP = entropiaNormalizada(PERFIS.map(p => contPerfil[p.id]));
  const cF = entropiaNormalizada(Object.values(contFuncao));
  const idf = arred((cP * 0.25 + cF * 0.25 + dispersao * 0.50) * 100);

  /* ── ICF — Índice de Cobertura Funcional ──────────────────────────────────
   * Calculado a partir dos escores comportamentais INDIVIDUAIS (item 41).
   * Para cada capacidade:
   *   portadores = participantes com escore relativo ≥ 50
   *   alvo       = 1 portador a cada 8 pessoas (mínimo 1)
   *   valor      = 70% presença de portadores + 30% média da equipe
   */
  const alvo = Math.max(1, Math.round(n / 8));
  const cobertura = CAPACIDADES.map(c => {
    const vals = membros.map(m => m.capacidades[c.id]);
    const portadores = vals.filter(v => v >= LIMIAR_PORTADOR).length;
    const med = media(vals);
    const valor = arred((0.70 * Math.min(1, portadores / alvo) + 0.30 * (med / 100)) * 100);
    return {
      capacidade: c.id, nome: c.nome, valor, nivel: nivelCob(valor),
      portadores, media: arred(med), belbin: c.belbin, desc: c.desc
    };
  });
  const icf = arred(media(cobertura.map(c => c.valor)));

  /* ── Belbin da equipe, a partir das respostas dos participantes (item 47) ── */
  const belbinEquipe = PAPEIS_BELBIN.map(p => {
    const vals = membros.map(m => m.belbin[p.id]);
    const med = media(vals);
    return {
      id: p.id, nome: p.nome, media: arred(med), intensidade: intensidade(med),
      portadores: vals.filter(v => v >= LIMIAR_PORTADOR).length, dimensao: p.dimensao
    };
  });

  const hhi = n ? Math.round(PERFIS.reduce((s, p) => s + (contPerfil[p.id] / n) ** 2, 0) * 1000) / 1000 : 0;
  const maior = [...PERFIS].sort((a, b) => contPerfil[b.id] - contPerfil[a.id])[0];
  const perfisPresentes = PERFIS.filter(p => contPerfil[p.id] > 0).length;
  const cobertas = cobertura.filter(c => c.portadores > 0).length;

  /* ── Leitura qualitativa, sempre ancorada nos dados ──────────────────── */
  const ordCob = [...cobertura].sort((a, b) => b.valor - a.valor);
  const topo = ordCob.filter(c => c.valor >= 55).slice(0, 4);
  const baixas = ordCob.filter(c => c.valor < 55).slice(-3).reverse();
  const baseRel = baixas.length ? baixas : ordCob.slice(-2).reverse();
  const soRelativo = baixas.length === 0;

  const potencias: { titulo: string; evidencia: string }[] = topo.map(c => ({
    titulo: `Boa cobertura de ${c.nome.toLowerCase()}`,
    evidencia: `${c.portadores} de ${n} participante(s) apresentam escore relativo ≥ ${LIMIAR_PORTADOR} nesta capacidade, e a média da equipe é ${c.media}. Referência funcional: ${c.belbin}.`
  }));
  const fnTop = [...distribuicaoFuncoes].sort((a, b) => b.media - a.media)[0];
  if (n && fnTop.media >= 28) potencias.push({
    titulo: `Presença relativa forte de ${fnTop.nome}`,
    evidencia: `Média de ${fnTop.media} no escore relativo de ${fnTop.nome}, e ${fnTop.n} de ${n} participante(s) têm essa função como dominante.`
  });
  const belTop = [...belbinEquipe].sort((a, b) => b.media - a.media)[0];
  if (n) potencias.push({
    titulo: `Recursos próximos ao papel ${belTop.nome}`,
    evidencia: `Média de proximidade ${belTop.media} (${belTop.intensidade.toLowerCase()}), com ${belTop.portadores} participante(s) acima do limiar.`
  });

  /* Sombra coletiva (item 45): sempre derivada de uma FORÇA da equipe. */
  const sombraColetiva = construirSombraColetiva(distribuicaoEixos, cobertura, n);

  const pontosAtencao: { titulo: string; evidencia: string }[] = [];
  if (n && hhi >= 0.30) pontosAtencao.push({
    titulo: 'Concentração de perfis',
    evidencia: `O perfil ${PERFIL_POR_ID[maior.id].animal} concentra ${pctN(contPerfil[maior.id])}% da equipe e ${perfisPresentes} dos 8 perfis estão presentes. Isso pode produzir alinhamento em situações compatíveis, mas merece atenção para que outras perspectivas tenham espaço.`
  });
  const at = [...distribuicaoAtitudes].sort((a, b) => b.pct - a.pct)[0];
  if (n >= MIN_PARTICIPANTES_INTERPRETACAO && at.pct >= 75) pontosAtencao.push({
    titulo: `Predominância de ${at.nome}`,
    evidencia: `${at.pct}% da equipe tende a ${at.atitude === 'E' ? 'orientar a atenção ao ambiente externo' : 'orientar a atenção à elaboração interna'} (média do escore relativo: ${at.media}). A perspectiva complementar aparece com menor frequência.`
  });
  for (const c of baseRel) pontosAtencao.push({
    titulo: soRelativo ? `${c.nome} é o ponto comparativamente mais frágil` : `Menor cobertura de ${c.nome.toLowerCase()}`,
    evidencia: soRelativo
      ? `Nenhuma capacidade ficou abaixo do limiar, o que sugere um conjunto amplo de recursos. Ainda assim, ${c.nome.toLowerCase()} tem a menor cobertura relativa (${c.valor}%, ${c.portadores} portador(es)) e tende a ser a primeira a ficar descoberta se a equipe mudar de composição ou de foco.`
      : `Cobertura estimada em ${c.valor}% (nível ${c.nivel}), com ${c.portadores} portador(es) e média ${c.media}. Os dados indicam menor presença relativa de comportamentos associados a esta capacidade.`
  });
  if (n && n < MIN_PARTICIPANTES_INTERPRETACAO) pontosAtencao.push({
    titulo: 'Amostra insuficiente para leitura coletiva',
    evidencia: `Com ${n} respondente(s), os indicadores são instáveis: a entrada ou saída de uma pessoa altera substancialmente os valores.`
  });

  const lacunas = baseRel.map(c => ({
    capacidade: c.capacidade, nome: c.nome, valor: c.valor,
    interpretacao: soRelativo
      ? `Não é uma lacuna absoluta: a cobertura de ${c.nome.toLowerCase()} está em ${c.valor}%. É a menor do conjunto, o que a torna a capacidade mais exposta a variações de composição.`
      : `Os dados indicam ${LACUNA_TEXTO[c.capacidade]}. ${c.portadores === 0
        ? 'Nenhum participante atinge o limiar de portador nesta capacidade.'
        : `Apenas ${c.portadores} de ${n} participante(s) atingem o limiar.`} Isso não significa que a equipe seja incapaz de exercê-la — sugere que ela tende a exigir esforço deliberado, e não a surgir espontaneamente.`
  }));

  return {
    n,
    amostraSuficiente: n >= MIN_PARTICIPANTES_INTERPRETACAO,
    avisoAmostra: n >= MIN_PARTICIPANTES_INTERPRETACAO ? null
      : 'A quantidade atual de respondentes é pequena para uma interpretação coletiva estável e pode comprometer a confidencialidade dos participantes.',
    idf, idfFaixa: faixa(idf, 40, 65),
    idfComponentes: { perfis: arred(cP * 100), funcoes: arred(cF * 100), dispersaoVetorial: arred(dispersao * 100) },
    icf, icfFaixa: faixa(icf, 45, 70),
    cobertura,
    distribuicaoPerfis, distribuicaoFuncoes, distribuicaoAtitudes, distribuicaoEixos, belbinEquipe,
    concentracao: { hhi, maiorPerfil: n ? maior.id : null, maiorPerfilPct: n ? pctN(contPerfil[maior.id]) : 0, perfisPresentes },
    complementaridade: { pct: arred((cobertas / CAPACIDADES.length) * 100), capacidadesCobertas: cobertas, total: CAPACIDADES.length },
    potencias, sombraColetiva, pontosAtencao, lacunas,
    recomendacoes: gerarRecomendacoes(baseRel.map(l => l.capacidade), arred((cobertas / CAPACIDADES.length) * 100), hhi),
    acoesLideranca: acoesParaLideranca(cobertura, distribuicaoEixos),
    leituraBelbin: leituraExecutivaBelbin(belbinEquipe, n)
  };
}

const LACUNA_TEXTO: Record<Capacidade, string> = {
  CRIAR: 'menor presença relativa de comportamentos associados à geração de alternativas e à ruptura com modelos estabelecidos',
  EXPLORAR: 'menor presença relativa de comportamentos associados à busca ativa de oportunidades e recursos fora da fronteira da equipe',
  ANALISAR: 'menor presença relativa de comportamentos associados à avaliação crítica de ideias antes da decisão',
  DECIDIR: 'menor presença relativa de comportamentos associados a impulsionar a ação e enfrentar obstáculos',
  ORGANIZAR: 'menor presença relativa de comportamentos associados a transformar decisões em processos aplicáveis',
  EXECUTAR: 'menor presença relativa de comportamentos associados à aplicação prática e disciplinada do que foi decidido',
  RELACIONAR: 'menor presença relativa de comportamentos associados à cooperação e ao equilíbrio interpessoal',
  COORDENAR: 'menor presença relativa de comportamentos associados a integrar pessoas e objetivos',
  FINALIZAR: 'menor presença relativa de comportamentos associados à revisão final, ao acompanhamento de detalhes e à conclusão',
  ESPECIALIZAR: 'menor presença relativa de comportamentos associados ao aprofundamento técnico em um domínio'
};

/** Item 45 — a sombra coletiva é sempre o excesso de uma força coletiva. */
function construirSombraColetiva(
  eixos: { eixo: EixoAux; nome: string; media: number }[],
  cobertura: { capacidade: Capacidade; nome: string; valor: number }[],
  n: number
) {
  if (!n) return [];
  const e = Object.fromEntries(eixos.map(x => [x.eixo, x.media])) as Record<EixoAux, number>;
  const c = Object.fromEntries(cobertura.map(x => [x.capacidade, x.valor])) as Record<Capacidade, number>;
  const out: { titulo: string; potencia: string[]; sombra: string[] }[] = [];

  if (e.EST >= e.FLE + 8 && (c.ORGANIZAR >= 55 || c.EXECUTAR >= 55)) out.push({
    titulo: 'Alta estrutura somada a execução',
    potencia: ['organização', 'previsibilidade', 'entrega consistente'],
    sombra: ['menor abertura para experimentação', 'tendência a preservar processos já conhecidos', 'redução da exploração antes da ação']
  });
  if (e.FLE >= e.EST + 8 && c.EXPLORAR >= 55) out.push({
    titulo: 'Alta flexibilidade somada a exploração',
    potencia: ['adaptação rápida', 'geração de alternativas', 'leitura de oportunidade'],
    sombra: ['dificuldade de fechamento', 'excesso de frentes abertas ao mesmo tempo', 'sobrecarga de quem sustenta a execução']
  });
  if (e.COO >= e.AUT + 8 && c.RELACIONAR >= 55) out.push({
    titulo: 'Alta cooperação',
    potencia: ['coesão', 'integração de pessoas', 'baixo atrito interpessoal'],
    sombra: ['divergências que não chegam à mesa', 'decisões mais lentas em busca de consenso', 'desconforto individual absorvido em silêncio']
  });
  if (e.AUT >= e.COO + 8) out.push({
    titulo: 'Alta autonomia',
    potencia: ['iniciativa própria', 'baixa dependência de supervisão', 'profundidade individual'],
    sombra: ['esforços paralelos e pouco sincronizados', 'conhecimento que não circula', 'decisões tomadas sem base compartilhada']
  });
  if (c.ANALISAR >= 65 && c.DECIDIR < 55) out.push({
    titulo: 'Forte análise com menor mobilização',
    potencia: ['avaliação crítica', 'redução de risco', 'qualidade das premissas'],
    sombra: ['prolongamento da análise', 'decisões adiadas por informação sempre insuficiente', 'perda de janela de oportunidade']
  });
  return out.slice(0, 3);
}

function gerarRecomendacoes(lacunas: Capacidade[], complementaridade: number, hhi: number) {
  const r: { tipo: string; texto: string }[] = [];
  if (lacunas.length) {
    const nomes = lacunas.map(l => CAPACIDADES.find(c => c.id === l)!.nome.toLowerCase()).join(', ');
    r.push({ tipo: 'Desenvolvimento', texto: `Trabalhar deliberadamente as capacidades menos representadas (${nomes}) em ações de desenvolvimento, em vez de assumir que elas emergirão da dinâmica espontânea da equipe.` });
    r.push({ tipo: 'Processos', texto: 'Criar mecanismos que compensem as lacunas: rituais fixos que forcem a etapa ausente do ciclo de trabalho.' });
  }
  if (complementaridade < 70) r.push({ tipo: 'Duplas complementares', texto: 'Compor duplas entre pessoas com recursos diferentes nas etapas com menos portadores, de modo que a capacidade ausente seja exercida em par.' });
  if (hhi >= 0.30) {
    r.push({ tipo: 'Organização do trabalho', texto: 'Distribuir tarefas considerando os recursos existentes e evitar que a etapa em que a equipe é mais forte absorva também as etapas em que ela é mais fraca.' });
    r.push({ tipo: 'Rodízio de funções', texto: 'Quando adequado ao contexto, alternar quem conduz cada etapa do ciclo de trabalho, ampliando o repertório coletivo sem alterar a composição.' });
  }
  r.push({ tipo: 'Recrutamento', texto: 'Apenas como possibilidade estratégica, e nunca como conclusão automática desta análise: se as lacunas forem persistentes e críticas para o trabalho da área, elas podem informar critérios de composição futura. O instrumento não recomenda contratar, promover, transferir ou desligar ninguém.' });
  return r;
}

/** Item 50 — sugestões práticas condicionadas aos dados, sem prescrever cargos. */
function acoesParaLideranca(
  cobertura: { capacidade: Capacidade; nome: string; valor: number }[],
  eixos: { eixo: EixoAux; nome: string; media: number }[]
) {
  const c = Object.fromEntries(cobertura.map(x => [x.capacidade, x.valor])) as Record<Capacidade, number>;
  const e = Object.fromEntries(eixos.map(x => [x.eixo, x.media])) as Record<EixoAux, number>;
  const out: { titulo: string; itens: string[] }[] = [];

  if (c.EXPLORAR < 55) out.push({ titulo: 'Se a exploração está baixa', itens: ['incluir brainstorming estruturado no início dos ciclos', 'buscar benchmarking externo antes de fechar o escopo', 'convidar perspectivas de outras áreas para as discussões iniciais'] });
  if (c.CRIAR < 55) out.push({ titulo: 'Se a geração de alternativas está baixa', itens: ['exigir formalmente pelo menos três opções antes de decidir', 'separar a etapa de gerar ideias da etapa de avaliá-las', 'proteger tempo de trabalho individual silencioso, onde este recurso costuma aparecer'] });
  if (c.FINALIZAR < 55) out.push({ titulo: 'Se a finalização está baixa', itens: ['criar checklists de conclusão', 'definir um responsável nominal pelo fechamento de cada entrega', 'estabelecer critérios objetivos de "pronto" antes de iniciar'] });
  if (c.ANALISAR < 55) out.push({ titulo: 'Se a análise está baixa', itens: ['incluir uma etapa formal de revisão crítica antes das decisões relevantes', 'pedir explicitamente o contraponto em cada proposta', 'documentar as premissas assumidas'] });
  if (c.DECIDIR < 55) out.push({ titulo: 'Se a mobilização está baixa', itens: ['definir quem decide em cada tipo de questão', 'estabelecer prazo máximo para decisões reversíveis', 'separar decisões reversíveis de irreversíveis, com ritos diferentes'] });
  if (c.ORGANIZAR < 55 || c.EXECUTAR < 55) out.push({ titulo: 'Se organização ou execução estão baixas', itens: ['converter decisões em planos com responsável e data antes de encerrar a reunião', 'reduzir o número de frentes simultâneas', 'tornar visível o andamento das entregas'] });
  if (c.RELACIONAR < 55 || e.COO < 35) out.push({ titulo: 'Se a cooperação está baixa', itens: ['usar duplas em entregas relevantes', 'criar ritos regulares de alinhamento', 'estruturar espaços em que a divergência possa ser dita na reunião, e não no corredor'] });
  if (c.COORDENAR < 55) out.push({ titulo: 'Se a coordenação está baixa', itens: ['nomear responsável por integração em projetos com mais de uma frente', 'tornar explícitos papéis e interfaces', 'reservar tempo de agenda para sincronização entre frentes'] });
  if (c.ESPECIALIZAR < 55) out.push({ titulo: 'Se o aprofundamento técnico está baixo', itens: ['identificar os domínios críticos sem referência técnica interna', 'proteger tempo para estudo e documentação', 'evitar que o mesmo grupo seja sempre consultado sobre tudo'] });

  if (!out.length) out.push({ titulo: 'Nenhuma capacidade abaixo do limiar', itens: ['A configuração atual cobre as dez capacidades acima do limiar adotado. A prioridade tende a ser preservar essa cobertura em mudanças de composição, e não corrigi-la.'] });
  return out;
}

/** Item 48 — interpretação da leitura Belbin, não apenas barras. */
function leituraExecutivaBelbin(belbin: { nome: string; media: number; intensidade: Intensidade; dimensao: string }[], n: number): string[] {
  if (!n) return [];
  const ord = [...belbin].sort((a, b) => b.media - a.media);
  const altos = ord.slice(0, 2), baixos = ord.slice(-2).reverse();
  const tarefa = media(belbin.filter(b => b.dimensao === 'tarefa').map(b => b.media));
  const relac = media(belbin.filter(b => b.dimensao === 'relacionamento').map(b => b.media));

  const out = [
    `A equipe apresenta maior presença de recursos próximos aos papéis ${altos[0].nome} (${altos[0].media}) e ${altos[1].nome} (${altos[1].media}).`,
    `A menor presença relativa aparece em ${baixos[0].nome} (${baixos[0].media}) e ${baixos[1].nome} (${baixos[1].media}), o que pode indicar que as contribuições associadas a esses papéis dependem de um grupo menor de pessoas.`
  ];
  if (Math.abs(tarefa - relac) >= 6) {
    out.push(tarefa > relac
      ? `No agrupamento proposto por Belbin, os papéis da dimensão tarefa aparecem com média ${arred(tarefa)}, acima da dimensão relacionamento (${arred(relac)}). A configuração tende a favorecer a obtenção de resultados; o cuidado com o vínculo e a integração tende a exigir intenção deliberada.`
      : `Os papéis da dimensão relacionamento aparecem com média ${arred(relac)}, acima da dimensão tarefa (${arred(tarefa)}). A configuração tende a favorecer coesão e integração; o foco em resultado e no fechamento tende a exigir intenção deliberada.`);
  } else {
    out.push(`As dimensões tarefa (${arred(tarefa)}) e relacionamento (${arred(relac)}) aparecem equilibradas.`);
  }
  out.push('Esta leitura apresenta proximidades funcionais entre os comportamentos observados neste instrumento e contribuições descritas por Meredith Belbin. Não corresponde à aplicação do instrumento oficial de Belbin e não implica equivalência entre os modelos.');
  return out;
}

/* ── Comparação entre equipes (item 51) ──────────────────────────────────── */
export function compararSetores(porSetor: Record<string, MembroAgregado[]>) {
  return Object.entries(porSetor).map(([setor, membros]) => {
    const a = analisarEquipe(membros);
    return {
      setor, n: a.n, idf: a.idf, icf: a.icf,
      funcoes: Object.fromEntries(a.distribuicaoFuncoes.map(f => [f.funcao, f.media])) as Record<Funcao, number>,
      atitudes: Object.fromEntries(a.distribuicaoAtitudes.map(x => [x.atitude, x.media])) as Record<Atitude, number>,
      eixos: Object.fromEntries(a.distribuicaoEixos.map(x => [x.eixo, x.media])) as Record<EixoAux, number>,
      capacidades: Object.fromEntries(a.cobertura.map(c => [c.capacidade, c.valor])) as Record<Capacidade, number>,
      belbin: Object.fromEntries(a.belbinEquipe.map(b => [b.id, b.media])) as Record<PapelBelbin, number>,
      perfilTop: [...a.distribuicaoPerfis].sort((x, y) => y.n - x.n)[0],
      coberturaTopo: [...a.cobertura].sort((x, y) => y.valor - x.valor)[0]?.nome ?? '—',
      coberturaBase: [...a.cobertura].sort((x, y) => x.valor - y.valor)[0]?.nome ?? '—',
      amostraSuficiente: a.amostraSuficiente
    };
  }).sort((x, y) => x.setor.localeCompare(y.setor));
}

/* ── "Você na sua equipe" (itens 20 a 29) ────────────────────────────────── */
export interface ComparacaoIndividuo {
  disponivel: boolean;
  motivo?: string;
  nSetor: number;
  mesmoPerfil: { n: number; pct: number; posicao: number; total: number; muitoPresente: boolean; poucoPresente: boolean };
  mesmaFuncao: { n: number; pct: number; nome: string };
  atitudes: { E: number; I: number; minha: Atitude };
  contribuicao: string;
  nota: string;
}

export function compararComEquipe(
  meu: VetorParticipante, equipe: MembroAgregado[]
): ComparacaoIndividuo {
  const n = equipe.length;
  const vazio = {
    nSetor: n,
    mesmoPerfil: { n: 0, pct: 0, posicao: 0, total: 0, muitoPresente: false, poucoPresente: false },
    mesmaFuncao: { n: 0, pct: 0, nome: NOME_FUNCAO[meu.funcaoDominante] },
    atitudes: { E: 0, I: 0, minha: meu.atitude },
    contribuicao: '', nota: ''
  };
  if (n < MIN_PARTICIPANTES_INTERPRETACAO) {
    return {
      ...vazio, disponivel: false,
      motivo: 'Ainda não existem respostas suficientes para apresentar uma comparação coletiva preservando a confidencialidade.'
    };
  }

  const cont = Object.fromEntries(PERFIS.map(p => [p.id, 0])) as Record<PerfilId, number>;
  for (const m of equipe) cont[m.perfil]++;
  const ranking = PERFIS.map(p => ({ id: p.id, n: cont[p.id] })).sort((a, b) => b.n - a.n);
  const posicao = ranking.findIndex(r => r.id === meu.perfil) + 1;
  const presentes = ranking.filter(r => r.n > 0).length;
  const nMeu = cont[meu.perfil];
  const pctMeu = arred((nMeu / n) * 100);

  const nFuncao = equipe.filter(m => m.funcaoDominante === meu.funcaoDominante).length;
  const nE = equipe.filter(m => m.atitude === 'E').length;

  const a = analisarEquipe(equipe);
  const minhasFortes = CAPACIDADES
    .map(c => ({ id: c.id, nome: c.nome, meu: meu.capacidades[c.id], equipe: a.cobertura.find(x => x.capacidade === c.id)!.valor }))
    .sort((x, y) => (y.meu - y.equipe) - (x.meu - x.equipe));
  const destaque = minhasFortes[0];

  const muitoPresente = pctMeu >= 35;
  const poucoPresente = pctMeu <= 12;

  const contribuicao =
    destaque.meu >= LIMIAR_PORTADOR && destaque.equipe < 60
      ? `Sua equipe apresenta cobertura ${a.cobertura.find(c => c.capacidade === destaque.id)!.nivel} de ${destaque.nome.toLowerCase()} (${destaque.equipe}%), e seus resultados mostram presença relativa alta nessa mesma capacidade (${destaque.meu}). Esse recurso pode oferecer uma perspectiva menos frequente no grupo, principalmente em situações que a exijam.`
      : `Seus escores mais altos aparecem em capacidades que a equipe já cobre bem. Isso tende a produzir fluidez e linguagem comum; o ponto de atenção é garantir que as capacidades menos cobertas do grupo (${a.lacunas.map(l => l.nome.toLowerCase()).join(', ')}) também encontrem espaço.`;

  const nota = muitoPresente
    ? 'Esse modo de funcionamento é bastante presente na equipe. Isso pode produzir fluidez e alinhamento em situações compatíveis com suas características, mas merece atenção para que outras perspectivas também tenham espaço.'
    : poucoPresente
      ? 'Esse padrão aparece com menor frequência relativa na equipe e pode oferecer perspectivas complementares em determinadas situações.'
      : 'Esse padrão aparece na equipe em proporção intermediária.';

  return {
    disponivel: true, nSetor: n,
    mesmoPerfil: { n: nMeu, pct: pctMeu, posicao, total: presentes, muitoPresente, poucoPresente },
    mesmaFuncao: { n: nFuncao, pct: arred((nFuncao / n) * 100), nome: NOME_FUNCAO[meu.funcaoDominante] },
    atitudes: { E: nE, I: n - nE, minha: meu.atitude },
    contribuicao, nota
  };
}

export { CAPACIDADES, PAPEIS_BELBIN, PARES_EIXO };
