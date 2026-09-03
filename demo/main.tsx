/**
 * DEMO NAVEGÁVEL v2.0 — executa o SISTEMA REAL sobre um repositório em memória.
 * ---------------------------------------------------------------------------
 * Idêntico à produção: as 48 questões, o algoritmo determinístico das duas
 * trilhas, a matriz de pontuação por alternativa, a agregação por vetores
 * completos, o IDF, o ICF, a geração real do Excel e todas as telas.
 *
 * A ÚNICA diferença é a camada de persistência: aqui os registros ficam em
 * memória; em produção, no PostgreSQL do Supabase, através de
 * src/lib/repo-supabase.ts, que expõe a mesma interface.
 *
 * Nada aqui é simulado: exportar baixa um .xlsx de verdade, zerar remove
 * registros de verdade, e retomar recupera as respostas salvas de verdade.
 */
import React, { useMemo, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { ESTILOS, Aviso, Card, Marca, Glossario } from '../src/components/ui';
import { DefinicoesAnimais } from '../src/components/animais-svg';
import { MARCA_DATA_URI } from '../src/data/marca';
import { TelaIdentificacao, TelaQuestionario, TelaResultado } from '../src/components/views-participante';
import {
  TelaEquipe, TelaVisaoOrganizacional, TelaComparacao, TelaLeituraExecutivaIndividual,
  TelaPessoas, TelaMetodologia, TelaGestaoDados, TelaAnimais,
  type AlvoReset, type QualidadeItem, type PainelProducao, CONFIRMACAO_DEMO
} from '../src/components/views-gestao';
import { composicaoAnimais, matrizAnimais } from '../src/lib/animais';
import { avaliar, vetorDe, type Resposta, type ResultadoIndividual } from '../src/lib/scoring';
import { analisarEquipe, compararSetores, compararComEquipe, type MembroAgregado } from '../src/lib/aggregate';
import { gerarExcel, NOME_ARQUIVO, type RegistroExport, type TipoExport } from '../src/lib/excel';
import { VERSAO_INSTRUMENTO } from '../src/data/questions';
import { MATRIZ_PONTUACAO } from '../src/data/scoringMatrix';
import { QUESTOES_COMPLETAS as QUESTOES, ALTERNATIVA_POR_ID } from '../src/data/questions.server';
import { PERFIS, NOME_FUNCAO, NOME_ATITUDE } from '../src/data/profiles';
import { CAPACIDADES } from '../src/data/functional';
import { gerarParticipantes, SETORES } from '../scripts/simulate';

/* ─────────────────── Repositório em memória (papel do Supabase) ──────────── */
interface Registro {
  participanteId: string; nome: string; matricula: string; setor: string; email: string;
  concluidaEm: string; respostas: Resposta[]; resultado: ResultadoIndividual;
  isDemo: boolean; status: 'CONCLUIDA' | 'EM_ANDAMENTO';
}

const semente = gerarParticipantes();
const INICIAIS: Registro[] = semente.map((p, i) => ({
  participanteId: `demo-${i}`, nome: p.nome, matricula: p.matricula, setor: p.setor, email: p.email,
  concluidaEm: p.concluidoEm, respostas: p.respostas, resultado: avaliar(p.respostas),
  isDemo: true, status: 'CONCLUIDA'
}));

const paraMembros = (rs: Registro[]): MembroAgregado[] =>
  rs.filter(r => r.status === 'CONCLUIDA').map(r => ({ id: r.participanteId, setor: r.setor, ...vetorDe(r.resultado) }));

const paraExport = (rs: Registro[]): RegistroExport[] =>
  rs.filter(r => r.status === 'CONCLUIDA').map(r => ({
    participanteId: r.participanteId, nome: r.nome, matricula: r.matricula, setor: r.setor, email: r.email,
    concluidaEm: r.concluidaEm, versao: VERSAO_INSTRUMENTO, isDemo: r.isDemo,
    respostas: r.respostas.map(x => {
      const a = ALTERNATIVA_POR_ID[x.alternativaId];
      return { questaoId: x.questaoId, alternativaId: x.alternativaId, jung: a.jung, eixo: a.eixo, peso: a.peso };
    }),
    resultado: r.resultado
  }));

/**
 * Detecta se a página está sendo exibida DENTRO de um visualizador embutido
 * (iframe). Navegadores bloqueiam downloads iniciados por script em iframes
 * com sandbox — silenciosamente, sem erro no console.
 */
const EMBUTIDO = (() => {
  try { return window.self !== window.top; } catch { return true; }
})();

type Aba = 'participante' | 'organizacional' | 'equipe' | 'comparativo' | 'animais' | 'pessoas' | 'metodologia' | 'siglas' | 'dados';

function App() {
  const [aba, setAba] = useState<Aba>('participante');
  const [regs, setRegs] = useState<Registro[]>(INICIAIS);
  const [setores, setSetores] = useState<string[]>(SETORES);
  const [setorSel, setSetorSel] = useState('MEC');

  // fluxo do participante
  const [etapa, setEtapa] = useState<'ident' | 'quest' | 'result'>('ident');
  const [atual, setAtual] = useState<{ nome: string; matricula: string; setor: string } | null>(null);
  const [rascunho, setRascunho] = useState<Record<string, Record<string, string>>>({}); // matrícula → respostas salvas
  const [meu, setMeu] = useState<Registro | null>(null);
  const [gravadas, setGravadas] = useState(0);
  const [erroIdent, setErroIdent] = useState<string | null>(null);

  // gestão
  const [verPessoa, setVerPessoa] = useState<Registro | null>(null);
  const [exportando, setExportando] = useState<string | null>(null);
  const [erroExport, setErroExport] = useState<string | null>(null);
  const [arquivoPronto, setArquivoPronto] = useState<{ nome: string; url: string; kb: number; embutido: boolean } | null>(null);
  const [previa, setPrevia] = useState<AlvoReset | null>(null);
  const [resultadoReset, setResultadoReset] = useState<string | null>(null);
  const [logs, setLogs] = useState<{ data: string; usuario: string; acao: string; detalhe: string }[]>([]);

  const log = (acao: string, detalhe: string) =>
    setLogs(l => [{ data: new Date().toISOString(), usuario: 'administrador (pré-visualização)', acao, detalhe }, ...l]);

  const concluidas = regs.filter(r => r.status === 'CONCLUIDA');
  const membros = useMemo(() => paraMembros(regs), [regs]);
  const geral = useMemo(() => analisarEquipe(membros), [membros]);
  const doSetor = useMemo(() => analisarEquipe(membros.filter(m => m.setor === setorSel)), [membros, setorSel]);
  const comparativo = useMemo(() => {
    const g: Record<string, MembroAgregado[]> = {};
    for (const m of membros) (g[m.setor] ||= []).push(m);
    return compararSetores(g);
  }, [membros]);

  /* ── Participante ── */
  const iniciar = (d: { nome: string; matricula: string; setor: string }) => {
    setErroIdent(null);
    const existente = regs.find(r => r.matricula === d.matricula && r.status === 'CONCLUIDA');
    if (existente) {
      // Matrícula duplicada com avaliação concluída: abre o resultado existente.
      setAtual({ nome: existente.nome, matricula: existente.matricula, setor: existente.setor });
      setMeu(existente); setEtapa('result');
      return;
    }
    setAtual(d);
    setGravadas(Object.keys(rascunho[d.matricula] ?? {}).length);
    setEtapa('quest');
  };

  const salvarResposta = (r: Resposta) => {
    if (!atual) return;
    setRascunho(prev => ({ ...prev, [atual.matricula]: { ...(prev[atual.matricula] ?? {}), [r.questaoId]: r.alternativaId } }));
    setGravadas(g => g + 1);
  };

  const concluir = (respostas: Resposta[]) => {
    if (!atual) return;
    const resultado = avaliar(respostas);
    if (!resultado.completo) return;
    const novo: Registro = {
      participanteId: `real-${atual.matricula}`, nome: atual.nome, matricula: atual.matricula,
      setor: atual.setor, email: '', concluidaEm: new Date().toISOString(),
      respostas, resultado, isDemo: false, status: 'CONCLUIDA'
    };
    setRegs(prev => [...prev.filter(r => r.matricula !== atual.matricula), novo]);
    setRascunho(prev => { const c = { ...prev }; delete c[atual.matricula]; return c; });
    setMeu(novo); setSetorSel(atual.setor); setEtapa('result');
  };

  /* ── Exportação real ────────────────────────────────────────────────────
   * Três defeitos corrigidos em relação à primeira versão:
   *  1. a âncora precisa estar ANEXADA ao documento — Firefox e navegadores
   *     estritos ignoram click() em elemento solto;
   *  2. revokeObjectURL não pode ser síncrono após o clique — isso cancela o
   *     download antes de ele começar em Firefox e Safari;
   *  3. o erro era engolido: qualquer falha deixava o botão voltar ao normal
   *     sem explicação nenhuma.
   *
   * Além disso: quando a página está EMBUTIDA em um visualizador (iframe com
   * sandbox), o navegador bloqueia qualquer download iniciado por script, sem
   * emitir erro. Nesse caso o arquivo é gerado normalmente e oferecido por um
   * link manual, com a instrução do que fazer.
   */
  const exportar = async (tipo: string, setor?: string) => {
    setExportando(tipo);
    setErroExport(null);
    setArquivoPronto(null);
    try {
      const registros = paraExport(regs);
      const buf = await gerarExcel(tipo as TipoExport, registros,
        { setor: setor ?? setorSel, geradoPor: 'pré-visualização de desenvolvimento', geradoEm: new Date().toISOString() });
      const blob = new Blob([buf], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
      const url = URL.createObjectURL(blob);
      const nome = `${NOME_ARQUIVO[tipo as TipoExport]}${setor ? '-' + setor.replace(/\s+/g, '_') : ''}.xlsx`;

      const a = document.createElement('a');
      a.href = url; a.download = nome; a.rel = 'noopener';
      a.style.display = 'none';
      document.body.appendChild(a);          // (1)
      a.click();
      document.body.removeChild(a);
      setTimeout(() => URL.revokeObjectURL(url), 120000);   // (2) revoga só depois

      // O arquivo fica sempre disponível por link manual — é o que salva o caso
      // do visualizador embutido, em que o clique programático é inerte.
      setArquivoPronto({ nome, url, kb: Math.round(blob.size / 1024), embutido: EMBUTIDO });
      log('EXPORTACAO', `${tipo}${setor ? ' · ' + setor : ''} · ${registros.length} registros · ${Math.round(blob.size / 1024)} KB`);
    } catch (e: any) {                                       // (3)
      setErroExport(`Falha ao gerar a planilha: ${e?.message ?? e}`);
    } finally { setExportando(null); }
  };

  /* ── Reset real, com prévia e confirmação ── */
  const alvoDe = (escopo: AlvoReset['escopo'], param?: string): Registro[] => {
    if (escopo === 'participante') return regs.filter(r => r.matricula === param);
    if (escopo === 'setor') return regs.filter(r => r.setor === param);
    if (escopo === 'periodo') return regs.filter(r => param && r.concluidaEm.slice(0, 10) <= param);
    if (escopo === 'demo') return regs.filter(r => r.isDemo);
    return regs;
  };
  const DESCR: Record<AlvoReset['escopo'], string> = {
    participante: 'Remove as avaliações, respostas e resultados do participante informado. Preserva o cadastro, as perguntas e todas as matrizes.',
    setor: 'Remove as avaliações, respostas e resultados de todos os participantes da equipe selecionada.',
    periodo: 'Remove as avaliações concluídas até a data informada.',
    demo: 'Remove apenas os registros marcados como demonstração. Todos os dados reais são preservados.',
    tudo: 'Remove TODAS as avaliações, respostas e resultados da organização. Perguntas, alternativas, matrizes, animais, perfis, parâmetros funcionais, configuração Belbin, setores, administradores e versões são preservados.'
  };
  const abrirPrevia = (escopo: AlvoReset['escopo'], param?: string) => {
    const alvo = alvoDe(escopo, param);
    setResultadoReset(null);
    setPrevia({
      escopo, participantes: alvo.length, avaliacoes: alvo.filter(r => r.status === 'CONCLUIDA').length,
      respostas: alvo.reduce((s, r) => s + r.respostas.length, 0), descricao: DESCR[escopo]
    });
  };
  const confirmarReset = (escopo: AlvoReset['escopo'], param?: string) => {
    const alvo = new Set(alvoDe(escopo, param).map(r => r.participanteId));
    const antes = regs.length;
    setRegs(prev => prev.filter(r => !alvo.has(r.participanteId)));
    setPrevia(null);
    setResultadoReset(`${alvo.size} registro(s) removido(s). Restam ${antes - alvo.size}. Perguntas, matrizes, perfis, setores e versões permanecem intactos.`);
    log('RESET', `escopo=${escopo}${param ? ' · ' + param : ''} · ${alvo.size} registros removidos`);
  };

  /* ── Qualidade do instrumento (dashboard metodológico) ── */
  const qualidade: QualidadeItem[] = useMemo(() => QUESTOES.map(q => {
    const escolhas = concluidas.map(r => r.respostas.find(x => x.questaoId === q.id)?.alternativaId).filter(Boolean) as string[];
    const n = escolhas.length || 1;
    const distribuicao = q.alternativas.map(a => {
      const c = escolhas.filter(x => x === a.id).length;
      return { alternativaId: a.id, n: c, pct: Math.round((c / n) * 1000) / 10 };
    });
    const maxPct = Math.max(...distribuicao.map(d => d.pct));
    return {
      questaoId: q.id, contexto: q.contexto, n: escolhas.length, distribuicao,
      concentracaoMax: maxPct, discriminativo: distribuicao.every(d => d.n > 0)
    };
  }), [concluidas]);

  const empates = useMemo(() => {
    const e = concluidas.filter(r => r.resultado.empateFuncoes).length;
    return { n: e, pct: concluidas.length ? Math.round((e / concluidas.length) * 1000) / 10 : 0 };
  }, [concluidas]);

  /* ── Painel de produção, sobre o repositório em memória ──
     Esta é uma PRÉ-VISUALIZAÇÃO DE DESENVOLVIMENTO. Os mesmos controles, na
     aplicação Next.js, operam contra o PostgreSQL: prévia, backup, confirmação
     literal e auditoria são executados por funções do banco. */
  const [previaDemo, setPreviaDemo] = useState<PainelProducao['previaDemo']>(null);
  const [resultadoDemo, setResultadoDemo] = useState<PainelProducao['resultadoDemo']>(null);
  const [checklist, setChecklist] = useState<PainelProducao['checklist']>(null);
  const [ocupadoProd, setOcupadoProd] = useState<string | null>(null);
  const [msgProd, setMsgProd] = useState<string | null>(null);
  const [erroProd, setErroProd] = useState<string | null>(null);

  const producao: PainelProducao = {
    ambiente: 'AMBIENTE: PRÉ-VISUALIZAÇÃO DE DESENVOLVIMENTO',
    emProducao: false,
    contagem: {
      participantes: regs.filter(r => r.isDemo).length,
      avaliacoes: regs.filter(r => r.isDemo && r.status === 'CONCLUIDA').length,
      testes: 0
    },
    previaDemo, resultadoDemo, checklist, ocupado: ocupadoProd, mensagem: msgProd, erro: erroProd,
    onPreviaDemo: () => {
      const alvo = regs.filter(r => r.isDemo);
      setErroProd(null); setMsgProd(null); setResultadoDemo(null);
      setPreviaDemo({
        participantes: alvo.length,
        avaliacoes: alvo.filter(r => r.status === 'CONCLUIDA').length,
        respostas: alvo.reduce((s, r) => s + r.respostas.length, 0),
        resultados: alvo.filter(r => r.status === 'CONCLUIDA').length,
        reaisPreservados: regs.filter(r => !r.isDemo).length
      });
    },
    onCancelarPrevia: () => setPreviaDemo(null),
    onLimparDemo: (c: string) => {
      if (c !== CONFIRMACAO_DEMO) { setErroProd(`Confirmação inválida. Digite exatamente ${CONFIRMACAO_DEMO}.`); return; }
      const alvo = regs.filter(r => r.isDemo);
      setRegs(prev => prev.filter(r => !r.isDemo));
      setPreviaDemo(null);
      setResultadoDemo({
        participantes: alvo.length,
        avaliacoes: alvo.filter(r => r.status === 'CONCLUIDA').length,
        respostas: alvo.reduce((s, r) => s + r.respostas.length, 0),
        restantes: 0
      });
      log('LIMPEZA_DEMO', `${alvo.length} participante(s) de demonstração removido(s); dados reais preservados`);
    },
    onPreparar: () => {
      setOcupadoProd('preparo');
      const demoRestante = regs.filter(r => r.isDemo).length;
      setChecklist([
        { chave: 'questoes', item: '48 questões carregadas', ok: QUESTOES.length === 48, detalhe: `${QUESTOES.length} itens no banco fixo` },
        { chave: 'alternativas', item: '48 questões com alternativas', ok: QUESTOES.every(q => q.alternativas.length === 4), detalhe: `${QUESTOES.reduce((s, q) => s + q.alternativas.length, 0)} alternativas` },
        { chave: 'algoritmo', item: 'Algoritmo ativo', ok: true, detalhe: `Instrumento ${VERSAO_INSTRUMENTO}` },
        { chave: 'banco', item: 'Banco persistente conectado', ok: false, detalhe: 'Pré-visualização em memória: não há banco. Na aplicação Next.js este item consulta o PostgreSQL.' },
        { chave: 'demo_zero', item: 'Dados DEMO = 0', ok: demoRestante === 0, detalhe: `${demoRestante} registro(s) de demonstração` },
        { chave: 'rls', item: 'RLS ativo', ok: false, detalhe: 'Verificável somente contra o Supabase.' }
      ]);
      setOcupadoProd(null);
    },
    onLimparTeste: () => setMsgProd('Não há registros de validação nesta pré-visualização.'),
    onLiberarReaplicacao: (m: string) => setMsgProd(`Na aplicação real, a matrícula ${m} teria a avaliação anterior arquivada e poderia responder novamente — a nova aplicação receberia o número seguinte, e a anterior continuaria consultável no histórico.`),
    /* Operações de servidor não têm equivalente aqui: a demo calcula tudo em
       memória e não guarda resultado derivado nenhum para regravar. */
    onPreviaRecalculo: () => setMsgProd('O recálculo reprocessa a tabela de resultados do banco. Não há o que recalcular nesta pré-visualização, que calcula tudo em memória a cada abertura.'),
    onRecalcular: () => setMsgProd('Disponível apenas na aplicação real.'),
    previaRecalculo: null,
    onCancelarRecalculo: () => {},
    resultadoRecalculo: null
  };

  const nav: [Aba, string][] = [
    ['participante', 'Participante'], ['organizacional', 'Visão geral'], ['equipe', 'Equipes'],
    ['comparativo', 'Comparativo'], ['animais', 'Animais'], ['pessoas', 'Pessoas e resultados'],
    ['metodologia', 'Metodologia'], ['siglas', 'Siglas'], ['dados', 'Gestão de dados']
  ];

  const minhaComparacao = meu
    ? compararComEquipe(vetorDe(meu.resultado), membros.filter(m => m.setor === meu.setor && m.id !== meu.participanteId))
    : null;

  return (
    <>
      <DefinicoesAnimais />
      <header className="topo">
        <div className="wrap">
          {/* O arquivo oficial vem embutido: a pré-visualização precisa
              funcionar sem servidor. */}
          <Marca origem={MARCA_DATA_URI} />
          <div className="divisor-marca" />
          <div style={{ minWidth: 0 }}>
            <div className="marca">
              <span>Pré-visualização de desenvolvimento</span>
              <span aria-hidden="true">·</span>
              <span>Instrumento Piloto de Desenvolvimento Organizacional</span>
              <span aria-hidden="true">·</span>
              <span>{VERSAO_INSTRUMENTO}</span>
            </div>
            <h1 style={{ marginTop: 4 }}>Mapeamento da Diversidade Psicológica, Comportamental e Funcional das Equipes</h1>
          </div>
          <nav className="nav">
            {nav.map(([k, l]) => <button key={k} aria-current={aba === k} onClick={() => { setAba(k); setVerPessoa(null); }}>{l}</button>)}
          </nav>
        </div>
      </header>

      <main className="wrap" style={{ paddingTop: 20, paddingBottom: 30 }}>
        <div className="aviso a-alerta" style={{ marginTop: 0 }}>
          <strong>Este arquivo é a pré-visualização de desenvolvimento, não a aplicação organizacional</strong>
          <div>
            Ele executa <b>exatamente o mesmo código</b> da aplicação — as 48 questões, o algoritmo determinístico
            das duas trilhas, o IDF, o ICF e a geração real do Excel — mas sobre um repositório em memória, com{' '}
            <b>{concluidas.length} avaliações de amostra</b> em {setores.length} equipes
            ({concluidas.reduce((s, r) => s + r.respostas.length, 0).toLocaleString('pt-BR')} respostas brutas), para
            que se possa percorrer todas as telas sem banco.
            <br />
            <b>A versão de aplicação organizacional é a aplicação Next.js + Supabase</b>, publicada em servidor:
            lá os dados ficam no PostgreSQL, nada fictício é criado, o acesso é controlado por Row Level Security
            e cada operação é auditada. Consulte <code>IMPLANTACAO.md</code>.
          </div>
        </div>

        {aba === 'participante' && (
          <>
            {etapa === 'ident' && <TelaIdentificacao setores={setores} onIniciar={iniciar} erro={erroIdent} />}
            {etapa === 'quest' && atual && (
              <>
                <Aviso tipo="info" titulo="Salvamento incremental e retomada">
                  Cada resposta é persistida no momento da escolha — em produção, uma linha na tabela <code>respostas</code>,
                  com a chave de pontuação congelada. Respostas gravadas nesta sessão: <b>{gravadas}</b>.
                  Volte à identificação e informe a mesma matrícula para ver a retomada funcionando.
                </Aviso>
                <TelaQuestionario
                  semente={atual.matricula}
                  respostasIniciais={rascunho[atual.matricula] ?? {}}
                  onSalvarResposta={salvarResposta}
                  onConcluir={concluir}
                />
                <div style={{ textAlign: 'center', marginTop: 12 }}>
                  <button className="btn btn-sec" onClick={() => setEtapa('ident')}>Sair e continuar depois</button>
                </div>
              </>
            )}
            {etapa === 'result' && meu && (
              <>
                <Aviso tipo="info" titulo="Registro gravado">
                  A avaliação de <b>{meu.nome}</b> ({meu.matricula} — {meu.setor}) foi armazenada com as 48 respostas brutas
                  e já compõe as análises.
                  <button className="btn btn-sec" style={{ marginLeft: 12, padding: '5px 12px', fontSize: 12.5 }}
                    onClick={() => { setEtapa('ident'); setAtual(null); setMeu(null); }}>Responder como outra pessoa</button>
                </Aviso>
                <TelaResultado r={meu.resultado} comparacao={minhaComparacao}
                  dados={{ nome: meu.nome, setor: meu.setor, data: meu.concluidaEm }} />
              </>
            )}
          </>
        )}

        {aba === 'organizacional' && (
          <TelaVisaoOrganizacional animais={composicaoAnimais(membros, 'Organização')} a={geral} resumo={{
            totalParticipantes: regs.length, concluidas: concluidas.length,
            incompletas: Object.keys(rascunho).length, setores: setores.length
          }} />
        )}

        {aba === 'equipe' && (
          <>
            <Card>
              <div style={{ display: 'flex', gap: 12, alignItems: 'center', flexWrap: 'wrap' }}>
                <label htmlFor="f-equipe" style={{ margin: 0 }}>Equipe</label>
                <div style={{ width: 260 }}>
                  <select id="f-equipe" value={setorSel} onChange={e => setSetorSel(e.target.value)}>
                    {setores.map(s => <option key={s} value={s}>{s} ({membros.filter(m => m.setor === s).length})</option>)}
                  </select>
                </div>
                <span style={{ fontSize: 12.5, color: '#7C756B' }}>
                  Experimente <b>SESMT</b> para ver o tratamento de grupos com menos de 5 respondentes.
                </span>
              </div>
            </Card>
            <TelaEquipe titulo={`Equipe ${setorSel}`} a={doSetor}
              animais={composicaoAnimais(membros.filter(m => m.setor === setorSel), setorSel)} />
          </>
        )}

        {aba === 'comparativo' && <TelaComparacao linhas={comparativo} />}

        {aba === 'animais' && <TelaAnimais m={matrizAnimais(membros)} filtros={[
          { rotulo: 'Equipe', valor: 'todas' },
          { rotulo: 'Status', valor: 'concluída' },
          { rotulo: 'Versão', valor: VERSAO_INSTRUMENTO }
        ]} />}

        {aba === 'pessoas' && (
          verPessoa ? (
            <>
              <button className="btn btn-sec" style={{ marginBottom: 14 }} onClick={() => setVerPessoa(null)}>← Voltar</button>
              <TelaLeituraExecutivaIndividual r={verPessoa.resultado}
                dados={{ nome: verPessoa.nome, matricula: verPessoa.matricula, setor: verPessoa.setor, data: verPessoa.concluidaEm }} />
            </>
          ) : (
            <TelaPessoas
              pessoas={concluidas.map(r => ({
                nome: r.nome, matricula: r.matricula, setor: r.setor,
                perfil: r.resultado.perfilPrincipal, secundario: r.resultado.perfilSecundario,
                data: r.concluidaEm, status: 'concluída', demo: r.isDemo
              }))}
              onAbrir={m => setVerPessoa(concluidas.find(r => r.matricula === m) ?? null)} />
          )
        )}

        {aba === 'metodologia' && (
          <TelaMetodologia qualidade={qualidade} matriz={MATRIZ_PONTUACAO} empates={empates} distribuicoes={{
            perfis: geral.distribuicaoPerfis.map(p => ({ nome: p.animal, n: p.n })),
            funcoes: geral.distribuicaoFuncoes.map(f => ({ nome: f.nome, n: f.n })),
            atitudes: geral.distribuicaoAtitudes.map(a => ({ nome: a.nome, n: a.n })),
            capacidades: CAPACIDADES.map(c => ({ nome: c.nome, media: geral.cobertura.find(x => x.capacidade === c.id)!.media }))
          }} />
        )}

        {aba === 'siglas' && <Glossario titulo="Leitura de todas as siglas do instrumento" />}

        {aba === 'dados' && (
          <TelaGestaoDados
            setores={setores} exportar={exportar} exportando={exportando}
            embutido={EMBUTIDO} erroExport={erroExport} arquivoPronto={arquivoPronto}
            previa={previa} onPrevia={abrirPrevia} onConfirmar={confirmarReset}
            resultadoReset={resultadoReset} logs={logs} producao={producao} />
        )}
      </main>

      <footer className="rod">
        <div className="wrap">
          <div>
            <b>Referenciais</b><br />
            Tipologia psicológica de C. G. Jung (cap. 16.5 de <i>Teorias da Personalidade: Freud, Reich, Jung</i>) &middot;
            simbolismo animal de <i>Os animais e a psique</i>, vol. 1 (Ramos et al., Summus, 2005) &middot;
            teoria dos papéis de equipe de Meredith Belbin, conforme Miranda &amp; Vasconcelos, <i>Pretexto</i> v.21 n.3, FUMEC, 2020.
          </div>
          <div>
            <b>Limites</b><br />
            Este instrumento representa tendências de autorrelato e possui finalidade de desenvolvimento organizacional.
            Não constitui diagnóstico psicológico, avaliação clínica ou instrumento psicométrico validado.
            Escores são relativos internos, não percentis. Os animais são metáforas didáticas.
            Não deve ser usado para seleção, promoção, transferência ou desligamento.
          </div>
        </div>
      </footer>
    </>
  );
}

const estilo = document.createElement('style');
estilo.textContent = ESTILOS;
document.head.appendChild(estilo);
createRoot(document.getElementById('root')!).render(<App />);
