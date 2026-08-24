import Link from 'next/link';
import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { AcessoRestrito } from '@/components/AcessoRestrito';
import { Rodape } from '@/components/Rodape';
import { TelaEquipe } from '@/components/views-gestao';
import { ErroConsulta, Card, Vazio } from '@/components/ui';
import { analisarEquipe } from '@/lib/aggregate';
import { composicaoAnimais } from '@/lib/animais';
import { carregarMembros } from '@/lib/repo-supabase';

export const dynamic = 'force-dynamic';

export default async function Page({ searchParams }: { searchParams: { s?: string } }) {
  const p = await papel();
  if (p === 'PARTICIPANTE') return <AcessoRestrito />;
  const s = db() as any;

  let setores: any[] = [];
  let membros: Awaited<ReturnType<typeof carregarMembros>> | null = null;
  let sel = '';
  let erro: string | null = null;
  try {
    const { data, error } = await s.from('setores').select('codigo').eq('ativo', true).order('codigo');
    if (error) throw error;
    setores = data ?? [];
    sel = searchParams.s ?? setores[0]?.codigo ?? '';
    membros = sel ? await carregarMembros(s, sel) : [];
  } catch (e: any) { erro = e?.message ?? String(e); }

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        {erro || !membros ? <ErroConsulta detalhe={erro} /> : (
          <>
            {/* Item 32 — uma barra de filtros só, no topo, em vez de selects
                espalhados pela página. */}
            <div className="barra-filtros">
              <span className="campo-f" style={{ fontWeight: 700, letterSpacing: '.12em', textTransform: 'uppercase', fontSize: 10.5 }}>Equipe</span>
              {setores.map((x: any) => (
                <Link key={x.codigo} href={`/dashboard/equipe?s=${encodeURIComponent(x.codigo)}`}>
                  <button className={x.codigo === sel ? 'btn' : 'btn btn-sec'}
                    style={{ padding: '6px 13px', fontSize: 12.5 }}>{x.codigo}</button>
                </Link>
              ))}
              <span className="fixo" style={{ marginLeft: 'auto' }}>Status: <b>Concluídas</b></span>
              <span className="fixo">Versão: <b>Atual</b></span>
              <span className="fixo">Origem: <b>Produção</b></span>
            </div>
            {sel
              ? <TelaEquipe titulo={`Equipe ${sel}`} a={analisarEquipe(membros)} animais={composicaoAnimais(membros, sel)} />
              : <Card titulo="Equipes"><Vazio titulo="Nenhum setor ativo cadastrado.">
                  Cadastre os setores ou contratos antes de aplicar o instrumento.
                </Vazio></Card>}
          </>
        )}
      </main>
      <Rodape />
    </>
  );
}
