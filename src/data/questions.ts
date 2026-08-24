/**
 * ETAPA 4 — BANCO FIXO DE 48 QUESTÕES SITUACIONAIS (versão v1.0-piloto)
 * ---------------------------------------------------------------------------
 * REGRA FUNDAMENTAL (item 13 do prompt-mestre): a IA NÃO gera perguntas durante
 * a aplicação. Este banco é fixo, versionado, com ID próprio por item e por
 * alternativa, e é aplicado igualmente a todos os participantes da versão.
 *
 * DESENHO DOS ITENS
 * -----------------
 * Escolha forçada com 4 alternativas. Toda alternativa representa um recurso
 * comportamental plausível e funcional — nunca há alternativa "certa" ou
 * moralmente superior (itens 10 e 11).
 *
 * Cada alternativa carrega DUAS chaves:
 *   `jung` — polo junguiano: E | I | T | F | S | N
 *   `eixo` — polo comportamental auxiliar: EXP | EXE | AUT | COO | FLE | EST
 *
 * Dois tipos de item:
 *   tipo 'FUNCAO'  (24 itens) — as 4 alternativas têm jung = T, F, S, N
 *                               (uma de cada). Alimenta o eixo das funções.
 *   tipo 'ATITUDE' (24 itens) — as 4 alternativas têm jung = E, E, I, I.
 *                               Alimenta o eixo da atitude.
 * Consequência estrutural: para qualquer participante,
 *   T+F+S+N = soma dos pesos dos itens FUNCAO   (27 com os pesos atuais)
 *   E+I     = soma dos pesos dos itens ATITUDE  (27 com os pesos atuais)
 * Os totais são idênticos para todos, o que torna os escores comparáveis sem
 * qualquer normalização por respondente.
 *
 * ITENS ÂNCORA (peso 2): 3 por grupo. Existem por dois motivos:
 *  (a) maior validade aparente — descrevem a situação em que a distinção entre
 *      os polos é mais nítida;
 *  (b) tornam os totais ÍMPARES (27), o que ELIMINA empate na atitude.
 * Empate entre funções continua possível e tem regra própria (ver scoring.ts).
 *
 * ORDEM DE EXIBIÇÃO: as alternativas são randomizadas na aplicação; a chave de
 * pontuação está vinculada ao ID da alternativa, nunca à posição (item 12).
 * Pensamento não é sempre "A", Sentimento não é sempre "B".
 */

import type { Atitude, Funcao } from './profiles';

export type EixoAux = 'EXP' | 'EXE' | 'AUT' | 'COO' | 'FLE' | 'EST';
export type PoloJung = Atitude | Funcao;
export type TipoItem = 'FUNCAO' | 'ATITUDE';

