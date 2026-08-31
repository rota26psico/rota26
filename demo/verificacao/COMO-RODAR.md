# Como rodar as verificações da demo

## Requisitos

- Node 20+ — nesta máquina, `nvm use 20`
- Chromium do Playwright: `npx playwright install chromium`

Os caminhos absolutos que vinham no pacote (`/home/claude/app/...`) foram
substituídos por resolução a partir do próprio arquivo, então os scripts rodam
de onde estiverem dentro do projeto. O Playwright já é `devDependency` daqui.

O Chromium é procurado em `/opt/pw-browsers/chromium` — mesma convenção que o
`scripts/test-ui.mjs` deste projeto já usava. Se o seu estiver em outro lugar:

```bash
CHROMIUM_PATH=~/.cache/ms-playwright/chromium-*/chrome-linux/chrome node verifica-demo.mjs
```

## Rodando

Copie `ROTA26-demo-v2.html` para esta pasta (ou rode os scripts a partir da pasta
onde o HTML estiver — eles o resolvem a partir do diretório atual):

```bash
node verifica-demo.mjs        # 18 checagens
node verifica-dashboard.mjs   # 72 checagens
```

## O que cada um verifica

**`verifica-demo.mjs`** — a parte que mais importa: ele gera 4.000 conjuntos de
respostas com o motor TypeScript real (`src/lib/v2/apuracao.ts`, rodando sob
`--conditions=react-server`), roda os mesmos 4.000 dentro da demo, e compara
campo a campo. Se divergirem, a demo está mostrando um instrumento que não existe.
Depois percorre as 48 questões clicando na tela, passa pelo desempate quando ele
aparece, e confere o relatório individual.

> Esta parte precisa do projeto Next.js disponível, porque roda o motor real.
> Sem ele, o restante do script (percurso clicado, relatório, responsividade)
> ainda funciona se você comentar a seção 1.

**`verifica-dashboard.mjs`** — identificação obrigatória e cascata
contrato → setor → líder; isolamento do participante; presença das seções do
painel; as quatro classificações; ausência de nomes técnicos de papéis de equipe;
ausência das palavras "melhor", "pior", "adequado" e "inadequado"; filtros;
amostra mínima de cinco; console limpo; e ausência de rolagem horizontal em 390px.
Cobre também o relatório integral: as catorze seções exigidas, as nove
contribuições, a leitura por índice contra a linha de base, os cinco domínios, a
declaração de limites e a mesma amostra mínima do painel.
