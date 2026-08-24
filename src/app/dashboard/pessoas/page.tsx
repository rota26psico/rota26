import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { AcessoRestrito } from '@/components/AcessoRestrito';
import { Rodape } from '@/components/Rodape';
import { Pessoas } from './Pessoas';
import { ErroConsulta } from '@/components/ui';
import { carregarPessoas } from '@/lib/repo-supabase';

export const dynamic = 'force-dynamic';

export default async function Page() {
  const p = await papel();
  if (p === 'PARTICIPANTE') return <AcessoRestrito />;
  let pessoas: Awaited<ReturnType<typeof carregarPessoas>> | null = null;
  let erro: string | null = null;
  try { pessoas = await carregarPessoas(db() as any); }
  catch (e: any) { erro = e?.message ?? String(e); }

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        {erro || !pessoas ? <ErroConsulta detalhe={erro} /> : <Pessoas pessoas={pessoas} />}
      </main>
      <Rodape />
    </>
  );
}
