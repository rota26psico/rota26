'use client';
/**
 * Primitivas de interface e gráficos.
 * Compartilhadas entre a aplicação Next.js e a demo navegável — os dois
 * renderizam EXATAMENTE os mesmos componentes sobre os mesmos cálculos.
 *
 * Regra de visualização: a cor nunca é o único canal de informação. Todo
 * gráfico traz o valor numérico impresso, para leitura acessível.
 */
import React from 'react';
import { verbete, GLOSSARIO, GRUPOS, NOME_GRUPO, porGrupo, type Verbete } from '../data/glossario';
import { MARCA_SRC, MARCA_ALT, MARCA_LARGURA, MARCA_ALTURA } from '../data/marca';
import { Animal } from './animais-svg';

/**
 * Cores dos gráficos — dentro da paleta da marca (itens 19 e 41).
 * Quatro tons de uma mesma família, do grafite ao amarelo, com separação
 * suficiente para distinguir. O valor numérico é impresso sempre, então a cor
 * nunca é o único canal.
 */
export const CORES_FUNCAO: Record<string, string> = {
  T: '#2B2A28',   // grafite — as letras de ROTA
  F: '#A66A17',   // bronze — a sombra do relevo amarelo
  S: '#8A7C61',   // bege escuro
  N: '#DCA436'    // amarelo da marca
};
export const CORES_ATITUDE: Record<string, string> = { E: '#DCA436', I: '#2B2A28' };

export function Card({ children, titulo, sub, acao }: { children: React.ReactNode; titulo?: string; sub?: string; acao?: React.ReactNode }) {
  /* O cabeçalho aparece quando há QUALQUER um dos três: título, subtítulo ou
     ação. Antes ele dependia só do título, e um cartão sem título engolia
     silenciosamente o controle passado em `acao`. */
  const temCabecalho = !!(titulo || sub || acao);
  return (
    <section className="card">
      {temCabecalho && (
        <header className="card-h">
          <div>{titulo && <h3>{titulo}</h3>}{sub && <p className="sub">{sub}</p>}</div>
          {acao}
        </header>
      )}
      {children}
    </section>
  );
}

export function Kpi({ rotulo, valor, faixa, ajuda, cor, sigla, leitura }: {
  rotulo: string; valor: number | string; faixa?: string; ajuda?: string; cor?: string;
  /** Sigla do glossário: acrescenta o bloco "por que é assim" ao indicador. */
  sigla?: string;
  /** Interpretação visível — o que este número quer dizer, em uma frase. */
  leitura?: React.ReactNode;
}) {
  return (
    <div className="kpi" style={{ ['--kc' as any]: cor ?? '#31556B' }}>
      <div className="kpi-rot">{rotulo}</div>
      <div className="kpi-val">{valor}</div>
      {faixa && <div className={`kpi-faixa f-${faixa}`}>{faixa}</div>}
      {leitura && <p className="kpi-leitura">{leitura}</p>}
      {ajuda && <p className="kpi-ajuda">{ajuda}</p>}
      {sigla && <ExplicaSigla sigla={sigla} />}
    </div>
  );
}

export function Aviso({ tipo = 'info', titulo, children }: { tipo?: 'info' | 'alerta' | 'limite'; titulo?: string; children: React.ReactNode }) {
  return (
    <div className={`aviso a-${tipo}`}>
      {titulo && <strong>{titulo}</strong>}
      <div>{children}</div>
    </div>
  );
}

/** Barras horizontais com valor impresso. */
/**
 * Item 23 — estado vazio legítimo. Zero respondentes é uma informação
 * verdadeira, e é muito melhor do que preencher um gráfico com dado artificial.
 */
export function Vazio({ titulo = 'Aguardando respostas para gerar análise.', children }: {
  titulo?: string; children?: React.ReactNode;
}) {
  return (
    <div className="vazio">
      {/* Item 33 — o símbolo é a própria rota, com o percurso ainda por fazer. */}
      <svg className="marca-vazio" viewBox="0 0 120 26" width="120" height="26" aria-hidden="true">
        <line x1="4" y1="13" x2="116" y2="13" stroke="var(--linha2)" strokeWidth="2" />
        <circle cx="14" cy="13" r="4" fill="var(--amarelo)" />
        <circle cx="60" cy="13" r="4" fill="var(--linha2)" />
        <circle cx="106" cy="13" r="4" fill="var(--linha2)" />
      </svg>
      <strong>{titulo}</strong>
      <div>{children ?? 'Assim que as primeiras avaliações forem concluídas, os indicadores aparecem aqui.'}</div>
    </div>
  );
}

/**
 * Item 24 — falha de consulta NÃO é zero. Quando o banco não responde, a tela
 * diz exatamente isso, em vez de exibir "0 participantes".
 */
export function ErroConsulta({ detalhe }: { detalhe?: string | null }) {
  return (
    <Aviso tipo="limite" titulo="Não foi possível consultar os dados">
      A aplicação não conseguiu ler o banco de dados. Os números abaixo não foram carregados —
      isto <b>não</b> significa que não existam registros. Recarregue a página; se persistir, verifique
      a conexão com o Supabase e as credenciais do ambiente.
      {detalhe && <div style={{ marginTop: 8, fontSize: 12.5, color: '#7C756B' }}><code>{detalhe}</code></div>}
    </Aviso>
  );
}

/** Itens 32 e 33 — checklist de pré-aplicação. */
export function Checklist({ itens }: { itens: { item: string; ok: boolean; detalhe?: string }[] }) {
  return (
    <ul className="checklist">
      {itens.map((x, i) => (
        <li key={i}>
          <span className={`mk ${x.ok ? 'ok' : 'nao'}`}>{x.ok ? '✓' : '✗'}</span>
          <span><b>{x.item}</b>{x.detalhe && <div className="det">{x.detalhe}</div>}</span>
        </li>
      ))}
    </ul>
  );
}

export function Barras({ dados, max = 100, sufixo = '', altura = 26 }: {
  dados: { rotulo: string; valor: number; cor?: string; nota?: string }[]; max?: number; sufixo?: string; altura?: number;
}) {
  const m = Math.max(max, ...dados.map(d => d.valor)) || 1;
  return (
    <div className="barras">
      {dados.map((d, i) => (
        /* minHeight, não height: a terceira coluna leva o valor e, quando existe,
           uma nota que quebra em duas ou três linhas. Com altura fixa a nota
           transbordava e colidia com a barra seguinte. Sem nota, o resultado é
           o mesmo de antes. */
        <div className="barra-linha" key={i} style={{ minHeight: altura }}>
          <div className="barra-rot" title={d.rotulo}>{d.rotulo}</div>
          <div className="barra-trilho">
            <div className="barra-fill" style={{ width: `${Math.max(1, (d.valor / m) * 100)}%`, background: d.cor ?? '#31556B' }} />
          </div>
          <div className="barra-val">{d.valor}{sufixo}{d.nota && <span className="barra-nota">{d.nota}</span>}</div>
        </div>
      ))}
    </div>
  );
}

/** Barra empilhada 2 polos (atitude, eixos). */
export function BarraDupla({ a, b, corA, corB }: { a: { rotulo: string; valor: number }; b: { rotulo: string; valor: number }; corA: string; corB: string }) {
  const t = a.valor + b.valor || 1;
  return (
    <div className="dupla">
      <div className="dupla-topo"><span>{a.rotulo} <b>{a.valor}</b></span><span>{b.rotulo} <b>{b.valor}</b></span></div>
      <div className="dupla-trilho">
        <div style={{ width: `${(a.valor / t) * 100}%`, background: corA }} />
        <div style={{ width: `${(b.valor / t) * 100}%`, background: corB }} />
      </div>
    </div>
  );
}

