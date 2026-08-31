# ALTERAÇÕES REALIZADAS — v3.0 ROTA26

Item 106 do prompt-mestre. Separado em **ADICIONADO**, **AJUSTADO**,
**REMOVIDO DA DEMO** e **PRESERVADO**, para que se possa conferir que nenhuma
alteração não autorizada foi feita.

A prova mecânica está em `baseline.json` e em `npm run regressao`: cinco
conjuntos controlados de 48 respostas e uma população fixa de 96 participantes,
congelados **antes** da refatoração e reexecutados **depois**. Resultado:
**nenhuma divergência**.

---

## PRESERVADO

Nada abaixo foi tocado. Verificado campo a campo pelo teste de regressão.

**Instrumento** — as 48 questões e seus textos · as 192 alternativas e seus
textos · a ordem e a estrutura conceitual dos itens · os pesos (âncoras de peso 2)
· a chave de pontuação Jung de cada alternativa · a matriz de pontuação funcional
de 192 linhas · as regras de desempate D1/D2/D3 · a versão do instrumento
(`v1.0-piloto`) e a da matriz (`v2.0`).

**Trilha psicológica** — os 8 perfis junguianos · perfil predominante e
secundário · os 8 animais e a associação Jung × animal · os textos de cada animal
· luz e sombra · as descrições profissionais · Extroversão, Introversão,
Pensamento, Sentimento, Sensação e Intuição, brutos e relativos · função
dominante, auxiliar, inferior e menos representada.

**Trilha funcional** — os seis eixos comportamentais · as dez capacidades ·
os escores e as proximidades Belbin · a ordenação e as três maiores proximidades
· as faixas de intensidade.

**Análises coletivas** — a fórmula do IDF e seus três componentes · a fórmula do
ICF e o limiar de portador (50) · complementaridade · concentração (HHI) ·
todas as distribuições · o limite de amostra de 5 respondentes.

**Aplicação** — estrutura de setores · filtros · exportações que já funcionavam ·
funcionalidades administrativas · avisos metodológicos · linguagem não
diagnóstica · toda a camada de produção da etapa anterior (`APP_MODE`, trava do
seed, view de dados reais, limpeza DEMO, RLS, auditoria).

> Confirmação numérica dos cinco conjuntos, idêntica antes e depois:
>
> | Conjunto | Perfil | Secundário | E / I | T / F / S / N | Belbin (top 3) |
> |---|---|---|---|---|---|
> | C1 | Te | Se | 100 / 0 | 100 / 0 / 0 / 0 | Monitor > Formador > Coordenador |
> | C2 | Fe | Se | 100 / 0 | 0 / 100 / 0 / 0 | Trab. Equipe > Coordenador > Formador |
> | C3 | Te | Se | 55,6 / 44,4 | 51,9 / 0 / 48,1 / 0 | Implementador > Finalizador > Monitor |
> | C4 | Ni | Fi | 44,4 / 55,6 | 0 / 48,1 / 0 / 51,9 | Planta > Trab. Equipe > Inv. Recursos |
> | C5 | Te | Se | 55,6 / 44,4 | 37 / 14,8 / 29,6 / 18,5 | Implementador > Formador > Monitor |
>
> População de referência (96 participantes, 16 equipes): **IDF 84,2 · ICF 62,7 ·
> complementaridade 100%** — antes e depois.

---

## ADICIONADO

### Composição simbólica (Partes I e J)

- `src/lib/animais.ts` — **rotina única** de agregação dos animais
  (`composicaoAnimais`, `matrizAnimais`), usada por dashboard **e** Excel.
  É o que garante o item 66: não existe uma segunda contagem no projeto.
- Bloco **Composição simbólica da equipe** no dashboard: os oito animais com
  quantidade e percentual, **incluindo os que estão em zero** (item 53).
- **Maior** e **menor representação relativa** (itens 54 e 55). A palavra
  "lacuna" não é usada para animal ausente.
- Validação da soma (item 56): se os oito animais não somarem o total de
  avaliações válidas, a tela emite alerta de inconsistência.
- Tela **Animais** (`/dashboard/animais`): matriz Equipe × Animal com alternância
  entre **quantidade** e **percentual** (item 58) e filtros declarados (item 59).

### Resultado individual (Partes D e E)

