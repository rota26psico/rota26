# Dicionário de Dados — ROTA26

Item 87 e item 105 do prompt-mestre. Gerado a partir do **esquema real**
aplicado em PostgreSQL 16 (`information_schema`), não de documentação a priori.

Legenda: `PK` chave primária · `FK` chave estrangeira · `UQ` único · `NN` não nulo.

---

## 1. Estrutura do instrumento

Tabelas que **nunca** são apagadas por reset ou limpeza.

### `setores` — equipes / contratos
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | Identificador interno |
| `codigo` | text | UQ, NN | Sigla exibida na interface (ex.: `MEC`) |
| `nome` | text | NN | Nome por extenso |
| `ativo` | boolean | NN, default true | Somente equipes ativas aparecem no cadastro |
| `criado_em` | timestamptz | NN | — |

### `versoes_instrumento` — versionamento (item 49 da etapa anterior)
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | — |
| `codigo` | text | UQ, NN | Ex.: `v1.0-piloto` |
| `descricao` | text | | — |
| `peso_atitude` | int | NN | **Denominador** dos escores E/I. Hoje 27 |
| `peso_funcao` | int | NN | **Denominador** dos escores T/F/S/N. Hoje 27 |
| `ativa` | boolean | NN | Índice único parcial garante **uma só** versão ativa |
| `publicada_em` | timestamptz | | — |

### `questoes` — as 48 situações
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | — |
| `versao_id` | uuid | FK → `versoes_instrumento` | Item pertence a uma versão |
| `codigo` | text | UQ com versão | `Q001` … `Q048` |
| `tipo` | enum | NN | `FUNCAO` ou `ATITUDE` |
| `peso` | int | NN, 1 a 3 | 2 nas seis âncoras; 1 nas demais |
| `contexto`, `enunciado` | text | NN | Texto exibido |
| `ordem` | int | NN | Ordem canônica |
| `ativa` | boolean | NN | — |

### `alternativas` — as 192 opções
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | — |
| `questao_id` | uuid | FK → `questoes` | Quatro por item |
| `codigo` | text | UQ com questão | `Q001A` … `Q048D` |
| `texto` | text | NN | — |
| `jung` | enum | NN | **Chave de pontuação**: `E`,`I`,`T`,`F`,`S`,`N` |
| `eixo` | enum | NN | **Chave de pontuação**: `EXP`,`EXE`,`AUT`,`COO`,`FLE`,`EST` |
| `ordem` | int | NN | Ordem canônica; a exibição é embaralhada |

### `perfis` · `matriz_funcional` · `afinidade_belbin`
Matrizes teóricas dos 8 perfis, das 10 capacidades e dos 9 papéis.
`perfis.conteudo` é `jsonb` com jung, livro, estrutura, luz, sombra e trabalho.
`perfis.cor` é a **cor canônica do animal**, usada em toda a interface (item 77).

---

## 2. Pessoas e acesso

### `participantes`
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | — |
| `user_id` | uuid | UQ, FK → `auth.users` | Nulo em registros sem login próprio |
| `nome` | text | NN | **Dado pessoal** |
| `matricula` | text | UQ, NN | **Identificador organizacional único** (item 18) |
| `email` | text | | **Dado pessoal** |
| `setor_id` | uuid | FK → `setores`, NN | Impede participante sem equipe |
| `ativo` | boolean | NN | — |
| `is_demo` | boolean | NN, default false | **Registro de demonstração** |
| `is_test` | boolean | NN, default false | **Registro de validação controlada** (item 34) |
| `reaplicacao_liberada_em` / `_por` | timestamptz / uuid | | Item 17 — autorização do Master |

### `administradores`
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `user_id` | uuid | PK, FK → `auth.users` | — |
| `papel` | enum | NN | `MASTER` ou `ADMIN_SETOR` |
| `setor_id` | uuid | FK → `setores` | Obrigatório para `ADMIN_SETOR`, nulo para `MASTER` (constraint `admin_setor_coerente`) |

---

## 3. Coleta

### `avaliacoes`
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | — |
| `participante_id` | uuid | FK → `participantes`, NN | — |
| `versao_codigo` | text | NN | **Congelado**, não é FK mutável — editar o banco de questões não altera avaliações históricas |
| `status` | enum | NN | `EM_ANDAMENTO`, `CONCLUIDA`, `INVALIDADA` |
| `iniciada_em` / `concluida_em` | timestamptz | | — |
| `is_demo` / `is_test` | boolean | NN | Excluem a linha de **todos** os indicadores |
| `arquivada_em` / `arquivada_por` | timestamptz / uuid | | Soft delete: sai dos indicadores, as respostas permanecem |

> **Gatilho `trg_valida_conclusao`**: recusa mudar o status para `CONCLUIDA`
> enquanto o número de respostas for menor que o número de itens ativos da
> versão. É a garantia de banco do item 25.

### `respostas` — RESPOSTAS BRUTAS
| Campo | Tipo | Regras | Significado |
|---|---|---|---|
| `id` | uuid | PK | — |
| `avaliacao_id` | uuid | FK → `avaliacoes`, NN | — |
| `questao_codigo` | text | NN, UQ com avaliação | Uma resposta por item |
| `alternativa_codigo` | text | NN | — |
| `jung` | enum | NN | **Chave copiada no momento da resposta** |
| `eixo` | enum | NN | Idem |
| `peso` | int | NN | Idem |
| `posicao_exibida` | int | | Posição em que a alternativa apareceu (randomização) |
| `respondida_em` | timestamptz | NN | — |

> A chave é **copiada**, não referenciada. Se as questões forem editadas depois,
> este registro permanece íntegro e o resultado continua reproduzível.
> Sem policy de UPDATE ou DELETE: respostas brutas são imutáveis.
> Formato adequado a alfa de Cronbach, ômega, correlação item-total, análise
> fatorial e teste-reteste.

