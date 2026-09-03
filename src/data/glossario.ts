/**
 * GLOSSÁRIO — LEITURA DE TODAS AS SIGLAS
 * ===========================================================================
 * Cada verbete responde a TRÊS perguntas, nesta ordem:
 *
 *   o que é        — a expansão e o significado, em uma frase;
 *   por que assim  — a RAZÃO da escolha. É esta parte que costuma faltar em
 *                    instrumento de perfil, e é a que sustenta a confiança:
 *                    quem lê precisa poder discordar de um critério, e para
 *                    isso precisa saber qual é;
 *   onde aparece   — em que tela o leitor encontra o termo.
 *
 * ESTE ARQUIVO NÃO PARTICIPA DE NENHUM CÁLCULO. É texto explicativo. Alterar
 * qualquer linha daqui não muda um único escore — o que é justamente o motivo
 * de o glossário poder ser revisado sem versionar o instrumento.
 *
 * Quando um número é fruto de escolha e não de medição, o verbete DIZ isso.
 */

export type GrupoGlossario =
  | 'indices' | 'jung' | 'perfis' | 'eixos' | 'capacidades' | 'belbin' | 'tecnicos';

export interface Verbete {
  /** A sigla ou código como aparece na tela. */
  sigla: string;
  /** Por extenso. */
  nome: string;
  grupo: GrupoGlossario;
  oQueE: string;
  porQue: string;
  /** Só quando existe fórmula. Escrita como se lê, não como código. */
  formula?: string;
  ondeAparece: string;
}

export const NOME_GRUPO: Record<GrupoGlossario, string> = {
  indices: 'Índices coletivos',
  jung: 'Atitudes e funções de Jung',
  perfis: 'Os oito perfis',
  eixos: 'Os seis eixos comportamentais',
  capacidades: 'As dez capacidades funcionais',
  belbin: 'Os nove papéis de referência (Belbin)',
  tecnicos: 'Termos técnicos e de administração'
};

