import 'server-only';
/**
 * PERSISTÊNCIA QUE PRECISA DA CHAVE DE PONTUAÇÃO
 * ---------------------------------------------------------------------------
 * Tudo aqui depende de `scoring.ts` ou de `questions.server.ts` — isto é, do
 * gabarito. Por isso o módulo é `server-only`: se um componente de cliente o
 * importar, o `next build` falha.
 *
 * POR QUE ESTAS CINCO FUNÇÕES SAÍRAM DE `repo-supabase.ts`: aquele módulo é
 * importado por telas de cliente (o percurso do participante, o painel nominal,
 * a gestão de dados). Enquanto `gravarResposta` lia `ALTERNATIVA_POR_ID` e
 * `concluirAvaliacao` chamava `avaliar()` de lá, a chave das 192 alternativas ia
 * junto para o bundle — e foi medido: 191 delas eram baixáveis do endereço
 * publicado, sem login.
 *
 * O que mudou de fato: as mesmas funções, no mesmo formato, executando no
 * SERVIDOR. A sessão continua sendo a do próprio participante (`db()` de
 * `sessao.ts` carrega os cookies dele), então o RLS decide exatamente o que
 * decidia antes — nenhuma política foi afrouxada, e a chave de serviço não
 * entra nisto.
 *
 * Item 53 preservado: a chave de pontuação continua sendo congelada na linha de
 * `respostas` no instante da escolha. Só que agora quem a lê é o servidor.
 * Item 19 preservado: a conclusão é transacional e o status só vira CONCLUIDA
 * depois que todos os derivados estão gravados e conferidos.
 */
import { ALTERNATIVA_POR_ID } from '../data/questions.server';
import { VERSAO_INSTRUMENTO } from '../data/questions';
import { avaliar } from './scoring';
import type { Resposta, ResultadoIndividual } from './resultado';
import type { RegistroExport } from './excel';
import { supabaseBrowser } from './supabase';
import { VERSAO_MATRIZ } from '../data/matriz';
import { registrarEvento, VIEW_REAIS, VIEW_TODOS, COLUNAS, type EstadoAvaliacao } from './repo-supabase';

type DB = ReturnType<typeof supabaseBrowser>;

/**
 * Itens 16 e 17 — CONSULTA, não cria nada.
 *
 * Três situações, tratadas de forma diferente e explícita:
 *   'concluida'    → a matrícula já respondeu. Não se abre outra avaliação em
 *                    silêncio; o participante vê a tela "sua avaliação já foi
 *                    concluída". Só o Master libera a reaplicação.
 *   'em_andamento' → existe avaliação salva. A aplicação PERGUNTA se deseja
 *                    continuar; não retoma sozinha.
 *   'nova'         → nenhuma avaliação. A gravação só começa quando o
 *                    participante confirmar o início.
 */
export async function consultarAvaliacao(db: DB, participanteId: string): Promise<EstadoAvaliacao> {
  const { data: existentes, error } = await db.from('avaliacoes')
    .select('id,status,concluida_em,numero_aplicacao')
    .eq('participante_id', participanteId)
    .is('arquivada_em', null)
    .order('iniciada_em', { ascending: false });
  if (error) throw error;

  /* `existentes` já vem da mais recente para a mais antiga, então o `find`
     devolve a última concluída — a mesma que `vw_resultados` considera vigente.
     É a leitura que a pessoa deve reencontrar ao voltar. */
  const concluida = existentes?.find(a => a.status === 'CONCLUIDA');
  if (concluida) {
    const r = await recalcular(db, concluida.id);
    return {
      situacao: 'concluida', avaliacaoId: concluida.id, respostasSalvas: {}, respondidas: 48,
      concluida: true, resultado: r, concluidaEm: concluida.concluida_em as string,
      aplicacao: (concluida as any).numero_aplicacao ?? 1
    };
  }

  const emAndamento = existentes?.find(a => a.status === 'EM_ANDAMENTO');
  if (emAndamento) {
    const { data: rs, error: e } = await db.from('respostas')
      .select('questao_codigo,alternativa_codigo').eq('avaliacao_id', emAndamento.id);
    if (e) throw e;
    const salvas = Object.fromEntries((rs ?? []).map(x => [x.questao_codigo as string, x.alternativa_codigo as string]));
    return {
      situacao: 'em_andamento', avaliacaoId: emAndamento.id, respostasSalvas: salvas,
      respondidas: Object.keys(salvas).length, concluida: false,
      aplicacao: (emAndamento as any).numero_aplicacao ?? 1
    };
  }

  return { situacao: 'nova', avaliacaoId: null, respostasSalvas: {}, respondidas: 0, concluida: false };
}



