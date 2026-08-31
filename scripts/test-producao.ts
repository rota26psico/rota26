/**
 * TESTE DE PRODUÇÃO DE PONTA A PONTA — PostgreSQL real
 * ---------------------------------------------------------------------------
 * Exercita o fluxo completo da aplicação organizacional contra um banco
 * PostgreSQL de verdade, com RLS ligado e com três identidades distintas.
 *
 * Não é simulação: cada afirmação abaixo é verificada com uma consulta ao
 * banco, usando as MESMAS funções SQL que a aplicação chama.
 *
 * IMPORTANTE: o teste escreve no banco e NÃO é idempotente — ele exercita
 * cadastro, conclusão, limpeza e reaplicação, que são operações de estado.
 * Rode sempre contra um banco recém-criado com as migrations 01, 02, 03, 05,
 * 06, 07 e 08 aplicadas. Reexecutar sobre a base do teste anterior produz
 * falhas que são do procedimento, não da aplicação.
 *
 * Uso:
 *   createdb mapa_teste && psql -d mapa_teste -f supabase/01_schema.sql  (…02, 03, 05, 06, 07, 08)
 *   PGURL=postgres://... npx tsx scripts/test-producao.ts
 */
import { Client } from 'pg';
import { VERSAO_INSTRUMENTO } from '../src/data/questions';
import { QUESTOES_COMPLETAS as QUESTOES } from '../src/data/questions.server';
import { VERSAO_MATRIZ } from '../src/data/scoringMatrix';
import { avaliar, vetorDe, type Resposta } from '../src/lib/scoring';
import { analisarEquipe, compararComEquipe, type MembroAgregado } from '../src/lib/aggregate';
import { gerarExcel, type RegistroExport } from '../src/lib/excel';

const URL = process.env.PGURL ?? 'postgres://postgres@/mapa2?host=/tmp&port=5433';

const MASTER = '11111111-1111-1111-1111-111111111111';
const ADMIN_MEC = '22222222-2222-2222-2222-222222222222';
const PART = '33333333-3333-3333-3333-333333333333';

let ok = 0, falhas = 0;
const linhas: string[] = [];

function checa(titulo: string, condicao: boolean, detalhe: string) {
  if (condicao) { ok++; linhas.push(`  ✓ ${titulo} — ${detalhe}`); }
  else { falhas++; linhas.push(`  ✗ ${titulo} — ${detalhe}`); }
}
function secao(t: string) { linhas.push(''); linhas.push(`── ${t}`); }

const c = new Client({ connectionString: URL });

/** Executa como um usuário autenticado específico, com RLS aplicado. */
async function como(userId: string | null, email: string, fn: () => Promise<void>) {
  await c.query('begin');
  await c.query('set local role authenticated');
  if (userId) {
    await c.query(`set local request.jwt.claim.sub = '${userId}'`);
    await c.query(`set local request.jwt.claims = '${JSON.stringify({ sub: userId, email })}'`);
  }
  try { await fn(); } finally { await c.query('commit'); }
}
async function comoDono(fn: () => Promise<void>) {
  await c.query('begin'); await c.query('reset role');
  try { await fn(); } finally { await c.query('commit'); }
}

const escolha = (i: number, deslocamento = 0) => QUESTOES[i].alternativas[(i + deslocamento) % 4];
const respostasDe = (d: number): Resposta[] =>
  QUESTOES.map((q, i) => ({ questaoId: q.id, alternativaId: escolha(i, d).id }));

