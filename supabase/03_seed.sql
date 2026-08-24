-- ============================================================================
-- SEED DO INSTRUMENTO — gerado automaticamente por scripts/gen-sql.ts
-- NÃO EDITE À MÃO. Altere src/data/*.ts e rode: npm run gen:sql
-- Instrumento: v1.0-piloto
-- ============================================================================
begin;

-- ─── Setores (item 26) ───────────────────────────────────────────────────
insert into setores (codigo, nome) values
  ('MM', 'MM'),
  ('MDHC', 'MDHC'),
  ('MS', 'MS'),
  ('MEC', 'MEC'),
  ('ANTT', 'ANTT'),
  ('HUMAN POWER', 'HUMAN POWER'),
  ('TERRACAP', 'TERRACAP'),
  ('AGSUS', 'AGSUS'),
  ('MONITORIA', 'MONITORIA'),
  ('FINANCEIRO', 'FINANCEIRO'),
  ('DH', 'DH'),
  ('JURÍDICO', 'JURÍDICO'),
  ('DAP', 'DAP'),
  ('SESMT', 'SESMT'),
  ('INFRAESTRUTURA', 'INFRAESTRUTURA'),
  ('PLANEJAMENTO', 'PLANEJAMENTO')
on conflict (codigo) do nothing;

-- ─── Versão do instrumento ───────────────────────────────────────────────
insert into versoes_instrumento (codigo, descricao, peso_atitude, peso_funcao, ativa, publicada_em)
values ('v1.0-piloto', 'Versão piloto com 48 itens situacionais de escolha forçada. Aprovada na auditoria estrutural (0 erros, 0 alertas). NÃO validada psicometricamente — ver Etapas 51 e 52.', 27, 27, true, now())
on conflict (codigo) do update set ativa = true;

-- ─── Perfis (Etapa 2) ────────────────────────────────────────────────────
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Te', 1, 'E', 'T', 'Pensamento Extrovertido', 'Lobo', '#2E6E8E', 'F', 'Organiza a realidade externa por critério lógico e espera que o sistema seja seguido.', '{"funcaoInferiorNome":"Sentimento","jung":"Estabelece ordem lógica entre coisas externas; preocupa-se com situações externas; tende a submeter a própria conduta e a dos outros a um determinado sistema de ideias. Ponto fraco: o sentimento, o que pode levar a dificuldade de ligações afetivas profundas.","livro":"[ETO] Ao amadurecer, \"passa a participar das atividades, obedecendo a leis e hierarquias bem definidas\"; \"armam situações astutas para atrair a presa\"; anda em fila indiana \"para não deixar pegadas\"; a coesão grupal \"é um agente de cooperação e facilitação nas caçadas\". [SIM] Ysengrin, \"ira de ferro\", age \"com frieza e determinação férreas\".","estrutura":{"percebe":"Lê o campo como terreno operacional: posições, papéis, sequências e pontos de falha. Vê primeiro a estrutura, depois as pessoas.","decide":"Por critério explícito e antecipado. Planeja a rota antes de andar e escolhe o caminho de menor exposição, não o mais rápido. Revisa diante de dado novo, não diante de pressão afetiva.","relaciona":"Vincula-se pela função e pela confiabilidade. A lealdade é real e sustentada, mas se expressa em provisão e proteção, não em manifestação afetiva."},"potencias":["Transforma intenção difusa em processo executável","Cria clareza de papéis e reduz retrabalho","Sustenta padrão de qualidade e cobra o combinado","Coordena esforços coletivos com naturalidade","Persiste em esforço longo quando enxerga a lógica dele"],"luzSombra":[{"forca":"Clareza de critério","equilibrada":"Decisões auditáveis que a equipe consegue reproduzir sozinha","excessiva":"Rigidez: exceção legítima passa a ser lida como corrupção do sistema"},{"forca":"Objetividade","equilibrada":"Separa o problema da pessoa e despersonaliza o conflito","excessiva":"Desconsideração: o custo humano do que é tecnicamente correto deixa de ser registrado"},{"forca":"Capacidade de organizar os outros","equilibrada":"Coordenação que multiplica o esforço coletivo","excessiva":"Autoritarismo: o próprio sistema é aplicado a quem não o compartilha"},{"forca":"Orientação a resultado","equilibrada":"Foco sustentado que atravessa o cansaço da equipe","excessiva":"Voracidade — \"obter tudo sem considerar os meios\" — em que a própria inteligência tática se degrada"}],"luz":"Equilibrado, é a função que torna o esforço coletivo possível: transforma intenção difusa em operação, distribui papéis, sustenta padrão e protege quem está fragilizado dentro do sistema que construiu. No livro esse polo aparece como guardião, guia e psicopompo — \"um animal que conhece a agressividade e a crueldade\" e é forte o bastante para afastá-la. A firmeza é serviço, não domínio.","sombra":"A sombra é o sentimento inferior e aparece de duas formas opostas. Na primeira, o valor do outro não é registrado: vence \"sem dar ouvidos à sua argumentação lógica\", e o rigor vira desconsideração. Na segunda, o afeto recalcado retorna cru — a frieza que carrega raiva reprimida por trás. Não é um perfil pior: é o mesmo perfil com a função inferior no comando.","contribuicoes":["Converte decisão coletiva em operação que sobrevive à semana seguinte","Define papéis, limites e sequência quando o escopo está difuso","Sustenta o padrão combinado sem depender de vigilância externa","Protege a equipe de decisões arbitrárias exigindo critério explícito"],"menosEspontaneos":["Registrar o efeito das decisões sobre as pessoas envolvidas","Reconhecer contribuições informais que não aparecem em processo","Sustentar ambiguidade sem apressar uma estrutura"],"complementaridade":"Complementa-se com recursos voltados ao valor humano da decisão e à leitura do clima — quem pergunta \"quem é afetado por isto?\" antes de o critério fechar. E com recursos de percepção de possibilidade, que evitam que o sistema construído se torne o único horizonte considerado.","trabalho":{"decisao":"Rápida quando o critério está claro; travada quando não está. Muda diante de argumento, não diante de pressão emocional.","comunicacao":"Direta, impessoal e orientada ao problema. Argumenta por dado, precedente e consistência. Faz perguntas de verificação que soam como interrogatório sem essa intenção.","execucao":"Organiza antes de executar. Com escopo e limite explícitos, preenche o resto sozinho.","mudanca":"Aceita mudança bem fundamentada e resiste à anunciada sem critério. O que rejeita não é o novo — é o arbitrário.","conflitos":"Enfrenta pelo mérito e despersonaliza, o que ajuda no conteúdo e machuca na forma. Frequentemente não percebe que houve conflito.","relacionamento":"Confiável e protetor com quem está dentro do sistema. Pouca manifestação afetiva, muita provisão concreta.","pressao":"Endurece: aumenta controle, encurta prazos e reduz consulta.","inovacao":"Inova por otimização e redesenho, raramente por ruptura. Melhora o que existe até uma ordem de grandeza.","organizacao":"Alta. É frequentemente a infraestrutura organizacional invisível da equipe."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Ti', 2, 'I', 'T', 'Pensamento Introvertido', 'Elefante', '#1C4A62', 'F', 'Constrói e guarda a arquitetura conceitual do trabalho; move-se devagar e com muito peso.', '{"funcaoInferiorNome":"Sentimento","jung":"Atraído pela organização e clarificação de ideias; interessa-se mais pelas abstrações teóricas do que pelos fatos em si; produz novas hipóteses originais. O sentimento inferior é \"intenso e pouco diferenciado\" e pode irromper como explosões repentinas de afeto que espantam quem conhece apenas o lado racional.","livro":"[ETO] \"Inteligência notável e ótima memória\"; \"reduzido poder visual, mas olfato apurado\"; dorme em pé; o musth traz \"períodos de intensa virilidade, excitação e agressividade\" em animal de rotina plácida. [SIM] Ganesha, \"Deus da sabedoria, do conhecimento e da aprendizagem\"; \"energias físicas que, embora devastadoras, se sujeitam à lei\".","estrutura":{"percebe":"Por sondagem e a distância, não pelo imediatamente visível. Registra o padrão de fundo e a memória do que já ocorreu.","decide":"Devagar e por coerência interna, não por consenso nem urgência. \"Achou justo o pedido e encontrou outro acesso ao lago\": julga por princípio e refaz a rota inteira se o princípio exigir.","relaciona":"Poucos vínculos, profundos e duradouros. A autossuficiência é estrutural — e o livro a critica: \"embora possa sustentar o peso de todos, não é sustentado por ninguém\"."},"potencias":["Antecipa a falha de arquitetura que ninguém viu","É a memória institucional viva da equipe","Eleva o padrão intelectual da discussão","Produz o modelo ou padrão que outros usarão por anos","Submete a própria força a um princípio — poder que aceita limite"],"luzSombra":[{"forca":"Profundidade analítica","equilibrada":"Evita o retrabalho caro identificando o erro estrutural cedo","excessiva":"Sobre-análise: a versão boa o suficiente nunca chega"},{"forca":"Memória longa","equilibrada":"Impede que a organização repita decisões já testadas","excessiva":"Precedente usado como veto: \"já tentamos\" bloqueia o que mudou de contexto"},{"forca":"Autonomia intelectual","equilibrada":"Pensa por conta própria e não cede a pressão de moda","excessiva":"Isolamento estrutural: sustenta todos e não é sustentado por ninguém"},{"forca":"Exigência de coerência","equilibrada":"Padrão elevado que puxa o time inteiro","excessiva":"Arrogância — o \"ser arrogante e onipotente\" de La Fontaine — e persona inflada como defesa"}],"luz":"Equilibrado, é o guardião do que sustenta o resto: a arquitetura conceitual, a memória do porquê das regras, o padrão que outros usarão por anos. Ganesha condensa esse polo — aquele que \"abre caminhos e supera obstáculos\". E a formulação decisiva do livro descreve o que ele oferece a uma organização: força que aceita limite, e por isso confiável.","sombra":"A sombra tem o nome que o próprio livro dá: autossuficiência unilateral. Começa como virtude — pensar por conta própria — e termina como isolamento, sustentando todos sem ser sustentado. Daí a arrogância e a persona inflada, \"que quando usada como mecanismo de defesa pode se mostrar inútil\". E há a irrupção: o musth, \"fúria devastadora similar ao comportamento intempestivo das pessoas habitualmente pacatas\" — descrição literal do sentimento inferior deste tipo.","contribuicoes":["Identifica o erro de arquitetura antes que ele custe caro","Guarda e recupera o histórico das decisões e seus motivos","Produz documentação e padrões que sobrevivem a mudanças de equipe","Sustenta o rigor conceitual quando a pressa quer atalho"],"menosEspontaneos":["Traduzir a própria análise para quem não compartilha o repertório","Entregar uma versão parcial dentro de um prazo curto","Sinalizar desacordo cedo, em pequeno grau, antes que vire posição definitiva"],"complementaridade":"Complementa-se com recursos de execução concreta e de tradução — quem converte modelo em passo verificável e leva o conteúdo à circulação. E com recursos de leitura do clima, que reduzem o custo relacional de sua exigência de coerência.","trabalho":{"decisao":"Lenta e por coerência interna. Precisa reconstruir o raciocínio inteiro para concordar; uma vez decidido, dificilmente reabre.","comunicacao":"Fala pouco e denso; quando fala, a discussão muda de nível. Prefere texto a reunião. Não disputa espaço de fala.","execucao":"Em profundidade e em ritmo próprio. Precisa de blocos longos; agenda fragmentada destrói sua contribuição principal.","mudanca":"Resistente à mudança de forma, receptivo à mudança de fundamento. Recusa ajuste cosmético.","conflitos":"Evita o atrito enquanto pode e depois sustenta a posição com peso desproporcional. O conflito irrompe já grande.","relacionamento":"Generoso com quem pede ajuda; invisível para o resto. Vínculos poucos e duradouros.","pressao":"Retrai-se e aprofunda, o que agrava o atraso. Períodos raros de irritação intensa em alguém habitualmente plácido.","inovacao":"No nível do modelo, não do produto. Sua contribuição costuma ser reconhecida anos depois, quando já virou infraestrutura.","organizacao":"Alta no plano conceitual, baixa no plano operacional cotidiano."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Fe', 3, 'E', 'F', 'Sentimento Extrovertido', 'Carneiro', '#C1663A', 'T', 'Orienta-se pelos valores compartilhados do grupo e trabalha para manter o vínculo coletivo íntegro.', '{"funcaoInferiorNome":"Pensamento","jung":"Mantém relação adequada com os objetos exteriores por meio de avaliação afetiva; guiado por valores e ideais coletivos; expansivo e afetuoso, costuma ter muitos amigos, capta o que os outros necessitam e é capaz de se sacrificar por eles. O pensamento inferior volta-se contra o sujeito e é \"muitas vezes negativista\".","livro":"[ETO] A criação é incentivada \"pela docilidade, disciplina e forte instinto gregário\"; adapta-se \"a qualquer tipo de terreno\"; isola-se \"apenas quando ferido, doente ou desgarrado\"; no doméstico, \"fica totalmente inerte ao ser atacado\". [SIM] Vítima sacrificial; obediência que permite adaptar-se \"não só às exigências externas, sociais, mas também à autoridade do Self\".","estrutura":{"percebe":"Pelo estado do vínculo: quem está desconfortável, o que se rompeu, o que ainda não foi dito. Lê o clima antes de ler o conteúdo.","decide":"Por adesão e por impacto nas pessoas. Busca consenso antes de posição — decisões estáveis, porém lentas. Sob dúvida, adota o critério de quem tem mais convicção.","relaciona":"É o tecido conectivo. Integra, medeia e assume a parte ingrata sem que peçam."},"potencias":["Sustenta a confiança que permite ao time discordar sem se romper","Detecta desengajamento e sofrimento antes de qualquer indicador","Faz o onboarding real acontecer","Traduz decisões duras em linguagem que o time consegue receber","Adapta-se a contextos e culturas muito diferentes com facilidade rara"],"luzSombra":[{"forca":"Leitura do clima","equilibrada":"Antecipa ruptura de vínculo antes que ela custe pessoas","excessiva":"Absorção invisível do desconforto alheio até o esgotamento"},{"forca":"Busca de harmonia","equilibrada":"Mantém o grupo capaz de divergir sem se romper","excessiva":"Diluição da própria posição; a discordância migra para o corredor"},{"forca":"Disponibilidade","equilibrada":"Cobre lacunas que ninguém quer cobrir","excessiva":"Sobrecarga silenciosa e o ressentimento que o livro registra: \"com as atitudes de vítima e sacrifício, em geral coexistem sentimentos de ódio\""},{"forca":"Adaptabilidade","equilibrada":"Funciona bem em qualquer contexto ou cultura","excessiva":"Inércia diante da hostilidade — deixa de reagir quando reagir seria necessário"}],"luz":"Equilibrado, é a função que mantém o grupo capaz de discordar sem se romper. O livro descreve esse polo como obediência madura — não submissão defensiva, mas a capacidade de adaptar-se também \"à autoridade do Self\" — e reconhece que \"o comportamento imitativo e adaptativo ao meio social é imprescindível para a estruturação do ego\". A adesão não é fraqueza; é fase necessária.","sombra":"A sombra do carneiro é a mais mal compreendida, porque não se parece com uma sombra. Começa onde a adaptação deixa de ser escolha e \"se torna defensiva, e paralisa a criatividade\". A forma extrema é a inércia. Mas o material mais desconfortável é outro: o livro afirma que quem age \"como um cordeiro manso\" pode \"exercer um poder inconsciente sobre os outros\". A docilidade tem uma face de poder — e é por não ser reconhecida como tal que ela opera. O pensamento inferior fecha o quadro: julgamentos rígidos e categóricos sobre a intenção alheia, num perfil habitualmente flexível.","contribuicoes":["Cria a segurança psicológica sem a qual não há divergência produtiva","Integra pessoas novas e reconstrói vínculos rompidos","Comunica decisões difíceis de modo que o time consiga recebê-las","Sinaliza desgaste humano muito antes de ele virar rotatividade"],"menosEspontaneos":["Formar e sustentar posição própria antes de consultar o grupo","Recusar demandas explicitamente e nomear o próprio limite","Aplicar critério técnico quando ele contraria a preferência do grupo"],"complementaridade":"Complementa-se com recursos de critério explícito e de análise, que dão lastro técnico às suas leituras relacionais. E com recursos de posicionamento firme, que ajudam a converter percepção de clima em decisão.","trabalho":{"decisao":"Por consenso e por impacto nas pessoas. Estável e lenta.","comunicacao":"Calorosa, afirmativa e atenta ao efeito. Suaviza a mensagem para preservar a relação — às vezes ao ponto de perdê-la.","execucao":"Colaborativa. Rende mais em par ou grupo pequeno do que isolada.","mudanca":"Adapta-se rapidamente e absorve o custo emocional pelos outros — absorção que costuma ser invisível até o esgotamento.","conflitos":"Evita o confronto aberto e leva a discordância para o corredor. O conflito muda de lugar em vez de se resolver.","relacionamento":"Tecido conectivo. Assume a parte ingrata sem que peçam.","pressao":"Cede espaço e aumenta disponibilidade, o que agrava a sobrecarga. Em ambiente hostil, tende à inércia.","inovacao":"Raramente propõe; frequentemente viabiliza. Faz a ideia de outro ser aceita pelo grupo.","organizacao":"Moderada e centrada em pessoas: sabe quem precisa de quê, mais do que qual é o processo."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Fi', 4, 'I', 'F', 'Sentimento Introvertido', 'Baleia', '#8C3F33', 'T', 'Sustenta um sistema de valores interno, profundo e pouco verbalizado, que orienta suas escolhas com firmeza silenciosa.', '{"funcaoInferiorNome":"Pensamento","jung":"Calmo, retraído e silencioso; sentimentos profundos que se desdobram no íntimo e são difíceis de expressar; motivado por valores bem compreendidos por si mesmo; pode exercer uma influência moral sobre quem convive. O pensamento extrovertido é inferior e pouco desenvolvido.","livro":"[ETO] Maior animal existente, de \"comportamento não agressivo e uma delicadeza surpreendente\"; comunica-se por sons que podem alcançar \"centenas de quilômetros\"; a ferida \"recebe ajuda dos machos e não é abandonada até a morte\". [SIM] \"Predominantemente associada ao dinamismo matriarcal\"; o mar como inconsciente; salvadora e guia.","estrutura":{"percebe":"Em profundidade e a distância. Registra muito antes de manifestar, e manifesta pouco do que registra.","decide":"Por congruência com o próprio sistema de valores, mesmo contra a maioria e sem explicitar a razão da recusa. Processa no próprio tempo; uma vez alinhada, sustenta com constância subestimada.","relaciona":"Vínculo denso e discreto. Não abandona quem está ferido — o cuidado é ação, não declaração."},"potencias":["É a consciência ética da equipe: freia o atalho que ninguém quer nomear","Estabilidade emocional em momentos de crise e ruído","Escuta de altíssima qualidade","Cria segurança pela previsibilidade do próprio caráter","Sustenta compromissos de longo prazo sem supervisão"],"luzSombra":[{"forca":"Convicção ética firme","equilibrada":"Freio confiável antes que o dano aconteça","excessiva":"Autoridade moral não declarada que, segundo o livro, \"pode levar à repressão do menor e mais frágil\""},{"forca":"Discrição","equilibrada":"Presença estável que não disputa espaço nem cria ruído","excessiva":"Invisibilidade: a contribuição não é reconhecida e a divergência nunca chega à mesa"},{"forca":"Profundidade de vínculo","equilibrada":"Confiança que faz as pessoas trazerem o que não trazem a mais ninguém","excessiva":"Presença que envolve e retém — o polo de sedução que o livro registra"},{"forca":"Processamento interno prolongado","equilibrada":"Decisões maduras e sustentadas ao longo do tempo","excessiva":"Ressentimento acumulado que só aparece já como decisão de saída"}],"luz":"Equilibrada, exerce o que o capítulo junguiano chama de influência moral: não pelo discurso, mas pela coerência. É a estabilidade que segura o ambiente quando tudo acelera e a escuta a quem se conta o que não se conta a mais ninguém. No livro, é salvadora e guia — impede o encalhe e conduz o barco ao porto — e \"a força que, quando positivamente canalizada, conduz e dirige a psique para o plano consciente\".","sombra":"A sombra é a mesma profundidade sem via de saída. O livro registra a insaciabilidade — \"há sempre um buraco não preenchido\" — e é dela que nasce a forma organizacional mais comum: o ressentimento acumulado em silêncio, que só aparece como decisão já tomada. Há também o polo do disfarce: \"simboliza aquele que se disfarça e engana\", parece ilha e afunda com quem se instalou sobre ela. O pensamento inferior aparece quando finalmente se explica: argumentação rígida, dados usados como arma, frieza atípica.","contribuicoes":["Sinaliza o custo ético de decisões que pareciam apenas técnicas","Estabiliza a equipe em períodos de crise e alta rotatividade","Oferece escuta que faz problemas emergirem antes de estourarem","Sustenta relações de confiança de longo prazo com pessoas e parceiros"],"menosEspontaneos":["Verbalizar os critérios que já concluiu internamente","Sinalizar desconforto cedo e em pequeno grau, antes que vire ruptura","Ocupar espaço em discussões abertas e disputadas"],"complementaridade":"Complementa-se com recursos de articulação e visibilidade, que levam suas conclusões ao debate coletivo. E com recursos de estruturação, que convertem convicção de valor em critério aplicável.","trabalho":{"decisao":"Por congruência com valores próprios, mesmo isolada. Raramente explicita a razão da recusa.","comunicacao":"Fala pouco, e o que diz reorienta a conversa. Melhor em conversa a dois do que em plenária.","execucao":"Profunda, silenciosa e no próprio tempo. Precisa de material antecipado e de contexto.","mudanca":"Aceita mudança justificada por propósito e resiste à justificada por eficiência. Precisa de tempo e de sentido, nessa ordem.","conflitos":"Não confronta; absorve. A expressão chega tarde, já na forma de uma decisão tomada.","relacionamento":"Presença constante e discreta. Não abandona quem está em dificuldade.","pressao":"Submerge: reduz contato, mantém a entrega e para de sinalizar.","inovacao":"Gesta em silêncio e apresenta pronto. O risco é a organização nunca saber que havia algo sendo gestado.","organizacao":"Moderada, orientada por compromisso assumido mais do que por sistema formal."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Se', 5, 'E', 'S', 'Sensação Extrovertida', 'Cavalo', '#6E8B3D', 'N', 'Opera na realidade palpável, com senso agudo do concreto e enorme capacidade de ação imediata.', '{"funcaoInferiorNome":"Intuição","jung":"Ótima capacidade de perceber os objetos do mundo externo, relacionando-se de modo prático e concreto com eles; agudo senso de realidade; eficiente e apreciador do prazer sensorial; \"só se move na realidade palpável\". A intuição inferior leva a explicar tudo por um único pensamento rígido.","livro":"[ETO] Tem \"os maiores globos oculares dentre os mamíferos terrestres\"; movimentos oculares independentes que permitem \"focar duas direções ao mesmo tempo\"; percebe pelo freio \"as menores variações dos movimentos das rédeas\"; assusta-se \"com qualquer objeto que atravesse de súbito seu campo visual\". [SIM] Encarna a energia instintiva, que \"exige uma direção consciente\" para se tornar produtiva.","estrutura":{"percebe":"Amplitude e detalhe simultâneos. Registra o que muda, na hora em que muda.","decide":"Rápido e em gradação de custo: primeiro sinaliza, depois recua, só então confronta. Aprende fazendo, não modelando.","relaciona":"Gregário e responsivo. Lê a menor variação de tom e postura da liderança, mesmo quando não comenta."},"potencias":["Destrava o que está parado e recupera cronograma","Presença firme em campo, com cliente e em operação","Aumenta o ritmo do time inteiro por contágio","Resolve problemas concretos com economia de movimento","Desempenho excepcional em crise e alta pressão sensorial"],"luzSombra":[{"forca":"Senso de realidade","equilibrada":"Ancora a discussão no que efetivamente está acontecendo","excessiva":"Descarte do que ainda não é visível — inclusive do risco que só existe no futuro"},{"forca":"Velocidade de ação","equilibrada":"Tira o trabalho do papel no mesmo dia","excessiva":"Ação que se antecipa à compreensão e multiplica o dano quando o diagnóstico estava errado"},{"forca":"Energia e disposição","equilibrada":"Contagia e sustenta o ritmo coletivo","excessiva":"Atropelamento de perfis mais lentos e desengajamento visível em conversas longas"},{"forca":"Pragmatismo","equilibrada":"Contorna a burocracia que não serve à entrega","excessiva":"Baixa documentação: a equipe refaz o mesmo trabalho por falta de registro"}],"luz":"Equilibrado, é a energia que tira o trabalho do papel — e o livro é explícito sobre a condição disso: trata-se de \"o ímpeto biológico, a energia natural\", massa de energia que \"exige uma direção consciente\" para se tornar produtiva. Com direção, o polo é solar: \"emerge da sombra para a luz\" e chega a representar \"instintos sublimados ou controlados\". O ideal descrito é Quíron, \"a expressão nítida da harmonia do homem com sua instintividade\".","sombra":"A sombra aparece exatamente onde a direção falta. \"A imagem do cavalo desenfreado aponta para a dificuldade de domínio do eu diante da invasão de impulsos inconscientes\" — em termos organizacionais: velocidade que produz dano e energia que não distingue urgência de importância. Há também a indiscriminação, a \"crina embaraçada\" que confunde o pensamento. E a intuição inferior fecha o quadro: pressentimentos catastróficos em alguém habitualmente ancorado no presente.","contribuicoes":["Converte decisão em fato concreto no mesmo dia","Sustenta a operação e o contato direto com a realidade do trabalho","Estabiliza a equipe em crises que exigem resposta imediata","Traz de volta ao concreto discussões que se abstraíram"],"menosEspontaneos":["Antecipar consequências de segunda ordem antes de agir","Planejar e documentar o que descobriu na prática","Sustentar trabalho abstrato de horizonte longo"],"complementaridade":"Complementa-se com recursos de antecipação e de modelagem, que dão direção à sua energia. E com recursos de registro e continuidade, que preservam o que ele descobriu executando.","trabalho":{"decisao":"Rápida, com base no que está diante dos olhos. Prefere testar a modelar; subestima consequências de segunda ordem.","comunicacao":"Objetiva, concreta e cheia de exemplos reais. Prefere mostrar a explicar.","execucao":"Faz. Aprende fazendo. Rende em ciclos curtos com resultado visível.","mudanca":"Adapta-se com facilidade a mudanças concretas; sofre com mudanças de direção estratégica sem tradução prática.","conflitos":"Reage rápido e sinaliza antes de escalar. Intenso, explícito e geralmente curto.","relacionamento":"Contagia o ritmo. Presença disponível e visível.","pressao":"Acelera: faz mais, mais rápido, com menos consulta.","inovacao":"Por experimento e improviso eficaz. Descobre na prática o que não estava no plano — mas não formaliza o que descobre.","organizacao":"Baixa no plano formal, alta no plano prático: sabe onde as coisas estão e como fazê-las andar."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Si', 6, 'I', 'S', 'Sensação Introvertida', 'Urso', '#47632B', 'N', 'Percebe o detalhe concreto com precisão incomum e o organiza em um repertório interno estável.', '{"funcaoInferiorNome":"Intuição","jung":"Ótima capacidade de apreender impressões dos objetos, mas com atenção voltada à percepção interna e subjetiva; sintonizado no fato, no \"aqui e agora\"; percepção sensorial diferenciada; colecionador, atento a qualidades estéticas. A intuição inferior aparece \"de modo primitivo\", como pressentimentos negativos e fantasias que assaltam.","livro":"[ETO] \"Audição e olfato bem desenvolvidos, mas sua visão é deficiente\"; plantígrado que \"apóia a sola do pé inteira no chão\"; hiberna cerca de quatro meses; reconhece a parceira \"pelo odor\"; pelo mel \"enfrenta, sem receios, grandes enxames de abelhas\". [SIM] A hibernação em que \"conteúdos internos possam ser gestados num processo de recuperação\".","estrutura":{"percebe":"Por proximidade e cheiro, não por varredura à distância. Nota o que mudou, compara com o que já viu, sente antes de nomear.","decide":"Comparando com a experiência concreta acumulada e em ritmo calendárico. Precisa de dado completo; sob objeto desejado, porém, suprime o cálculo de custo e avança.","relaciona":"Vínculo estável, individualizado e de contato. Pequenos grupos, não coletivos amplos."},"potencias":["Qualidade e confiabilidade sustentadas ao longo do tempo","Documentação, rastreabilidade e continuidade operacional","Detecta o erro pequeno que se tornaria caro","Estabiliza o time nos períodos em que todos estão reagindo","Sensibilidade qualitativa: percebe o mal-acabado antes de saber dizer por quê"],"luzSombra":[{"forca":"Atenção ao detalhe","equilibrada":"Precisão e prevenção do erro caro","excessiva":"Perfeccionismo e dificuldade de dar por concluído"},{"forca":"Consistência de padrão","equilibrada":"Qualidade que não oscila com o humor da semana","excessiva":"Resistência à mudança necessária por apego ao que funcionou"},{"forca":"Memória operacional","equilibrada":"Contexto recuperável que economiza meses de retrabalho","excessiva":"Excesso de detalhe em comunicações que pediam síntese"},{"forca":"Confiabilidade","equilibrada":"É a base sobre a qual a operação não desmorona","excessiva":"Sobrecarga silenciosa por acumular o que ninguém mais quer sustentar"}],"luz":"Equilibrado, é a base sobre a qual a operação não desmorona: qualidade constante, memória do detalhe, continuidade quando todos estão reagindo. O livro concentra esse polo na função de cura — o xamã que \"podia assumir a forma do urso\" — e dá à sua retração o sentido produtivo que raramente se lhe reconhece: a hibernação é a etapa em que conteúdos são \"gestados\", e a saída dela \"pode representar o surgimento da criatividade\". O recolhimento não é ausência de trabalho: é onde este perfil trabalha.","sombra":"A sombra tem duas direções. A primeira é a ingenuidade que o livro documenta exaustivamente e define com precisão: não é falta de inteligência, é não imaginar o que o outro está planejando — crença literal na palavra alheia e aplicação de regra por inversão mecânica sem compreender o caso concreto. É a intuição inferior em estado puro. A segunda é o descontrole da própria potência: o berserk, e a fábula em que mata quem ama \"por não conseguir conhecer e usar adequadamente a própria força\".","contribuicoes":["Garante que o que foi construído continue funcionando","Produz o registro e a rastreabilidade que a equipe usa depois","Identifica antecipadamente o que vai quebrar quando a mudança chegar à operação","Mantém o padrão de qualidade sem depender de cobrança"],"menosEspontaneos":["Considerar cenários que ainda não se materializaram","Sintetizar: entregar as três linhas principais antes do detalhe","Ler a intenção estratégica por trás do pedido de outra pessoa"],"complementaridade":"Complementa-se com recursos de percepção de possibilidade, que ampliam seu horizonte além do precedente. E com recursos de articulação, que traduzem seu conhecimento operacional para quem decide.","trabalho":{"decisao":"Por comparação com a experiência concreta: \"já vimos isso antes, e deu nisto\". Desconfia de decisão sem precedente.","comunicacao":"Fala pouco e com precisão factual. Comunica por registro escrito e histórico. Levanta a inconsistência no fim da reunião.","execucao":"Metódica, no próprio ritmo e com reserva acumulada de dados, versões e contexto.","mudanca":"O ponto mais sensível. Mudança súbita é vivida como perda. Precisa de aviso antecipado e motivo demonstrado.","conflitos":"Evita, acumula e expressa tarde, por acúmulo de evidências. A reação parece desproporcional ao gatilho aparente.","relacionamento":"Estabilizador. Assume silenciosamente o que ninguém quer sustentar.","pressao":"Fecha-se e reduz o escopo ao que domina. Surge catastrofismo difuso em alguém habitualmente ancorado.","inovacao":"Baixa iniciativa de ruptura, alta contribuição de viabilidade: identifica o que vai quebrar na operação real.","organizacao":"Muito alta. É frequentemente quem sabe onde tudo está."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Ne', 7, 'E', 'N', 'Intuição Extrovertida', 'Raposa', '#8A5AA0', 'S', 'Fareja possibilidades no mundo externo e converte contexto em oportunidade.', '{"funcaoInferiorNome":"Sensação","jung":"Apreende o movimento das coisas como possibilidades; inovador; tem \"faro\" para o que vai dar certo; nunca está parado e abandona seus projetos empreendendo algo novo; não suporta rotina; \"raras vezes colhem o que plantam\". A sensação introvertida inferior faz com que não perceba que está cansado ou com fome.","livro":"[SIM] Oitavo perfil, decorrente de lacuna estrutural identificada na matriz. A introdução do volume 1 cita \"esperto como uma raposa\" entre as convenções comportamentais, e o animal é analisado pelas mesmas autoras no volume 2. No volume 1 ela aparece como agente em três capítulos — \"O lobo e a raposa\", \"O jaguar e a raposa\", \"O urso, o pássaro e a raposa\" — sempre percebendo a possibilidade que o animal grande não vê. O livro diferencia as duas inteligências: o lobo \"tenta utilizar os mesmos estratagemas que a raposa utiliza; mas ela é bem-sucedida e ele fracassa\". No mito Kaska, é ela quem \"levou o fogo para as tribos\".","estrutura":{"percebe":"Relações e aberturas onde os outros veem obstáculo. Lê o campo externo como campo de possibilidades.","decide":"Por leitura de cenário e percepção de janela, com alta tolerância a risco e a informação incompleta. Muda de decisão sem constrangimento quando o cenário muda.","relaciona":"Por articulação e persuasão. Rede ampla construída sem esforço aparente."},"potencias":["Traz para dentro da organização o que está acontecendo fora","Gera opções onde o time via um beco sem saída","Abre portas, parcerias e caminhos que não existiam","Recoloca em movimento projetos empacados por excesso de estrutura","Improviso de alta qualidade em contexto novo"],"luzSombra":[{"forca":"Visão de possibilidades","equilibrada":"Inovação e saída não óbvia no impasse","excessiva":"Dispersão: inicia muito, sustenta pouco — \"raras vezes colhem o que plantam\""},{"forca":"Persuasão","equilibrada":"Faz uma ideia boa ser adotada antes de estar pronta","excessiva":"Manipulação — no volume 1, a possibilidade percebida é sempre convertida em engano do outro"},{"forca":"Versatilidade","equilibrada":"Funciona bem em contexto ambíguo e desconhecido","excessiva":"Compromissos verbais sem lastro, que corroem a própria credibilidade"},{"forca":"Energia de início","equilibrada":"Destrava o que estava parado","excessiva":"Sobrecarga de quem executa: a equipe paga o custo do que foi prometido"}],"luz":"Equilibrada, é a função que abre caminhos que não existiam. O livro atribui à \"força da idéia criativa\" o poder de vencer o que a força bruta não vence — e a raposa é sua principal portadora. Há uma imagem que fixa esse polo: no mito Kaska, depois de todos os animais planejarem juntos a artimanha, é ela quem leva o fogo para as tribos. Não é a guardiã do fogo, é quem o distribui — converte um bem retido em recurso comum.","sombra":"A sombra é a única que o volume 1 mostra por inteiro, porque ali ela aparece sempre do lado de quem engana: convence Ysengrin a mergulhar o rabo no lago gelado, escapa do poço fazendo o lobo descer pela corda, mata o jaguar persuadindo-o a deixar que lhe retirem o coração. É inteligência de cenário sem compromisso com o outro — o risco organizacional de articular narrativas que funcionam melhor do que são verdadeiras. E a sensação inferior: perde a leitura do próprio corpo, do próprio limite e do custo real do que promete.","contribuicoes":["Identifica oportunidades e riscos externos antes que apareçam nos números","Produz alternativas quando o caminho conhecido se esgotou","Articula parcerias, contatos e recursos fora da fronteira da equipe","Destrava negociações e impasses por reenquadramento"],"menosEspontaneos":["Concluir e sustentar o que iniciou","Trabalhar com detalhe, processo e prestação de contas","Reconhecer o próprio limite de carga antes do esgotamento"],"complementaridade":"Complementa-se com recursos de consistência e de detalhe, que sustentam o que ela abre. E com recursos de critério, que separam a boa oportunidade da narrativa persuasiva.","trabalho":{"decisao":"Por percepção de janela e leitura de cenário. Muda de decisão sem constrangimento — o que os outros leem como falta de palavra.","comunicacao":"Envolvente, associativa e persuasiva. Vende a ideia antes de a ideia existir. Salta entre assuntos seguindo conexões que só ela viu.","execucao":"Em muitas frentes e em rajadas. Excelente no início e na virada; fraca na sustentação.","mudanca":"Prospera na mudança e a provoca. Às vezes cria movimento sem necessidade, apenas para haver movimento.","conflitos":"Contorna em vez de enfrentar; reenquadra e encontra saída lateral. Torna-se evasiva quando o conflito precisava ser tido.","relacionamento":"Energiza e conecta. Mas a equipe paga o custo de execução do que ela promete.","pressao":"Multiplica opções e abre novas frentes — o oposto do que a situação pede. Perde a leitura do próprio cansaço.","inovacao":"Inovação por descoberta externa. Raramente é quem termina a inovação que iniciou.","organizacao":"Baixa. Precisa de estrutura emprestada de outros perfis."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;
insert into perfis (codigo, ordem, atitude, funcao, nome_jung, animal, cor, funcao_inferior, sintese, conteudo) values
  ('Ni', 8, 'I', 'N', 'Intuição Introvertida', 'Onça', '#4E3163', 'S', 'Enxerga o desdobramento profundo das coisas antes que haja evidência dele.', '{"funcaoInferiorNome":"Sensação","jung":"Percepção da realidade objetiva fraca e indeterminada, com fantasia muito viva; místicos, artistas visionários, expoentes de novas filosofias; excêntricos; capacidade de transformação de toda uma cultura. A sensação extrovertida inferior faz com que o real lhe escape.","livro":"[ETO] \"Ágeis, velozes, elegantes, silenciosos e pacientes\"; caminha \"sem fazer ruído\"; vê na penumbra; o macho \"costuma viver solitário\". [SIM] Clarividente (Tezcatlipoca, \"o espelho fumegante\"), psicopompo maia, xamã ou pajé, e guardião do fogo, \"símbolo de transformação cultural\". A ingenuidade: \"é somente por meio desse seu ponto fraco que a onça pode ser derrotada\".","estrutura":{"percebe":"Vê onde os outros não veem — a visão noturna que sustenta, no livro, a atribuição de clarividência e a possibilidade \"de iluminar o inconsciente, de ver o desconhecido\".","decide":"A partir de convicção interna sobre o desdobramento futuro, depois de espera prolongada. A ação, quando vem, é súbita e total; sob contestação, escala em vez de reavaliar.","relaciona":"Solitária por estrutura, não por circunstância. O vínculo profundo existe, mas é episódico e não organiza sua conduta."},"potencias":["Antecipa mudança de mercado, risco estrutural e ruptura de modelo","Enxerga a dinâmica política e emocional que ninguém verbalizou","Formula a visão e a narrativa de longo prazo","Faz a pergunta que reposiciona o problema inteiro","Paciência incomum: espera o momento e age de uma só vez"],"luzSombra":[{"forca":"Antecipação de cenários","equilibrada":"Vê a ruptura antes de haver evidência dela","excessiva":"Descarte do dado presente que contraria a leitura de longo prazo"},{"forca":"Convicção","equilibrada":"Sustenta a visão quando o consenso ainda não existe","excessiva":"Escalada em vez de reavaliação — \"quanto mais se debate, mais aumenta o ferimento\""},{"forca":"Autonomia","equilibrada":"Pensa fora do enquadramento coletivo","excessiva":"Isolamento e perda de influência por não construir base de apoio"},{"forca":"Leitura do não-dito","equilibrada":"Nomeia a dinâmica que o grupo evita","excessiva":"Ingenuidade prática: subestima o pequeno e \"avalia mal os próprios limites\""}],"luz":"Equilibrada, é a função que antecipa a mudança antes de haver evidência dela. O livro reúne esse polo em quatro figuras convergentes: clarividente, psicopompo, xamã — \"o pajé representa para a sociedade exatamente o mesmo que o jaguar representa para a natureza\" — e guardião do fogo, \"símbolo de transformação cultural\". Vale reter que ela não inventa o fogo: é \"seu guardião, depositário e o primeiro a utilizá-lo\".","sombra":"A sombra tem uma face esperada e outra que surpreende. A esperada é a destrutividade: \"agressividade destemida e traiçoeira é o aspecto central de seu simbolismo\". A inesperada — e mais útil — é a ingenuidade. O livro afirma que \"é somente por meio desse seu ponto fraco que a onça pode ser derrotada\" e a define: credulidade diante de propostas vantajosas, incapacidade de prever a estratégia do outro, e desprezo pelo fraco. É a sensação inferior: quem enxerga longe deixa de ver o que está diante de si. O livro também aponta a saída, e ela é concreta: a consciência perdida \"só é restaurada pelo reconhecimento do valor do menor, do mais humilde, do mais frágil\".","contribuicoes":["Sinaliza risco estrutural e mudança de modelo antes dos indicadores","Formula a visão de longo prazo e a narrativa que dá sentido ao esforço","Nomeia a dinâmica implícita que trava o grupo","Reposiciona problemas que a equipe vinha tentando resolver no enquadramento errado"],"menosEspontaneos":["Traduzir a visão em um passo concreto e verificável do trimestre","Construir base de apoio antes de sustentar uma posição","Sustentar o detalhe operacional e o presente concreto"],"complementaridade":"Complementa-se com recursos de execução e de concretização, que dão corpo à visão. E com recursos de articulação e de leitura de clima, que constroem a adesão de que ela não cuida.","trabalho":{"decisao":"Por convicção interna sobre o desdobramento futuro. Não negocia bem a própria visão.","comunicacao":"Por imagem, cenário e síntese, frequentemente sem mostrar o percurso. A conclusão chega sem a demonstração.","execucao":"Sozinha, em silêncio e por longos períodos de aparente inatividade, seguidos de contribuição concentrada.","mudanca":"Não reage à mudança: costuma tê-la previsto antes. A dificuldade é sustentar o presente enquanto espera o cenário que enxergou.","conflitos":"Raramente entra; quando entra, não recua.","relacionamento":"Presença intermitente. Cala-se em reuniões operacionais e intervém uma vez, deslocando toda a discussão.","pressao":"Isola-se e endurece a convicção. Surge descuido com o corpo e o ambiente, ou fixação em detalhe irrelevante.","inovacao":"É a fonte da inovação de ruptura e a menos capaz de executá-la sozinha.","organizacao":"Baixa no operacional. Indiferente ao processo — não por rebeldia, por desinteresse."}}'::jsonb)
on conflict (codigo) do update set
  ordem = excluded.ordem, atitude = excluded.atitude, funcao = excluded.funcao,
  nome_jung = excluded.nome_jung, animal = excluded.animal, cor = excluded.cor,
  funcao_inferior = excluded.funcao_inferior, sintese = excluded.sintese, conteudo = excluded.conteudo;

-- ─── Matriz funcional (Etapa 3) ──────────────────────────────────────────
insert into matriz_funcional (perfil_codigo, capacidade, valor, justificativa) values
  ('Te', 'CRIAR', 2, null),
  ('Te', 'EXPLORAR', 3, null),
  ('Te', 'ANALISAR', 4, 'Nota 4. Função dominante racional voltada ao objeto externo; analisa para agir, não para compreender — daí 4 e não 5, reservado ao Ti.'),
  ('Te', 'DECIDIR', 5, 'Nota 5. O Formador de Belbin "supera os obstáculos por pura determinação" e "exige decisões rápidas para superar ameaças e dificuldades". O tipo Te "estabelece ordem lógica entre coisas externas" e decide rápido quando o critério está claro; o lobo, no livro, planeja a emboscada e coordena o bando para executá-la.'),
  ('Te', 'ORGANIZAR', 5, 'Nota 5. Etologicamente o lobo "obedece a leis e hierarquias bem definidas" e escolhe a rota por critério (fila indiana para não deixar pegadas). Jung: submete a própria conduta e a dos outros a um sistema de ideias.'),
  ('Te', 'EXECUTAR', 4, 'Nota 4. Alta persistência em esforço longo quando enxerga a lógica; afinidade com o Implementador, "confiável e com capacidade de aplicação".'),
  ('Te', 'RELACIONAR', 2, null),
  ('Te', 'COORDENAR', 4, 'Nota 4. Coordena por função e papel, não por leitura de talento individual — o que mantém abaixo do Fe, que coordena por vínculo.'),
  ('Te', 'FINALIZAR', 3, null),
  ('Te', 'ESPECIALIZAR', 3, null),
  ('Ti', 'CRIAR', 3, null),
  ('Ti', 'EXPLORAR', 1, 'Nota 1. O Investigador de Recursos é extrovertido e desenvolve contatos externos; Ti é o polo oposto em atitude e no livro o elefante "sugere mudanças lentas, porém duradouras".'),
  ('Ti', 'ANALISAR', 5, 'Nota 5. O Monitor Avaliador é "sério e prudente", "lento em tomar decisão por pensar cuidadosamente" e "lida com fatos e lógicas ao invés de emoção" — descrição que coincide ponto a ponto com o pensamento introvertido de Jung, atraído "pelas abstrações teóricas do que pelos fatos em si".'),
  ('Ti', 'DECIDIR', 2, null),
  ('Ti', 'ORGANIZAR', 4, 'Nota 4. Organiza no plano conceitual (modelos, padrões, arquitetura), não no operacional cotidiano.'),
  ('Ti', 'EXECUTAR', 2, null),
  ('Ti', 'RELACIONAR', 2, null),
  ('Ti', 'COORDENAR', 2, null),
  ('Ti', 'FINALIZAR', 4, 'Nota 4. Exigência de coerência e padrão elevado sustentam a conclusão de alto rigor — mas o mesmo perfeccionismo conceitual atrasa a entrega, o que impede a nota 5.'),
  ('Ti', 'ESPECIALIZAR', 5, 'Nota 5. O Especialista "ama aprender; acumular conhecimentos como principal motivo de sua existência". O elefante condensa "a memória, a paciência e a autoconfiança" e a sabedoria de Ganesha.'),
  ('Fe', 'CRIAR', 2, null),
  ('Fe', 'EXPLORAR', 3, null),
  ('Fe', 'ANALISAR', 1, 'Nota 1. Pensamento é a função inferior; o livro registra que a argumentação lógica correta do cordeiro não o salva — o raciocínio existe, mas não é o recurso que organiza a conduta.'),
  ('Fe', 'DECIDIR', 2, null),
  ('Fe', 'ORGANIZAR', 3, null),
  ('Fe', 'EXECUTAR', 3, null),
  ('Fe', 'RELACIONAR', 5, 'Nota 5. O Trabalhador em Equipe é "perceptivo, diplomático, bom ouvinte, preocupado com a harmonia e em evitar conflitos". Jung: o sentimento extrovertido "capta o que outras pessoas necessitam" e é "capaz de se sacrificar por elas".'),
  ('Fe', 'COORDENAR', 4, 'Nota 4. Coordena por vínculo e por leitura de necessidade — próximo do Coordenador, "rápido em detectar talentos individuais" —, mas sem a assertividade de delegar que Belbin atribui ao papel.'),
  ('Fe', 'FINALIZAR', 3, null),
  ('Fe', 'ESPECIALIZAR', 1, 'Nota 1. Adaptabilidade ampla é o oposto do aprofundamento técnico exclusivo que define o Especialista.'),
  ('Fi', 'CRIAR', 3, null),
  ('Fi', 'EXPLORAR', 1, 'Nota 1. Introversão marcada e ritmo próprio; nenhum material de busca ativa de oportunidade externa.'),
  ('Fi', 'ANALISAR', 3, null),
  ('Fi', 'DECIDIR', 2, null),
  ('Fi', 'ORGANIZAR', 2, null),
  ('Fi', 'EXECUTAR', 3, null),
  ('Fi', 'RELACIONAR', 5, 'Nota 5. Vínculo denso e escuta de alta qualidade; a baleia "não é abandonada até a morte". Relaciona por profundidade, não por articulação.'),
  ('Fi', 'COORDENAR', 3, null),
  ('Fi', 'FINALIZAR', 3, null),
  ('Fi', 'ESPECIALIZAR', 3, null),
  ('Se', 'CRIAR', 2, null),
  ('Se', 'EXPLORAR', 4, 'Nota 4. Busca ativa no campo externo e presença em contato direto — mas explora o disponível agora, não a possibilidade futura, o que reserva a nota 5 ao Ne.'),
  ('Se', 'ANALISAR', 2, null),
  ('Se', 'DECIDIR', 4, 'Nota 4. Decide rápido e mobiliza; próximo do Formador, sem a orientação a confronto sistemático deste.'),
  ('Se', 'ORGANIZAR', 2, null),
  ('Se', 'EXECUTAR', 5, 'Nota 5. O Implementador é "prático, autocontrolado e disciplinado" e valorizado pela "capacidade de aplicação". Jung: a sensação extrovertida "só se move na realidade palpável" e tem agudo senso de realidade.'),
  ('Se', 'RELACIONAR', 4, 'Nota 4. Alta responsividade interpessoal e leitura fina de tom e postura, ainda que a serviço da ação e não do vínculo.'),
  ('Se', 'COORDENAR', 2, null),
  ('Se', 'FINALIZAR', 3, null),
  ('Se', 'ESPECIALIZAR', 2, null),
  ('Si', 'CRIAR', 1, 'Nota 1. Intuição é a função inferior; o livro documenta a ingenuidade como incapacidade específica de imaginar o que ainda não ocorreu.'),
  ('Si', 'EXPLORAR', 1, 'Nota 1. Mesma razão, somada à introversão e ao apego ao ambiente previsível.'),
  ('Si', 'ANALISAR', 4, 'Nota 4. Analisa por comparação com o precedente concreto, não por modelo abstrato.'),
  ('Si', 'DECIDIR', 2, null),
  ('Si', 'ORGANIZAR', 5, 'Nota 5. Reserva acumulada, rastreabilidade e ritmo calendárico; o urso "comporta-se segundo regras rígidas".'),
  ('Si', 'EXECUTAR', 4, 'Nota 4. Execução constante e confiável, em ritmo próprio — o que a diferencia da execução veloz do Se.'),
  ('Si', 'RELACIONAR', 3, null),
  ('Si', 'COORDENAR', 2, null),
  ('Si', 'FINALIZAR', 5, 'Nota 5. O Finalizador é "atento aos detalhes", "confiável para fazer trabalhos de alto padrão e concluí-lo em tempo" e "busca a perfeição". Jung: percepção sensorial diferenciada e atenção às qualidades estéticas.'),
  ('Si', 'ESPECIALIZAR', 4, 'Nota 4. Acúmulo profundo de repertório concreto em um domínio.'),
  ('Ne', 'CRIAR', 5, 'Nota 5. O Planta "desafia as formas convencionais e estabelecidas de fazer as coisas" e "fornece soluções para resolver problemas complexos". A raposa, no volume 1, é a portadora da "idéia criativa" que vence a força bruta.'),
  ('Ne', 'EXPLORAR', 5, 'Nota 5. O Investigador de Recursos é "extrovertido e entusiasmado", "bom negociador", "explora novas oportunidades e desenvolve contatos". Jung: apreende o movimento das coisas como possibilidades e tem "faro" para o que vai dar certo.'),
  ('Ne', 'ANALISAR', 2, null),
  ('Ne', 'DECIDIR', 3, null),
  ('Ne', 'ORGANIZAR', 1, 'Nota 1. Jung: "raras vezes colhem o que plantam"; não suporta rotina nem estrutura.'),
  ('Ne', 'EXECUTAR', 2, null),
  ('Ne', 'RELACIONAR', 4, 'Nota 4. Articulação e rede ampla — relaciona-se para conectar e persuadir, não para cuidar, o que a distingue de Fe e Fi.'),
  ('Ne', 'COORDENAR', 3, null),
  ('Ne', 'FINALIZAR', 1, 'Nota 1. Abandona projetos empreendendo algo novo — o oposto exato do Finalizador.'),
  ('Ne', 'ESPECIALIZAR', 1, 'Nota 1. Amplitude e versatilidade em vez de aprofundamento em um domínio.'),
  ('Ni', 'CRIAR', 5, 'Nota 5. O Planta é "introvertido, independente e altamente criativo" e "prefere operar a uma certa distância dos outros membros" — descrição que coincide com a intuição introvertida de Jung e com a onça solitária e clarividente do livro. Belbin observa ainda que o Planta "nem sempre consegue se comunicar de forma convincente", o que corresponde à conclusão que chega sem a demonstração.'),
  ('Ni', 'EXPLORAR', 3, null),
  ('Ni', 'ANALISAR', 4, 'Nota 4. Analisa por leitura de padrão e de dinâmica implícita, não por verificação de fatos.'),
  ('Ni', 'DECIDIR', 3, null),
  ('Ni', 'ORGANIZAR', 2, null),
  ('Ni', 'EXECUTAR', 1, 'Nota 1. Sensação extrovertida é a função inferior; o livro registra que "o real lhe escapa".'),
  ('Ni', 'RELACIONAR', 1, 'Nota 1. Solitária por estrutura; não constrói base de apoio.'),
  ('Ni', 'COORDENAR', 2, null),
  ('Ni', 'FINALIZAR', 2, null),
  ('Ni', 'ESPECIALIZAR', 4, 'Nota 4. Aprofundamento em um domínio de longo prazo (cenários, risco estrutural).')
on conflict (perfil_codigo, capacidade) do update set valor = excluded.valor, justificativa = excluded.justificativa;

-- ─── Afinidade com os papéis de Belbin ───────────────────────────────────
insert into afinidade_belbin (perfil_codigo, papel, valor) values
  ('Te', 'PLANTA', 1),
  ('Te', 'INV_RECURSOS', 2),
  ('Te', 'COORDENADOR', 4),
  ('Te', 'FORMADOR', 5),
  ('Te', 'MONITOR', 3),
  ('Te', 'IMPLEMENTADOR', 4),
  ('Te', 'TRAB_EQUIPE', 1),
  ('Te', 'FINALIZADOR', 3),
  ('Te', 'ESPECIALISTA', 2),
  ('Ti', 'PLANTA', 3),
  ('Ti', 'INV_RECURSOS', 1),
  ('Ti', 'COORDENADOR', 2),
  ('Ti', 'FORMADOR', 1),
  ('Ti', 'MONITOR', 5),
  ('Ti', 'IMPLEMENTADOR', 3),
  ('Ti', 'TRAB_EQUIPE', 1),
  ('Ti', 'FINALIZADOR', 3),
  ('Ti', 'ESPECIALISTA', 5),
  ('Fe', 'PLANTA', 1),
  ('Fe', 'INV_RECURSOS', 3),
  ('Fe', 'COORDENADOR', 4),
  ('Fe', 'FORMADOR', 1),
  ('Fe', 'MONITOR', 1),
  ('Fe', 'IMPLEMENTADOR', 3),
  ('Fe', 'TRAB_EQUIPE', 5),
  ('Fe', 'FINALIZADOR', 2),
  ('Fe', 'ESPECIALISTA', 1),
  ('Fi', 'PLANTA', 2),
  ('Fi', 'INV_RECURSOS', 1),
  ('Fi', 'COORDENADOR', 3),
  ('Fi', 'FORMADOR', 1),
  ('Fi', 'MONITOR', 3),
  ('Fi', 'IMPLEMENTADOR', 2),
  ('Fi', 'TRAB_EQUIPE', 4),
  ('Fi', 'FINALIZADOR', 3),
  ('Fi', 'ESPECIALISTA', 3),
  ('Se', 'PLANTA', 1),
  ('Se', 'INV_RECURSOS', 3),
  ('Se', 'COORDENADOR', 2),
  ('Se', 'FORMADOR', 4),
  ('Se', 'MONITOR', 1),
  ('Se', 'IMPLEMENTADOR', 5),
  ('Se', 'TRAB_EQUIPE', 3),
  ('Se', 'FINALIZADOR', 2),
  ('Se', 'ESPECIALISTA', 2),
  ('Si', 'PLANTA', 1),
  ('Si', 'INV_RECURSOS', 1),
  ('Si', 'COORDENADOR', 2),
  ('Si', 'FORMADOR', 1),
  ('Si', 'MONITOR', 4),
  ('Si', 'IMPLEMENTADOR', 5),
  ('Si', 'TRAB_EQUIPE', 3),
  ('Si', 'FINALIZADOR', 5),
  ('Si', 'ESPECIALISTA', 4),
  ('Ne', 'PLANTA', 4),
  ('Ne', 'INV_RECURSOS', 5),
  ('Ne', 'COORDENADOR', 3),
  ('Ne', 'FORMADOR', 3),
  ('Ne', 'MONITOR', 1),
  ('Ne', 'IMPLEMENTADOR', 1),
  ('Ne', 'TRAB_EQUIPE', 3),
  ('Ne', 'FINALIZADOR', 1),
  ('Ne', 'ESPECIALISTA', 1),
  ('Ni', 'PLANTA', 5),
  ('Ni', 'INV_RECURSOS', 2),
  ('Ni', 'COORDENADOR', 2),
  ('Ni', 'FORMADOR', 2),
  ('Ni', 'MONITOR', 4),
  ('Ni', 'IMPLEMENTADOR', 1),
  ('Ni', 'TRAB_EQUIPE', 1),
  ('Ni', 'FINALIZADOR', 2),
  ('Ni', 'ESPECIALISTA', 4)
on conflict (perfil_codigo, papel) do update set valor = excluded.valor;

-- ─── Banco fixo de questões e alternativas (item 13) ─────────────────────
do $seed$
declare v_versao uuid; v_questao uuid;
begin
  select id into v_versao from versoes_instrumento where codigo = 'v1.0-piloto';

  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q001', 'FUNCAO'::tipo_item, 2, 'informações incompletas', 'A equipe recebe um problema novo e ainda existem poucas informações disponíveis. Qual comportamento mais se aproxima da sua tendência inicial?', 1)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q001A', 'Procuro organizar os fatos existentes e encontrar uma lógica entre eles.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q001B', 'Converso com as pessoas envolvidas para compreender diferentes perspectivas e impactos.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q001C', 'Observo cuidadosamente aquilo que já é concreto e verificável.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q001D', 'Começo a imaginar diferentes cenários e possibilidades que ainda não foram consideradas.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q002', 'ATITUDE'::tipo_item, 1, 'reuniões', 'Uma reunião importante começa e o tema é aberto para discussão. O que você costuma fazer nos primeiros minutos?', 2)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q002A', 'Já coloco minhas primeiras leituras na mesa e vou ajustando conforme os outros reagem.', 'E'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q002B', 'Puxo a conversa perguntando às pessoas o que cada uma está vendo.', 'E'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q002C', 'Escuto o conjunto até formar uma posição, e só então falo.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q002D', 'Reviso mentalmente o material que preparei antes de intervir.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q003', 'FUNCAO'::tipo_item, 1, 'tomada de decisão', 'Você precisa escolher entre duas propostas de trabalho igualmente defensáveis. O que pesa mais na sua escolha?', 3)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q003A', 'Qual delas é mais consistente com os critérios que já definimos.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q003B', 'Qual delas as pessoas envolvidas conseguirão sustentar de verdade.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q003C', 'Qual delas já se mostrou viável na prática em situações parecidas.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q003D', 'Qual delas abre mais caminhos para o que vem depois.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q004', 'ATITUDE'::tipo_item, 1, 'aprendizagem', 'Você precisa dominar rapidamente um assunto novo para o trabalho. Como tende a começar?', 4)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q004A', 'Procuro alguém que já domina e converso para acelerar o entendimento.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q004B', 'Começo a mexer na ferramenta ou no material e aprendo no processo.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q004C', 'Leio e organizo o conteúdo por conta própria antes de discutir com alguém.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q004D', 'Monto um roteiro de estudo e sigo por etapas.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q005', 'FUNCAO'::tipo_item, 1, 'problemas inesperados', 'Um problema inesperado interrompe o andamento do trabalho. Sua primeira reação tende a ser:', 5)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q005A', 'Identificar a causa e a cadeia que levou até aqui.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q005B', 'Verificar quem foi afetado e o que isso significa para as pessoas.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q005C', 'Levantar exatamente o que está acontecendo agora, ponto por ponto.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q005D', 'Perceber o que esse problema revela sobre algo maior.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q006', 'ATITUDE'::tipo_item, 2, 'pressão', 'Um período de pressão intensa se instala na equipe. Onde você busca o que precisa para se sustentar?', 6)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q006A', 'Na conversa e no contato frequente com as pessoas ao redor.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q006B', 'Em manter-me em movimento, resolvendo uma coisa depois da outra.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q006C', 'Em um espaço de silêncio para reorganizar as ideias antes de seguir.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q006D', 'Em reduzir o escopo ao que domino e trabalhar de forma previsível.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q007', 'FUNCAO'::tipo_item, 1, 'reuniões', 'Em uma reunião de trabalho, qual é a contribuição que você mais costuma dar?', 7)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q007A', 'Aponto inconsistências e ajudo a fechar o raciocínio.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q007B', 'Percebo quem não está confortável e traz essa pessoa para a conversa.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q007C', 'Traz os dados concretos e o histórico do que já foi feito.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q007D', 'Levanto ângulos que ainda não apareceram na discussão.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q008', 'ATITUDE'::tipo_item, 1, 'comunicação', 'Você tem uma ideia que considera relevante mas ainda não totalmente formada. O que costuma fazer?', 8)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q008A', 'Compartilho no estado em que está e vou lapidando na conversa.', 'E'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q008B', 'Testo com uma ou duas pessoas informalmente para ver como reage.', 'E'::polo_jung, 'EXP'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q008C', 'Trabalho nela até que esteja consistente e só então apresento.', 'I'::polo_jung, 'EST'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q008D', 'Escrevo para mim mesmo primeiro, até entender o que realmente penso.', 'I'::polo_jung, 'AUT'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q009', 'FUNCAO'::tipo_item, 1, 'planejamento', 'Ao planejar um trabalho de vários meses, o que você constrói primeiro?', 9)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q009A', 'A estrutura de etapas, dependências e critérios de conclusão.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q009B', 'O acordo com as pessoas sobre papéis, expectativas e carga.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q009C', 'O levantamento do que já existe, dos recursos e das restrições reais.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q009D', 'A leitura do cenário em que esse trabalho vai desembocar.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q010', 'ATITUDE'::tipo_item, 1, 'organização', 'Como você costuma organizar seu próprio trabalho no dia a dia?', 10)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q010A', 'Vou reagindo ao que aparece e reorganizando a ordem conforme o dia anda.', 'E'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q010B', 'Combino com as pessoas ao redor e me organizo em função do ritmo delas.', 'E'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q010C', 'Mantenho um sistema próprio que só eu preciso entender.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q010D', 'Sigo uma rotina estável, com horários e blocos definidos.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q011', 'FUNCAO'::tipo_item, 1, 'conflitos', 'Duas pessoas da equipe estão em desacordo aberto. Qual é sua entrada mais natural?', 11)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q011A', 'Separar o que é divergência de critério do que é ruído.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q011B', 'Cuidar para que a relação entre elas não se rompa no processo.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q011C', 'Reconstituir o que de fato aconteceu, na ordem em que aconteceu.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q011D', 'Perceber o que esse desacordo está dizendo sobre algo não nomeado.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q012', 'ATITUDE'::tipo_item, 1, 'novas oportunidades', 'Surge uma oportunidade fora do escopo habitual da equipe. Como você tende a se posicionar?', 12)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q012A', 'Já começo a sondar contatos e a mapear quem pode abrir portas.', 'E'::polo_jung, 'EXP'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q012B', 'Levo para o grupo rapidamente para pensarmos juntos em voz alta.', 'E'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q012C', 'Avalio internamente se faz sentido antes de mobilizar ninguém.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q012D', 'Verifico se temos estrutura para sustentar isso antes de entusiasmar-me.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q013', 'FUNCAO'::tipo_item, 2, 'análise', 'Você recebe um relatório extenso para avaliar. Onde sua atenção vai primeiro?', 13)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q013A', 'À coerência interna: se as conclusões se sustentam a partir dos dados.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q013B', 'Ao que aquilo implica para as pessoas e áreas envolvidas.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q013C', 'À exatidão dos números, das fontes e dos detalhes verificáveis.', 'S'::polo_jung, 'EST'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q013D', 'Ao que o relatório sugere sobre a direção das coisas.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q014', 'ATITUDE'::tipo_item, 1, 'relacionamento', 'Você entra em uma equipe nova. Como tende a construir sua posição ali?', 14)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q014A', 'Circulando, conversando com muita gente e me tornando presente rápido.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q014B', 'Assumindo logo alguma entrega visível para mostrar o que sei fazer.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q014C', 'Observando as dinâmicas por um tempo antes de me expor.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q014D', 'Aprendendo primeiro os processos e a forma correta de operar ali.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q015', 'FUNCAO'::tipo_item, 1, 'prazos', 'Um prazo está apertado e algo terá de ser sacrificado. Como você decide o que sai?', 15)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q015A', 'Pelo critério de impacto: sai o que menos compromete o resultado.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q015B', 'Pelo acordo: converso com quem depende daquilo antes de cortar.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q015C', 'Pelo que já está pronto: preservo o que existe e concluo o possível.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q015D', 'Pelo que pode ser retomado depois sem perda: sai o que é reversível.', 'N'::polo_jung, 'FLE'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q016', 'ATITUDE'::tipo_item, 1, 'execução', 'Você tem uma tarefa longa e absorvente para entregar. Que condição faz você render mais?', 16)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q016A', 'Estar perto das pessoas, com trocas rápidas ao longo do caminho.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q016B', 'Ter movimento e variedade, alternando entre frentes diferentes.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q016C', 'Ter blocos longos e ininterruptos de concentração.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q016D', 'Ter um plano claro e um ambiente estável e previsível.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q017', 'FUNCAO'::tipo_item, 1, 'inovação', 'A equipe precisa encontrar uma solução realmente diferente para um problema antigo. Sua contribuição tende a ser:', 17)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q017A', 'Estruturar o problema de outro modo para que a solução apareça.', 'T'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q017B', 'Garantir que a solução seja aceitável para quem vai conviver com ela.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q017C', 'Testar rapidamente algo pequeno para ver o que acontece de fato.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q017D', 'Gerar várias hipóteses ainda não consideradas, mesmo as improváveis.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q018', 'ATITUDE'::tipo_item, 1, 'divergências', 'Você discorda de uma decisão que já foi tomada pelo grupo. O que costuma fazer?', 18)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q018A', 'Digo na hora, abertamente, e sustento o debate ali mesmo.', 'E'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q018B', 'Procuro as pessoas individualmente e reabro a conversa.', 'E'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q018C', 'Formulo com cuidado o argumento e escolho o momento de apresentá-lo.', 'I'::polo_jung, 'EST'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q018D', 'Sigo o combinado, mantendo minha avaliação para mim.', 'I'::polo_jung, 'AUT'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q019', 'FUNCAO'::tipo_item, 1, 'comunicação', 'Você precisa explicar um assunto complexo a quem não conhece o tema. Como estrutura a explicação?', 19)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q019A', 'Pela lógica: começo pelo princípio que organiza tudo.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q019B', 'Pela pessoa: começo pelo que importa para quem está ouvindo.', 'F'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q019C', 'Pelo exemplo concreto: mostro um caso real e vou generalizando.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q019D', 'Pela imagem: uso uma analogia que faça o conjunto aparecer de uma vez.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q020', 'ATITUDE'::tipo_item, 1, 'problemas inesperados', 'Algo dá errado no meio de uma entrega. Qual é seu primeiro movimento?', 20)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q020A', 'Aviso e mobilizo as pessoas necessárias imediatamente.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q020B', 'Parto para a ação e vou corrigindo enquanto ando.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q020C', 'Paro e entendo o que aconteceu antes de mover qualquer coisa.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q020D', 'Volto ao procedimento previsto para esse tipo de situação.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q021', 'FUNCAO'::tipo_item, 1, 'mudanças', 'A organização anuncia uma mudança significativa de direção. Qual é sua primeira pergunta interna?', 21)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q021A', 'Isso é coerente com o que vínhamos sustentando?', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q021B', 'Como isso vai cair para as pessoas que serão afetadas?', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q021C', 'O que muda concretamente no meu trabalho a partir de amanhã?', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q021D', 'Para onde isso nos leva daqui a dois ou três anos?', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q022', 'ATITUDE'::tipo_item, 1, 'prioridades', 'Você tem mais demandas do que consegue atender. Como define o que fazer primeiro?', 22)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q022A', 'Consulto quem está envolvido e negocio a ordem com eles.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q022B', 'Ataco primeiro o que está mais visível e destrava mais gente.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q022C', 'Faço minha própria leitura de importância e assumo a decisão.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q022D', 'Sigo os critérios de prioridade já estabelecidos.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q023', 'FUNCAO'::tipo_item, 1, 'negociação', 'Em uma negociação difícil, o que costuma sustentar sua posição?', 23)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q023A', 'A consistência do argumento e os dados que o apoiam.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q023B', 'A compreensão do que realmente importa para o outro lado.', 'F'::polo_jung, 'EXP'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q023C', 'O conhecimento preciso das condições concretas e das restrições.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q023D', 'A leitura de para onde a conversa pode ser levada.', 'N'::polo_jung, 'FLE'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q024', 'ATITUDE'::tipo_item, 1, 'aprendizagem', 'Depois de concluir um projeto, como você mais aprende com ele?', 24)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q024A', 'Conversando com os envolvidos sobre o que cada um percebeu.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q024B', 'Já aplicando o aprendido no projeto seguinte.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q024C', 'Revisando sozinho o percurso e formando minhas próprias conclusões.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q024D', 'Registrando o que funcionou para incorporar ao processo.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q025', 'FUNCAO'::tipo_item, 1, 'conclusão', 'Um trabalho está na fase final. Onde você coloca mais energia?', 25)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q025A', 'Em verificar se o resultado corresponde ao que foi definido.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q025B', 'Em cuidar de quem participou e reconhecer as contribuições.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q025C', 'Em revisar os detalhes e fechar as pontas soltas.', 'S'::polo_jung, 'EST'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q025D', 'Em identificar o que esse trabalho abriu para o próximo.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q026', 'ATITUDE'::tipo_item, 2, 'planejamento', 'Você precisa formar uma opinião sólida sobre um tema difícil. O que funciona melhor para você?', 26)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q026A', 'Pensar em voz alta com outras pessoas até a ideia se formar.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q026B', 'Experimentar na prática e deixar a opinião se formar pela experiência.', 'E'::polo_jung, 'EXP'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q026C', 'Elaborar internamente até chegar a uma posição própria.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q026D', 'Estudar de forma sistemática antes de concluir qualquer coisa.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q027', 'FUNCAO'::tipo_item, 1, 'execução', 'Você assume uma entrega com autonomia total. Como começa?', 27)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q027A', 'Definindo critérios de sucesso e a sequência de etapas.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q027B', 'Alinhando expectativas com quem vai receber o resultado.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q027C', 'Fazendo a primeira parte concreta e ajustando a partir dela.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q027D', 'Desenhando o cenário completo antes de tocar em qualquer parte.', 'N'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q028', 'ATITUDE'::tipo_item, 1, 'inovação', 'A equipe está buscando ideias novas. Em que situação você produz suas melhores contribuições?', 28)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q028A', 'Em discussão aberta, no calor da troca com o grupo.', 'E'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q028B', 'Circulando fora da equipe, vendo como outros resolvem.', 'E'::polo_jung, 'EXP'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q028C', 'Sozinho, com tempo, deixando a ideia amadurecer.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q028D', 'A partir de um método ou referência já organizada.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q029', 'FUNCAO'::tipo_item, 1, 'pressão', 'Sob forte pressão de tempo, qual recurso você aciona primeiro?', 29)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q029A', 'Corto pelo critério: defino o essencial e descarto o resto.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q029B', 'Chamo as pessoas certas e divido a carga.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q029C', 'Coloco a mão na massa e resolvo o que está na minha frente.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q029D', 'Procuro um caminho alternativo que ninguém tentou ainda.', 'N'::polo_jung, 'FLE'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q030', 'ATITUDE'::tipo_item, 1, 'conflitos', 'Há uma tensão não resolvida no ambiente de trabalho. Como você lida?', 30)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q030A', 'Nomeio a questão abertamente para que possa ser tratada.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q030B', 'Movimento a situação: proponho algo concreto que mude a dinâmica.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q030C', 'Observo e busco compreender a origem antes de agir.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q030D', 'Encaminho pelos canais e procedimentos apropriados.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q031', 'FUNCAO'::tipo_item, 1, 'relacionamento', 'Um colega procura você para falar de uma dificuldade no trabalho. O que você tende a oferecer primeiro?', 31)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q031A', 'Ajuda a organizar o problema e enxergar as opções com clareza.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q031B', 'Escuta e reconhecimento do que ele está vivendo.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q031C', 'Apoio prático: o que dá para fazer hoje para aliviar a situação.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q031D', 'Uma leitura mais ampla do que pode estar por trás daquilo.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q032', 'ATITUDE'::tipo_item, 1, 'prazos', 'Faltam poucos dias para uma entrega importante. Como você trabalha nesse período?', 32)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q032A', 'Aumento o contato com o time, sincronizando com frequência.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q032B', 'Acelero e faço o que aparecer, na ordem em que aparecer.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q032C', 'Me isolo para conseguir concentração total no que falta.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q032D', 'Sigo rigorosamente o plano de fechamento que montei antes.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q033', 'FUNCAO'::tipo_item, 1, 'organização', 'Você precisa colocar ordem em um processo confuso. Por onde começa?', 33)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q033A', 'Pela lógica do fluxo: o que depende de quê.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q033B', 'Pelas pessoas: quem faz o quê e como estão se sentindo nisso.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q033C', 'Pelo mapeamento do que existe hoje, exatamente como está.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q033D', 'Pela pergunta de para que esse processo existe, afinal.', 'N'::polo_jung, 'AUT'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q034', 'ATITUDE'::tipo_item, 1, 'análise', 'Você recebeu dados complexos para interpretar. Como conduz o trabalho?', 34)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q034A', 'Discuto os números com outras pessoas enquanto analiso.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q034B', 'Manipulo os dados de várias formas até algo aparecer.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q034C', 'Analiso sozinho e apresento quando tiver uma leitura formada.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q034D', 'Sigo um roteiro de análise definido, passo a passo.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q035', 'FUNCAO'::tipo_item, 1, 'divergências', 'Sua avaliação técnica difere da avaliação do grupo. O que costuma fazer?', 35)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q035A', 'Explicito o critério que usei e peço que apontem onde ele falha.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q035B', 'Procuro entender o que o grupo está valorizando que eu não vi.', 'F'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q035C', 'Trago as evidências concretas que sustentam minha leitura.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q035D', 'Reformulo a questão de outro jeito para deslocar o debate.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q036', 'ATITUDE'::tipo_item, 1, 'mudanças', 'Uma mudança de processo é anunciada para a semana seguinte. Qual é sua reação mais típica?', 36)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q036A', 'Já começo a testar e a descobrir na prática como vai funcionar.', 'E'::polo_jung, 'FLE'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q036B', 'Procuro as pessoas para entender como cada uma está recebendo isso.', 'E'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q036C', 'Preciso de um tempo para processar antes de me posicionar.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q036D', 'Quero saber o motivo e ver o novo procedimento documentado.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q037', 'FUNCAO'::tipo_item, 1, 'novas oportunidades', 'Uma oportunidade promissora aparece, mas com informação incompleta. Como você a avalia?', 37)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q037A', 'Monto o raciocínio de custo, risco e retorno com o que há.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q037B', 'Avalio se ela é compatível com o que consideramos importante.', 'F'::polo_jung, 'EST'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q037C', 'Busco verificar o que é fato e o que é ainda promessa.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q037D', 'Sinto se há algo ali e vou atrás mesmo sem tudo confirmado.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q038', 'ATITUDE'::tipo_item, 1, 'negociação', 'Você vai conduzir uma negociação importante. Como se prepara?', 38)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q038A', 'Converso com pessoas que conhecem o outro lado.', 'E'::polo_jung, 'EXP'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q038B', 'Confio na leitura que vou fazer no próprio momento da conversa.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q038C', 'Reflito sobre os cenários possíveis e defino minha posição sozinho.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q038D', 'Preparo material, números e limites antes de entrar na sala.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q039', 'FUNCAO'::tipo_item, 1, 'tomada de decisão', 'Uma decisão precisa ser tomada hoje e não há consenso. Como você contribui?', 39)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q039A', 'Proponho o critério de decisão e aplico.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q039B', 'Busco a formulação que o grupo consiga sustentar junto.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q039C', 'Aponto o que já sabemos com certeza e decido a partir daí.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q039D', 'Aponto qual das opções mantém mais portas abertas.', 'N'::polo_jung, 'FLE'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q040', 'ATITUDE'::tipo_item, 1, 'comunicação', 'Você precisa comunicar um resultado à organização. Qual formato prefere?', 40)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q040A', 'Apresentação ao vivo, com espaço para perguntas e discussão.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q040B', 'Conversas rápidas e diretas com cada pessoa envolvida.', 'E'::polo_jung, 'FLE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q040C', 'Um documento bem escrito que a pessoa lê no tempo dela.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q040D', 'Um relatório estruturado, com seções e dados organizados.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q041', 'FUNCAO'::tipo_item, 1, 'aprendizagem', 'Você errou em algo importante. Como processa esse erro?', 41)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q041A', 'Reconstituo a lógica da decisão para achar onde ela falhou.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q041B', 'Cuido do efeito que isso teve sobre as pessoas envolvidas.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q041C', 'Verifico o que exatamente foi feito e corrijo o que dá para corrigir.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q041D', 'Procuro o padrão: se isso já aconteceu antes de outra forma.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q042', 'ATITUDE'::tipo_item, 2, 'reuniões', 'Ao final de um dia inteiro de reuniões e interação, como você costuma se sentir?', 42)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q042A', 'Com energia: as conversas me deixaram mais ativado.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q042B', 'Bem, e com vontade de emendar em alguma coisa prática.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q042C', 'Preciso de um período sozinho para me recompor.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q042D', 'Preciso organizar tudo o que ficou pendente antes de parar.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q043', 'FUNCAO'::tipo_item, 1, 'prioridades', 'Sua equipe está dispersa em muitas frentes. O que você propõe?', 43)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q043A', 'Um critério objetivo para hierarquizar e cortar.', 'T'::polo_jung, 'EST'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q043B', 'Uma conversa sobre carga e sobre o que está pesando em cada um.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q043C', 'Um levantamento do estado real de cada frente antes de decidir.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q043D', 'Uma revisão do propósito: talvez a lista esteja errada, não a ordem.', 'N'::polo_jung, 'FLE'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q044', 'ATITUDE'::tipo_item, 1, 'conclusão', 'Você terminou uma entrega significativa. O que faz em seguida?', 44)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q044A', 'Compartilho com as pessoas e comemoro junto.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q044B', 'Emendo direto na próxima coisa.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q044C', 'Recolho-me um pouco para digerir o que acabou de passar.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q044D', 'Fecho a documentação e os registros antes de seguir.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q045', 'FUNCAO'::tipo_item, 1, 'informações incompletas', 'Você precisa se posicionar sobre um tema em que faltam dados essenciais. O que faz?', 45)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q045A', 'Explicito as premissas que estou assumindo e decido sobre elas.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q045B', 'Consulto quem tem experiência prática no assunto.', 'F'::polo_jung, 'EXP'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q045C', 'Espero até ter o dado mínimo verificável.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q045D', 'Trabalho com hipóteses e sigo, ajustando conforme aparecer.', 'N'::polo_jung, 'FLE'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q046', 'ATITUDE'::tipo_item, 1, 'execução', 'Um trabalho pode ser feito individualmente ou em dupla, com o mesmo resultado. O que escolhe?', 46)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q046A', 'Em dupla: a troca constrói o resultado junto com o processo.', 'E'::polo_jung, 'COO'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q046B', 'Em dupla, dividindo em partes e cada um acelerando a sua.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q046C', 'Individualmente: rendo mais sem precisar sincronizar.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q046D', 'Individualmente, seguindo meu próprio método já testado.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q047', 'FUNCAO'::tipo_item, 2, 'mudanças', 'A equipe precisa abandonar um jeito de trabalhar que funcionava bem. O que mais pesa para você?', 47)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q047A', 'Se a razão da mudança se sustenta logicamente.', 'T'::polo_jung, 'AUT'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q047B', 'Se as pessoas que construíram aquilo estão sendo consideradas.', 'F'::polo_jung, 'COO'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q047C', 'O que se perde concretamente e o que já está garantido no novo jeito.', 'S'::polo_jung, 'EXE'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q047D', 'O que o novo jeito torna possível e o antigo impedia.', 'N'::polo_jung, 'EXP'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into questoes (versao_id, codigo, tipo, peso, contexto, enunciado, ordem)
  values (v_versao, 'Q048', 'ATITUDE'::tipo_item, 1, 'prioridades', 'De modo geral, onde você diria que sua atenção se dirige mais naturalmente no trabalho?', 48)
  on conflict (versao_id, codigo) do update set
    tipo = excluded.tipo, peso = excluded.peso, contexto = excluded.contexto,
    enunciado = excluded.enunciado, ordem = excluded.ordem
  returning id into v_questao;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q048A', 'Ao que está acontecendo em volta: pessoas, movimentos, demandas.', 'E'::polo_jung, 'EXP'::eixo_aux, 1)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q048B', 'À ação: ao que precisa ser movido e resolvido agora.', 'E'::polo_jung, 'EXE'::eixo_aux, 2)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q048C', 'Ao meu próprio processamento: ao que aquilo significa e como se organiza.', 'I'::polo_jung, 'AUT'::eixo_aux, 3)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
  insert into alternativas (questao_id, codigo, texto, jung, eixo, ordem)
  values (v_questao, 'Q048D', 'Ao que precisa ser mantido em ordem, previsível e sob controle.', 'I'::polo_jung, 'EST'::eixo_aux, 4)
  on conflict (questao_id, codigo) do update set texto = excluded.texto, jung = excluded.jung, eixo = excluded.eixo;
end $seed$;

commit;