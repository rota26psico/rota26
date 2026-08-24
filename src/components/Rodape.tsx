import { VERSAO_INSTRUMENTO } from '@/data/questions';
import { VERSAO_MATRIZ } from '@/data/scoringMatrix';
import { MARCA } from '@/lib/env';

/**
 * Item 35 — STATUS DO INSTRUMENTO.
 * ---------------------------------------------------------------------------
 * A aplicação está tecnicamente em produção. O INSTRUMENTO continua em fase
 * piloto. As duas coisas convivem, e é exatamente isso que este rodapé diz —
 * ele não é um aviso de "demonstração", é a declaração honesta do estágio de
 * validação científica.
 */
export function Rodape() {
  return (
    <footer className="rod">
      <div className="wrap">
        <div>
          <b>Referenciais</b><br />
          Tipologia psicológica de C. G. Jung &middot; simbolismo animal de <i>Os animais e a psique</i>, vol. 1
          (Ramos et al., Summus, 2005) &middot; teoria dos papéis de equipe de Meredith Belbin, conforme
          Miranda &amp; Vasconcelos, <i>Pretexto</i> v.21 n.3, FUMEC, 2020.
        </div>
        <div>
          <b>Status do instrumento</b><br />
          Instrumento em <b>fase piloto</b> para desenvolvimento organizacional.
          <b> Não constitui diagnóstico psicológico.</b> Os valores são <b>escores relativos internos</b>,
          não percentis populacionais — não há normatização populacional.
          Os animais são metáforas didáticas de comportamento.
          <b> Não utilizar isoladamente</b> para seleção, promoção, transferência ou desligamento,
          nem como decisão automatizada sobre pessoas.
        </div>
        <div>
          <b>{MARCA.subtitulo}</b><br />
          Versão do instrumento: {VERSAO_INSTRUMENTO} &middot; matriz de pontuação {VERSAO_MATRIZ}.<br />
          Perfil, animal, função, atitude, proximidades Belbin, IDF e ICF são calculados por
          algoritmo determinístico. Nenhum resultado é decidido por inteligência artificial.
        </div>
      </div>
    </footer>
  );
}
