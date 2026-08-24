/**
 * Renderização das telas novas do fluxo do participante (itens 16, 17 e 18).
 * Confere o TEXTO que a pessoa realmente lê, não a intenção do código.
 */
import { renderToStaticMarkup } from 'react-dom/server';
import React from 'react';
import { TelaRetomada, TelaJaConcluida, TelaIdentificacao } from '../src/components/views-participante';
import { Vazio, ErroConsulta, Checklist } from '../src/components/ui';

let ok = 0, falhas = 0;
const t = (n: string, c: boolean, d = '') => {
  if (c) { ok++; console.log(`  ✓ ${n}${d ? ' — ' + d : ''}`); }
  else { falhas++; console.log(`  ✗ ${n}${d ? ' — ' + d : ''}`); }
};
const texto = (el: React.ReactElement) =>
  renderToStaticMarkup(el).replace(/<[^>]+>/g, ' ').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ');

console.log('── Item 16 · retomada de avaliação');
const ret = texto(<TelaRetomada nome="Ana" respondidas={20} proxima={21} onContinuar={() => {}} />);
t('Pergunta antes de retomar', /Encontramos uma avaliação em andamento/.test(ret));
t('Oferece continuar', /Deseja continuar de onde parou/.test(ret));
t('Mostra o progresso salvo', /20 de 48/.test(ret));
t('Informa a primeira questão sem resposta', /situação 21/.test(ret));

console.log('\n── Item 17 · participante que já concluiu');
const ja = texto(<TelaJaConcluida nome="Ana" data="2026-08-20T12:00:00Z" podeVerResultado onVerResultado={() => {}} />);
t('Diz que a avaliação já foi concluída', /Sua avaliação já foi concluída/.test(ja));
t('Oferece ver o resultado', /Ver meu resultado/.test(ja));
t('Explica quando é possível reaplicar',
  /Administrador Master libera a reaplicação/.test(ja) && /arquivada/.test(ja) && /nova versão do instrumento/.test(ja));
const semRes = texto(<TelaJaConcluida nome="Ana" />);
t('Não oferece o resultado quando não autorizado', !/Ver meu resultado/.test(semRes));

console.log('\n── Item 18 · validação do cadastro');
const ident = texto(<TelaIdentificacao setores={['MEC', 'MS']} onIniciar={() => {}} />);
t('Os três campos obrigatórios estão na tela',
  /Nome completo/.test(ident) && /Matrícula/.test(ident) && /Setor \/ Contrato/.test(ident));
t('Botão começa desabilitado', /disabled/.test(renderToStaticMarkup(
  <TelaIdentificacao setores={['MEC']} onIniciar={() => {}} />)));

console.log('\n── Itens 23 e 24 · vazio não é erro, erro não é zero');
const v = texto(<Vazio />);
t('Estado vazio diz que aguarda respostas', /Aguardando respostas para gerar análise/.test(v));
const e = texto(<ErroConsulta detalhe="connection refused" />);
t('Erro de consulta é declarado como erro', /Não foi possível consultar os dados/.test(e));
t('Erro deixa claro que não significa base vazia', /não.{0,3} significa que não existam registros/.test(e));
t('Erro mostra o detalhe técnico', /connection refused/.test(e));

console.log('\n── Item 33 · checklist');
const ch = texto(<Checklist itens={[
  { item: '48 questões carregadas', ok: true, detalhe: '48 na versão ativa' },
  { item: 'Dados demo = 0', ok: false, detalhe: '96 registros' }
]} />);
t('Checklist marca aprovado e reprovado', /✓/.test(ch) && /✗/.test(ch), ch.trim().slice(0, 90));

console.log(`\n RESULTADO: ${ok} aprovadas, ${falhas} falhas.`);
process.exit(falhas ? 1 : 0);
