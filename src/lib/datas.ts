/**
 * FORMATAÇÃO DE DATA — POR QUE EXISTE, E POR QUE MORA AQUI
 * ---------------------------------------------------------------------------
 * `toLocaleDateString` sem fuso usa o fuso de QUEM EXECUTA. Estas telas são
 * renderizadas no servidor e hidratadas no navegador, e os dois discordam: o
 * servidor roda em UTC (container), o navegador em America/Sao_Paulo. Depois
 * das 21h a mesma avaliação sai como 03/09 no HTML do servidor e 02/09 no
 * cliente — medido em `/dashboard/pessoas` —, e o React não trata isso como
 * detalhe: derruba a hidratação e re-renderiza a página inteira no cliente.
 *
 * Fixar o fuso resolve as duas coisas de uma vez. Os dois lados produzem o mesmo
 * texto, e o texto passa a ser o horário local de quem usa o instrumento, não o
 * do servidor onde ele está hospedado.
 *
 * MORA EM `lib/` E NÃO EM `ui.tsx` porque `ui.tsx` começa com `'use client'`:
 * um Server Component que importe uma função de lá recebe uma referência de
 * cliente, não a função — e quebra em tempo de execução com "is not a function".
 * Este módulo não tem diretiva, então serve aos dois lados.
 *
 * Devolve travessão para valor ausente, em vez de "Invalid Date": data que não
 * existe é informação, data quebrada é defeito.
 */
const FUSO = 'America/Sao_Paulo';

export const dataBR = (v: string | null | undefined) =>
  v ? new Date(v).toLocaleDateString('pt-BR', { timeZone: FUSO }) : '—';

export const dataHoraBR = (v: string | null | undefined) =>
  v ? new Date(v).toLocaleString('pt-BR', { timeZone: FUSO, dateStyle: 'short', timeStyle: 'short' }) : '—';
