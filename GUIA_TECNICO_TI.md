# GUIA TÉCNICO DE IMPLANTAÇÃO — ROTA26
## Instrumento de Mapeamento da Diversidade e Complementaridade de Equipes

Documento destinado à **equipe de TI que não participou do desenvolvimento**.
Ao final dele, a aplicação deve estar publicada, com banco configurado, acesso
controlado e base limpa para aplicação real.

Companheiros deste documento: `MANUAL_ADMINISTRADOR.md` (operação),
`DICIONARIO_DE_DADOS.md` (banco campo a campo), `DIAGRAMA_BANCO.md` (arquitetura
e ER), `CHECKLIST_GOLIVE.md` (aceite) e `RELATORIO_DE_TESTES.md` (o que foi
testado e como reproduzir).

> **Uma distinção que precisa ficar clara para todo mundo.**
> A **aplicação** vai para produção. O **instrumento** continua em fase piloto,
> sem validação psicométrica. Publicar não valida. Os avisos de limite na
> interface são obrigatórios e não devem ser removidos.

---

## 1. Arquitetura

Ver os diagramas em `DIAGRAMA_BANCO.md`. Em resumo:

| Camada | Tecnologia | Observação |
|---|---|---|
| Frontend | Next.js 14 (App Router), React 18, TypeScript | Server Components para leitura; Client Components no questionário e na gestão |
| Backend | Rotas de servidor do próprio Next.js | `/api/exportar` e `/api/preparar`. Não há backend separado |
| Cálculo | Biblioteca TypeScript pura | `src/lib/scoring.ts`, `aggregate.ts`, `animais.ts`, `narrative.ts`, `excel.ts`. Sem rede, sem aleatoriedade, sem IA |
| Banco | PostgreSQL gerenciado (Supabase) | Row Level Security ativo em todas as tabelas sensíveis |
| Autenticação | Supabase Auth (e-mail e senha) | Papéis na tabela `administradores` |
| Planilhas | ExcelJS | Gerado no servidor, nas rotas |
| Hospedagem | Qualquer provedor que rode Next.js 14 | Vercel é o caminho mais curto |

**Não existe** no projeto, e não deve ser provisionado: fila, cache distribuído,
worker, microsserviço, storage de objetos ou serviço de IA em runtime.

### Estrutura do repositório

```
src/data/        FONTE ÚNICA DE VERDADE do instrumento
  questions.ts       48 itens, 192 alternativas, chave Jung + eixo
  scoringMatrix.ts   matriz funcional por alternativa
  profiles.ts        8 perfis, animais, cores, luz e sombra
  functional.ts      capacidades e papéis de Belbin
src/lib/         cálculo determinístico, agregação, animais, narrativa, Excel, env
src/components/  interface compartilhada com a pré-visualização
src/app/         páginas e rotas
supabase/        migrations SQL na ordem de aplicação
scripts/         auditorias, testes, geração de SQL e da pré-visualização
baseline.json    prova de regressão do instrumento
```

---

## 2. Pré-requisitos

