import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { AcessoRestrito } from '@/components/AcessoRestrito';
import { Rodape } from '@/components/Rodape';
import { TelaVisaoOrganizacional } from '@/components/views-gestao';
import { ErroConsulta } from '@/components/ui';
import { analisarEquipe } from '@/lib/aggregate';
import { composicaoAnimais } from '@/lib/animais';
import { carregarMembros, resumoOrganizacional } from '@/lib/repo-supabase';

export const dynamic = 'force-dynamic';

export default async function Page() {
  const p = await papel();
  if (p === 'PARTICIPANTE') return <AcessoRestrito />;
  const s = db() as any;

  /* Item 24 — falha de consulta e ausência de dados são coisas diferentes, e a
     tela diz qual das duas aconteceu. Uma exceção do banco nunca é convertida
     em "0 participantes". */
  let dados: { membros: Awaited<ReturnType<typeof carregarMembros>>; resumo: Awaited<ReturnType<typeof resumoOrganizacional>> } | null = null;
  let erro: string | null = null;
  try {
    // O RLS já restringe: o ADMIN_SETOR recebe apenas as linhas do próprio setor.
    const [membros, resumo] = await Promise.all([carregarMembros(s), resumoOrganizacional(s)]);
    dados = { membros, resumo };
  } catch (e: any) { erro = e?.message ?? String(e); }

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        {erro || !dados
          ? <ErroConsulta detalhe={erro} />
          : <TelaVisaoOrganizacional a={analisarEquipe(dados.membros)} resumo={dados.resumo}
              animais={composicaoAnimais(dados.membros, 'Organização')} />}
      </main>
      <Rodape />
    </>
  );
}