/** Grade de cobertura funcional 0–100. */
export function Cobertura({ dados }: { dados: { nome: string; valor: number; portadores: number; belbin: string }[] }) {
  /* Item 19 — mesma família, do bronze pleno ao bege. */
  const cor = (v: number) => v >= 70 ? '#A66A17' : v >= 45 ? '#B98235' : '#B7A88C';
  return (
    <div className="cobertura">
      {dados.map(d => (
        <div className="cob-item" key={d.nome}>
          <div className="cob-cab"><span>{d.nome}</span><b style={{ color: cor(d.valor) }}>{d.valor}%</b></div>
          <div className="cob-trilho"><div style={{ width: `${d.valor}%`, background: cor(d.valor) }} /></div>
          <div className="cob-pe">{d.portadores} portador(es) &middot; ref. {d.belbin}</div>
        </div>
      ))}
    </div>
  );
}

export function Tabela({ colunas, linhas }: { colunas: string[]; linhas: (React.ReactNode)[][] }) {
  return (
    <div className="tab-wrap">
      <table>
        <thead><tr>{colunas.map((c, i) => <th key={i}>{c}</th>)}</tr></thead>
        <tbody>{linhas.map((l, i) => <tr key={i}>{l.map((c, k) => <td key={k}>{c}</td>)}</tr>)}</tbody>
      </table>
    </div>
  );
}

export function Pill({ children, cor }: { children: React.ReactNode; cor?: string }) {
  return <span className="pill" style={{ background: (cor ?? '#31556B') + '1A', color: cor ?? '#31556B', borderColor: (cor ?? '#31556B') + '44' }}>{children}</span>;
}


/** Medidor horizontal com rótulo de intensidade. */
export function Medidor({ valor, cor, rotulo }: { valor: number; cor?: string; rotulo?: string }) {
  return (
    <div className="med">
      <div className="med-trilho"><div style={{ width: `${Math.max(1, Math.min(100, valor))}%`, background: cor ?? '#31556B' }} /></div>
      <span className="med-val">{valor}{rotulo ? ` · ${rotulo}` : ''}</span>
    </div>
  );
}