- Reorganizado nos **oito blocos** do item 26. Nada foi retirado.
- Bloco 4 **Suas potências** — novo, composto por `potenciasIndividuais()`, que
  só reúne escores já calculados e imprime o número que sustenta cada linha.
- Bloco 8 ampliado: mesma função dominante, mesma atitude, posição relativa e
  participação percentual do perfil (item 30).
- **O que sua presença acrescenta à configuração da equipe** (item 31), via
  `presencaNaConfiguracao()` — usa dados já calculados, sem nova classificação.
- Componente `Totem`: tratamento simbólico do animal, com a fórmula
  "Sua maior correspondência simbólica" (item 27).

### Liderança (Partes G e H)

- Bloco **"Onde existe complementaridade"** na leitura executiva (item 47),
  cruzando cobertura e portadores — dois números que a análise já produzia.
- Seção **AÇÃO — Como liderar esta configuração** separada da interpretação
  (item 48), com aviso explícito de que não prescreve decisão de emprego.

### Excel (Parte K)

- Aba **Composição dos Animais** — Equipe | Animal | Quantidade | Percentual | Total da Equipe (item 62).
- Aba **Animais por Equipe** — matriz em quantidade (item 63).
- Aba **Percentual de Animais** — a mesma matriz em percentual (item 64).
- Coluna **Animal predominante** na tabela individual de Participantes (item 65).
- Seis verbetes novos no Dicionário de Dados descrevendo as abas acrescentadas.

### Administração (Parte L)

- Menu do Master reorganizado em dez entradas (item 68), todas apontando para
  telas que existem de fato.
- Aba **Configurações** na Gestão de dados: versões, parâmetros de IDF e ICF,
  limiar de portador, amostra mínima e equipes — **em leitura**, porque editar
  qualquer um deles mudaria resultados já colhidos.
- Zona de segurança visualmente destacada das demais abas (item 69).

### Identidade e design system (Parte M)

- Design system Rota26 completo: tipografia, paleta, escala de espaço, raio,
  sombra, cards, botões, campos, tabelas, gráficos, alertas, estados vazios,
  carregamento e erro.
- Lockup **ROTA26** e novo cabeçalho.
- Tratamento dos animais como **totem** sóbrio, com a cor canônica de
  `profiles.ts` em todas as telas (item 77).
- Foco visível, `sr-only` com alternativa textual aos gráficos, `prefers-reduced-motion`,
  folha de impressão e responsividade até 390px (itens 81 e 82).

### Leitura das siglas e explicações clicáveis

- `src/data/glossario.ts` — **59 verbetes** cobrindo toda sigla que chega à tela
  ou à planilha: IDF, ICF, HHI, complementaridade, n; E, I, T, F, S, N; os 8
  perfis; os 6 eixos; as 10 capacidades; os 9 papéis de Belbin; e os termos
  técnicos. Cada verbete responde a **o que é**, **por que é assim** e **onde aparece**.
- Componentes `PorQue`, `ExplicaSigla`, `Sigla`, `CartaoVerbete` e `Glossario`,
  construídos sobre `<details>/<summary>` nativos: funcionam sem JavaScript, já
  são navegáveis por teclado e anunciados por leitor de tela, e a impressão abre
  todos.
- **Interpretação visível** em cada indicador (`Kpi` ganhou `leitura` e `sigla`):
  o dashboard passa a dizer, em texto e sem clique, o que aquele número indica.
- `leituraIDF()` e `leituraICF()` traduzem o número calculado em uma frase,
  sem adjetivo de valor e sem comparação com norma — porque norma não existe.
- Explicações ligadas ao resultado individual (perfil, funções, eixos,
  capacidades, Belbin, empate, escore relativo), ao dashboard (Síntese,
  Diversidade, Cobertura) e à Metodologia.
- Página **/glossario** aberta a todos os papéis, com os grupos filtrados por papel.
- `scripts/test-glossario.ts` — 23 verificações, incluindo cobertura obrigatória:
  se alguém acrescentar um eixo, capacidade ou papel e esquecer o verbete, falha.

### Verificação

- `baseline.json` + `npm run baseline` + `npm run regressao` (itens 7, 8 e 104).
- `scripts/test-animais.ts` — 16 verificações (itens 51 a 56, 66, 99).
- `scripts/test-excel-animais.ts` — 13 verificações que **abrem o .xlsx gerado**
  e comparam célula a célula com o dashboard (itens 67 e 100).

