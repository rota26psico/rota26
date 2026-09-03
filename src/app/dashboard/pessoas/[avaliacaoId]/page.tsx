/**
 * O TESTE COMPLETO DE UMA PESSOA — rastreabilidade por aplicação
 * ---------------------------------------------------------------------------
 * Existe por três motivos, e cada um resolve uma limitação concreta:
 *
 *  1. Até aqui o detalhe de uma pessoa era ESTADO LOCAL do painel nominal: não
 *     tinha endereço, não podia ser aberto de novo, compartilhado com quem tem
 *     permissão, nem impresso sozinho. Agora tem URL, e é a URL da AVALIAÇÃO —
 *     não da pessoa —, porque é a avaliação que carrega respostas, data e
 *     resultado.
 *  2. O histórico de aplicações. `vw_resultados` mostra só a aplicação vigente,
 *     que é o correto para indicadores; aqui aparece a linha do tempo inteira,
 *     inclusive as arquivadas.
 *  3. As 48 situações com a alternativa escolhida. É o que permite conferir um
 *     resultado contestado sem pedir que a pessoa refaça o teste.
 *
 * SIGILO. A folha de respostas é montada com `QUESTOES` de `data/questions.ts`
 * — a camada pública, sem polo, eixo ou peso — cruzada com os códigos de
 * alternativa vindos de `carregarRespostas`, cujo `select` não pede a chave.
 * Nada nesta página importa `questions.server.ts`; se importasse, o build
 * falharia, e `npm run test:sigilo` varre o bundle atrás de vestígio.
 *
 * PERMISSÃO. Duas camadas, deliberadamente: a página só renderiza a folha de
 * respostas para o MASTER, e o RLS (`respostas_acesso`, 02_policies.sql) negaria
 * a leitura ao ADMIN_SETOR de qualquer forma. Se a tela esquecesse a checagem, o
 * banco ainda diria não — resposta item a item é dado sensível e só interessa à
 * análise psicométrica.
 *
 * O resultado é RECALCULADO a partir das respostas brutas, nunca lido de cache:
 * é a mesma prova de reprodutibilidade que o painel nominal já fazia.
 */
import Link from 'next/link';
import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { AcessoRestrito } from '@/components/AcessoRestrito';
import { Rodape } from '@/components/Rodape';
import { Card, ErroConsulta, Aviso, Tabela } from '@/components/ui';
import { dataHoraBR } from '@/lib/datas';
import { BotaoImprimir } from '@/components/BotaoImprimir';
import {
  TelaLeituraExecutivaIndividual, HistoricoAplicacoes, FolhaDeRespostas
} from '@/components/views-gestao';
import { carregarAplicacao, carregarAplicacoes, carregarRespostas } from '@/lib/repo-supabase';
import { recalcular } from '@/lib/repo-servidor';

export const dynamic = 'force-dynamic';

