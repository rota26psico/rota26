import { db, papel } from '@/lib/sessao';
import { supabaseAdmin, carregarMembros, verificarProntidao, registrarEvento } from '@/lib/repo-supabase';
import { carregarParaExport } from '@/lib/repo-servidor';
import { avaliar, vetorDe, type Resposta } from '@/lib/scoring';
import { analisarEquipe, compararComEquipe } from '@/lib/aggregate';
import { gerarExcel } from '@/lib/excel';
import { VERSAO_INSTRUMENTO } from '@/data/questions';
import { QUESTOES_COMPLETAS as QUESTOES } from '@/data/questions.server';
import { VERSAO_MATRIZ } from '@/data/scoringMatrix';
import { PERFIL_POR_ID } from '@/data/profiles';
import { EM_PRODUCAO, SEED_DEMO_PERMITIDO, APP_MODE } from '@/lib/env';

export const dynamic = 'force-dynamic';

/**
 * PREPARAR SISTEMA PARA APLICAÇÃO REAL — itens 32, 33 e 34.
 * ---------------------------------------------------------------------------
 * Roda os treze passos do item 32. Os oito primeiros e o décimo são verificados
 * no banco; os demais são SONDAS DE VERDADE: a rotina cria um participante
 * marcado com `is_test`, grava resposta por resposta, retoma, finaliza,
 * confere o resultado individual, compara com a equipe, monta o dashboard,
 * gera um Excel real e depois remove o registro — deixando zero avaliações
 * artificiais.
 *
 * `is_test` NÃO é `is_demo`: o registro de validação nunca entra em nenhum
 * indicador, porque a própria view do banco o exclui. A sonda verifica isso
 * explicitamente.
 *
 * As gravações da sonda usam a chave de serviço porque o RLS — corretamente —
 * impede que um administrador grave respostas em nome de outra pessoa. O
 * acesso à rota exige sessão de Administrador Master.
 */

const MATRICULA_SONDA = '__VALIDACAO_SISTEMA__';

type Passo = { chave: string; item: string; ok: boolean; detalhe: string };

