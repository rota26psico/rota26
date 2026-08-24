/**
 * CONTEÚDO INTERPRETATIVO DA TRILHA FUNCIONAL (itens 15 a 19 e 32)
 * ---------------------------------------------------------------------------
 * Texto fixo, revisado, associado a cada capacidade e a cada papel de Belbin.
 * A IA pode reescrever a partir daqui, mas nunca alterar escores nem posições.
 *
 * Fonte da caracterização dos papéis: MIRANDA & VASCONCELOS, "A 'teoria da
 * equipe' de Meredith Belbin na percepção de gestores decisores", Pretexto
 * v.21 n.3, FUMEC, 2020 — Tabela 01 (características e função, fonte Belbin 2014).
 */
import type { Capacidade, PapelBelbin } from './functional';

export interface ConteudoCapacidade {
  significado: string;
  noTrabalho: string;
  quandoUtil: string;
  /** Sugestões de aproveitamento (item 32) — só exibidas quando o escore sustenta. */
  aproveitar: string;
}

export const CONTEUDO_CAPACIDADE: Record<Capacidade, ConteudoCapacidade> = {
  CRIAR: {
    significado: 'Gerar ideias e soluções, desafiando as formas convencionais de fazer as coisas.',
    noTrabalho: 'Aparece como propostas que reenquadram o problema, alternativas que ninguém tinha levantado e desconforto produtivo com a resposta óbvia.',
    quandoUtil: 'Em problemas antigos que resistem às soluções conhecidas, no início de projetos e quando o caminho habitual se esgotou.',
    aproveitar: 'convidar para a etapa de geração de alternativas, antes de o escopo fechar'
  },
  EXPLORAR: {
    significado: 'Buscar oportunidades e recursos fora da fronteira imediata do trabalho.',
    noTrabalho: 'Aparece como contatos que se transformam em caminhos, informação trazida de fora e leitura de oportunidade antes de ela ficar evidente.',
    quandoUtil: 'Em prospecção, parcerias, negociação e sempre que a solução depende de algo que a equipe ainda não tem.',
    aproveitar: 'envolver em prospecção, benchmarking e articulação com outras áreas'
  },
  ANALISAR: {
    significado: 'Avaliar criticamente ideias e problemas, ponderando as opções antes da decisão.',
    noTrabalho: 'Aparece como perguntas que expõem premissas frágeis, comparação sistemática de alternativas e identificação de inconsistências.',
    quandoUtil: 'Em decisões complexas, avaliação de risco, revisão de propostas e análise de projetos.',
    aproveitar: 'envolver na avaliação crítica de propostas antes das decisões relevantes'
  },
  DECIDIR: {
    significado: 'Impulsionar a ação e enfrentar obstáculos, sustentando a decisão sob pressão.',
    noTrabalho: 'Aparece como disposição de assumir a escolha quando não há consenso, energia para destravar impasses e tolerância ao atrito necessário.',
    quandoUtil: 'Em situações de urgência, impasse prolongado e quando a análise já cumpriu seu papel.',
    aproveitar: 'atribuir a responsabilidade por decisões que estão paradas há tempo demais'
  },
  ORGANIZAR: {
    significado: 'Estruturar e transformar decisões em processos práticos e aplicáveis.',
    noTrabalho: 'Aparece como sequência de etapas, definição de responsáveis e critérios, e conversão de intenção em plano executável.',
    quandoUtil: 'Na passagem da decisão para a operação, em projetos com muitas dependências e na criação de rotinas.',
    aproveitar: 'utilizar na estruturação de processos e no desenho de planos de trabalho'
  },
  EXECUTAR: {
    significado: 'Colocar decisões em prática de forma confiável e disciplinada.',
    noTrabalho: 'Aparece como entregas que saem, contato direto com a realidade do trabalho e capacidade de fazer andar o que estava parado.',
    quandoUtil: 'Em implantação, operação, campo e situações que exigem resposta concreta rápida.',
    aproveitar: 'utilizar em implantação e nas frentes que precisam sair do papel'
  },
  RELACIONAR: {
    significado: 'Favorecer cooperação e equilíbrio interpessoal, resolvendo tensões entre pessoas.',
    noTrabalho: 'Aparece como leitura precoce de desconforto, escuta que faz problemas emergirem antes de estourarem e cuidado com o vínculo durante o conflito.',
    quandoUtil: 'Em momentos de tensão, integração de pessoas novas, mudanças que afetam rotinas e equipes em reconstrução.',
    aproveitar: 'envolver na integração de pessoas e na condução de conversas difíceis'
  },
  COORDENAR: {
    significado: 'Integrar pessoas e objetivos, reconhecendo talentos e articulando esforços.',
    noTrabalho: 'Aparece como alinhamento entre frentes, distribuição consciente de responsabilidades e capacidade de fazer o grupo convergir.',
    quandoUtil: 'Em projetos multiárea, quando há muitas pessoas envolvidas e quando as frentes começam a se desencontrar.',
    aproveitar: 'utilizar na articulação entre frentes e no alinhamento de expectativas'
  },
  FINALIZAR: {
    significado: 'Garantir qualidade, detalhes e conclusão efetiva do que foi iniciado.',
    noTrabalho: 'Aparece como revisão minuciosa, identificação de pontas soltas e recusa em dar por encerrado o que ainda não está.',
    quandoUtil: 'Nas etapas finais, em entregas que exigem padrão elevado e sempre que a equipe tende a iniciar mais do que conclui.',
    aproveitar: 'utilizar na revisão final e no fechamento formal das entregas'
  },
  ESPECIALIZAR: {
    significado: 'Fornecer conhecimento técnico aprofundado e orientar os demais em um domínio.',
    noTrabalho: 'Aparece como referência interna sobre um assunto, memória do que já foi tentado e profundidade que não se improvisa.',
    quandoUtil: 'Em questões técnicas específicas, decisões que exigem domínio acumulado e formação de outras pessoas.',
    aproveitar: 'consultar como referência técnica e envolver na formação de outras pessoas'
  }
};

