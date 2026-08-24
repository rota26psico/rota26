import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { AcessoRestrito } from '@/components/AcessoRestrito';
import { Rodape } from '@/components/Rodape';
import { TelaComparacao } from '@/components/views-gestao';
import { ErroConsulta } from '@/components/ui';
import { compararSetores, type MembroAgregado } from '@/lib/aggregate';
import { carregarMembros } from '@/lib/repo-supabase';

export const dynamic = 'force-dynamic';

export default async function Page() {
  const p = await papel();
  if (p === 'PARTICIPANTE') return <AcessoRestrito />;

  let linhas: ReturnType<typeof compararSetores> | null = null;
  let erro: string | null = null;
  try {
    const membros = await carregarMembros(db() as any);
    const grupos: Record<string, MembroAgregado[]> = {};
    for (const m of membros) (grupos[m.setor] ||= []).push(m);
    linhas = compararSetores(grupos);
  } catch (e: any) { erro = e?.message ?? String(e); }

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        {erro || !linhas ? <ErroConsulta detalhe={erro} /> : <TelaComparacao linhas={linhas} />}
      </main>
      <Rodape />
    </>
  );
}