export const GLOSSARIO: Verbete[] = [

  /* ═══════════════════════ ÍNDICES COLETIVOS ═══════════════════════════ */
  {
    sigla: 'IDF', nome: 'Índice de Diversidade Funcional', grupo: 'indices',
    oQueE:
      'Mede, de 0 a 100, quanta variedade de perspectivas existe em uma equipe. ' +
      'Não mede qualidade, competência nem desempenho: mede variedade.',
    formula:
      '25% entropia da distribuição dos 8 perfis + 25% entropia da distribuição das 4 funções ' +
      'dominantes + 50% dispersão real dos 22 escores contínuos de cada participante.',
    porQue:
      'Os 50% da dispersão são a parte que mais importa, e existem por um motivo prático: contar ' +
      'rótulos é grosseiro. Duas equipes podem ter exatamente a mesma contagem de "três Lobos e dois ' +
      'Ursos" e ser muito diferentes por dentro, porque o rótulo esconde a distância entre os escores ' +
      'que o produziram. A dispersão olha os números reais, não a etiqueta. As entropias entram com ' +
      'peso menor porque continuam sendo informação útil — variedade de rótulos importa —, mas seriam ' +
      'uma leitura pobre se usadas sozinhas.',
    ondeAparece: 'Dashboard da equipe, seções Síntese e Diversidade. Visão geral. Excel, aba Indicadores.'
  },
  {
    sigla: 'ICF', nome: 'Índice de Cobertura Funcional', grupo: 'indices',
    oQueE:
      'Mede, de 0 a 100, se a equipe possui os recursos comportamentais que o trabalho coletivo exige. ' +
      'É calculado capacidade por capacidade — são dez — e o índice é a média das dez.',
    formula:
      'Por capacidade: 70% × (portadores ÷ alvo, limitado a 1) + 30% × (média da equipe ÷ 100). ' +
      'Alvo = 1 portador a cada 8 pessoas, no mínimo 1. Portador = escore relativo igual ou maior que 50.',
    porQue:
      'Os 70% priorizam PRESENÇA em vez de média, e isso é deliberado: para uma equipe entregar, importa ' +
      'mais existir alguém realmente forte em finalizar do que a equipe inteira ser mediana nisso. Uma ' +
      'média confortável pode esconder que ninguém sustenta a capacidade de fato. Os 30% da média existem ' +
      'para o efeito contrário — impedir que uma única pessoa carregue a capacidade sozinha e o número ' +
      'pareça saudável. O alvo de 1 a cada 8 evita que equipes grandes pareçam melhor cobertas apenas ' +
      'por serem grandes.',
    ondeAparece: 'Dashboard da equipe, seções Síntese e Cobertura. Visão geral. Excel, aba Indicadores.'
  },
  {
    sigla: 'IDF × ICF', nome: 'Por que são dois índices, e não um', grupo: 'indices',
    oQueE:
      'São independentes: medem coisas diferentes e podem andar em direções opostas.',
    porQue:
      'Uma equipe pode ter IDF alto e ICF baixo — gente muito diferente entre si e, ainda assim, ninguém ' +
      'forte naquilo que o trabalho exige. E o contrário acontece: equipe homogênea que cobre bem ' +
      'exatamente o que precisa cobrir. Um número único esconderia essa distinção, que costuma ser a ' +
      'informação mais útil da análise.',
    ondeAparece: 'Dashboard da equipe, aviso "Como ler os dois índices".'
  },
  {
    sigla: 'Complementaridade', nome: 'Capacidades com ao menos um portador', grupo: 'indices',
    oQueE:
      'Percentual das dez capacidades que têm ao menos uma pessoa acima do limiar de portador.',
    formula: 'capacidades com pelo menos 1 portador ÷ 10 × 100.',
    porQue:
      'Responde a uma pergunta diferente da do ICF. O ICF pergunta "quão bem coberto está?"; a ' +
      'complementaridade pergunta "existe alguém, ainda que uma pessoa só?". Uma equipe pode ter 100% de ' +
      'complementaridade e ICF baixo: todas as capacidades têm um portador, mas quase sempre apenas um. ' +
      'Isso é fragilidade concentrada, e é útil enxergar separadamente.',
    ondeAparece: 'Dashboard da equipe, seção Síntese. Excel, aba Indicadores.'
  },
  {
    sigla: 'HHI', nome: 'Índice de concentração (Herfindahl-Hirschman)', grupo: 'indices',
    oQueE:
      'Mede, de 0 a 1, o quanto a equipe está concentrada em poucos perfis. Quanto mais próximo de 1, ' +
      'mais gente no mesmo perfil.',
    formula: 'soma dos quadrados das proporções de cada um dos 8 perfis.',
    porQue:
      'É a medida de concentração usada em economia para avaliar mercados, e serve aqui pelo mesmo ' +
      'motivo: elevar ao quadrado faz o índice reagir com força quando UM grupo domina, e pouco quando a ' +
      'distribuição é equilibrada. Concentração não é problema em si — pode significar alinhamento e ' +
      'linguagem comum. O índice apenas torna o fato visível.',
    ondeAparece: 'Dashboard da equipe, seção Síntese ("Principal concentração") e Interpretação.'
  },
  {
    sigla: 'n', nome: 'Número de respondentes', grupo: 'indices',
    oQueE: 'Quantas pessoas do grupo concluíram as 48 situações e entram na análise.',
    porQue:
      'Aparece sempre ao lado dos índices porque IDF e ICF calculados sobre poucas pessoas são instáveis: ' +
      'uma resposta a mais muda muito. Abaixo de 5 respondentes o sistema não exibe distribuição ' +
      'detalhada — não por rigor estatístico, mas por privacidade: em grupo pequeno, a distribuição ' +
      'permitiria identificar quem é quem.',
    ondeAparece: 'Todos os dashboards, ao lado de cada indicador.'
  },

  /* ═══════════════════════ ATITUDES E FUNÇÕES ══════════════════════════ */
  {
    sigla: 'E', nome: 'Extroversão', grupo: 'jung',
    oQueE:
      'Atitude em que a atenção se dirige primeiro ao mundo externo — pessoas, ação, acontecimentos. ' +
      'A energia tende a crescer no contato.',
    porQue:
      'Em Jung, extroversão e introversão são a direção habitual da atenção, não sociabilidade. Uma pessoa ' +
      'extrovertida pode ser tímida, e uma introvertida pode ser excelente em público. O instrumento mede ' +
      'para onde a atenção vai primeiro, não o quanto a pessoa fala.',
    ondeAparece: 'Resultado individual, bloco 3. Dashboard, seção Composição. Excel.'
  },
  {
    sigla: 'I', nome: 'Introversão', grupo: 'jung',
    oQueE:
      'Atitude em que a atenção se dirige primeiro ao mundo interno — impressão, elaboração, sentido. ' +
      'A energia tende a se recompor no recolhimento.',
    porQue:
      'Mesmo par conceitual do verbete anterior. Vale repetir o que ele NÃO é: introversão não é timidez, ' +
      'dificuldade social nem preferência por ficar sozinho. É a direção para a qual a atenção se volta ' +
      'antes de responder.',
    ondeAparece: 'Resultado individual, bloco 3. Dashboard, seção Composição. Excel.'
  },
  {
    sigla: 'T', nome: 'Pensamento', grupo: 'jung',
    oQueE:
      'Função de julgamento que organiza a realidade por critério lógico: consistência, causa, princípio.',
    porQue:
      'A letra vem de "Thinking". As quatro funções usam as iniciais da convenção internacional, e não as ' +
      'do português, por uma razão concreta: em português, Pensamento, Sentimento, Sensação e Intuição ' +
      'produziriam P, S, S e I — duas colisões em quatro letras. As letras T, F, S e N são inequívocas e ' +
      'permitem comparar com a literatura.',
    ondeAparece: 'Resultado individual, bloco 3. Excel, aba Resultados Jung.'
  },
  {
    sigla: 'F', nome: 'Sentimento', grupo: 'jung',
    oQueE:
      'Função de julgamento que organiza a realidade por valor: o que importa, para quem, a que custo humano.',
    porQue:
      'A letra vem de "Feeling". E aqui cabe um cuidado que o instrumento faz questão de manter: em Jung, ' +
      'Sentimento é uma função RACIONAL de julgamento — avalia por critério de valor —, e não emoção. ' +
      'Confundir os dois é o erro de leitura mais comum na tipologia.',
    ondeAparece: 'Resultado individual, bloco 3. Excel, aba Resultados Jung.'
  },
  {
    sigla: 'S', nome: 'Sensação', grupo: 'jung',
    oQueE:
      'Função de percepção que capta o dado concreto: o que está presente, verificável, observável agora.',
    porQue:
      'A letra vem de "Sensation". Percepção e julgamento são categorias distintas em Jung: Sensação e ' +
      'Intuição apenas CAPTAM; Pensamento e Sentimento DECIDEM. O instrumento preserva essa separação — ' +
      'por isso a função auxiliar sempre vem do par oposto ao da dominante.',
    ondeAparece: 'Resultado individual, bloco 3. Excel, aba Resultados Jung.'
  },
  {
    sigla: 'N', nome: 'Intuição', grupo: 'jung',
    oQueE:
      'Função de percepção que capta possibilidade, padrão e desdobramento — o que ainda não está dado.',
    porQue:
      'A letra vem de "iNtuition", com N e não I, porque o I já designa Introversão. É uma convenção ' +
      'herdada, e o instrumento a mantém para não criar um dialeto próprio que dificultaria comparação ' +
      'com a literatura.',
    ondeAparece: 'Resultado individual, bloco 3. Excel, aba Resultados Jung.'
  },
  {
    sigla: 'Função dominante', nome: 'A função mais presente', grupo: 'jung',
    oQueE: 'A função com maior escore — a que organiza o modo habitual de entrar nos problemas.',
    porQue:
      'É ela que define o perfil, junto com a atitude. Ser dominante não significa ser melhor: significa ' +
      'ser a primeira a aparecer, inclusive quando outra seria mais adequada à situação.',
    ondeAparece: 'Resultado individual, blocos 1 e 3.'
  },
  {
    sigla: 'Função auxiliar', nome: 'A função de apoio', grupo: 'jung',
    oQueE: 'A segunda função mais presente, obrigatoriamente do par oposto ao da dominante.',
    porQue:
      'A restrição não é conveniência de cálculo, é regra junguiana: se a dominante percebe (S ou N), a ' +
      'auxiliar precisa julgar (T ou F), e vice-versa. Uma pessoa não funciona apenas percebendo ou ' +
      'apenas julgando. É essa regra que produz o perfil secundário.',
    ondeAparece: 'Resultado individual, bloco 1. Excel, aba Resultados Jung.'
  },
  {
    sigla: 'Função inferior', nome: 'A oposta da dominante', grupo: 'jung',
    oQueE:
      'A função oposta à dominante. É a base de toda a leitura de sombra e de comportamento sob pressão.',
    porQue:
      'Em Jung, quanto mais desenvolvida a dominante, menos elaborada tende a ser a sua oposta — e é ela ' +
      'que costuma irromper de forma desproporcional sob tensão. Por isso a seção de sombra NUNCA é uma ' +
      'lista de defeitos: ela é derivada da própria força e da função inferior correspondente.',
    ondeAparece: 'Resultado individual, bloco 5. Excel, aba Resultados Jung.'
  },
  {
    sigla: 'Escore relativo', nome: 'Escore relativo interno', grupo: 'jung',
    oQueE:
      'Valor de 0 a 100 que indica a participação de um polo no conjunto das SUAS próprias respostas.',
    porQue:
      'É relativo a você, não a uma população. O instrumento não foi normatizado: não existe amostra de ' +
      'referência, portanto não existe percentil. Um Pensamento 62 significa que Pensamento ocupou 62% do ' +
      'espaço possível nas suas respostas — e não que você pensa mais que 62% das pessoas. Dizer o ' +
      'contrário seria inventar uma norma que não foi medida.',
    ondeAparece: 'Resultado individual, bloco 3, e em todo lugar onde aparece um número de 0 a 100.'
  },
  {
    sigla: 'Empate', nome: 'Empate entre funções', grupo: 'jung',
    oQueE:
      'Ocorre quando duas funções terminam com o mesmo escore e uma cascata explícita de três degraus decide ' +
      'qual delas vale. Acontece em dois lugares: na função dominante, que define a tendência predominante, e ' +
      'no par auxiliar, que define a secundária.',
    porQue:
      'O instrumento poderia esconder o empate e simplesmente entregar um resultado. Ele prefere declarar, ' +
      'porque a informação importa para quem lê: um resultado que veio de desempate descreve uma tendência ' +
      'MENOS definida, e as duas funções empatadas são recursos reais da pessoa. A regra aplicada aparece ' +
      'na tela e fica gravada no banco. Os três degraus, sempre nesta ordem: D1 vence a função cuja oposta ' +
      'tem o menor escore; D2 desempata por evidência convergente nos eixos comportamentais; D3 recorre à ' +
      'ordem canônica fixa, e o texto diz que esse último é arbitrário. Empate de atitude, por sinal, é ' +
      'impossível: a soma dos pesos é ímpar (27), de propósito.',
    ondeAparece: 'Resultado individual, bloco 1, quando ocorre. Excel e Metodologia.'
  },

  /* ═══════════════════════════ OS OITO PERFIS ══════════════════════════ */
  ...([
    ['Te', 'Pensamento Extrovertido', 'Lobo', 'Organiza a realidade externa por critério lógico e espera que o sistema seja seguido.'],
    ['Ti', 'Pensamento Introvertido', 'Elefante', 'Constrói coerência interna e só se manifesta quando o raciocínio fecha.'],
    ['Fe', 'Sentimento Extrovertido', 'Carneiro', 'Lê o clima do grupo e trabalha pela harmonia e pelo vínculo.'],
    ['Fi', 'Sentimento Introvertido', 'Baleia', 'Decide por valor pessoal profundo, mesmo quando não o verbaliza.'],
    ['Se', 'Sensação Extrovertida', 'Cavalo', 'Responde ao concreto imediato, com energia e presença física.'],
    ['Si', 'Sensação Introvertida', 'Urso', 'Ancora no que já foi verificado; memória detalhada e ritmo próprio.'],
    ['Ne', 'Intuição Extrovertida', 'Raposa', 'Enxerga possibilidade onde os outros veem obstáculo; conecta o que estava solto.'],
    ['Ni', 'Intuição Introvertida', 'Onça', 'Chega à síntese por dentro, muitas vezes sem mostrar o percurso.']
  ] as const).map(([id, nome, animal, sintese]): Verbete => ({
    sigla: id, nome: `${nome} — ${animal}`, grupo: 'perfis',
    oQueE: `${sintese} O código combina a função dominante em maiúscula com a atitude em minúscula.`,
    porQue:
      `Lê-se assim: ${id[0]} é a função dominante e "${id[1]}" é a atitude — ` +
      `${id[1] === 'e' ? 'extrovertida' : 'introvertida'}. ` +
      'A notação existe para caber em tabela e em coluna de planilha sem ambiguidade. ' +
      `O animal (${animal}) é METÁFORA DIDÁTICA de comportamento, escolhida por correspondência com a ` +
      'configuração — nunca uma classificação da pessoa. O sistema jamais escreve "você é um animal"; ' +
      'escreve "sua maior correspondência simbólica".',
    ondeAparece: 'Resultado individual, bloco 1. Composição simbólica. Painel nominal. Excel.'
  })),

  /* ══════════════════════════ OS SEIS EIXOS ════════════════════════════ */
  ...([
    ['EXP', 'Exploração', 'EXE',
      'Buscar o que está fora do escopo imediato: informação nova, contato, alternativa ainda não considerada.'],
    ['EXE', 'Execução', 'EXP',
      'Levar adiante o que já foi definido, com disciplina e continuidade.'],
    ['AUT', 'Autonomia', 'COO',
      'Agir por conta própria, decidir sem precisar de validação a cada passo.'],
    ['COO', 'Cooperação', 'AUT',
      'Construir com os outros, buscar acordo e apoio antes de avançar.'],
    ['FLE', 'Flexibilidade', 'EST',
      'Ajustar-se à mudança de rumo, tolerar o que ainda está aberto.'],
    ['EST', 'Estrutura', 'FLE',
      'Preferir plano, padrão e previsibilidade; fechar o que está em aberto.']
  ] as const).map(([id, nome, oposto, oQueE]): Verbete => ({
    sigla: id, nome, grupo: 'eixos', oQueE,
    porQue:
      `Os seis eixos formam TRÊS PARES DE OPOSTOS — este forma par com ${oposto}. São lidos aos pares, e ` +
      'não isoladamente, porque um escore alto aqui significa necessariamente menos espaço para o polo ' +
      'oposto: os dois dividem os mesmos itens. Nenhum polo é melhor que o outro — a barra mostra para ' +
      'que lado a pessoa tende, não o quanto ela vale. Os eixos são a matéria-prima da trilha funcional, ' +
      'que é calculada em paralelo à trilha junguiana e não deriva dela.',
    ondeAparece: 'Resultado individual, bloco 3. Dashboard, seção Diversidade. Excel.'
  })),

  /* ═══════════════════════ AS DEZ CAPACIDADES ══════════════════════════ */
  ...([
    ['CRIAR', 'Criar', 'Planta'],
    ['EXPLORAR', 'Explorar', 'Investigador de Recursos'],
    ['ANALISAR', 'Analisar', 'Monitor Avaliador'],
    ['DECIDIR', 'Decidir / Mobilizar', 'Formador'],
    ['ORGANIZAR', 'Organizar', 'Implementador'],
    ['EXECUTAR', 'Executar', 'Implementador'],
    ['RELACIONAR', 'Relacionar', 'Trabalhador em Equipe'],
    ['COORDENAR', 'Coordenar', 'Coordenador'],
    ['FINALIZAR', 'Finalizar', 'Finalizador'],
    ['ESPECIALIZAR', 'Especializar', 'Especialista']
  ] as const).map(([id, nome, belbin]): Verbete => ({
    sigla: id, nome, grupo: 'capacidades',
    oQueE:
      `Uma das dez capacidades funcionais do trabalho coletivo. Referência funcional: ${belbin}.`,
    porQue:
      'As capacidades são calculadas a partir do CONTEÚDO COMPORTAMENTAL de cada alternativa escolhida, ' +
      'e não do perfil junguiano. É por isso que duas pessoas com o mesmo perfil podem ter configurações ' +
      'funcionais bem diferentes — as duas trilhas partem das mesmas 48 respostas, mas nenhuma deriva da ' +
      'outra. Na versão anterior do instrumento isso não era verdade, e a correção foi a mudança central ' +
      'da v2.0.',
    ondeAparece: 'Resultado individual, bloco 6. Dashboard, seção Cobertura. Excel.'
  })),

  /* ══════════════════════ OS NOVE PAPÉIS BELBIN ════════════════════════ */
  {
    sigla: 'Belbin', nome: 'Papéis de Equipe de Meredith Belbin', grupo: 'belbin',
    oQueE:
      'Referencial que descreve nove contribuições funcionais distintas dentro de uma equipe.',
    porQue:
      'Belbin entra aqui como REFERÊNCIA FUNCIONAL, não como um terceiro teste de personalidade. O que o ' +
      'instrumento apresenta é PROXIMIDADE entre os comportamentos observados nas 48 situações e as ' +
      'contribuições que Belbin descreve. Não corresponde à aplicação do instrumento oficial de Belbin e ' +
      'não implica equivalência entre os modelos. Uma pessoa nunca "é" um papel.',
    ondeAparece: 'Resultado individual, bloco 7. Dashboard, seção Cobertura. Excel.'
  },
  ...([
    ['PLANTA', 'Planta', 'tarefa'],
    ['INV_RECURSOS', 'Investigador de Recursos', 'relacionamento'],
    ['COORDENADOR', 'Coordenador', 'relacionamento'],
    ['FORMADOR', 'Formador', 'tarefa'],
    ['MONITOR', 'Monitor Avaliador', 'tarefa'],
    ['IMPLEMENTADOR', 'Implementador', 'tarefa'],
    ['TRAB_EQUIPE', 'Trabalhador em Equipe', 'relacionamento'],
    ['FINALIZADOR', 'Finalizador', 'tarefa'],
    ['ESPECIALISTA', 'Especialista', 'tarefa']
  ] as const).map(([id, nome, dimensao]): Verbete => ({
    sigla: id, nome, grupo: 'belbin',
    oQueE: `Papel da dimensão ${dimensao}. Nas planilhas aparece com o código ${id}.`,
    porQue:
      `A separação entre dimensão de TAREFA e de RELACIONAMENTO importa na leitura de equipe: um grupo ` +
      'pode ter cobertura alta em tudo que é entrega e baixa em tudo que sustenta convivência, e o ' +
      'resultado disso aparece meses depois. ' +
      (id.includes('_')
        ? 'O código usa sublinhado porque é identificador de coluna em planilha e em banco, onde espaço em branco atrapalha.'
        : 'O código é a forma abreviada usada em coluna de planilha e em banco.'),
    ondeAparece: 'Resultado individual, bloco 7. Dashboard, seção Cobertura. Excel, aba Resultados Belbin.'
  })),
  {
    sigla: 'Portador', nome: 'Portador de uma capacidade', grupo: 'belbin',
    oQueE: 'Participante com escore relativo igual ou maior que 50 em determinada capacidade.',
    porQue:
      'Este é um número ESCOLHIDO, não medido — é a metade da escala. É plausível e está declarado, mas ' +
      'não veio de dados. Com base real acumulada, o corte poderia vir da distribuição observada. Optamos ' +
      'por não mudá-lo agora porque alterá-lo mudaria o ICF de toda a base já coletada, e isso exige ' +
      'decisão explícita, não ajuste silencioso.',
    ondeAparece: 'Dashboard, seção Cobertura. Excel, aba Cobertura Funcional. Configurações.'
  },
  {
    sigla: 'Intensidade', nome: 'Rótulos de intensidade', grupo: 'belbin',
    oQueE:
      'Muito alta (60+), Alta (45+), Moderada (30+), Baixa (18+), Muito baixa (abaixo de 18).',
    porQue:
      'Servem para dar leitura ao número, porque "58,9" sozinho não diz nada a quem não acompanha a ' +
      'escala. Os cortes são parâmetros internos exploratórios, iguais para capacidades, papéis e escores ' +
      'junguianos — e, sendo honesto, isso é uma simplificação: como o máximo obtenível difere entre as ' +
      'dimensões, "alta" não significa exatamente a mesma coisa em todas. Está registrado como sugestão ' +
      'de melhoria ainda não implementada.',
    ondeAparece: 'Resultado individual, blocos 4, 6 e 7. Dashboard.'
  },

  /* ════════════════════════ TERMOS TÉCNICOS ════════════════════════════ */
  {
    sigla: 'is_demo', nome: 'Registro de demonstração', grupo: 'tecnicos',
    oQueE: 'Marca que identifica dados fictícios, criados para testar o sistema.',
    porQue:
      'O filtro que exclui esses registros está na definição da view do banco, não em uma cláusula de ' +
      'tela. É uma decisão de arquitetura: assim, nenhum indicador, relatório ou planilha consegue ' +
      'enxergar dado fictício por descuido de código futuro.',
    ondeAparece: 'Gestão de dados. Excel, aba Participantes.'
  },
  {
    sigla: 'is_test', nome: 'Registro de validação controlada', grupo: 'tecnicos',
    oQueE:
      'Marca do registro temporário criado pela rotina de preparação para exercitar o fluxo real.',
    porQue:
      'É diferente de is_demo de propósito. A rotina de prontidão precisa gravar uma avaliação de verdade ' +
      'para provar que salvamento, retomada, conclusão e Excel funcionam — e precisa provar também que ' +
      'esse registro NÃO entrou em nenhum indicador. Ao final, ela mesma o remove.',
    ondeAparece: 'Gestão de dados, aba Preparar aplicação.'
  },
  {
    sigla: 'RLS', nome: 'Row Level Security', grupo: 'tecnicos',
    oQueE:
      'Mecanismo do PostgreSQL que decide, linha a linha, o que cada usuário autenticado pode ler.',
    porQue:
      'O sigilo está no banco, não na interface. Esconder um menu não protege dado nenhum: quem souber ' +
      'montar a requisição contorna a tela. Com RLS, a chave usada pelo navegador simplesmente não ' +
      'retorna a linha de outra pessoa. Um administrador de setor, por exemplo, recebe zero respostas ' +
      'brutas — não porque a tela não as mostra, mas porque o banco não as entrega.',
    ondeAparece: 'Documentação técnica. Checklist de prontidão.'
  },
  {
    sigla: 'P00001', nome: 'Identificador anônimo', grupo: 'tecnicos',
    oQueE:
      'Código que substitui nome e matrícula na exportação anonimizada, atribuído por ordem de conclusão.',
    porQue:
      'Uma ressalva honesta: isso é PSEUDONIMIZAÇÃO, não anonimização irreversível. O arquivo continua ' +
      'trazendo as respostas item a item, e quem tiver acesso à base original consegue reidentificar. ' +
      'Trate o arquivo como dado pessoal.',
    ondeAparece: 'Excel anonimizado.'
  },
  {
    sigla: 'EM_ANDAMENTO / CONCLUIDA', nome: 'Situação da avaliação', grupo: 'tecnicos',
    oQueE:
      'Uma avaliação só passa a CONCLUIDA com as 48 respostas gravadas e todos os resultados calculados.',
    porQue:
      'A verificação está no banco, num gatilho, e não apenas na aplicação. Se algo falhar no meio, a ' +
      'avaliação permanece EM_ANDAMENTO e a pessoa retoma do ponto exato — nunca fica em um estado ' +
      'meio-concluído que produziria resultado incompleto.',
    ondeAparece: 'Painel nominal. Gestão de dados. Excel.'
  },
  {
    sigla: 'Versão do instrumento', nome: 'Versionamento', grupo: 'tecnicos',
    oQueE:
      'Código da versão vigente das 48 questões e da chave de pontuação, gravado em cada avaliação.',
    porQue:
      'A chave de pontuação é COPIADA para dentro de cada resposta no momento em que ela é dada. Assim, ' +
      'editar o banco de questões no futuro não altera nenhuma avaliação já respondida, e o resultado ' +
      'antigo continua reproduzível a partir do bruto. Mudança de item exige nova versão, não correção ' +
      'silenciosa da anterior.',
    ondeAparece: 'Cabeçalho de todas as telas. Excel. Configurações.'
  }
];

