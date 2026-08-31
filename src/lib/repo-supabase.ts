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
import { VERSAO_INSTRUMENTO } from '../data/questions';
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

/** Abre a avaliação. Chamado apenas depois da confirmação do participante. */
export async function abrirAvaliacao(db: DB, participanteId: string): Promise<string> {
  const { data, error } = await db.from('avaliacoes')
    .insert({ participante_id: participanteId, versao_codigo: VERSAO_INSTRUMENTO, is_demo: false, is_test: false })
    .select('id').single();
  if (error) throw error;
  return data.id as string;
}

export const VIEW_REAIS = 'vw_resultados';
export const VIEW_TODOS = 'vw_resultados_todos';

export const COLUNAS = 'avaliacao_id,participante_id,nome,matricula,email,setor,concluida_em,is_demo,is_test,eh_administrador,' +
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