export default async function Page({ params }: { params: { avaliacaoId: string } }) {
  const p = await papel();
  if (p === 'PARTICIPANTE') return <AcessoRestrito ambito="Os resultados nominais" />;

  const s = db() as any;
  let dados: {
    aplicacao: Awaited<ReturnType<typeof carregarAplicacao>>;
    historico: Awaited<ReturnType<typeof carregarAplicacoes>>;
    resultado: Awaited<ReturnType<typeof recalcular>> | null;
    respostas: Awaited<ReturnType<typeof carregarRespostas>>;
  } | null = null;
  let erro: string | null = null;

  try {
    const aplicacao = await carregarAplicacao(s, params.avaliacaoId);
    if (aplicacao) {
      const [historico, respostas] = await Promise.all([
        carregarAplicacoes(s, aplicacao.participanteId),
        // Só o MASTER lê respostas brutas — nem vale a pena tentar como ADMIN_SETOR.
        p === 'MASTER' ? carregarRespostas(s, params.avaliacaoId) : Promise.resolve([])
      ]);
      const resultado = aplicacao.status === 'CONCLUIDA'
        ? await recalcular(s, params.avaliacaoId)
        : null;
      dados = { aplicacao, historico, resultado, respostas };
    } else {
      dados = { aplicacao: null, historico: [], resultado: null, respostas: [] };
    }
  } catch (e: any) { erro = e?.message ?? String(e); }

  const voltar = (
    <div className="nao-imprime" style={{ marginBottom: 14 }}>
      <Link className="btn btn-sec" href="/dashboard/pessoas">← Pessoas e resultados</Link>
    </div>
  );

  if (erro || !dados) {
    return (
      <>
        <Nav papel={p} />
        <main className="wrap" style={{ paddingTop: 24 }}>{voltar}<ErroConsulta detalhe={erro} /></main>
        <Rodape />
      </>
    );
  }

  const a = dados.aplicacao;

  /* Avaliação inexistente e avaliação que o RLS não libera chegam aqui do mesmo
     jeito — uma consulta sem linhas. A mensagem não distingue as duas de
     propósito: dizer "existe, mas você não pode ver" já é informação sobre
     alguém de outro setor. */
  if (!a) {
    return (
      <>
        <Nav papel={p} />
        <main className="wrap" style={{ paddingTop: 24 }}>
          {voltar}
          <Aviso tipo="limite" titulo="Avaliação não encontrada">
            Esta avaliação não existe ou não está no seu escopo de acesso. Administradores de setor
            enxergam apenas os participantes do próprio setor — a restrição é aplicada no banco, não na tela.
          </Aviso>
        </main>
        <Rodape />
      </>
    );
  }

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        {voltar}
        <BotaoImprimir
          titulo={`${a.nome} · aplicação ${String(a.numero).padStart(2, '0')}`}
          recorte={`${a.nome} (${a.matricula}) · ${a.setor}`}
          papel={p}
        >
          <Card titulo="Identificação e datas">
            <Tabela colunas={['Campo', 'Valor']} linhas={[
              [<b key="a">Nome</b>, a.nome],
              [<b key="b">Matrícula</b>, a.matricula],
              [<b key="c">Setor</b>, a.setor],
              [<b key="d">Aplicação</b>, `${String(a.numero).padStart(2, '0')}${a.vigente ? ' · vigente' : a.arquivadaEm ? ' · arquivada' : ''}`],
              [<b key="e">Versão do instrumento</b>, a.versao],
              [<b key="f">Iniciada em</b>, dataHoraBR(a.iniciadaEm)],
              [<b key="g">Concluída em</b>, dataHoraBR(a.concluidaEm)],
              [<b key="h">Respostas gravadas</b>, String(a.respostasGravadas)]
            ]} />
          </Card>

          <HistoricoAplicacoes aplicacoes={dados.historico} atual={a.avaliacaoId} />

          {dados.resultado
            ? <TelaLeituraExecutivaIndividual r={dados.resultado}
                dados={{ nome: a.nome, matricula: a.matricula, setor: a.setor, data: a.concluidaEm ?? a.iniciadaEm ?? '' }} />
            : <Aviso tipo="info" titulo="Aplicação em andamento">
                Esta aplicação ainda não foi concluída, então não há resultado a exibir. As respostas já
                gravadas continuam salvas e a pessoa pode retomar de onde parou.
              </Aviso>}

          {p === 'MASTER'
            ? <FolhaDeRespostas respostas={dados.respostas} />
            : <Aviso tipo="limite" titulo="Respostas item a item — restritas ao Administrador Master">
                As 48 escolhas individuais não são exibidas a administradores de setor. É uma restrição
                aplicada no banco (<code>respostas_acesso</code>), não na tela: respostas item a item são dado
                sensível e existem para conferência e análise psicométrica, não para leitura sobre a pessoa.
              </Aviso>}
        </BotaoImprimir>
      </main>
      <Rodape />
    </>
  );
}