/** Item 53 — grava a resposta bruta com a chave congelada. Idempotente. */
export async function gravarResposta(db: DB, avaliacaoId: string, r: Resposta, posicaoExibida?: number) {
  const alt = ALTERNATIVA_POR_ID[r.alternativaId];
  if (!alt || alt.questaoId !== r.questaoId) throw new Error('Resposta inválida: a alternativa não pertence à questão.');
  const { error } = await db.from('respostas').upsert({
    avaliacao_id: avaliacaoId, questao_codigo: r.questaoId, alternativa_codigo: r.alternativaId,
    jung: alt.jung, eixo: alt.eixo, peso: alt.peso, posicao_exibida: posicaoExibida ?? null
  }, { onConflict: 'avaliacao_id,questao_codigo' });
  if (error) throw error;
}



/**
 * Item 19 — FINALIZAÇÃO TRANSACIONAL.
 *
 * A avaliação NÃO é marcada como concluída se qualquer etapa crítica falhar.
 * A ordem é a do item 19 e cada passo é verificado antes do seguinte; o status
 * CONCLUIDA é o ÚLTIMO ato, depois que todos os derivados já estão gravados.
 * Se algo quebrar no meio, a avaliação permanece EM_ANDAMENTO e o participante
 * pode retomar — nunca fica num estado meio-concluído.
 *
 * O resultado é calculado no servidor a partir das respostas relidas do banco.
 * O cliente jamais envia o resultado.
 */
export async function concluirAvaliacao(db: DB, avaliacaoId: string): Promise<ResultadoIndividual> {
  const passo = async (nome: string, fn: () => Promise<{ error: any } | void>) => {
    let out: any;
    try { out = await fn(); } catch (e: any) { throw new Error(`Falha em "${nome}": ${e?.message ?? e}`); }
    if (out && out.error) throw new Error(`Falha em "${nome}": ${out.error.message ?? out.error}`);
    return out;
  };

  // 1 e 2 — verificar as 48 respostas E a persistência delas no banco.
  const { data: brutas, error: e1 } = await db.from('respostas')
    .select('questao_codigo,alternativa_codigo').eq('avaliacao_id', avaliacaoId);
  if (e1) throw new Error(`Não foi possível ler as respostas gravadas: ${e1.message}`);

  const respostas: Resposta[] = (brutas ?? []).map(b => ({
    questaoId: b.questao_codigo as string, alternativaId: b.alternativa_codigo as string
  }));

  // 3 a 9 — Jung, perfil principal, perfil secundário, animal, eixos,
  // capacidades e proximidades Belbin. Tudo determinístico, em código.
  const r = avaliar(respostas);
  if (!r.completo || respostas.length !== 48) {
    throw new Error(
      `Avaliação incompleta: ${r.respostasValidas} de 48 respostas gravadas no banco. ` +
      'A avaliação continua em andamento e você pode retomar de onde parou.'
    );
  }

  // 10 — salvar os resultados das duas trilhas.
  await passo('gravar escores', () => db.from('escores')
    .upsert({ avaliacao_id: avaliacaoId, bruto: r.escores.bruto, relativo: r.escores.relativo }) as any);

  await passo('gravar resultado junguiano', () => db.from('resultados').upsert({
    avaliacao_id: avaliacaoId, atitude: r.atitude, funcao_dominante: r.funcaoDominante,
    funcao_auxiliar: r.funcaoAuxiliar, funcao_menos_representada: r.funcaoMenosRepresentada,
    funcao_inferior: r.funcaoInferior, perfil_principal: r.perfilPrincipal,
    perfil_secundario: r.perfilSecundario, empate_funcoes: r.empateFuncoes,
    regra_desempate: r.regraDesempate, empate_auxiliar: r.empateAuxiliar,
    regra_desempate_auxiliar: r.regraDesempateAuxiliar,
    ordem_funcoes: r.ordemFuncoes, algoritmo_versao: r.versaoAlgoritmo
  }) as any);

  await passo('gravar resultado funcional', () => db.from('resultados_funcionais').upsert({
    avaliacao_id: avaliacaoId,
    eixos_bruto: r.escores.eixos.bruto, eixos: r.escores.eixos.relativo,
    cap_bruto: r.funcional.capacidadesBruto, capacidades: r.funcional.capacidades,
    ordem_capacidades: r.capacidadesOrdenadas.map(c => c.id), versao_matriz: VERSAO_MATRIZ
  }) as any);

  const t = r.top3Belbin;
  await passo('gravar proximidades Belbin', () => db.from('resultados_belbin').upsert({
    avaliacao_id: avaliacaoId, bruto: r.funcional.belbinBruto, relativo: r.funcional.belbin,
    top1: t[0].id, top1_valor: t[0].valor, top1_intensidade: t[0].intensidade,
    top2: t[1].id, top2_valor: t[1].valor, top2_intensidade: t[1].intensidade,
    top3: t[2].id, top3_valor: t[2].valor, top3_intensidade: t[2].intensidade,
    versao_matriz: VERSAO_MATRIZ
  }) as any);

  // Conferência antes de fechar: os quatro derivados existem mesmo no banco?
  const conf = await Promise.all([
    db.from('escores').select('avaliacao_id').eq('avaliacao_id', avaliacaoId).maybeSingle(),
    db.from('resultados').select('avaliacao_id').eq('avaliacao_id', avaliacaoId).maybeSingle(),
    db.from('resultados_funcionais').select('avaliacao_id').eq('avaliacao_id', avaliacaoId).maybeSingle(),
    db.from('resultados_belbin').select('avaliacao_id').eq('avaliacao_id', avaliacaoId).maybeSingle()
  ]);
  if (conf.some(c => !c.data)) {
    throw new Error('Os resultados não foram confirmados no banco. A avaliação permanece em andamento — tente finalizar novamente.');
  }

  // 11 — só agora a avaliação é fechada.
  await passo('finalizar a avaliação', () => db.from('avaliacoes')
    .update({ status: 'CONCLUIDA', concluida_em: new Date().toISOString() })
    .eq('id', avaliacaoId).eq('status', 'EM_ANDAMENTO') as any);

  // 12 — auditoria da conclusão (item 27).
  await registrarEvento(db, 'CONCLUSAO', 'avaliacao', avaliacaoId, 48,
    { perfil: r.perfilPrincipal, secundario: r.perfilSecundario, versao: r.versao });

  return r;
}



