# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Sobre o projeto

ROTA26 — instrumento organizacional de mapeamento de equipes (Jung × *Os animais e a psique* ×
Belbin). Next.js 14 (App Router, Server Components) + Supabase/PostgreSQL. Código, dados,
identificadores e documentação em **português**; mantenha esse padrão.

## Comandos

```bash
npm install
npm run dev                # http://localhost:3000 (exige .env.local — ver abaixo)
npm run build && npm start
npm run typecheck          # tsc --noEmit
npm run lint

# Suítes de verificação — cada script é a menor unidade executável (não há
# filtro por caso de teste); todos saem com código 1 em caso de falha.
npm run audit:itens        # estrutura dos 48 itens / 192 alternativas
npm run audit:matriz       # matriz de pontuação e independência das duas trilhas
npm run test:algoritmo     # algoritmo determinístico
npm run test:telas         # textos das telas
npm run test:animais       # composição simbólica
npm run test:excel         # abre o .xlsx gerado e confere contra o dashboard
npm run test:glossario     # cobertura das siglas
npm run regressao          # compara com baseline.json — ver "Contrato de regressão"
npm run verificar          # tudo acima + typecheck + gen:sql
npm run test:ui            # build-previa + Playwright sobre dist/demo.html
npm run verificar:tudo     # verificar + test:ui + build

# Geradores
npm run gen:sql            # regenera supabase/03_seed.sql e 04_demo_seed.sql a partir de src/data/
npm run previa             # regenera dist/demo.html
npm run baseline           # regrava baseline.json (só com --forcar; ver abaixo)

# Ponta a ponta contra PostgreSQL real, com RLS ligado (escreve no banco, NÃO é idempotente —
# use um banco recém-criado com 01, 02, 03, 05, 06, 07, 08 e 09 aplicados):
PGURL=postgres://usuario@host/banco npx tsx scripts/test-producao.ts
```

`npm run dev` não sobe sem `.env.local` (`cp .env.example .env.local`) com `NEXT_PUBLIC_SUPABASE_URL`,
`NEXT_PUBLIC_SUPABASE_ANON_KEY` e `SUPABASE_SERVICE_ROLE_KEY` — `repo-supabase.ts` lê essas variáveis
no topo do módulo. As migrações precisam estar aplicadas na ordem `01 → 02 → 03 → 05 → 06 → 07 → 08 → 09`
(nunca `04_demo_seed.sql` fora de desenvolvimento) e um usuário do Supabase Auth precisa existir em
`administradores` com papel `MASTER`, senão toda tela de dashboard responde "acesso restrito" — o que
é o comportamento correto.

## Arquitetura

### Duas trilhas paralelas (o ponto central do desenho)

`src/lib/scoring.ts` transforma as mesmas 48 respostas por **dois caminhos que não se consultam**:

- **Trilha A (psicológica)**: polo junguiano de cada alternativa → E/I/T/F/S/N → atitude, função
  dominante e auxiliar → perfil principal e secundário → animal, luz e sombra.
- **Trilha B (funcional)**: conteúdo comportamental de cada alternativa
  (`src/data/scoringMatrix.ts`, uma linha por alternativa) → seis eixos → dez capacidades → nove
  proximidades Belbin.

`calcularFuncional` **não pode** ler o perfil junguiano — `audit:matriz` inspeciona o próprio código
dessa função para garantir isso. Na v1.0 a trilha funcional era um rótulo do perfil; desfazer essa
separação é a regressão mais grave possível aqui.

O módulo é puro: sem rede, sem aleatoriedade, sem IA. Desempates têm regra explícita e ordenações
usam desempate estável pela ordem canônica — respostas idênticas produzem sempre o mesmo resultado.