### Documentação

`GUIA_TECNICO_TI.md` · `MANUAL_ADMINISTRADOR.md` · `DICIONARIO_DE_DADOS.md` ·
`DIAGRAMA_BANCO.md` · `CHECKLIST_GOLIVE.md` · `RELATORIO_DE_TESTES.md` ·
`INVENTARIO_DE_ALTERACOES.md` · `SUGESTOES_NAO_IMPLEMENTADAS.md` · este changelog.

---

## AJUSTADO

Apenas apresentação. Nenhum número mudou.

| O que | De | Para |
|---|---|---|
| Marca | "Mapeamento da Diversidade…" | **ROTA26** + o mesmo título |
| Selo | "Aplicação Organizacional — Instrumento Piloto" | "Instrumento Piloto de Desenvolvimento Organizacional" |
| Resultado individual | seções A–H em ordem própria | **oito blocos** do item 26 |
| Belbin | "Monitor Avaliador — 58,9" | escore **+** "proximidade alta" **+** cinco leituras |
| Dashboard da equipe | seções A–F | **Síntese · Composição · Diversidade · Cobertura · Interpretação · Ação** |
| Gestão de dados | 4 abas | 5 abas, com Zona de segurança destacada |
| Perfis no gráfico da equipe | só os com n > 0 | **todos os 8**, os vazios em cinza |

---

## REMOVIDO DA DEMO

Concluído na etapa anterior e mantido:

- "Você está na demonstração", "Demonstração navegável", "dados simulados",
  "memória do navegador" da interface de produção;
- `master@demo` como autor de log e de exportação;
- geração automática de participantes fictícios em produção.

O arquivo `dist/demo.html` continua existindo, agora rotulado como
**pré-visualização de desenvolvimento** — mesmo código de cálculo, sem banco.
Não é a aplicação.

---

## DEFEITOS REAIS CORRIGIDOS DURANTE A ETAPA

Dois, ambos encontrados por teste automatizado e ambos de apresentação:

1. **`Card` engolia o conteúdo de `acao` quando não havia título.** O
   alternador quantidade/percentual da matriz de animais (item 58) simplesmente
   não era renderizado. O cabeçalho do cartão passou a aparecer quando houver
   título **ou** subtítulo **ou** ação.
2. **`.belcard` e `.dim` eram usados sem existir no CSS.** Os cartões de Belbin
   e as dez dimensões vinham sem estilo desde a versão anterior. Agora têm.

3. **Colisão entre `N` e `n` no glossário.** A busca por sigla normalizava para
   maiúsculas, então o verbete de "número de respondentes" sobrescrevia o de
   Intuição — e o resultado individual exibiria a explicação errada na letra N.
   A busca passou a ser exata primeiro, com a versão sem caixa apenas como
   reserva. Encontrado pelo teste de cobertura do glossário, na primeira execução.

Nenhum dos três afetava cálculo.

---

# v3.1 — REDESIGN VISUAL ROTA26

Etapa **exclusivamente visual**. O prompt de redesign é explícito sobre o que
não estava autorizado: perguntas, alternativas, textos técnicos, cálculos,
pontuações, perfis, animais, Jung, Belbin, IDF, ICF, banco de dados, regras,
resultados, funcionalidades, filtros, dashboards e exportações. **Nada disso foi
tocado.** `npm run regressao` continua respondendo **nenhuma divergência** — os
mesmos cinco conjuntos e a mesma população de 96 dão exatamente os mesmos
números de antes do redesign.

## A marca (itens 3, 4 e 39)

- O logotipo oficial entrou como **arquivo**, em `public/marca/`:
  `rota26-original.png` (como recebido), `rota26.png` (aparado, 479×385) e
  `rota26@2x.png` (420px de largura, o que a interface serve).
- **Não foi redesenhado, não foi recortado, não foi deformado, não foi
  recolorido, não recebeu efeito, não foi posto dentro de escudo e não foi
  recriado por CSS.** A proporção 479:385 é preservada em toda tela.
- O arquivo é um relevo 3D sobre uma parede creme. Recortar o fundo deixaria
  halo na borda das letras, então a marca é apresentada sobre uma **placa creme**
  (`.placa`) que continua a própria parede do arquivo. Foi a forma de honrar o
  item 39 sem tocar no desenho.
