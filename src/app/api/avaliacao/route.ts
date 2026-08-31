/**
 * O PERCURSO DO PARTICIPANTE, DO LADO DO SERVIDOR
 * ---------------------------------------------------------------------------
 * Estas quatro operações precisam da chave de pontuação, e a chave não pode
 * chegar ao navegador. Antes elas rodavam no cliente — `Fluxo.tsx` chamava
 * `concluirAvaliacao` direto, e por isso `src/data/questions.ts` inteiro,
 * com o polo junguiano e o eixo de cada alternativa, ia no bundle.
 *
 * O que NÃO mudou, e é o ponto: a sessão continua sendo a do próprio
 * participante. `db()` carrega os cookies dele, então o RLS decide o que sempre
 * decidiu — ninguém grava resposta em avaliação alheia, ninguém lê resultado de
 * terceiro. A chave de serviço não entra aqui; se entrasse, o servidor passaria
 * a poder o que o participante não pode, e a garantia mudaria de lugar.
 *
 * `recalcular` é a exceção de público: quem a chama é o painel nominal, e o RLS
 * de `respostas` já restringe a leitura ao Master. Um participante que a chame
 * para uma avaliação alheia recebe zero linhas e um erro, não um resultado.
 */
import { NextRequest } from 'next/server';
import { db } from '@/lib/sessao';
import {
  consultarAvaliacao, gravarResposta, concluirAvaliacao, recalcular
} from '@/lib/repo-servidor';

export const dynamic = 'force-dynamic';

type Corpo =
  | { acao: 'consultar'; participanteId: string }
  | { acao: 'responder'; avaliacaoId: string; questaoId: string; alternativaId: string; posicaoExibida?: number }
  | { acao: 'concluir'; avaliacaoId: string }
  | { acao: 'recalcular'; avaliacaoId: string };

const erro = (mensagem: string, status: number) =>
  Response.json({ erro: mensagem }, { status });

export async function POST(req: NextRequest) {
  let corpo: Corpo;
  try { corpo = await req.json(); } catch { return erro('Corpo inválido.', 400); }

  const s = db() as any;

  try {
    switch (corpo?.acao) {
      case 'consultar':
        if (!corpo.participanteId) return erro('participanteId ausente.', 400);
        return Response.json(await consultarAvaliacao(s, corpo.participanteId));

      case 'responder':
        if (!corpo.avaliacaoId || !corpo.questaoId || !corpo.alternativaId)
          return erro('Dados da resposta incompletos.', 400);
        await gravarResposta(s, corpo.avaliacaoId,
          { questaoId: corpo.questaoId, alternativaId: corpo.alternativaId }, corpo.posicaoExibida);
        return Response.json({ ok: true });

      case 'concluir':
        if (!corpo.avaliacaoId) return erro('avaliacaoId ausente.', 400);
        return Response.json(await concluirAvaliacao(s, corpo.avaliacaoId));

      case 'recalcular':
        if (!corpo.avaliacaoId) return erro('avaliacaoId ausente.', 400);
        return Response.json(await recalcular(s, corpo.avaliacaoId));

      default:
        return erro('Ação desconhecida.', 400);
    }
  } catch (e: any) {
    // A mensagem original importa: o fluxo do participante distingue "avaliação
    // incompleta" de "falha ao gravar", e a tela mostra qual foi.
    return erro(e?.message ?? String(e), 400);
  }
}
