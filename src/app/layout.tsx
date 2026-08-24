import type { Metadata } from 'next';
import { ESTILOS } from '@/components/ui';
import { DefinicoesAnimais } from '@/components/animais-svg';
import { MARCA } from '@/lib/env';

/** Itens 1 e 2 — identidade de aplicação organizacional, sem menção a demonstração. */
export const metadata: Metadata = {
  title: MARCA.tituloCurto,
  description: MARCA.descricao,
  applicationName: MARCA.tituloCurto,
  robots: { index: false, follow: false }   // instrumento interno: não indexar
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <head><style dangerouslySetInnerHTML={{ __html: ESTILOS }} /></head>
      <body>
        {/* Os oito símbolos são definidos UMA vez por documento. */}
        <DefinicoesAnimais />
        {children}
      </body>
    </html>
  );
}
