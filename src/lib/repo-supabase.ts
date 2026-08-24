/**
 * CAMADA DE PERSISTÊNCIA — Supabase / PostgreSQL (v2.0)
 * ---------------------------------------------------------------------------
 * Mesma interface que a demo implementa em memória, de modo que telas e
 * cálculos são idênticos nos dois ambientes.
 *
 * Garantias implementadas aqui:
 *  * item 53 — cada resposta é gravada individualmente, com a chave de
 *    pontuação congelada;
 *  * item 54 — `retomarAvaliacao` devolve o que já foi salvo, permitindo
 *    continuar do ponto exato;
 *  * item 55 — a conclusão relê as respostas do banco, recalcula no servidor e
 *    só então marca CONCLUIDA. O cliente nunca envia o resultado;
 *  * item 74 — dashboards e Excel leem da mesma view `vw_resultados`.
 */
import { supabaseBrowser, supabaseServer, supabaseAdmin } from './supabase';
import { ALTERNATIVA_POR_ID, VERSAO_INSTRUMENTO } from '../data/questions';
import { VERSAO_MATRIZ } from '../data/scoringMatrix';
import { avaliar, type Resposta, type ResultadoIndividual } from './scoring';
import type { MembroAgregado } from './aggregate';
import type { RegistroExport } from './excel';

/* Reexportados para que os importadores antigos sigam funcionando. */
export { supabaseBrowser, supabaseServer, supabaseAdmin };

type DB = ReturnType<typeof supabaseBrowser>;

/* ── Cadastro ────────────────────────────────────────────────────────────── */

export async function listarSetores(db: DB): Promise<{ id: string; codigo: string }[]> {
  const { data, error } = await db.from('setores').select('id,codigo').eq('ativo', true).order('codigo');
  if (error) throw error;
  return data ?? [];
}

/**
 * Item 18 — validação do cadastro. A matrícula é o identificador
 * organizacional único: é ela que evita respostas sem participante e
 * participante sem setor.
 */
export function validarCadastro(d: { nome: string; matricula: string; setor: string }): string | null {
  if (d.nome.trim().length < 3) return 'Informe o nome completo (nome e sobrenome).';
  if (!d.matricula.trim()) return 'A matrícula é obrigatória — é ela que identifica você na organização.';
  if (!/^[A-Za-z0-9._-]{2,32}$/.test(d.matricula.trim()))
    return 'Matrícula inválida. Use apenas letras, números, ponto, hífen ou sublinhado (2 a 32 caracteres).';
  if (!d.setor) return 'Selecione o setor ou contrato.';
  return null;
}

/**
 * SESSÃO DE QUEM RESPONDE.
 *
 * Toda policy de RLS é `to authenticated`: sem sessão, nem a lista de setores
 * carrega — a tela mostrava "Nenhum setor" e o percurso não começava. Quem
 * responde não tem conta nominal, então a sessão é anônima: o Supabase emite um
 * usuário com `role: authenticated` e `is_anonymous: true`, o que faz
 * `auth.uid()` existir e todas as policias valerem sem alteração nenhuma. Ele
 * não está em `administradores`, logo `papel()` devolve PARTICIPANTE e os
 * dashboards respondem "acesso restrito".
 *
 * Sessão existente NÃO é tocada: quem já entrou pelo /entrar continua sendo
 * ele mesmo — inclusive o administrador que também vai responder.
 */
export async function garantirSessao(db: DB) {
  const { data } = await db.auth.getSession();
  if (data.session) return;
  const { error } = await db.auth.signInAnonymously();
  if (error) throw new Error(`Não foi possível iniciar a sessão. Recarregue a página. (${error.message})`);
}

export async function garantirParticipante(db: DB, d: { nome: string; matricula: string; setorId: string; email?: string }) {
  const { data: user } = await db.auth.getUser();
  // `is_demo` e `is_test` ficam de fora de propósito: as duas colunas já nascem
  // `false` por padrão, e escrevê-las aqui faria o UPDATE do upsert esbarrar na
  // trava de 07_papeis.sql, que reserva a marcação à administração.
  const { data, error } = await db.from('participantes').upsert({
    user_id: user.user?.id ?? null, nome: d.nome.trim(), matricula: d.matricula.trim(),
    setor_id: d.setorId, email: d.email ?? user.user?.email ?? null
  }, { onConflict: 'matricula' }).select('id,nome,setor_id').single();
  if (error) throw error;
  return data.id as string;
}

/* ── Avaliação: início, retomada, gravação e conclusão ───────────────────── */

export type SituacaoAvaliacao = 'nova' | 'em_andamento' | 'concluida';

