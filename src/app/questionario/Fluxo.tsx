'use client';
/**
 * FLUXO REAL DO PARTICIPANTE — Supabase / PostgreSQL
 * ---------------------------------------------------------------------------
 * Item 14 — o banco é a fonte oficial. Nenhum resultado depende de estado
 *   React ou de memória do navegador.
 * Item 15 — cada escolha é gravada no banco no instante em que é feita.
 * Item 16 — se existir avaliação em andamento, a aplicação PERGUNTA antes de
 *   retomar, e reabre na primeira questão sem resposta.
 * Item 17 — matrícula com avaliação concluída NÃO inicia outra em silêncio.
 * Item 19 — a finalização é transacional: o resultado é calculado no servidor a
 *   partir das respostas relidas do banco e a avaliação só vira CONCLUIDA
 *   depois que todos os derivados estão gravados e conferidos.
 * Item 21 — "Você na sua equipe" consulta apenas avaliações reais concluídas.
 */
import { useEffect, useState } from 'react';
import {
  TelaIdentificacao, TelaQuestionario, TelaResultado, TelaRetomada, TelaJaConcluida
} from '@/components/views-participante';
import { Aviso, ErroConsulta } from '@/components/ui';
import { BotaoImprimir } from '@/components/BotaoImprimir';
import {
  supabaseBrowser, garantirSessao, listarSetores, garantirParticipante, validarCadastro,
  abrirAvaliacao, carregarMembros, registrarEvento, type EstadoAvaliacao
} from '@/lib/repo-supabase';
/* Estas quatro passam pelo servidor: dependem da chave de pontuação, que não
   pode chegar ao navegador. A sessão continua sendo a do participante. */
import { consultarAvaliacao, gravarResposta, concluirAvaliacao } from '@/lib/avaliacao-cliente';
import { compararComEquipe, type ComparacaoIndividuo } from '@/lib/aggregate';
import { vetorDe, type ResultadoIndividual, type Resposta } from '@/lib/resultado';
import { QUESTOES } from '@/data/questions';

type Etapa = 'ident' | 'retomar' | 'concluida' | 'quest' | 'result';

