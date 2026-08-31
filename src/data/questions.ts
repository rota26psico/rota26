/**
 * AS 48 SITUAÇÕES — CAMADA PÚBLICA
 * ---------------------------------------------------------------------------
 * Este arquivo pode chegar ao navegador. Ele traz identificadores, contexto,
 * enunciado e o texto das alternativas — nada mais.
 *
 * O QUE NÃO ESTÁ AQUI, E POR QUÊ: o polo junguiano de cada alternativa, o eixo
 * comportamental e o peso do item são a CHAVE DE PONTUAÇÃO. Enquanto viviam
 * neste arquivo, iam inteiros para o bundle: qualquer pessoa que abrisse as
 * ferramentas do navegador na tela do questionário lia o gabarito das 192
 * alternativas e podia escolher o próprio resultado. Um instrumento com a chave
 * de correção pública deixa de medir o que se propõe.
 *
 * A chave passou para `questions.server.ts`, que começa com `import 'server-only'`
 * — se um componente de cliente a importar, o `next build` falha. Os dois
 * arquivos são conferidos um contra o outro por `npm run audit:itens`.
 *
 * A ordem e os identificadores permanecem os mesmos: a pontuação está vinculada
 * ao ID da alternativa, nunca à posição (item 12).
 */
import type { Atitude, Funcao } from './profiles';

export type EixoAux = 'EXP' | 'EXE' | 'AUT' | 'COO' | 'FLE' | 'EST';
export type PoloJung = Atitude | Funcao;
export type TipoItem = 'FUNCAO' | 'ATITUDE';

export interface Alternativa {
  id: string;          // ex.: 'Q001A'
  texto: string;
}
export interface Questao {
  id: string;          // ex.: 'Q001'
  contexto: string;
  enunciado: string;
  alternativas: Alternativa[];
}

export const VERSAO_INSTRUMENTO = 'v1.0-piloto';

export const NOME_EIXO: Record<EixoAux, string> = {
  EXP: 'Exploração', EXE: 'Execução', AUT: 'Autonomia',
  COO: 'Cooperação', FLE: 'Flexibilidade', EST: 'Estrutura'
};
export const EIXO_OPOSTO: Record<EixoAux, EixoAux> = {
  EXP: 'EXE', EXE: 'EXP', AUT: 'COO', COO: 'AUT', FLE: 'EST', EST: 'FLE'
};
export const PARES_EIXO: [EixoAux, EixoAux][] = [['EXP', 'EXE'], ['AUT', 'COO'], ['FLE', 'EST']];

const q = (id: string, contexto: string, enunciado: string, textos: string[]): Questao => ({
  id, contexto, enunciado,
  alternativas: textos.map((texto, i) => ({ id: `${id}${'ABCD'[i]}`, texto }))
});

