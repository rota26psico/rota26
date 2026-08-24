# RELATÓRIO DE TESTES — ROTA26 v3.1

Item 105. Tudo aqui foi **executado**, não planejado. Cada seção diz o que foi
verificado, com que comando reproduzir e qual foi o resultado.

**Total: 263 verificações automatizadas, 0 falhas.**

> Última execução após o redesign visual (v3.1). A linha que mais importa nesta
> etapa é a da regressão: **nenhuma divergência**. O redesign mexeu em
> apresentação e em nada mais — os mesmos cinco conjuntos de 48 respostas e a
> mesma população de 96 participantes produzem exatamente os mesmos números de
> antes.

| Bateria | Verificações | Resultado | Comando |
|---|---|---|---|
| Auditoria estrutural dos 48 itens | — | **0 erros, 0 alertas** | `npm run audit:itens` |
| Auditoria da matriz (192 alternativas) | — | **0 erros, 0 alertas** | `npm run audit:matriz` |
| Algoritmo determinístico | 83 | **83/83** | `npm run test:algoritmo` |
| Telas de retomada, conclusão, vazio e erro | 15 | **15/15** | `npm run test:telas` |
| Composição simbólica dos animais | 16 | **16/16** | `npm run test:animais` |
| Dashboard × Excel (abrindo o .xlsx) | 13 | **13/13** | `npm run test:excel` |
| Cobertura e honestidade do glossário | 23 | **23/23** | `npm run test:glossario` |
| **Regressão contra a baseline** | campo a campo | **nenhuma divergência** | `npm run regressao` |
| Produção ponta a ponta em PostgreSQL real | 45 | **45/45** | `scripts/test-producao.ts` |
| Interface no navegador (Playwright) | 48 | **48/48, 0 erros de JS** | `npm run test:ui` |
| Verificação de tipos | — | **0 erros** | `npm run typecheck` |
| Compilação | — | **12 rotas** | `npm run build` |

---

## 1. Teste de regressão — o coração desta etapa

**Itens 7, 8 e 104.** Antes de tocar em qualquer arquivo, `npm run baseline`
congelou em `baseline.json`:

- **cinco conjuntos controlados** de 48 respostas, com regra de escolha fixa e
  reproduzível à mão;
- para cada um: perfil predominante, perfil secundário, atitude e margem, as
  quatro funções ordenadas, empate e regra de desempate, E/I/T/F/S/N brutos e
  relativos, denominadores, os seis eixos brutos e relativos, os eixos
  auxiliares, as dez capacidades brutas e relativas e sua ordenação, os nove
  papéis Belbin brutos e relativos, o top 3 e as versões;
- a **população fixa de 96 participantes em 16 equipes**, com IDF e seus três
  componentes, ICF, complementaridade, concentração, todas as distribuições,
  cobertura e Belbin agregado — no geral e equipe por equipe.

Depois de **todas** as alterações, `npm run regressao` reexecutou exatamente os
mesmos conjuntos e comparou campo a campo.

```
RESULTADO: nenhuma divergência. O instrumento é BIT A BIT o mesmo.
```

| Conjunto | Regra de escolha | Perfil | Secundário | E / I | T / F / S / N | Belbin (top 3) |
|---|---|---|---|---|---|---|
| C1 | sempre a 1ª alternativa | Te | Se | 100 / 0 | 100 / 0 / 0 / 0 | Monitor > Formador > Coordenador |
| C2 | sempre a 2ª | Fe | Se | 100 / 0 | 0 / 100 / 0 / 0 | Trab. Equipe > Coordenador > Formador |
| C3 | i mod 4 | Te | Se | 55,6 / 44,4 | 51,9 / 0 / 48,1 / 0 | Implementador > Finalizador > Monitor |
| C4 | 3 − (i mod 4) | Ni | Fi | 44,4 / 55,6 | 0 / 48,1 / 0 / 51,9 | Planta > Trab. Equipe > Inv. Recursos |
| C5 | ⌊i/3⌋ mod 4 | Te | Se | 55,6 / 44,4 | 37 / 14,8 / 29,6 / 18,5 | Implementador > Formador > Monitor |

População de referência: **IDF 84,2 · ICF 62,7 · complementaridade 100%** —
idênticos antes e depois.

O comparador reporta o **caminho exato** de qualquer diferença
(`individuais[3].retrato.top3Belbin[0].valor`, por exemplo), inclusive campo
novo ou removido. Não é comparação de resumo.

---

## 2. Instrumento

