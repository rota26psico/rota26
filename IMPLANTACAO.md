# Implantação — da pré-visualização à aplicação organizacional

Este documento é o caminho completo entre o que existia (um arquivo HTML navegável com dados
em memória) e o que passa a existir agora: uma **aplicação organizacional em produção**, com banco
persistente, controle de acesso e auditoria.

> **Produção técnica não é validação científica.** A aplicação roda em ambiente de produção com dados
> reais. O **instrumento** continua em fase piloto, não normatizado, e não deve ser usado isoladamente
> para seleção, promoção, transferência ou desligamento. As duas afirmações são compatíveis e ambas
> aparecem na interface.

---

## 1. O que mudou

| | Antes | Agora |
|---|---|---|
| Fonte oficial dos dados | memória do navegador | **PostgreSQL (Supabase)** |
| Dados iniciais | 96 participantes fictícios criados na abertura | **nenhum** — o banco começa vazio |
| Dashboards | contavam tudo | contam **somente** `is_demo = false` e `is_test = false`, filtrado **na view do banco** |
| Identidade | "Demonstração navegável" | **Mapeamento da Diversidade Psicológica, Comportamental e Funcional das Equipes** |
| Retomada | recomeçava sozinha | **pergunta** e reabre na primeira questão sem resposta |
| Já concluiu | abria outra avaliação em silêncio | **bloqueia** e explica; só o Master libera reaplicação |
| Zero respondentes | gráfico vazio ambíguo | **"Aguardando respostas para gerar análise."** |
| Falha de banco | virava "0 participantes" | **"Não foi possível consultar os dados."** |
| Limpeza dos dados fictícios | não existia | **LIMPAR DADOS DA DEMONSTRAÇÃO**, com prévia, backup, confirmação literal e auditoria |
| Autor nos registros | `master@demo` | **administrador autenticado real** |

O `dist/demo.html` continua existindo, agora rotulado como **pré-visualização de desenvolvimento**.
Ele executa exatamente o mesmo código de cálculo e as mesmas telas, mas **não é a aplicação**: serve
para percorrer a interface sem banco. A aplicação é a Next.js publicada em servidor.

---

## 2. Instalação

### 2.1 Pré-requisitos

