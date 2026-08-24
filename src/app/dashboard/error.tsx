'use client';
/**
 * O QUE APARECE QUANDO /dashboard NÃO PODE SER ABERTO.
 *
 * Falta de permissão NÃO passa por aqui: as páginas comparam o papel e
 * devolvem <AcessoRestrito /> com HTTP 200. Esta fronteira é a rede de
 * segurança do que sobra — o que quebra de verdade — para que a pessoa receba
 * a linguagem da aplicação em vez da página de erro genérica do Next.
 *
 * A distinção é a do item 24: erro de consulta diz que os números não foram
 * lidos, nunca que não existem.
 */
import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { ErroConsulta } from '@/components/ui';

export default function Erro({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  return (
    <>
      <Nav papel="PARTICIPANTE" />
      <main className="wrap" style={{ paddingTop: 24 }}>
        <div style={{ maxWidth: 640 }}>
          <ErroConsulta detalhe={error.message} />
          <button className="btn btn-sec" style={{ marginTop: 14 }} onClick={reset}>Tentar de novo</button>
        </div>
      </main>
      <Rodape />
    </>
  );
}