`npm run audit:itens` — 48 itens, 192 alternativas, quatro por item; 24 itens de
função e 24 de atitude; seis âncoras de peso 2; E+I = 27 e T+F+S+N = 27
(soma ímpar, que torna empate de atitude impossível); cobertura equilibrada dos
seis eixos; ausência de colinearidade entre polo junguiano e eixo auxiliar.
**0 erros, 0 alertas.**

`npm run audit:matriz` — as 192 linhas da matriz funcional: cobertura das dez
capacidades e dos nove papéis, soma de pesos por alternativa entre 3 e 4, poder
discriminativo por item e **independência das trilhas** (cada polo junguiano
precisa produzir ao menos quatro assinaturas funcionais distintas).
**0 erros, 0 alertas.**

---

## 3. Algoritmo — 83/83

Nove seções, incluindo determinismo em 150 execuções repetidas e com a ordem das
respostas embaralhada, as três regras de desempate, a independência entre as
duas trilhas (um teste inspeciona o próprio código de `calcularFuncional` para
garantir que ele não consulta o perfil junguiano) e a coincidência entre
dashboard e Excel.

Um teste foi **atualizado nesta etapa**: a contagem de abas do Excel completo
passou de 13 para 16, porque os itens 62 a 64 acrescentaram três abas. As 13
originais continuam sendo exigidas nominalmente — nenhuma exportação foi
removida.

---

## 4. Composição simbólica — 16/16

`npm run test:animais`, itens 50 a 56, 66 e 99:

- exatamente oito animais, e são os já definidos no instrumento;
- categorias com zero permanecem visíveis (16 equipes têm ao menos um animal em
  zero, e ele é exibido);
- **a soma dos oito animais bate com o total de avaliações válidas em todas as
  16 equipes e na organização** (96 de 96);
- um perfil fora dos oito é **detectado** como inconsistência — testado
  injetando um perfil inválido de propósito;
- maior e menor representação relativa identificadas;
- a composição bate com a `distribuicaoPerfis` que o dashboard já usava —
  mesma quantidade, mesmo percentual, mesmo arredondamento.

---

## 5. Dashboard × Excel — 13/13

`npm run test:excel`, itens 61 a 67 e 100. O teste **gera a planilha, abre o
arquivo com ExcelJS e lê as células**:

- as 13 abas anteriores continuam existindo, e as três novas foram criadas;
- coluna **Animal predominante** presente e preenchida na tabela individual;
- **136 combinações equipe × animal conferidas célula a célula**, sem divergência;
- exemplo nominal do item 67: dashboard `AGSUS · Urso · 3 · 60%` → Excel
  `AGSUS | Urso | 3 | 60%`;
- cada linha da matriz soma o total da equipe (17 linhas conferidas);
- cada linha percentual totaliza 100% dentro da tolerância de arredondamento;
- IDF, ICF e n da aba Indicadores idênticos aos do dashboard
  (84,2 · 62,7 · 96).

---

## 6. Telas — 15/15

`npm run test:telas` renderiza os componentes no servidor e confere o **texto
que a pessoa lê**: a pergunta de retomada e o ponto exato de volta, a tela de
quem já concluiu e as três condições de reaplicação, os três campos obrigatórios
do cadastro, o estado vazio, o erro de consulta (que declara explicitamente não
significar base vazia) e o checklist com aprovado e reprovado.

---

## 7. Produção ponta a ponta — 45/45

`scripts/test-producao.ts` contra **PostgreSQL 16 real, com RLS ligado**, banco
criado do zero com as migrations 01, 02, 03, 05, 06 e 07.

| Seção | O que provou |
|---|---|
| 1 · Estado inicial | zero DEMO, resumo honesto, estrutura intacta |
| 2 · Participante real | gravação item a item (20 respostas persistidas); retomada recupera as 20 e volta na situação 21 |
| 3 · Finalização | **o gatilho do banco recusa concluir com menos de 48 respostas**; a avaliação só fecha depois dos quatro derivados gravados |
| 4 · Já concluiu | nenhuma nova avaliação é aberta em silêncio |
| 5 · Dashboards | refletem exatamente o banco |
| 6 · Coexistência com DEMO | registro `is_demo` reintroduzido: view de dados reais devolve 1, view irrestrita devolve 2 — **o DEMO não entra em nenhum indicador** |
| 7 · Limpeza DEMO | prévia correta; confirmação errada recusada; limpeza remove só o DEMO; **participante real sobrevive com as 48 respostas**; 48 questões, 192 alternativas, 8 perfis, 16 setores, 80 linhas da matriz funcional, 72 de Belbin, versões e administradores intactos; auditado com o e-mail real |
| 8 · RLS | participante vê 1 pessoa e as próprias 48 respostas, e **0** registros de auditoria; administrador de setor vê seu setor e **0 respostas brutas**, e é **recusado** ao tentar limpar dados; Master vê tudo |
| 9 · Excel | planilha gerada do banco, sem nenhum registro DEMO; n do Excel = n do dashboard |
| 10 · Checklist | 14 itens de `verificar_prontidao()`, todos ✓ |
| 11 · Reaplicação | Master arquiva e libera; a avaliação sai dos indicadores **sem perder as 48 respostas**; o participante volta a poder responder |

