'use client';
/**
 * EXPERIÊNCIA DO PARTICIPANTE (itens 8 a 29 e 69)
 * ---------------------------------------------------------------------------
 * Fluxo: Identificação → 48 situações → Resultado → Como você funciona →
 * Animal → Luz e sombra → Sua contribuição → Belbin → Você na sua equipe.
 *
 * O participante NÃO vê IDF, ICF, fórmulas, matriz de pontuação nem pesos.
 */
import React, { useMemo, useState } from 'react';
import {
  Card, Aviso, Barras, BarraDupla, Tabela, Pill, Medidor, Secao, Totem, FaixaAnimais,
  PorQue, ExplicaSigla, Glossario, TracoRota, CORES_FUNCAO, CORES_ATITUDE
} from './ui';
import { dataBR } from '../lib/datas';
import { AnimalDoPerfil } from './animais-svg';
import { QUESTOES, NOME_EIXO, type Questao } from '../data/questions';
import { PERFIL_POR_ID, NOME_FUNCAO, NOME_ATITUDE } from '../data/profiles';
import type { ResultadoIndividual, Resposta } from '../lib/resultado';
import type { ComparacaoIndividuo } from '../lib/aggregate';
import {
  cabecalho, interacaoPerfis, comoVoceFunciona, luz, sombra,
  contribuicaoFuncional, belbinDetalhado, menosEspontaneos,
  potenciasIndividuais, presencaNaConfiguracao,
  AVISO_ESCORES, AVISO_BELBIN, AVISO_GERAL
} from '../lib/narrative';

/* ───────────────────────── IDENTIFICAÇÃO (item 26) ───────────────────────── */
/**
 * A MESMA identificação serve a dois propósitos, e eles pedem textos diferentes.
 * Quem chega por `/questionario` vai responder e precisa saber quanto tempo leva
 * e que dá para parar no meio. Quem chega por `/meu-resultado` já respondeu:
 * dizer "são 48 situações, leva 12 minutos" ali sugere que ele vai refazer o
 * teste — que é exatamente o oposto do que a tela faz. `modo` troca o que muda,
 * e só isso: os campos, a validação e a regra da matrícula são os mesmos.
 */
export function TelaIdentificacao({ setores, onIniciar, erro, modo = 'responder' }: {
  setores: string[]; onIniciar: (d: { nome: string; matricula: string; setor: string }) => void;
  erro?: string | null;
  modo?: 'responder' | 'revisitar';
}) {
  const [nome, setNome] = useState('');
  const [matricula, setMatricula] = useState('');
  const [setor, setSetor] = useState(setores[0] ?? '');
  const [tocado, setTocado] = useState(false);
  React.useEffect(() => { if (!setor && setores.length) setSetor(setores[0]); }, [setores]);

  /* Item 18 — os três campos são obrigatórios e a matrícula é o identificador
     organizacional único. A mesma regra é reaplicada no servidor. */
  const problema =
    nome.trim().length < 3 ? 'Informe o nome completo (nome e sobrenome).'
    : !matricula.trim() ? 'A matrícula é obrigatória — é ela que identifica você na organização.'
    : !/^[A-Za-z0-9._-]{2,32}$/.test(matricula.trim())
      ? 'Matrícula inválida. Use apenas letras, números, ponto, hífen ou sublinhado (2 a 32 caracteres).'
    : !setor ? 'Selecione o setor ou contrato.'
    : null;
  const valido = !problema;

  return (
    <div style={{ maxWidth: 640, margin: '0 auto' }}>
      <Card titulo="Identificação"
        sub={modo === 'revisitar'
          ? 'Informe os mesmos dados que você usou para responder — é por eles que seu resultado é localizado.'
          : 'Seus dados vinculam o resultado a você e compõem as análises por equipe.'}>
        {erro && <Aviso tipo="limite" titulo="Não foi possível continuar">{erro}</Aviso>}
        {/* label ligado por htmlFor/id: sem isso o leitor de tela anuncia
            "caixa de edição" sem dizer de quê. */}
        <div className="campo"><label htmlFor="c-nome">Nome completo</label>
          <input id="c-nome" name="nome" autoComplete="name" value={nome}
            aria-invalid={tocado && !!problema} aria-describedby={tocado && problema ? 'c-erro' : undefined}
            onChange={e => setNome(e.target.value)} onBlur={() => setTocado(true)} placeholder="Nome e sobrenome" /></div>
        <div className="campo"><label htmlFor="c-matricula">Matrícula</label>
          <input id="c-matricula" name="matricula" value={matricula}
            aria-invalid={tocado && !!problema} aria-describedby={tocado && problema ? 'c-erro' : undefined}
            onChange={e => setMatricula(e.target.value)} onBlur={() => setTocado(true)} placeholder="Sua matrícula" /></div>
        <div className="campo"><label htmlFor="c-setor">Setor / Contrato</label>
          <select id="c-setor" name="setor" value={setor} onChange={e => setSetor(e.target.value)}>
            {setores.length === 0 && <option value="">Nenhum setor cadastrado</option>}
            {setores.map(s => <option key={s} value={s}>{s}</option>)}
          </select></div>
        {tocado && problema && (
          <p id="c-erro" role="alert" style={{ color: '#A8503C', fontSize: 13, margin: '0 0 12px' }}>{problema}</p>
        )}
        {modo === 'revisitar' ? (
          <Aviso tipo="info" titulo="Você não vai responder de novo">
            Seu resultado é <b>recalculado a partir das 48 respostas já guardadas</b> — por isso ele é sempre o
            mesmo, e por isso não é preciso refazer nada para lê-lo. Se você respondeu mais de uma vez,
            todas as aplicações ficam disponíveis.
          </Aviso>
        ) : (
          <Aviso tipo="info" titulo="Como funciona">
            São 48 situações de trabalho, sem resposta certa ou errada — todas as alternativas descrevem
            recursos úteis. Leva cerca de 12 minutos. <b>Cada resposta é salva no momento em que você escolhe</b>,
            então você pode fechar e continuar depois do ponto em que parou.
          </Aviso>
        )}
        <Aviso tipo="limite" titulo="Limites">{AVISO_GERAL} Seus resultados individuais não são visíveis para colegas.</Aviso>
        <button className="btn" disabled={!valido} onClick={() => onIniciar({ nome, matricula, setor })}>
          {modo === 'revisitar' ? 'Ver meu resultado' : 'Iniciar ou continuar'}
        </button>
      </Card>
    </div>
  );
}

