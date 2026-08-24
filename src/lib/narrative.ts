/**
 * NÍVEL 2 — INTERPRETAÇÃO EM LINGUAGEM NATURAL (determinística, sem IA)
 * ---------------------------------------------------------------------------
 * Recebe o resultado JÁ CALCULADO e o converte em texto. Os mesmos escores
 * produzem sempre o mesmo texto. A IA (item 7) pode reescrever, mas nunca
 * alterar perfil, animal, função, atitude, proximidade Belbin, IDF ou ICF.
 *
 * Cuidados obrigatórios de redação:
 *  - escores são "escores relativos internos", nunca percentis (item 12);
 *  - nunca "você é uma Baleia"; sempre "maior correspondência com" (item 9);
 *  - recursos menos usados nunca são chamados de fraquezas;
 *  - sombra é sempre o excesso de uma força, nunca defeito moral (item 14).
 */
import { PERFIL_POR_ID, NOME_FUNCAO, NOME_ATITUDE } from '../data/profiles';
import { NOME_EIXO } from '../data/questions';
import { CAPACIDADES, PAPEIS_BELBIN } from '../data/functional';
import { CONTEUDO_CAPACIDADE, CONTEUDO_BELBIN, DIMENSOES_FUNCIONAMENTO } from '../data/functionalContent';
import type { ResultadoIndividual } from './scoring';

export const AVISO_ANIMAL =
  'Dentro do modelo simbólico utilizado neste instrumento, seu padrão predominante apresenta maior correspondência com este animal. A metáfora não descreve a pessoa por inteiro e não constitui diagnóstico psicológico.';

export const AVISO_ESCORES =
  'Os valores são escores relativos internos do instrumento: indicam a participação de cada polo no conjunto das suas próprias respostas. Não são percentis populacionais e não comparam você a nenhuma norma.';

export const AVISO_BELBIN =
  'Esta seção apresenta proximidades funcionais entre os comportamentos observados neste instrumento e contribuições descritas por Meredith Belbin. Não corresponde à aplicação do instrumento oficial de Belbin e não implica equivalência entre os modelos.';

export const AVISO_GERAL =
  'Este instrumento representa tendências de autorrelato e possui finalidade de desenvolvimento organizacional. Não constitui diagnóstico psicológico, avaliação clínica ou instrumento psicométrico validado.';

const alto = (v: number) => v >= 45;
const baixo = (v: number) => v < 25;

/** Item 10 — interação entre a tendência predominante e a secundária. */
export function interacaoPerfis(r: ResultadoIndividual): string {
  const p = PERFIL_POR_ID[r.perfilPrincipal], s = PERFIL_POR_ID[r.perfilSecundario];
  return `A tendência predominante (${p.nomeJung}) indica o recurso que você aciona primeiro e com mais destreza. ` +
    `A secundária (${s.nomeJung}) descreve o recurso de apoio, que Jung chama de função auxiliar: ela vem do outro par de opostos e ` +
    `equilibra a dominante — ${NOME_FUNCAO[r.funcaoAuxiliar]} complementa ${NOME_FUNCAO[r.funcaoDominante]} em vez de competir com ela. ` +
    `Na prática, as duas costumam operar juntas: a dominante define o modo de entrada em uma situação e a auxiliar oferece a segunda leitura. ` +
    `Nenhuma pessoa pertence rigidamente a uma única categoria — o que o instrumento descreve são tendências, não fronteiras.`;
}