export const QUESTOES: Questao[] = [
  // ─────────────── 1 ───────────────
  q("Q001", "informações incompletas",
    "A equipe recebe um problema novo e ainda existem poucas informações disponíveis. Qual comportamento mais se aproxima da sua tendência inicial?", [
    "Procuro organizar os fatos existentes e encontrar uma lógica entre eles.",
    "Converso com as pessoas envolvidas para compreender diferentes perspectivas e impactos.",
    "Observo cuidadosamente aquilo que já é concreto e verificável.",
    "Começo a imaginar diferentes cenários e possibilidades que ainda não foram consideradas."
  ]),
  // ─────────────── 2 ───────────────
  q("Q002", "reuniões",
    "Uma reunião importante começa e o tema é aberto para discussão. O que você costuma fazer nos primeiros minutos?", [
    "Já coloco minhas primeiras leituras na mesa e vou ajustando conforme os outros reagem.",
    "Puxo a conversa perguntando às pessoas o que cada uma está vendo.",
    "Escuto o conjunto até formar uma posição, e só então falo.",
    "Reviso mentalmente o material que preparei antes de intervir."
  ]),
  // ─────────────── 3 ───────────────
  q("Q003", "tomada de decisão",
    "Você precisa escolher entre duas propostas de trabalho igualmente defensáveis. O que pesa mais na sua escolha?", [
    "Qual delas é mais consistente com os critérios que já definimos.",
    "Qual delas as pessoas envolvidas conseguirão sustentar de verdade.",
    "Qual delas já se mostrou viável na prática em situações parecidas.",
    "Qual delas abre mais caminhos para o que vem depois."
  ]),
  // ─────────────── 4 ───────────────
  q("Q004", "aprendizagem",
    "Você precisa dominar rapidamente um assunto novo para o trabalho. Como tende a começar?", [
    "Procuro alguém que já domina e converso para acelerar o entendimento.",
    "Começo a mexer na ferramenta ou no material e aprendo no processo.",
    "Leio e organizo o conteúdo por conta própria antes de discutir com alguém.",
    "Monto um roteiro de estudo e sigo por etapas."
  ]),
  // ─────────────── 5 ───────────────
  q("Q005", "problemas inesperados",
    "Um problema inesperado interrompe o andamento do trabalho. Sua primeira reação tende a ser:", [
    "Identificar a causa e a cadeia que levou até aqui.",
    "Verificar quem foi afetado e o que isso significa para as pessoas.",
    "Levantar exatamente o que está acontecendo agora, ponto por ponto.",
    "Perceber o que esse problema revela sobre algo maior."
  ]),
  // ─────────────── 6 ───────────────
  q("Q006", "pressão",
    "Um período de pressão intensa se instala na equipe. Onde você busca o que precisa para se sustentar?", [
    "Na conversa e no contato frequente com as pessoas ao redor.",
    "Em manter-me em movimento, resolvendo uma coisa depois da outra.",
    "Em um espaço de silêncio para reorganizar as ideias antes de seguir.",
    "Em reduzir o escopo ao que domino e trabalhar de forma previsível."
  ]),
  // ─────────────── 7 ───────────────
  q("Q007", "reuniões",
    "Em uma reunião de trabalho, qual é a contribuição que você mais costuma dar?", [
    "Aponto inconsistências e ajudo a fechar o raciocínio.",
    "Percebo quem não está confortável e traz essa pessoa para a conversa.",
    "Traz os dados concretos e o histórico do que já foi feito.",
    "Levanto ângulos que ainda não apareceram na discussão."
  ]),
  // ─────────────── 8 ───────────────
  q("Q008", "comunicação",
    "Você tem uma ideia que considera relevante mas ainda não totalmente formada. O que costuma fazer?", [
    "Compartilho no estado em que está e vou lapidando na conversa.",
    "Testo com uma ou duas pessoas informalmente para ver como reage.",
    "Trabalho nela até que esteja consistente e só então apresento.",
    "Escrevo para mim mesmo primeiro, até entender o que realmente penso."
  ]),
  // ─────────────── 9 ───────────────
  q("Q009", "planejamento",
    "Ao planejar um trabalho de vários meses, o que você constrói primeiro?", [
    "A estrutura de etapas, dependências e critérios de conclusão.",
    "O acordo com as pessoas sobre papéis, expectativas e carga.",
    "O levantamento do que já existe, dos recursos e das restrições reais.",
    "A leitura do cenário em que esse trabalho vai desembocar."
  ]),
  // ─────────────── 10 ───────────────
  q("Q010", "organização",
    "Como você costuma organizar seu próprio trabalho no dia a dia?", [
    "Vou reagindo ao que aparece e reorganizando a ordem conforme o dia anda.",
    "Combino com as pessoas ao redor e me organizo em função do ritmo delas.",
    "Mantenho um sistema próprio que só eu preciso entender.",
    "Sigo uma rotina estável, com horários e blocos definidos."
  ]),
  // ─────────────── 11 ───────────────
  q("Q011", "conflitos",
    "Duas pessoas da equipe estão em desacordo aberto. Qual é sua entrada mais natural?", [
    "Separar o que é divergência de critério do que é ruído.",
    "Cuidar para que a relação entre elas não se rompa no processo.",
    "Reconstituir o que de fato aconteceu, na ordem em que aconteceu.",
    "Perceber o que esse desacordo está dizendo sobre algo não nomeado."
  ]),
  // ─────────────── 12 ───────────────
  q("Q012", "novas oportunidades",
    "Surge uma oportunidade fora do escopo habitual da equipe. Como você tende a se posicionar?", [
    "Já começo a sondar contatos e a mapear quem pode abrir portas.",
    "Levo para o grupo rapidamente para pensarmos juntos em voz alta.",
    "Avalio internamente se faz sentido antes de mobilizar ninguém.",
    "Verifico se temos estrutura para sustentar isso antes de entusiasmar-me."
  ]),
  // ─────────────── 13 ───────────────
  q("Q013", "análise",
    "Você recebe um relatório extenso para avaliar. Onde sua atenção vai primeiro?", [
    "À coerência interna: se as conclusões se sustentam a partir dos dados.",
    "Ao que aquilo implica para as pessoas e áreas envolvidas.",
    "À exatidão dos números, das fontes e dos detalhes verificáveis.",
    "Ao que o relatório sugere sobre a direção das coisas."
  ]),
  // ─────────────── 14 ───────────────
  q("Q014", "relacionamento",
    "Você entra em uma equipe nova. Como tende a construir sua posição ali?", [
    "Circulando, conversando com muita gente e me tornando presente rápido.",
    "Assumindo logo alguma entrega visível para mostrar o que sei fazer.",
    "Observando as dinâmicas por um tempo antes de me expor.",
    "Aprendendo primeiro os processos e a forma correta de operar ali."
  ]),
  // ─────────────── 15 ───────────────
  q("Q015", "prazos",
    "Um prazo está apertado e algo terá de ser sacrificado. Como você decide o que sai?", [
    "Pelo critério de impacto: sai o que menos compromete o resultado.",
    "Pelo acordo: converso com quem depende daquilo antes de cortar.",
    "Pelo que já está pronto: preservo o que existe e concluo o possível.",
    "Pelo que pode ser retomado depois sem perda: sai o que é reversível."
  ]),
  // ─────────────── 16 ───────────────
  q("Q016", "execução",
    "Você tem uma tarefa longa e absorvente para entregar. Que condição faz você render mais?", [
    "Estar perto das pessoas, com trocas rápidas ao longo do caminho.",
    "Ter movimento e variedade, alternando entre frentes diferentes.",
    "Ter blocos longos e ininterruptos de concentração.",
    "Ter um plano claro e um ambiente estável e previsível."
  ]),
  // ─────────────── 17 ───────────────
  q("Q017", "inovação",
    "A equipe precisa encontrar uma solução realmente diferente para um problema antigo. Sua contribuição tende a ser:", [
    "Estruturar o problema de outro modo para que a solução apareça.",
    "Garantir que a solução seja aceitável para quem vai conviver com ela.",
    "Testar rapidamente algo pequeno para ver o que acontece de fato.",
    "Gerar várias hipóteses ainda não consideradas, mesmo as improváveis."
  ]),
  // ─────────────── 18 ───────────────
  q("Q018", "divergências",
    "Você discorda de uma decisão que já foi tomada pelo grupo. O que costuma fazer?", [
    "Digo na hora, abertamente, e sustento o debate ali mesmo.",
    "Procuro as pessoas individualmente e reabro a conversa.",
    "Formulo com cuidado o argumento e escolho o momento de apresentá-lo.",
    "Sigo o combinado, mantendo minha avaliação para mim."
  ]),
  // ─────────────── 19 ───────────────
  q("Q019", "comunicação",
    "Você precisa explicar um assunto complexo a quem não conhece o tema. Como estrutura a explicação?", [
    "Pela lógica: começo pelo princípio que organiza tudo.",
    "Pela pessoa: começo pelo que importa para quem está ouvindo.",
    "Pelo exemplo concreto: mostro um caso real e vou generalizando.",
    "Pela imagem: uso uma analogia que faça o conjunto aparecer de uma vez."
  ]),
  // ─────────────── 20 ───────────────
  q("Q020", "problemas inesperados",
    "Algo dá errado no meio de uma entrega. Qual é seu primeiro movimento?", [
    "Aviso e mobilizo as pessoas necessárias imediatamente.",
    "Parto para a ação e vou corrigindo enquanto ando.",
    "Paro e entendo o que aconteceu antes de mover qualquer coisa.",
    "Volto ao procedimento previsto para esse tipo de situação."
  ]),
  // ─────────────── 21 ───────────────
  q("Q021", "mudanças",
    "A organização anuncia uma mudança significativa de direção. Qual é sua primeira pergunta interna?", [
    "Isso é coerente com o que vínhamos sustentando?",
    "Como isso vai cair para as pessoas que serão afetadas?",
    "O que muda concretamente no meu trabalho a partir de amanhã?",
    "Para onde isso nos leva daqui a dois ou três anos?"
  ]),
  // ─────────────── 22 ───────────────
  q("Q022", "prioridades",
    "Você tem mais demandas do que consegue atender. Como define o que fazer primeiro?", [
    "Consulto quem está envolvido e negocio a ordem com eles.",
    "Ataco primeiro o que está mais visível e destrava mais gente.",
    "Faço minha própria leitura de importância e assumo a decisão.",
    "Sigo os critérios de prioridade já estabelecidos."
  ]),
  // ─────────────── 23 ───────────────
  q("Q023", "negociação",
    "Em uma negociação difícil, o que costuma sustentar sua posição?", [
    "A consistência do argumento e os dados que o apoiam.",
    "A compreensão do que realmente importa para o outro lado.",
    "O conhecimento preciso das condições concretas e das restrições.",
    "A leitura de para onde a conversa pode ser levada."
  ]),
  // ─────────────── 24 ───────────────
  q("Q024", "aprendizagem",
    "Depois de concluir um projeto, como você mais aprende com ele?", [
    "Conversando com os envolvidos sobre o que cada um percebeu.",
    "Já aplicando o aprendido no projeto seguinte.",
    "Revisando sozinho o percurso e formando minhas próprias conclusões.",
    "Registrando o que funcionou para incorporar ao processo."
  ]),
  // ─────────────── 25 ───────────────
  q("Q025", "conclusão",
    "Um trabalho está na fase final. Onde você coloca mais energia?", [
    "Em verificar se o resultado corresponde ao que foi definido.",
    "Em cuidar de quem participou e reconhecer as contribuições.",
    "Em revisar os detalhes e fechar as pontas soltas.",
    "Em identificar o que esse trabalho abriu para o próximo."
  ]),
  // ─────────────── 26 ───────────────
  q("Q026", "planejamento",
    "Você precisa formar uma opinião sólida sobre um tema difícil. O que funciona melhor para você?", [
    "Pensar em voz alta com outras pessoas até a ideia se formar.",
    "Experimentar na prática e deixar a opinião se formar pela experiência.",
    "Elaborar internamente até chegar a uma posição própria.",
    "Estudar de forma sistemática antes de concluir qualquer coisa."
  ]),
  // ─────────────── 27 ───────────────
  q("Q027", "execução",
    "Você assume uma entrega com autonomia total. Como começa?", [
    "Definindo critérios de sucesso e a sequência de etapas.",
    "Alinhando expectativas com quem vai receber o resultado.",
    "Fazendo a primeira parte concreta e ajustando a partir dela.",
    "Desenhando o cenário completo antes de tocar em qualquer parte."
  ]),
  // ─────────────── 28 ───────────────
  q("Q028", "inovação",
    "A equipe está buscando ideias novas. Em que situação você produz suas melhores contribuições?", [
    "Em discussão aberta, no calor da troca com o grupo.",
    "Circulando fora da equipe, vendo como outros resolvem.",
    "Sozinho, com tempo, deixando a ideia amadurecer.",
    "A partir de um método ou referência já organizada."
  ]),
  // ─────────────── 29 ───────────────
  q("Q029", "pressão",
    "Sob forte pressão de tempo, qual recurso você aciona primeiro?", [
    "Corto pelo critério: defino o essencial e descarto o resto.",
    "Chamo as pessoas certas e divido a carga.",
    "Coloco a mão na massa e resolvo o que está na minha frente.",
    "Procuro um caminho alternativo que ninguém tentou ainda."
  ]),
  // ─────────────── 30 ───────────────
  q("Q030", "conflitos",
    "Há uma tensão não resolvida no ambiente de trabalho. Como você lida?", [
    "Nomeio a questão abertamente para que possa ser tratada.",
    "Movimento a situação: proponho algo concreto que mude a dinâmica.",
    "Observo e busco compreender a origem antes de agir.",
    "Encaminho pelos canais e procedimentos apropriados."
  ]),
  // ─────────────── 31 ───────────────
  q("Q031", "relacionamento",
    "Um colega procura você para falar de uma dificuldade no trabalho. O que você tende a oferecer primeiro?", [
    "Ajuda a organizar o problema e enxergar as opções com clareza.",
    "Escuta e reconhecimento do que ele está vivendo.",
    "Apoio prático: o que dá para fazer hoje para aliviar a situação.",
    "Uma leitura mais ampla do que pode estar por trás daquilo."
  ]),
  // ─────────────── 32 ───────────────
  q("Q032", "prazos",
    "Faltam poucos dias para uma entrega importante. Como você trabalha nesse período?", [
    "Aumento o contato com o time, sincronizando com frequência.",
    "Acelero e faço o que aparecer, na ordem em que aparecer.",
    "Me isolo para conseguir concentração total no que falta.",
    "Sigo rigorosamente o plano de fechamento que montei antes."
  ]),
  // ─────────────── 33 ───────────────
  q("Q033", "organização",
    "Você precisa colocar ordem em um processo confuso. Por onde começa?", [
    "Pela lógica do fluxo: o que depende de quê.",
    "Pelas pessoas: quem faz o quê e como estão se sentindo nisso.",
    "Pelo mapeamento do que existe hoje, exatamente como está.",
    "Pela pergunta de para que esse processo existe, afinal."
  ]),
  // ─────────────── 34 ───────────────
  q("Q034", "análise",
    "Você recebeu dados complexos para interpretar. Como conduz o trabalho?", [
    "Discuto os números com outras pessoas enquanto analiso.",
    "Manipulo os dados de várias formas até algo aparecer.",
    "Analiso sozinho e apresento quando tiver uma leitura formada.",
    "Sigo um roteiro de análise definido, passo a passo."
  ]),
  // ─────────────── 35 ───────────────
  q("Q035", "divergências",
    "Sua avaliação técnica difere da avaliação do grupo. O que costuma fazer?", [
    "Explicito o critério que usei e peço que apontem onde ele falha.",
    "Procuro entender o que o grupo está valorizando que eu não vi.",
    "Trago as evidências concretas que sustentam minha leitura.",
    "Reformulo a questão de outro jeito para deslocar o debate."
  ]),
  // ─────────────── 36 ───────────────
  q("Q036", "mudanças",
    "Uma mudança de processo é anunciada para a semana seguinte. Qual é sua reação mais típica?", [
    "Já começo a testar e a descobrir na prática como vai funcionar.",
    "Procuro as pessoas para entender como cada uma está recebendo isso.",
    "Preciso de um tempo para processar antes de me posicionar.",
    "Quero saber o motivo e ver o novo procedimento documentado."
  ]),
  // ─────────────── 37 ───────────────
  q("Q037", "novas oportunidades",
    "Uma oportunidade promissora aparece, mas com informação incompleta. Como você a avalia?", [
    "Monto o raciocínio de custo, risco e retorno com o que há.",
    "Avalio se ela é compatível com o que consideramos importante.",
    "Busco verificar o que é fato e o que é ainda promessa.",
    "Sinto se há algo ali e vou atrás mesmo sem tudo confirmado."
  ]),
  // ─────────────── 38 ───────────────
  q("Q038", "negociação",
    "Você vai conduzir uma negociação importante. Como se prepara?", [
    "Converso com pessoas que conhecem o outro lado.",
    "Confio na leitura que vou fazer no próprio momento da conversa.",
    "Reflito sobre os cenários possíveis e defino minha posição sozinho.",
    "Preparo material, números e limites antes de entrar na sala."
  ]),
  // ─────────────── 39 ───────────────
  q("Q039", "tomada de decisão",
    "Uma decisão precisa ser tomada hoje e não há consenso. Como você contribui?", [
    "Proponho o critério de decisão e aplico.",
    "Busco a formulação que o grupo consiga sustentar junto.",
    "Aponto o que já sabemos com certeza e decido a partir daí.",
    "Aponto qual das opções mantém mais portas abertas."
  ]),
  // ─────────────── 40 ───────────────
  q("Q040", "comunicação",
    "Você precisa comunicar um resultado à organização. Qual formato prefere?", [
    "Apresentação ao vivo, com espaço para perguntas e discussão.",
    "Conversas rápidas e diretas com cada pessoa envolvida.",
    "Um documento bem escrito que a pessoa lê no tempo dela.",
    "Um relatório estruturado, com seções e dados organizados."
  ]),
  // ─────────────── 41 ───────────────
  q("Q041", "aprendizagem",
    "Você errou em algo importante. Como processa esse erro?", [
    "Reconstituo a lógica da decisão para achar onde ela falhou.",
    "Cuido do efeito que isso teve sobre as pessoas envolvidas.",
    "Verifico o que exatamente foi feito e corrijo o que dá para corrigir.",
    "Procuro o padrão: se isso já aconteceu antes de outra forma."
  ]),
  // ─────────────── 42 ───────────────
  q("Q042", "reuniões",
    "Ao final de um dia inteiro de reuniões e interação, como você costuma se sentir?", [
    "Com energia: as conversas me deixaram mais ativado.",
    "Bem, e com vontade de emendar em alguma coisa prática.",
    "Preciso de um período sozinho para me recompor.",
    "Preciso organizar tudo o que ficou pendente antes de parar."
  ]),
  // ─────────────── 43 ───────────────
  q("Q043", "prioridades",
    "Sua equipe está dispersa em muitas frentes. O que você propõe?", [
    "Um critério objetivo para hierarquizar e cortar.",
    "Uma conversa sobre carga e sobre o que está pesando em cada um.",
    "Um levantamento do estado real de cada frente antes de decidir.",
    "Uma revisão do propósito: talvez a lista esteja errada, não a ordem."
  ]),
  // ─────────────── 44 ───────────────
  q("Q044", "conclusão",
    "Você terminou uma entrega significativa. O que faz em seguida?", [
    "Compartilho com as pessoas e comemoro junto.",
    "Emendo direto na próxima coisa.",
    "Recolho-me um pouco para digerir o que acabou de passar.",
    "Fecho a documentação e os registros antes de seguir."
  ]),
  // ─────────────── 45 ───────────────
  q("Q045", "informações incompletas",
    "Você precisa se posicionar sobre um tema em que faltam dados essenciais. O que faz?", [
    "Explicito as premissas que estou assumindo e decido sobre elas.",
    "Consulto quem tem experiência prática no assunto.",
    "Espero até ter o dado mínimo verificável.",
    "Trabalho com hipóteses e sigo, ajustando conforme aparecer."
  ]),
  // ─────────────── 46 ───────────────
  q("Q046", "execução",
    "Um trabalho pode ser feito individualmente ou em dupla, com o mesmo resultado. O que escolhe?", [
    "Em dupla: a troca constrói o resultado junto com o processo.",
    "Em dupla, dividindo em partes e cada um acelerando a sua.",
    "Individualmente: rendo mais sem precisar sincronizar.",
    "Individualmente, seguindo meu próprio método já testado."
  ]),
  // ─────────────── 47 ───────────────
  q("Q047", "mudanças",
    "A equipe precisa abandonar um jeito de trabalhar que funcionava bem. O que mais pesa para você?", [
    "Se a razão da mudança se sustenta logicamente.",
    "Se as pessoas que construíram aquilo estão sendo consideradas.",
    "O que se perde concretamente e o que já está garantido no novo jeito.",
    "O que o novo jeito torna possível e o antigo impedia."
  ]),
  // ─────────────── 48 ───────────────
  q("Q048", "prioridades",
    "De modo geral, onde você diria que sua atenção se dirige mais naturalmente no trabalho?", [
    "Ao que está acontecendo em volta: pessoas, movimentos, demandas.",
    "À ação: ao que precisa ser movido e resolvido agora.",
    "Ao meu próprio processamento: ao que aquilo significa e como se organiza.",
    "Ao que precisa ser mantido em ordem, previsível e sob controle."
  ])
];

export const QUESTAO_POR_ID: Record<string, Questao> =
  Object.fromEntries(QUESTOES.map(x => [x.id, x]));

/* Contagens seguras: números agregados não identificam QUAIS itens são âncora,
   e as telas de metodologia precisam deles. */
export const TOTAL_QUESTOES = QUESTOES.length;
export const TOTAL_ALTERNATIVAS = QUESTOES.reduce((n, x) => n + x.alternativas.length, 0);
export const TOTAL_ANCORAS = 6;
export const TOTAL_ITENS_FUNCAO = 24;
export const TOTAL_ITENS_ATITUDE = 24;