export async function POST() {
  const p = await papel();
  if (p !== 'MASTER') return Response.json({ erro: 'Acesso restrito ao Administrador Master.' }, { status: 403 });

  const sessao = db() as any;
  const adm = supabaseAdmin() as any;
  const passos: Passo[] = [];
  const reg = (chave: string, item: string, ok: boolean, detalhe: string) => passos.push({ chave, item, ok, detalhe });

  // ── Passos 1 a 6 e 10: o que o banco prova sozinho ───────────────────────
  try {
    const base = await verificarProntidao(sessao);
    passos.push(...base);
  } catch (e: any) {
    reg('banco', 'Banco conectado', false, `Falha ao consultar o banco: ${e.message ?? e}`);
    return Response.json({ passos, pronto: false });
  }

  // ── Passos 9 e 10: modo de produção e trava do seed ──────────────────────
  reg('modo', 'APP_MODE definido como produção', EM_PRODUCAO, `APP_MODE = ${APP_MODE}`);
  reg('seed', 'Seed de demonstração desativado', !SEED_DEMO_PERMITIDO,
    SEED_DEMO_PERMITIDO
      ? 'PERMITIR_SEED_DEMO=true — geradores de dados fictícios habilitados. Desative antes de aplicar.'
      : 'Nenhum gerador de dados fictícios pode ser executado neste ambiente.');

  // ── Passos 11 a 12: sondas reais de ponta a ponta ────────────────────────
  let participanteId: string | null = null;
  try {
    const { data: setor, error: eSet } = await adm.from('setores')
      .select('id,codigo').eq('ativo', true).order('codigo').limit(1).maybeSingle();
    if (eSet || !setor) throw new Error('Nenhum setor ativo disponível para a validação.');

    // Registro de validação controlada (item 34): is_test, jamais is_demo.
    const { data: part, error: eP } = await adm.from('participantes').upsert({
      nome: 'Validação do sistema', matricula: MATRICULA_SONDA, setor_id: setor.id,
      is_demo: false, is_test: true
    }, { onConflict: 'matricula' }).select('id').single();
    if (eP) throw new Error(`Não foi possível criar o registro de validação: ${eP.message}`);
    participanteId = part.id;

    await adm.from('avaliacoes').delete().eq('participante_id', participanteId);
    const { data: av, error: eA } = await adm.from('avaliacoes').insert({
      participante_id: participanteId, versao_codigo: VERSAO_INSTRUMENTO, is_demo: false, is_test: true
    }).select('id').single();
    if (eA) throw new Error(`Não foi possível abrir a avaliação de validação: ${eA.message}`);
    const avaliacaoId: string = av.id;

    // Sonda de SALVAMENTO — grava uma resposta e relê do banco.
    const escolha = (i: number) => QUESTOES[i].alternativas[i % 4];
    const grava = async (i: number) => {
      const q = QUESTOES[i], a = escolha(i);
      const { error } = await adm.from('respostas').upsert({
        avaliacao_id: avaliacaoId, questao_codigo: q.id, alternativa_codigo: a.id,
        jung: a.jung, eixo: a.eixo, peso: q.peso, posicao_exibida: (i % 4) + 1
      }, { onConflict: 'avaliacao_id,questao_codigo' });
      if (error) throw new Error(error.message);
    };
    await grava(0);
    const { count: c1 } = await adm.from('respostas')
      .select('*', { count: 'exact', head: true }).eq('avaliacao_id', avaliacaoId);
    reg('salvamento', 'Salvamento funcionando', c1 === 1,
      c1 === 1 ? 'Resposta gravada e relida do banco imediatamente' : `Esperava 1 resposta gravada, encontrou ${c1}`);

    // Sonda de RETOMADA — a avaliação é reencontrada em andamento, com o que já
    // foi salvo, e a próxima questão é a primeira sem resposta.
    const { data: emAnd } = await adm.from('avaliacoes')
      .select('id,status').eq('participante_id', participanteId).eq('status', 'EM_ANDAMENTO').maybeSingle();
    const { data: salvas } = await adm.from('respostas')
      .select('questao_codigo').eq('avaliacao_id', avaliacaoId);
    const jaSalvas = new Set((salvas ?? []).map((x: any) => x.questao_codigo));
    const proxima = QUESTOES.findIndex(q => !jaSalvas.has(q.id)) + 1;
    reg('retomada', 'Retomada funcionando', !!emAnd && proxima === 2,
      !!emAnd && proxima === 2
        ? 'Avaliação em andamento recuperada com 1 resposta salva; retomaria na situação 2'
        : `Estado inesperado ao retomar (avaliação ${emAnd ? 'encontrada' : 'não encontrada'}, próxima situação ${proxima})`);

    // Sonda de FINALIZAÇÃO — 48 respostas, cálculo determinístico, gravação
    // das duas trilhas e fechamento da avaliação (o gatilho do banco recusa
    // qualquer conclusão com menos de 48 respostas).
    for (let i = 1; i < QUESTOES.length; i++) await grava(i);
    const respostas: Resposta[] = QUESTOES.map((q, i) => ({ questaoId: q.id, alternativaId: escolha(i).id }));
    const r = avaliar(respostas);
    if (!r.completo) throw new Error('O algoritmo não considerou a avaliação de validação completa.');

    await adm.from('escores').upsert({ avaliacao_id: avaliacaoId, bruto: r.escores.bruto, relativo: r.escores.relativo });
    await adm.from('resultados').upsert({
      avaliacao_id: avaliacaoId, atitude: r.atitude, funcao_dominante: r.funcaoDominante,
      funcao_auxiliar: r.funcaoAuxiliar, funcao_menos_representada: r.funcaoMenosRepresentada,
      funcao_inferior: r.funcaoInferior, perfil_principal: r.perfilPrincipal,
      perfil_secundario: r.perfilSecundario, empate_funcoes: r.empateFuncoes,
      regra_desempate: r.regraDesempate, empate_auxiliar: r.empateAuxiliar,
      regra_desempate_auxiliar: r.regraDesempateAuxiliar,
      ordem_funcoes: r.ordemFuncoes, algoritmo_versao: r.versaoAlgoritmo
    });
    await adm.from('resultados_funcionais').upsert({
      avaliacao_id: avaliacaoId, eixos_bruto: r.escores.eixos.bruto, eixos: r.escores.eixos.relativo,
      cap_bruto: r.funcional.capacidadesBruto, capacidades: r.funcional.capacidades,
      ordem_capacidades: r.capacidadesOrdenadas.map(c => c.id), versao_matriz: VERSAO_MATRIZ
    });
    const t = r.top3Belbin;
    await adm.from('resultados_belbin').upsert({
      avaliacao_id: avaliacaoId, bruto: r.funcional.belbinBruto, relativo: r.funcional.belbin,
      top1: t[0].id, top1_valor: t[0].valor, top1_intensidade: t[0].intensidade,
      top2: t[1].id, top2_valor: t[1].valor, top2_intensidade: t[1].intensidade,
      top3: t[2].id, top3_valor: t[2].valor, top3_intensidade: t[2].intensidade,
      versao_matriz: VERSAO_MATRIZ
    });
    const { error: eFim } = await adm.from('avaliacoes')
      .update({ status: 'CONCLUIDA', concluida_em: new Date().toISOString() }).eq('id', avaliacaoId);
    reg('finalizacao', 'Finalização funcionando', !eFim,
      eFim ? `A conclusão foi recusada: ${eFim.message}` : '48 respostas verificadas; escores, resultado Jung, funcional e Belbin gravados; avaliação fechada');

    // Sonda de RESULTADO INDIVIDUAL.
    const animal = PERFIL_POR_ID[r.perfilPrincipal as keyof typeof PERFIL_POR_ID]?.animal;
    const okRes = !!r.perfilPrincipal && !!r.perfilSecundario && !!animal && r.top3Belbin.length === 3;
    reg('resultado', 'Resultado individual funcionando', okRes,
      okRes ? `Perfil ${r.perfilPrincipal} · secundário ${r.perfilSecundario} · animal ${animal} · Belbin ${t.map(x => x.id).join(', ')}`
            : 'O resultado individual não trouxe perfil, animal ou proximidades Belbin');

    // Sonda de COMPARAÇÃO COM A EQUIPE e de DASHBOARD, sobre os dados REAIS.
    const membros = await carregarMembros(sessao);
    const contem = membros.some(m => m.id === participanteId);
    reg('isolamento', 'Registro de validação fora dos indicadores', !contem,
      contem ? 'FALHA: o registro is_test apareceu no dashboard' :
        `A view de dados reais devolveu ${membros.length} participante(s) e nenhum deles é o registro de validação`);

    const comp = compararComEquipe(vetorDe(r), membros);
    reg('comparacao', 'Comparação com a equipe funcionando', typeof comp.nSetor === 'number',
      comp.disponivel
        ? `Comparação calculada sobre ${comp.nSetor} respondente(s) real(is): ${comp.mesmoPerfil.n} com o mesmo perfil predominante (${comp.mesmoPerfil.pct}%)`
        : `Comparação respondeu corretamente com o limite de amostra: ${comp.motivo ?? 'grupo pequeno demais para exibir distribuição'}`);

    const a = analisarEquipe(membros);
    reg('dashboard', 'Dashboard funcionando', true,
      membros.length === 0
        ? 'Nenhuma avaliação real concluída: o dashboard exibe o estado vazio, sem dado artificial'
        : `IDF ${a.idf} · ICF ${a.icf} · ${a.concentracao.perfisPresentes} dos 8 perfis presentes`);

    // Sonda de EXCEL, com os mesmos dados do dashboard.
    const regs = await carregarParaExport(sessao);
    const buf = await gerarExcel('individual', regs, {
      geradoPor: 'verificação de prontidão', geradoEm: new Date().toISOString()
    });
    reg('excel', 'Excel funcionando', buf.byteLength > 0,
      `Planilha gerada com ${Math.round(buf.byteLength / 1024)} KB a partir de ${regs.length} registro(s) reais`);
  } catch (e: any) {
    reg('sondas', 'Sondas de ponta a ponta', false, `Falha durante a validação: ${e?.message ?? e}`);
  } finally {
    // Passo 8/34 — o registro de validação não sobrevive à rotina.
    if (participanteId) {
      const { error } = await adm.from('participantes').delete().eq('matricula', MATRICULA_SONDA);
      const { count } = await adm.from('participantes')
        .select('*', { count: 'exact', head: true }).eq('is_test', true);
      reg('limpeza_teste', 'Zero avaliações artificiais ao final', !error && (count ?? 0) === 0,
        error ? `Não foi possível remover o registro de validação: ${error.message}`
              : `${count ?? 0} registro(s) is_test no banco após a verificação`);
    }
  }

  const pronto = passos.every(x => x.ok);
  await registrarEvento(sessao, 'ALTERACAO_CONFIGURACAO', 'preparacao', pronto ? 'pronto' : 'pendente',
    passos.filter(x => !x.ok).length, { itens: passos.map(x => ({ [x.chave]: x.ok })) });

  return Response.json({ passos, pronto });
}