export function Fluxo() {
  const db = supabaseBrowser();
  const [setores, setSetores] = useState<{ id: string; codigo: string }[]>([]);
  const [erroSetores, setErroSetores] = useState<string | null>(null);
  const [etapa, setEtapa] = useState<Etapa>('ident');
  const [ident, setIdent] = useState<{ nome: string; matricula: string; setor: string } | null>(null);
  const [participanteId, setParticipanteId] = useState<string | null>(null);
  const [estado, setEstado] = useState<EstadoAvaliacao | null>(null);
  const [avaliacaoId, setAvaliacaoId] = useState<string | null>(null);
  const [resultado, setResultado] = useState<ResultadoIndividual | null>(null);
  const [comparacao, setComparacao] = useState<ComparacaoIndividuo | null>(null);
  const [dataConclusao, setDataConclusao] = useState<string>('');
  const [erro, setErro] = useState<string | null>(null);
  const [salvando, setSalvando] = useState(false);
  const [ocupado, setOcupado] = useState(false);

  /* A sessão vem ANTES da primeira consulta: sem ela o RLS devolve zero setores
     e a tela mostraria "Nenhum setor" como se o banco estivesse vazio. */
  useEffect(() => {
    garantirSessao(db)
      .then(() => listarSetores(db))
      .then(s => { setSetores(s); setErroSetores(null); })
      .catch(e => setErroSetores(e.message));
  }, []);

  const carregarComparacao = async (r: ResultadoIndividual, setor: string, pid?: string) => {
    try {
      const equipe = await carregarMembros(db, setor);
      setComparacao(compararComEquipe(vetorDe(r), equipe.filter(m => m.id !== pid)));
    } catch { setComparacao(null); }
  };

  /* Identificação → decide qual das três situações apresentar. Não grava
     avaliação nenhuma neste passo. */
  const identificar = async (d: { nome: string; matricula: string; setor: string }) => {
    setErro(null); setOcupado(true);
    try {
      const problema = validarCadastro(d);
      if (problema) throw new Error(problema);
      const s = setores.find(x => x.codigo === d.setor);
      if (!s) throw new Error('Setor não encontrado. Recarregue a página e tente novamente.');

      const pid = await garantirParticipante(db, { nome: d.nome, matricula: d.matricula, setorId: s.id });
      const est = await consultarAvaliacao(pid);
      setIdent(d); setParticipanteId(pid); setEstado(est);
      await registrarEvento(db, 'LOGIN', 'participante', d.matricula, 1, { situacao: est.situacao });

      if (est.situacao === 'concluida' && est.resultado) {
        setResultado(est.resultado);
        setDataConclusao(est.concluidaEm ?? '');
        setEtapa('concluida');
      } else if (est.situacao === 'em_andamento') {
        setAvaliacaoId(est.avaliacaoId);
        setEtapa('retomar');
      } else {
        const novo = await abrirAvaliacao(db, pid);
        setAvaliacaoId(novo);
        setEtapa('quest');
      }
    } catch (e: any) { setErro(e.message ?? String(e)); }
    finally { setOcupado(false); }
  };

  const salvar = async (r: Resposta, posicao: number) => {
    if (!avaliacaoId) return;
    setSalvando(true);
    try { await gravarResposta(avaliacaoId, r, posicao); setErro(null); }
    catch (e: any) { setErro(`Sua resposta não foi salva: ${e.message}. Verifique a conexão e escolha novamente.`); }
    finally { setSalvando(false); }
  };

  const concluir = async () => {
    if (!avaliacaoId || !ident) return;
    setSalvando(true); setErro(null);
    try {
      const r = await concluirAvaliacao(avaliacaoId);
      setResultado(r);
      setDataConclusao(new Date().toISOString());
      await carregarComparacao(r, ident.setor, participanteId ?? undefined);
      setEtapa('result');
    } catch (e: any) { setErro(e.message ?? String(e)); }
    finally { setSalvando(false); }
  };

  const verResultado = async () => {
    if (!resultado || !ident) return;
    await carregarComparacao(resultado, ident.setor, participanteId ?? undefined);
    setEtapa('result');
  };

  const primeiraPendente = estado
    ? Math.max(0, QUESTOES.findIndex(q => !estado.respostasSalvas[q.id])) + 1
    : 1;

  return (
    <>
      {etapa === 'ident' && (
        <>
          {erroSetores && <ErroConsulta detalhe={erroSetores} />}
          <TelaIdentificacao setores={setores.map(s => s.codigo)} onIniciar={identificar} erro={erro} />
        </>
      )}

      {etapa === 'retomar' && ident && estado && (
        <TelaRetomada nome={ident.nome} respondidas={estado.respondidas} proxima={primeiraPendente}
          ocupado={ocupado} onContinuar={() => setEtapa('quest')} />
      )}

      {etapa === 'concluida' && ident && (
        <TelaJaConcluida nome={ident.nome} data={dataConclusao} aplicacao={estado?.aplicacao}
          podeVerResultado={!!resultado} onVerResultado={verResultado} />
      )}

      {etapa === 'quest' && ident && (
        <TelaQuestionario semente={ident.matricula} respostasIniciais={estado?.respostasSalvas ?? {}}
          onSalvarResposta={salvar} onConcluir={concluir} salvando={salvando} erro={erro} />
      )}

      {etapa === 'result' && resultado && ident && (
        /* O relatório individual em PDF sai pela impressão do navegador, como o
           painel: o papel é exatamente o que está na tela, sem uma segunda rota
           de renderização que pudesse divergir dos números exibidos. */
        <BotaoImprimir titulo="Seu resultado" recorte={ident.nome} papel="PARTICIPANTE">
          {estado?.situacao === 'concluida' && (
            <Aviso tipo="info" titulo="Resultado já registrado">
              Este resultado foi recalculado agora a partir das suas 48 respostas gravadas no banco.
            </Aviso>
          )}
          <TelaResultado r={resultado} comparacao={comparacao}
            dados={{ nome: ident.nome, setor: ident.setor, data: dataConclusao }} />
          <div className="nao-imprime" style={{ marginTop: 18 }}>
            <Aviso tipo="info" titulo="Para reler isto depois">
              Você não precisa responder de novo para ver seu resultado outra vez. Basta abrir
              <b> Meu resultado</b> e informar os mesmos dados — ele é recalculado a partir das suas
              respostas guardadas, e por isso é sempre o mesmo.
            </Aviso>
            <a className="btn btn-sec" href="/meu-resultado">Meu resultado</a>
          </div>
        </BotaoImprimir>
      )}
    </>
  );
}
