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

---

## 8. Revisitar o resultado só funciona no navegador que respondeu

**O que identifiquei.** O vínculo entre pessoa e resultado é o `user_id` da
sessão anônima criada quando ela respondeu. `participantes_atualiza`
(`supabase/02_policies.sql`) exige `user_id = auth.uid()` para atualizar o
cadastro, e o upsert de `garantirParticipante` casa por **matrícula**. As duas
regras juntas produzem dois efeitos, e vale separar:

*O efeito bom, verificado contra PostgreSQL real com RLS ligado:* digitar a
matrícula de um colega em outra sessão **não** dá acesso ao resultado dele. O
UPDATE é recusado pelo banco. A proteção não depende da interface.

*O efeito ruim:* quem respondeu no computador da recepção e depois abre no
próprio, quem limpou os dados do navegador, quem trocou de celular — todos caem
na mesma recusa. Até esta entrega, liam
`new row violates row-level security policy for table "participantes"`, que não
diz nada a ninguém. Isso **foi corrigido**: a mensagem agora explica o que
aconteceu, por que a recusa existe e a quem recorrer. O que **não** foi feito é
dar a essa pessoa um caminho próprio de volta.

**Por que não foi resolvido agora.** Qualquer caminho de volta é uma decisão de
autenticação, e ela muda o fluxo de entrada de todo mundo — inclusive de quem
ainda não respondeu. Merece decisão própria, não carona numa entrega sobre
revisitar resultado.

**Três saídas avaliadas.**

*Código de acesso pessoal.* Na conclusão, o participante recebe um código curto,
mostrado na tela e impresso no rodapé do PDF; com matrícula **e** código, o
vínculo pode ser transferido para a sessão nova. Não depende de SMTP nem de
e-mail cadastrado (hoje `participantes.email` é opcional) e funciona no cenário
presencial de computador compartilhado. Custo: uma coluna, uma tela, e um
caminho de reemissão pelo Master para quem perder o código.

*Link por e-mail.* O participante informa a matrícula e recebe um link via
Supabase Auth. Mais forte e sem nada para guardar. Custo maior: exige SMTP
configurado, e-mail obrigatório para todo mundo, e troca a sessão anônima por
conta nominal — o que muda a premissa "responder não exige cadastro", declarada
na abertura.

*Emissão pelo Master.* Nenhuma mudança de fluxo: o participante procura a área
responsável, que abre `/dashboard/pessoas/<avaliação>` e imprime o relatório. Já
funciona hoje, e é o que a mensagem de erro passou a instruir. Custo zero de
código, custo operacional recorrente.

**Impacto se nada mais for feito.** Nenhum número muda. O resultado continua
acessível — pelo mesmo navegador, ou pela administração. O que fica é o atrito
para quem troca de dispositivo.

**Recomendação.** Decidir antes de ampliar o uso para além do piloto. Das três, o
código de acesso é a que cabe no desenho atual sem mudar a premissa de entrada.

---

## 9. "Anterior" permite trocar a resposta, mas o banco recusa a troca

**O que identifiquei.** `respostas` tem policy de SELECT e de INSERT, e
**nenhuma de UPDATE** — a decisão está escrita no próprio SQL
(`supabase/02_policies.sql`): *"respostas brutas são imutáveis após gravadas"*.
Só que `gravarResposta` (`src/lib/repo-servidor.ts`) grava com
`upsert ... onConflict: 'avaliacao_id,questao_codigo'`, e a tela oferece o botão
**Anterior** com as alternativas clicáveis.

Resultado: quem volta uma situação e escolhe outra alternativa recebe
*"Sua resposta não foi salva: new row violates row-level security policy (USING
expression) for table respostas"*. Reproduzido no navegador contra a stack local,
e confirmado na estrutura — `select policyname, cmd from pg_policies where
tablename='respostas'` devolve apenas SELECT e INSERT.

**Por que é sério.** Não é só uma mensagem feia. A tela passa a mostrar a
alternativa nova enquanto o banco mantém a antiga, e é o banco que alimenta o
resultado. A pessoa acredita ter corrigido uma resposta que não foi corrigida.

**Por que não corrigi.** Porque as duas metades são decisões declaradas e
opostas, e escolher entre elas é decisão de metodologia, não de implementação:

*Manter a imutabilidade e ajustar a tela.* A resposta bruta continua sendo o
registro do que a pessoa escolheu **no instante em que escolheu** — que é o que
sustenta a reprodutibilidade e a análise psicométrica. A tela deixaria de aceitar
a troca: "Anterior" passaria a ser só releitura, com as alternativas
desabilitadas e uma frase explicando por quê. Nenhum escore muda.

*Permitir a correção.* Uma policy de UPDATE restrita à própria avaliação e ao
status `EM_ANDAMENTO` — o mesmo recorte que `respostas_insere` já usa. Custa o
abandono da imutabilidade declarada, e convém guardar a resposta anterior em vez
de sobrescrevê-la, senão a auditoria perde a informação de que houve troca.
Escores de quem trocar de resposta mudam — corretamente, mas mudam.

**Impacto se nada for feito.** Nenhum número muda. O que fica é a discrepância
entre o que a tela deixa fazer e o que o banco aceita, e o risco de alguém
concluir a avaliação convencido de ter corrigido uma resposta.

**Recomendação.** Decidir antes da próxima aplicação. A primeira saída é a que
preserva o desenho atual e custa menos.

