import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { GestaoCliente } from './GestaoCliente';
import { carregarLogs } from '@/lib/repo-supabase';

export const dynamic = 'force-dynamic';

export default async function Page({ searchParams }: { searchParams: { aba?: string } }) {
  const p = await papel();
  if (p !== 'MASTER') return (<><Nav papel={p} /><main className="wrap" style={{ paddingTop: 24 }}>
    <div className="aviso a-limite"><strong>Acesso restrito</strong><div>Área exclusiva do Administrador Master.</div></div>
  </main><Rodape /></>);
  const s = db() as any;
  const [{ data: setores }, logs] = await Promise.all([
    s.from('setores').select('codigo').eq('ativo', true).order('codigo'),
    carregarLogs(s)
  ]);
  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        <GestaoCliente setores={(setores ?? []).map((x: any) => x.codigo)} logsIniciais={logs}
          abaInicial={searchParams.aba} />
      </main>
      <Rodape />
    </>
  );
}
