'use client';
/**
 * REVISITAR O PRÓPRIO RESULTADO — sem refazer o teste
 * ---------------------------------------------------------------------------
 * O resultado nunca precisou ser refeito para ser lido de novo: ele é
 * RECALCULADO a partir das 48 respostas gravadas, com a chave congelada no
 * instante de cada escolha. O que faltava era um endereço para isso. Até aqui,
 * a única porta era recomeçar o percurso em `/questionario` e esbarrar na tela
 * "sua avaliação já foi concluída" — que oferece o resultado, mas depois de
 * pedir de novo os dados de quem quer apenas reler o que já respondeu.
 *
 * Também mostra o HISTÓRICO: quem respondeu mais de uma vez consegue abrir
 * qualquer aplicação anterior, e não só a vigente. Uma reaplicação arquiva a
 * leitura anterior para os indicadores — não a apaga.
 *
 * ALCANCE DO ACESSO — declarado, não escondido. A identificação aqui é a mesma
 * do percurso: nome, matrícula e setor. Não é autenticação. Quem souber a
 * matrícula de um colega alcança o resultado dele, e isso já valia antes desta
 * página existir (`TelaJaConcluida` faz o mesmo). O fecho — código de acesso
 * pessoal ou link por e-mail — está registrado como decisão pendente no item 8
 * de SUGESTOES_NAO_IMPLEMENTADAS.md. Enquanto não for tomada, esta tela não
 * expõe nada que a anterior já não expusesse, e o aviso abaixo diz isso a quem
 * usa.
 */
import { useEffect, useState } from 'react';
import { TelaIdentificacao, TelaResultado } from '@/components/views-participante';
import { HistoricoAplicacoes } from '@/components/views-gestao';
import { Aviso, Card, ErroConsulta, Carregando } from '@/components/ui';
import { BotaoImprimir } from '@/components/BotaoImprimir';
import {
  supabaseBrowser, garantirSessao, listarSetores, garantirParticipante, validarCadastro,
  carregarMembros, type Aplicacao
} from '@/lib/repo-supabase';
import { consultarAvaliacao, recalcular, listarAplicacoes } from '@/lib/avaliacao-cliente';
import { compararComEquipe, type ComparacaoIndividuo } from '@/lib/aggregate';
import { vetorDe, type ResultadoIndividual } from '@/lib/resultado';

type Etapa = 'ident' | 'resultado' | 'sem-resultado';

