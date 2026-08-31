import { db, papel } from '@/lib/sessao';
import { Nav } from '@/components/Nav';
import { Rodape } from '@/components/Rodape';
import { TelaMetodologia, type QualidadeItem } from '@/components/views-gestao';
import { ErroConsulta, Glossario } from '@/components/ui';
import { QUESTOES } from '@/data/questions';
/* A matriz é lida no servidor e entregue à tela por prop: ela é a chave de
   pontuação e não pode fazer parte do bundle que o navegador baixa. */
import { MATRIZ_PONTUACAO } from '@/data/scoringMatrix';
import { CAPACIDADES } from '@/data/functional';
import { analisarEquipe } from '@/lib/aggregate';
import { carregarMembros } from '@/lib/repo-supabase';

export const dynamic = 'force-dynamic';

export default async function Page() {
  const p = await papel();
  if (p !== 'MASTER') return (<><Nav papel={p} /><main className="wrap" style={{ paddingTop: 24 }}>
    <div className="aviso a-limite"><strong>Acesso restrito</strong><div>Área exclusiva do Administrador Master.</div></div>
  </main><Rodape /></>);

  const s = db() as any;
  /* Item 24 — erro de consulta é reportado como erro, não como base vazia. */
  let respostas: any[] = [], resultados: any[] = [], membros: Awaited<ReturnType<typeof carregarMembros>> = [];
  let erro: string | null = null;
  try {
    const [a, b, c] = await Promise.all([
      s.from('respostas').select('questao_codigo,alternativa_codigo'),
      s.from('vw_resultados').select('empate_funcoes'),
      carregarMembros(s)
    ]);
    if (a.error) throw a.error;
    if (b.error) throw b.error;
    respostas = a.data ?? []; resultados = b.data ?? []; membros = c;
  } catch (e: any) { erro = e?.message ?? String(e); }

  if (erro) return (<><Nav papel={p} /><main className="wrap" style={{ paddingTop: 24 }}>
    <ErroConsulta detalhe={erro} />
  </main><Rodape /></>);

  const freq: Record<string, number> = {};
  for (const r of respostas) freq[r.alternativa_codigo] = (freq[r.alternativa_codigo] ?? 0) + 1;

  const qualidade: QualidadeItem[] = QUESTOES.map(q => {
    const n = q.alternativas.reduce((acc, a) => acc + (freq[a.id] ?? 0), 0);
    const distribuicao = q.alternativas.map(a => ({
      alternativaId: a.id, n: freq[a.id] ?? 0,
      pct: n ? Math.round(((freq[a.id] ?? 0) / n) * 1000) / 10 : 0
    }));
    return {
      questaoId: q.id, contexto: q.contexto, n, distribuicao,
      concentracaoMax: Math.max(0, ...distribuicao.map(d => d.pct)),
      discriminativo: distribuicao.every(d => d.n > 0)
    };
  });

  const total = resultados.length;
  const nEmpates = resultados.filter((r: any) => r.empate_funcoes).length;
  const a = analisarEquipe(membros);

  return (
    <>
      <Nav papel={p} />
      <main className="wrap" style={{ paddingTop: 24 }}>
        <TelaMetodologia
          qualidade={qualidade}
          matriz={MATRIZ_PONTUACAO}
          empates={{ n: nEmpates, pct: total ? Math.round((nEmpates / total) * 1000) / 10 : 0 }}
          distribuicoes={{
            perfis: a.distribuicaoPerfis.map(x => ({ nome: x.animal, n: x.n })),
            funcoes: a.distribuicaoFuncoes.map(x => ({ nome: x.nome, n: x.n })),
            atitudes: a.distribuicaoAtitudes.map(x => ({ nome: x.nome, n: x.n })),
            capacidades: CAPACIDADES.map(c => ({ nome: c.nome, media: a.cobertura.find(x => x.capacidade === c.id)!.media }))
          }} />
        <Glossario titulo="Leitura de todas as siglas do instrumento" />
      </main>
      <Rodape />
    </>
  );
}