/** Item 49 — mapa de complementaridade como fluxo do ciclo de trabalho. */
export function FluxoComplementaridade({ etapas }: { etapas: { nome: string; valor: number; nivel: string }[] }) {
  const cor = (n: string) => n === 'forte' ? '#8A5612' : n === 'adequada' ? '#A66A17' : n === 'moderada' ? '#B98235' : '#B7A88C';
  return (
    <div className="fluxo">
      {etapas.map((e, i) => (
        <div className="fluxo-item" key={e.nome}>
          <div className="fluxo-caixa" style={{ borderColor: cor(e.nivel), background: cor(e.nivel) + '12' }}>
            <div className="fluxo-nome">{e.nome}</div>
            <div className="fluxo-val" style={{ color: cor(e.nivel) }}>{e.valor}%</div>
            <div className="fluxo-niv">{e.nivel}</div>
          </div>
          {i < etapas.length - 1 && <div className="fluxo-seta">↓</div>}
        </div>
      ))}
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   EXPLICAÇÕES CLICÁVEIS E LEITURA DAS SIGLAS
   --------------------------------------------------------------------------
   Construídas sobre <details>/<summary> nativos, de propósito:

     · funcionam sem JavaScript;
     · já são navegáveis por teclado e anunciados por leitor de tela como
       controle expansível, sem precisar de ARIA improvisado;
     · a impressão pode abri-los todos por CSS.

   A regra editorial destes blocos: além de dizer o que a coisa É, dizer
   POR QUE ela é assim. Quem lê um resultado sobre si mesmo tem o direito de
   discordar de um critério — e para discordar precisa saber qual é.
   ══════════════════════════════════════════════════════════════════════════ */


/**
 * Bloco "por que assim" recolhido. Fica fechado por padrão para não competir
 * com o resultado, e abre no clique ou pelo teclado.
 */
export function PorQue({ titulo = 'Por que é assim?', children, aberto = false }: {
  titulo?: string; children: React.ReactNode; aberto?: boolean;
}) {
  return (
    <details className="porque" open={aberto}>
      <summary>{titulo}</summary>
      <div className="porque-corpo">{children}</div>
    </details>
  );
}

/**
 * Explicação de uma sigla, puxada do glossário pela própria sigla.
 * Se o verbete não existir, não renderiza nada — melhor omitir do que exibir
 * uma caixa vazia.
 */
export function ExplicaSigla({ sigla, titulo }: { sigla: string; titulo?: string }) {
  const v = verbete(sigla);
  if (!v) return null;
  return (
    <PorQue titulo={titulo ?? `O que é ${v.sigla}, e por que é assim`}>
      <p><b>{v.sigla} — {v.nome}.</b> {v.oQueE}</p>
      {v.formula && (
        <p className="formula"><b>Como é calculado.</b> {v.formula}</p>
      )}
      <p><b>Por que assim.</b> {v.porQue}</p>
      <p className="onde">Aparece em: {v.ondeAparece}</p>
    </PorQue>
  );
}

/**
 * Sigla inline com leitura por extenso. Usa <abbr>, que o leitor de tela
 * anuncia, e mostra o significado no hover para quem usa mouse.
 */
export function Sigla({ sigla, children }: { sigla: string; children?: React.ReactNode }) {
  const v = verbete(sigla);
  if (!v) return <>{children ?? sigla}</>;
  return <abbr className="sigla" title={`${v.nome} — ${v.oQueE}`}>{children ?? sigla}</abbr>;
}

/** Um verbete completo, como cartão. */
export function CartaoVerbete({ v }: { v: Verbete }) {
  return (
    <div className="verbete" id={`glossario-${v.sigla.replace(/[^A-Za-z0-9]/g, '-')}`}>
      <div className="verbete-cab">
        <span className="verbete-sigla">{v.sigla}</span>
        <span className="verbete-nome">{v.nome}</span>
      </div>
      <p>{v.oQueE}</p>
      {v.formula && <p className="formula"><b>Como é calculado.</b> {v.formula}</p>}
      <p><b>Por que assim.</b> {v.porQue}</p>
      <p className="onde">Aparece em: {v.ondeAparece}</p>
    </div>
  );
}

/**
 * Glossário completo. `grupos` permite exibir só o que interessa àquela tela —
 * o participante não precisa dos termos de administração.
 */
export function Glossario({ grupos = GRUPOS, titulo = 'Leitura das siglas' }: {
  grupos?: typeof GRUPOS; titulo?: string;
}) {
  return (
    <Card titulo={titulo}
      sub="Toda sigla usada nas telas, com o que significa e por que foi definida assim.">
      {grupos.map(g => {
        const itens = porGrupo(g);
        if (!itens.length) return null;
        return (
          <details className="grupo-glossario" key={g}>
            <summary>
              {NOME_GRUPO[g]} <span className="conta">{itens.length}</span>
            </summary>
            <div className="verbetes">
              {itens.map(v => <CartaoVerbete key={v.sigla} v={v} />)}
            </div>
          </details>
        );
      })}
      <p style={{ fontSize: 12.5, color: 'var(--ink3)', marginTop: 14, marginBottom: 0 }}>
        {GLOSSARIO.length} verbetes. Este glossário é texto explicativo: alterá-lo não muda
        nenhum escore.
      </p>
    </Card>
  );
}

/* ══════════════ IDENTIDADE ROTA26 ════════════════════════════════════════ */

/**
 * A MARCA. Arquivo oficial, exibido como está: sem redesenho, sem recorte,
 * sem mudança de proporção, sem filtro e sem efeito por cima.
 *
 * `origem` existe porque a aplicação Next.js serve o PNG de /public, enquanto
 * a pré-visualização autocontida precisa da cópia embutida — é o mesmo
 * arquivo, entregue de dois jeitos.
 */
export function Marca({ tamanho = 'medio', origem = MARCA_SRC }: {
  tamanho?: 'pequeno' | 'medio' | 'grande';
  origem?: string;
}) {
  const cls = tamanho === 'grande' ? 'placa placa-g' : tamanho === 'pequeno' ? 'placa placa-p' : 'placa';
  return (
    <span className={cls}>
      <img src={origem} alt={MARCA_ALT} width={MARCA_LARGURA} height={MARCA_ALTURA} />
    </span>
  );
}

/** Mantido por compatibilidade — as telas antigas que chamavam Logo. */
export function Logo() { return <Marca tamanho="medio" />; }

/**
 * TOTEM DO ANIMAL — item 76.
 * Tratamento simbólico e institucional: uma placa sóbria com a inicial gravada,
 * o nome em serifa e a configuração junguiana embaixo. Sem cartoon, sem emoji,
 * sem mascote.
 *
 * Item 27 — o texto NUNCA diz "você é uma Raposa". Diz correspondência.
 * Item 77 — a cor vem sempre de `src/data/profiles.ts`; a tela não escolhe cor.
 */
export function Totem({ animal, nomeJung, cor, rotulo = 'Sua maior correspondência simbólica', sintese }: {
  animal: string; nomeJung: string; cor: string; rotulo?: string; sintese?: string;
}) {
  return (
    <div className="totem" style={{ ['--tc' as any]: cor }}>
      <div className="totem-marca" aria-hidden="true"><Animal nome={animal} tamanho={54} /></div>
      <div>
        <div className="totem-sub">{rotulo}</div>
        <div className="totem-nome">{animal}</div>
        <div className="totem-jung">{nomeJung}</div>
        {sintese && <p style={{ fontSize: 13.5, color: '#413C35', margin: '8px 0 0', maxWidth: 620 }}>{sintese}</p>}
      </div>
    </div>
  );
}

/**
 * COMPOSIÇÃO SIMBÓLICA — itens 51 a 55.
 * Os oito animais sempre visíveis, inclusive os que estão em zero, com
 * quantidade E percentual impressos (a cor não é o único canal).
 */
export function FaixaAnimais({ linhas }: {
  linhas: { animal: string; nomeJung: string; cor: string; n: number; pct: number }[];
}) {
  return (
    <div className="animais-faixa">
      {linhas.map(l => (
        <div className={`animal-cel${l.n === 0 ? ' zero' : ''}`} key={l.animal}
          style={{ ['--ac' as any]: l.n === 0 ? 'var(--linha2)' : l.cor }}
          title={`${l.animal} — ${l.nomeJung}: ${l.n} pessoa(s), ${l.pct}%`}>
          <div className="a-fig"><Animal nome={l.animal} tamanho={46} /></div>
          <div className="a-nome">{l.animal}</div>
          <div className="a-n">{l.n}</div>
          <div className="a-pct">{l.pct}%</div>
        </div>
      ))}
    </div>
  );
}

/**
 * Tabela matricial com primeira coluna fixa e números alinhados à direita
 * (Parte J). A última linha é destacada como total organizacional.
 */
export function TabelaMatriz({ colunas, linhas, legenda }: {
  colunas: string[];
  linhas: { rotulo: React.ReactNode; valores: (string | number)[]; total: React.ReactNode; destaque?: boolean }[];
  legenda?: string;
}) {
  return (
    <div className="tab-wrap">
      {legenda && <span className="sr-only">{legenda}</span>}
      <table className="matriz">
        <thead><tr>
          {colunas.map((c, i) => <th key={i} className={i === 0 ? undefined : 'num'} scope="col">{c}</th>)}
        </tr></thead>
        <tbody>
          {linhas.map((l, i) => (
            <tr key={i} className={l.destaque ? 'total-linha' : undefined}>
              <td scope="row">{l.rotulo}</td>
              {l.valores.map((v, k) => (
                <td key={k} className={`num${v === 0 ? ' celula-zero' : ''}`}>{v}</td>
              ))}
              <td className="num"><b>{l.total}</b></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

/**
 * Traço de rota — o motivo gráfico da marca virado elemento de composição.
 * Duas curvas suaves com nós, discretas, atrás do conteúdo das aberturas.
 */
export function TracoRota() {
  return (
    <svg className="traco-rota" viewBox="0 0 800 260" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
      <g stroke="#A66A17" strokeWidth=".9" fill="none" opacity=".38">
        <path d="M-20,182 C160,120 300,198 470,132 C600,82 700,120 820,84" />
        <path d="M-20,216 C170,168 320,226 500,170 C620,134 720,158 820,130" />
      </g>
      <g fill="#DCA436" opacity=".5">
        <circle cx="160" cy="150" r="2.6" /><circle cx="470" cy="132" r="3.2" /><circle cx="700" cy="120" r="2.6" />
      </g>
    </svg>
  );
}

/** Estado de carregamento explícito — item 78. */
export function Carregando({ children = 'Carregando…' }: { children?: React.ReactNode }) {
  return (
    <div role="status" aria-live="polite">
      <p style={{ fontSize: 13.5, color: 'var(--ink3)', margin: '0 0 8px' }}>{children}</p>
      {/* Item 34 — um nó percorrendo a rota, no lugar do spinner genérico. */}
      <div className="rota-carrega"><i /></div>
    </div>
  );
}

export function Secao({ n, titulo, children }: { n?: string; titulo: string; children: React.ReactNode }) {
  return (
    <section className="secao">
      <h2 className="secao-t">{n && <span className="secao-n">{n}</span>}{titulo}</h2>
      {children}
    </section>
  );
}

export const ESTILOS = `
/* ══════════════════════════════════════════════════════════════════════════
   DESIGN SYSTEM ROTA26 — item 78
   --------------------------------------------------------------------------
   Conceito (item 75): ROTA é caminho, movimento, direção — daí a régua
   horizontal que abre cada seção e o traço que conduz a leitura de cima para
   baixo. 26 é futuro e estratégia — daí a base gráfica sóbria, de painel
   executivo. PESSOAS é diversidade e complementaridade — daí a cor nunca ser
   decoração: cada animal carrega SEMPRE a mesma cor, em todas as telas.

   Registro institucional e contemporâneo. Deliberadamente distante de quiz,
   jogo, mascote ou template genérico de dashboard (item 74).

   Regra de acessibilidade que atravessa tudo (item 82): a cor jamais é o único
   canal. Todo gráfico traz número; todo estado traz rótulo textual.
   ══════════════════════════════════════════════════════════════════════════ */
:root{
  /* ══════════════════════════════════════════════════════════════════════
     PALETA ROTA26 — amostrada do arquivo oficial da marca
     ----------------------------------------------------------------------
     Nenhum destes valores foi escolhido a olho. O amarelo, o grafite e o
     creme saíram de src/data/marca.ts, medidos pixel a pixel no logotipo.
     O bronze é literalmente a sombra do relevo amarelo (#A66A17), o que faz
     o acento da interface e o acento da marca serem a mesma cor em
     profundidades diferentes.
     ══════════════════════════════════════════════════════════════════════ */

  /* Grafite — as letras de ROTA */
  --preto:#0B0B0A;
  --carvao:#161615;
  --grafite:#2B2A28;
  --grafite-2:#3B3A37;
  --grafite-3:#555554;

  /* Amarelo — o 26, e o asfalto que o acompanha */
  --amarelo:#DCA436;
  --amarelo-claro:#E9BD58;
  --bronze:#A66A17;
  --bronze-2:#B98235;

  /* Creme — a parede do logotipo */
  --creme:#EFE6D6;
  --creme-2:#F6F0E5;
  --branco-quente:#FCFAF6;

  /* Tinta e linhas sobre o claro */
  --tinta:#1A1917;
  --tinta-2:#4A453D;
  --ink3:#7A7267;
  --cinza-quente:#7A7267;
  --ink4:#948B7E;
  --linha:#DED2BE;
  --linha2:#C6B79E;
  --linha3:#AD9C82;
  --linha-escura:#332F2B;

  /* Semânticos — separados do acento da marca */
  --ok:#4A6B2E; --ok-bg:#E9EFE0; --ok-linha:#C2D3AE;
  --atencao:#8A6516; --atencao-bg:#F8F0DE; --atencao-linha:#E3CDA1;
  --limite:#8A3B2A; --limite-bg:#F7E9E4; --limite-linha:#E0C1B6;
  --info:#2B4A5B; --info-bg:#ECF2F5; --info-linha:#C7D9E3;

  /* Compatibilidade com o código existente */
  --bg:#EFE6D6; --bg2:#E6DBC7; --surface:#FCFAF6; --surface2:#F6F0E5;
  --ink:#1A1917; --ink2:#4A453D;
  --rota:#2B2A28; --rota-2:#3B3A37; --cobre:#A66A17; --cobre-claro:#DCA436;
  --acento:#8A3B2A; --azul:#2B4A5B;

  --e1:4px; --e2:8px; --e3:12px; --e4:16px; --e5:22px; --e6:32px; --e7:48px;
  --r1:5px; --r2:9px; --r3:14px; --r-pill:999px;
  --sombra:0 1px 2px rgba(26,25,23,.04),0 6px 18px -12px rgba(26,25,23,.20);
  --sombra-alta:0 2px 8px rgba(26,25,23,.07),0 24px 50px -24px rgba(26,25,23,.34);

  --display:"Fraunces","Iowan Old Style","Palatino Linotype",Palatino,Georgia,serif;
  --serif:var(--display);
  --sans:"Archivo",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
  --ui:var(--sans);
  --mono:ui-monospace,SFMono-Regular,"SF Mono",Menlo,Consolas,monospace;
}
@import url('https://fonts.googleapis.com/css2?family=Archivo:wght@400;500;600;700&family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&display=swap');
*{box-sizing:border-box}
html{-webkit-text-size-adjust:100%}
body{margin:0;background:var(--creme);color:var(--tinta);font-family:var(--sans);
  font-size:15px;line-height:1.62;-webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility}
h1,h2,h3,h4{font-family:var(--serif);font-weight:600;line-height:1.22;margin:0;letter-spacing:-.005em}
p{margin:0 0 .8em}
ul,ol{margin:0 0 .8em;padding-left:1.15em}
li{margin-bottom:.28em}
button{font:inherit;color:inherit}
a{color:var(--azul);text-underline-offset:2px}
code{font-family:var(--mono);font-size:.9em;background:var(--bg2);padding:1px 5px;border-radius:4px}
.wrap{max-width:1200px;margin:0 auto;padding:0 var(--e5)}

/* Foco visível e consistente — navegação por teclado (item 82) */
:where(a,button,input,select,textarea,[tabindex]):focus-visible{
  outline:2.5px solid var(--cobre);outline-offset:2px;border-radius:var(--r1)}
.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;
  clip:rect(0 0 0 0);white-space:nowrap;border:0}

/* ── CABEÇALHO ─────────────────────────────────────────────────────────── */
/* Casca em grafite — a mesma cor das letras de ROTA. O filete inferior é o
   amarelo da marca abrindo caminho, como a faixa central da estrada.        */
.topo{background:linear-gradient(178deg,#131312,var(--grafite));color:var(--creme);
  padding:var(--e4) 0;position:relative}
.topo::after{content:"";position:absolute;left:0;right:0;bottom:0;height:3px;
  background:linear-gradient(90deg,var(--amarelo),var(--bronze) 24%,transparent 68%)}
.topo .wrap{display:flex;align-items:center;gap:var(--e5);flex-wrap:wrap}
.topo h1{font-size:17px;max-width:430px;line-height:1.3;color:var(--creme-2);font-weight:600}
.topo .marca{font-size:10px;letter-spacing:.2em;text-transform:uppercase;color:var(--amarelo);
  display:flex;align-items:center;gap:var(--e2);flex-wrap:wrap;font-weight:600}
.topo .sub-marca{font-size:12.5px;color:#A79C8C;margin-top:3px;max-width:600px}

/* A marca vive numa placa clara: o arquivo oficial traz a parede creme junto,
   e recortá-la deixaria halo nas sombras. A placa também é fiel ao objeto. */
.placa{background:var(--creme);border-radius:var(--r2);padding:7px 10px;flex:none;
  display:block;line-height:0;box-shadow:0 1px 0 rgba(255,255,255,.12),0 8px 20px -12px rgba(0,0,0,.7)}
.placa img{display:block;height:58px;width:auto}
.placa-g img{height:104px}
.placa-p img{height:32px}
.divisor-marca{width:1px;align-self:stretch;background:var(--grafite-2);flex:none;margin:2px 0}

.nav{margin-left:auto;display:flex;gap:4px;flex-wrap:wrap}
.nav button{background:transparent;border:1px solid transparent;color:#B5AA98;
  padding:7px 13px;border-radius:var(--r-pill);cursor:pointer;font-size:12.5px;transition:.15s;
  font-family:var(--sans)}
.nav button:hover{background:rgba(255,255,255,.07);color:var(--creme)}
.nav button[aria-current="true"]{background:var(--creme);color:var(--grafite);font-weight:600}

/* ── CARTÃO ────────────────────────────────────────────────────────────── */
.card{background:var(--surface);border:1px solid var(--linha);border-radius:var(--r2);
  padding:var(--e5) 24px;margin-bottom:var(--e4)}
.card-h{display:flex;align-items:flex-start;gap:var(--e4);margin-bottom:var(--e4)}
.card-h h3{font-size:17.5px}
.card-h .sub{font-size:13px;color:var(--ink3);margin:5px 0 0;line-height:1.5}

.grid{display:grid;gap:var(--e4)}
.g2{grid-template-columns:repeat(2,minmax(0,1fr))}
.g3{grid-template-columns:repeat(3,minmax(0,1fr))}
.g4{grid-template-columns:repeat(4,minmax(0,1fr))}

/* ── INDICADOR ─────────────────────────────────────────────────────────── */
.kpi{background:var(--surface);border:1px solid var(--linha);border-top:2px solid var(--kc);
  border-radius:var(--r2);padding:var(--e4) 19px}
.kpi-rot{font-size:10.5px;letter-spacing:.13em;text-transform:uppercase;color:var(--ink3);font-weight:700}
.kpi-val{font-family:var(--display);font-size:37px;line-height:1.05;margin-top:7px;color:var(--tinta);
  font-variant-numeric:tabular-nums;overflow-wrap:anywhere;font-weight:600}
.kpi-faixa{display:inline-block;font-size:11px;font-weight:700;text-transform:uppercase;
  letter-spacing:.09em;padding:3px 9px;border-radius:var(--r-pill);margin-top:9px}
.f-alta{background:var(--ok-bg);color:var(--ok)}
.f-moderada{background:var(--atencao-bg);color:var(--atencao)}
.f-baixa{background:var(--limite-bg);color:var(--limite)}
.kpi-ajuda{font-size:12px;color:var(--ink3);margin:9px 0 0;line-height:1.45}

/* ── AVISOS ────────────────────────────────────────────────────────────── */
.aviso{border-radius:var(--r2);padding:14px 17px;margin:var(--e3) 0;font-size:13.5px;line-height:1.55;
  border-left-width:3px;border-left-style:solid}
.aviso strong{display:block;margin-bottom:5px;font-family:var(--serif);font-size:14.5px}
.a-info{background:var(--info-bg);border:1px solid var(--info-linha);border-left-color:var(--info);color:var(--info)}
.a-alerta{background:var(--atencao-bg);border:1px solid var(--atencao-linha);border-left-color:var(--atencao);color:var(--atencao)}
.a-limite{background:var(--limite-bg);border:1px solid var(--limite-linha);border-left-color:var(--limite);color:var(--limite)}

/* ── GRÁFICOS: sempre com número impresso ao lado ──────────────────────── */
.barras{display:flex;flex-direction:column;gap:5px}
.barra-linha{display:grid;grid-template-columns:138px minmax(0,1fr) 104px;align-items:center;gap:11px}
.barra-rot{font-size:13px;color:var(--ink2);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.barra-trilho{background:#E6DBC7;border-radius:3px;height:14px;overflow:hidden}
.barra-fill{height:100%;border-radius:3px;transition:width .4s ease}
.barra-val{font-size:13px;font-weight:700;font-variant-numeric:tabular-nums;text-align:right}
.barra-nota{display:block;font-size:10.5px;font-weight:400;color:var(--ink3);line-height:1.35;margin-top:1px}

.dupla{margin:var(--e3) 0}
.dupla-topo{display:flex;justify-content:space-between;font-size:12.5px;color:var(--ink2);margin-bottom:6px}
.dupla-trilho{display:flex;height:16px;border-radius:3px;overflow:hidden;background:#E6DBC7}

.cobertura{display:grid;grid-template-columns:repeat(auto-fill,minmax(215px,1fr));gap:var(--e4)}
.cob-cab{display:flex;justify-content:space-between;font-size:13px;font-weight:600;margin-bottom:6px;gap:8px}
.cob-trilho{background:#E6DBC7;border-radius:3px;height:9px;overflow:hidden}
.cob-trilho div{height:100%}
.cob-pe{font-size:11px;color:var(--ink3);margin-top:5px}

/* ── TABELAS ───────────────────────────────────────────────────────────── */
.tab-wrap{overflow-x:auto;border:1px solid var(--linha);border-radius:var(--r2);background:var(--surface)}
table{border-collapse:collapse;width:100%;font-size:13.5px;background:var(--surface)}
th,td{text-align:left;padding:11px 14px;border-bottom:1px solid #EDE3D2;vertical-align:top}
thead th{background:transparent;font-size:10px;letter-spacing:.14em;text-transform:uppercase;
  color:var(--ink3);font-weight:700;white-space:nowrap;position:sticky;top:0;z-index:1;
  border-bottom:1.5px solid var(--linha2);padding-bottom:9px}
tbody tr:last-child td{border-bottom:none}
tbody tr:hover{background:var(--creme-2)}
td.num,th.num{text-align:right;font-variant-numeric:tabular-nums}

/* Matriz Equipe × Animal — primeira coluna fixa na rolagem horizontal */
.matriz td:first-child,.matriz th:first-child{position:sticky;left:0;background:var(--surface);
  font-weight:600;box-shadow:1px 0 0 var(--linha)}
.matriz thead th:first-child{background:var(--bg2);z-index:2}
.matriz tbody tr:hover td:first-child{background:var(--surface2)}
.matriz .total-linha td{background:var(--bg2);font-weight:700;border-top:2px solid var(--linha2)}
.matriz .total-linha td:first-child{background:var(--bg2)}
.celula-zero{color:var(--ink4)}

.pill{display:inline-block;font-size:11.5px;font-weight:700;padding:2px 9px;
  border-radius:var(--r-pill);border:1px solid;white-space:nowrap}

/* ── AÇÕES E CAMPOS ────────────────────────────────────────────────────── */
.btn{background:var(--rota);color:#fff;border:1px solid var(--rota);padding:11px 21px;
  border-radius:var(--r1);cursor:pointer;font-weight:600;font-size:14px;transition:.15s;
  display:inline-flex;align-items:center;gap:8px;justify-content:center}
.btn:hover:not(:disabled){background:var(--rota-2);border-color:var(--rota-2)}
.btn:disabled{opacity:.42;cursor:not-allowed}
.btn-sec{background:transparent;color:var(--rota);border:1px solid var(--linha2)}
.btn-sec:hover:not(:disabled){background:var(--bg2);border-color:var(--linha3)}
.perigo{background:var(--limite);color:#fff;border:1px solid var(--limite);padding:11px 21px;
  border-radius:var(--r1);cursor:pointer;font-weight:700;font-size:14px}
.perigo:disabled{opacity:.42;cursor:not-allowed}
input,select,textarea{font:inherit;padding:10px 13px;border:1px solid var(--linha2);
  border-radius:var(--r1);background:#fff;width:100%;color:var(--ink)}
input:hover,select:hover{border-color:var(--linha3)}
label{display:block;font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;
  color:var(--ink3);margin-bottom:6px}
.campo{margin-bottom:var(--e4)}

.filters{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:var(--e4)}
.filters button{background:var(--surface);border:1px solid var(--linha2);color:var(--ink2);
  padding:8px 15px;border-radius:var(--r-pill);cursor:pointer;font-size:13px;transition:.15s}
.filters button:hover{background:var(--bg2)}
.filters button[aria-pressed="true"]{background:var(--rota);color:#fff;border-color:var(--rota);font-weight:600}
/* Item 69 — a Zona de segurança é visualmente distinta das demais abas. */
.filters button.aba-perigo{border-color:var(--limite-linha);color:var(--limite)}
.filters button.aba-perigo[aria-pressed="true"]{background:var(--limite);border-color:var(--limite);color:#fff}

/* ── BARRA DE FILTROS ÚNICA (item 32) ──────────────────────────────────── */
.barra-filtros{display:flex;gap:var(--e2);align-items:center;flex-wrap:wrap;
  background:var(--branco-quente);border:1px solid var(--linha);border-radius:var(--r2);
  padding:10px var(--e3);margin-bottom:var(--e4)}
.barra-filtros .campo-f{display:flex;align-items:center;gap:7px;font-size:12.5px;color:var(--ink3)}
.barra-filtros .campo-f select,.barra-filtros .campo-f input{width:auto;min-width:130px;padding:6px 10px;
  font-size:12.5px;background:var(--creme-2);border-color:var(--linha)}
.barra-filtros .fixo{font-size:12.5px;color:var(--ink3);background:var(--creme-2);
  border:1px solid var(--linha);border-radius:var(--r1);padding:6px 11px}
.barra-filtros .fixo b{color:var(--tinta)}

/* ── PRIMEIRA DOBRA DO DASHBOARD (item 25) ─────────────────────────────── */
.dobra{display:flex;justify-content:space-between;align-items:flex-end;gap:var(--e4);
  flex-wrap:wrap;margin-bottom:var(--e4)}
.dobra .rot{font-size:10.5px;letter-spacing:.18em;text-transform:uppercase;color:var(--bronze);font-weight:700}
.dobra h2{font-size:clamp(28px,4.4vw,40px);line-height:1.04;margin-top:4px;color:var(--tinta)}
.dobra .n{font-family:var(--display);font-size:29px;color:var(--tinta);font-variant-numeric:tabular-nums;font-weight:600}
.dobra .d{font-size:12.5px;color:var(--ink3)}

/* ── QUESTIONÁRIO ──────────────────────────────────────────────────────── */
.alt{display:block;width:100%;text-align:left;background:#fff;border:1.5px solid var(--linha);
  border-radius:var(--r2);padding:15px 17px;margin-bottom:10px;cursor:pointer;font-size:14.5px;
  line-height:1.5;transition:.14s}
.alt:hover{border-color:var(--linha3);background:var(--creme-2)}
.alt[aria-pressed="true"]{border-color:var(--amarelo);background:#FFFCF4;
  box-shadow:inset 0 0 0 1.5px var(--amarelo)}
/* A rota como progresso: asfalto grafite, faixa central amarela avançando.
   Nunca literal — sem placa, sem quilometragem, sem mapa. */
.prog{height:9px;background:var(--grafite);border-radius:5px;overflow:hidden;margin:var(--e4) 0 6px;
  position:relative}
.prog div{height:100%;background:var(--amarelo);transition:width .4s ease;position:relative}
.prog::after{content:"";position:absolute;left:0;right:0;top:50%;height:1.5px;transform:translateY(-50%);
  background:repeating-linear-gradient(90deg,rgba(239,230,214,.34) 0 7px,transparent 7px 15px);
  pointer-events:none}

/* ── ABERTURA ESCURA: hero e revelação do resultado ────────────────────── */
.abertura{background:radial-gradient(120% 100% at 80% 15%,rgba(220,164,54,.16),transparent 60%),
  linear-gradient(178deg,#131312,var(--preto));color:var(--creme);
  border-radius:var(--r3);padding:var(--e7) var(--e5);position:relative;overflow:hidden;
  margin-bottom:var(--e4)}
.abertura .traco-rota{position:absolute;inset:0;opacity:.55;pointer-events:none}
.abertura .dentro{position:relative;display:flex;gap:var(--e6);align-items:center;
  flex-wrap:wrap;justify-content:space-between}
.abertura .col{flex:1 1 320px;min-width:0}
.abertura .rot{font-size:10.5px;letter-spacing:.24em;text-transform:uppercase;color:var(--amarelo);font-weight:600}
.abertura h2{font-size:clamp(28px,5.2vw,46px);color:var(--creme-2);margin:var(--e3) 0 var(--e2);line-height:1.08}
.abertura .sub{color:#A79C8C;font-size:16px;max-width:52ch}
.abertura .frase{color:var(--creme);font-size:16px;margin-top:var(--e4);max-width:52ch;
  border-left:2px solid var(--amarelo);padding-left:var(--e3)}
.abertura .jung{font-family:var(--display);font-size:18px;color:var(--amarelo);margin-top:2px}
.abertura .corresp{font-size:12.5px;color:#A79C8C;margin-top:var(--e3);font-style:italic}
/* O animal entra num disco — eco do selo circular, e resolve o desenho ficar
   encostado na borda do próprio viewBox. O tamanho vem do próprio SVG: aqui o
   disco se ajusta a ele, e não o contrário. */
.abertura .figura{flex:none;margin-right:2px;border-radius:50%;padding:30px;
  display:flex;align-items:center;justify-content:center;
  background:radial-gradient(circle at 42% 34%,rgba(220,164,54,.13),rgba(255,255,255,.02) 62%);
  border:1px solid rgba(220,164,54,.22)}
.abertura .figura svg{display:block}
@media(max-width:760px){.abertura .figura{padding:20px}}
@media(max-width:760px){
  .abertura{padding:var(--e5) var(--e4)}
  .abertura .dentro{gap:var(--e4)}
  .abertura .figura{width:118px;margin:0 auto}
}

/* Botão da marca — o amarelo do logo, usado UMA vez por tela. */
.btn-marca{background:var(--amarelo);color:var(--grafite);border-color:var(--amarelo);font-weight:700}
.btn-marca:hover:not(:disabled){background:var(--amarelo-claro);border-color:var(--amarelo-claro)}
/* ATENÇÃO: esta folha inteira é um template literal. Crase e cifrão-chave aqui
   dentro encerram ou interpolam a string — o comentário vira código.
   O botão secundário é preto sobre claro; dentro da abertura, que é escura, o
   texto sumia. Ele existe ali desde que a abertura passou a oferecer também
   "já respondi": quem volta para reler é tão previsto quanto quem começa. */
.abertura .btn-sec{color:#F3EEE3;border-color:rgba(243,238,227,.34);background:transparent}
.abertura .btn-sec:hover:not(:disabled){background:rgba(243,238,227,.10);border-color:rgba(243,238,227,.55)}

/* Lugar do selo dos oito animais. Enquanto o arquivo oficial não chega, os
   oito nomes em disco sustentam a composição — sem fingir ser o selo.        */
.selo-lugar{flex:none;width:270px;display:grid;place-items:center}
.selo-anel{position:relative;width:250px;height:250px;border-radius:50%;
  border:1px solid rgba(220,164,54,.30);display:grid;place-items:center}
.selo-anel::before{content:"";position:absolute;inset:26px;border-radius:50%;
  border:1px dashed rgba(220,164,54,.20)}
.selo-anel em{font-family:var(--display);font-style:normal;font-size:44px;color:var(--amarelo);opacity:.9}
.selo-anel span{position:absolute;left:50%;top:50%;font-size:11px;letter-spacing:.14em;
  text-transform:uppercase;color:#A79C8C;white-space:nowrap;
  transform:rotate(calc(var(--i) * (360deg / var(--n)))) translateY(-108px)
            rotate(calc(-1 * var(--i) * (360deg / var(--n))))}
@media(max-width:760px){.selo-lugar{width:210px;margin:0 auto}
  .selo-anel{width:196px;height:196px}
  .selo-anel span{transform:rotate(calc(var(--i) * (360deg / var(--n)))) translateY(-84px)
            rotate(calc(-1 * var(--i) * (360deg / var(--n))));font-size:9.5px}}

/* ── SEÇÃO — a "rota" que conduz a leitura ─────────────────────────────── */
.secao{margin:var(--e6) 0 var(--e5)}
.secao-t{font-size:13px;letter-spacing:.17em;text-transform:uppercase;color:var(--ink3);
  display:flex;align-items:center;gap:var(--e3);margin-bottom:var(--e4);font-family:var(--sans);font-weight:700}
.secao-t::after{content:"";flex:1;height:1px;background:linear-gradient(90deg,var(--linha2),transparent)}
.secao-n{display:inline-flex;align-items:center;justify-content:center;min-width:26px;height:26px;
  border-radius:var(--r1);background:var(--grafite);color:var(--amarelo);font-family:var(--display);
  font-size:12.5px;font-weight:600;padding:0 7px}

/* ── ANIMAL: tratamento simbólico, de gravura ──────────────────────────── */
/* item 76 — totem sóbrio, sem cartoon, sem emoji, sem mascote.
   item 77 — a cor vem SEMPRE de src/data/profiles.ts, nunca é escolhida na tela. */
.animal{font-family:var(--serif);font-size:30px}
.totem{display:flex;align-items:center;gap:var(--e4);padding:var(--e5);border-radius:var(--r3);
  background:linear-gradient(140deg,var(--tc,#31556B)0E,var(--tc,#31556B)04);
  border:1px solid var(--linha);border-left:4px solid var(--tc,#31556B)}
.totem-marca{width:66px;height:66px;min-width:66px;border-radius:var(--r2);display:flex;
  align-items:center;justify-content:center;background:var(--grafite);
  box-shadow:inset 0 -3px 0 rgba(0,0,0,.25)}
.totem-nome{font-family:var(--serif);font-size:29px;line-height:1.1;color:var(--tc,#31556B)}
.totem-sub{font-size:12px;letter-spacing:.15em;text-transform:uppercase;color:var(--ink3);
  font-weight:700;margin-bottom:3px}
.totem-jung{font-size:13.5px;color:var(--ink2);margin-top:4px}

/* Faixa da composição simbólica */
.animais-faixa{display:grid;grid-template-columns:repeat(auto-fit,minmax(112px,1fr));gap:var(--e2)}
.animal-cel{border:1px solid var(--linha);border-radius:var(--r2);padding:var(--e3);text-align:center;
  background:var(--surface);border-top:3px solid var(--ac,#CBC2B2)}
.animal-cel.zero{background:var(--surface2);border-top-color:var(--linha2);opacity:.82}
.animal-cel .a-fig{display:flex;justify-content:center;margin-bottom:4px}
.animal-cel.zero .a-fig{opacity:.4;filter:grayscale(.75)}
.animal-cel .a-nome{font-family:var(--display);font-size:14.5px;color:var(--ink2)}
.animal-cel .a-n{font-family:var(--serif);font-size:27px;line-height:1.1;color:var(--ac,#6F685E);
  font-variant-numeric:tabular-nums}
.animal-cel .a-pct{font-size:11.5px;color:var(--ink3);font-variant-numeric:tabular-nums}

/* ── CARTÃO DE PROXIMIDADE FUNCIONAL (Belbin) — itens 35 a 38 ─────────── */
.belcard{border:1px solid var(--linha);border-left:4px solid var(--c,#31556B);border-radius:var(--r2);
  padding:var(--e4) 18px;margin-bottom:var(--e3);background:var(--surface2)}
.belcard .pos{font-size:10.5px;letter-spacing:.13em;text-transform:uppercase;color:var(--ink3);font-weight:700}
.belcard h4{font-size:16.5px;margin:5px 0 9px;color:var(--c,#31556B)}
.belcard dl{margin:12px 0 0;display:grid;grid-template-columns:auto 1fr;gap:5px var(--e4);font-size:13.5px}
.belcard dt{font-weight:700;color:var(--ink3);font-size:11px;letter-spacing:.08em;text-transform:uppercase;
  padding-top:3px;white-space:nowrap}
.belcard dd{margin:0;color:var(--ink2)}
@media(max-width:640px){.belcard dl{grid-template-columns:1fr;gap:2px}
  .belcard dd{margin-bottom:9px}}

.dim{margin-bottom:var(--e4)}
.dim h4{font-size:14px;margin-bottom:4px}
.dim p{margin-bottom:0;font-size:13.8px}

/* ── EXPLICAÇÕES CLICÁVEIS E GLOSSÁRIO ─────────────────────────────────── */
.porque{margin-top:var(--e3);border-top:1px dashed var(--linha2);padding-top:var(--e2)}
.porque > summary{cursor:pointer;font-size:12.5px;font-weight:700;color:var(--rota);
  list-style:none;display:flex;align-items:center;gap:7px;padding:4px 0;user-select:none}
.porque > summary::-webkit-details-marker{display:none}
.porque > summary::before{content:"+";display:inline-flex;align-items:center;justify-content:center;
  width:17px;height:17px;border-radius:5px;border:1px solid var(--linha2);background:var(--surface);
  font-weight:700;font-size:13px;line-height:1;color:var(--rota);flex:none}
.porque[open] > summary::before{content:"–"}
.porque > summary:hover{color:var(--cobre)}
.porque > summary:hover::before{border-color:var(--cobre);color:var(--cobre)}
.porque-corpo{padding:var(--e3) 0 var(--e2) 24px;font-size:13.3px;line-height:1.6;color:var(--ink2);
  border-left:2px solid var(--linha);margin-left:8px}
.porque-corpo p{margin-bottom:.7em}
.porque-corpo p:last-child{margin-bottom:0}
.porque-corpo .formula{background:var(--bg2);border-radius:var(--r1);padding:9px 11px;
  font-size:12.8px;border-left:3px solid var(--cobre)}
.porque-corpo .onde,.verbete .onde{font-size:12px;color:var(--ink3);font-style:italic}

/* A leitura do indicador: o que o número quer dizer, sempre visível. */
.kpi-leitura{font-size:12.8px;color:var(--ink2);margin:9px 0 0;line-height:1.5;
  border-left:2px solid var(--kc);padding-left:9px}

.sigla{text-decoration:underline dotted var(--linha3);text-underline-offset:3px;cursor:help}

.grupo-glossario{border:1px solid var(--linha);border-radius:var(--r2);margin-bottom:var(--e2);
  background:var(--surface2);overflow:hidden}
.grupo-glossario > summary{cursor:pointer;padding:13px 16px;font-family:var(--serif);font-size:15.5px;
  font-weight:600;display:flex;align-items:center;gap:10px;list-style:none;user-select:none}
.grupo-glossario > summary::-webkit-details-marker{display:none}
.grupo-glossario > summary::before{content:"▸";color:var(--cobre);font-size:12px;flex:none}
.grupo-glossario[open] > summary::before{content:"▾"}
.grupo-glossario > summary:hover{background:var(--bg2)}
.grupo-glossario .conta{margin-left:auto;font-family:var(--sans);font-size:11.5px;font-weight:700;
  color:var(--ink3);background:var(--bg2);border-radius:var(--r-pill);padding:2px 9px}
.verbetes{padding:0 16px 14px;display:grid;gap:var(--e3)}
.verbete{background:var(--surface);border:1px solid var(--linha);border-left:3px solid var(--cobre);
  border-radius:var(--r1);padding:13px 15px;font-size:13.3px;line-height:1.6}
.verbete-cab{display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;margin-bottom:7px}
.verbete-sigla{font-family:var(--mono);font-size:13px;font-weight:700;color:var(--rota);
  background:var(--bg2);border-radius:5px;padding:2px 8px}
.verbete-nome{font-family:var(--serif);font-size:15px;color:var(--ink)}
.verbete p{margin-bottom:.6em}
.verbete p:last-child{margin-bottom:0}
.verbete .formula{background:var(--bg2);border-radius:var(--r1);padding:8px 10px;font-size:12.8px}

/* ── ESTADOS ───────────────────────────────────────────────────────────── */
.vazio{border:1px dashed var(--linha2);border-radius:var(--r2);padding:32px 20px;text-align:center;
  color:var(--ink3);background:var(--creme-2)}
.vazio .marca-vazio{display:block;margin:0 auto 14px}
.vazio strong{display:block;color:var(--ink2);font-size:16px;margin-bottom:6px;font-family:var(--display)}
@keyframes percorrer{0%{left:2%}100%{left:95%}}
.rota-carrega{position:relative;height:3px;background:var(--linha);border-radius:2px;max-width:280px}
.rota-carrega i{position:absolute;top:-3.5px;width:10px;height:10px;border-radius:50%;
  background:var(--amarelo);animation:percorrer 1.5s ease-in-out infinite alternate}
.carregando{display:inline-flex;align-items:center;gap:9px;color:var(--ink3);font-size:13.5px}
.esqueleto{background:linear-gradient(90deg,var(--bg2)25%,#F5F1EA 50%,var(--bg2)75%);
  background-size:200% 100%;animation:brilho 1.4s infinite;border-radius:var(--r1);height:14px}
@keyframes brilho{to{background-position:-200% 0}}

.checklist{list-style:none;padding:0;margin:0}
.checklist li{display:flex;gap:11px;align-items:flex-start;padding:8px 0;
  border-bottom:1px solid #EFE9DE;font-size:13.5px}
.checklist li:last-child{border-bottom:0}
.checklist .mk{font-weight:700;min-width:18px}
.checklist .ok{color:var(--ok)}
.checklist .nao{color:var(--limite)}
.checklist .det{color:var(--ink3);font-size:12.5px;margin-top:2px}

.bloco{border-left:3px solid var(--linha2);padding:2px 0 2px var(--e4);margin-bottom:var(--e4)}
.bloco h4{font-size:14.5px;margin-bottom:5px}
.zona{border:1.5px solid var(--limite-linha);background:var(--limite-bg);border-radius:var(--r3);
  padding:var(--e5);margin-top:var(--e4)}
.zona h4{font-size:16px;color:var(--limite);margin-bottom:6px}

.med{display:flex;align-items:center;gap:10px}
.med-trilho{flex:1;background:#E6DBC7;border-radius:3px;height:9px;overflow:hidden}
.med-trilho div{height:100%}
.med-val{font-size:12px;color:var(--ink3);white-space:nowrap;font-variant-numeric:tabular-nums}

.fluxo{display:flex;flex-direction:column;gap:2px}
.fluxo-caixa{border:1.5px solid;border-radius:var(--r2);padding:10px 14px;display:flex;
  align-items:center;gap:var(--e3);flex-wrap:wrap}
.fluxo-nome{font-weight:600;font-size:13.5px;flex:1;min-width:120px}
.fluxo-val{font-family:var(--serif);font-size:19px;font-variant-numeric:tabular-nums}
.fluxo-niv{font-size:11px;text-transform:uppercase;letter-spacing:.08em;color:var(--ink3)}
.fluxo-seta{text-align:center;color:var(--linha3);font-size:13px;line-height:1}

/* ── RODAPÉ ────────────────────────────────────────────────────────────── */
.rod{color:#8F8677;background:var(--grafite);padding:34px 0;margin-top:var(--e6);font-size:12.5px;
  border-top:3px solid var(--amarelo)}
.rod .wrap{display:grid;gap:var(--e5);grid-template-columns:repeat(auto-fit,minmax(258px,1fr))}
.rod b{color:var(--creme)}

/* ── RESPONSIVO (item 81) ──────────────────────────────────────────────── */
@media(max-width:1000px){
  .g3,.g4{grid-template-columns:repeat(2,minmax(0,1fr))}
}
@media(max-width:760px){
  .wrap{padding:0 var(--e4)}
  .g2,.g3,.g4{grid-template-columns:1fr}
  .topo{padding:var(--e4) 0}
  .topo .wrap{gap:var(--e3)}
  .topo h1{font-size:17px}
  .nav{margin-left:0;width:100%;overflow-x:auto;flex-wrap:nowrap;padding-bottom:3px;
    -webkit-overflow-scrolling:touch}
  .nav button{white-space:nowrap}
  .card{padding:var(--e4);border-radius:var(--r2)}
  .barra-linha{grid-template-columns:96px minmax(0,1fr) 88px;gap:8px}
  .kpi-val{font-size:31px}
  /* Questionário no celular: alvo de toque grande e texto confortável */
  .alt{padding:16px;font-size:15.5px;min-height:56px}
  .totem{flex-direction:column;text-align:center;align-items:center}
  .animais-faixa{grid-template-columns:repeat(auto-fit,minmax(94px,1fr))}
}
@media(max-width:420px){
  .barra-linha{grid-template-columns:1fr;gap:2px}
  .barra-rot{white-space:normal}
  .barra-val{text-align:left}
}

/* Preferência de movimento reduzido */
@media(prefers-reduced-motion:reduce){
  *,*::before,*::after{animation-duration:.001ms!important;animation-iteration-count:1!important;
    transition-duration:.001ms!important}
  .rota-carrega i{left:46%}
}

/* Blocos que só existem no papel — ver components/BotaoImprimir.tsx */
.so-impressao{display:none}
.barra-exportar{display:flex;justify-content:flex-end;margin-bottom:14px}

/* Impressão do resultado individual, da leitura executiva e dos painéis */
@media print{
  .topo,.nav,.filters,.rod{display:none}
  /* O !important aqui não é preguiça: esta classe existe para garantir que algo
     NUNCA seja impresso, e estilo inline no mesmo elemento venceria a regra.
     Foi exatamente o que aconteceu com o botão de exportar. */
  .nao-imprime{display:none!important}
  body{background:#fff}
  .card{break-inside:avoid;box-shadow:none;border-color:#ccc}

  /* O cabeçalho e os limites aparecem só aqui: um PDF circula sozinho, longe
     do cabeçalho e do rodapé da aplicação. */
  .so-impressao{display:block}
  .si-marca{font:700 15px/1.3 Georgia,serif;letter-spacing:.02em;margin-bottom:6px}
  .si-linha{display:flex;flex-wrap:wrap;gap:4px 22px;font-size:11px;color:#4a463f;
    border-bottom:1px solid #ccc;padding-bottom:10px;margin-bottom:16px}
  .si-limites{margin-top:18px;padding-top:10px;border-top:1px solid #ccc;
    font-size:10.5px;line-height:1.5;color:#333;break-inside:avoid}

  /* As grades colapsam para uma coluna nas media queries de tela estreita, e a
     impressão cai nelas: o painel virava um cartão por linha e 18 páginas.
     Aqui as colunas voltam. */
  .g2{grid-template-columns:repeat(2,minmax(0,1fr))}
  .g3{grid-template-columns:repeat(3,minmax(0,1fr))}
  .g4{grid-template-columns:repeat(4,minmax(0,1fr))}

  /* Com quatro colunas em A4 o cartão fica estreito, e o overflow-wrap:anywhere
     do .kpi-val — que na tela evita estouro — passava a partir as palavras no
     meio: "Carneir/o", "Sentime/nto". Reduzir o corpo resolve sem tirar a
     proteção contra estouro. */
  .kpi-val{font-size:24px;line-height:1.15}
  .kpi{padding:13px 15px}

  /* Título não fica órfão no pé da folha, e tabela não parte ao meio. */
  h1,h2,h3,h4{break-after:avoid}
  table,tr,.tabela{break-inside:avoid}
  a[href]:after{content:''}
  /* Na impressão nada fica escondido atrás de um clique. */
  details{open:true}
  .porque,.grupo-glossario{display:block}
  .porque > summary,.grupo-glossario > summary{font-weight:700}
  .porque-corpo,.verbetes{display:block!important}
}
`;