A cascata de desempate vive em `desempatar()` e é aplicada em **dois** pontos: a função dominante
(perfil principal) e a função auxiliar (perfil secundário). D1 diferenciação em relação à oposta →
D2 evidência convergente nos eixos → D3 ordem canônica. O texto gravado em `regra_desempate` /
`regra_desempate_auxiliar` só lista degraus que **efetivamente reduziram** o conjunto de candidatas.
`VERSAO_ALGORITMO` (`data/questions.ts`) é distinta de `VERSAO_INSTRUMENTO`: a primeira identifica
como as respostas viram resultado, a segunda o que foi perguntado. Mudar a cascata muda a primeira.

### A chave de pontuação não chega ao navegador

Vale para as duas versões, e na v1.0 é correção recente: até 28/08/2026 o bundle público entregava
**191 das 192 alternativas** com o polo junguiano e o eixo ao lado, sem login. Medido no endereço
publicado, não deduzido.

Cada camada de dado existe em dois arquivos:

| Público — pode ir ao navegador | Confidencial — `import 'server-only'` |
|---|---|
| `data/questions.ts` — id, contexto, enunciado, textos | `data/questions.server.ts` — polo, eixo, peso, tipo |
| `data/matriz.ts` — versão, listas de id, máximos agregados | `data/scoringMatrix.ts` — a matriz alternativa → pesos |
| `lib/resultado.ts` — o FORMATO do resultado, `intensidade`, `vetorDe` | `lib/scoring.ts` — o algoritmo |
| `lib/repo-supabase.ts` — leitura e cadastro | `lib/repo-servidor.ts` — o que precisa da chave |
| `data/v2/questoes.ts` | `data/v2/mapa.server.ts`, `desempate.server.ts`, `lib/v2/apuracao.ts` |

Três consequências práticas:

- **Componente de cliente que importe um módulo confidencial quebra o `next build`.** Não é
  convenção, é erro de compilação — e `npm run test:sigilo` (22 checagens) ainda compila e varre
  `.next/static` atrás de vestígio. **Se falhar, não publique.**
- **Scripts que tocam a chave precisam de `tsx --conditions=react-server`** — já está nos scripts do
  `package.json`. `test:telas` é a exceção: renderiza React e por isso NÃO pode usar a condição;
  que ele passe sem ela é a prova de que as telas do participante não tocam mais na chave.
- **A tela de metodologia recebe a matriz por prop**, montada no servidor para o Master autenticado.
  Ela nunca faz parte do bundle estático.

Os máximos por capacidade e por papel são publicados como literais em `data/matriz.ts` porque são
agregados — dizem quanto uma dimensão soma no instrumento inteiro, não o que cada alternativa vale.
`npm run audit:matriz` recalcula os dois a partir da matriz real e falha se algum número divergir.

`dist/demo.html` é a exceção declarada: calcula no navegador, e por isso `build-previa.mjs`
neutraliza o `server-only` de propósito. `dist/` está no `.gitignore` e no `.vercelignore` e nunca
é publicado — se um dia precisar ir a público, esse atalho cai junto.

### Duas versões do instrumento convivem

`v1.0-piloto` é a que está ativa e coletando. `v2.0-reavaliacao` entrou pela migração
`08_reavaliacao_v2.sql` com `ativa = false` — o motor, os dados e o banco existem; **as telas ainda
não foram religadas**. Enquanto a versão estiver inativa, nada muda para quem responde.

As duas **não são comparáveis**: a v1.0 tem duas trilhas independentes e produz capacidades e
proximidades Belbin por pessoa; a v2.0 usa as mesmas 48 respostas para atitude e função ao mesmo
tempo e produz uma configuração predominante, sem trilha funcional. Por isso todo indicador é
filtrado por versão e nunca somado entre versões — `vw_resultados_v2` traz o filtro na definição, e
`resumo_organizacional()` conta pela versão ativa.

O que muda de arquitetura na v2.0, e é o ponto do desenho:

- `src/data/v2/questoes.ts` é **público** — só identificadores e textos, nenhuma configuração,
  peso, âncora ou animal;
- `src/data/v2/mapa.server.ts`, `desempate.server.ts` e `src/lib/v2/apuracao.ts` abrem com
  `import 'server-only'`. Se um componente de cliente importar qualquer um deles, `next build`
  **falha**. Não é convenção, é erro de compilação;