/** Item 11 — as dez leituras, construídas a partir dos escores reais. */
export function comoVoceFunciona(r: ResultadoIndividual): { titulo: string; texto: string }[] {
  const j = r.escores.relativo, e = r.escores.eixos.relativo, c = r.funcional.capacidades;
  const dom = NOME_FUNCAO[r.funcaoDominante], aux = NOME_FUNCAO[r.funcaoAuxiliar];
  const introv = r.atitude === 'I';
  const t: Record<string, string> = {};

  t.perceber = j.S >= j.N
    ? `Sua atenção tende a se fixar primeiro no que está concretamente presente: fatos, detalhes e evidências verificáveis (Sensação ${j.S}, contra Intuição ${j.N}). ` +
      `Você costuma partir do que já é observável antes de considerar o que ainda é hipótese.`
    : `Sua atenção tende a captar primeiro possibilidades, conexões e desdobramentos ainda não evidentes (Intuição ${j.N}, contra Sensação ${j.S}). ` +
      `Você costuma perceber para onde a situação está indo antes de esgotar o levantamento do que já existe.`;

  t.decidir = j.T >= j.F
    ? `Ao decidir, o peso maior tende a recair sobre a consistência: critérios, causalidade e coerência (Pensamento ${j.T}, contra Sentimento ${j.F}). ` +
      `O critério tende a vir antes do consenso.`
    : `Ao decidir, o peso maior tende a recair sobre o valor envolvido: o que é adequado e sustentável para as pessoas afetadas (Sentimento ${j.F}, contra Pensamento ${j.T}). ` +
      `Vale lembrar que, em Jung, sentimento designa um modo de julgar por valor — não emocionalidade.`;

  t.informacao = e.EXP >= e.EXE
    ? `Diante de informação nova, sua tendência é explorar: buscar mais, testar por onde aquilo leva, comparar com o que existe fora (Exploração ${e.EXP}).`
    : `Diante de informação nova, sua tendência é aplicar: verificar o que muda na prática e incorporar ao trabalho (Execução ${e.EXE}).`;

  t.problemas = `Sua entrada mais frequente em um problema combina ${dom.toLowerCase()} com ${aux.toLowerCase()}. ` +
    (alto(c.ANALISAR) ? `A capacidade Analisar aparece alta (${c.ANALISAR}), o que sugere avaliação cuidadosa antes de agir. `
      : alto(c.EXECUTAR) ? `A capacidade Executar aparece alta (${c.EXECUTAR}), o que sugere avanço concreto desde cedo. `
      : alto(c.CRIAR) ? `A capacidade Criar aparece alta (${c.CRIAR}), o que sugere tendência a reenquadrar o problema antes de resolvê-lo. ` : '') +
    (alto(c.DECIDIR) ? `Há também disposição relevante para mobilizar e destravar (Decidir ${c.DECIDIR}).` : `A mobilização aparece em nível ${c.DECIDIR >= 30 ? 'intermediário' : 'mais discreto'} (Decidir ${c.DECIDIR}).`);

  t.mudancas = e.FLE >= e.EST
    ? `Diante de mudanças, sua tendência é adaptar-se em movimento, ajustando o caminho conforme a situação se revela (Flexibilidade ${e.FLE}, contra Estrutura ${e.EST}).`
    : `Diante de mudanças, sua tendência é buscar previsibilidade: entender o motivo, ver o novo procedimento e reorganizar antes de avançar (Estrutura ${e.EST}, contra Flexibilidade ${e.FLE}).`;

  t.comunicar = introv
    ? `Sua comunicação tende a ser mais elaborada antes de expressa: você costuma formar a posição internamente e trazê-la depois (Introversão ${j.I}). ` +
      (alto(c.RELACIONAR) ? `Ainda assim, a capacidade Relacionar aparece alta (${c.RELACIONAR}), o que sugere presença atenta às pessoas mesmo com pouca fala.` : `Em ambientes de fala disputada, sua contribuição pode ficar menos visível do que é.`)
    : `Sua comunicação tende a acontecer em voz alta e em movimento: você costuma pensar falando e ajustar conforme os outros reagem (Extroversão ${j.E}). ` +
      (alto(c.COORDENAR) ? `A capacidade Coordenar aparece alta (${c.COORDENAR}), o que sugere facilidade em fazer o grupo convergir.` : ``);

  t.grupo = e.COO >= e.AUT
    ? `Em grupo, sua tendência é construir junto: consultar, negociar e integrar antes de avançar (Cooperação ${e.COO}, contra Autonomia ${e.AUT}).`
    : `Em grupo, sua tendência é assumir a própria parte com independência e sincronizar depois (Autonomia ${e.AUT}, contra Cooperação ${e.COO}).`;

  t.pressao = `Sob pressão, o recurso que você mais aciona tende a ser ${r.capacidadesOrdenadas[0].nome.toLowerCase()} (${r.capacidadesOrdenadas[0].valor}). ` +
    `Jung observa que, sob tensão, a função menos desenvolvida — no seu caso ${NOME_FUNCAO[r.funcaoInferior]} — pode irromper de forma desproporcional e surpreender quem só conhece seu lado habitual. ` +
    `Isso não é um defeito: é a expressão menos treinada do mesmo funcionamento.`;

  t.organizar = alto(c.ORGANIZAR) || alto(c.FINALIZAR)
    ? `Na organização e na execução, seus escores são consistentes (Organizar ${c.ORGANIZAR}, Executar ${c.EXECUTAR}, Finalizar ${c.FINALIZAR}): há tendência a estruturar e levar até o fim.`
    : `Organizar (${c.ORGANIZAR}), Executar (${c.EXECUTAR}) e Finalizar (${c.FINALIZAR}) aparecem em nível mais discreto nas suas respostas. Isso sugere que a estruturação e o fechamento tendem a exigir esforço deliberado — ou apoio de recursos complementares — em vez de surgirem espontaneamente.`;

  t.conflitos = alto(c.RELACIONAR)
    ? `Em conflitos, sua tendência é preservar o vínculo enquanto o assunto é tratado (Relacionar ${c.RELACIONAR}).`
    : alto(c.DECIDIR)
      ? `Em conflitos, sua tendência é enfrentar diretamente e buscar resolução rápida (Decidir ${c.DECIDIR}).`
      : alto(c.ANALISAR)
        ? `Em conflitos, sua tendência é primeiro entender a origem e separar o que é divergência de critério do que é ruído (Analisar ${c.ANALISAR}).`
        : `Em conflitos, seus escores não indicam uma estratégia dominante: Relacionar ${c.RELACIONAR}, Analisar ${c.ANALISAR}, Decidir ${c.DECIDIR}. Isso sugere resposta variável conforme a situação.`;

  return DIMENSOES_FUNCIONAMENTO.map(d => ({ titulo: d.titulo, texto: t[d.id] }));
}

