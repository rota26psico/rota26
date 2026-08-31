# CHECKLIST DE GO-LIVE — ROTA26

Item 105. Percorra na ordem. Só marque o que você **verificou**, não o que
presume estar certo. A coluna "como conferir" diz onde olhar.

---

## A · Ambiente e código

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Repositório na branch de produção, sem alteração local pendente | `git status` |
| ☐ | `npm install` sem erro | terminal |
| ☐ | `npm run verificar` passa inteiro | auditorias + 83 testes + 15 + 16 + 13 + regressão + typecheck |
| ☐ | `npm run regressao` sem divergência | é a prova de que o instrumento não mudou |
| ☐ | `npm run build` compila | 12 rotas |
| ☐ | Homologação publicada em banco **próprio**, em modo produção | painel da hospedagem |

## B · Banco

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Projeto Supabase criado na região correta | painel |
| ☐ | `01_schema.sql` aplicado | `select count(*) from questoes;` |
| ☐ | `02_policies.sql` aplicado | seção F abaixo |
| ☐ | `03_seed.sql` aplicado | 48 questões · 192 alternativas · 8 perfis · setores |
| ☐ | `05_migracao_v2.sql` aplicado | `resultados_funcionais` e `resultados_belbin` existem |
| ☐ | `06_producao.sql` aplicado | `select * from verificar_prontidao();` |
| ☐ | `07_papeis.sql` aplicado | `select eh_conta_administrativa(null) is not null;` |
| ☐ | `08_reavaliacao_v2.sql` aplicado, versão **inativa** | `select codigo, ativa from versoes_instrumento;` |
| ☐ | **`04_demo_seed.sql` NÃO aplicado** | `select * from contagem_demo();` → tudo zero |
| ☐ | **`00_stub_auth_local.sql` NÃO aplicado** | só serve para PostgreSQL local |
| ☐ | Backups do provedor ativos | Database → Backups |

## C · Variáveis e segredos

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | `NEXT_PUBLIC_APP_MODE=production` | painel da hospedagem |
| ☐ | `NEXT_PUBLIC_SUPABASE_URL` e `ANON_KEY` preenchidas | idem |
| ☐ | `SUPABASE_SERVICE_ROLE_KEY` preenchida e **não** pública | idem |
| ☐ | `PERMITIR_SEED_DEMO` ausente ou `false` | idem |
| ☐ | Nenhum segredo versionado | `git log -p .env*` |
| ☐ | `.vercelignore` presente — `docker/` fora do envio | procurar `docker/.env` no deployment publicado |

## D · Domínio e HTTPS

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | CNAME apontado e propagado | `dig` ou o painel do provedor |
| ☐ | Certificado TLS emitido | abrir o endereço em https |
| ☐ | HTTPS forçado, HSTS ativo | painel da hospedagem |
| ☐ | Site URL e Redirect URLs no Supabase apontam para o domínio final | Authentication → URL Configuration |

## E · Acessos

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Usuário do Administrador Master criado no Auth | Authentication → Users |
| ☐ | UID inserido em `administradores` com papel `MASTER` | login mostra Gestão de dados |
| ☐ | Administradores de setor criados, cada um com seu `setor_id` | login mostra só o próprio setor |
| ☐ | MFA ativo nas contas de Supabase e da hospedagem | painéis |
| ☐ | Lista nominal de quem tem acesso administrativo aprovada | registro da área responsável |

## E.1 · Sessão (sem isto, ninguém responde)

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | **Anonymous sign-ins ligado** | Authentication → Sign In / Providers |
| ☐ | Rate limit de cadastros anônimos elevado acima do padrão de 30/h por IP | Authentication → Rate Limits |
| ☐ | `/questionario` em aba anônima lista os 16 setores | abrir o endereço publicado |
| ☐ | `/dashboard` sem login mostra "Acesso restrito", não erro do servidor | idem |
| ☐ | `/entrar` autentica e abre os dashboards | idem |
| ☐ | **Sair** encerra a sessão e devolve o menu de participante | idem |

