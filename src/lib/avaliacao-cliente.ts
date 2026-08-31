/**
 * AS QUATRO OPERAÇÕES DO PERCURSO, VISTAS DO NAVEGADOR
 * ---------------------------------------------------------------------------
 * Invólucros finos sobre `POST /api/avaliacao`. Existem para que as telas
 * continuem lendo como antes — `await concluirAvaliacao(id)` — enquanto o
 * cálculo mudou de lado.
 *
 * Nada aqui sabe a chave de pontuação. É exatamente esse o ponto: este módulo
 * pode ir para o bundle sem levar o gabarito junto.
 */
import type { ResultadoIndividual, Resposta } from './resultado';
import type { EstadoAvaliacao } from './repo-supabase';

async function chamar<T>(corpo: object): Promise<T> {
  const r = await fetch('/api/avaliacao', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(corpo)
  });
  const dados = await r.json().catch(() => ({ erro: 'Resposta ilegível do servidor.' }));
  // A mensagem do servidor é preservada: a tela distingue avaliação incompleta
  // de falha de gravação, e o participante precisa ler qual das duas foi.
  if (!r.ok) throw new Error(dados?.erro ?? `Falha na comunicação (HTTP ${r.status}).`);
  return dados as T;
}

export const consultarAvaliacao = (participanteId: string) =>
  chamar<EstadoAvaliacao>({ acao: 'consultar', participanteId });

export const gravarResposta = (avaliacaoId: string, r: Resposta, posicaoExibida?: number) =>
  chamar<{ ok: true }>({
    acao: 'responder', avaliacaoId,
    questaoId: r.questaoId, alternativaId: r.alternativaId, posicaoExibida
  });

export const concluirAvaliacao = (avaliacaoId: string) =>
  chamar<ResultadoIndividual>({ acao: 'concluir', avaliacaoId });

export const recalcular = (avaliacaoId: string) =>
  chamar<ResultadoIndividual>({ acao: 'recalcular', avaliacaoId });