---

## 8. Interface no navegador — 48/48

`npm run test:ui` — Playwright sobre Chromium, percorrendo a pré-visualização de
verdade: preenche a identificação, responde as **48 situações uma a uma**, chega
ao resultado, navega por todos os dashboards, opera a matriz de animais, expande
o glossário e abre a gestão de dados. **0 erros de JavaScript em todo o percurso.**

O script é `scripts/test-ui.mjs` e está no projeto — não é um teste avulso que
existiu uma vez. `npm run verificar:tudo` roda a suíte inteira mais este e a
compilação.

**8.1 · A marca (7 verificações).** O item 39 do prompt de redesign é uma
restrição, e restrição sem teste é promessa. Verifica-se que a marca é uma
`<img>` e não um lockup recriado em CSS; que o arquivo oficial **carrega de
fato** (`naturalWidth > 0`), de modo que apagar `public/marca/rota26@2x.png`
quebra o teste em vez de mostrar um ícone quebrado na tela; que a **proporção
479:385 se mantém** dentro de 1%; que a marca nunca fica **abaixo de 48px** de
altura; que **nenhum filtro, transform ou mix-blend-mode** foi aplicado sobre
ela; que o selo "Instrumento Piloto de Desenvolvimento Organizacional" está
presente — ele já sumiu uma vez numa reescrita de cabeçalho; e que os oito
`<symbol>` de animal existem **uma única vez** no documento.

**8.2 · Percurso completo (10).** Os campos de identificação têm `label`
associado; o botão começa desabilitado e habilita quando a identificação fica
válida; o questionário abre em "Situação 1 de 48" com quatro alternativas;
declara que não há alternativa certa ou errada e que a ordem é embaralhada; as 48
são respondidas uma a uma; o botão de resultado **só aparece com as 48
completas**; e o contador de salvamento incremental registra cada escolha.

**8.3 · Resultado individual (10).** A abertura escura com o animal em disco; os
**oito blocos**; "Sua maior correspondência simbólica" **e a ausência** de "você
é uma Raposa"; a declaração de que a metáfora não constitui diagnóstico; a
explicação de que a função auxiliar vem obrigatoriamente do par oposto; os três
cartões de Belbin e o gráfico dos nove papéis preservado; e as explicações
clicáveis — mais de 20 blocos `<details>`, com o conteúdo conferido depois de
abrir.

**8.4 · Dashboards (15).** As seis seções do dashboard de equipe; IDF e ICF com
leitura em texto, não só o número; o tratamento explícito de grupos com menos de
5 respondentes; os oito animais **inclusive os zerados**; "maior e menor
representação" e a **ausência** da palavra "lacuna"; o alternador
quantidade/percentual com `aria-pressed`, que **muda de fato** os valores da
matriz, totaliza 100% por linha em percentual e **restaura** os números ao
voltar; o glossário em blocos recolhíveis, com IDF e ICF por extenso e o alerta
de que Sentimento em Jung é função racional de julgamento, não emoção; e a
exportação em Excel na gestão de dados.

**8.5 · Limites, responsividade e console (6).** As declarações de que o
instrumento não serve para seleção, promoção ou desligamento e de que usa escores
internos; ausência de rolagem horizontal em viewport de 390px; a proporção da
marca preservada também no celular; e nenhum erro de JavaScript.

### 8.6 Dois defeitos reais encontrados por esta bateria

1. **Os oito `<symbol>` eram definidos duas vezes.** `views-gestao.tsx`
   renderizava `<DefinicoesAnimais />` na tela de Animais, além da definição já
   feita na raiz (`layout.tsx` na aplicação, `main.tsx` na pré-visualização).
   Dezesseis símbolos com oito IDs repetidos: HTML inválido. Visualmente
   inofensivo, porque `<use>` resolve o primeiro — o tipo de defeito que só um
   teste encontra. Removida a definição duplicada.