## F · Segurança verificada, não presumida

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Participante A não enxerga participante B | entrar como participante e olhar |
| ☐ | Participante não acessa `/dashboard` | a rota recusa |
| ☐ | Administrador de setor vê **zero** respostas brutas | painel de metodologia vazio para ele |
| ☐ | Administrador de setor não executa função de Master | tentar limpar demo → recusa do banco |
| ☐ | Master vê tudo e a auditoria | menu completo |
| ☐ | Views com `security_invoker = true` | `\d+ vw_resultados` |

## G · Preparação da base

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Zero registros DEMO | Gestão de dados → Preparar aplicação |
| ☐ | Se havia DEMO: backup exportado antes da limpeza | arquivo salvo em local definido |
| ☐ | Se havia DEMO: limpeza executada e "0 registros DEMO permanecem" | tela de resultado |
| ☐ | Zero registros `is_test` | mesmo painel |
| ☐ | **PREPARAR SISTEMA PARA APLICAÇÃO REAL** executado | todos os itens em ✓ |
| ☐ | Atualizar o navegador não recria dado fictício | F5 e conferir |

## H · Fluxo real, ponta a ponta

Faça com uma pessoa de verdade, em homologação, antes de abrir para todos.

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Cadastro exige nome, matrícula e setor | tentar enviar vazio |
| ☐ | As 48 situações aparecem, uma a uma | percorrer |
| ☐ | Cada resposta é salva no momento da escolha | conferir `respostas` no banco durante o preenchimento |
| ☐ | Fechar o navegador e voltar retoma no ponto exato | testar de verdade |
| ☐ | Finalização só ocorre com 48 respostas | tentar finalizar antes |
| ☐ | Resultado individual exibe os oito blocos | rolar a tela |
| ☐ | Animal aparece como correspondência simbólica | bloco 1 |
| ☐ | Luz e sombra presentes | bloco 5 |
| ☐ | Belbin com as três maiores proximidades detalhadas | bloco 7 |
| ☐ | "Você dentro da sua equipe" mostra quantos compartilham o perfil | bloco 8 |
| ☐ | Grupo com menos de 5 respondentes não exibe distribuição detalhada | testar em equipe pequena |

## I · Liderança e Master

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Dashboard da equipe nas seis seções | Síntese → Ação |
| ☐ | Composição dos animais com os oito, incluindo zeros | seção Composição |
| ☐ | Soma dos animais bate com o total, em toda equipe | sem alerta de inconsistência |
| ☐ | Matriz Equipe × Animal alterna quantidade e percentual | menu Animais |
| ☐ | Comparativo entre equipes carrega | menu Comparativo |
| ☐ | Leitura executiva individual abre | Pessoas e resultados |
| ☐ | As seis exportações baixam | Exportações |
| ☐ | Excel tem as 16 abas | abrir o arquivo |
| ☐ | Números do Excel batem com a tela | comparar uma equipe e um animal |
| ☐ | Auditoria registra login, conclusão e exportação | aba Auditoria |

## J · Conformidade

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Base legal do tratamento definida | jurídico |
| ☐ | Finalidade registrada no inventário de tratamento | DPO |
| ☐ | Prazo de retenção definido, com responsável | área de gestão de pessoas |
| ☐ | Procedimento de atendimento ao titular definido | DPO |
| ☐ | Equipes informadas sobre finalidade e limites antes de responder | comunicação enviada |
| ☐ | Avisos metodológicos presentes na interface | rodapé e telas de resultado |
| ☐ | Aprovação formal do DPO, do jurídico e de gestão de pessoas | registrada |

## K · Depois de publicar

| ✓ | Item | Como conferir |
|---|---|---|
| ☐ | Login funciona no domínio final | testar |
| ☐ | Um participante real concluiu e apareceu no dashboard | conferir |
| ☐ | Excel exportado logo após o primeiro lote | arquivar |
| ☐ | Rotina de revisão da auditoria definida | combinado com a TI |
| ☐ | Plano de rollback conhecido por quem está de plantão | guia técnico, seção 11 |

---

## Critério de aceite

A aplicação só está pronta quando **todas** as caixas acima estiverem marcadas,
e quando ficar claro para quem vai aplicar que **produção técnica não é
validação científica**: o instrumento permanece em fase piloto.