/** Item 13 — luz: 4 a 6 manifestações, cada uma ligada a um resultado real. */
export function luz(r: ResultadoIndividual): { titulo: string; texto: string; evidencia: string }[] {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const out: { titulo: string; texto: string; evidencia: string }[] = [];

  for (const c of r.capacidadesOrdenadas.slice(0, 3)) {
    const k = CONTEUDO_CAPACIDADE[c.id];
    out.push({
      titulo: c.nome,
      texto: `${k.significado} ${k.noTrabalho}`,
      evidencia: `Escore relativo ${c.valor} (${c.intensidade.toLowerCase()}) — ${c.id === r.capacidadesOrdenadas[0].id ? 'sua capacidade mais presente' : 'entre as suas três mais presentes'}.`
    });
  }
  out.push({
    titulo: p.potencias[0],
    texto: p.luz.split('. ').slice(0, 2).join('. ') + '.',
    evidencia: `Decorre da configuração ${p.nomeJung} (${NOME_FUNCAO[r.funcaoDominante]} ${r.escores.relativo[r.funcaoDominante]}, ${NOME_ATITUDE[r.atitude]} ${r.escores.relativo[r.atitude]}).`
  });
  const eixoForte = [...r.eixosAuxiliares].sort((a, b) => Math.max(b.a, b.b) - Math.max(a.a, a.b))[0];
  if (eixoForte.polo !== 'equilibrado') {
    out.push({
      titulo: NOME_EIXO[eixoForte.polo as keyof typeof NOME_EIXO],
      texto: `Este eixo comportamental aparece de forma marcada nas suas respostas e tende a caracterizar como você entra nas situações de trabalho.`,
      evidencia: `${NOME_EIXO[eixoForte.par[0]]} ${eixoForte.a} contra ${NOME_EIXO[eixoForte.par[1]]} ${eixoForte.b}.`
    });
  }
  const bel = r.top3Belbin[0];
  out.push({
    titulo: `Proximidade com ${bel.nome}`,
    texto: CONTEUDO_BELBIN[bel.id].contribuicao,
    evidencia: `Maior proximidade funcional identificada nas suas respostas (${bel.valor}, ${bel.intensidade.toLowerCase()}).`
  });
  return out.slice(0, 6);
}