export interface Alternativa {
  id: string;          // ex.: 'Q001A'
  texto: string;
  jung: PoloJung;
  eixo: EixoAux;
}
export interface Questao {
  id: string;          // ex.: 'Q001'
  tipo: TipoItem;
  peso: number;        // 1 ou 2 (âncora)
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

const q = (
  id: string, tipo: TipoItem, peso: number, contexto: string, enunciado: string,
  alts: [string, PoloJung, EixoAux][]
): Questao => ({
  id, tipo, peso, contexto, enunciado,
  alternativas: alts.map(([texto, jung, eixo], i) => ({
    id: `${id}${'ABCD'[i]}`, texto, jung, eixo
  }))
});

export const QUESTOES: Questao[] = [
  // ─────────────── 1 ───────────────
  q('Q001', 'FUNCAO', 2, 'informações incompletas',
    'A equipe recebe um problema novo e ainda existem poucas informações disponíveis. Qual comportamento mais se aproxima da sua tendência inicial?', [
    ['Procuro organizar os fatos existentes e encontrar uma lógica entre eles.', 'T', 'EST'],
    ['Converso com as pessoas envolvidas para compreender diferentes perspectivas e impactos.', 'F', 'COO'],
    ['Observo cuidadosamente aquilo que já é concreto e verificável.', 'S', 'EXE'],
    ['Começo a imaginar diferentes cenários e possibilidades que ainda não foram consideradas.', 'N', 'EXP']
  ]),
  q('Q002', 'ATITUDE', 1, 'reuniões',
    'Uma reunião importante começa e o tema é aberto para discussão. O que você costuma fazer nos primeiros minutos?', [
    ['Já coloco minhas primeiras leituras na mesa e vou ajustando conforme os outros reagem.', 'E', 'FLE'],
    ['Puxo a conversa perguntando às pessoas o que cada uma está vendo.', 'E', 'COO'],
    ['Escuto o conjunto até formar uma posição, e só então falo.', 'I', 'AUT'],
    ['Reviso mentalmente o material que preparei antes de intervir.', 'I', 'EST']
  ]),
  q('Q003', 'FUNCAO', 1, 'tomada de decisão',
    'Você precisa escolher entre duas propostas de trabalho igualmente defensáveis. O que pesa mais na sua escolha?', [
    ['Qual delas é mais consistente com os critérios que já definimos.', 'T', 'EST'],
    ['Qual delas as pessoas envolvidas conseguirão sustentar de verdade.', 'F', 'COO'],
    ['Qual delas já se mostrou viável na prática em situações parecidas.', 'S', 'EXE'],
    ['Qual delas abre mais caminhos para o que vem depois.', 'N', 'EXP']
  ]),
  q('Q004', 'ATITUDE', 1, 'aprendizagem',
    'Você precisa dominar rapidamente um assunto novo para o trabalho. Como tende a começar?', [
    ['Procuro alguém que já domina e converso para acelerar o entendimento.', 'E', 'COO'],
    ['Começo a mexer na ferramenta ou no material e aprendo no processo.', 'E', 'FLE'],
    ['Leio e organizo o conteúdo por conta própria antes de discutir com alguém.', 'I', 'AUT'],
    ['Monto um roteiro de estudo e sigo por etapas.', 'I', 'EST']
  ]),
  q('Q005', 'FUNCAO', 1, 'problemas inesperados',
    'Um problema inesperado interrompe o andamento do trabalho. Sua primeira reação tende a ser:', [
    ['Identificar a causa e a cadeia que levou até aqui.', 'T', 'AUT'],
    ['Verificar quem foi afetado e o que isso significa para as pessoas.', 'F', 'COO'],
    ['Levantar exatamente o que está acontecendo agora, ponto por ponto.', 'S', 'EXE'],
    ['Perceber o que esse problema revela sobre algo maior.', 'N', 'EXP']
  ]),
  q('Q006', 'ATITUDE', 2, 'pressão',
    'Um período de pressão intensa se instala na equipe. Onde você busca o que precisa para se sustentar?', [
    ['Na conversa e no contato frequente com as pessoas ao redor.', 'E', 'COO'],
    ['Em manter-me em movimento, resolvendo uma coisa depois da outra.', 'E', 'EXE'],
    ['Em um espaço de silêncio para reorganizar as ideias antes de seguir.', 'I', 'AUT'],
    ['Em reduzir o escopo ao que domino e trabalhar de forma previsível.', 'I', 'EST']
  ]),
  q('Q007', 'FUNCAO', 1, 'reuniões',
    'Em uma reunião de trabalho, qual é a contribuição que você mais costuma dar?', [
    ['Aponto inconsistências e ajudo a fechar o raciocínio.', 'T', 'AUT'],
    ['Percebo quem não está confortável e traz essa pessoa para a conversa.', 'F', 'COO'],
    ['Traz os dados concretos e o histórico do que já foi feito.', 'S', 'EXE'],
    ['Levanto ângulos que ainda não apareceram na discussão.', 'N', 'EXP']
  ]),
  q('Q008', 'ATITUDE', 1, 'comunicação',
    'Você tem uma ideia que considera relevante mas ainda não totalmente formada. O que costuma fazer?', [
    ['Compartilho no estado em que está e vou lapidando na conversa.', 'E', 'FLE'],
    ['Testo com uma ou duas pessoas informalmente para ver como reage.', 'E', 'EXP'],
    ['Trabalho nela até que esteja consistente e só então apresento.', 'I', 'EST'],
    ['Escrevo para mim mesmo primeiro, até entender o que realmente penso.', 'I', 'AUT']
  ]),
  q('Q009', 'FUNCAO', 1, 'planejamento',
    'Ao planejar um trabalho de vários meses, o que você constrói primeiro?', [
    ['A estrutura de etapas, dependências e critérios de conclusão.', 'T', 'EST'],
    ['O acordo com as pessoas sobre papéis, expectativas e carga.', 'F', 'COO'],
    ['O levantamento do que já existe, dos recursos e das restrições reais.', 'S', 'EXE'],
    ['A leitura do cenário em que esse trabalho vai desembocar.', 'N', 'EXP']
  ]),
  q('Q010', 'ATITUDE', 1, 'organização',
    'Como você costuma organizar seu próprio trabalho no dia a dia?', [
    ['Vou reagindo ao que aparece e reorganizando a ordem conforme o dia anda.', 'E', 'FLE'],
    ['Combino com as pessoas ao redor e me organizo em função do ritmo delas.', 'E', 'COO'],
    ['Mantenho um sistema próprio que só eu preciso entender.', 'I', 'AUT'],
    ['Sigo uma rotina estável, com horários e blocos definidos.', 'I', 'EST']
  ]),
  q('Q011', 'FUNCAO', 1, 'conflitos',
    'Duas pessoas da equipe estão em desacordo aberto. Qual é sua entrada mais natural?', [
    ['Separar o que é divergência de critério do que é ruído.', 'T', 'AUT'],
    ['Cuidar para que a relação entre elas não se rompa no processo.', 'F', 'COO'],
    ['Reconstituir o que de fato aconteceu, na ordem em que aconteceu.', 'S', 'EXE'],
    ['Perceber o que esse desacordo está dizendo sobre algo não nomeado.', 'N', 'EXP']
  ]),
  q('Q012', 'ATITUDE', 1, 'novas oportunidades',
    'Surge uma oportunidade fora do escopo habitual da equipe. Como você tende a se posicionar?', [
    ['Já começo a sondar contatos e a mapear quem pode abrir portas.', 'E', 'EXP'],
    ['Levo para o grupo rapidamente para pensarmos juntos em voz alta.', 'E', 'COO'],
    ['Avalio internamente se faz sentido antes de mobilizar ninguém.', 'I', 'AUT'],
    ['Verifico se temos estrutura para sustentar isso antes de entusiasmar-me.', 'I', 'EST']
  ]),
  q('Q013', 'FUNCAO', 2, 'análise',
    'Você recebe um relatório extenso para avaliar. Onde sua atenção vai primeiro?', [
    ['À coerência interna: se as conclusões se sustentam a partir dos dados.', 'T', 'AUT'],
    ['Ao que aquilo implica para as pessoas e áreas envolvidas.', 'F', 'COO'],
    ['À exatidão dos números, das fontes e dos detalhes verificáveis.', 'S', 'EST'],
    ['Ao que o relatório sugere sobre a direção das coisas.', 'N', 'EXP']
  ]),
  q('Q014', 'ATITUDE', 1, 'relacionamento',
    'Você entra em uma equipe nova. Como tende a construir sua posição ali?', [
    ['Circulando, conversando com muita gente e me tornando presente rápido.', 'E', 'COO'],
    ['Assumindo logo alguma entrega visível para mostrar o que sei fazer.', 'E', 'EXE'],
    ['Observando as dinâmicas por um tempo antes de me expor.', 'I', 'AUT'],
    ['Aprendendo primeiro os processos e a forma correta de operar ali.', 'I', 'EST']
  ]),
  q('Q015', 'FUNCAO', 1, 'prazos',
    'Um prazo está apertado e algo terá de ser sacrificado. Como você decide o que sai?', [
    ['Pelo critério de impacto: sai o que menos compromete o resultado.', 'T', 'EST'],
    ['Pelo acordo: converso com quem depende daquilo antes de cortar.', 'F', 'COO'],
    ['Pelo que já está pronto: preservo o que existe e concluo o possível.', 'S', 'EXE'],
    ['Pelo que pode ser retomado depois sem perda: sai o que é reversível.', 'N', 'FLE']
  ]),
  q('Q016', 'ATITUDE', 1, 'execução',
    'Você tem uma tarefa longa e absorvente para entregar. Que condição faz você render mais?', [
    ['Estar perto das pessoas, com trocas rápidas ao longo do caminho.', 'E', 'COO'],
    ['Ter movimento e variedade, alternando entre frentes diferentes.', 'E', 'FLE'],
    ['Ter blocos longos e ininterruptos de concentração.', 'I', 'AUT'],
    ['Ter um plano claro e um ambiente estável e previsível.', 'I', 'EST']
  ]),
  q('Q017', 'FUNCAO', 1, 'inovação',
    'A equipe precisa encontrar uma solução realmente diferente para um problema antigo. Sua contribuição tende a ser:', [
    ['Estruturar o problema de outro modo para que a solução apareça.', 'T', 'FLE'],
    ['Garantir que a solução seja aceitável para quem vai conviver com ela.', 'F', 'COO'],
    ['Testar rapidamente algo pequeno para ver o que acontece de fato.', 'S', 'EXE'],
    ['Gerar várias hipóteses ainda não consideradas, mesmo as improváveis.', 'N', 'EXP']
  ]),
  q('Q018', 'ATITUDE', 1, 'divergências',
    'Você discorda de uma decisão que já foi tomada pelo grupo. O que costuma fazer?', [
    ['Digo na hora, abertamente, e sustento o debate ali mesmo.', 'E', 'FLE'],
    ['Procuro as pessoas individualmente e reabro a conversa.', 'E', 'COO'],
    ['Formulo com cuidado o argumento e escolho o momento de apresentá-lo.', 'I', 'EST'],
    ['Sigo o combinado, mantendo minha avaliação para mim.', 'I', 'AUT']
  ]),
  q('Q019', 'FUNCAO', 1, 'comunicação',
    'Você precisa explicar um assunto complexo a quem não conhece o tema. Como estrutura a explicação?', [
    ['Pela lógica: começo pelo princípio que organiza tudo.', 'T', 'EST'],
    ['Pela pessoa: começo pelo que importa para quem está ouvindo.', 'F', 'FLE'],
    ['Pelo exemplo concreto: mostro um caso real e vou generalizando.', 'S', 'EXE'],
    ['Pela imagem: uso uma analogia que faça o conjunto aparecer de uma vez.', 'N', 'EXP']
  ]),
  q('Q020', 'ATITUDE', 1, 'problemas inesperados',
    'Algo dá errado no meio de uma entrega. Qual é seu primeiro movimento?', [
    ['Aviso e mobilizo as pessoas necessárias imediatamente.', 'E', 'COO'],
    ['Parto para a ação e vou corrigindo enquanto ando.', 'E', 'EXE'],
    ['Paro e entendo o que aconteceu antes de mover qualquer coisa.', 'I', 'AUT'],
    ['Volto ao procedimento previsto para esse tipo de situação.', 'I', 'EST']
  ]),
  q('Q021', 'FUNCAO', 1, 'mudanças',
    'A organização anuncia uma mudança significativa de direção. Qual é sua primeira pergunta interna?', [
    ['Isso é coerente com o que vínhamos sustentando?', 'T', 'EST'],
    ['Como isso vai cair para as pessoas que serão afetadas?', 'F', 'COO'],
    ['O que muda concretamente no meu trabalho a partir de amanhã?', 'S', 'EXE'],
    ['Para onde isso nos leva daqui a dois ou três anos?', 'N', 'EXP']
  ]),
  q('Q022', 'ATITUDE', 1, 'prioridades',
    'Você tem mais demandas do que consegue atender. Como define o que fazer primeiro?', [
    ['Consulto quem está envolvido e negocio a ordem com eles.', 'E', 'COO'],
    ['Ataco primeiro o que está mais visível e destrava mais gente.', 'E', 'FLE'],
    ['Faço minha própria leitura de importância e assumo a decisão.', 'I', 'AUT'],
    ['Sigo os critérios de prioridade já estabelecidos.', 'I', 'EST']
  ]),
  q('Q023', 'FUNCAO', 1, 'negociação',
    'Em uma negociação difícil, o que costuma sustentar sua posição?', [
    ['A consistência do argumento e os dados que o apoiam.', 'T', 'AUT'],
    ['A compreensão do que realmente importa para o outro lado.', 'F', 'EXP'],
    ['O conhecimento preciso das condições concretas e das restrições.', 'S', 'EXE'],
    ['A leitura de para onde a conversa pode ser levada.', 'N', 'FLE']
  ]),
  q('Q024', 'ATITUDE', 1, 'aprendizagem',
    'Depois de concluir um projeto, como você mais aprende com ele?', [
    ['Conversando com os envolvidos sobre o que cada um percebeu.', 'E', 'COO'],
    ['Já aplicando o aprendido no projeto seguinte.', 'E', 'EXE'],
    ['Revisando sozinho o percurso e formando minhas próprias conclusões.', 'I', 'AUT'],
    ['Registrando o que funcionou para incorporar ao processo.', 'I', 'EST']
  ]),
  q('Q025', 'FUNCAO', 1, 'conclusão',
    'Um trabalho está na fase final. Onde você coloca mais energia?', [
    ['Em verificar se o resultado corresponde ao que foi definido.', 'T', 'AUT'],
    ['Em cuidar de quem participou e reconhecer as contribuições.', 'F', 'COO'],
    ['Em revisar os detalhes e fechar as pontas soltas.', 'S', 'EST'],
    ['Em identificar o que esse trabalho abriu para o próximo.', 'N', 'EXP']
  ]),
  q('Q026', 'ATITUDE', 2, 'planejamento',
    'Você precisa formar uma opinião sólida sobre um tema difícil. O que funciona melhor para você?', [
    ['Pensar em voz alta com outras pessoas até a ideia se formar.', 'E', 'COO'],
    ['Experimentar na prática e deixar a opinião se formar pela experiência.', 'E', 'EXP'],
    ['Elaborar internamente até chegar a uma posição própria.', 'I', 'AUT'],
    ['Estudar de forma sistemática antes de concluir qualquer coisa.', 'I', 'EST']
  ]),
  q('Q027', 'FUNCAO', 1, 'execução',
    'Você assume uma entrega com autonomia total. Como começa?', [
    ['Definindo critérios de sucesso e a sequência de etapas.', 'T', 'AUT'],
    ['Alinhando expectativas com quem vai receber o resultado.', 'F', 'COO'],
    ['Fazendo a primeira parte concreta e ajustando a partir dela.', 'S', 'EXE'],
    ['Desenhando o cenário completo antes de tocar em qualquer parte.', 'N', 'EST']
  ]),
  q('Q028', 'ATITUDE', 1, 'inovação',
    'A equipe está buscando ideias novas. Em que situação você produz suas melhores contribuições?', [
    ['Em discussão aberta, no calor da troca com o grupo.', 'E', 'FLE'],
    ['Circulando fora da equipe, vendo como outros resolvem.', 'E', 'EXP'],
    ['Sozinho, com tempo, deixando a ideia amadurecer.', 'I', 'AUT'],
    ['A partir de um método ou referência já organizada.', 'I', 'EST']
  ]),
  q('Q029', 'FUNCAO', 1, 'pressão',
    'Sob forte pressão de tempo, qual recurso você aciona primeiro?', [
    ['Corto pelo critério: defino o essencial e descarto o resto.', 'T', 'AUT'],
    ['Chamo as pessoas certas e divido a carga.', 'F', 'COO'],
    ['Coloco a mão na massa e resolvo o que está na minha frente.', 'S', 'EXE'],
    ['Procuro um caminho alternativo que ninguém tentou ainda.', 'N', 'FLE']
  ]),
  q('Q030', 'ATITUDE', 1, 'conflitos',
    'Há uma tensão não resolvida no ambiente de trabalho. Como você lida?', [
    ['Nomeio a questão abertamente para que possa ser tratada.', 'E', 'COO'],
    ['Movimento a situação: proponho algo concreto que mude a dinâmica.', 'E', 'EXE'],
    ['Observo e busco compreender a origem antes de agir.', 'I', 'AUT'],
    ['Encaminho pelos canais e procedimentos apropriados.', 'I', 'EST']
  ]),
  q('Q031', 'FUNCAO', 1, 'relacionamento',
    'Um colega procura você para falar de uma dificuldade no trabalho. O que você tende a oferecer primeiro?', [
    ['Ajuda a organizar o problema e enxergar as opções com clareza.', 'T', 'AUT'],
    ['Escuta e reconhecimento do que ele está vivendo.', 'F', 'COO'],
    ['Apoio prático: o que dá para fazer hoje para aliviar a situação.', 'S', 'EXE'],
    ['Uma leitura mais ampla do que pode estar por trás daquilo.', 'N', 'EXP']
  ]),
  q('Q032', 'ATITUDE', 1, 'prazos',
    'Faltam poucos dias para uma entrega importante. Como você trabalha nesse período?', [
    ['Aumento o contato com o time, sincronizando com frequência.', 'E', 'COO'],
    ['Acelero e faço o que aparecer, na ordem em que aparecer.', 'E', 'FLE'],
    ['Me isolo para conseguir concentração total no que falta.', 'I', 'AUT'],
    ['Sigo rigorosamente o plano de fechamento que montei antes.', 'I', 'EST']
  ]),
  q('Q033', 'FUNCAO', 1, 'organização',
    'Você precisa colocar ordem em um processo confuso. Por onde começa?', [
    ['Pela lógica do fluxo: o que depende de quê.', 'T', 'EST'],
    ['Pelas pessoas: quem faz o quê e como estão se sentindo nisso.', 'F', 'COO'],
    ['Pelo mapeamento do que existe hoje, exatamente como está.', 'S', 'EXE'],
    ['Pela pergunta de para que esse processo existe, afinal.', 'N', 'AUT']
  ]),
  q('Q034', 'ATITUDE', 1, 'análise',
    'Você recebeu dados complexos para interpretar. Como conduz o trabalho?', [
    ['Discuto os números com outras pessoas enquanto analiso.', 'E', 'COO'],
    ['Manipulo os dados de várias formas até algo aparecer.', 'E', 'FLE'],
    ['Analiso sozinho e apresento quando tiver uma leitura formada.', 'I', 'AUT'],
    ['Sigo um roteiro de análise definido, passo a passo.', 'I', 'EST']
  ]),
  q('Q035', 'FUNCAO', 1, 'divergências',
    'Sua avaliação técnica difere da avaliação do grupo. O que costuma fazer?', [
    ['Explicito o critério que usei e peço que apontem onde ele falha.', 'T', 'EST'],
    ['Procuro entender o que o grupo está valorizando que eu não vi.', 'F', 'FLE'],
    ['Trago as evidências concretas que sustentam minha leitura.', 'S', 'EXE'],
    ['Reformulo a questão de outro jeito para deslocar o debate.', 'N', 'EXP']
  ]),
  q('Q036', 'ATITUDE', 1, 'mudanças',
    'Uma mudança de processo é anunciada para a semana seguinte. Qual é sua reação mais típica?', [
    ['Já começo a testar e a descobrir na prática como vai funcionar.', 'E', 'FLE'],
    ['Procuro as pessoas para entender como cada uma está recebendo isso.', 'E', 'COO'],
    ['Preciso de um tempo para processar antes de me posicionar.', 'I', 'AUT'],
    ['Quero saber o motivo e ver o novo procedimento documentado.', 'I', 'EST']
  ]),
  q('Q037', 'FUNCAO', 1, 'novas oportunidades',
    'Uma oportunidade promissora aparece, mas com informação incompleta. Como você a avalia?', [
    ['Monto o raciocínio de custo, risco e retorno com o que há.', 'T', 'AUT'],
    ['Avalio se ela é compatível com o que consideramos importante.', 'F', 'EST'],
    ['Busco verificar o que é fato e o que é ainda promessa.', 'S', 'EXE'],
    ['Sinto se há algo ali e vou atrás mesmo sem tudo confirmado.', 'N', 'EXP']
  ]),
  q('Q038', 'ATITUDE', 1, 'negociação',
    'Você vai conduzir uma negociação importante. Como se prepara?', [
    ['Converso com pessoas que conhecem o outro lado.', 'E', 'EXP'],
    ['Confio na leitura que vou fazer no próprio momento da conversa.', 'E', 'FLE'],
    ['Reflito sobre os cenários possíveis e defino minha posição sozinho.', 'I', 'AUT'],
    ['Preparo material, números e limites antes de entrar na sala.', 'I', 'EST']
  ]),
  q('Q039', 'FUNCAO', 1, 'tomada de decisão',
    'Uma decisão precisa ser tomada hoje e não há consenso. Como você contribui?', [
    ['Proponho o critério de decisão e aplico.', 'T', 'AUT'],
    ['Busco a formulação que o grupo consiga sustentar junto.', 'F', 'COO'],
    ['Aponto o que já sabemos com certeza e decido a partir daí.', 'S', 'EXE'],
    ['Aponto qual das opções mantém mais portas abertas.', 'N', 'FLE']
  ]),
  q('Q040', 'ATITUDE', 1, 'comunicação',
    'Você precisa comunicar um resultado à organização. Qual formato prefere?', [
    ['Apresentação ao vivo, com espaço para perguntas e discussão.', 'E', 'COO'],
    ['Conversas rápidas e diretas com cada pessoa envolvida.', 'E', 'FLE'],
    ['Um documento bem escrito que a pessoa lê no tempo dela.', 'I', 'AUT'],
    ['Um relatório estruturado, com seções e dados organizados.', 'I', 'EST']
  ]),
  q('Q041', 'FUNCAO', 1, 'aprendizagem',
    'Você errou em algo importante. Como processa esse erro?', [
    ['Reconstituo a lógica da decisão para achar onde ela falhou.', 'T', 'AUT'],
    ['Cuido do efeito que isso teve sobre as pessoas envolvidas.', 'F', 'COO'],
    ['Verifico o que exatamente foi feito e corrijo o que dá para corrigir.', 'S', 'EXE'],
    ['Procuro o padrão: se isso já aconteceu antes de outra forma.', 'N', 'EXP']
  ]),
  q('Q042', 'ATITUDE', 2, 'reuniões',
    'Ao final de um dia inteiro de reuniões e interação, como você costuma se sentir?', [
    ['Com energia: as conversas me deixaram mais ativado.', 'E', 'COO'],
    ['Bem, e com vontade de emendar em alguma coisa prática.', 'E', 'EXE'],
    ['Preciso de um período sozinho para me recompor.', 'I', 'AUT'],
    ['Preciso organizar tudo o que ficou pendente antes de parar.', 'I', 'EST']
  ]),
  q('Q043', 'FUNCAO', 1, 'prioridades',
    'Sua equipe está dispersa em muitas frentes. O que você propõe?', [
    ['Um critério objetivo para hierarquizar e cortar.', 'T', 'EST'],
    ['Uma conversa sobre carga e sobre o que está pesando em cada um.', 'F', 'COO'],
    ['Um levantamento do estado real de cada frente antes de decidir.', 'S', 'EXE'],
    ['Uma revisão do propósito: talvez a lista esteja errada, não a ordem.', 'N', 'FLE']
  ]),
  q('Q044', 'ATITUDE', 1, 'conclusão',
    'Você terminou uma entrega significativa. O que faz em seguida?', [
    ['Compartilho com as pessoas e comemoro junto.', 'E', 'COO'],
    ['Emendo direto na próxima coisa.', 'E', 'EXE'],
    ['Recolho-me um pouco para digerir o que acabou de passar.', 'I', 'AUT'],
    ['Fecho a documentação e os registros antes de seguir.', 'I', 'EST']
  ]),
  q('Q045', 'FUNCAO', 1, 'informações incompletas',
    'Você precisa se posicionar sobre um tema em que faltam dados essenciais. O que faz?', [
    ['Explicito as premissas que estou assumindo e decido sobre elas.', 'T', 'AUT'],
    ['Consulto quem tem experiência prática no assunto.', 'F', 'EXP'],
    ['Espero até ter o dado mínimo verificável.', 'S', 'EXE'],
    ['Trabalho com hipóteses e sigo, ajustando conforme aparecer.', 'N', 'FLE']
  ]),
  q('Q046', 'ATITUDE', 1, 'execução',
    'Um trabalho pode ser feito individualmente ou em dupla, com o mesmo resultado. O que escolhe?', [
    ['Em dupla: a troca constrói o resultado junto com o processo.', 'E', 'COO'],
    ['Em dupla, dividindo em partes e cada um acelerando a sua.', 'E', 'EXE'],
    ['Individualmente: rendo mais sem precisar sincronizar.', 'I', 'AUT'],
    ['Individualmente, seguindo meu próprio método já testado.', 'I', 'EST']
  ]),
  q('Q047', 'FUNCAO', 2, 'mudanças',
    'A equipe precisa abandonar um jeito de trabalhar que funcionava bem. O que mais pesa para você?', [
    ['Se a razão da mudança se sustenta logicamente.', 'T', 'AUT'],
    ['Se as pessoas que construíram aquilo estão sendo consideradas.', 'F', 'COO'],
    ['O que se perde concretamente e o que já está garantido no novo jeito.', 'S', 'EXE'],
    ['O que o novo jeito torna possível e o antigo impedia.', 'N', 'EXP']
  ]),
  q('Q048', 'ATITUDE', 1, 'prioridades',
    'De modo geral, onde você diria que sua atenção se dirige mais naturalmente no trabalho?', [
    ['Ao que está acontecendo em volta: pessoas, movimentos, demandas.', 'E', 'EXP'],
    ['À ação: ao que precisa ser movido e resolvido agora.', 'E', 'EXE'],
    ['Ao meu próprio processamento: ao que aquilo significa e como se organiza.', 'I', 'AUT'],
    ['Ao que precisa ser mantido em ordem, previsível e sob controle.', 'I', 'EST']
  ])
];

/** ---- Índices derivados (usados pelo algoritmo e pela auditoria) ---- */

export const QUESTAO_POR_ID: Record<string, Questao> =
  Object.fromEntries(QUESTOES.map(q => [q.id, q]));

export const ALTERNATIVA_POR_ID: Record<string, Alternativa & { questaoId: string; peso: number }> =
  Object.fromEntries(
    QUESTOES.flatMap(q => q.alternativas.map(a => [a.id, { ...a, questaoId: q.id, peso: q.peso }]))
  );

/**
 * Máximo teórico por polo = soma dos pesos dos itens em que o polo aparece.
 * Usado para converter contagem bruta em ESCORE RELATIVO INTERNO (item 17).
 * Calcular a partir do banco elimina qualquer viés de desbalanceamento: um polo
 * que aparece em menos itens não é penalizado.
 */
export const MAXIMO_POR_POLO_JUNG: Record<PoloJung, number> = (() => {
  const m: Record<string, number> = { E: 0, I: 0, T: 0, F: 0, S: 0, N: 0 };
  for (const qq of QUESTOES) {
    const polos = new Set(qq.alternativas.map(a => a.jung));
    for (const p of polos) m[p] += qq.peso;
  }
  return m as Record<PoloJung, number>;
})();

export const MAXIMO_POR_EIXO: Record<EixoAux, number> = (() => {
  const m: Record<string, number> = { EXP: 0, EXE: 0, AUT: 0, COO: 0, FLE: 0, EST: 0 };
  for (const qq of QUESTOES) {
    const polos = new Set(qq.alternativas.map(a => a.eixo));
    for (const p of polos) m[p] += qq.peso;
  }
  return m as Record<EixoAux, number>;
})();

/** Total de pesos por tipo de item — denominador dos escores junguianos. */
export const PESO_TOTAL_FUNCAO = QUESTOES.filter(q => q.tipo === 'FUNCAO').reduce((s, q) => s + q.peso, 0);
export const PESO_TOTAL_ATITUDE = QUESTOES.filter(q => q.tipo === 'ATITUDE').reduce((s, q) => s + q.peso, 0);
