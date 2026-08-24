import { papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { Glossario, Card, Aviso } from '@/components/ui';
import { GLOSSARIO } from '@/data/glossario';

export const dynamic = 'force-dynamic';

/**
 * LEITURA DAS SIGLAS — página aberta a todos os papéis.
 *
 * O participante vê os grupos que dizem respeito ao próprio resultado.
 * Administradores veem também os índices coletivos e os termos técnicos, que
 * não fazem parte da devolutiva individual.
 */
export default async function Page() {
  const p = await papel();
  const ehAdmin = p !== 'PARTICIPANTE';
  const grupos = ehAdmin
    ? (['indices', 'jung', 'perfis', 'eixos', 'capacidades', 'belbin', 'tecnicos'] as const)
    : (['jung', 'perfis', 'eixos', 'capacidades', 'belbin'] as const);

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24, maxWidth: 900 }}>
        <Card titulo="Leitura das siglas"
          sub="Toda abreviação usada no instrumento, com o significado e a razão de ter sido definida assim.">
          <p style={{ marginBottom: 0 }}>
            Cada verbete responde a três perguntas: <b>o que é</b>, <b>por que é assim</b> e
            <b> onde aparece</b>. A segunda é a que costuma faltar em instrumentos de perfil — e é a
            que permite discordar de um critério com conhecimento de causa.
          </p>
          <Aviso tipo="info" titulo="Quando um número foi escolhido, o verbete diz isso">
            Nem todo parâmetro veio de medição. O limiar de portador, por exemplo, é a metade da escala:
            plausível, declarado e ainda não validado com dados. Onde é esse o caso, está escrito.
          </Aviso>
        </Card>

        <Glossario grupos={grupos as any} titulo={`${GLOSSARIO.length} verbetes`} />
      </main>
      <Rodape />
    </>
  );
}