/** Item 14 — sombra: sempre o excesso da própria força. */
export function sombra(r: ResultadoIndividual) {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const doPerfil = p.luzSombra.map(x => ({
    forca: x.forca, equilibrio: x.equilibrada, excesso: x.excessiva,
    origem: `configuração ${p.nomeJung}`
  }));
  const doFuncional = r.capacidadesOrdenadas.slice(0, 2).map(c => ({
    forca: c.nome,
    equilibrio: CONTEUDO_CAPACIDADE[c.id].quandoUtil,
    excesso: excessoDaCapacidade(c.id),
    origem: `escore relativo ${c.valor} nesta capacidade`
  }));
  return [...doFuncional, ...doPerfil].slice(0, 6);
}

const EXCESSO_CAPACIDADE: Record<string, string> = {
  CRIAR: 'Geração contínua de alternativas que não encontram fechamento; dispersão e dificuldade de convergir.',
  EXPLORAR: 'Muitas frentes abertas e poucas concluídas; o custo de sustentar o que foi iniciado recai sobre outras pessoas.',
  ANALISAR: 'A análise prolonga-se além do necessário e a decisão é adiada por informação sempre considerada insuficiente.',
  DECIDIR: 'Decisão antes de compreensão suficiente; atropelamento de análises e de pessoas.',
  ORGANIZAR: 'Estrutura que passa a valer por si mesma; rigidez diante de exceções legítimas.',
  EXECUTAR: 'Ação que se antecipa ao diagnóstico; retrabalho por velocidade e pouca documentação do que se descobriu.',
  RELACIONAR: 'Divergências que não chegam à mesa; desconforto absorvido em silêncio até virar ruptura.',
  COORDENAR: 'Articulação que substitui a entrega; excesso de alinhamento e pouca decisão.',
  FINALIZAR: 'Perfeccionismo e dificuldade de dar por concluído; relutância em delegar a revisão.',
  ESPECIALIZAR: 'Aprofundamento em uma faixa estreita; menor flexibilidade quando o próprio domínio é questionado.'
};
const excessoDaCapacidade = (id: string) => EXCESSO_CAPACIDADE[id] ?? '';

/** Itens 16 a 19 — leitura detalhada das três maiores proximidades Belbin. */
export function belbinDetalhado(r: ResultadoIndividual) {
  return r.top3Belbin.map(b => {
    const k = CONTEUDO_BELBIN[b.id];
    const meta = PAPEIS_BELBIN.find(p => p.id === b.id)!;
    return {
      id: b.id, nome: b.nome, valor: b.valor, intensidade: b.intensidade, posicao: b.posicao,
      dimensao: meta.dimensao,
      contribuicao: k.contribuicao,
      comoAparece: k.comoAparece,
      ondeAgrega: k.ondeAgrega,
      excesso: k.excesso,
      complementaridade: k.complementaridade
    };
  });
}

/** Item 15 — contribuição funcional individual, com significado e uso. */
export function contribuicaoFuncional(r: ResultadoIndividual) {
  return r.capacidadesOrdenadas.slice(0, 4).map((c, i) => ({
    posicao: i + 1, id: c.id, nome: c.nome, valor: c.valor, intensidade: c.intensidade,
    ...CONTEUDO_CAPACIDADE[c.id]
  }));
}

/** Recursos menos espontâneos — nunca chamados de fraquezas. */
export function menosEspontaneos(r: ResultadoIndividual) {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  return {
    capacidades: r.capacidadesOrdenadas.slice(-3).reverse().map(c => ({
      nome: c.nome, valor: c.valor,
      texto: `${CONTEUDO_CAPACIDADE[c.id].significado} Aparece com escore relativo ${c.valor} nas suas respostas, o que sugere que tende a exigir esforço deliberado em vez de surgir espontaneamente.`
    })),
    doPerfil: p.menosEspontaneos,
    complementaridade: p.complementaridade
  };
}

/** Cabeçalho do resultado individual (item 9). */
export function cabecalho(r: ResultadoIndividual, dados: { nome: string; setor: string; data: string }) {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  return {
    ...dados,
    versao: r.versao,
    configuracao: p.nomeJung,
    animal: p.animal,
    cor: p.cor,
    sintese: p.sintese,
    aviso: AVISO_ANIMAL
  };
}

