# ROTA26 — Mapeamento da Diversidade Psicológica, Comportamental e Funcional das Equipes

**Instrumento de Mapeamento da Diversidade e Complementaridade de Equipes** — v3.1.

> A **aplicação** está em ambiente de produção, com dados reais em banco persistente.
> O **instrumento** continua em fase piloto, não normatizado psicometricamente.
> As duas coisas são compatíveis, e ambas aparecem declaradas na interface.

## Documentação

| Documento | Para quem |
|---|---|
| **[GUIA_TECNICO_TI.md](GUIA_TECNICO_TI.md)** | Equipe de TI — arquitetura, banco, RLS, variáveis, publicação, domínio, LGPD, monitoramento, rollback |
| **[MANUAL_ADMINISTRADOR.md](MANUAL_ADMINISTRADOR.md)** | Quem aplica e lê os resultados |
| **[DICIONARIO_DE_DADOS.md](DICIONARIO_DE_DADOS.md)** | Banco campo a campo, extraído do esquema real |
| **[DIAGRAMA_BANCO.md](DIAGRAMA_BANCO.md)** | Arquitetura, ER, fluxo do dado e mapa do sigilo |
| **[CHECKLIST_GOLIVE.md](CHECKLIST_GOLIVE.md)** | Aceite antes de abrir para os participantes |
| **[RELATORIO_DE_TESTES.md](RELATORIO_DE_TESTES.md)** | O que foi testado, com que resultado e como reproduzir |
| **[CHANGELOG.md](CHANGELOG.md)** | O que foi adicionado, ajustado, removido da demo e preservado |
| **[INVENTARIO_DE_ALTERACOES.md](INVENTARIO_DE_ALTERACOES.md)** | Classificação feita antes de alterar |
| **[SUGESTOES_NAO_IMPLEMENTADAS.md](SUGESTOES_NAO_IMPLEMENTADAS.md)** | Melhorias identificadas e **não** aplicadas, aguardando autorização |
| [IMPLANTACAO.md](IMPLANTACAO.md) | Resumo da migração para produção (etapa anterior) |

Referenciais: **tipologia psicológica de C. G. Jung**, **simbolismo animal** de *Os animais e a psique* vol. 1 (Ramos et al., Summus, 2005) e **teoria dos papéis de equipe de Meredith Belbin**, conforme Miranda & Vasconcelos, *Pretexto* v.21 n.3, FUMEC, 2020.

---

## O que mudou na v2.0 — a correção conceitual central

Na v1.0, capacidades funcionais e proximidades com Belbin eram lidas de uma tabela indexada pelo **perfil junguiano**. A auditoria do código mediu a consequência:

> Duas pessoas do mesmo perfil, com **até 38 de 48 respostas diferentes**, recebiam resultado funcional **idêntico**. Em 8 de 8 pares testados. A trilha funcional não tinha informação própria — era um rótulo do perfil Jung.

Agora o sistema opera em **duas trilhas paralelas e independentes**, partindo das mesmas 48 respostas:

| | Trilha A — psicológica | Trilha B — funcional |
|---|---|---|
| Entrada | 48 respostas | as mesmas 48 respostas |
| Processo | atitudes e funções de Jung | seis eixos comportamentais |
| Saída | 8 configurações → perfil principal e secundário → animal → luz e sombra | dez capacidades → nove proximidades Belbin → cobertura funcional |
| Fonte da pontuação | polo junguiano de cada alternativa | **conteúdo comportamental** de cada alternativa |

Cada uma das **192 alternativas** carrega agora sua própria contribuição de capacidades e de papéis, definida a partir do texto da alternativa (`src/data/scoringMatrix.ts`). Resultado medido após a refatoração:

> **8 de 8 pares** do mesmo perfil junguiano produzem escores Belbin diferentes, e a ordem do top-3 muda em todos eles. No banco, o perfil `Se` reúne 17 pessoas com **4 primeiros lugares distintos** e **12 combinações de top-3 distintas**.

---

## Estado de verificação

