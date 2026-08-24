import { papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { Entrar } from './Entrar';

export const dynamic = 'force-dynamic';

export default async function Page() {
  const p = await papel();
  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}><Entrar /></main>
      <Rodape />
    </>
  );
}