/* ═══════════════ LEITURA EXECUTIVA INDIVIDUAL — LIDERANÇA (item 31) ═══════ */

export function leituraExecutivaIndividual(r: ResultadoIndividual) {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const f = comoVoceFunciona(r);
  const get = (i: number) => f[i].texto;
  const top = r.capacidadesOrdenadas;
  const bel = belbinDetalhado(r);

  const aproveitar = top.filter(c => c.valor >= 45).slice(0, 4)
    .map(c => `${CONTEUDO_CAPACIDADE[c.id].aproveitar} (escore ${c.valor})`);

  return {
    configuracao: `${p.nomeJung} — correspondência simbólica: ${p.animal}. Tendência secundária: ${PERFIL_POR_ID[r.perfilSecundario].nomeJung}.`,
    contribuicaoPrincipal: `${top[0].nome} (${top[0].valor}, ${top[0].intensidade.toLowerCase()}) — ${CONTEUDO_CAPACIDADE[top[0].id].significado}`,
    segundaContribuicao: `${top[1].nome} (${top[1].valor}, ${top[1].intensidade.toLowerCase()}) — ${CONTEUDO_CAPACIDADE[top[1].id].significado}`,
    recursosMenosEspontaneos: top.slice(-3).reverse().map(c => `${c.nome} (${c.valor})`),
    comoDecide: get(1),
    comoComunica: get(5),
    sobPressao: get(7),
    tiposDeProblema: bel[0].ondeAgrega,
    quandoValioso: `Especialmente quando o trabalho exige ${CONTEUDO_CAPACIDADE[top[0].id].quandoUtil.toLowerCase()}`,
    pontosCegos: [
      excessoDaCapacidade(top[0].id),
      bel[0].excesso,
      `A função menos desenvolvida (${NOME_FUNCAO[r.funcaoInferior]}) tende a aparecer sob pressão de forma desproporcional.`
    ],
    recursosComplementares: `${bel[0].complementaridade} ${p.complementaridade}`,
    desenvolvimento: p.menosEspontaneos,
    aproveitar: aproveitar.length ? aproveitar : ['Nenhuma capacidade atingiu o limiar que sustentaria uma sugestão específica de aproveitamento. Evite atribuições baseadas apenas neste instrumento.'],
    limite: 'Esta leitura serve a desenvolvimento, composição de projetos e distribuição consciente de responsabilidades. Não deve ser usada para promover, transferir, selecionar, reprovar, afastar, contratar ou desligar.'
  };
}

/* ═══════════════ BLOCO 4 — SUAS POTÊNCIAS (item 26) ══════════════════════ */
/**
 * APRESENTAÇÃO, NÃO CÁLCULO.
 *
 * Reúne, em uma leitura curta, o que os escores JÁ CALCULADOS sustentam: as
 * capacidades mais presentes, a função dominante, o eixo mais marcado e a maior
 * proximidade funcional. Nenhum número é recalculado, nenhuma classificação
 * nova é criada — cada linha carrega o escore que a origina, para que o leitor
 * possa conferir.
 */
export function potenciasIndividuais(r: ResultadoIndividual): { titulo: string; texto: string; escore: string }[] {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const out: { titulo: string; texto: string; escore: string }[] = [];

  for (const c of r.capacidadesOrdenadas.slice(0, 3)) {
    out.push({
      titulo: c.nome,
      texto: CONTEUDO_CAPACIDADE[c.id].quandoUtil,
      escore: `escore relativo ${c.valor} · ${c.intensidade.toLowerCase()}`
    });
  }

  out.push({
    titulo: NOME_FUNCAO[r.funcaoDominante],
    texto: `É a função mais presente nas suas respostas e organiza a forma como você entra nos problemas. ${p.estrutura.percebe}`,
    escore: `${NOME_FUNCAO[r.funcaoDominante]} ${r.escores.relativo[r.funcaoDominante]} · ${NOME_ATITUDE[r.atitude]} ${r.escores.relativo[r.atitude]}`
  });

  const eixo = [...r.eixosAuxiliares].sort((a, b) => Math.max(b.a, b.b) - Math.max(a.a, a.b))[0];
  if (eixo.polo !== 'equilibrado') {
    out.push({
      titulo: NOME_EIXO[eixo.polo as keyof typeof NOME_EIXO],
      texto: 'É o eixo comportamental mais marcado nas suas respostas e tende a caracterizar como você entra nas situações de trabalho.',
      escore: `${NOME_EIXO[eixo.par[0]]} ${eixo.a} · ${NOME_EIXO[eixo.par[1]]} ${eixo.b}`
    });
  }

  const b = r.top3Belbin[0];
  out.push({
    titulo: `Proximidade com ${b.nome}`,
    texto: CONTEUDO_BELBIN[b.id].contribuicao,
    escore: `proximidade ${b.valor} · ${b.intensidade.toLowerCase()}`
  });

  return out;
}

