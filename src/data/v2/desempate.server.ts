import 'server-only';
/**
 * REAVALIAÇÃO v2.0 — ITENS DE DESEMPATE (CAMADA DE SERVIDOR)
 * ===========================================================================
 * ⚠ NUNCA pode chegar ao navegador: o par em disputa é a informação que o
 * adendo manda esconder do participante.
 *
 * O servidor escolhe o item pelo par, envia ao cliente APENAS o enunciado e os
 * dois textos (em ordem sorteada), recebe de volta a alternativa escolhida e
 * resolve o par aqui dentro.
 *
 * Fonte oficial: ROTA26adendodesempateCONFIDENCIAL.pdf — 28 itens, um por par,
 * conferidos contra o PDF.
 */
import type { Config } from './mapa.server';

export interface ItemDesempate {
  codigo: string;
  par: [Config, Config];
  enunciado: string;
  alternativas: { p: Config; texto: string }[];
}

export const ITENS_DESEMPATE: ItemDesempate[] = [
  { codigo: 'D01', par: ['Te', 'Ti'],
    enunciado: "Um procedimento em uso apresenta falhas recorrentes. Você tem autonomia para agir. O que faz primeiro?",
    alternativas: [
      { p: 'Te', texto: "Escrevo a versão corrigida do procedimento e coloco em uso, ajustando o que aparecer depois." },
      { p: 'Ti', texto: "Estudo por que ele falha antes de propor qualquer substituição, mesmo que isso leve tempo." },
    ] },
  { codigo: 'D02', par: ['Te', 'Fe'],
    enunciado: "Uma entrega atrasou e há desconforto entre as pessoas envolvidas. Por onde você começa?",
    alternativas: [
      { p: 'Te', texto: "Pelo combinado: retomo prazos e responsabilidades, e reorganizo o que ficou pendente." },
      { p: 'Fe', texto: "Pelas pessoas: converso com quem está desconfortável antes de tratar da entrega." },
    ] },
  { codigo: 'D03', par: ['Te', 'Fi'],
    enunciado: "Você recebe uma orientação que considera equivocada, mas legítima. Como se posiciona?",
    alternativas: [
      { p: 'Te', texto: "Cumpro e registro formalmente minha divergência, para que fique documentada." },
      { p: 'Fi', texto: "Cumpro no que não contraria o que acredito, e não finjo concordar no restante." },
    ] },
  { codigo: 'D04', par: ['Te', 'Se'],
    enunciado: "Um problema urgente aparece e a equipe está dispersa. Qual é o seu primeiro movimento?",
    alternativas: [
      { p: 'Te', texto: "Defino quem cuida do quê e em que ordem, antes de qualquer um começar a agir." },
      { p: 'Se', texto: "Começo a resolver a parte mais crítica eu mesmo, e organizo o resto no caminho." },
    ] },
  { codigo: 'D05', par: ['Te', 'Si'],
    enunciado: "Você assume a coordenação de um trabalho que já vinha sendo feito de outra forma. Como conduz?",
    alternativas: [
      { p: 'Te', texto: "Estabeleço a estrutura que considero correta e comunico o novo funcionamento." },
      { p: 'Si', texto: "Mantenho o que já funcionava e mudo apenas o que se mostrar necessário." },
    ] },
  { codigo: 'D06', par: ['Te', 'Ne'],
    enunciado: "A equipe precisa de uma saída para um problema que se repete. O que você traz?",
    alternativas: [
      { p: 'Te', texto: "Uma proposta fechada, com etapas, responsáveis e prazo, pronta para ser decidida." },
      { p: 'Ne', texto: "Várias direções possíveis, para que a equipe escolha antes de fechar qualquer uma." },
    ] },
  { codigo: 'D07', par: ['Te', 'Ni'],
    enunciado: "Há uma decisão a tomar e o cenário à frente não está claro. Como você se apoia?",
    alternativas: [
      { p: 'Te', texto: "No critério que já usamos em casos parecidos — decido e sigo, revisando se mudar." },
      { p: 'Ni', texto: "Na leitura de onde isso vai desembocar, mesmo que ainda não haja evidência disso." },
    ] },
  { codigo: 'D08', par: ['Ti', 'Fe'],
    enunciado: "Você identifica um erro no trabalho apresentado por um colega diante do grupo. Como age?",
    alternativas: [
      { p: 'Ti', texto: "Aponto o erro com precisão, porque deixá-lo passar comprometeria o resultado." },
      { p: 'Fe', texto: "Trato depois, em separado, para não expor a pessoa na frente de todos." },
    ] },
  { codigo: 'D09', par: ['Ti', 'Fi'],
    enunciado: "Uma escolha pode ser defendida por argumento técnico ou por convicção pessoal. Qual pesa mais?",
    alternativas: [
      { p: 'Ti', texto: "O argumento: se ele não se sustenta, minha convicção também não deveria." },
      { p: 'Fi', texto: "A convicção: há coisas que sustento mesmo sem conseguir demonstrar por raciocínio." },
    ] },
  { codigo: 'D10', par: ['Ti', 'Se'],
    enunciado: "Surge uma abordagem nova para um trabalho que você domina. Como você a avalia?",
    alternativas: [
      { p: 'Ti', texto: "Entendo como ela funciona por dentro antes de confiar qualquer coisa a ela." },
      { p: 'Se', texto: "Experimento em pequena escala — descubro mais usando do que analisando." },
    ] },
  { codigo: 'D11', par: ['Ti', 'Si'],
    enunciado: "Um resultado não fechou como esperado. Onde você procura primeiro?",
    alternativas: [
      { p: 'Ti', texto: "Na lógica: reconstruo o raciocínio até achar onde a premissa não se sustenta." },
      { p: 'Si', texto: "Nos registros: confiro passo a passo o que foi feito até achar onde saiu do padrão." },
    ] },
  { codigo: 'D12', par: ['Ti', 'Ne'],
    enunciado: "Você tem tempo livre para se dedicar a um assunto de trabalho. Como o usa?",
    alternativas: [
      { p: 'Ti', texto: "Aprofundo um único tema até dominá-lo por inteiro." },
      { p: 'Ne', texto: "Percorro vários temas novos, atrás de conexões que ainda não enxerguei." },
    ] },
  { codigo: 'D13', par: ['Ti', 'Ni'],
    enunciado: "Você precisa avaliar uma proposta complexa. O que examina primeiro?",
    alternativas: [
      { p: 'Ti', texto: "Se ela é internamente coerente — se as partes se sustentam umas às outras." },
      { p: 'Ni', texto: "Aonde ela chega no longo prazo, mesmo que hoje pareça coerente." },
    ] },
  { codigo: 'D14', par: ['Fe', 'Fi'],
    enunciado: "O grupo caminha para uma decisão com a qual você não concorda. O que você faz?",
    alternativas: [
      { p: 'Fe', texto: "Busco uma formulação que a maioria consiga aceitar sem que o grupo se divida." },
      { p: 'Fi', texto: "Mantenho minha posição, mesmo ficando sozinho, e não a sustento por fora." },
    ] },
  { codigo: 'D15', par: ['Fe', 'Se'],
    enunciado: "Uma frente de trabalho está parada e a equipe desanimada. Por onde você entra?",
    alternativas: [
      { p: 'Fe', texto: "Descubro o que desanimou o grupo e trato disso antes de retomar o trabalho." },
      { p: 'Se', texto: "Começo a fazer a primeira coisa concreta — o movimento costuma reanimar por si." },
    ] },
  { codigo: 'D16', par: ['Fe', 'Si'],
    enunciado: "Você vai distribuir tarefas em um trabalho coletivo. O que orienta a divisão?",
    alternativas: [
      { p: 'Fe', texto: "Onde cada pessoa vai se sentir útil e disposta a contribuir." },
      { p: 'Si', texto: "Quem já fez aquilo bem antes e tem prática comprovada na tarefa." },
    ] },
  { codigo: 'D17', par: ['Fe', 'Ne'],
    enunciado: "Você tem uma conversa com alguém de outra área. O que busca nela?",
    alternativas: [
      { p: 'Fe', texto: "Construir uma relação de confiança que facilite o trabalho conjunto depois." },
      { p: 'Ne', texto: "Descobrir oportunidades e cruzamentos entre o que cada um faz." },
    ] },
  { codigo: 'D18', par: ['Fe', 'Ni'],
    enunciado: "A equipe está sobrecarregada e o desgaste começa a aparecer. Do que você cuida?",
    alternativas: [
      { p: 'Fe', texto: "Do clima agora: sem as pessoas inteiras, nada mais anda." },
      { p: 'Ni', texto: "Da causa de fundo: enquanto ela ficar, a sobrecarga volta em outra forma." },
    ] },
  { codigo: 'D19', par: ['Fi', 'Se'],
    enunciado: "Sob pressão intensa, o que costuma acontecer com você?",
    alternativas: [
      { p: 'Fi', texto: "Fico mais quieto — processo por dentro antes de me manifestar." },
      { p: 'Se', texto: "Fico mais em movimento — quando aperta, eu ajo." },
    ] },
  { codigo: 'D20', par: ['Fi', 'Si'],
    enunciado: "Você precisa entregar algo que considera abaixo do que deveria ser. O que sustenta sua recusa?",
    alternativas: [
      { p: 'Fi', texto: "Não entrego mal aquilo que, para mim, não se entrega mal — é questão de princípio." },
      { p: 'Si', texto: "Não entrego fora do padrão combinado — é questão de conferência e método." },
    ] },
  { codigo: 'D21', par: ['Fi', 'Ne'],
    enunciado: "Você tem uma ideia que ainda não convenceu ninguém. O que faz com ela?",
    alternativas: [
      { p: 'Fi', texto: "Sigo sustentando por conta própria, sem transformar isso em campanha." },
      { p: 'Ne', texto: "Levo a mais gente e a outros lugares até encontrar quem se interesse." },
    ] },
  { codigo: 'D22', par: ['Fi', 'Ni'],
    enunciado: "Você percebe algo importante que o grupo ainda não vê. Como se manifesta?",
    alternativas: [
      { p: 'Fi', texto: "Digo se me pedirem, e sustento na prática mesmo que não me perguntem." },
      { p: 'Ni', texto: "Digo uma vez, com clareza, e não insisto — quando ficar visível, vão lembrar." },
    ] },
  { codigo: 'D23', par: ['Se', 'Si'],
    enunciado: "Você precisa decidir sobre algo concreto e há alguma margem de risco. Como resolve?",
    alternativas: [
      { p: 'Se', texto: "Testo logo, em escala pequena, e deixo o resultado decidir." },
      { p: 'Si', texto: "Verifico tudo antes de mover — sob pressa é que o erro passa." },
    ] },
  { codigo: 'D24', par: ['Se', 'Ne'],
    enunciado: "Um trabalho novo vai começar e nada está definido ainda. Qual é a sua entrada?",
    alternativas: [
      { p: 'Se', texto: "Faço a primeira coisa concreta possível hoje, e o resto vem atrás." },
      { p: 'Ne', texto: "Levanto os caminhos possíveis antes de fechar por onde começar." },
    ] },
  { codigo: 'D25', par: ['Se', 'Ni'],
    enunciado: "Uma urgência aparece pela terceira vez no mês. O que você faz agora?",
    alternativas: [
      { p: 'Se', texto: "Resolvo a urgência da vez — o padrão a gente discute depois, com calma." },
      { p: 'Ni', texto: "Paro e trato do que está gerando as urgências, mesmo com esta ainda aberta." },
    ] },
  { codigo: 'D26', par: ['Si', 'Ne'],
    enunciado: "Propõem trocar um processo que funciona por outro ainda não testado aqui. Qual é a sua posição?",
    alternativas: [
      { p: 'Si', texto: "Rodar os dois em paralelo antes de abandonar o que já se mostrou confiável." },
      { p: 'Ne', texto: "Adotar o novo: o atual já mostrou seu limite e o outro abre caminhos." },
    ] },
  { codigo: 'D27', par: ['Si', 'Ni'],
    enunciado: "Pedem seu parecer sobre um plano detalhado. O que você olha primeiro?",
    alternativas: [
      { p: 'Si', texto: "Se os detalhes fecham: prazos, responsáveis e o que depende do quê." },
      { p: 'Ni', texto: "Se a direção está certa — plano bem-feito na direção errada continua errado." },
    ] },
  { codigo: 'D28', par: ['Ne', 'Ni'],
    enunciado: "Um projeto ainda em fase de ideia chega até você. Como você contribui?",
    alternativas: [
      { p: 'Ne', texto: "Trago referências e combinações de fora que ninguém tinha considerado." },
      { p: 'Ni', texto: "Aponto no que aquilo pode se transformar, mesmo sem sinal disso ainda." },
    ] },
];

const chave = (a: Config, b: Config) => [a, b].sort().join('|');

const POR_PAR: Record<string, ItemDesempate> =
  Object.fromEntries(ITENS_DESEMPATE.map(i => [chave(i.par[0], i.par[1]), i]));

/** O item que compara exatamente estas duas configurações. */
export function itemDoPar(a: Config, b: Config): ItemDesempate {
  const i = POR_PAR[chave(a, b)];
  if (!i) throw new Error(`sem item de desempate para ${a} vs ${b}`);
  return i;
}

/* ── Conferências estruturais ───────────────────────────────────────────── */
{
  if (ITENS_DESEMPATE.length !== 28)
    throw new Error(`deveriam existir 28 itens, existem ${ITENS_DESEMPATE.length}`);
  if (Object.keys(POR_PAR).length !== 28) throw new Error('há par repetido entre os itens');
  for (const it of ITENS_DESEMPATE) {
    if (it.alternativas.length !== 2)
      throw new Error(`${it.codigo} não tem exatamente duas alternativas`);
    const alvos = new Set(it.alternativas.map(a => a.p));
    if (alvos.size !== 2 || !it.par.every(p => alvos.has(p)))
      throw new Error(`${it.codigo}: alternativas não correspondem ao par`);
  }
}