---

## 4. Resultados derivados

Todos recalculáveis a partir de `respostas`.

| Tabela | Chave | Conteúdo |
|---|---|---|
| `escores` | `avaliacao_id` PK | `bruto` e `relativo` (jsonb) dos seis polos junguianos |
| `resultados` | `avaliacao_id` PK | atitude, funções dominante/auxiliar/inferior/menos representada, perfil principal e secundário, empate, regra de desempate, `ordem_funcoes` (text[]), versão do algoritmo |
| `resultados_funcionais` | `avaliacao_id` PK | `eixos_bruto`, `eixos`, `cap_bruto`, `capacidades` (jsonb), `ordem_capacidades` (text[]), `versao_matriz` |
| `resultados_belbin` | `avaliacao_id` PK | `bruto`, `relativo` (jsonb) e top1/top2/top3 com valor e intensidade |

---

## 5. Auditoria

### `logs_auditoria` — o log em uso
| Campo | Tipo | Significado |
|---|---|---|
| `id` | bigserial PK | — |
| `user_id` | uuid | Autor |
| `usuario_email` | text | Preenchido pelo banco via `email_do_usuario()` (item 30) |
| `acao` | text NN | `LOGIN`, `CONCLUSAO`, `EXPORTACAO`, `RESET`, `LIMPEZA_DEMO`, `LIMPEZA_TESTE`, `ALTERACAO_CONFIGURACAO` |
| `escopo`, `parametro` | text | Alvo da operação |
| `registros_afetados` | int NN | Quantidade |
| `detalhe` | jsonb | Contexto da operação |
| `criado_em` | timestamptz NN | Data e horário |

`log_auditoria` (singular) é a tabela original do schema 01, mantida por
compatibilidade. A aplicação escreve em `logs_auditoria`.

---

## 6. Views

| View | Conteúdo | Regra |
|---|---|---|
| `vw_resultados` | **Somente dados reais** | `status = CONCLUIDA` **e** não arquivada **e** `is_demo = false` **e** `is_test = false`. Tudo que a aplicação lê passa por aqui |
| `vw_resultados_todos` | Tudo que está concluído | Usada **apenas** para o backup dos dados DEMO |
| `resultados_jung` | Compatibilidade de nome | — |

Ambas com `security_invoker = true`: o RLS das tabelas continua valendo dentro
da view. Ambas expõem `eh_administrador` — verdadeiro quando o respondente
também é conta administrativa. É marcação, não filtro: a linha continua
contando em todos os indicadores.

---

## 7. Funções

| Função | Papel exigido | O que faz |
|---|---|---|
| `eh_master()` · `eh_admin()` · `setor_do_admin()` · `meu_participante_id()` | — | Autorização, usadas pelas policies |
| `eh_conta_administrativa(user_id)` | autenticado | Alimenta `eh_administrador` nas views. SECURITY DEFINER: sem isso o ADMIN_SETOR, que só enxerga a própria linha de `administradores`, veria a marcação sempre falsa |
| `email_do_usuario()` | — | E-mail do JWT, para a auditoria |
| `resumo_organizacional()` | autenticado | Contadores do topo do dashboard, já sem DEMO |
| `avaliacao_em_andamento()` | participante | Retomada (item 24) |
| `previa_reset()` · `executar_reset()` | MASTER | Arquivamento com prévia; reset geral exige `ZERAR RESULTADOS` |
| `previa_limpeza_demo()` | MASTER | Contagens do item 17 |
| `limpar_dados_demo(confirmacao)` | MASTER | Exige `LIMPAR DADOS DEMO` (item 19) |
| `contagem_demo()` | MASTER | Governa a exibição dos botões |
| `limpar_dados_teste()` | MASTER | Remove registros `is_test` |
| `liberar_reaplicacao(matricula)` | MASTER | Item 17 |
| `verificar_prontidao()` | MASTER | Checklist verificado no banco |
| `registrar_evento()` · `registrar_exportacao()` | autenticado | Auditoria |

---

## 8. Índices

`participantes(setor_id)` · `participantes(is_demo) where is_demo` ·
`participantes(is_test) where is_test` · `avaliacoes(participante_id)` ·
`avaliacoes(status)` · `avaliacoes(is_demo) where is_demo` ·
`avaliacoes(is_test) where is_test` · `avaliacoes(status) where arquivada_em is null` ·
`respostas(avaliacao_id)` · `respostas(questao_codigo, alternativa_codigo)` ·
`resultados(perfil_principal)` · `logs_auditoria(criado_em desc)` ·
`versoes_instrumento((ativa)) where ativa` (único).

---

## 9. Dados pessoais (para a análise de LGPD)

| Campo | Onde | Classificação |
|---|---|---|
| `participantes.nome` | tabela e exportações não anonimizadas | Dado pessoal |
| `participantes.matricula` | idem | Dado pessoal — identificador funcional |
| `participantes.email` | idem | Dado pessoal |
| `participantes.setor_id` | idem | Dado funcional |
| `respostas.*` | tabela | Dado comportamental de autorrelato — **o mais sensível do conjunto** |
| `resultados.*`, `escores.*`, `resultados_funcionais.*`, `resultados_belbin.*` | tabelas | Derivados do anterior |
| `logs_auditoria.usuario_email` | tabela | Dado pessoal de administrador |

A exportação **anonimizada** substitui nome e matrícula por `P00001`, `P00002`…
atribuídos por ordem de conclusão. Ela continua contendo respostas item a item,
portanto **não é anonimização irreversível** para quem tenha acesso à base
original — é pseudonimização. Trate como tal.