/* ═══════ ITEM 31 — O QUE SUA PRESENÇA ACRESCENTA À CONFIGURAÇÃO ═════════ */
/**
 * Usa exclusivamente dados já calculados: a distribuição de perfis da equipe,
 * a posição relativa do participante e os próprios escores dele. Não cria
 * classificação nova nem atribui valor a estar em maioria ou em minoria.
 */
export function presencaNaConfiguracao(
  r: ResultadoIndividual,
  c: { nSetor: number; mesmoPerfil: { n: number; pct: number; posicao: number; total: number; muitoPresente: boolean; poucoPresente: boolean } }
): { titulo: string; texto: string }[] {
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const top = r.capacidadesOrdenadas;
  const out: { titulo: string; texto: string }[] = [];

  out.push({
    titulo: 'A leitura que você traz',
    texto: `Sua configuração predominante é ${p.nomeJung}. ${p.estrutura.percebe} ` +
      `Em uma equipe de ${c.nSetor} respondente(s), esse é o ${c.mesmoPerfil.posicao}º padrão mais representado, ` +
      `com ${c.mesmoPerfil.n} pessoa(s) — ${c.mesmoPerfil.pct}% dos respondentes.`
  });

  out.push({
    titulo: c.mesmoPerfil.poucoPresente ? 'Um recurso pouco frequente por aqui' : 'Um recurso compartilhado por aqui',
    texto: c.mesmoPerfil.poucoPresente
      ? `Poucas pessoas da equipe partem do mesmo lugar que você. Na prática, isso costuma significar que a sua ` +
        `leitura de um problema chega antes por um caminho que os demais percorrem depois — e que ela precisa de ` +
        `espaço explícito para ser ouvida, porque não será repetida por muitos.`
      : `Boa parte da equipe parte de um lugar parecido com o seu. Isso costuma facilitar acordo e linguagem comum, ` +
        `e ao mesmo tempo torna mais fácil que uma mesma leitura se confirme sem ser testada. Vale perguntar, ` +
        `nas decisões importantes, quem na equipe enxergaria isso de outro modo.`
  });

  out.push({
    titulo: 'O que você tende a colocar na mesa',
    texto: `Suas três capacidades mais presentes são ${top[0].nome.toLowerCase()} (${top[0].valor}), ` +
      `${top[1].nome.toLowerCase()} (${top[1].valor}) e ${top[2].nome.toLowerCase()} (${top[2].valor}). ` +
      `${CONTEUDO_CAPACIDADE[top[0].id].noTrabalho}`
  });

  out.push({
    titulo: 'Onde você tende a precisar dos outros',
    texto: `As capacidades menos espontâneas nas suas respostas são ` +
      `${top.slice(-2).map(x => `${x.nome.toLowerCase()} (${x.valor})`).join(' e ')}. ` +
      `Não são fraquezas: são recursos que exigem esforço deliberado e que outras pessoas da equipe ` +
      `provavelmente oferecem com menos custo. ${p.complementaridade}`
  });

  return out;
}

/* ═══════════ INTERPRETAÇÃO VISÍVEL DOS ÍNDICES COLETIVOS ═════════════════ */
/**
 * Traduzem um número já calculado em uma frase. Não recalculam nada, não
 * comparam com norma nenhuma — porque norma não existe — e evitam
 * deliberadamente adjetivo de valor: dizem o que o número indica sobre a
 * CONFIGURAÇÃO, não se a equipe é boa.
 */