2. **Os campos de identificação não tinham `label` associado.** `<label>Nome
   completo</label>` sem `htmlFor`, e o `<input>` sem `id`: um leitor de tela
   anunciava "caixa de edição" sem dizer de quê. Foi o que fez o teste falhar ao
   tentar preencher o formulário pelo rótulo, como uma pessoa faria. Corrigido
   com `htmlFor`/`id`, mais `aria-invalid` e `aria-describedby` ligando a
   mensagem de erro ao campo, e `role="alert"` para que a mensagem seja anunciada
   quando aparece.

Nenhum dos dois afetava cálculo.

---

## 9. Como reproduzir

```bash
npm install
npm run verificar        # auditorias + 83 + 15 + 16 + 13 + 23 + regressão + typecheck
npm run test:ui          # gera a pré-visualização e roda as 48 do navegador
npm run build

# ou tudo de uma vez:
npm run verificar:tudo

# Ponta a ponta em PostgreSQL — o banco precisa ser NOVO a cada execução,
# porque o teste exercita cadastro, limpeza e reaplicação.
createdb rota26_teste
for f in 01_schema 02_policies 03_seed 05_migracao_v2 06_producao 07_papeis; do
  psql -d rota26_teste -f supabase/$f.sql
done
PGURL=postgres:///rota26_teste npx tsx scripts/test-producao.ts
```

Para PostgreSQL fora do Supabase, aplique antes `supabase/00_stub_auth_local.sql`,
que reproduz o mínimo do schema `auth`.

---

## 9.1 Glossário — 23/23

`npm run test:glossario` varre as fontes de verdade do instrumento e **exige
verbete** para cada código que chega à tela ou à planilha: os 8 perfis, as 4
funções, as 2 atitudes, os 6 eixos, as 10 capacidades, os 9 papéis de Belbin, os
índices coletivos e os termos técnicos. Se alguém acrescentar um item no futuro
e esquecer o glossário, o teste falha.

Verifica também a **honestidade** dos verbetes: que o limiar de 50 esteja
declarado como escolha e não como medição, que o escore relativo diga
explicitamente que não é percentil, que a exportação "anonimizada" seja chamada
de pseudonimização, e que as faixas de intensidade admitam a própria
simplificação.

---

## 10. Defeitos reais encontrados e corrigidos

Todos de apresentação, todos flagrados por teste automatizado, nenhum afetava
cálculo:

1. **`Card` descartava o conteúdo de `acao` quando não havia título.** O
   alternador quantidade/percentual da matriz de animais (item 58) não era
   renderizado. Corrigido: o cabeçalho do cartão passa a existir quando houver
   título, subtítulo **ou** ação.
2. **`.belcard` e `.dim` eram usados sem existir no CSS.** Os cartões de Belbin
   e as dez dimensões estavam sem estilo desde a versão anterior.
3. **Colisão entre `N` e `n` no glossário.** A busca por sigla normalizava para
   maiúsculas, e o verbete de "número de respondentes" sobrescrevia o de
   Intuição — o resultado individual exibiria a explicação errada na letra N.
   Corrigido com busca exata primeiro. Flagrado na primeira execução do teste de
   cobertura.
4. **Os oito `<symbol>` eram definidos duas vezes** — ver 8.6.
5. **Os campos de identificação não tinham `label` associado** — ver 8.6.
6. **`.abertura .figura` colapsava o SVG do animal para 0×0.** `aspect-ratio: 1`
   somado a padding percentual e `place-items: center` fazia `width: 100%`
   resolver em zero, e o bloco 1 do resultado abria sem a figura.
7. **Barra secundária ilegível** — `#C3B7A3` sobre trilho `#E3D9C8` lia como
   barra cheia. Escurecida para `#B29A79`.
8. **`.card + .card` aplicava margem também dentro de grid**, desalinhando o topo
   dos KPIs. Restringido a `:not(.grid) >`.

---

## 11. O que estes testes **não** cobrem

Sendo direto, porque isso importa mais do que a lista do que passou:

- **Validação psicométrica.** Nenhum teste aqui diz que o instrumento mede o que
  diz medir. Não há alfa de Cronbach, ômega, correlação item-total, análise
  fatorial nem teste-reteste. O banco guarda os dados no formato necessário —
  a análise depende de dados reais e ainda não foi feita.
- **Carga e concorrência.** Não houve teste de volume nem de acesso simultâneo.
- **Compatibilidade entre navegadores.** Verificado apenas em Chromium.
- **Acessibilidade auditada por pessoa.** Foram implementados foco visível,
  alternativa textual aos gráficos, contraste, navegação por teclado e respeito
  a `prefers-reduced-motion` — mas isso não substitui auditoria com leitor de
  tela e com usuários reais.
- **Segurança ofensiva.** O RLS foi verificado com três identidades legítimas;
  não houve teste de intrusão.
