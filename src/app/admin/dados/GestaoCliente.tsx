'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { TelaGestaoDados, type AlvoReset, type PainelProducao, type ItemChecklistUI } from '@/components/views-gestao';
import {
  supabaseBrowser, previaReset, executarReset, registrarExportacao,
  contagemDemo, previaLimpezaDemo, limparDadosDemo, limparDadosTeste,
  liberarReaplicacao, CONFIRMACAO_LIMPEZA_DEMO,
  type ContagemDemo, type PreviaDemo
} from '@/lib/repo-supabase';
import { ROTULO_AMBIENTE, EM_PRODUCAO } from '@/lib/env';

const DESCR: Record<AlvoReset['escopo'], string> = {
  participante: 'Arquiva as avaliações, respostas e resultados do participante informado. Preserva o cadastro, as perguntas e todas as matrizes.',
  setor: 'Arquiva as avaliações, respostas e resultados de todos os participantes da equipe selecionada.',
  periodo: 'Arquiva as avaliações concluídas até a data informada.',
  demo: 'Arquiva apenas os registros marcados como demonstração. Todos os dados reais são preservados.',
  tudo: 'Arquiva TODAS as avaliações, respostas e resultados. Perguntas, alternativas, matrizes, animais, perfis, parâmetros funcionais, configuração Belbin, setores, administradores e versões são preservados.'
};

/** Uma página embutida em iframe tem o download iniciado por script bloqueado pelo navegador. */
function estaEmbutido() {
  if (typeof window === 'undefined') return false;
  try { return window.self !== window.top; } catch { return true; }
}