/** Recalcula a partir das respostas brutas — prova de reprodutibilidade. */
export async function recalcular(db: DB, avaliacaoId: string): Promise<ResultadoIndividual> {
  const { data } = await db.from('respostas')
    .select('questao_codigo,alternativa_codigo').eq('avaliacao_id', avaliacaoId);
  return avaliar((data ?? []).map(b => ({
    questaoId: b.questao_codigo as string, alternativaId: b.alternativa_codigo as string
  })));
}

/* ── Leitura para dashboards e exportação (fonte única — item 74) ────────── */

/**
 * REGRA DO ITEM 5, IMPLEMENTADA NO BANCO.
 *
 * `vw_resultados` já exclui, na definição da própria view, tudo que tenha
 * is_demo ou is_test. Nenhum indicador — participantes, IDF, ICF, distribuição
 * Jung, animais, perfis, funções, atitudes, capacidades, Belbin, comparação
 * entre equipes, leitura executiva, relatórios — consegue enxergar dado
 * fictício, mesmo que uma tela futura esqueça de filtrar.
 *
 * `vw_resultados_todos` existe apenas para o backup dos dados DEMO antes da
 * limpeza (item 8) e é usada só quando explicitamente pedida.
 */



/**
 * Monta os registros para o Excel a partir da mesma view + respostas brutas.
 * Item 25 — o padrão é `escopo: 'reais'`. O escopo 'demo' existe apenas para o
 * backup do item 8 e só é alcançável pelo Master enquanto houver dado DEMO.
 */
export async function carregarParaExport(
  db: DB, setor?: string, escopo: 'reais' | 'demo' = 'reais'
): Promise<RegistroExport[]> {
  let q = db.from(escopo === 'demo' ? VIEW_TODOS : VIEW_REAIS).select(COLUNAS);
  if (escopo === 'demo') q = q.eq('is_demo', true);
  if (setor) q = q.eq('setor', setor);
  const { data, error } = await q;
  if (error) throw error;
  const linhas = data ?? [];
  const ids = linhas.map((x: any) => x.avaliacao_id);
  const { data: respostas } = await db.from('respostas')
    .select('avaliacao_id,questao_codigo,alternativa_codigo,jung,eixo,peso').in('avaliacao_id', ids);

  const porAval: Record<string, any[]> = {};
  for (const r of respostas ?? []) (porAval[r.avaliacao_id as string] ||= []).push(r);

  return linhas.map((x: any) => {
    const rs = (porAval[x.avaliacao_id] ?? []).map(r => ({
      questaoId: r.questao_codigo, alternativaId: r.alternativa_codigo,
      jung: r.jung, eixo: r.eixo, peso: r.peso
    }));
    return {
      participanteId: x.participante_id, nome: x.nome, matricula: x.matricula,
      setor: x.setor, email: x.email ?? '', concluidaEm: x.concluida_em,
      versao: VERSAO_INSTRUMENTO, isDemo: !!x.is_demo, ehAdministrador: !!x.eh_administrador,
      respostas: rs,
      resultado: avaliar(rs.map(r => ({ questaoId: r.questaoId, alternativaId: r.alternativaId })))
    };
  });
}
