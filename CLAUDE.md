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
# use um banco recém-criado com 01, 02, 03, 05, 06 e 07 aplicados):
PGURL=postgres://usuario@host/banco npx tsx scripts/test-producao.ts
```

`npm run dev` não sobe sem `.env.local` (`cp .env.example .env.local`) com `NEXT_PUBLIC_SUPABASE_URL`,
`NEXT_PUBLIC_SUPABASE_ANON_KEY` e `SUPABASE_SERVICE_ROLE_KEY` — `repo-supabase.ts` lê essas variáveis
no topo do módulo. As migrações precisam estar aplicadas na ordem `01 → 02 → 03 → 05 → 06 → 07`
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

### Fonte única de verdade

`src/data/` é a origem de tudo. `supabase/03_seed.sql` e `04_demo_seed.sql` são **gerados** por
`npm run gen:sql` e trazem o aviso "NÃO EDITE À MÃO" no cabeçalho — altere `src/data/*.ts` e
regenere. O mesmo vale para agregação: `src/lib/animais.ts` é a única contagem de animais, chamada
tanto pelo dashboard quanto pelo Excel; é isso que faz os números coincidirem.

### Regras que moram no banco, não na tela

- `vw_resultados` já exclui `is_demo` e `is_test` **na definição da view**. Nenhum indicador,
  relatório ou planilha enxerga dado fictício mesmo que uma tela futura esqueça de filtrar.
  `vw_resultados_todos` existe só para o backup antes da limpeza DEMO.
- RLS em `02_policies.sql` implementa os três papéis: participante vê a si mesmo e suas respostas
  brutas; `ADMIN_SETOR` vê o próprio setor e **zero** respostas brutas; `MASTER` vê tudo. As páginas
  não filtram por setor — o RLS filtra.
- Operações destrutivas são funções SQL com confirmação literal (`limpar_dados_demo('LIMPAR DADOS DEMO')`,
  reset geral com `ZERAR RESULTADOS`), prévia, backup e registro em auditoria.

### Fluxo do participante

`src/app/questionario/Fluxo.tsx` (client) abre a sessão antes de qualquer consulta
(`garantirSessao` — anônima para quem responde, intocada para quem já entrou por `/entrar`) e grava
**cada resposta individualmente** no instante da escolha, com a chave de pontuação congelada. `concluirAvaliacao` (`src/lib/repo-supabase.ts`)
relê as respostas do banco, recalcula **no servidor**, grava os quatro derivados, confere que
existem e só então marca `CONCLUIDA` — o cliente nunca envia resultado. Avaliação em andamento
pergunta antes de retomar; matrícula já concluída é bloqueada até o Master liberar reaplicação.

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