/**
 * Busca por sigla. A CAIXA IMPORTA na primeira tentativa, e isso não é
 * preciosismo: `N` é Intuição e `n` é o número de respondentes. Uma busca que
 * ignorasse maiúsculas faria um verbete sobrescrever o outro em silêncio — foi
 * exatamente o que o teste de cobertura flagrou.
 *
 * A tentativa sem diferenciar caixa fica como reserva, para siglas em que a
 * ambiguidade não existe (idf, rls, is_demo…).
 */
export const VERBETE_EXATO: Record<string, Verbete> =
  Object.fromEntries(GLOSSARIO.map(v => [v.sigla, v]));

export const VERBETE_POR_SIGLA: Record<string, Verbete> = (() => {
  const m: Record<string, Verbete> = {};
  for (const v of GLOSSARIO) {
    const k = v.sigla.toUpperCase();
    if (!(k in m)) m[k] = v;      // o primeiro registrado vence; nada é sobrescrito
  }
  return m;
})();

export function verbete(sigla: string): Verbete | undefined {
  return VERBETE_EXATO[sigla] ?? VERBETE_POR_SIGLA[sigla.toUpperCase()];
}

/** Siglas que só se distinguem pela caixa — precisam de busca exata. */
export const SIGLAS_AMBIGUAS: string[] = (() => {
  const cont: Record<string, string[]> = {};
  for (const v of GLOSSARIO) (cont[v.sigla.toUpperCase()] ||= []).push(v.sigla);
  return Object.values(cont).filter(g => g.length > 1).flat();
})();

export function porGrupo(g: GrupoGlossario): Verbete[] {
  return GLOSSARIO.filter(v => v.grupo === g);
}

export const GRUPOS: GrupoGlossario[] =
  ['indices', 'jung', 'perfis', 'eixos', 'capacidades', 'belbin', 'tecnicos'];