export function leituraIDF(a: any): string {
  if (!a.n) return 'Sem respondentes suficientes para calcular.';
  const c = a.idfComponentes;
  const dominante =
    c.dispersaoVetorial >= c.perfis && c.dispersaoVetorial >= c.funcoes
      ? 'a variedade vem sobretudo da dispersão dos escores individuais, não apenas de rótulos diferentes'
      : c.perfis >= c.funcoes
        ? 'a variedade vem sobretudo da distribuição entre os perfis'
        : 'a variedade vem sobretudo da distribuição entre as funções';

  if (a.idfFaixa === 'alta')
    return `Variedade ampla de perspectivas: ${dominante}. Tende a produzir leituras diferentes para o mesmo problema — o que ajuda na análise e exige mais tempo para chegar a acordo.`;
  if (a.idfFaixa === 'moderada')
    return `Variedade intermediária: ${dominante}. Há diferença suficiente para gerar debate, sem a dispersão que costuma dificultar convergência.`;
  return `Variedade estreita: ${dominante}. A equipe tende a enxergar os problemas de modo parecido — o que acelera acordo e reduz a chance de uma leitura ser confrontada.`;
}

export function leituraICF(a: any): string {
  if (!a.n) return 'Sem respondentes suficientes para calcular.';
  const semPortador = a.cobertura.filter((c: any) => c.portadores === 0).length;
  const fracas = a.cobertura.filter((c: any) => c.valor < 45).length;

  if (semPortador > 0)
    return `${semPortador} das dez capacidades não têm nenhum portador acima do limiar. Nessas frentes o recurso não está presente no grupo atual — precisa vir de fora ou ser construído.`;
  if (a.icfFaixa === 'alta')
    return 'Todas as capacidades têm portadores e a cobertura média é alta: a equipe dispõe internamente dos recursos que o ciclo de trabalho exige.';
  if (a.icfFaixa === 'moderada')
    return `Todas as capacidades têm ao menos um portador, mas ${fracas} ainda aparece(m) com cobertura baixa — recurso presente, porém concentrado em poucas pessoas.`;
  return 'Os recursos existem, mas de forma rarefeita: a maioria das capacidades depende de poucas pessoas. Concentração desse tipo costuma aparecer como gargalo em período de pressão.';
}

/* ═══════════════ RESUMO EXECUTIVO DA EQUIPE (itens 42 e 43) ═══════════════ */