- por isso a apuração da v2.0 só pode acontecer no servidor — e a gravação também. `08` não tem
  policy de INSERT em `resultados_v2` nem em `desempates` de propósito: a escrita passa por rota de
  servidor com a chave de serviço. Ver a seção 7 do próprio arquivo SQL;
- `npm run test:sigilo` compila e vasculha `.next/static` atrás de vestígio do gabarito. **Se
  falhar, não publique.** `npm run test:v2` roda os 47 testes do motor.

Os dois exigem **Node 20+** (`nvm use 20`) — a máquina de desenvolvimento tem 18 por padrão.
`demo/ROTA26-demo-v2.html` e `demo/fontes/` contêm o gabarito e são a especificação executável do
painel; `.vercelignore` mantém `demo/` fora de qualquer publicação.

### Fonte única de verdade

`src/data/` é a origem de tudo. `supabase/03_seed.sql` e `04_demo_seed.sql` são **gerados** por
`npm run gen:sql` e trazem o aviso "NÃO EDITE À MÃO" no cabeçalho — altere `src/data/*.ts` e
regenere. O mesmo vale para agregação: `src/lib/animais.ts` é a única contagem de animais, chamada
tanto pelo dashboard quanto pelo Excel; é isso que faz os números coincidirem.

### Regras que moram no banco, não na tela

- `vw_resultados` já exclui `is_demo` e `is_test` **na definição da view**. Nenhum indicador,
  relatório ou planilha enxerga dado fictício mesmo que uma tela futura esqueça de filtrar.
  `vw_resultados_todos` existe só para o backup antes da limpeza DEMO.
- `vw_resultados` também é `distinct on (participante)`, pela conclusão mais recente: **uma linha por
  pessoa, sempre**. `avaliacoes_cria` não verifica se já existe avaliação concluída — o bloqueio é
  aplicacional —, e sem o `distinct on` quem contornasse a interface se contaria duas vezes em todo
  indicador. `resumo_organizacional()` conta pessoas distintas pelo mesmo motivo.
- `vw_aplicacoes` é o oposto declarado: o histórico por participante, **incluindo arquivadas e em
  andamento**. Arquivar significa "fora dos indicadores", não "inexistente". `numero_aplicacao` é
  atribuído por trigger no banco — `abrirAvaliacao` roda no navegador e é sujeito a corrida.
- `resultados` só tem policy de INSERT para o participante; `resultados_atualiza_master` permite
  UPDATE ao MASTER, e existe para o recálculo de `/api/recalcular` quando o algoritmo muda. As
  `respostas` continuam sem UPDATE nem DELETE: são imutáveis.
- RLS em `02_policies.sql` implementa os três papéis: participante vê a si mesmo e suas respostas
  brutas; `ADMIN_SETOR` vê o próprio setor e **zero** respostas brutas; `MASTER` vê tudo. As páginas
  não filtram por setor — o RLS filtra.
- Operações destrutivas são funções SQL com confirmação literal (`limpar_dados_demo('LIMPAR DADOS DEMO')`,
  reset geral com `ZERAR RESULTADOS`), prévia, backup e registro em auditoria.

### Fluxo do participante

O participante revisita o próprio resultado em `/meu-resultado`, que reaproveita a identificação do
percurso e lista as aplicações dele por `vw_aplicacoes`. O vínculo pessoa↔resultado é o `user_id` da
sessão anônima que respondeu, e `participantes_atualiza` exige `user_id = auth.uid()`: digitar a
matrícula de um colega **não** abre o resultado dele — o banco recusa —, mas quem troca de navegador
também é recusado. A mensagem explica isso; o caminho de volta é decisão pendente, no item 8 de
`SUGESTOES_NAO_IMPLEMENTADAS.md`.