export interface ConteudoBelbin {
  contribuicao: string;
  ondeAgrega: string[];
  comoAparece: string;
  excesso: string;
  complementaridade: string;
}

export const CONTEUDO_BELBIN: Record<PapelBelbin, ConteudoBelbin> = {
  PLANTA: {
    contribuicao: 'Produz ideias originais e soluções para problemas complexos, desafiando as formas convencionais e estabelecidas de fazer as coisas.',
    ondeAgrega: ['problemas sem solução conhecida', 'reformulação de abordagens', 'etapas iniciais de projeto', 'desenho de novas alternativas'],
    comoAparece: 'Costuma trabalhar a certa distância dos demais e trazer contribuições concentradas, que reposicionam a discussão em vez de acrescentar mais um item a ela.',
    excesso: 'As ideias podem permanecer no plano da possibilidade sem encontrar caminho de execução, e a comunicação pode não ser convincente para quem precisa implementá-las — Belbin observa que o papel nem sempre consegue se comunicar de forma persuasiva.',
    complementaridade: 'Recursos voltados à organização, à execução e ao fechamento ajudam a converter a ideia em algo que funcione na prática.'
  },
  INV_RECURSOS: {
    contribuicao: 'Explora oportunidades, desenvolve contatos e traz para dentro da equipe informação e recursos que estão fora dela.',
    ondeAgrega: ['prospecção e parcerias', 'negociação', 'busca de referências externas', 'destravamento de impasses'],
    comoAparece: 'Costuma ser entusiasmado e comunicativo, construindo rede com facilidade e reagindo rápido a novas possibilidades.',
    excesso: 'O entusiasmo pode desaparecer rapidamente depois do início, deixando frentes abertas para outras pessoas sustentarem.',
    complementaridade: 'Recursos de consistência, detalhe e conclusão ajudam a sustentar o que foi aberto.'
  },
  COORDENADOR: {
    contribuicao: 'Integra pessoas e objetivos, delega com naturalidade e é rápido em detectar talentos individuais e usá-los em busca dos objetivos do grupo.',
    ondeAgrega: ['projetos com muitas pessoas', 'alinhamento entre frentes', 'distribuição de responsabilidades', 'condução de reuniões decisórias'],
    comoAparece: 'Costuma ser maduro e confiante, criando as condições para que o grupo funcione em vez de executar diretamente.',
    excesso: 'A articulação pode ser percebida como manipulação quando os objetivos pessoais não estão explícitos, e pode chocar-se com estilos mais diretivos.',
    complementaridade: 'Recursos de análise crítica e de execução concreta equilibram a condução com substância técnica e entrega.'
  },
  FORMADOR: {
    contribuicao: 'Impulsiona a ação, supera obstáculos por determinação e exige decisões rápidas para enfrentar ameaças e dificuldades.',
    ondeAgrega: ['situações de urgência', 'impasses prolongados', 'metas exigentes', 'ambientes sob pressão'],
    comoAparece: 'Costuma ser assertivo e direcionado, aumentando o ritmo do grupo e tolerando o atrito necessário para decidir.',
    excesso: 'Pode tornar-se argumentativo ou provocar reações, e a pressa pode atropelar a análise e o cuidado com as pessoas.',
    complementaridade: 'Recursos de análise, escuta e cuidado relacional ajudam a manter a qualidade da decisão e a adesão do grupo.'
  },
  MONITOR: {
    contribuicao: 'Analisa possibilidades com cuidado, compara alternativas e identifica inconsistências antes da decisão.',
    ondeAgrega: ['avaliação de riscos', 'análise de projetos', 'revisão de propostas', 'decisões complexas'],
    comoAparece: 'Costuma ser sério e prudente, trabalhando com fatos e lógica em vez de entusiasmo, e ponderando as opções pró e contra.',
    excesso: 'A análise pode prolongar-se excessivamente ou reduzir a velocidade da decisão, e a crítica pode desmotivar quem propôs.',
    complementaridade: 'Recursos voltados à mobilização, à exploração e à execução ajudam a transformar análise em movimento.'
  },
  IMPLEMENTADOR: {
    contribuicao: 'Transforma decisões em ação organizada, com método, disciplina e confiabilidade.',
    ondeAgrega: ['implantação', 'estruturação de processos', 'rotinas operacionais', 'projetos que precisam sair do papel'],
    comoAparece: 'Costuma ser prático e autocontrolado, sistemático no modo de trabalhar e confiável na aplicação do que foi combinado.',
    excesso: 'Pode ser inflexível ao aceitar novas formas de fazer as coisas e favorecer o que já domina em detrimento do que é necessário.',
    complementaridade: 'Recursos de exploração e de geração de alternativas ajudam a evitar que o método se torne o limite.'
  },
  TRAB_EQUIPE: {
    contribuicao: 'Sustenta a cooperação, resolve tensões interpessoais e mantém o grupo capaz de trabalhar junto.',
    ondeAgrega: ['situações tensas', 'integração de pessoas', 'mudanças que afetam rotinas', 'equipes em reconstrução'],
    comoAparece: 'Costuma ser perceptivo, diplomático e bom ouvinte, adaptando-se a diferentes situações e pessoas.',
    excesso: 'A preocupação com a harmonia pode adiar conversas necessárias e levar a evitar conflitos que precisariam acontecer.',
    complementaridade: 'Recursos de critério explícito e de mobilização ajudam a converter cuidado relacional em posição e decisão.'
  },
  FINALIZADOR: {
    contribuicao: 'Garante padrão e conclusão: atento aos detalhes, confiável para concluir trabalhos de alto padrão dentro do prazo.',
    ondeAgrega: ['etapas finais', 'controle de qualidade', 'entregas com padrão elevado', 'revisão antes da publicação'],
    comoAparece: 'Costuma ser esforçado e minucioso, percebendo o que ficou solto e sustentando o nível até o fim.',
    excesso: 'A busca de perfeição pode gerar ansiedade, dificultar o encerramento e criar relutância em delegar.',
    complementaridade: 'Recursos de mobilização e de visão de conjunto ajudam a definir quando o suficiente já foi alcançado.'
  },
  ESPECIALISTA: {
    contribuicao: 'Fornece conhecimento técnico aprofundado e orienta os demais a partir dele.',
    ondeAgrega: ['questões técnicas específicas', 'decisões que exigem domínio acumulado', 'formação de outras pessoas', 'pareceres'],
    comoAparece: 'Costuma acumular conhecimento em um domínio e ser procurado como referência quando o assunto aparece.',
    excesso: 'Pode contribuir apenas em uma faixa estreita e tornar-se pouco flexível quando o próprio conhecimento é questionado.',
    complementaridade: 'Recursos de articulação e de visão de conjunto ajudam o conhecimento a circular e a se conectar ao todo.'
  }
};

/** Item 11 — as dez leituras de "Como você tende a funcionar". */
export const DIMENSOES_FUNCIONAMENTO = [
  { id: 'perceber', titulo: 'Como você tende a perceber situações' },
  { id: 'decidir', titulo: 'Como tende a tomar decisões' },
  { id: 'informacao', titulo: 'Como lida com informações novas' },
  { id: 'problemas', titulo: 'Como tende a resolver problemas' },
  { id: 'mudancas', titulo: 'Como funciona diante de mudanças' },
  { id: 'comunicar', titulo: 'Como tende a se comunicar' },
  { id: 'grupo', titulo: 'Como atua em grupo' },
  { id: 'pressao', titulo: 'Como trabalha sob pressão' },
  { id: 'organizar', titulo: 'Como organiza e executa' },
  { id: 'conflitos', titulo: 'Como costuma lidar com conflitos' }
] as const;

export type DimensaoFuncionamento = typeof DIMENSOES_FUNCIONAMENTO[number]['id'];