export function MeuResultado() {
  const db = supabaseBrowser();
  const [setores, setSetores] = useState<{ id: string; codigo: string }[]>([]);
  const [erroSetores, setErroSetores] = useState<string | null>(null);
  const [etapa, setEtapa] = useState<Etapa>('ident');
  const [ident, setIdent] = useState<{ nome: string; matricula: string; setor: string } | null>(null);
  const [participanteId, setParticipanteId] = useState<string | null>(null);
  const [aplicacoes, setAplicacoes] = useState<Aplicacao[]>([]);
  const [aberta, setAberta] = useState<string | null>(null);
  const [resultado, setResultado] = useState<ResultadoIndividual | null>(null);
  const [comparacao, setComparacao] = useState<ComparacaoIndividuo | null>(null);
  const [dataConclusao, setDataConclusao] = useState('');
  const [erro, setErro] = useState<string | null>(null);
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

  const identificar = async (d: { nome: string; matricula: string; setor: string }) => {
    setErro(null); setOcupado(true);
    try {
      const problema = validarCadastro(d);
      if (problema) throw new Error(problema);
      const s = setores.find(x => x.codigo === d.setor);
      if (!s) throw new Error('Setor não encontrado. Recarregue a página e tente novamente.');

      const pid = await garantirParticipante(db, { nome: d.nome, matricula: d.matricula, setorId: s.id });
      const [estado, lista] = await Promise.all([consultarAvaliacao(pid), listarAplicacoes(pid)]);
      setIdent(d); setParticipanteId(pid); setAplicacoes(lista);

      if (estado.situacao === 'concluida' && estado.resultado) {
        setResultado(estado.resultado);
        setDataConclusao(estado.concluidaEm ?? '');
        setAberta(estado.avaliacaoId);
        await carregarComparacao(estado.resultado, d.setor, pid);
        setEtapa('resultado');
      } else {
        setEtapa('sem-resultado');
      }
    } catch (e: any) { setErro(e.message ?? String(e)); }
    finally { setOcupado(false); }
  };

  /* Abrir uma aplicação anterior. O resultado é recalculado das respostas
     daquela aplicação — nunca lido de cache — então uma leitura antiga continua
     reproduzível mesmo depois de arquivada. */
  const abrir = async (avaliacaoId: string) => {
    if (!ident) return;
    setOcupado(true); setErro(null);
    try {
      const r = await recalcular(avaliacaoId);
      const a = aplicacoes.find(x => x.avaliacaoId === avaliacaoId);
      setResultado(r);
      setAberta(avaliacaoId);
      setDataConclusao(a?.concluidaEm ?? '');
      await carregarComparacao(r, ident.setor, participanteId ?? undefined);
      setEtapa('resultado');
    } catch (e: any) { setErro(e.message ?? String(e)); }
    finally { setOcupado(false); }
  };

  const concluidas = aplicacoes.filter(a => a.status === 'CONCLUIDA');
  const aplicacaoAberta = aplicacoes.find(a => a.avaliacaoId === aberta);

  if (etapa === 'ident') {
    return (
      <>
        {erroSetores && <ErroConsulta detalhe={erroSetores} />}
        <TelaIdentificacao modo="revisitar" setores={setores.map(s => s.codigo)} onIniciar={identificar} erro={erro} />
        {ocupado && <Carregando />}
      </>
    );
  }

  if (etapa === 'sem-resultado') {
    return (
      <div style={{ maxWidth: 640, margin: '0 auto' }}>
        <Card titulo="Ainda não há resultado para esta matrícula" sub={ident?.nome}>
          <p style={{ fontSize: 15 }}>
            {aplicacoes.length === 0
              ? 'Nenhuma avaliação foi iniciada com estes dados.'
              : 'Existe uma avaliação em andamento, mas ela ainda não foi finalizada — o resultado só é gerado depois das 48 situações.'}
          </p>
          <a className="btn" href="/questionario">
            {aplicacoes.length === 0 ? 'Responder agora' : 'Retomar de onde parei'}
          </a>
        </Card>
      </div>
    );
  }

  return (
    <>
      {erro && <ErroConsulta detalhe={erro} />}

      {concluidas.length > 1 && (
        <div className="nao-imprime">
          <HistoricoAplicacoes
            aplicacoes={aplicacoes.map(a => ({
              avaliacaoId: a.avaliacaoId, numero: a.numero, versao: a.versao, status: a.status,
              iniciadaEm: a.iniciadaEm, concluidaEm: a.concluidaEm, arquivadaEm: a.arquivadaEm,
              vigente: a.vigente, perfilPrincipal: a.perfilPrincipal, perfilSecundario: a.perfilSecundario,
              respostasGravadas: a.respostasGravadas
            }))}
            atual={aberta ?? undefined}
            onAbrir={abrir} />
        </div>
      )}

      {resultado && ident && (
        <BotaoImprimir
          titulo="Seu resultado"
          recorte={concluidas.length > 1 && aplicacaoAberta
            ? `${ident.nome} · aplicação ${String(aplicacaoAberta.numero).padStart(2, '0')}`
            : ident.nome}
          papel="PARTICIPANTE"
        >
          <Aviso tipo="info" titulo="Resultado já registrado">
            Este resultado foi recalculado agora a partir das suas 48 respostas gravadas no banco
            {aplicacaoAberta && concluidas.length > 1
              ? <> — aplicação {String(aplicacaoAberta.numero).padStart(2, '0')} de {concluidas.length}</>
              : null}.
          </Aviso>
          <TelaResultado r={resultado} comparacao={comparacao}
            dados={{ nome: ident.nome, setor: ident.setor, data: dataConclusao }} />
        </BotaoImprimir>
      )}
    </>
  );
}
