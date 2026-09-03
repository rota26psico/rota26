/**
 * RECÁLCULO DOS DERIVADOS COM O ALGORITMO VIGENTE — só o MASTER
 * ---------------------------------------------------------------------------
 * POR QUE PRECISA EXISTIR. As telas do participante e o painel nominal
 * recalculam o resultado a partir das respostas brutas toda vez que abrem, de
 * modo que sempre exibem o algoritmo atual. Mas os DASHBOARDS leem
 * `vw_resultados`, que se apoia na tabela `resultados`, gravada uma única vez
 * no momento da conclusão. Quando o algoritmo muda — como mudou em
 * `v1.1-desempate-auxiliar`, que passou a declarar o empate da função auxiliar —
 * a tabela fica com o valor antigo e o painel discorda da devolutiva sem que
 * nada esteja quebrado.
 *
 * O QUE NÃO MUDA. As `respostas` são intocadas: são o dado bruto, imutáveis por
 * política, e é delas que tudo é reproduzido. Este recálculo não inventa nada —
 * roda `avaliar()` sobre as mesmas respostas e regrava o derivado.
 *
 * AUTORIZAÇÃO EM DUAS CAMADAS. A rota confere `papel() === 'MASTER'`, e a
 * gravação usa a sessão do próprio administrador: a policy
 * `resultados_atualiza_master` (09_aplicacoes.sql) só libera UPDATE em
 * `resultados` para `eh_master()`. A chave de serviço NÃO entra aqui — se
 * entrasse, o servidor poderia o que o usuário não pode, e a garantia mudaria
 * de lugar. É a mesma escolha de `/api/avaliacao`.
 *
 * CONFIRMAÇÃO LITERAL E PRÉVIA, como em toda operação de escrita em massa deste
 * projeto: `previa` conta e nunca altera nada; `aplicar` exige a frase exata.
 */
import { NextRequest } from 'next/server';
import { db, papel } from '@/lib/sessao';
import { avaliar } from '@/lib/scoring';
import { registrarEvento } from '@/lib/repo-supabase';
import { VERSAO_ALGORITMO } from '@/data/questions';
import { VERSAO_MATRIZ } from '@/data/matriz';

export const dynamic = 'force-dynamic';

/* A mesma frase exportada por `views-gestao` para a tela. Não pode ser
   exportada daqui: um route handler do Next só aceita exports conhecidos. */
const CONFIRMACAO_RECALCULO = 'RECALCULAR RESULTADOS';

const erro = (mensagem: string, status: number) => Response.json({ erro: mensagem }, { status });

type Corpo =
  | { acao: 'previa' }
  | { acao: 'aplicar'; confirmacao: string };

interface Divergencia {
  avaliacaoId: string;
  campo: string;
  de: string | null;
  para: string | null;
}

/**
 * Relê as respostas de cada avaliação concluída, recalcula e compara com o que
 * está gravado. Devolve o que MUDARIA — sem escrever nada.
 */