- O antigo lockup em CSS foi retirado — o item 39 manda usar o arquivo oficial
  quando ele existe, e ele passou a existir.

## A paleta (item 5)

Amostrada **pixel a pixel do próprio arquivo da marca**, com PIL/numpy, em vez
de escolhida por semelhança. `src/data/marca.ts` registra a origem de cada valor:

| Token | Valor | De onde veio |
|---|---|---|
| `--amarelo` | `#DCA436` | mediana dos pixels amarelos do "26" |
| `--bronze` | `#A66A17` | a **sombra** do relevo amarelo |
| `--grafite` | `#2B2A28` | média das letras de "ROTA" |
| `--marfim` | `#EFE6D6` | a parede do logotipo |

O achado que organizou o resto: bronze e amarelo são **a mesma cor em duas
profundidades**. Por isso o acento da interface e o acento da marca não brigam —
são o mesmo pigmento, um à luz e outro à sombra. Preto, carvão e grafite claro
saíram por interpolação dessa mesma família.

- Os gráficos foram trazidos para dentro da família (`CORES_FUNCAO`,
  `CORES_ATITUDE`). **Nenhuma série mudou de valor** — apenas de cor.

## A "rota" como linguagem (itens 12, 19 e 20)

- `TracoRota` — o traço da estrada, com o tracejado amarelo do logotipo, usado
  como divisor e como fio condutor.
- A barra de progresso do questionário passou a ser um **percurso**, não um tubo.
- Estados de carregamento usam um **nó de rota**, não um spinner genérico.
- Estado vazio ilustrado com o mesmo traço, em vez de caixa cinza.

## Hierarquia e telas

- Cabeçalho sóbrio com hierarquia **ROTA26 → nome do instrumento → selo
  "Instrumento Piloto de Desenvolvimento Organizacional"** (itens 6 a 9).
- **Abertura de impacto** (item 10): fundo escuro, frase curta, um único botão.
- **Resultado individual** (itens 21 a 27): abertura escura com o animal em disco
  de bronze, depois conteúdo claro; os oito blocos ganharam ritmo narrativo, sem
  que um único texto fosse reescrito.
- **Belbin** (itens 28 a 30): hierarquia elegante, sem tabela crua.
- **Dashboard executivo** (itens 31 a 35): claro, não todo escuro; a primeira
  dobra responde à pergunta do item 25.
- Família única de ícones; responsivo até 390px sem rolagem horizontal; alvos de
  toque de 324×104.

## Os oito animais (item 40) — ainda provisórios

