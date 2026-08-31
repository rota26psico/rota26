'use client';
/**
 * EXPORTAR A TELA EM PDF
 * ---------------------------------------------------------------------------
 * Usa a impressão do próprio navegador (`window.print()`), não uma biblioteca:
 * o que sai é exatamente o que está na tela, com os mesmos números, sem uma
 * segunda rota de renderização que pudesse divergir do painel. É o mesmo
 * caminho que o relatório integral da v2.0 especifica.
 *
 * O componente traz três coisas, e as duas últimas existem por causa do que um
 * PDF é: um arquivo que sai do sistema e circula sozinho.
 *
 *  1. o botão — que não se imprime;
 *  2. um cabeçalho só de impressão, com o que identifica o documento: o recorte,
 *     quem emitiu e quando. Sem isso, uma folha solta numa mesa não diz de que
 *     equipe é nem de quando;
 *  3. os limites declarados, repetidos no rodapé impresso. Na tela eles moram no
 *     rodapé da aplicação, que a folha de impressão esconde — e um relatório de
 *     equipe que circula sem dizer que não serve para seleção, promoção ou
 *     desligamento é exatamente o uso que este instrumento recusa.
 *
 * A data é preenchida depois da montagem, e não no servidor: renderizar "agora"
 * dos dois lados produziria textos diferentes e um aviso de hidratação.
 */
import { useEffect, useState } from 'react';

export function BotaoImprimir({ titulo, recorte, papel, children }: {
  titulo: string;
  /** O que este documento cobre — "Organização", um setor, uma equipe. */
  recorte: string;
  papel: 'MASTER' | 'ADMIN_SETOR';
  /** O conteúdo do painel. Envolver, em vez de só preceder, é o que garante que
      os limites saiam no FIM do documento e não logo abaixo do cabeçalho. */
  children: React.ReactNode;
}) {
  const [emitido, setEmitido] = useState('');
  useEffect(() => {
    setEmitido(new Date().toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' }));
  }, []);

  return (
    <>
      <div className="nao-imprime barra-exportar">
        <button className="btn btn-sec" onClick={() => window.print()}>
          Exportar em PDF
        </button>
      </div>

      {/* Só aparece no papel. Na tela, o cabeçalho da aplicação já diz tudo isto. */}
      <div className="so-impressao">
        <div className="si-marca">ROTA26 · {titulo}</div>
        <div className="si-linha">
          <span><b>Recorte:</b> {recorte}</span>
          <span><b>Emitido em:</b> {emitido || '—'}</span>
          <span><b>Acesso:</b> {papel === 'MASTER' ? 'Administrador Master' : 'Administrador de setor'}</span>
        </div>
      </div>

      {children}

      <div className="so-impressao si-limites">
        <b>Limites de uso.</b> Documento de gestão, de acesso restrito. O instrumento está em fase
        piloto e <b>não</b> constitui diagnóstico psicológico. Os valores são escores relativos
        internos, não percentis populacionais. <b>Não utilizar</b> para seleção, promoção,
        transferência ou desligamento, nem como decisão automatizada sobre pessoas. As leituras são
        hipóteses de gestão, para verificar na convivência com a equipe.
      </div>
    </>
  );
}