async function levantar(s: any) {
  const { data: linhas, error } = await s.from('resultados')
    .select('avaliacao_id,funcao_auxiliar,perfil_secundario,funcao_dominante,perfil_principal,algoritmo_versao');
  if (error) throw error;

  const ids = (linhas ?? []).map((x: any) => x.avaliacao_id);
  if (ids.length === 0) return { total: 0, divergencias: [] as Divergencia[], recalculados: [] as any[] };

  /* Uma consulta só para todas as respostas: 48 linhas por avaliação, e uma
     ida ao banco por avaliação seria lenta o suficiente para estourar o tempo
     da rota numa base de algumas centenas de pessoas. */
  const { data: brutas, error: e2 } = await s.from('respostas')
    .select('avaliacao_id,questao_codigo,alternativa_codigo').in('avaliacao_id', ids);
  if (e2) throw e2;

  const porAvaliacao = new Map<string, { questaoId: string; alternativaId: string }[]>();
  for (const b of brutas ?? []) {
    const lista = porAvaliacao.get(b.avaliacao_id) ?? [];
    lista.push({ questaoId: b.questao_codigo, alternativaId: b.alternativa_codigo });
    porAvaliacao.set(b.avaliacao_id, lista);
  }

  const divergencias: Divergencia[] = [];
  const recalculados: any[] = [];

  for (const linha of linhas ?? []) {
    const respostas = porAvaliacao.get(linha.avaliacao_id) ?? [];
    // Avaliação sem as 48 respostas não é recalculável — e não deveria existir,
    // porque o gatilho do banco recusa CONCLUIDA antes disso. Se existir, é
    // pulada em silêncio em vez de gravar um resultado parcial por cima do bom.
    if (respostas.length === 0) continue;
    const r = avaliar(respostas);
    if (!r.completo) continue;

    const comparar = (campo: string, de: any, para: any) => {
      if (de !== para) divergencias.push({ avaliacaoId: linha.avaliacao_id, campo, de, para });
    };
    comparar('funcao_dominante', linha.funcao_dominante, r.funcaoDominante);
    comparar('perfil_principal', linha.perfil_principal, r.perfilPrincipal);
    comparar('funcao_auxiliar', linha.funcao_auxiliar, r.funcaoAuxiliar);
    comparar('perfil_secundario', linha.perfil_secundario, r.perfilSecundario);
    comparar('algoritmo_versao', linha.algoritmo_versao, r.versaoAlgoritmo);

    recalculados.push({ avaliacaoId: linha.avaliacao_id, r });
  }

  return { total: recalculados.length, divergencias, recalculados };
}

export async function POST(req: NextRequest) {
  if (await papel() !== 'MASTER')
    return erro('Apenas o Administrador Master pode recalcular resultados.', 403);

  let corpo: Corpo;
  try { corpo = await req.json(); } catch { return erro('Corpo inválido.', 400); }

  const s = db() as any;

  try {
    const { total, divergencias, recalculados } = await levantar(s);

    if (corpo.acao === 'previa') {
      const porCampo: Record<string, number> = {};
      for (const d of divergencias) porCampo[d.campo] = (porCampo[d.campo] ?? 0) + 1;
      const avaliacoesAfetadas = new Set(divergencias.map(d => d.avaliacaoId)).size;
      return Response.json({
        total, avaliacoesAfetadas, porCampo, algoritmo: VERSAO_ALGORITMO,
        exemplos: divergencias.slice(0, 20)
      });
    }

    if (corpo.acao !== 'aplicar') return erro('Ação desconhecida.', 400);
    if (corpo.confirmacao !== CONFIRMACAO_RECALCULO)
      return erro(`Confirmação incorreta. Digite exatamente: ${CONFIRMACAO_RECALCULO}`, 400);

    let gravados = 0;
    for (const { avaliacaoId, r } of recalculados) {
      const { error } = await s.from('resultados').update({
        atitude: r.atitude, funcao_dominante: r.funcaoDominante,
        funcao_auxiliar: r.funcaoAuxiliar, funcao_menos_representada: r.funcaoMenosRepresentada,
        funcao_inferior: r.funcaoInferior, perfil_principal: r.perfilPrincipal,
        perfil_secundario: r.perfilSecundario, empate_funcoes: r.empateFuncoes,
        regra_desempate: r.regraDesempate, empate_auxiliar: r.empateAuxiliar,
        regra_desempate_auxiliar: r.regraDesempateAuxiliar,
        ordem_funcoes: r.ordemFuncoes, algoritmo_versao: r.versaoAlgoritmo
      }).eq('avaliacao_id', avaliacaoId);
      // Uma falha isolada não deve abortar as demais, mas também não pode
      // passar despercebida: o total gravado é comparado com o total previsto.
      if (!error) gravados++;
    }

    await registrarEvento(s, 'RECALCULO', 'resultados', VERSAO_ALGORITMO, gravados, {
      algoritmo: VERSAO_ALGORITMO, matriz: VERSAO_MATRIZ,
      avaliacoesAfetadas: new Set(divergencias.map(d => d.avaliacaoId)).size
    });

    return Response.json({
      total, gravados,
      completo: gravados === total,
      avaliacoesAfetadas: new Set(divergencias.map(d => d.avaliacaoId)).size,
      algoritmo: VERSAO_ALGORITMO
    });
  } catch (e: any) {
    return erro(e?.message ?? String(e), 400);
  }
}