/* ──────────────────── RETOMADA DE AVALIAÇÃO (item 16) ───────────────────── */
/**
 * A aplicação encontrou uma avaliação EM_ANDAMENTO e PERGUNTA — não retoma
 * sozinha, e não abre outra por baixo. Ao continuar, o questionário abre na
 * primeira questão ainda não respondida.
 */
export function TelaRetomada({ nome, respondidas, total = 48, proxima, onContinuar, ocupado }: {
  nome: string; respondidas: number; total?: number; proxima: number;
  onContinuar: () => void; ocupado?: boolean;
}) {
  return (
    <div style={{ maxWidth: 640, margin: '0 auto' }}>
      <Card titulo="Encontramos uma avaliação em andamento" sub={`${nome}, suas respostas anteriores estão salvas.`}>
        <p style={{ fontSize: 15 }}>
          Você já respondeu <b>{respondidas} de {total}</b> situações. Deseja continuar de onde parou?
        </p>
        <div className="prog" style={{ margin: '10px 0 16px' }}><div style={{ width: `${(respondidas / total) * 100}%` }} /></div>
        <Aviso tipo="info" titulo="O que acontece ao continuar">
          A avaliação reabre na <b>situação {proxima}</b>, a primeira ainda sem resposta. Nada do que você já
          respondeu é perdido ou refeito.
        </Aviso>
        <button className="btn" disabled={ocupado} onClick={onContinuar}>
          {ocupado ? 'Abrindo…' : 'Continuar minha avaliação'}
        </button>
      </Card>
    </div>
  );
}

/* ────────────── PARTICIPANTE QUE JÁ CONCLUIU (item 17) ──────────────────── */
/**
 * Nenhuma nova avaliação é iniciada em silêncio. Responder de novo depende de
 * uma autorização explícita do Administrador Master.
 */
