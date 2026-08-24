import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { AcessoRestrito } from '@/components/AcessoRestrito';
import { Rodape } from '@/components/Rodape';
import { TelaAnimais } from '@/components/views-gestao';
import { ErroConsulta } from '@/components/ui';
import { matrizAnimais } from '@/lib/animais';
import { carregarMembros } from '@/lib/repo-supabase';
import { VERSAO_INSTRUMENTO } from '@/data/questions';

export const dynamic = 'force-dynamic';

/**
 * VISÃO ORGANIZACIONAL DOS ANIMAIS — Parte J.
 * O RLS já restringe: um ADMIN_SETOR recebe apenas as linhas do próprio setor,
 * e a matriz é montada sobre o que ele pode ver.
 */
export default async function Page({ searchParams }: { searchParams: { s?: string } }) {
  const p = await papel();
  if (p === 'PARTICIPANTE') return <AcessoRestrito />;
  let m: ReturnType<typeof matrizAnimais> | null = null;
  let erro: string | null = null;
  const setor = searchParams.s;

  try {
    const membros = await carregarMembros(db() as any, setor);
    m = matrizAnimais(membros);
  } catch (e: any) { erro = e?.message ?? String(e); }

  /* Item 59 — os filtros em vigor ficam declarados na tela. */
  const filtros = [
    { rotulo: 'Equipe', valor: setor ?? 'todas' },
    { rotulo: 'Status', valor: 'concluída' },
    { rotulo: 'Versão', valor: VERSAO_INSTRUMENTO },
    { rotulo: 'Origem', valor: 'produção (dados reais)' }
  ];

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        {erro || !m ? <ErroConsulta detalhe={erro} /> : <TelaAnimais m={m} filtros={filtros} />}
      </main>
      <Rodape />
    </>
  );
}
