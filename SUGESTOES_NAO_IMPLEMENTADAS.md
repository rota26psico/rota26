# SUGESTÕES DE MELHORIA NÃO IMPLEMENTADAS

Item 107 do prompt-mestre. **Nada aqui foi aplicado ao código.** São observações
levantadas durante o trabalho, registradas para decisão sua.

Para cada uma: o que foi identificado, por que pareceu uma melhoria, que impacto
teria e **quais resultados mudariam**.

---

## 1. O IDF não distingue diversidade de perfis de diversidade de escores

**O que identifiquei.** O IDF pesa 25% entropia dos perfis, 25% entropia das
funções e 50% dispersão dos escores. Como perfil e função dominante são
derivados dos mesmos escores, os três componentes compartilham informação: uma
equipe pode ganhar pontos duas vezes pela mesma variação.

**Por que seria uma melhoria.** Um índice com componentes menos correlacionados
seria mais fácil de interpretar — hoje é difícil dizer o que exatamente um IDF de
84,2 significa além de "alto".

**Impacto.** Reponderação ou substituição por uma medida de dispersão
multivariada.

**O que mudaria.** O IDF de **todas** as equipes e da organização, em qualquer
período já coletado. As faixas (baixa/moderada/alta) precisariam ser
recalibradas. Comparações históricas ficariam inválidas sem recálculo.

**Risco de não fazer nada.** Baixo. O índice é declarado como parâmetro interno
exploratório e nunca é usado como nota.

---

## 2. O limiar de portador (50) é um número redondo, não um ponto de corte medido

**O que identifiquei.** `LIMIAR_PORTADOR = 50` define quem "tem" uma capacidade
e alimenta o ICF, a complementaridade e a contagem de portadores. O valor é
plausível, mas não veio de dados: é a metade da escala.

**Por que seria uma melhoria.** Com dados reais acumulados, o corte poderia sair
da distribuição observada (por exemplo, o tercil superior) em vez de um número
escolhido a priori.

**Impacto.** O ICF, a complementaridade, a contagem de portadores e a leitura
"onde existe complementaridade" mudariam em todas as equipes.

**O que mudaria.** ICF de toda a base. Capacidades hoje classificadas como
cobertas poderiam passar a descobertas e vice-versa.

**Recomendação.** Não mexer agora. Faz sentido revisar **depois** do piloto,
junto com a análise psicométrica, e com o corte documentado como mudança de
versão do instrumento.

---

## 3. A Raposa (Ne) foi introduzida para completar a matriz

**O que identifiquei.** Sete animais vêm do volume 1 de *Os animais e a psique*;
a Raposa foi acrescentada para cobrir a Intuição Extrovertida, que não tinha
portador no livro. Isso está documentado e é honesto, mas a base textual dela é
mais fina que a dos outros sete — o livro a trata como agente em três capítulos,
não como capítulo próprio.

**Por que mencionar.** Se em algum momento o volume 2 for incorporado ao
referencial, a Raposa passaria a ter tratamento equivalente ao dos demais.

**Impacto.** Apenas de **conteúdo textual** do animal. Nenhum escore mudaria.

**O que mudaria.** Os textos de luz, sombra e livro do perfil `Ne`. Perfil,
animal e escores permaneceriam idênticos.

---

## 4. As faixas de intensidade são uniformes para dimensões de escala diferente

**O que identifiquei.** `intensidade()` usa os mesmos cortes (60 / 45 / 30 / 18)
para capacidades, papéis de Belbin e escores junguianos. Como os máximos
obteníveis diferem entre dimensões, "alta" não significa a mesma coisa em todas.

**Por que seria uma melhoria.** Rótulos por dimensão tornariam a leitura mais
comparável entre seções do relatório.

**Impacto.** Os rótulos textuais mudariam em muitos relatórios individuais.
Os **números** não.

**O que mudaria.** Palavras como "alta" / "moderada" em capacidades e Belbin.
Perfil, animal, IDF e ICF ficariam iguais.

---

## 5. Ordem fixa das alternativas na chave, embaralhada na tela

**O que identifiquei.** A exibição é embaralhada por uma semente derivada da
matrícula. Isso é bom contra viés de posição, mas significa que duas pessoas
veem ordens diferentes — o que dificulta análise de efeito de ordem no futuro.

**Por que mencionar.** A coluna `posicao_exibida` já é gravada, então o dado
para essa análise **existe**. É só uma observação de que ele ainda não é usado.

**Impacto.** Nenhum, se nada for feito.

**O que mudaria.** Nada. Esta é uma sugestão de **análise**, não de alteração.

---

## 6. "Perfil secundário" pode ser lido como um segundo tipo

**O que identifiquei.** O perfil secundário é a mesma atitude somada à função
auxiliar. Alguns leitores tendem a interpretá-lo como "meu segundo tipo", o que
não é o conceito junguiano.

**Por que seria uma melhoria.** Um rótulo como "configuração auxiliar" reduziria
a leitura equivocada.

**Impacto.** Puramente de nomenclatura na interface e no Excel.

**O que mudaria.** O **rótulo**. O valor calculado seria exatamente o mesmo.
Mesmo assim não implementei: mudar nome de coluna do Excel quebraria planilhas
que a organização já tenha montado sobre exportações anteriores.

---

## 7. Não há teste-reteste, e o instrumento não é normatizado

**O que identifiquei.** É a limitação mais séria do conjunto, e já está declarada
na interface e no rodapé. O banco guarda os dados no formato necessário para
alfa de Cronbach, ômega de McDonald, correlação item-total, análise fatorial e
teste-reteste — mas nenhuma dessas análises foi feita.

**Por que mencionar.** Enquanto isso não for feito, o instrumento **não pode**
ser chamado de validado, e nenhuma decisão sobre pessoas deve se apoiar nele.

**Impacto.** Uma análise psicométrica pode indicar itens a revisar ou remover.

**O que mudaria.** Potencialmente a estrutura do instrumento — que é exatamente
por isso que precisa de decisão explícita e nova versão, nunca de alteração
silenciosa.

**Esta é a única da lista que eu recomendaria priorizar**, e ela depende de
dados reais, não de código.