export function TelaJaConcluida({ nome, data, aplicacao, podeVerResultado, onVerResultado }: {
  nome: string; data?: string; aplicacao?: number; podeVerResultado?: boolean; onVerResultado?: () => void;
}) {
  return (
    <div style={{ maxWidth: 640, margin: '0 auto' }}>
      <Card titulo="Sua avaliação já foi concluída" sub={nome}>
        <p style={{ fontSize: 15 }}>
          Suas 48 respostas estão registradas{data ? <> e a avaliação foi finalizada em <b>{dataBR(data)}</b></> : null}
          {aplicacao && aplicacao > 1 ? <> — esta é a sua <b>{aplicacao}ª aplicação</b></> : null}.
          Elas já compõem as análises da sua equipe.
        </p>
        <Aviso tipo="info" titulo="Quer responder novamente?">
          Uma nova aplicação só é aberta quando o Administrador Master libera a reaplicação, quando a avaliação
          anterior é arquivada, ou quando uma nova versão do instrumento é publicada para reaplicação.
          Procure a área responsável pelo instrumento.
        </Aviso>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {podeVerResultado && onVerResultado && (
            <button className="btn" onClick={onVerResultado}>Ver meu resultado</button>
          )}
          {/* Endereço fixo: quem só quer reler o resultado não precisa passar
              pela tela de quem vai responder. */}
          <a className="btn btn-sec" href="/meu-resultado">Meu resultado e histórico</a>
        </div>
      </Card>
    </div>
  );
}

/* ───────────────────────────── QUESTIONÁRIO ─────────────────────────────── */
function embaralhar<T>(arr: T[], semente: number): T[] {
  const a = [...arr]; let s = semente >>> 0;
  const r = () => { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; };
  for (let i = a.length - 1; i > 0; i--) { const k = Math.floor(r() * (i + 1)); [a[i], a[k]] = [a[k], a[i]]; }
  return a;
}
const hash = (t: string) => { let h = 2166136261; for (const c of t) { h ^= c.charCodeAt(0); h = Math.imul(h, 16777619); } return h >>> 0; };

/** `respostasIniciais` permite RETOMAR de onde parou (item 54). */
export function TelaQuestionario({ semente, respostasIniciais = {}, onConcluir, onSalvarResposta, salvando, erro }: {
  semente: string;
  respostasIniciais?: Record<string, string>;
  onConcluir: (r: Resposta[]) => void;
  onSalvarResposta?: (r: Resposta, posicao: number) => void | Promise<void>;
  salvando?: boolean; erro?: string | null;
}) {
  const [resp, setResp] = useState<Record<string, string>>(respostasIniciais);
  const primeiraPendente = Math.max(0, QUESTOES.findIndex(q => !respostasIniciais[q.id]));
  const [i, setI] = useState(primeiraPendente === -1 ? 0 : primeiraPendente);

  const q: Questao = QUESTOES[i];
  const base = hash(semente);
  const alts = useMemo(() => embaralhar(q.alternativas, base + i * 7919), [q.id, base, i]);
  const escolhida = resp[q.id];
  const total = QUESTOES.length;
  const respondidas = Object.keys(resp).length;
  const retomado = Object.keys(respostasIniciais).length;

  const escolher = (altId: string, pos: number) => {
    setResp(p => ({ ...p, [q.id]: altId }));
    onSalvarResposta?.({ questaoId: q.id, alternativaId: altId }, pos);
    setTimeout(() => { if (i < total - 1) setI(i + 1); }, 170);
  };

  return (
    <div style={{ maxWidth: 780, margin: '0 auto' }}>
      {retomado > 0 && retomado < total && (
        <Aviso tipo="info" titulo="Continuando de onde você parou">
          {retomado} de {total} respostas já estavam salvas. Você retomou no item {primeiraPendente + 1}.
        </Aviso>
      )}
      {erro && <Aviso tipo="limite" titulo="Erro ao salvar">{erro}</Aviso>}
      <Card>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12.5, color: '#7C756B' }}>
          <span>Situação <b>{i + 1}</b> de {total}</span>
          <span>{respondidas} respondidas{salvando ? ' · salvando…' : ''}</span>
        </div>
        <div className="prog"><div style={{ width: `${(respondidas / total) * 100}%` }} /></div>
        <h3 style={{ fontSize: 19, margin: '16px 0 14px' }}>{q.enunciado}</h3>
        {alts.map((a, k) => (
          <button key={a.id} className="alt" aria-pressed={escolhida === a.id} onClick={() => escolher(a.id, k + 1)}>{a.texto}</button>
        ))}
        <div style={{ display: 'flex', gap: 9, marginTop: 14, alignItems: 'center', flexWrap: 'wrap' }}>
          <button className="btn btn-sec" disabled={i === 0} onClick={() => setI(i - 1)}>Anterior</button>
          <button className="btn btn-sec" disabled={i >= total - 1} onClick={() => setI(i + 1)}>Pular</button>
          <div style={{ marginLeft: 'auto' }}>
            <button className="btn" disabled={respondidas < total}
              onClick={() => onConcluir(QUESTOES.filter(x => resp[x.id]).map(x => ({ questaoId: x.id, alternativaId: resp[x.id] })))}>
              {respondidas < total ? `Faltam ${total - respondidas}` : 'Ver meu resultado'}
            </button>
          </div>
        </div>
        <p style={{ fontSize: 12, color: '#7C756B', marginTop: 12, marginBottom: 0 }}>
          Não há alternativa certa ou errada. A ordem das alternativas é embaralhada e a pontuação está
          vinculada ao identificador da alternativa, não à posição em que ela aparece.
        </p>
      </Card>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   RESULTADO INDIVIDUAL — oito blocos (item 26)
   --------------------------------------------------------------------------
   REORGANIZAÇÃO DE APRESENTAÇÃO. Nenhuma informação foi retirada e nenhum
   escore foi recalculado: os mesmos números da versão anterior, na ordem
   pedida, com hierarquia visual.

     1  Sua configuração
     2  Como você tende a funcionar
     3  Seus escores
     4  Suas potências
     5  Luz e sombra
     6  O que você tende a oferecer à equipe
     7  Contribuições funcionais / Belbin
     8  Você dentro da sua equipe
   ══════════════════════════════════════════════════════════════════════════ */