Node.js 18+, uma conta no [Supabase](https://supabase.com) (plano gratuito serve) e uma conta em
qualquer hospedagem de Next.js (a Vercel tem plano gratuito).

```bash
npm install
```

### 2.2 Banco de dados — ordem obrigatória

No painel do Supabase: **SQL Editor → New query**. Cole e execute **um por vez, nesta ordem**:

| Ordem | Arquivo | O que faz |
|---|---|---|
| 1 | `supabase/01_schema.sql` | Tabelas, tipos, índices, gatilho de conclusão e funções de autorização |
| 2 | `supabase/02_policies.sql` | Row Level Security dos três papéis |
| 3 | `supabase/03_seed.sql` | 48 questões, 192 alternativas, 8 perfis, matrizes, 16 setores |
| 4 | `supabase/05_migracao_v2.sql` | Trilha funcional própria, arquivamento, auditoria, retomada, reset |
| 5 | `supabase/06_producao.sql` | **Produção**: `is_test`, view de dados reais, limpeza DEMO, checklist, auditoria de login e conclusão |
| 6 | `supabase/07_papeis.sql` | Marcação `eh_administrador` nas views, trava das colunas de marcação do participante |
| 7 | `supabase/08_reavaliacao_v2.sql` | **v2.0-reavaliacao**, inativa: `resultados_v2`, `desempates`, `vw_resultados_v2`, filtros de contrato e líder |
| 8 | `supabase/09_aplicacoes.sql` | Aplicações numeradas (`numero_aplicacao`), histórico `vw_aplicacoes`, `vw_resultados` com uma linha por pessoa e o desempate declarado da função auxiliar |

**Não execute** `supabase/04_demo_seed.sql`. Ele cria 96 participantes fictícios e existe apenas para
desenvolvimento. O arquivo `supabase/00_stub_auth_local.sql` também **não** deve ser executado no
Supabase — serve só para validar o SQL em um PostgreSQL local.

Depois de aplicar os cinco arquivos, confira:

```sql
select * from verificar_prontidao();
```

### 2.3 Variáveis de ambiente

```bash
cp .env.example .env.local
```

| Variável | Valor | Onde obter |
|---|---|---|
| `NEXT_PUBLIC_APP_MODE` | `production` | fixo |
| `NEXT_PUBLIC_SUPABASE_URL` | URL do projeto | Project Settings → API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | chave anônima | Project Settings → API |
| `SUPABASE_SERVICE_ROLE_KEY` | chave de serviço | Project Settings → API |

`NEXT_PUBLIC_APP_MODE` **tem produção como padrão**: se a variável faltar, estiver vazia ou tiver um
valor inválido, o sistema entra em produção. Só o valor literal `development`, combinado com
`PERMITIR_SEED_DEMO=true`, destrava qualquer gerador de dados fictícios. Essa combinação nunca deve
existir em um ambiente de aplicação.

A chave de serviço é usada por uma única rota (`/api/preparar`), porque a validação precisa gravar um
registro temporário em nome de outro participante — algo que o RLS, corretamente, impede um
administrador de fazer pela chave anônima. **Nunca** a exponha no cliente.

### 2.4 ⚠️ O único passo manual

Depende de um usuário existir no Supabase Auth, o que não pode ser criado por SQL antecipadamente.

1. **Authentication → Users → Add user**: crie seu usuário e copie o **UID**.
2. No SQL Editor:

```sql
insert into administradores (user_id, papel, nome)
values ('COLE-AQUI-O-UID', 'MASTER', 'Seu Nome');
```

Sem isso você entra como participante e não vê nenhum dashboard — comportamento correto e seguro.

Administrador de setor (vê apenas o próprio setor, **sem** respostas brutas):

```sql
insert into administradores (user_id, papel, setor_id, nome)
values ('UID', 'ADMIN_SETOR', (select id from setores where codigo = 'MEC'), 'Nome');
```

### 2.4.1 ⚠️ Sessão de quem responde

Toda policy de RLS é `to authenticated`, e quem responde não tem conta nominal.
A aplicação abre uma **sessão anônima** no primeiro carregamento de
`/questionario`. Ligue em **Authentication → Sign In / Providers → Anonymous
sign-ins** — sem isso o questionário mostra "Nenhum setor", como se o banco
estivesse vazio.

Em **Authentication → Rate Limits**, suba o teto de cadastros anônimos: o padrão
é 30 por hora **por IP**, e uma equipe inteira atrás do mesmo NAT corporativo
estoura isso em minutos.

Quem administra entra por `/entrar`, com e-mail e senha.

### 2.5 Publicar

```bash
npm run build
npx vercel        # ou a hospedagem de sua preferência
```

Declare as quatro variáveis de ambiente também no painel da hospedagem, e
preencha **Site URL** e **Redirect URLs** no Supabase com o domínio publicado.

`.vercelignore` mantém `docker/` fora do envio — é onde ficam o `JWT_SECRET` e a
`SERVICE_KEY` da pilha local.

---

## 3. Antes de aplicar — a rotina obrigatória

Entre como **Administrador Master** e vá em **Gestão de dados → Preparar aplicação**.

1. Confira os quatro contadores no topo: participantes DEMO, avaliações DEMO, registros de validação
   e ambiente.
2. Se houver dado DEMO (por exemplo, porque `04_demo_seed.sql` chegou a ser aplicado):
   **LIMPAR DADOS DA DEMONSTRAÇÃO** → confira as três contagens → **EXPORTAR BACKUP DOS DADOS DEMO**
   → digite `LIMPAR DADOS DEMO` → **CONFIRMAR LIMPEZA**.
3. **PREPARAR SISTEMA PARA APLICAÇÃO REAL**. A rotina cria um registro `is_test`, grava as respostas
   uma a uma, retoma, finaliza, confere o resultado, compara com a equipe, monta o dashboard, gera um
   Excel de verdade e depois remove o registro.
4. Leia o **checklist de pré-aplicação**. Só considere o sistema pronto quando todos os itens
   estiverem com ✓.

---

## 4. Checklist de validação

| # | Item | Onde é verificado |
|---|---|---|
| 1 | 48 questões carregadas | `verificar_prontidao()` |
| 2 | 48 questões com alternativas (192, quatro por item) | `verificar_prontidao()` |
| 3 | Algoritmo ativo (versão e denominadores) | `verificar_prontidao()` |
| 4 | Banco conectado | `verificar_prontidao()` |
| 5 | Salvamento funcionando | sonda real em `/api/preparar` |
| 6 | Retomada funcionando | sonda real em `/api/preparar` |
| 7 | Finalização funcionando | sonda real em `/api/preparar` |
| 8 | Resultado individual funcionando | sonda real em `/api/preparar` |
| 9 | Comparação com a equipe funcionando | sonda real em `/api/preparar` |
| 10 | Dashboard funcionando | sonda real em `/api/preparar` |
| 11 | Excel funcionando | sonda real em `/api/preparar` |
| 12 | Dados DEMO = 0 | `verificar_prontidao()` |
| 13 | Seed demo desativado | `APP_MODE` e `PERMITIR_SEED_DEMO` |
| 14 | RLS ativo | `verificar_prontidao()` — 8 de 8 tabelas sensíveis |
| 15 | Administrador autenticado | `verificar_prontidao()` |
| 16 | Logs funcionando | `verificar_prontidao()` |

Extras verificados junto: registros `is_test` = 0, avaliações concluídas com exatamente 48 respostas,
resultados derivados completos nas duas trilhas, nenhuma resposta órfã, e o registro de validação
comprovadamente fora dos indicadores.

---

## 5. Operação do dia a dia

**Participante.** Acessa `/questionario`, informa nome, matrícula e setor. Se já tiver avaliação em
andamento, o sistema pergunta se deseja continuar e reabre na primeira questão sem resposta. Se já
tiver concluído, vê a tela correspondente e pode rever o resultado — nunca começa outra em silêncio.

**Administrador de setor.** Vê os dashboards do próprio setor. **Não** vê respostas brutas, nem outros
setores, nem a gestão de dados. A restrição está no banco.

**Administrador Master.** Vê tudo, exporta, administra o instrumento, limpa dados DEMO, arquiva
avaliações, libera reaplicação e lê a auditoria.

**Reaplicação.** Gestão de dados → Preparar aplicação → *Liberar reaplicação de um participante*.
A avaliação anterior é **arquivada**, não apagada: as respostas continuam no banco para histórico e
análise psicométrica, mas saem dos indicadores atuais.

**Exportação.** Por padrão só dados reais. Enquanto existir dado DEMO, aparece uma opção separada
*Exportar dados DEMO*; depois da limpeza ela desaparece sozinha.

---

## 6. Comandos de verificação

```bash
npm run audit:itens      # auditoria estrutural dos 48 itens
npm run audit:matriz     # auditoria da matriz de pontuação e da independência das trilhas
npm run test:algoritmo   # 82 testes do algoritmo determinístico
npm run test:telas       # textos das telas de retomada, conclusão, vazio e erro
npm run typecheck
npm run verificar        # tudo acima
npm run build

# Teste de ponta a ponta contra um PostgreSQL real, com RLS ligado:
PGURL=postgres://usuario@host/banco npx tsx scripts/test-producao.ts
```

---

## 7. Solução de problemas

**"Não foi possível consultar os dados."** É erro de conexão ou de credencial, não base vazia. Confira
as variáveis de ambiente e se os cinco arquivos SQL foram aplicados.

**Entro e não vejo nenhum dashboard.** Você está autenticado como participante. Insira seu UID na
tabela `administradores` (seção 2.4).

**O dashboard mostra 0 e eu sei que há respostas.** Verifique se as avaliações estão `CONCLUIDA`,
não arquivadas, e sem `is_demo`/`is_test`:

```sql
select status, is_demo, is_test, arquivada_em, count(*) from avaliacoes
group by 1,2,3,4;
```

**O Excel não baixa.** Se a página estiver aberta dentro de um visualizador embutido (iframe), o
navegador bloqueia o download silenciosamente. Abra a aplicação em uma aba própria. A tela avisa
sobre isso antes do clique e oferece um link manual.

**Reapliquei o `04_demo_seed.sql` por engano.** Gestão de dados → Preparar aplicação →
LIMPAR DADOS DA DEMONSTRAÇÃO. Ou, direto no SQL: `select limpar_dados_demo('LIMPAR DADOS DEMO');`
