# Inventário de classificação — item 4 do prompt-mestre

Feito **antes** de qualquer alteração, e com a baseline metodológica já congelada
(`baseline.json`, gerada por `npm run baseline`).

Legenda:

- **PRESERVAR** — não recebe nenhuma alteração.
- **AJUSTAR** — muda apenas a **apresentação**; o dado por trás continua igual.
- **ADICIONAR** — algo que não existia.
- **REMOVER SOMENTE DEMO** — sai o que era de demonstração; nada real é tocado.

---

## 1. Instrumento e metodologia — tudo PRESERVAR

| Item | Classificação | Verificação |
|---|---|---|
| As 48 questões e seus textos | **PRESERVAR** | `baseline.json` · `audit:itens` |
| As 192 alternativas e seus textos | **PRESERVAR** | `audit:itens` |
| Ordem e estrutura conceitual dos itens | **PRESERVAR** | `audit:itens` |
| Pesos (âncoras de peso 2) | **PRESERVAR** | `audit:itens` |
| Chave de pontuação Jung por alternativa | **PRESERVAR** | `audit:matriz` |
| Matriz de pontuação funcional (192 linhas) | **PRESERVAR** | `audit:matriz` |
| Regras de desempate D1 / D2 / D3 | **PRESERVAR** | `test:algoritmo` |
| Os 8 perfis junguianos | **PRESERVAR** | `regressao` |
| Perfil predominante e perfil secundário | **PRESERVAR** | `regressao` |
| Os 8 animais e a associação Jung × animal | **PRESERVAR** | `regressao` |
| Textos de cada animal, luz e sombra | **PRESERVAR** | inspeção de `profiles.ts` |
| Descrições profissionais existentes | **PRESERVAR** | inspeção de `profiles.ts` |
| E, I, T, F, S, N — brutos e relativos | **PRESERVAR** | `regressao` |
| Os seis eixos comportamentais | **PRESERVAR** | `regressao` |
| As dez capacidades funcionais | **PRESERVAR** | `regressao` |
| Escores e proximidades Belbin | **PRESERVAR** | `regressao` |
| Fórmula do IDF | **PRESERVAR** | `regressao` |
| Fórmula do ICF e limiar de portador | **PRESERVAR** | `regressao` |
| Complementaridade | **PRESERVAR** | `regressao` |
| Faixas de intensidade | **PRESERVAR** | `regressao` |
| Limite de amostra (n < 5) | **PRESERVAR** | `regressao` |
| Avisos metodológicos e linguagem não diagnóstica | **PRESERVAR** | `test:telas` |

> Nenhum arquivo de `src/data/` foi aberto para edição nesta etapa, salvo para
> **acrescentar** conteúdo interpretativo novo que não participa de cálculo.

---

## 2. Apresentação — AJUSTAR

| Item | Classificação | O que muda |
|---|---|---|
| Identidade visual | **AJUSTAR** | Rota26: tipografia, paleta, cards, botões, tabelas, estados |
| Título e metadados | **AJUSTAR** | "ROTA26 — Instrumento de Mapeamento da Diversidade e Complementaridade de Equipes" |
| Resultado individual | **AJUSTAR** | reorganizado nos 8 blocos do item 26; nenhuma informação retirada |
| Frase do animal | **AJUSTAR** | "Sua maior correspondência simbólica", nunca "Você é uma Raposa" |
| Apresentação de Belbin | **AJUSTAR** | escore vira escore **+** rótulo **+** cinco leituras; gráfico atual preservado |
| Dashboard da equipe | **AJUSTAR** | reordenado em Síntese → Composição → Diversidade → Cobertura → Interpretação → Ação |
| Menu do Master | **AJUSTAR** | dez entradas do item 68 |
| Gestão de dados | **AJUSTAR** | Exportação e Zona de Segurança visualmente separadas |
| Responsividade e acessibilidade | **AJUSTAR** | contraste, foco, teclado, rótulos, alternativa textual aos gráficos |

---

## 3. Novidades — ADICIONAR

| Item | Classificação | Observação |
|---|---|---|
| Composição simbólica da equipe (8 animais, quantidade e %) | **ADICIONAR** | inclui os zeros; soma validada contra o total |
| Matriz organizacional Equipe × Animal | **ADICIONAR** | alterna quantidade / percentual |
| Rotina única `distribuicaoAnimais()` | **ADICIONAR** | **a mesma** para dashboard e Excel (item 66) |
| Sinalizador de inconsistência da soma | **ADICIONAR** | item 56 |
| "Você dentro da sua equipe" ampliado | **ADICIONAR** | mesma função dominante, mesma atitude, posição relativa |
| "O que sua presença acrescenta" | **ADICIONAR** | usa dados já calculados; nenhuma classificação nova |
| Leitura executiva individual para o líder | **ADICIONAR** | distinta da devolutiva do participante |
| "Como liderar esta configuração" | **ADICIONAR** | recomendações de desenvolvimento, nunca de emprego |
| Três abas novas de animais no Excel | **ADICIONAR** | Composição, matriz, percentual |
| Baseline e teste de regressão | **ADICIONAR** | `baseline.json`, `npm run regressao` |
| Guia Técnico de Implantação para TI | **ADICIONAR** | Parte N |
| Manual do Administrador | **ADICIONAR** | Parte O |
| Dicionário de Dados e diagrama ER | **ADICIONAR** | itens 87 e 105 |
| Checklist de Go-Live | **ADICIONAR** | item 105 |
| Changelog e sugestões não implementadas | **ADICIONAR** | itens 106 e 107 |

---

## 4. Saída da demonstração — REMOVER SOMENTE DEMO

| Item | Classificação |
|---|---|
| "Você está na demonstração", "dados simulados", "demonstração navegável" | **REMOVER SOMENTE DEMO** |
| `master@demo` como autor de log e exportação | **REMOVER SOMENTE DEMO** |
| Geração automática de participantes fictícios em produção | **REMOVER SOMENTE DEMO** |
| Registros `is_demo = true` do banco de aplicação | **REMOVER SOMENTE DEMO** |

Já implementado na etapa anterior e **preservado** aqui: `APP_MODE`, trava do seed,
view de dados reais, limpeza DEMO com prévia/backup/confirmação, auditoria.

---

## 5. O que NÃO foi feito

Nenhuma alteração metodológica. As observações que surgiram durante o trabalho
estão em **`SUGESTOES_NAO_IMPLEMENTADAS.md`**, aguardando autorização — nenhuma
delas foi aplicada ao código.