export function TelaResultado({ r, dados, comparacao }: {
  r: ResultadoIndividual;
  dados: { nome: string; setor: string; data: string };
  comparacao?: ComparacaoIndividuo | null;
}) {
  const cab = cabecalho(r, dados);
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const sec = PERFIL_POR_ID[r.perfilSecundario];
  const rel = r.escores.relativo;
  const funcionamento = comoVoceFunciona(r);
  const potencias = potenciasIndividuais(r);
  const luzes = luz(r);
  const sombras = sombra(r);
  const contribs = contribuicaoFuncional(r);
  const bel = belbinDetalhado(r);
  const menos = menosEspontaneos(r);

  return (
    <div>
      {/* ══ BLOCO 1 — SUA CONFIGURAÇÃO ══════════════════════════════════ */}
      {/* Item 14 — abertura escura de revelação, sem parecer jogo: o animal
          entra grande, o nome em serifa, e a frase-síntese logo abaixo.     */}
      <section className="abertura">
        <TracoRota />
        <div className="dentro">
          <div className="col">
            <div className="rot">01 · Sua configuração</div>
            <h2 style={{ marginBottom: 0 }}>{p.animal}</h2>
            <div className="jung">{p.nomeJung}</div>
            <div className="corresp">“Sua maior correspondência simbólica”</div>
            <p className="frase">{p.sintese}</p>
          </div>
          <div className="figura">
            <AnimalDoPerfil perfil={p.id} tamanho={178} />
          </div>
        </div>
      </section>

      <Card>
        <div style={{ fontSize: 12.5, color: 'var(--ink3)', marginBottom: 16 }}>
          <b>{cab.nome}</b> · {cab.setor} · {dataBR(cab.data)} · instrumento {cab.versao}
        </div>

        <Aviso tipo="limite">{cab.aviso}</Aviso>
        <ExplicaSigla sigla={p.id} titulo={`Como se lê "${p.id}", e por que este animal`} />

        <div className="grid g2" style={{ marginTop: 4 }}>
          <div className="bloco" style={{ borderLeftColor: p.cor }}>
            <h4>Tendência predominante</h4>
            <p style={{ fontFamily: 'var(--display)', fontSize: 18, color: p.cor, margin: '0 0 6px' }}>{p.nomeJung}</p>
            <p style={{ marginBottom: 0 }}>{p.estrutura.percebe}</p>
            <ExplicaSigla sigla="Função dominante" titulo="O que significa ser a função dominante" />
          </div>
          <div className="bloco" style={{ borderLeftColor: sec.cor }}>
            <h4>Tendência secundária</h4>
            <p style={{ fontFamily: 'var(--display)', fontSize: 18, color: sec.cor, margin: '0 0 6px' }}>{sec.nomeJung}</p>
            <p style={{ marginBottom: 0 }}>{sec.estrutura.decide}</p>
            <ExplicaSigla sigla="Função auxiliar" titulo="Por que a secundária vem obrigatoriamente do par oposto" />
          </div>
        </div>
        <p style={{ marginTop: 14, marginBottom: 0 }}>{interacaoPerfis(r)}</p>
        {/* Os dois empates são declarados separadamente porque decidem coisas
            diferentes: o da dominante define a tendência PREDOMINANTE, o da
            auxiliar define a SECUNDÁRIA. Esconder o segundo — como acontecia até
            o algoritmo v1.0-piloto — fazia a secundária parecer mais firme do
            que os números sustentam. */}
        {r.empateFuncoes && (
          <Aviso tipo="alerta" titulo="Duas funções apareceram empatadas na tendência predominante">
            A tendência predominante acima decorre de uma regra de desempate explícita ({r.regraDesempate}). Leia-a
            como menos definida do que o habitual: ambas as funções empatadas descrevem recursos que você utiliza.
            <ExplicaSigla sigla="Empate" titulo="Por que o empate é declarado em vez de escondido" />
          </Aviso>
        )}
        {r.empateAuxiliar && (
          <Aviso tipo="alerta" titulo="As duas funções do par auxiliar apareceram empatadas">
            A tendência <b>secundária</b> acima decorre de uma regra de desempate explícita
            ({r.regraDesempateAuxiliar}). As duas funções do par tiveram exatamente o mesmo escore, então leia a
            secundária como uma indicação fraca: a outra função do par descreve recursos igualmente seus.
            <ExplicaSigla sigla="Empate" titulo="Por que o empate é declarado em vez de escondido" />
          </Aviso>
        )}
      </Card>

      {/* ══ BLOCO 2 — COMO VOCÊ TENDE A FUNCIONAR ═══════════════════════ */}
      <Secao n="2" titulo="Como você tende a funcionar">
        <Card sub="Dez dimensões do trabalho, lidas a partir dos seus próprios escores.">
          <div className="grid g2">
            <div>{funcionamento.slice(0, 5).map(d => (
              <div className="bloco" key={d.titulo}><h4>{d.titulo}</h4><p style={{ marginBottom: 0 }}>{d.texto}</p></div>))}</div>
            <div>{funcionamento.slice(5).map(d => (
              <div className="bloco" key={d.titulo}><h4>{d.titulo}</h4><p style={{ marginBottom: 0 }}>{d.texto}</p></div>))}</div>
          </div>
        </Card>
      </Secao>

      {/* ══ BLOCO 3 — SEUS ESCORES ══════════════════════════════════════ */}
      <Secao n="3" titulo="Seus escores">
        <div className="grid g2">
          <Card titulo="Atitude e funções">
            <BarraDupla a={{ rotulo: 'Extroversão', valor: rel.E }} b={{ rotulo: 'Introversão', valor: rel.I }}
              corA={CORES_ATITUDE.E} corB={CORES_ATITUDE.I} />
            <div style={{ marginTop: 14 }}>
              <Barras max={60} altura={32} dados={(['T', 'F', 'S', 'N'] as const).map(f => ({
                rotulo: NOME_FUNCAO[f], valor: rel[f], cor: CORES_FUNCAO[f],
                nota: f === r.funcaoDominante ? 'dominante' : f === r.funcaoAuxiliar ? 'auxiliar' : f === r.funcaoInferior ? 'inferior' : undefined
              }))} />
            </div>
            {/* Alternativa textual ao gráfico — item 82 */}
            <p className="sr-only">
              Extroversão {rel.E}, Introversão {rel.I}, Pensamento {rel.T}, Sentimento {rel.F},
              Sensação {rel.S}, Intuição {rel.N}.
            </p>

            <h4 style={{ fontSize: 13, margin: '18px 0 6px' }}>O que significa cada letra</h4>
            {(['E', 'I'] as const).map(k => <ExplicaSigla key={k} sigla={k}
              titulo={`${k} — ${k === 'E' ? 'Extroversão' : 'Introversão'} (seu escore: ${rel[k]})`} />)}
            {(['T', 'F', 'S', 'N'] as const).map(k => <ExplicaSigla key={k} sigla={k}
              titulo={`${k} — ${NOME_FUNCAO[k]} (seu escore: ${rel[k]})`} />)}
            <ExplicaSigla sigla="Função inferior"
              titulo={`Sua função inferior é ${NOME_FUNCAO[r.funcaoInferior]} — o que isso quer dizer`} />
          </Card>
          <Card titulo="Seis eixos comportamentais">
            {r.eixosAuxiliares.map(e => (
              <BarraDupla key={e.par[0]} a={{ rotulo: NOME_EIXO[e.par[0]], valor: e.a }}
                b={{ rotulo: NOME_EIXO[e.par[1]], valor: e.b }} corA="var(--bronze)" corB="var(--grafite-3)" />
            ))}
            <Aviso tipo="info">{AVISO_ESCORES}</Aviso>
            <ExplicaSigla sigla="Escore relativo" titulo="Por que 0 a 100 aqui não é percentil" />

            <h4 style={{ fontSize: 13, margin: '18px 0 6px' }}>O que significa cada eixo</h4>
            {r.eixosAuxiliares.flatMap(e => e.par).map(k => (
              <ExplicaSigla key={k} sigla={k} titulo={`${k} — ${NOME_EIXO[k]}`} />
            ))}
          </Card>
        </div>
      </Secao>

      {/* ══ BLOCO 4 — SUAS POTÊNCIAS ════════════════════════════════════ */}
      <Secao n="4" titulo="Suas potências">
        <Card sub="Cada potência abaixo carrega o escore que a sustenta — nada aqui é atribuído sem número.">
          <div className="grid g2">
            {potencias.map((x, i) => (
              <div className="bloco" key={i} style={{ borderLeftColor: p.cor }}>
                <h4>{x.titulo}</h4>
                <p style={{ marginBottom: 5 }}>{x.texto}</p>
                <Pill cor={p.cor}>{x.escore}</Pill>
              </div>
            ))}
          </div>
        </Card>
      </Secao>

      {/* ══ BLOCO 5 — LUZ E SOMBRA ══════════════════════════════════════ */}
      <Secao n="5" titulo="Luz e sombra">
        <Card titulo="Quando seus recursos trabalham a seu favor"
          sub="Luz — a expressão equilibrada da sua configuração.">
          <div className="grid g2">
            {luzes.map((l, i) => (
              <div className="bloco" key={i} style={{ borderLeftColor: p.cor }}>
                <h4>{l.titulo}</h4><p>{l.texto}</p>
                <p style={{ fontSize: 12.5, color: 'var(--ink3)', marginBottom: 0 }}>{l.evidencia}</p>
              </div>
            ))}
          </div>
        </Card>
        <Card titulo="Quando suas forças passam do ponto"
          sub="A sombra aqui não é defeito: é a mesma força em expressão excessiva ou menos consciente.">
          <Tabela colunas={['Força', 'Em equilíbrio', 'Quando excessiva', 'Origem']}
            linhas={sombras.map(s => [<b key="f">{s.forca}</b>, s.equilibrio, s.excesso,
              <span key="o" style={{ fontSize: 12, color: 'var(--ink3)' }}>{s.origem}</span>])} />
        </Card>
      </Secao>

      {/* ══ BLOCO 6 — O QUE VOCÊ TENDE A OFERECER À EQUIPE ══════════════ */}
      <Secao n="6" titulo="O que você tende a oferecer à equipe">
        <Card sub="Capacidades calculadas a partir das suas respostas comportamentais — não do seu perfil junguiano.">
          {contribs.map(c => (
            <div className="bloco" key={c.id} style={{ borderLeftColor: p.cor, marginBottom: 20 }}>
              <h4>{c.posicao}. {c.nome} <Pill cor={p.cor}>{c.valor} · {c.intensidade}</Pill></h4>
              <p><b>Significado.</b> {c.significado}</p>
              <p><b>Como aparece no trabalho.</b> {c.noTrabalho}</p>
              <p style={{ marginBottom: 0 }}><b>Quando é particularmente útil.</b> {c.quandoUtil}</p>
              <ExplicaSigla sigla={c.id}
                titulo={`Por que "${c.nome}" foi calculada assim (código ${c.id})`} />
            </div>
          ))}
          <h4 style={{ fontSize: 14, margin: '18px 0 8px' }}>As dez capacidades, em ordem</h4>
          <Barras max={100} altura={30}
            dados={r.capacidadesOrdenadas.map(c => ({ rotulo: c.nome, valor: c.valor, cor: p.cor, nota: c.intensidade }))} />
        </Card>

        <Card titulo="Recursos menos espontâneos"
          sub="Não são fraquezas: são recursos que tendem a exigir esforço deliberado.">
          <div className="grid g2">
            <div>
              {menos.capacidades.map(c => (
                <div className="bloco" key={c.nome}>
                  <h4>{c.nome} <Pill cor="var(--ink3)">{c.valor}</Pill></h4>
                  <p style={{ marginBottom: 0 }}>{c.texto}</p>
                </div>
              ))}
            </div>
            <div>
              <h4 style={{ fontSize: 14, marginBottom: 7 }}>Do seu padrão predominante</h4>
              <ul style={{ paddingLeft: 18, margin: '0 0 14px' }}>
                {menos.doPerfil.map((x, i) => <li key={i} style={{ marginBottom: 6 }}>{x}</li>)}
              </ul>
              <h4 style={{ fontSize: 14, marginBottom: 7 }}>Com quem você pode se complementar</h4>
              <p style={{ fontSize: 14, marginBottom: 0 }}>{menos.complementaridade}</p>
            </div>
          </div>
        </Card>
      </Secao>

      {/* ══ BLOCO 7 — CONTRIBUIÇÕES FUNCIONAIS / BELBIN ═════════════════ */}
      {/* Itens 34 a 38: apresentação mais profunda, MESMO cálculo. O gráfico
          com os nove papéis foi preservado — a interpretação foi adicionada. */}
      <Secao n="7" titulo="Sua contribuição funcional na equipe">
        <Card sub="Leitura inspirada nos Papéis de Equipe de Meredith Belbin.">
          <Aviso tipo="limite">{AVISO_BELBIN}</Aviso>
          <ExplicaSigla sigla="Belbin" titulo="Por que isto é proximidade, e não um teste de Belbin" />

          <h4 style={{ fontSize: 14.5, margin: '4px 0 12px' }}>Suas três maiores proximidades funcionais</h4>
          {bel.map(b => (
            <div className="belcard" key={b.id} style={{ ['--c' as any]: p.cor }}>
              <div className="pos">{b.posicao}ª maior proximidade funcional · dimensão {b.dimensao}</div>
              <h4>{b.nome} — proximidade {b.intensidade.toLowerCase()}</h4>
              <Medidor valor={b.valor} cor={p.cor} rotulo={b.intensidade} />
              <dl>
                <dt>Contribuição</dt><dd>{b.contribuicao}</dd>
                <dt>Como aparece no trabalho</dt><dd>{b.comoAparece}</dd>
                <dt>Onde agrega</dt><dd>{b.ondeAgrega.join(' · ')}</dd>
                <dt>Possível excesso</dt><dd>{b.excesso}</dd>
                <dt>Complementaridade</dt><dd>{b.complementaridade}</dd>
              </dl>
              <ExplicaSigla sigla={b.id} titulo={`Sobre o papel ${b.nome} (código ${b.id})`} />
              <ExplicaSigla sigla="Intensidade"
                titulo={`Por que ${b.valor} é lido como proximidade ${b.intensidade.toLowerCase()}`} />
            </div>
          ))}

          <h4 style={{ fontSize: 14, margin: '20px 0 8px' }}>Proximidade com os nove papéis</h4>
          <Barras max={100} altura={28}
            dados={r.belbinOrdenado.map(b => ({ rotulo: b.nome, valor: b.valor, cor: p.cor, nota: b.intensidade }))} />
          <p className="sr-only">
            {r.belbinOrdenado.map(b => `${b.nome}: ${b.valor}, ${b.intensidade}.`).join(' ')}
          </p>
        </Card>
      </Secao>

      {/* ══ BLOCO 8 — VOCÊ DENTRO DA SUA EQUIPE ════════════════════════ */}
      {comparacao && <VoceNaEquipe c={comparacao} r={r} setor={dados.setor} />}

      {/* Leitura de TODAS as siglas usadas neste relatório. Os grupos de
          administração ficam de fora: não fazem parte do que o participante vê. */}
      <Secao titulo="Leitura das siglas">
        <Glossario grupos={['jung', 'perfis', 'eixos', 'capacidades', 'belbin']}
          titulo="Todas as siglas deste relatório" />
      </Secao>

      <Aviso tipo="limite" titulo="Sobre este resultado">{AVISO_GERAL}</Aviso>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   BLOCO 8 — VOCÊ DENTRO DA SUA EQUIPE (Parte E, itens 28 a 33)
   --------------------------------------------------------------------------
   Item 32 — o participante vê SOMENTE agregados. Nomes, matrículas e
   resultados de colegas não chegam a esta tela, e a restrição é aplicada no
   banco, não aqui.
   Item 33 — abaixo de cinco avaliações válidas, nada de distribuição detalhada.
   ══════════════════════════════════════════════════════════════════════════ */
function VoceNaEquipe({ c, r, setor }: { c: ComparacaoIndividuo; r: ResultadoIndividual; setor: string }) {
  const p = PERFIL_POR_ID[r.perfilPrincipal];

  if (!c.disponivel) {
    return (
      <Secao n="8" titulo="Você dentro da sua equipe">
        <Card>
          <Aviso tipo="limite" titulo="Amostra insuficiente para comparação">
            {c.motivo}
          </Aviso>
          <p style={{ marginBottom: 0, fontSize: 14 }}>
            Este limite existe para proteger você e seus colegas: em grupos pequenos, uma distribuição detalhada
            permitiria identificar pessoas. Assim que a equipe tiver cinco ou mais avaliações concluídas, esta
            seção passa a exibir os agregados.
          </p>
        </Card>
      </Secao>
    );
  }

  const presenca = presencaNaConfiguracao(r, c);

  return (
    <Secao n="8" titulo="Você dentro da sua equipe">
      {/* Item 29 — as três frases exigidas, nesta ordem. */}
      <Card>
        <p style={{ fontSize: 16.5, marginBottom: 4 }}>
          <b>{setor}</b> possui <b>{c.nSetor} participantes</b> com avaliações válidas concluídas.
        </p>
        <p style={{ fontSize: 16.5, marginBottom: 4 }}>
          <b>{c.mesmoPerfil.n} pessoa(s)</b> apresentam o mesmo perfil predominante que você.
        </p>
        <p style={{ fontSize: 16.5, marginBottom: 0 }}>
          Isso representa <b>{c.mesmoPerfil.pct}%</b> dos respondentes da equipe.
        </p>

        {/* Item 30 — os quatro complementos. */}
        <div className="grid g4" style={{ marginTop: 18 }}>
          <div className="bloco" style={{ borderLeftColor: p.cor }}>
            <h4>Mesmo perfil predominante</h4>
            <p style={{ marginBottom: 0 }}>
              <b>{c.mesmoPerfil.n}</b> de {c.nSetor} · <b>{c.mesmoPerfil.pct}%</b>
            </p>
          </div>
          <div className="bloco">
            <h4>Mesma função dominante</h4>
            <p style={{ marginBottom: 0 }}>
              {c.mesmaFuncao.nome}: <b>{c.mesmaFuncao.n}</b> de {c.nSetor} · <b>{c.mesmaFuncao.pct}%</b>
            </p>
          </div>
          <div className="bloco">
            <h4>Mesma atitude</h4>
            <p style={{ marginBottom: 0 }}>
              {NOME_ATITUDE[c.atitudes.minha]}: <b>{c.atitudes[c.atitudes.minha]}</b> de {c.nSetor}
              <br />
              <span style={{ fontSize: 12.5, color: 'var(--ink3)' }}>
                Extroversão {c.atitudes.E} · Introversão {c.atitudes.I}
              </span>
            </p>
          </div>
          <div className="bloco">
            <h4>Posição relativa do perfil</h4>
            <p style={{ marginBottom: 0 }}>
              <b>{c.mesmoPerfil.posicao}º</b> mais representado, entre {c.mesmoPerfil.total} perfis presentes
            </p>
          </div>
        </div>
        <Aviso tipo="info">{c.nota}</Aviso>
      </Card>

      {/* Item 31 — o que a presença acrescenta, a partir de dados já calculados. */}
      <Card titulo="O que sua presença acrescenta à configuração da equipe"
        sub="Leitura construída sobre os números acima e sobre os seus próprios escores. Não é uma nova classificação.">
        <div className="grid g2">
          {presenca.map((x, i) => (
            <div className="bloco" key={i} style={{ borderLeftColor: i === 0 ? p.cor : undefined }}>
              <h4>{x.titulo}</h4>
              <p style={{ marginBottom: 0 }}>{x.texto}</p>
            </div>
          ))}
        </div>
        <p style={{ marginTop: 14, marginBottom: 0 }}>{c.contribuicao}</p>
      </Card>

      <Aviso tipo="limite" titulo="Privacidade">
        Você visualiza apenas quantidades, percentuais e distribuição agregada. Nomes, matrículas e
        resultados individuais de colegas não são acessíveis — a restrição é aplicada no banco de dados,
        não apenas nesta tela.
      </Aviso>
    </Secao>
  );
}