| Verificação | Resultado |
|---|---|
| Auditoria estrutural dos 48 itens | **0 erros, 0 alertas** |
| Auditoria da matriz de pontuação (192 alternativas) | **0 erros, 0 alertas** |
| Algoritmo determinístico | **83/83** |
| Schema + RLS + seeds + migrações de produção em PostgreSQL 16 limpo | **6 arquivos, sem erro** |
| **Fluxo de produção ponta a ponta em PostgreSQL real, com RLS ligado** | **45/45** |
| Telas de retomada, conclusão, estado vazio e erro de consulta | **15/15** |
| Composição simbólica dos animais | **16/16** |
| Dashboard × Excel, abrindo o .xlsx gerado | **13/13** |
| Cobertura e honestidade do glossário | **23/23**, 59 verbetes |
| Interface no navegador (Playwright) | **48/48**, 0 erros de JS |
| Exportação Excel nos seis formatos, no navegador | **6/6**, planilhas válidas |
| **Regressão contra a baseline metodológica** | **nenhuma divergência** |
| `tsc --noEmit` | **0 erros** |
| `next build` | **compila, 14 rotas** |

**Total: 263 verificações automatizadas, 0 falhas.** Detalhamento em
[RELATORIO_DE_TESTES.md](RELATORIO_DE_TESTES.md).

---

## O que foi preservado da v1.0

As 48 questões comportamentais · o fluxo de identificação · os oito perfis junguianos · a matriz simbólica dos animais · luz e sombra · os seis eixos · o algoritmo determinístico · a estrutura de dashboard · IDF · ICF · comparação entre setores · painel nominal · versionamento do instrumento · avisos metodológicos · linguagem não diagnóstica.

Nada foi simplificado. O IDF foi **preservado e melhorado**: agora incorpora a dispersão real dos escores, não apenas a contagem de rótulos.

---

## v2.1 — de demonstração navegável a aplicação organizacional

| | Antes | Agora |
|---|---|---|
| Fonte oficial dos dados | memória do navegador | **PostgreSQL (Supabase)** |
| Dados iniciais | 96 participantes fictícios na abertura | **nenhum** — o banco começa vazio |
| Dashboards | contavam tudo | contam somente `is_demo = false` e `is_test = false`, **filtrado na view do banco** |
| Retomada | recomeçava sozinha | **pergunta** e reabre na primeira questão sem resposta |
| Quem já concluiu | abria outra avaliação em silêncio | **bloqueia** e explica; só o Master libera reaplicação |
| Zero respondentes | gráfico vazio ambíguo | *"Aguardando respostas para gerar análise."* |
| Falha de banco | virava "0 participantes" | *"Não foi possível consultar os dados."* |
| Limpeza dos dados fictícios | não existia | **LIMPAR DADOS DA DEMONSTRAÇÃO** — prévia, backup, confirmação literal, auditoria |
| Autor nos registros | `master@demo` | **administrador autenticado real** |

A regra do filtro está na definição da view `vw_resultados`, no banco — não em uma cláusula de tela.
Nenhum indicador, relatório ou planilha consegue enxergar dado fictício por descuido de código.

`dist/demo.html` continua existindo como **pré-visualização de desenvolvimento**: executa o mesmo
código de cálculo e as mesmas telas, sem banco. Não é a aplicação.

---

## v3.0 — ROTA26: organização, identidade e composição simbólica

Etapa de **preservação, organização e estabilização**. Nenhuma alteração
metodológica foi feita, e isso é verificado mecanicamente:

```bash
npm run regressao
# RESULTADO: nenhuma divergência. O instrumento é BIT A BIT o mesmo.
```

`baseline.json` congela cinco conjuntos controlados de 48 respostas e uma
população fixa de 96 participantes, com **todos** os campos de resultado. Foi
gerado **antes** da refatoração e é reexecutado depois.

O que mudou:

- **Identidade ROTA26** e design system completo — tipografia, paleta, cards,
  botões, tabelas, gráficos, alertas, estados vazios, carregamento e erro.
  Animais tratados como totem sóbrio, com a cor canônica em todas as telas.
- **Resultado individual em oito blocos**, sem retirar nenhuma informação.
- **Belbin aprofundado**: escore **mais** rótulo de intensidade **mais**
  contribuição, onde agrega, como aparece, possível excesso e complementaridade.
  O gráfico dos nove papéis foi preservado.
- **Composição simbólica das equipes**: os oito animais com quantidade e
  percentual, **incluindo os que estão em zero**, com maior e menor
  representação relativa e validação da soma.
- **Matriz Equipe × Animal** alternando quantidade e percentual.
- **Dashboard em seis seções**: Síntese · Composição · Diversidade · Cobertura ·
  Interpretação · Ação.
- **Três abas novas no Excel**, saindo da **mesma rotina** do dashboard
  (`src/lib/animais.ts`) — é o que garante que os números coincidam.
