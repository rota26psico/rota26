import Link from 'next/link';
import { Nav } from './Nav';
import { Rodape } from './Rodape';
import { Aviso } from './ui';

/**
 * A TELA DE QUEM NÃO TEM PERMISSÃO — e por que ela não é um erro.
 *
 * Com a aplicação publicada, qualquer visitante pode digitar /dashboard. Isso
 * é uso normal, não defeito: a resposta correta é explicar e oferecer o
 * caminho, com HTTP 200. Deixar `exigirAdmin()` lançar devolvia **500**, que
 * diz "o servidor quebrou" para quem apenas não é administrador — e enche o
 * monitoramento de falhas que não existem.
 *
 * Mesmo padrão que `/admin/dados` já usava. A fronteira de erro em
 * `dashboard/error.tsx` continua existindo para o que é falha de verdade.
 */
export function AcessoRestrito({ ambito = 'Os painéis de equipe' }: { ambito?: string }) {
  return (
    <>
      <Nav papel="PARTICIPANTE" />
      <main className="wrap" style={{ paddingTop: 24 }}>
        <div style={{ maxWidth: 640 }}>
          <Aviso tipo="limite" titulo="Acesso restrito">
            {ambito} são visíveis apenas a administradores autorizados. A restrição é aplicada no
            banco por Row Level Security, não apenas nesta tela.
          </Aviso>
          <div style={{ display: 'flex', gap: 10, marginTop: 14 }}>
            <Link href="/entrar"><button className="btn btn-marca">Entrar como administrador</button></Link>
            <Link href="/questionario"><button className="btn btn-sec">Ir para minha avaliação</button></Link>
          </div>
        </div>
      </main>
      <Rodape />
    </>
  );
}