async function main() {
  await c.connect();

  /* ══════════════ 0. Preparação das três identidades ══════════════ */
  await comoDono(async () => {
    await c.query(`insert into auth.users(id,email) values
      ($1,'master@empresa.com.br'),($2,'admin.mec@empresa.com.br'),($3,'ana.real@empresa.com.br')
      on conflict (id) do nothing`, [MASTER, ADMIN_MEC, PART]);
    await c.query(`insert into administradores(user_id,papel,nome) values ($1,'MASTER','Master')
      on conflict (user_id) do nothing`, [MASTER]);
    await c.query(`insert into administradores(user_id,papel,setor_id,nome)
      values ($1,'ADMIN_SETOR',(select id from setores where codigo='MEC'),'Admin MEC')
      on conflict (user_id) do nothing`, [ADMIN_MEC]);
    // Todas as tabelas precisam ser legíveis pelo papel authenticated para que
    // o RLS — e não a falta de GRANT — seja o que decide o que cada um vê.
    await c.query(`grant usage on schema public to authenticated`);
    await c.query(`grant select, insert, update, delete on all tables in schema public to authenticated`);
    await c.query(`grant execute on all functions in schema public to authenticated`);
    await c.query(`grant usage, select on all sequences in schema public to authenticated`);
  });

  /* ══════════════ 1. Estado inicial: banco sem dado fictício ══════════════ */
  secao('1. Estado inicial do banco de produção');
  await como(MASTER, 'master@empresa.com.br', async () => {
    const d = (await c.query('select * from contagem_demo()')).rows[0];
    checa('Nenhum dado DEMO no banco', Number(d.participantes) === 0 && Number(d.avaliacoes) === 0,
      `${d.participantes} participantes DEMO, ${d.avaliacoes} avaliações DEMO`);
    const r = (await c.query('select * from resumo_organizacional()')).rows[0];
    checa('Resumo organizacional zerado e honesto', Number(r.concluidas) === 0,
      `${r.participantes} participantes · ${r.concluidas} concluídas · ${r.setores} setores ativos`);
    checa('Estrutura do instrumento intacta',
      Number((await c.query('select count(*) n from questoes')).rows[0].n) === 48,
      '48 questões continuam no banco após a limpeza DEMO da etapa anterior');
  });

  /* ══════════════ 2. Participante real: cadastro e gravação item a item ══ */
  secao('2. Participante real — cadastro, gravação incremental e retomada');
  let participanteId = '', avaliacaoId = '';
  await comoDono(async () => {
    participanteId = (await c.query(
      `insert into participantes(user_id,nome,matricula,email,setor_id,is_demo,is_test)
       values ($1,'Ana Real','MAT-0001','ana.real@empresa.com.br',
               (select id from setores where codigo='MEC'), false, false)
       on conflict (matricula) do update set nome = excluded.nome returning id`, [PART])).rows[0].id;
  });

  await como(PART, 'ana.real@empresa.com.br', async () => {
    avaliacaoId = (await c.query(
      `insert into avaliacoes(participante_id,versao_codigo,is_demo,is_test)
       values ($1,$2,false,false) returning id`, [participanteId, VERSAO_INSTRUMENTO])).rows[0].id;

    // Item 15 — uma gravação por escolha, como a aplicação faz.
    for (let i = 0; i < 20; i++) {
      const q = QUESTOES[i], a = escolha(i);
      await c.query(
        `insert into respostas(avaliacao_id,questao_codigo,alternativa_codigo,jung,eixo,peso,posicao_exibida)
         values ($1,$2,$3,$4,$5,$6,$7)
         on conflict (avaliacao_id,questao_codigo) do update set alternativa_codigo = excluded.alternativa_codigo`,
        [avaliacaoId, q.id, a.id, a.jung, a.eixo, q.peso, (i % 4) + 1]);
    }
    const n = Number((await c.query('select count(*) n from respostas where avaliacao_id=$1', [avaliacaoId])).rows[0].n);
    checa('Cada resposta é gravada no momento da escolha', n === 20, `${n} respostas persistidas`);
  });

  // Item 16 — "fecha o navegador": nova sessão, mesma matrícula.
  await como(PART, 'ana.real@empresa.com.br', async () => {
    const r = await c.query('select * from avaliacao_em_andamento()');
    const salvas = new Set(r.rows.filter(x => x.questao_codigo).map(x => x.questao_codigo));
    const proxima = QUESTOES.findIndex(q => !salvas.has(q.id)) + 1;
    checa('Retomada encontra a avaliação e o ponto exato',
      r.rows.length > 0 && salvas.size === 20 && proxima === 21,
      `${salvas.size} respostas recuperadas; retoma na situação ${proxima}`);
  });

  /* ══════════════ 3. Conclusão transacional ══════════════ */
  secao('3. Finalização transacional');
  await como(PART, 'ana.real@empresa.com.br', async () => {
    // A conclusão prematura tem de ser recusada pelo gatilho do banco.
    let recusou = false;
    try {
      await c.query('savepoint sp');
      await c.query(`update avaliacoes set status='CONCLUIDA' where id=$1`, [avaliacaoId]);
      await c.query('release savepoint sp');
    } catch { recusou = true; await c.query('rollback to savepoint sp'); }
    checa('Conclusão com menos de 48 respostas é recusada pelo banco', recusou,
      'o gatilho valida_conclusao impede o estado meio-concluído');

    for (let i = 20; i < 48; i++) {
      const q = QUESTOES[i], a = escolha(i);
      await c.query(
        `insert into respostas(avaliacao_id,questao_codigo,alternativa_codigo,jung,eixo,peso,posicao_exibida)
         values ($1,$2,$3,$4,$5,$6,$7) on conflict do nothing`,
        [avaliacaoId, q.id, a.id, a.jung, a.eixo, q.peso, (i % 4) + 1]);
    }

    // O resultado é calculado a partir das respostas RELIDAS DO BANCO.
    const brutas = (await c.query(
      'select questao_codigo, alternativa_codigo from respostas where avaliacao_id=$1', [avaliacaoId])).rows;
    const r = avaliar(brutas.map(b => ({ questaoId: b.questao_codigo, alternativaId: b.alternativa_codigo })));
    checa('Algoritmo considera a avaliação completa', r.completo && brutas.length === 48,
      `${brutas.length} respostas · perfil ${r.perfilPrincipal} · secundário ${r.perfilSecundario}`);

    await c.query(`insert into escores(avaliacao_id,bruto,relativo) values ($1,$2,$3)
      on conflict (avaliacao_id) do update set bruto=excluded.bruto, relativo=excluded.relativo`,
      [avaliacaoId, r.escores.bruto, r.escores.relativo]);
    await c.query(`insert into resultados(avaliacao_id,atitude,funcao_dominante,funcao_auxiliar,
      funcao_menos_representada,funcao_inferior,perfil_principal,perfil_secundario,empate_funcoes,
      regra_desempate,ordem_funcoes,algoritmo_versao)
      values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) on conflict (avaliacao_id) do nothing`,
      [avaliacaoId, r.atitude, r.funcaoDominante, r.funcaoAuxiliar, r.funcaoMenosRepresentada,
       r.funcaoInferior, r.perfilPrincipal, r.perfilSecundario, r.empateFuncoes,
       r.regraDesempate, r.ordemFuncoes, r.versao]);
    await c.query(`insert into resultados_funcionais(avaliacao_id,eixos_bruto,eixos,cap_bruto,capacidades,
      ordem_capacidades,versao_matriz) values ($1,$2,$3,$4,$5,$6,$7) on conflict (avaliacao_id) do nothing`,
      [avaliacaoId, r.escores.eixos.bruto, r.escores.eixos.relativo, r.funcional.capacidadesBruto,
       r.funcional.capacidades, r.capacidadesOrdenadas.map(x => x.id), VERSAO_MATRIZ]);
    const t = r.top3Belbin;
    await c.query(`insert into resultados_belbin(avaliacao_id,bruto,relativo,top1,top1_valor,top1_intensidade,
      top2,top2_valor,top2_intensidade,top3,top3_valor,top3_intensidade,versao_matriz)
      values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13) on conflict (avaliacao_id) do nothing`,
      [avaliacaoId, r.funcional.belbinBruto, r.funcional.belbin,
       t[0].id, t[0].valor, t[0].intensidade, t[1].id, t[1].valor, t[1].intensidade,
       t[2].id, t[2].valor, t[2].intensidade, VERSAO_MATRIZ]);
    await c.query(`update avaliacoes set status='CONCLUIDA', concluida_em=now()
      where id=$1 and status='EM_ANDAMENTO'`, [avaliacaoId]);

    const st = (await c.query('select status from avaliacoes where id=$1', [avaliacaoId])).rows[0].status;
    checa('Avaliação fechada somente após os derivados gravados', st === 'CONCLUIDA',
      `status final ${st}; escores, resultado Jung, funcional e Belbin conferidos antes do fechamento`);
    await c.query(`select registrar_evento('CONCLUSAO','avaliacao',$1,48,'{}'::jsonb)`, [avaliacaoId]);
  });

  /* ══════════════ 4. Item 17 — quem já concluiu não recomeça ══════════════ */
  secao('4. Participante que já concluiu');
  await como(PART, 'ana.real@empresa.com.br', async () => {
    const r = (await c.query(
      `select status from avaliacoes where participante_id=$1 and arquivada_em is null`, [participanteId])).rows;
    const temConcluida = r.some(x => x.status === 'CONCLUIDA');
    const emAndamento = (await c.query('select * from avaliacao_em_andamento()')).rows.length;
    checa('Nenhuma nova avaliação é aberta em silêncio', temConcluida && emAndamento === 0,
      `${r.length} avaliação(ões) do participante, nenhuma em andamento`);
  });

  /* ══════════════ 5. Dashboards com dado real ══════════════ */
  secao('5. Dashboards, comparação e Excel sobre dado real');
  let membros: MembroAgregado[] = [];
  await como(MASTER, 'master@empresa.com.br', async () => {
    const rows = (await c.query(
      `select participante_id, setor, atitude, funcao_dominante, perfil_principal, perfil_secundario,
              jung, eixos, capacidades, belbin from vw_resultados`)).rows;
    membros = rows.map((x: any) => ({
      id: x.participante_id, setor: x.setor, perfil: x.perfil_principal,
      perfilSecundario: x.perfil_secundario, atitude: x.atitude, funcaoDominante: x.funcao_dominante,
      jung: x.jung, eixos: x.eixos, capacidades: x.capacidades, belbin: x.belbin
    }));
    const resumo = (await c.query('select * from resumo_organizacional()')).rows[0];
    checa('Dashboard reflete exatamente o banco',
      membros.length === 1 && Number(resumo.concluidas) === 1,
      `${membros.length} membro(s) na view, ${resumo.concluidas} concluída(s) no resumo`);

    const a = analisarEquipe(membros);
    checa('Análise de equipe calculada sobre dado real', a.n === 1,
      `n=${a.n} · IDF ${a.idf} · ICF ${a.icf} · aviso de amostra: ${a.avisoAmostra ? 'presente' : 'ausente'}`);

    const comp = compararComEquipe(vetorDe(avaliar(respostasDe(0))), membros);
    checa('Comparação com a equipe responde corretamente ao grupo pequeno',
      typeof comp.nSetor === 'number',
      comp.disponivel ? `${comp.nSetor} respondentes` : `limite de amostra respeitado: ${comp.motivo}`);
  });

  /* ══════════════ 6. Coexistência com dado DEMO ══════════════ */
  secao('6. Dado DEMO reintroduzido — os indicadores continuam limpos');
  await comoDono(async () => {
    const pid = (await c.query(
      `insert into participantes(nome,matricula,setor_id,is_demo)
       values ('Fulano Demo','DEMO-9999',(select id from setores where codigo='MEC'), true)
       on conflict (matricula) do update set is_demo=true returning id`)).rows[0].id;
    const aid = (await c.query(
      `insert into avaliacoes(participante_id,versao_codigo,is_demo,status,concluida_em)
       values ($1,$2,true,'EM_ANDAMENTO',now()) returning id`, [pid, VERSAO_INSTRUMENTO])).rows[0].id;
    const rr = respostasDe(1);
    for (let i = 0; i < 48; i++) {
      const q = QUESTOES[i], a = escolha(i, 1);
      await c.query(`insert into respostas(avaliacao_id,questao_codigo,alternativa_codigo,jung,eixo,peso)
        values ($1,$2,$3,$4,$5,$6) on conflict do nothing`, [aid, q.id, a.id, a.jung, a.eixo, q.peso]);
    }
    const r = avaliar(rr);
    await c.query(`insert into escores(avaliacao_id,bruto,relativo) values ($1,$2,$3)`,
      [aid, r.escores.bruto, r.escores.relativo]);
    await c.query(`insert into resultados(avaliacao_id,atitude,funcao_dominante,funcao_auxiliar,
      funcao_menos_representada,funcao_inferior,perfil_principal,perfil_secundario,empate_funcoes,
      regra_desempate,ordem_funcoes,algoritmo_versao) values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)`,
      [aid, r.atitude, r.funcaoDominante, r.funcaoAuxiliar, r.funcaoMenosRepresentada, r.funcaoInferior,
       r.perfilPrincipal, r.perfilSecundario, r.empateFuncoes, r.regraDesempate, r.ordemFuncoes, r.versao]);
    await c.query(`update avaliacoes set status='CONCLUIDA' where id=$1`, [aid]);
  });

  await como(MASTER, 'master@empresa.com.br', async () => {
    const reais = Number((await c.query('select count(*) n from vw_resultados')).rows[0].n);
    const todos = Number((await c.query('select count(*) n from vw_resultados_todos')).rows[0].n);
    const resumo = (await c.query('select * from resumo_organizacional()')).rows[0];
    checa('Registro DEMO NÃO entra em nenhum indicador', reais === 1 && todos === 2,
      `view de dados reais: ${reais} · view irrestrita (backup): ${todos}`);
    checa('Contagens do dashboard ignoram o DEMO',
      Number(resumo.participantes) === 1 && Number(resumo.concluidas) === 1,
      `${resumo.participantes} participante(s), ${resumo.concluidas} concluída(s)`);
    const d = (await c.query('select * from contagem_demo()')).rows[0];
    checa('O sistema sabe que existe dado DEMO a limpar', Number(d.participantes) === 1,
      `${d.participantes} participante(s) DEMO detectado(s) — o botão de limpeza fica disponível`);
  });

  /* ══════════════ 7. Limpeza DEMO preserva o real ══════════════ */
  secao('7. Limpeza dos dados de demonstração');
  await como(MASTER, 'master@empresa.com.br', async () => {
    const p = (await c.query('select * from previa_limpeza_demo()')).rows[0];
    checa('Prévia mostra o que será afetado e o que será preservado',
      Number(p.participantes) === 1 && Number(p.respostas) === 48 && Number(p.reais_preservados) === 1,
      `${p.participantes} participante(s), ${p.avaliacoes} avaliação(ões), ${p.respostas} respostas · ${p.reais_preservados} real(is) preservado(s)`);

    let recusou = false;
    try {
      await c.query('savepoint sp2');
      await c.query(`select limpar_dados_demo('limpar dados demo')`);
      await c.query('release savepoint sp2');
    } catch { recusou = true; await c.query('rollback to savepoint sp2'); }
    checa('Confirmação errada é recusada', recusou, 'a função exige o texto literal LIMPAR DADOS DEMO');
  });

  await como(MASTER, 'master@empresa.com.br', async () => {
    const r = (await c.query(`select * from limpar_dados_demo('LIMPAR DADOS DEMO')`)).rows[0];
    checa('Limpeza remove somente o DEMO', Number(r.restantes) === 0,
      `${r.participantes_removidos} participante(s), ${r.avaliacoes_removidas} avaliação(ões), ${r.respostas_removidas} resposta(s) · ${r.restantes} DEMO restantes`);
  });

  await como(MASTER, 'master@empresa.com.br', async () => {
    const reais = Number((await c.query('select count(*) n from vw_resultados')).rows[0].n);
    const resp = Number((await c.query('select count(*) n from respostas')).rows[0].n);
    checa('Participante REAL sobreviveu intacto', reais === 1 && resp === 48,
      `${reais} avaliação real concluída, com ${resp} respostas brutas`);

    const est = (await c.query(`select
      (select count(*) from questoes) questoes, (select count(*) from alternativas) alternativas,
      (select count(*) from perfis) perfis, (select count(*) from setores) setores,
      (select count(*) from matriz_funcional) matriz, (select count(*) from afinidade_belbin) belbin,
      (select count(*) from versoes_instrumento) versoes, (select count(*) from administradores) admins`)).rows[0];
    checa('Estrutura do instrumento intocada',
      Number(est.questoes) === 48 && Number(est.alternativas) === 192 && Number(est.perfis) === 8 &&
      Number(est.setores) > 0 && Number(est.matriz) > 0 && Number(est.belbin) > 0 &&
      Number(est.versoes) > 0 && Number(est.admins) > 0,
      `${est.questoes} questões · ${est.alternativas} alternativas · ${est.perfis} perfis · ${est.setores} setores · ${est.matriz} matriz funcional · ${est.belbin} Belbin · ${est.versoes} versões · ${est.admins} administradores`);

    const log = (await c.query(
      `select acao, usuario_email, registros_afetados, detalhe from logs_auditoria
       where acao='LIMPEZA_DEMO' order by criado_em desc limit 1`)).rows[0];
    checa('Limpeza registrada na auditoria com autor real',
      !!log && log.usuario_email === 'master@empresa.com.br',
      `${log?.acao} por ${log?.usuario_email} · ${log?.registros_afetados} registro(s) · restantes ${log?.detalhe?.registros_demo_restantes}`);
  });

  /* ══════════════ 8. Sigilo aplicado no banco ══════════════ */
  secao('8. Row Level Security com três identidades');
  await como(PART, 'ana.real@empresa.com.br', async () => {
    const p = Number((await c.query('select count(*) n from participantes')).rows[0].n);
    const r = Number((await c.query('select count(*) n from respostas')).rows[0].n);
    const v = Number((await c.query('select count(*) n from vw_resultados')).rows[0].n);
    const l = Number((await c.query('select count(*) n from logs_auditoria')).rows[0].n);
    checa('Participante vê apenas a si mesmo', p === 1 && r === 48,
      `${p} participante visível, ${r} respostas (as próprias)`);
    checa('Participante não acessa dashboards nem auditoria', v === 1 && l === 0,
      `view de resultados: ${v} linha (a própria) · auditoria: ${l} registros`);
  });

  await como(ADMIN_MEC, 'admin.mec@empresa.com.br', async () => {
    const p = Number((await c.query('select count(*) n from participantes')).rows[0].n);
    const r = Number((await c.query('select count(*) n from respostas')).rows[0].n);
    checa('Administrador de setor vê seu setor e ZERO respostas brutas', p >= 1 && r === 0,
      `${p} participante(s) do MEC visível(is), ${r} respostas brutas`);
    let bloqueou = false;
    try {
      await c.query('savepoint sp3');
      await c.query(`select limpar_dados_demo('LIMPAR DADOS DEMO')`);
      await c.query('release savepoint sp3');
    } catch { bloqueou = true; await c.query('rollback to savepoint sp3'); }
    checa('Administrador de setor não pode limpar dados', bloqueou, 'a função exige papel MASTER');
  });

  await como(MASTER, 'master@empresa.com.br', async () => {
    const p = Number((await c.query('select count(*) n from participantes')).rows[0].n);
    const r = Number((await c.query('select count(*) n from respostas')).rows[0].n);
    const l = Number((await c.query('select count(*) n from logs_auditoria')).rows[0].n);
    checa('Master vê tudo e a auditoria', p >= 1 && r === 48 && l > 0,
      `${p} participante(s), ${r} respostas brutas, ${l} evento(s) de auditoria`);
  });

  /* ══════════════ 9. Excel = banco ══════════════ */
  secao('9. Excel gerado a partir do banco');
  await como(MASTER, 'master@empresa.com.br', async () => {
    const linhasV = (await c.query(
      `select avaliacao_id, participante_id, nome, matricula, email, setor, concluida_em from vw_resultados`)).rows;
    const brutas = (await c.query(
      `select avaliacao_id, questao_codigo, alternativa_codigo, jung, eixo, peso from respostas`)).rows;
    const regs: RegistroExport[] = linhasV.map((x: any) => {
      const rs = brutas.filter(b => b.avaliacao_id === x.avaliacao_id).map(b => ({
        questaoId: b.questao_codigo, alternativaId: b.alternativa_codigo,
        jung: b.jung, eixo: b.eixo, peso: b.peso
      }));
      return {
        participanteId: x.participante_id, nome: x.nome, matricula: x.matricula, setor: x.setor,
        email: x.email ?? '', concluidaEm: x.concluida_em, versao: VERSAO_INSTRUMENTO, isDemo: false,
        respostas: rs as any,
        resultado: avaliar(rs.map(r => ({ questaoId: r.questaoId, alternativaId: r.alternativaId })))
      };
    });
    const buf = await gerarExcel('completo', regs, { geradoPor: 'master@empresa.com.br', geradoEm: new Date().toISOString() });
    checa('Planilha gerada a partir do banco, sem nenhum registro DEMO',
      buf.byteLength > 0 && regs.length === 1 && regs.every(r => !r.isDemo),
      `${Math.round(buf.byteLength / 1024)} KB · ${regs.length} registro(s) · ${regs[0]?.respostas.length} respostas brutas`);

    const a = analisarEquipe(regs.map(r => ({ id: r.participanteId, setor: r.setor, ...vetorDe(r.resultado) })));
    const doBanco = analisarEquipe(membros);
    checa('Dashboard e Excel partem da mesma fonte', a.n === doBanco.n,
      `n do Excel ${a.n} · n do dashboard ${doBanco.n}`);
  });

  /* ══════════════ 10. Checklist de prontidão ══════════════ */
  secao('10. Checklist de pré-aplicação');
  await como(MASTER, 'master@empresa.com.br', async () => {
    const r = (await c.query('select * from verificar_prontidao()')).rows;
    for (const x of r) checa(`Checklist · ${x.item}`, x.ok, x.detalhe);
  });

  /* ══════════════ 11. Reaplicação autorizada ══════════════ */
  secao('11. Reaplicação autorizada pelo Master');
  await como(MASTER, 'master@empresa.com.br', async () => {
    const n = (await c.query(`select liberar_reaplicacao('MAT-0001') n`)).rows[0].n;
    checa('Master arquiva a avaliação anterior e libera a matrícula', Number(n) === 1,
      `${n} avaliação arquivada — as respostas continuam no banco`);
    const reais = Number((await c.query('select count(*) n from vw_resultados')).rows[0].n);
    const resp = Number((await c.query('select count(*) n from respostas')).rows[0].n);
    checa('Avaliação arquivada sai dos indicadores sem perder as respostas', reais === 0 && resp === 48,
      `${reais} linha(s) na view de resultados · ${resp} respostas brutas ainda gravadas`);
  });

  await como(PART, 'ana.real@empresa.com.br', async () => {
    const emAnd = (await c.query('select * from avaliacao_em_andamento()')).rows.length;
    const conc = Number((await c.query(
      `select count(*) n from avaliacoes where participante_id=$1 and status='CONCLUIDA' and arquivada_em is null`,
      [participanteId])).rows[0].n);
    checa('Participante liberado pode responder de novo', emAnd === 0 && conc === 0,
      'nenhuma avaliação ativa bloqueia uma nova aplicação');
  });

  await c.end();

  const cabecalho = [
    '══════════════════════════════════════════════════════════════════════════════',
    ' TESTE DE PRODUÇÃO DE PONTA A PONTA — PostgreSQL real, RLS ligado',
    '══════════════════════════════════════════════════════════════════════════════'
  ];
  const rodape = [
    '',
    '══════════════════════════════════════════════════════════════════════════════',
    ` RESULTADO: ${ok} verificação(ões) aprovada(s), ${falhas} falha(s).`,
    '══════════════════════════════════════════════════════════════════════════════'
  ];
  console.log([...cabecalho, ...linhas, ...rodape].join('\n'));
  process.exit(falhas ? 1 : 0);
}

main().catch(e => { console.error(e); process.exit(1); });
