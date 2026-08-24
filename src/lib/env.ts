/**
 * AMBIENTE DA APLICAÇÃO (itens 1, 2, 3, 13 e 31)
 * ---------------------------------------------------------------------------
 * Dois ambientes explícitos: `production` e `development`.
 *
 * O PADRÃO É PRODUCTION. Essa escolha é deliberada: uma variável de ambiente
 * esquecida, um deploy novo ou um `.env` ausente resultam em produção, não em
 * demonstração. O único jeito de ligar qualquer gerador de dados fictícios é
 * declarar as DUAS variáveis abaixo, de propósito.
 *
 * Em produção nada de fictício é criado — nem no primeiro acesso, nem ao
 * atualizar a página, nem em nenhuma rota (item 13).
 */

export type AppMode = 'production' | 'development';

export const APP_MODE: AppMode =
  (process.env.NEXT_PUBLIC_APP_MODE ?? '').trim().toLowerCase() === 'development'
    ? 'development'
    : 'production';

export const EM_PRODUCAO = APP_MODE === 'production';

/**
 * Item 13 — trava do seed. Só é verdadeira em desenvolvimento E com a variável
 * declarada explicitamente. Em produção é sempre falsa, sem exceção possível.
 */
export const SEED_DEMO_PERMITIDO =
  !EM_PRODUCAO && (process.env.PERMITIR_SEED_DEMO ?? '').trim() === 'true';

/** Guarda de execução: qualquer gerador de dados fictícios chama isto antes. */
export function exigirSeedPermitido(origem: string) {
  if (!SEED_DEMO_PERMITIDO) {
    throw new Error(
      `Geração de dados de demonstração bloqueada em ${origem}: APP_MODE=${APP_MODE}. ` +
      'Dados fictícios só podem ser criados em desenvolvimento, com PERMITIR_SEED_DEMO=true.'
    );
  }
}

/* ── Identidade da aplicação (itens 1 e 2) ────────────────────────────────── */

export const MARCA = {
  marca: 'ROTA26',
  titulo: 'Mapeamento da Diversidade Psicológica, Comportamental e Funcional das Equipes',
  tituloCurto: 'ROTA26 — Mapeamento da Diversidade e Complementaridade de Equipes',
  subtitulo: 'Instrumento de Mapeamento da Diversidade e Complementaridade de Equipes',
  selo: 'Instrumento Piloto de Desenvolvimento Organizacional',
  descricao:
    'ROTA26 — Instrumento organizacional de mapeamento da diversidade e da complementaridade de equipes, ' +
    'referenciado na tipologia psicológica de C. G. Jung, no simbolismo animal de Os animais e a psique ' +
    'e na teoria dos papéis de equipe de Meredith Belbin.'
} as const;

/**
 * Item 31 — indicador discreto de ambiente, exibido apenas ao Administrador
 * Master. O participante não vê.
 */
export const ROTULO_AMBIENTE = EM_PRODUCAO ? 'AMBIENTE: PRODUÇÃO' : 'AMBIENTE: DESENVOLVIMENTO';