export function blocosLeituraExecutiva(nome: string, a: any): { titulo: string; texto: string; itens?: string[] }[] {
  if (!a.n) return [{ titulo: 'Sem dados', texto: `Ainda não há respondentes em ${nome}.` }];
  const fn = [...a.distribuicaoFuncoes].sort((x: any, y: any) => y.media - x.media);
  const eix = [...a.distribuicaoEixos].sort((x: any, y: any) => y.media - x.media);
  const cob = [...a.cobertura].sort((x: any, y: any) => y.valor - x.valor);
  const at = [...a.distribuicaoAtitudes].sort((x: any, y: any) => y.pct - x.pct);

  return [
    {
      titulo: '1. Quem somos',
      texto: `${nome} reúne ${a.n} respondente(s) com avaliação concluída, distribuídos em ${a.concentracao.perfisPresentes} dos 8 perfis. ` +
        `A diversidade de perspectivas é ${a.idfFaixa} (IDF ${a.idf}) e a cobertura funcional é ${a.icfFaixa} (ICF ${a.icf}). ` +
        `Na forma de perceber e decidir, ${fn[0].nome} aparece com a maior média (${fn[0].media}) e ${fn[3].nome} com a menor (${fn[3].media}). ` +
        `A atenção do grupo tende mais a ${at[0].nome} (${at[0].pct}% dos participantes). ` +
        `Nos eixos comportamentais, ${eix[0].nome} é o mais presente (${eix[0].media}) e ${eix[5].nome} o menos (${eix[5].media}).`
    },
    {
      titulo: '2. Onde somos fortes',
      texto: `As capacidades com melhor cobertura são ${cob[0].nome.toLowerCase()} (${cob[0].valor}%), ${cob[1].nome.toLowerCase()} (${cob[1].valor}%) e ${cob[2].nome.toLowerCase()} (${cob[2].valor}%).`,
      itens: a.potencias.map((p: any) => `${p.titulo} — ${p.evidencia}`)
    },
    {
      titulo: '3. Onde estamos concentrados',
      texto: a.concentracao.hhi >= 0.30
        ? `O perfil ${a.distribuicaoPerfis.find((p: any) => p.perfil === a.concentracao.maiorPerfil)?.animal} concentra ${a.concentracao.maiorPerfilPct}% da equipe (índice de concentração ${a.concentracao.hhi}). Isso pode produzir alinhamento e linguagem comum, e ao mesmo tempo reduzir a variedade de leituras disponíveis para um mesmo problema.`
        : `Não há concentração acentuada de perfis (índice de concentração ${a.concentracao.hhi}); o maior grupo representa ${a.concentracao.maiorPerfilPct}% da equipe.`,
      itens: a.sombraColetiva.map((s: any) => `${s.titulo}: potência em ${s.potencia.join(', ')}; possível sombra coletiva em ${s.sombra.join(', ')}.`)
    },
    {
      titulo: '4. O que aparece pouco',
      texto: `As capacidades com menor cobertura são ${cob[cob.length - 1].nome.toLowerCase()} (${cob[cob.length - 1].valor}%) e ${cob[cob.length - 2].nome.toLowerCase()} (${cob[cob.length - 2].valor}%).`,
      itens: a.lacunas.map((l: any) => `${l.nome} (${l.valor}%): ${l.interpretacao}`)
    },
    {
      titulo: '5. Onde existe complementaridade',
      texto: `${a.complementaridade.capacidadesCobertas} das ${a.complementaridade.total} capacidades têm ao menos um portador ` +
        `acima do limiar (${a.complementaridade.pct}%). Onde uma capacidade está pouco presente na média, mas tem portadores ` +
        `identificados, a equipe já dispõe do recurso — ele só está concentrado em poucas pessoas, e depende de que o ` +
        `trabalho seja organizado de modo a alcançá-lo.`,
      itens: complementaridadeDisponivel(a)
    }
  ];
}

/**
 * Item 47 — "onde existe complementaridade".
 * Cruza cobertura e portadores, dois números que a análise JÁ produz: capacidade
 * com média baixa mas portadores presentes é complementaridade disponível;
 * capacidade sem portador nenhum é ausência real de recurso na equipe.
 */
function complementaridadeDisponivel(a: any): string[] {
  const out: string[] = [];
  const disponiveis = a.cobertura.filter((c: any) => c.portadores > 0 && c.valor < 70)
    .sort((x: any, y: any) => y.portadores - x.portadores).slice(0, 4);
  for (const c of disponiveis) {
    out.push(`${c.nome} (cobertura ${c.valor}%): ${c.portadores} pessoa(s) acima do limiar. ` +
      `O recurso existe na equipe e está concentrado — vale envolvê-las explicitamente nas situações que o exigem.`);
  }
  const semPortador = a.cobertura.filter((c: any) => c.portadores === 0);
  for (const c of semPortador) {
    out.push(`${c.nome} (cobertura ${c.valor}%): nenhum respondente acima do limiar. ` +
      `Aqui a complementaridade precisa vir de fora do grupo atual, ou ser construída ao longo do tempo.`);
  }
  if (!out.length) out.push('Todas as capacidades têm portadores e cobertura alta: a complementaridade já está distribuída pela equipe.');
  return out;
}

/**
 * Item 48 — COMO LIDERAR ESTA CONFIGURAÇÃO.
 * Recomendações de desenvolvimento e de organização do trabalho, condicionadas
 * aos dados. Nunca decisão de emprego (item 41).
 */
export function comoLiderarConfiguracao(a: any): { titulo: string; itens: string[] }[] {
  if (!a.n) return [];
  return a.acoesLideranca.map((x: any) => ({ titulo: x.titulo, itens: x.itens }));
}

export { CAPACIDADES, PAPEIS_BELBIN, CONTEUDO_CAPACIDADE, CONTEUDO_BELBIN };