`src/app/questionario/Fluxo.tsx` (client) abre a sessão antes de qualquer consulta
(`garantirSessao` — anônima para quem responde, intocada para quem já entrou por `/entrar`) e grava
**cada resposta individualmente** no instante da escolha, com a chave de pontuação congelada.
As quatro operações que dependem da chave de pontuação — consultar, responder, concluir e
recalcular — passam por `POST /api/avaliacao`, com os invólucros de `src/lib/avaliacao-cliente.ts`.
Elas executam em `src/lib/repo-servidor.ts`, que é `server-only`. `concluirAvaliacao` relê as
respostas do banco, recalcula **no servidor**, grava os quatro derivados, confere que existem e só
então marca `CONCLUIDA`. Avaliação em andamento pergunta antes de retomar; matrícula já concluída é
bloqueada até o Master liberar reaplicação.

A sessão usada nessas rotas é a **do próprio participante** (`db()` de `sessao.ts`, com os cookies
dele), nunca a chave de serviço: o RLS decide exatamente o que decidia quando o cálculo era no
cliente. Item 53 preservado — a chave continua congelada na linha de `respostas` no instante da
escolha; o que mudou é quem a lê.

### Páginas e sessão

Páginas são Server Components com `export const dynamic = 'force-dynamic'`. `src/lib/sessao.ts`
expõe `db()` (cliente Supabase com os cookies da sessão) e `papel()`; cada página compara o papel
e devolve `<AcessoRestrito />` — falta de permissão responde 200, não 500.
`src/middleware.ts` renova o token — Server Component não grava cookie, então sem ele a sessão
expira e vira "acesso restrito" sem motivo. `src/app/dashboard/error.tsx` distingue falta de
permissão (leva ao `/entrar`) de falha de consulta. Os três clientes Supabase moram em
`src/lib/supabase.ts`, separados de `repo-supabase.ts` para não arrastar as 48 questões para o
bundle de toda página. Toda página de
dashboard envolve a consulta em `try/catch` e renderiza `<ErroConsulta />` — **falha de banco nunca
pode virar "0 participantes"**. Alias de import: `@/*` → `./src/*`.

`dist/demo.html` (gerado de `demo/main.tsx` por esbuild) roda os mesmos componentes e o mesmo
cálculo sobre um repositório em memória. É pré-visualização de desenvolvimento e alvo dos testes de
Playwright — **não é a aplicação**.

## Contrato de regressão

`baseline.json` congela cinco conjuntos controlados de respostas e uma população fixa de 96
participantes, com todos os campos de resultado. Depois de qualquer alteração:

```bash
npm run regressao   # esperado: "nenhuma divergência"
```

Perguntas, alternativas, pesos, chaves de pontuação, regras de desempate, perfis, animais, eixos,
capacidades, Belbin, IDF e ICF são **metodologia congelada**. Mudanças de apresentação, banco ou
design não podem alterar um único escore. Se uma tarefa exigir mudar metodologia, isso precisa de
autorização explícita — regravar `baseline.json` (`npm run baseline --forcar`) apaga a prova de que
o instrumento não mudou. Melhorias identificadas e não autorizadas vão para
`SUGESTOES_NAO_IMPLEMENTADAS.md`, não para o código.

## Convenções da base

- Comentários de bloco no topo de cada módulo explicam **por que** a regra existe e citam o item do
  prompt-mestre correspondente (`item 13`, `item 74`, …). Ao alterar um módulo, mantenha esse
  registro coerente em vez de removê-lo.
- Linguagem não diagnóstica: o sistema nunca escreve "você é uma Baleia"; animais são metáforas
  didáticas e os valores são escores relativos internos, não percentis.
- `APP_MODE` tem **produção como padrão** (`src/lib/env.ts`): variável ausente, vazia ou inválida
  resulta em produção. Geradores de dados fictícios exigem `NEXT_PUBLIC_APP_MODE=development` **e**
  `PERMITIR_SEED_DEMO=true`, e chamam `exigirSeedPermitido()` antes de executar.
- `SUPABASE_SERVICE_ROLE_KEY` só é usada em rota de servidor (`/api/preparar`, que grava o registro
  `is_test` da sonda de validação em nome de outro participante). Nunca no cliente.