- **Menu do Master** reorganizado, com aba de Configurações em leitura.
- **Leitura de todas as siglas**: 59 verbetes explicando o que é, **por que é
  assim** e onde aparece. Interpretação de IDF e ICF visível sem clique, e um
  bloco "por que é assim" ao lado de cada indicador, escore, eixo, capacidade e
  papel de Belbin.
- **Documentação completa** para TI e para quem administra.

---

## v3.1 — redesign visual

Etapa **exclusivamente visual**. Perguntas, alternativas, textos técnicos,
cálculos, pontuações, perfis, animais, Jung, Belbin, IDF, ICF, banco, regras,
resultados, funcionalidades, filtros, dashboards e exportações **não foram
tocados** — e `npm run regressao` continua respondendo *nenhuma divergência*.

**A marca é o arquivo oficial, não uma imitação.** `public/marca/rota26@2x.png`
é servido como imagem, com a proporção 479:385 preservada. Não foi redesenhado,
recortado, deformado, recolorido, posto em escudo nem recriado por CSS. Como o
arquivo é um relevo 3D sobre parede creme, ele é apresentado sobre uma **placa
creme** que continua a própria parede — recortar o fundo deixaria halo nas
letras. Cinco testes de Playwright protegem essas restrições.

**A paleta saiu do arquivo, pixel a pixel** (`src/data/marca.ts`):
`#DCA436` (amarelo do "26") · `#A66A17` (bronze — a sombra desse mesmo amarelo) ·
`#2B2A28` (grafite das letras) · `#EFE6D6` (o creme da parede). Bronze e amarelo
são a mesma cor em duas profundidades, e é por isso que o acento da interface
nunca briga com o da marca.

**A "rota" virou linguagem**: o traço da estrada como divisor, a barra de
progresso como percurso, o carregamento como nó de rota.

**Verificação:** `npm run test:ui` gera a pré-visualização e roda 48 verificações
de navegador — sete delas apenas sobre a marca, porque o item 39 é restrição e
restrição sem teste é promessa. `npm run verificar:tudo` roda a suíte inteira.

**Pendente:** o **selo circular dos oito animais** ainda não foi recebido. As
oito marcas em `src/components/animais-svg.tsx` são uma proposta de linguagem;
recebendo o selo, elas são recalibradas para a textura e a iluminação dele, e o
selo assume a abertura, o cabeçalho da Composição Simbólica e a marca-d'água.

---

## Instalação

Guia completo em **[GUIA_TECNICO_TI.md](GUIA_TECNICO_TI.md)**. Resumo:

### Pré-requisitos
Node.js 18+ e uma conta no [Supabase](https://supabase.com) (plano gratuito serve).

```bash
npm install
```

### Aplicar o banco de dados

No painel do Supabase: **SQL Editor → New query**. Execute **nesta ordem**:

| Ordem | Arquivo | O que faz |
|---|---|---|
| 1 | `supabase/01_schema.sql` | Tabelas, tipos, índices e funções de autorização |
| 2 | `supabase/02_policies.sql` | Row Level Security dos três papéis |
| 3 | `supabase/03_seed.sql` | 48 questões, 192 alternativas, 8 perfis, matrizes, 16 setores |
| 4 | `supabase/05_migracao_v2.sql` | `resultados_funcionais`, `resultados_belbin`, `is_demo`, arquivamento, `logs_auditoria`, retomada e funções de reset |
| 5 | `supabase/06_producao.sql` | **v3**: `is_test`, view de dados reais, limpeza DEMO, checklist de prontidão, auditoria de login e conclusão |
| 6 | `supabase/07_papeis.sql` | Marcação `eh_administrador` nas views, trava das colunas de marcação do participante |
| 7 | `supabase/08_reavaliacao_v2.sql` | **v2.0-reavaliacao**, inativa: `resultados_v2`, `desempates`, `vw_resultados_v2`, filtros de contrato e líder |

> **Não execute** `supabase/04_demo_seed.sql` em ambiente de aplicação: ele cria 96 participantes
> fictícios e existe apenas para desenvolvimento. `supabase/00_stub_auth_local.sql` também não —
> serve só para validar o SQL em um PostgreSQL local.

Se os dados de demonstração tiverem sido aplicados por engano:
**Gestão de dados → Preparar aplicação → LIMPAR DADOS DA DEMONSTRAÇÃO**, ou:

```sql
select limpar_dados_demo('LIMPAR DADOS DEMO');
```

### Variáveis de ambiente

```bash
cp .env.example .env.local
```

`NEXT_PUBLIC_APP_MODE=production` e, de **Project Settings → API**: `NEXT_PUBLIC_SUPABASE_URL`,
`NEXT_PUBLIC_SUPABASE_ANON_KEY` e `SUPABASE_SERVICE_ROLE_KEY`.

O modo **production é o padrão**: variável ausente, vazia ou inválida resulta em produção, nunca em
demonstração. Geradores de dados fictícios só destravam com `NEXT_PUBLIC_APP_MODE=development` **e**
`PERMITIR_SEED_DEMO=true` — combinação que jamais deve existir em ambiente de aplicação.

### ⚠️ Único passo manual obrigatório

Depende de um usuário existir no Supabase Auth, o que não pode ser criado por SQL antecipadamente.

1. **Authentication → Users → Add user**: crie seu usuário.
2. Copie o **UID**.
3. No SQL Editor:

```sql
insert into administradores (user_id, papel, nome)
values ('COLE-AQUI-O-UID', 'MASTER', 'Seu Nome');
```

Sem isso você entra como participante e não vê nenhum dashboard — comportamento correto e seguro.

Administrador de setor (vê apenas o próprio setor, sem respostas brutas):

```sql
insert into administradores (user_id, papel, setor_id, nome)
values ('UID', 'ADMIN_SETOR', (select id from setores where codigo = 'MEC'), 'Nome');
```

### ⚠️ Segundo passo no painel: sessão de quem responde

Toda policy de RLS é `to authenticated`. Quem responde não tem conta nominal —
a aplicação abre uma **sessão anônima** no primeiro carregamento de
`/questionario`, e é ela que faz `auth.uid()` existir. Ligue em
**Authentication → Sign In / Providers → Anonymous sign-ins**.

Sem isso o questionário mostra "Nenhum setor", como se o banco estivesse vazio.
E em **Authentication → Rate Limits**, suba o teto de cadastros anônimos: o
padrão é 30 por hora **por IP**, e uma equipe atrás do mesmo NAT estoura isso.

Quem administra entra por `/entrar`, com e-mail e senha.

### Rodar e publicar

```bash
npm run dev        # http://localhost:3000
npm run build && npm start
npx vercel         # publicar (não exige repositório git)
```

`.vercelignore` mantém `docker/` fora do envio — é lá que ficam o `JWT_SECRET`
e a `SERVICE_KEY` da pilha local de desenvolvimento.

---

## Exportação em Excel — como abrir a demo

Abra `dist/demo.html` **diretamente no navegador** (clique duplo, ou arraste o arquivo para uma aba).

Se a página for aberta **dentro de um visualizador embutido** (um iframe de painel de pré-visualização), o navegador bloqueia o download de forma **silenciosa** — o arquivo é gerado corretamente, mas nunca chega ao disco, e nenhum código consegue contornar essa política de segurança. A partir desta versão a própria tela detecta essa situação e avisa antes que você clique, além de oferecer um link manual e mostrar qualquer erro de geração em tela.

Na aplicação Next.js a exportação passa pela rota `/api/exportar` e tem o mesmo tratamento.

---

## Comandos de verificação

```bash
npm run audit:itens      # auditoria dos 48 itens
npm run audit:matriz     # auditoria da matriz de pontuação e da independência das trilhas
npm run test:algoritmo   # 82 testes do algoritmo determinístico
npm run test:telas       # 15 verificações dos textos das telas
npm run test:animais     # 16 verificações da composição simbólica
npm run test:excel       # 13 verificações abrindo o .xlsx gerado
npm run test:glossario   # 23 verificações de cobertura das siglas
npm run baseline         # congela a baseline metodológica (uma única vez)
npm run regressao        # o instrumento continua idêntico à baseline?
npm run typecheck
npm run gen:sql          # regenera os seeds a partir de src/data/*.ts
npm run gen:demo         # regenera dist/demo.html (pré-visualização de desenvolvimento)
npm run verificar        # tudo acima

# Ponta a ponta contra um PostgreSQL real, com RLS ligado — 45 verificações:
PGURL=postgres://usuario@host/banco npx tsx scripts/test-producao.ts
```

---

## Estrutura

```
src/data/                 FONTE ÚNICA DE VERDADE
  questions.ts            48 itens, chave Jung + eixo (preservado da v1)
  scoringMatrix.ts        ★ v2 — capacidades e Belbin POR ALTERNATIVA
  profiles.ts             8 perfis, animais, luz/sombra
  functional.ts           capacidades, papéis de Belbin, matriz de referência
  functionalContent.ts    ★ v2 — conteúdo interpretativo de capacidades e papéis
src/lib/
  scoring.ts              ★ v2 — duas trilhas paralelas, determinístico
  aggregate.ts            ★ v2 — agregação por VETORES COMPLETOS, IDF, ICF
  narrative.ts            ★ v2 — 10 leituras, luz, sombra, Belbin, leitura executiva
  excel.ts                ★ v2 — exportação .xlsx (13 abas)
  repo-supabase.ts        persistência, retomada, conclusão segura
src/lib/
  env.ts                  ★ v3 — APP_MODE, trava do seed, identidade da aplicação
src/components/
  views-participante.tsx  ★ v3 — devolutiva, "Você na sua equipe", retomada e já-concluída
  views-gestao.tsx        ★ v3 — liderança, metodologia, gestão de dados, preparar aplicação
  Rodape.tsx              ★ v3 — status do instrumento em todas as páginas
src/app/api/preparar/     ★ v3 — as sondas reais do checklist de pré-aplicação
supabase/                 01 schema · 02 policies · 03 seed · 04 demo (dev) · 05 migração v2 · 06 produção
                          00 stub de auth (apenas para validação local)
scripts/                  audit-itens · audit-matriz · test-algoritmo · test-telas ·
                          test-producao · gen-sql · gen-demo
dist/demo.html            pré-visualização de desenvolvimento (não é a aplicação)
IMPLANTACAO.md            ★ v3 — instalação, publicação, checklist e operação
```

---

## Garantias verificadas

**A IA não decide nada.** Perfil, animal, função, atitude, proximidade Belbin, IDF e ICF são calculados por código determinístico. Verificado em 150 execuções repetidas e com a ordem das respostas embaralhada.

**A trilha funcional não consulta o perfil junguiano.** Há um teste que inspeciona o próprio código de `calcularFuncional` para garantir isso.

**Respostas brutas preservadas e imutáveis.** Cada resposta guarda a chave de pontuação vigente. O recálculo a partir do bruto bate com o armazenado em 96/96.

**Retomada real.** Fechar o navegador no item 20 e voltar recupera as 20 respostas e retoma no item 21 — testado no navegador.

**Sigilo aplicado no banco.** Participante vê 1 pessoa e as próprias 48 respostas; admin de setor vê seu setor e **zero respostas brutas**; Master vê tudo.

**Dashboard e Excel coincidem (item 74).** Teste automatizado compara n, IDF e ICF do MEC entre a análise e a planilha gerada.

**Nenhum dado fictício em produção.** O padrão de `APP_MODE` é `production`; geradores de dados
simulados exigem `development` **e** `PERMITIR_SEED_DEMO=true` para sequer executar. Atualizar a
página nunca recria dados.

**Dado DEMO não entra em indicador.** O filtro está na definição de `vw_resultados`, no banco.
Verificado reintroduzindo um participante `is_demo` em um banco real: a view de dados reais devolveu
1 linha e a view irrestrita, 2.

**Limpeza DEMO é segura e reversível apenas por backup.** Prévia com três contagens → backup em Excel
→ confirmação literal `LIMPAR DADOS DEMO` → auditoria com autor autenticado. Verificado em PostgreSQL
real: 96 participantes, 96 avaliações e 4.608 respostas removidos, com 48 questões, 192 alternativas,
8 perfis, 16 setores, 80 células da matriz funcional, 72 de Belbin, versões e administradores intactos.

**Erro nunca vira zero.** Uma falha de consulta produz *"Não foi possível consultar os dados"*, não
*"0 participantes"* — em todas as páginas de dashboard.

**Reset é controlado.** Prévia com contagem → confirmação → arquivamento (soft delete) → registro em auditoria. O reset geral exige digitar `ZERAR RESULTADOS`. Perguntas, alternativas, matrizes, animais, perfis, parâmetros funcionais, setores, administradores e versões **nunca** são removidos — verificado no Postgres.

---

## Limites declarados em tela

- Instrumento em **versão piloto, não validado psicometricamente**. O banco já guarda os dados no formato necessário para alfa de Cronbach, ômega de McDonald, correlação item-total, análise fatorial e teste-reteste.
- Os valores são **escores relativos internos**, não percentis populacionais.
- Os **animais são metáforas didáticas**. O sistema nunca escreve "você é uma Baleia".
- **Não deve ser usado** para promover, demitir, contratar, reprovar, afastar, transferir ou selecionar.
- Grupos com **menos de 5 respondentes** não têm distribuição detalhada exibida ao participante.
- **Diversidade não é qualidade.** Não existe perfil superior, animal superior nem equipe perfeita — existe **configuração**.
