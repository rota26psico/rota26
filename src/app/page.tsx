import Link from 'next/link';
import { papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { Marca, TracoRota, Card, Aviso } from '@/components/ui';
import { AVISO_GERAL } from '@/lib/narrative';
import { MARCA } from '@/lib/env';
import { PERFIS } from '@/data/profiles';

export const dynamic = 'force-dynamic';

/**
 * TELA DE ABERTURA (item 10).
 * Abertura escura de impacto, texto curto, um único botão. À direita, o lugar
 * do selo circular dos oito animais — enquanto ele não chega, a composição é
 * sustentada pelos oito nomes em disco, que já dizem do que se trata.
 */
export default async function Home() {
  const p = await papel();
  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 22 }}>
        <section className="abertura">
          <TracoRota />
          <div className="dentro">
            <div className="col">
              <div className="rot">{MARCA.selo}</div>
              <h2>Mapeamento da diversidade<br />e complementaridade de equipes</h2>
              <p className="frase">
                Diferentes formas de perceber, decidir e contribuir constroem diferentes
                possibilidades para uma equipe.
              </p>
              <div style={{ display: 'flex', gap: 10, marginTop: 26, flexWrap: 'wrap' }}>
                <Link href="/questionario">
                  <button className="btn btn-marca">Iniciar percurso</button>
                </Link>
                {/* Quem já respondeu chega aqui querendo reler, não recomeçar. */}
                <Link href="/meu-resultado">
                  <button className="btn btn-sec">Já respondi — ver meu resultado</button>
                </Link>
              </div>
            </div>

            <div className="selo-lugar" aria-hidden="true">
              <div className="selo-anel">
                {PERFIS.map((x, i) => (
                  <span key={x.id} style={{ ['--i' as any]: i, ['--n' as any]: PERFIS.length }}>
                    {x.animal}
                  </span>
                ))}
                <em>Ψ</em>
              </div>
            </div>
          </div>
        </section>

        <div className="grid g3">
          <Card titulo="48 situações de trabalho">
            <p style={{ marginBottom: 0 }}>
              Sem resposta certa ou errada — todas as alternativas descrevem recursos úteis.
              Cerca de 12 minutos.
            </p>
          </Card>
          <Card titulo="Duas trilhas paralelas">
            <p style={{ marginBottom: 0 }}>
              A psicológica (Jung, animal, luz e sombra) e a funcional (seis eixos, dez capacidades
              e proximidades inspiradas em Belbin). Nenhuma deriva da outra.
            </p>
          </Card>
          <Card titulo="Você pode parar e voltar">
            <p style={{ marginBottom: 0 }}>
              Cada resposta é salva no instante em que você escolhe. Fechar o navegador não perde nada.
            </p>
          </Card>
        </div>

        <Aviso tipo="limite" titulo="Limites">{AVISO_GERAL}</Aviso>
      </main>
      <Rodape />
    </>
  );
}