- Node.js 18 ou superior
- Conta no [Supabase](https://supabase.com) — o plano gratuito atende ao piloto
- Conta em uma hospedagem de Next.js
- Acesso ao DNS do domínio que será usado

---

## 3. Banco de dados

### 3.1 Criar o projeto no Supabase

1. **New project**. Escolha a região mais próxima dos usuários — para operação
   no Brasil, `South America (São Paulo)`.
2. Guarde a senha do banco em cofre de senhas. Ela **não** vai para o `.env`.
3. **Project Settings → Database → Connection pooling**: mantenha ativo.

### 3.2 Executar as migrations — ordem obrigatória

**SQL Editor → New query**, um arquivo por vez, **nesta ordem**:

| # | Arquivo | O que cria |
|---|---|---|
| 1 | `supabase/01_schema.sql` | Tabelas, tipos, índices, gatilho de conclusão, funções de autorização |
| 2 | `supabase/02_policies.sql` | Row Level Security dos três papéis |
| 3 | `supabase/03_seed.sql` | 48 questões, 192 alternativas, 8 perfis, matrizes, 16 setores |
| 4 | `supabase/05_migracao_v2.sql` | Trilha funcional própria, arquivamento, auditoria, retomada, reset |
| 5 | `supabase/06_producao.sql` | `is_test`, view de dados reais, limpeza DEMO, checklist, auditoria de login e conclusão |
| 6 | `supabase/07_papeis.sql` | Marcação `eh_administrador` nas views, trava das colunas de marcação do participante |
| 7 | `supabase/08_reavaliacao_v2.sql` | **v2.0-reavaliacao**, inativa: `resultados_v2`, `desempates`, `vw_resultados_v2`, filtros de contrato e líder |

**Não executar:**

- `supabase/04_demo_seed.sql` — cria 96 participantes fictícios. Só desenvolvimento.
- `supabase/00_stub_auth_local.sql` — reproduz o schema `auth` para validar o SQL
  em um PostgreSQL local. No Supabase o schema `auth` já existe.

### 3.3 Conferir

```sql
select * from verificar_prontidao();
```

Os itens de banco devem sair todos com `ok = true`, exceto `administrador`
enquanto o passo 3.5 não tiver sido feito.

### 3.4 Modelo de dados

Campo a campo em `DICIONARIO_DE_DADOS.md`; diagrama ER em `DIAGRAMA_BANCO.md`.
Os pontos que importam para quem opera:

- **Respostas brutas são imutáveis.** Não há policy de UPDATE nem de DELETE em
  `respostas`. A chave de pontuação é copiada para a linha no momento da
  resposta, então editar o banco de questões não altera avaliação histórica.
- **Reset arquiva, não apaga.** `arquivada_em` tira a avaliação dos indicadores
  e preserva as respostas.
- **`vw_resultados` é a fronteira.** Ela já exclui `is_demo` e `is_test`. Tudo
  que a aplicação lê passa por ela.

### 3.5 ⚠️ O único passo manual

Um usuário do Supabase Auth não pode ser criado por SQL antecipadamente.

1. **Authentication → Users → Add user**. Crie o usuário do Administrador Master
   e copie o **UID**.
2. **SQL Editor**:

```sql
insert into administradores (user_id, papel, nome)
values ('COLE-AQUI-O-UID', 'MASTER', 'Nome do responsável');
```

Sem isso a pessoa entra como participante e não vê dashboard nenhum —
comportamento correto e seguro.

Administrador de setor (vê apenas o próprio setor, **sem** respostas brutas):

```sql
insert into administradores (user_id, papel, setor_id, nome)
values ('UID', 'ADMIN_SETOR', (select id from setores where codigo = 'MEC'), 'Nome');
```

### 3.5.1 Administrador que também responde

A conta que administra **pode** responder às 48 situações. O resultado dela não
é escondido nem descontado: aparece no painel nominal com a etiqueta
`administração` e na planilha na coluna **Administrador**, para que quem lê o
mapa da equipe saiba de quem é aquela linha. Se a preferência for manter as
duas coisas em contas distintas, basta que a pessoa use um login para
administrar e outro para responder — nada no sistema obriga a escolha, e a
etiqueta continua indicando o que é o quê.

Duas travas correlatas, em `07_papeis.sql`:

- `papel()` filtra `administradores` por `user_id`. Sem isso, o MASTER — que
  pela policy enxerga **todas** as linhas — perdia todos os dashboards no
  momento em que o segundo administrador era cadastrado.
- Um trigger impede o participante de alterar `is_demo`, `is_test` e `ativo` do
  próprio cadastro. RLS no PostgreSQL não distingue coluna, e sem a trava um
  participante conseguia marcar-se como demonstração e desaparecer de todo
  indicador, relatório e planilha pela API.

### 3.5.2 Os dois modos de sessão

Toda policy de RLS é `to authenticated`. **Sem sessão, o RLS não devolve
linha nenhuma** — nem a lista de setores. A aplicação resolve isso de dois
jeitos, conforme quem está do outro lado:

| Quem | Sessão | Onde nasce |
|---|---|---|
| Quem responde | **anônima**, criada em silêncio | `garantirSessao()`, no primeiro carregamento de `/questionario` |
| Quem administra | **nominal**, e-mail e senha | tela `/entrar` |

O usuário anônimo tem `role: authenticated` e `is_anonymous: true` no JWT.
Isso faz `auth.uid()` existir e **todas as policies valerem sem alteração**: ele
cria o próprio participante, grava as próprias respostas e não enxerga nada de
terceiros. Como não está em `administradores`, `papel()` devolve PARTICIPANTE e
os dashboards respondem "Acesso restrito" com caminho para o login.

`garantirSessao()` **não toca em sessão existente**: quem entrou pelo `/entrar`
continua sendo ele mesmo, inclusive ao responder o instrumento.

Duas configurações no painel, sem as quais isso não funciona:

1. **Authentication → Sign In / Providers → Anonymous sign-ins: ligado.**
   Sem isso, `/questionario` não abre sessão e a tela volta a mostrar
   "Nenhum setor" — como se o banco estivesse vazio.
2. **Authentication → Rate Limits.** O padrão é 30 cadastros anônimos por hora
   **por IP**. Uma equipe inteira atrás do mesmo NAT corporativo estoura isso
   em minutos. Suba o limite antes da aplicação em massa.

A saída é `POST /api/sair` — rota de servidor, não botão em JavaScript, para
que a biblioteca do Supabase não entre no bundle de toda página.

### 3.6 Row Level Security

Três papéis, aplicados **no banco**:

| Papel | Participantes | Respostas brutas | Dashboards | Gestão de dados | Auditoria |
|---|---|---|---|---|---|
| `PARTICIPANTE` | só a si | só as próprias | não | não | não |
| `ADMIN_SETOR` | do próprio setor | **nenhuma** | do próprio setor | não | não |
| `MASTER` | todos | todas | todos | sim | sim |

Verificado com três identidades reais — ver `RELATORIO_DE_TESTES.md`, seção 8.
As views usam `security_invoker = true`, de modo que o RLS das tabelas continua
valendo dentro delas. **Não remova essa cláusula ao editar as views.**

### 3.7 Backups

Supabase → **Database → Backups**. No plano gratuito o retorno é limitado; para
aplicação real, avalie plano com *Point-in-Time Recovery*. Independentemente
disso, o Administrador Master deve exportar o **Excel completo** antes de
qualquer operação destrutiva — é um backup lógico legível, e a interface pede
isso explicitamente.

---

## 4. Variáveis de ambiente

`cp .env.example .env.local` e preencha:

| Variável | Onde obter | Exposta ao navegador |
|---|---|---|
| `NEXT_PUBLIC_APP_MODE` | fixo: `production` | sim |
| `NEXT_PUBLIC_SUPABASE_URL` | Project Settings → API | sim |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Project Settings → API | sim |
| `SUPABASE_SERVICE_ROLE_KEY` | Project Settings → API | **NÃO** |

Sobre `NEXT_PUBLIC_APP_MODE`: **produção é o padrão**. Variável ausente, vazia
ou com valor inválido resulta em produção. Geradores de dados fictícios só
destravam com `NEXT_PUBLIC_APP_MODE=development` **e** `PERMITIR_SEED_DEMO=true`
— combinação que jamais deve existir em ambiente de aplicação.

Sobre a `SERVICE_ROLE_KEY`: ela ignora RLS. É usada por **uma única rota**
(`/api/preparar`), que precisa gravar o registro temporário de validação em nome
de outro participante — algo que o RLS, corretamente, impede um administrador de
fazer pela chave anônima. Nunca a coloque em variável `NEXT_PUBLIC_`, nunca a
versione, e restrinja quem tem acesso a ela no painel da hospedagem.

---

## 5. Ambientes

Três, com bancos **separados** (itens 12 e 13):

| Ambiente | `NEXT_PUBLIC_APP_MODE` | Seed demo | Projeto Supabase |
|---|---|---|---|
| Development | `development` | permitido com `PERMITIR_SEED_DEMO=true` | próprio |
| Homologation | `production` | **bloqueado** | próprio |
| Production | `production` | **bloqueado** | próprio |

Homologação deve rodar em modo produção contra um banco próprio. Testar em
produção com dados reais de pessoas não é aceitável.

---

## 6. Publicação

```bash
npm install
npm run verificar     # auditorias + testes + regressão + typecheck
npm run build
```

`npm run verificar` precisa terminar sem falha antes do deploy.

### Vercel

O diretório não precisa ser repositório git: o CLI envia a pasta.

```bash
npx vercel            # primeira publicação (pergunta e cria o projeto)
npx vercel --prod     # produção
```

`.vercelignore` está no repositório e **é segurança, não arrumação**: mantém
fora do envio `docker/` — que contém o `JWT_SECRET` e a `SERVICE_KEY` da pilha
local —, além de `demo/`, `dist/`, `scripts/`, `supabase/` e a documentação.
Em tempo de execução a aplicação precisa apenas de `src/`, `public/`,
`next.config.mjs`, `package.json` e `tsconfig.json`.

Declare as quatro variáveis em **Settings → Environment Variables**, marcando
`SUPABASE_SERVICE_ROLE_KEY` para os ambientes corretos e **nunca** como pública.

Depois do primeiro deploy, volte ao Supabase em **Authentication → URL
Configuration** e preencha **Site URL** e **Redirect URLs** com o domínio
publicado — e confira o passo 3.5.2 (sign-ins anônimos e rate limit), sem o
qual o questionário não abre para ninguém.

### Outro provedor

Qualquer runtime Node 18+ que execute `npm run build && npm start`. A aplicação
não usa recurso específico da Vercel.

### Domínio e HTTPS

1. Aponte um registro `CNAME` do subdomínio escolhido para o alvo indicado pelo
   provedor de hospedagem (na Vercel, `cname.vercel-dns.com`).
2. O certificado TLS é emitido automaticamente por Let's Encrypt em ambos os
   provedores. Confirme a emissão antes de divulgar o endereço.
3. Force HTTPS e HSTS no provedor.
4. Adicione o domínio final em **Supabase → Authentication → URL Configuration**
   (Site URL e Redirect URLs) — sem isso o login falha em produção.

---

## 7. Segurança

- **Chave anônima no navegador é esperado.** Ela é pública por desenho; quem
  protege os dados é o RLS. Não tente escondê-la.
- **Nunca** exponha a `service_role` no cliente.
- MFA nas contas de administrador do Supabase e da hospedagem.
- Revise `administradores` periodicamente: quem saiu da organização precisa sair
  daqui e do Supabase Auth.
- O acesso à área do Master permite exportar dados pessoais. Trate como conta
  privilegiada.

---

## 8. LGPD

O sistema trata: **nome**, **matrícula**, **setor**, **respostas item a item** e
**resultados derivados**. As respostas são o dado mais sensível do conjunto.

| Tema | Situação atual | O que a organização precisa definir |
|---|---|---|
| Finalidade | Desenvolvimento organizacional e composição de equipes. Declarado na interface | Registrar a finalidade no inventário de tratamento |
| Base legal | Não definida no sistema | **Definir**: consentimento ou legítimo interesse, com o jurídico |
| Acesso | RLS de três papéis | Aprovar a lista nominal de administradores |
| Retenção | Sem expurgo automático | **Definir prazo** e quem executa |
| Anonimização | Exportação anonimizada substitui nome e matrícula por `P00001`… | Ver ressalva abaixo |
| Exclusão | `executar_reset('participante', matricula)` arquiva; exclusão física exige SQL | Definir o procedimento de atendimento ao titular |
| Backup | Do provedor + Excel completo | Definir onde o Excel exportado é guardado |
| Auditoria | `logs_auditoria`, sem expurgo automático | Definir retenção do log |

> **Ressalva honesta sobre a anonimização.** A exportação anonimizada é
> **pseudonimização**, não anonimização irreversível: ela remove nome e
> matrícula, mas mantém as respostas item a item, e quem tiver acesso à base
> original consegue reidentificar. Documente-a assim.

**Este guia não substitui parecer jurídico.** A implantação deve ser validada
pelo Encarregado de Dados (DPO), pelo jurídico e pela área de gestão de pessoas
antes da aplicação com pessoas reais.

---

## 9. Preparar a base para aplicação real

Item 95. Depois de publicar e antes de abrir para os participantes:

1. Entre como **Administrador Master**.
2. **Gestão de dados → Preparar aplicação**. Confira os contadores de registros
   DEMO e de validação.
3. Se houver dado DEMO — por exemplo, porque `04_demo_seed.sql` chegou a ser
   aplicado por engano:
   - **LIMPAR DADOS DA DEMONSTRAÇÃO**;
   - confira as três contagens (participantes, avaliações, respostas) e o aviso
     de que nenhum dado real será removido;
   - **EXPORTAR BACKUP DOS DADOS DEMO**;
   - digite `LIMPAR DADOS DEMO` e confirme;
   - verifique a mensagem "0 registros DEMO permanecem".
4. **PREPARAR SISTEMA PARA APLICAÇÃO REAL**. A rotina cria um registro
   `is_test`, grava as 48 respostas uma a uma, retoma, finaliza, confere o
   resultado, compara com a equipe, monta o dashboard, gera um Excel de verdade,
   **verifica que esse registro não entrou em nenhum indicador** e o remove.
5. Leia o checklist. Só siga adiante com todos os itens em ✓.
6. Confira `CHECKLIST_GOLIVE.md`.

---

## 10. Monitoramento e logs

| O que | Onde |
|---|---|
| Erros de aplicação | Logs da hospedagem (na Vercel, **Deployments → Functions**) |
| Erros de banco, consultas lentas | Supabase → **Logs & Analytics** |
| Ações administrativas | Tabela `logs_auditoria`, visível em **Gestão de dados → Auditoria** |
| Saúde do instrumento | **Metodologia** — frequência por alternativa, itens pouco discriminativos, taxa de empate |

Sugestão de rotina: revisar a auditoria semanalmente durante o piloto e conferir
a aba Metodologia a cada lote de respostas.

---

## 11. Rollback

O deploy e o banco têm caminhos de volta diferentes.

**Aplicação.** Na Vercel, **Deployments → Promote to Production** no deploy
anterior. Reversão em segundos, sem tocar em dados.

**Banco.** As migrations 05 e 06 são **aditivas e idempotentes**: acrescentam
colunas, tabelas, views e funções, e não removem nem alteram dado existente.
Reexecutá-las é seguro. Para voltar atrás:

- **Uma operação de reset indevida**: as avaliações foram *arquivadas*, não
  apagadas. Reverta com
  `update avaliacoes set arquivada_em = null, arquivada_por = null where arquivada_em > 'AAAA-MM-DD';`
- **Limpeza DEMO**: é **exclusão física** e **não tem desfazer**. É exatamente
  por isso que a interface obriga a exportar o backup antes e a digitar a
  confirmação literal.
- **Perda de dados reais**: restaure pelo backup do provedor. Não existe
  desfazer na aplicação.

**Regra de ouro:** antes de qualquer operação destrutiva, exporte o Excel
completo. A interface pede isso, e o pedido não é decorativo.

---

## 12. Verificação e testes

```bash
npm run audit:itens      # auditoria estrutural dos 48 itens
npm run audit:matriz     # matriz de pontuação e independência das trilhas
npm run test:algoritmo   # 83 testes do algoritmo determinístico
npm run test:telas       # 15 verificações de texto de tela
npm run test:animais     # 16 verificações da composição simbólica
npm run test:excel       # 13 verificações abrindo o .xlsx gerado
npm run regressao        # o instrumento continua idêntico à baseline?
npm run typecheck
npm run verificar        # tudo acima
npm run build

# Ponta a ponta contra um PostgreSQL real, com RLS ligado — 45 verificações:
PGURL=postgres://usuario@host/banco npx tsx scripts/test-producao.ts
```

Detalhamento e resultados em `RELATORIO_DE_TESTES.md`.

---

## 13. Solução de problemas

| Sintoma | Causa provável | O que fazer |
|---|---|---|
| "Não foi possível consultar os dados" | Credencial ou conexão | Conferir as variáveis e se as 5 migrations foram aplicadas |
| Entro e não vejo dashboard | Autenticado como participante | Inserir o UID em `administradores` (3.5) |
| Dashboard em 0 com respostas no banco | Avaliações não concluídas, arquivadas, ou marcadas como demo/test | `select status, is_demo, is_test, arquivada_em, count(*) from avaliacoes group by 1,2,3,4;` |
| Excel não baixa | Página aberta dentro de um visualizador embutido (iframe) | Abrir a aplicação em aba própria. A tela avisa antes e oferece link manual |
| Login falha em produção | Site URL não configurada | Supabase → Authentication → URL Configuration |
| Dados fictícios reapareceram | `04_demo_seed.sql` reaplicado | Gestão de dados → Preparar aplicação → LIMPAR DADOS DA DEMONSTRAÇÃO |
