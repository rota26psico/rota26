import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { MeuResultado } from './MeuResultado';

export const dynamic = 'force-dynamic';

export default function Page() {
  /* `papel()` não é chamado aqui de propósito: esta página é do participante, e
     o participante navega com sessão anônima. O Nav monta o menu público; quem
     for administrador e cair aqui continua vendo a própria devolutiva, porque
     administrador também pode ter respondido. */
  return (
    <>
      <Nav papel="PARTICIPANTE" />
      <main className="wrap" style={{ paddingTop: 24 }}>
        <MeuResultado />
      </main>
      <Rodape />
    </>
  );
}