export function GestaoCliente({ setores, logsIniciais, abaInicial }: {
  setores: string[];
  logsIniciais: { data: string; usuario: string; acao: string; detalhe: string }[];
  abaInicial?: string;
}) {
  const db = supabaseBrowser();
  const router = useRouter();
  const [exportando, setExportando] = useState<string | null>(null);
  const [previa, setPrevia] = useState<AlvoReset | null>(null);
  const [resultadoReset, setResultadoReset] = useState<string | null>(null);
  const [logs, setLogs] = useState(logsIniciais);
  const [erroExport, setErroExport] = useState<string | null>(null);
  const [arquivoPronto, setArquivoPronto] = useState<{ nome: string; url: string; kb: number; embutido: boolean } | null>(null);

  /* ── Bloco de produção (itens 6 a 12, 17, 32, 33, 34) ── */
  const [contagem, setContagem] = useState<ContagemDemo | null>(null);
  const [previaDemo, setPreviaDemo] = useState<PreviaDemo | null>(null);
  const [resultadoDemo, setResultadoDemo] = useState<{ participantes: number; avaliacoes: number; respostas: number; restantes: number } | null>(null);
  const [checklist, setChecklist] = useState<ItemChecklistUI[] | null>(null);
  const [ocupado, setOcupado] = useState<string | null>(null);
  const [mensagem, setMensagem] = useState<string | null>(null);
  const [erroProd, setErroProd] = useState<string | null>(null);

  const recarregarContagem = () =>
    contagemDemo(db).then(setContagem).catch(e => setErroProd(e.message));

  useEffect(() => { recarregarContagem(); }, []);

  const exportar = async (tipo: string, setor?: string) => {
    setExportando(tipo);
    setErroExport(null);
    setArquivoPronto(null);
    try {
      const url = `/api/exportar?tipo=${encodeURIComponent(tipo)}${setor ? `&setor=${encodeURIComponent(setor)}` : ''}`;
      const res = await fetch(url);
      if (!res.ok) throw new Error(await res.text());
      const blob = await res.blob();
      if (!blob.size) throw new Error('O servidor devolveu um arquivo vazio.');
      const nome = res.headers.get('X-Nome-Arquivo') ?? `${tipo}.xlsx`;
      const objUrl = URL.createObjectURL(blob);

      // O elemento precisa estar no documento antes do clique, e a URL do blob
      // só pode ser revogada depois que o navegador terminou de gravar o arquivo.
      const a = document.createElement('a');
      a.href = objUrl; a.download = nome; a.rel = 'noopener';
      a.style.display = 'none';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      setTimeout(() => URL.revokeObjectURL(objUrl), 120000);

      setArquivoPronto({ nome, url: objUrl, kb: Math.round(blob.size / 1024), embutido: estaEmbutido() });
      await registrarExportacao(db, tipo, Number(res.headers.get('X-Registros') ?? 0), { setor: setor ?? null });
      router.refresh();
    } catch (e: any) { setErroExport(`Falha ao gerar a planilha: ${e?.message ?? e}`); }
    finally { setExportando(null); }
  };

  const onPrevia = async (escopo: AlvoReset['escopo'], param?: string) => {
    setResultadoReset(null);
    try {
      const c = await previaReset(db, escopo, param);
      setPrevia({ escopo, ...c, descricao: DESCR[escopo] });
    } catch (e: any) { setResultadoReset(e.message); }
  };

  const onConfirmar = async (escopo: AlvoReset['escopo'], param?: string) => {
    try {
      const n = await executarReset(db, escopo, param, escopo === 'tudo' ? 'ZERAR RESULTADOS' : undefined);
      setPrevia(null);
      setResultadoReset(`${n} avaliação(ões) arquivada(s). Perguntas, matrizes, perfis, setores e versões permanecem intactos. A operação foi registrada na auditoria.`);
      setLogs(l => [{ data: new Date().toISOString(), usuario: 'você', acao: 'RESET', detalhe: `${escopo}${param ? ' · ' + param : ''} · ${n} registro(s)` }, ...l]);
      router.refresh();
    } catch (e: any) { setResultadoReset(e.message); }
  };

  /* ── Item 7 — prévia da limpeza DEMO ── */
  const onPreviaDemo = async () => {
    setOcupado('previa'); setErroProd(null); setMensagem(null); setResultadoDemo(null);
    try { setPreviaDemo(await previaLimpezaDemo(db)); }
    catch (e: any) { setErroProd(e.message); }
    finally { setOcupado(null); }
  };

  /* ── Itens 9 a 12 — execução da limpeza DEMO ── */
  const onLimparDemo = async (confirmacao: string) => {
    if (confirmacao !== CONFIRMACAO_LIMPEZA_DEMO) {
      setErroProd(`Confirmação inválida. Digite exatamente ${CONFIRMACAO_LIMPEZA_DEMO}.`);
      return;
    }
    setOcupado('limpeza'); setErroProd(null); setMensagem(null);
    try {
      const r = await limparDadosDemo(db, confirmacao);
      setResultadoDemo(r);
      setPreviaDemo(null);
      setLogs(l => [{
        data: new Date().toISOString(), usuario: 'você', acao: 'LIMPEZA_DEMO',
        detalhe: `demo · ${r.participantes} participante(s), ${r.avaliacoes} avaliação(ões), ${r.respostas} resposta(s)`
      }, ...l]);
      await recarregarContagem();
      setChecklist(null);        // o checklist anterior deixou de valer
      router.refresh();          // itens 10.8 e 10.9 — dashboards recalculados
    } catch (e: any) { setErroProd(e.message); }
    finally { setOcupado(null); }
  };

  /* ── Itens 32 e 33 — preparação e checklist ── */
  const onPreparar = async () => {
    setOcupado('preparo'); setErroProd(null); setMensagem(null);
    try {
      const res = await fetch('/api/preparar', { method: 'POST' });
      const j = await res.json();
      if (!res.ok) throw new Error(j?.erro ?? 'Não foi possível executar a verificação.');
      setChecklist(j.passos as ItemChecklistUI[]);
      await recarregarContagem();
      router.refresh();
    } catch (e: any) { setErroProd(e.message); }
    finally { setOcupado(null); }
  };

  /* ── Item 34 — remoção do registro de validação ── */
  const onLimparTeste = async () => {
    setOcupado('teste'); setErroProd(null);
    try {
      const n = await limparDadosTeste(db);
      setMensagem(`${n} registro(s) de validação removido(s). O banco não contém mais nenhuma avaliação artificial.`);
      await recarregarContagem();
      router.refresh();
    } catch (e: any) { setErroProd(e.message); }
    finally { setOcupado(null); }
  };

  /* ── Item 17 — liberação de reaplicação ── */
  const onLiberarReaplicacao = async (matricula: string) => {
    setOcupado('reaplicacao'); setErroProd(null); setMensagem(null);
    try {
      const n = await liberarReaplicacao(db, matricula);
      setMensagem(`Reaplicação liberada para a matrícula ${matricula}. ${n} avaliação(ões) anterior(es) foi(ram) arquivada(s) — as respostas continuam no banco, mas deixam de compor os indicadores atuais.`);
      setLogs(l => [{ data: new Date().toISOString(), usuario: 'você', acao: 'ALTERACAO_CONFIGURACAO', detalhe: `reaplicacao · ${matricula} · ${n} registro(s)` }, ...l]);
      router.refresh();
    } catch (e: any) { setErroProd(e.message); }
    finally { setOcupado(null); }
  };

  const producao: PainelProducao = {
    ambiente: ROTULO_AMBIENTE,
    emProducao: EM_PRODUCAO,
    contagem, previaDemo, resultadoDemo, checklist, ocupado, mensagem,
    erro: erroProd,
    onPreviaDemo, onLimparDemo, onPreparar, onLimparTeste, onLiberarReaplicacao,
    onCancelarPrevia: () => setPreviaDemo(null)
  };

  return (
    <TelaGestaoDados setores={setores} exportar={exportar} exportando={exportando}
      previa={previa} onPrevia={onPrevia} onConfirmar={onConfirmar}
      resultadoReset={resultadoReset} logs={logs} producao={producao}
      embutido={estaEmbutido()} erroExport={erroExport} arquivoPronto={arquivoPronto}
      abaInicial={abaInicial} />
  );
}