`src/components/animais-svg.tsx` define os oito como `<symbol>` SVG em madeira
entalhada, três planos de tom, todos em perfil à esquerda, cada um com um
elemento-assinatura. **São uma proposta de linguagem, não a versão final**: o
item 40 manda adaptá-los ao selo circular oficial dos oito animais, e **esse
arquivo ainda não foi recebido**. Recebendo o selo, as oito marcas são
recalibradas para a mesma textura e iluminação, e o selo assume os três lugares
que lhe cabem (abertura, cabeçalho da Composição Simbólica e marca-d'água a 6%).
Enquanto isso, os critérios de aceite 1 e 2 permanecem **parcialmente pendentes**.

## Proposta de design system (item 43)

Apresentada **antes** de qualquer alteração de código, como o item exige, e
depois atualizada com o arquivo real e a paleta amostrada dele.

## Defeitos reais corrigidos nesta etapa

Todos de apresentação, todos encontrados por teste:

1. `.abertura .figura` colapsava o SVG para 0×0 — `aspect-ratio:1` somado a
   padding percentual e `place-items:center` fazia `width:100%` resolver em zero.
2. `DefinicoesAnimais` era injetado duas vezes (16 símbolos, IDs duplicados).
   Passou para a raiz em `layout.tsx`.
3. `.card + .card` aplicava margem também dentro de grid, desalinhando o topo dos
   KPIs. Restringido a `:not(.grid) >`.
4. Barra secundária ilegível (`#C3B7A3` sobre trilho `#E3D9C8`, que lia como
   barra cheia). Escurecida para `#B29A79`.
5. O selo "Instrumento Piloto" tinha sumido da pré-visualização na reescrita do
   cabeçalho — regressão real, restaurada.
6. **Os oito `<symbol>` eram definidos duas vezes.** `views-gestao.tsx`
   renderizava `<DefinicoesAnimais />` na tela de Animais, além da definição já
   feita na raiz. Dezesseis símbolos com oito IDs repetidos — HTML inválido,
   visualmente inofensivo porque `<use>` resolve o primeiro. Removida a cópia.
7. **Os campos de identificação não tinham `label` associado.** `<label>` sem
   `htmlFor` e `<input>` sem `id`: um leitor de tela anunciava "caixa de edição"
   sem dizer de quê. Corrigido com `htmlFor`/`id`, `aria-invalid`,
   `aria-describedby` ligando a mensagem de erro ao campo e `role="alert"`.

Nenhum afetava cálculo. Os dois últimos foram encontrados pela bateria de
navegador reescrita nesta etapa (`npm run test:ui`, 48/48).

## Acrescentado à verificação

- `scripts/build-previa.mjs` — o gerador da pré-visualização passou a ser arquivo
  do projeto. Antes era um comando avulso, e quem recebesse o código não
  conseguiria reconstruir o `.html` de demonstração.
- `scripts/test-ui.mjs` — as 48 verificações de navegador, também como arquivo do
  projeto, incluindo as sete que protegem a marca (item 39).
- `npm run previa`, `npm run test:ui` e `npm run verificar:tudo`.

---

# v3.2 — SEPARAÇÃO ENTRE ADMINISTRAÇÃO E RESPONDENTE

Etapa disparada por uma pergunta simples: *existe perfil, e o administrador
está separado de quem responde?* A resposta foi verificada com JWT real dos
três papéis contra o RLS, não lida no código. `npm run regressao`: **nenhuma
divergência** — nada aqui toca escore.

## O que a verificação confirmou

Os três papéis funcionam como documentado. Com token de cada um, pela API:
participante enxerga só a própria linha; `ADMIN_SETOR` vê o próprio setor e
**zero** respostas brutas; trocado o setor do `ADMIN_SETOR`, tudo cai para zero.
Tentativas de escalada de um participante — criar avaliação alheia, inserir-se
em `administradores`, gravar resposta em avaliação de outro — todas 403, e a
tentativa de apagar respostas alheias não afetou nenhuma linha.

## Defeitos reais corrigidos

1. **O MASTER perdia todos os dashboards ao cadastrar o segundo administrador.**
   `sessao.papel()` fazia `.maybeSingle()` em `administradores` sem filtrar por
   `user_id`, e a policy `admins_leitura` devolve ao MASTER **todas** as linhas.
   Com dois administradores, `maybeSingle()` erra, `data` vem nulo e o MASTER é
   rebaixado a participante. Reproduzido e corrigido: filtro por `auth.uid()`
   em `sessao.papel()` e em `repo-supabase.papelDoUsuario()`.
2. **O participante conseguia apagar-se dos relatórios.** `PATCH /participantes`
   com sessão comum aceitava `is_demo = true` — a linha some de `vw_resultados`
   e, com ela, de todo indicador, relatório e planilha. RLS no PostgreSQL não
   distingue coluna. `07_papeis.sql` acrescenta um trigger que recusa alteração
   de `is_demo`, `is_test` e `ativo` por quem não é administração.
3. **`npm run build` estava quebrado.** O bind mount do compose criava
   `src/app/api/dev-login/route.ts` vazio e com dono `root` no diretório do
   projeto — `File ... is not a module`. O compose passou a montar o diretório,
   não o arquivo, e o `.next` do container saiu para fora do `.next` do projeto.

## Adicionado

- `supabase/07_papeis.sql` — `eh_conta_administrativa()`, a coluna
  `eh_administrador` nas duas views de resultado e o trigger de proteção.
- **Marcação do administrador que responde.** A conta que administra pode
  responder às 48 situações; a linha aparece no painel nominal com a etiqueta
  `administração` e na planilha na coluna *Administrador*. É marcação, não
  exclusão — continua contando em todos os indicadores.

---

# v3.3 — SESSÃO, LOGIN E PUBLICAÇÃO

Etapa disparada pela pergunta "como publico isso na Vercel". A verificação
antes de qualquer código mostrou que publicar não era o problema.

## O defeito que impedia publicar

**A aplicação nunca teve tela de login.** A rota `/api/dev-login` só existia
dentro do container Docker, montada pelo compose. E toda policy de RLS é
`to authenticated`. Medido com a chave anônima e sem sessão:

```
GET /rest/v1/setores  →  []
GET /questionario     →  "Nenhum setor"
```

Publicado como estava, o endereço abriria a home e o glossário e **nada mais**:
ninguém responderia as 48 situações, ninguém abriria dashboard. O
`MANUAL_ADMINISTRADOR.md` já prometia "faça login com e-mail e senha" — uma
tela que o código não tinha.

## Adicionado

- **Sessão anônima para quem responde** (`garantirSessao`, chamada por
  `Fluxo.tsx` antes da primeira consulta). O usuário anônimo tem
  `role: authenticated` e `is_anonymous: true`, então `auth.uid()` existe e
  **todas as policies valem sem uma linha de alteração**. Verificado com JWT
  anônimo real: lê os 16 setores e as questões, cria o próprio participante,
  abre a própria avaliação, grava e relê a própria resposta — e vê zero linhas
  de participantes, respostas, resultados e `administradores` de terceiros.
  Tentar inserir-se em `administradores`: 403.
- **`/entrar`** — login com e-mail e senha para a administração, na identidade
  do projeto. Mensagem de erro única, que não revela se o e-mail existe.
  Sem auto-cadastro nem recuperação: contas de administração nascem no painel
  do Supabase.
- **`POST /api/sair`** — encerra a sessão. Rota de servidor, não botão em
  JavaScript: fazer isso no cliente colocava a biblioteca do Supabase (~66 kB)
  no bundle de **toda** página, inclusive a abertura. POST, e não GET, porque
  um `<img src>` de terceiro deslogaria a pessoa.
- **`src/middleware.ts`** — renova o token de acesso. Server Component não pode
  gravar cookie (por isso o `try/catch` em `sessao.ts`), então sem middleware
  quem deixava a aba aberta voltava e encontrava "acesso restrito".
- **`<AcessoRestrito />`** e a remoção de `exigirAdmin()` — com a aplicação
  pública, digitar `/dashboard` sem ser administrador é uso normal, e o guard
  antigo respondia **HTTP 500** a isso: "o servidor quebrou" para quem apenas
  não tem permissão, além de encher o monitoramento de falhas inexistentes. As
  cinco páginas de dashboard passaram a comparar o papel e devolver a tela de
  acesso restrito com 200 e caminho para `/entrar` — o mesmo padrão que
  `/admin/dados` já usava. Verificado: as seis rotas respondem 200 a um
  visitante anônimo.
- **`src/app/dashboard/error.tsx`** — rede de segurança para o que quebra de
  verdade, na linguagem da aplicação em vez da página de erro do Next. Mantém
  a distinção do item 24: erro de consulta diz que os números não foram lidos,
  nunca que não existem.
- **`src/lib/supabase.ts`** — os três clientes em módulo próprio, para que um
  componente que só abre sessão não arraste as 48 questões e o algoritmo de
  pontuação. Sem isso, toda página passava de 139 kB para 205 kB.
- **`.vercelignore`** — segurança, não arrumação: mantém `docker/` fora do
  envio, onde ficam o `JWT_SECRET` e a `SERVICE_KEY` da pilha local.

## Dois limites do modo anônimo, declarados

1. O Supabase limita cadastros anônimos por hora **e por IP** (padrão 30). Uma
   equipe atrás do mesmo NAT corporativo estoura isso — o teto precisa ser
   elevado antes da aplicação em massa.
2. Endereço público significa que qualquer pessoa pode responder. O controle
   continua sendo a matrícula, como já era. CAPTCHA ou contas nominais são as
   saídas, se isso incomodar; nenhuma das duas foi implementada.

`npm run regressao`: **nenhuma divergência**. Nada aqui toca metodologia.

---

# v3.4 — REAVALIAÇÃO v2.0: INFRAESTRUTURA (BLOCO B)

O pacote `rota26v2` (25/08/2026) entrega um **novo instrumento**, para conviver
com a `v1.0-piloto` que está publicada. Esta etapa instala o que ele traz de
motor, dados e banco. **As telas não foram religadas** — a versão entra inativa
e nada muda para quem responde hoje.

`npm run regressao`: **nenhuma divergência**. `npm run verificar`: exit 0.

## Instalado

- `src/data/v2/questoes.ts` — camada **pública**: só identificadores e textos.
- `src/data/v2/mapa.server.ts` · `desempate.server.ts` · `src/lib/v2/apuracao.ts`
  — camada **confidencial**, com `import 'server-only'`. Componente de cliente
  que os importe faz o `next build` falhar.
- `supabase/08_reavaliacao_v2.sql` · `scripts/test-apuracao-v2.ts` (47 testes) ·
  `scripts/test-sigilo.mjs` (12 testes) · a demo e as verificações em `demo/`.
- Dependência `server-only`. Scripts `test:v2` e `test:sigilo`.

Resultados na primeira execução dentro deste projeto: **47/47** no motor,
**12/12** no sigilo.

## Divergências entre o pacote e o projeto, resolvidas

1. **Dois arquivos `07`.** O pacote chamava a migração de `07_reavaliacao_v2.sql`,
   mas `07_papeis.sql` já existia **e já estava aplicado na nuvem**. Renumerado
   para **`08`** — renumerar o que já rodou seria pior. O motivo está no
   cabeçalho do arquivo.
2. **`verificar:tudo` já existia.** O `MUDANCAS.md` do pacote afirmava que
   nenhum script existente seria alterado. Os dois novos foram **encadeados** ao
   que havia, não substituíram.
3. **Caminhos da máquina de origem.** As verificações da demo importavam o
   Playwright de `/home/claude/app/node_modules/...`. Passaram a resolver a raiz
   a partir do próprio arquivo, e o Chromium por `CHROMIUM_PATH` — mesma
   convenção que `scripts/test-ui.mjs` já usava aqui.
4. **`cobertura`.** O pacote lista esse script mas não o define em lugar nenhum.
   Não foi inventado.

## Lacunas do pacote, fechadas na migração 08

5. **Nenhuma policy de escrita** em `resultados_v2` nem em `desempates` — só
   `select`. Do jeito que veio, concluir uma avaliação v2.0 seria barrado pelo
   RLS. **Decisão registrada na seção 7 do SQL:** a ausência é deliberada. Como o
   gabarito é `server-only`, a apuração só pode ocorrer no servidor, e a gravação
   passa por rota de servidor com a chave de serviço. Acrescentar policy de
   escrita seria desfazer a garantia, não corrigir um esquecimento.
6. **`resumo_organizacional()` não filtrava versão.** Ativada a v2.0, os quatro
   números do topo somariam as duas versões enquanto os painéis — que leem
   `vw_resultados`, com junção na tabela `resultados` da v1.0 — mostrariam só a
   v1.0. Topo e painel discordando sem nada estar quebrado. A função passou a
   contar pela **versão ativa**. Provado em transação desfeita: com o filtro, 1;
   sem ele, 2.

## Verificado contra o banco

Migração aplicada em transação, com backup antes. Depois: os quatro números do
resumo idênticos (2 · 1 · 0 · 16) e o **md5 das respostas inalterado**
(`39b03b6a…`). `versoes_instrumento` passou a ter as duas, com a v2.0 `ativa = false`.

## O que continua faltando

As cinco frentes de tela da seção 9 do documento técnico — participante,
desempate, resultado, gravação em `resultados_v2`, dashboard e relatório
integral. E as decisões da seção 10, que são do cliente: se capacidades e
proximidades Belbin desaparecem por pessoa, e se a tabela das nove contribuições
está aprovada.

## Achado que não é do pacote, mas apareceu na análise

**A chave de pontuação da v1.0 está pública no endereço no ar.** 191 das 192
alternativas, com polo junguiano e eixo, baixáveis dos chunks de
`/questionario` sem login. É consequência de `concluirAvaliacao` recalcular no
navegador — o `CLAUDE.md` afirmava que era no servidor, e foi corrigido. A
correção do código é o Bloco A, ainda não feito.

---

# v3.5 — A CHAVE DE PONTUAÇÃO SAI DO NAVEGADOR (BLOCO A)

Correção do vazamento medido na análise do pacote v2.0. Não é melhoria de
arquitetura: é defeito de sigilo no instrumento que estava coletando.

## O que estava acontecendo

`Fluxo.tsx` é componente de cliente e chamava `concluirAvaliacao` de lá. Por
isso `src/data/questions.ts` ia inteiro para o bundle, com o polo junguiano e o
eixo de cada alternativa, e `scoringMatrix.ts` junto. Medido no endereço
publicado, sem login:

```
["Reviso mentalmente o material que preparei antes de intervir.","I","EST"]
191 de 192 alternativas
```

Um instrumento com a chave de correção pública deixa de medir o que se propõe:
quem quisesse sair Lobo em vez de Baleia bastava ler o arquivo.

## O que mudou

Cada camada de dado passou a existir em dois arquivos — o público e o
confidencial, este com `import 'server-only'`:

| Público | Confidencial |
|---|---|
| `data/questions.ts` — id, contexto, enunciado, textos | `data/questions.server.ts` — polo, eixo, peso, tipo |
| `data/matriz.ts` — versão, listas de id, máximos agregados | `data/scoringMatrix.ts` — a matriz |
| `lib/resultado.ts` — formato do resultado, `intensidade`, `vetorDe` | `lib/scoring.ts` — o algoritmo |
| `lib/repo-supabase.ts` — leitura e cadastro | `lib/repo-servidor.ts` — o que precisa da chave |

E as quatro operações que dependem da chave — consultar, responder, concluir,
recalcular — passaram para `POST /api/avaliacao`, com invólucros finos em
`lib/avaliacao-cliente.ts` para que as telas continuassem lendo como antes.

**A sessão continua sendo a do participante.** As rotas usam `db()` de
`sessao.ts`, com os cookies dele, e não a chave de serviço: o RLS decide
exatamente o que decidia quando o cálculo era no cliente. Nenhuma política foi
afrouxada. Item 53 preservado — a chave segue congelada na linha de `respostas`
no instante da escolha; mudou quem a lê.

A tela de metodologia do Master recebe a matriz **por prop**, montada no
servidor. Ela nunca faz parte do bundle estático.

## Provas

| | antes | depois |
|---|---|---|
| Alternativas com polo e eixo no bundle | **191** | **0** |
| Linhas da matriz funcional no bundle | presentes | **0** |
| Texto das 48 perguntas no bundle | presente | **presente** (o participante precisa lê-las) |

`npm run regressao`: **nenhuma divergência** — perfil, animal, E/I/T/F/S/N, seis
eixos, capacidades, Belbin, IDF, ICF e distribuições bit a bit iguais depois de
mover quinze arquivos.

Baterias: `verificar` exit 0 · `test:ui` 48/48 · `test:v2` 47/47 ·
`test:sigilo` **22/22** (era 12 — nove checagens novas cobrem a v1.0) ·
`verifica-demo` 18/18 · `verifica-dashboard` 72/72 · `build` exit 0.

## Travas acrescentadas

- **`test:sigilo` cobre a v1.0.** Varre o bundle atrás de alternativa com polo e
  eixo, de associação alternativa → polo, e de linha da matriz funcional. Se
  qualquer uma aparecer, falha.
- **`audit:matriz` compara os literais públicos com a matriz real.** Os máximos
  por capacidade e por papel são publicados como literais em `data/matriz.ts`
  para que as telas os leiam sem puxar a matriz; a auditoria recalcula e falha se
  divergirem. Verificado adulterando um número de propósito: `MATRIZ BLOQUEADA`.
- **`test:telas` roda SEM `--conditions=react-server`.** Que ele passe assim é a
  prova de que as telas do participante não tocam mais na chave.

## Dois defeitos meus no caminho, registrados

1. Ao criar `data/matriz.ts`, **escrevi as listas `CHAVES_CAPACIDADE` e
   `CHAVES_BELBIN` de memória em vez de copiá-las**. Seis das dez capacidades
   passaram a ter máximo zero. Apareceu na conferência dos números; recuperado do
   commit. É exatamente o tipo de erro que a auditoria nova agora pega sozinha.
2. A primeira versão da trava de deriva foi inserida **depois** do cálculo do
   veredito da auditoria, e por isso não reprovava nada. Descoberto ao testá-la
   com um número adulterado de propósito — o teste do teste.

## Exceção declarada

`dist/demo.html` calcula no navegador, por natureza. `build-previa.mjs`
neutraliza o `server-only` com um plugin do esbuild, de propósito e comentado.
`dist/` está no `.gitignore` e no `.vercelignore`. Se a demo um dia for a
público, esse atalho cai junto.