export interface EstadoAvaliacao {
  situacao: SituacaoAvaliacao;
  avaliacaoId: string | null;
  respostasSalvas: Record<string, string>;   // questaoId → alternativaId
  respondidas: number;
  concluida: boolean;
  resultado?: ResultadoIndividual;
  concluidaEm?: string;
}

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
    .select('id,status,concluida_em')
    .eq('participante_id', participanteId)
    .is('arquivada_em', null)
    .order('iniciada_em', { ascending: false });
  if (error) throw error;

  const concluida = existentes?.find(a => a.status === 'CONCLUIDA');
  if (concluida) {
    const r = await recalcular(db, concluida.id);
    return {
      situacao: 'concluida', avaliacaoId: concluida.id, respostasSalvas: {}, respondidas: 48,
      concluida: true, resultado: r, concluidaEm: concluida.concluida_em as string
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
      respondidas: Object.keys(salvas).length, concluida: false
    };
  }

  return { situacao: 'nova', avaliacaoId: null, respostasSalvas: {}, respondidas: 0, concluida: false };
}

/** Abre a avaliação. Chamado apenas depois da confirmação do participante. */
export async function abrirAvaliacao(db: DB, participanteId: string): Promise<string> {
  const { data, error } = await db.from('avaliacoes')
    .insert({ participante_id: participanteId, versao_codigo: VERSAO_INSTRUMENTO, is_demo: false, is_test: false })
    .select('id').single();
  if (error) throw error;
  return data.id as string;
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
    regra_desempate: r.regraDesempate, ordem_funcoes: r.ordemFuncoes, algoritmo_versao: r.versao
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
const VIEW_REAIS = 'vw_resultados';
const VIEW_TODOS = 'vw_resultados_todos';

const COLUNAS = 'avaliacao_id,participante_id,nome,matricula,email,setor,concluida_em,is_demo,is_test,eh_administrador,' +
  'atitude,funcao_dominante,perfil_principal,perfil_secundario,jung,eixos,capacidades,belbin';

export async function carregarMembros(db: DB, setor?: string): Promise<MembroAgregado[]> {
  let q = db.from(VIEW_REAIS).select(COLUNAS);
  if (setor) q = q.eq('setor', setor);
  const { data, error } = await q;
  if (error) throw error;
  return (data ?? []).map((x: any) => ({
    id: x.participante_id, setor: x.setor,
    perfil: x.perfil_principal, perfilSecundario: x.perfil_secundario,
    atitude: x.atitude, funcaoDominante: x.funcao_dominante,
    jung: x.jung, eixos: x.eixos, capacidades: x.capacidades, belbin: x.belbin
  }));
}

export async function carregarPessoas(db: DB, setor?: string) {
  let q = db.from(VIEW_REAIS)
    .select('nome,matricula,setor,perfil_principal,perfil_secundario,concluida_em,avaliacao_id,is_demo,eh_administrador')
    .order('nome');
  if (setor) q = q.eq('setor', setor);
  const { data, error } = await q;
  if (error) throw error;
  return (data ?? []).map((x: any) => ({
    nome: x.nome, matricula: x.matricula, setor: x.setor,
    perfil: x.perfil_principal, secundario: x.perfil_secundario,
    data: x.concluida_em, status: 'concluída', demo: x.is_demo,
    ehAdministrador: !!x.eh_administrador, avaliacaoId: x.avaliacao_id
  }));
}

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

/**
 * Itens 5 e 24 — os quatro números do topo, contados no banco, já sem DEMO e
 * sem registros de validação. Um erro de consulta PROPAGA: a tela distingue
 * "ninguém respondeu ainda" de "não consegui consultar". Zero nunca é o
 * disfarce de uma falha.
 */
export async function resumoOrganizacional(db: DB) {
  const { data, error } = await db.rpc('resumo_organizacional');
  if (error) throw error;
  const l = (data as any[])?.[0] ?? { participantes: 0, concluidas: 0, incompletas: 0, setores: 0 };
  return {
    totalParticipantes: l.participantes ?? 0, concluidas: l.concluidas ?? 0,
    incompletas: l.incompletas ?? 0, setores: l.setores ?? 0
  };
}

/* ── Gestão de dados (itens 61 a 65) ─────────────────────────────────────── */

export async function previaReset(db: DB, escopo: string, param?: string) {
  const { data, error } = await db.rpc('previa_reset', { p_escopo: escopo, p_param: param ?? null });
  if (error) throw error;
  const l = (data as any[])?.[0] ?? { participantes: 0, avaliacoes: 0, respostas: 0 };
  return { participantes: l.participantes, avaliacoes: l.avaliacoes, respostas: l.respostas };
}

export async function executarReset(db: DB, escopo: string, param?: string, confirmacao?: string) {
  const { data, error } = await db.rpc('executar_reset', {
    p_escopo: escopo, p_param: param ?? null, p_confirmacao: confirmacao ?? null
  });
  if (error) throw error;
  return data as number;
}

export async function registrarExportacao(db: DB, tipo: string, registros: number, detalhe: object = {}) {
  await db.rpc('registrar_exportacao', { p_tipo: tipo, p_registros: registros, p_detalhe: detalhe });
}

/* ══════════════ PRODUÇÃO — itens 6 a 13, 17, 27, 32, 33 e 34 ════════════ */

/** Item 27 — auditoria genérica. Silenciosa: um log que falha não derruba a operação. */
export async function registrarEvento(
  db: DB, acao: string, escopo?: string, parametro?: string, registros = 0, detalhe: object = {}
) {
  try {
    await db.rpc('registrar_evento', {
      p_acao: acao, p_escopo: escopo ?? null, p_parametro: parametro ?? null,
      p_registros: registros, p_detalhe: detalhe
    });
  } catch { /* auditoria nunca bloqueia o fluxo do participante */ }
}

export interface ContagemDemo { participantes: number; avaliacoes: number; testes: number }

/** Quantos registros DEMO ainda existem — governa a exibição dos botões. */
export async function contagemDemo(db: DB): Promise<ContagemDemo> {
  const { data, error } = await db.rpc('contagem_demo');
  if (error) throw error;
  const l = (data as any[])?.[0] ?? {};
  return { participantes: l.participantes ?? 0, avaliacoes: l.avaliacoes ?? 0, testes: l.testes ?? 0 };
}

export interface PreviaDemo {
  participantes: number; avaliacoes: number; respostas: number;
  resultados: number; reaisPreservados: number;
}

/** Item 7 — a janela de confirmação. Não altera nada. */
export async function previaLimpezaDemo(db: DB): Promise<PreviaDemo> {
  const { data, error } = await db.rpc('previa_limpeza_demo');
  if (error) throw error;
  const l = (data as any[])?.[0] ?? {};
  return {
    participantes: l.participantes ?? 0, avaliacoes: l.avaliacoes ?? 0,
    respostas: l.respostas ?? 0, resultados: l.resultados ?? 0,
    reaisPreservados: l.reais_preservados ?? 0
  };
}

export const CONFIRMACAO_LIMPEZA_DEMO = 'LIMPAR DADOS DEMO';

/** Itens 9 a 12 — exige a confirmação literal; o banco recusa qualquer outra. */
export async function limparDadosDemo(db: DB, confirmacao: string) {
  const { data, error } = await db.rpc('limpar_dados_demo', { p_confirmacao: confirmacao });
  if (error) throw error;
  const l = (data as any[])?.[0] ?? {};
  return {
    participantes: l.participantes_removidos ?? 0, avaliacoes: l.avaliacoes_removidas ?? 0,
    respostas: l.respostas_removidas ?? 0, restantes: l.restantes ?? 0
  };
}

/** Item 34 — remove o registro único de validação controlada. */
export async function limparDadosTeste(db: DB): Promise<number> {
  const { data, error } = await db.rpc('limpar_dados_teste');
  if (error) throw error;
  return (data as number) ?? 0;
}

/** Item 17 — único caminho autorizado para responder de novo. */
export async function liberarReaplicacao(db: DB, matricula: string): Promise<number> {
  const { data, error } = await db.rpc('liberar_reaplicacao', { p_matricula: matricula });
  if (error) throw error;
  return (data as number) ?? 0;
}

export interface ItemProntidao { chave: string; item: string; ok: boolean; detalhe: string }

/** Itens 32 e 33 — a parte do checklist que o banco consegue provar sozinho. */
export async function verificarProntidao(db: DB): Promise<ItemProntidao[]> {
  const { data, error } = await db.rpc('verificar_prontidao');
  if (error) throw error;
  return (data as any[]) ?? [];
}

export async function carregarLogs(db: DB) {
  const { data, error } = await db.from('logs_auditoria')
    .select('criado_em,usuario_email,acao,escopo,parametro,registros_afetados')
    .order('criado_em', { ascending: false }).limit(200);
  if (error) throw error;
  return (data ?? []).map((l: any) => ({
    data: l.criado_em, usuario: l.usuario_email ?? '—', acao: l.acao,
    detalhe: `${l.escopo ?? ''}${l.parametro ? ' · ' + l.parametro : ''} · ${l.registros_afetados} registro(s)`
  }));
}

/** Mesmo cuidado de `sessao.papel()`: sem o filtro por `user_id`, o MASTER
 *  recebe todas as linhas e `maybeSingle()` o rebaixa a participante. */
export async function papelDoUsuario(db: DB): Promise<'MASTER' | 'ADMIN_SETOR' | 'PARTICIPANTE'> {
  const { data: sessao } = await db.auth.getUser();
  const uid = sessao.user?.id;
  if (!uid) return 'PARTICIPANTE';
  const { data } = await db.from('administradores').select('papel').eq('user_id', uid).maybeSingle();
  return (data?.papel as any) ?? 'PARTICIPANTE';
}
