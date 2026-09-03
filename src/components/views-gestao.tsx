'use client';
/**
 * EXPERIÊNCIA DA LIDERANÇA E DO ADMINISTRADOR (itens 30 a 51, 57 a 68, 70, 71)
 * ---------------------------------------------------------------------------
 * Camada exclusiva: nada aqui é visível ao participante.
 */
import React, { useState } from 'react';
import {
  Card, Kpi, Aviso, Barras, BarraDupla, Cobertura, Tabela, Pill, Medidor,
  Secao, FluxoComplementaridade, Vazio, Checklist, FaixaAnimais, TabelaMatriz, Totem,
  PorQue, ExplicaSigla, Glossario, CORES_FUNCAO, CORES_ATITUDE
} from './ui';
import { dataBR, dataHoraBR } from '../lib/datas';
import { PERFIL_POR_ID, PERFIS, NOME_FUNCAO, NOME_ATITUDE } from '../data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN } from '../data/functional';
import { QUESTOES, NOME_EIXO, VERSAO_INSTRUMENTO, TOTAL_QUESTOES, TOTAL_ALTERNATIVAS, TOTAL_ANCORAS } from '../data/questions';
import { MAXIMO_CAPACIDADE, MAXIMO_BELBIN, VERSAO_MATRIZ, type LinhaMatriz } from '../data/matriz';
import type { AnaliseEquipe, MembroAgregado } from '../lib/aggregate';
import { LIMIAR_PORTADOR, MIN_PARTICIPANTES_INTERPRETACAO } from '../lib/aggregate';
import type { ComposicaoAnimais, MatrizAnimais } from '../lib/animais';
import { Animal } from './animais-svg';
import type { ResultadoIndividual } from '../lib/resultado';
import {
  blocosLeituraExecutiva, leituraExecutivaIndividual, leituraIDF, leituraICF,
  AVISO_BELBIN, AVISO_GERAL
} from '../lib/narrative';

/* ══════════════════════════════════════════════════════════════════════════
   DASHBOARD DA EQUIPE — seis seções (Parte H, itens 42 a 48)
   --------------------------------------------------------------------------
   REORGANIZAÇÃO DE LEITURA. Todos os dados da versão anterior continuam aqui,
   na ordem pedida:

     1 SÍNTESE · 2 COMPOSIÇÃO · 3 DIVERSIDADE · 4 COBERTURA
     5 INTERPRETAÇÃO · 6 AÇÃO

   As fórmulas de IDF, ICF e complementaridade NÃO foram tocadas.
   ══════════════════════════════════════════════════════════════════════════ */

export function TelaEquipe({ titulo, a, animais }: {
  titulo: string;
  a: AnaliseEquipe;
  /** Item 66 — vem da rotina ÚNICA `composicaoAnimais()`, a mesma do Excel. */
  animais: ComposicaoAnimais;
}) {
  /* Item 23 — estado vazio explícito, sem dado artificial para preencher gráfico. */
  if (a.n === 0) return (
    <Card titulo={titulo}>
      <Vazio>Nenhum participante desta equipe concluiu a avaliação até o momento.</Vazio>
    </Card>
  );
  const blocos = blocosLeituraExecutiva(titulo, a);
  const cobMais = [...a.cobertura].sort((x, y) => y.valor - x.valor)[0];
  const perfilMaior = a.distribuicaoPerfis.find(p => p.perfil === a.concentracao.maiorPerfil);

  return (
    <div>
      {a.avisoAmostra && <Aviso tipo="limite" titulo="Grupo pequeno">{a.avisoAmostra}</Aviso>}

      {/* Item 56 — se a soma dos animais não bater com o total, o sistema fala. */}
      {animais.inconsistencia && (
        <Aviso tipo="alerta" titulo="Inconsistência detectada na composição">{animais.inconsistencia}</Aviso>
      )}

      {/* ══ 1 · SÍNTESE ═════════════════════════════════════════════════ */}
      {/* Item 25 — a primeira dobra responde de imediato: qual equipe,
          quantas pessoas, como está configurada. O detalhe vem depois. */}
      <div className="dobra">
        <div>
          <div className="rot">Equipe</div>
          <h2>{titulo.replace(/^Equipe\s+/, '')}</h2>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div className="n">{a.n}</div>
          <div className="d">respondentes com avaliação concluída</div>
        </div>
      </div>

      <Secao n="1" titulo="Síntese">
        <div className="grid g4">
          <Kpi rotulo="Participantes" valor={a.n} cor="var(--grafite)" sigla="n"
            leitura={a.n < 5
              ? 'Amostra pequena: os índices abaixo são instáveis e a distribuição detalhada fica oculta.'
              : `${a.concentracao.perfisPresentes} dos 8 perfis estão presentes nesta equipe.`}
            ajuda={`${a.concentracao.perfisPresentes} dos 8 perfis presentes`} />

          <Kpi rotulo="IDF — Diversidade Funcional" valor={a.idf} faixa={a.idfFaixa} cor="var(--grafite)" sigla="IDF"
            leitura={leituraIDF(a)}
            ajuda={`Perfis ${a.idfComponentes.perfis} · funções ${a.idfComponentes.funcoes} · dispersão real dos escores ${a.idfComponentes.dispersaoVetorial}`} />

          <Kpi rotulo="ICF — Cobertura Funcional" valor={a.icf} faixa={a.icfFaixa} cor="var(--bronze)" sigla="ICF"
            leitura={leituraICF(a)}
            ajuda="A equipe possui recursos comportamentais suficientes para as diferentes funções do trabalho coletivo?" />

          <Kpi rotulo="Complementaridade" valor={`${a.complementaridade.pct}%`} cor="var(--amarelo)" sigla="Complementaridade"
            leitura={a.complementaridade.pct === 100
              ? 'Todas as dez capacidades têm ao menos um portador. Atenção: ter alguém não é o mesmo que ter cobertura — veja o ICF ao lado.'
              : `${a.complementaridade.total - a.complementaridade.capacidadesCobertas} capacidade(s) não têm nenhum portador acima do limiar nesta equipe.`}
            ajuda={`${a.complementaridade.capacidadesCobertas} das ${a.complementaridade.total} capacidades têm ao menos um portador`} />
        </div>
        <div className="grid g2">
          <Kpi rotulo="Principal concentração" valor={perfilMaior?.animal ?? '—'} cor={perfilMaior?.cor} sigla="HHI"
            leitura={a.concentracao.hhi >= 0.30
              ? `Concentração acentuada: ${a.concentracao.maiorPerfilPct}% da equipe compartilha o mesmo perfil. Isso costuma facilitar acordo e dificultar que uma leitura seja testada.`
              : `Sem concentração acentuada. O maior grupo reúne ${a.concentracao.maiorPerfilPct}% da equipe.`}
            ajuda={perfilMaior
              ? `${perfilMaior.nome} · ${perfilMaior.n} pessoa(s), ${a.concentracao.maiorPerfilPct}% da equipe · índice de concentração ${a.concentracao.hhi}`
              : 'sem respondentes'} />
          <Kpi rotulo="Capacidade mais representada" valor={cobMais.nome} cor="var(--bronze)" sigla={cobMais.capacidade}
            leitura={`É a capacidade com maior cobertura aqui: ${cobMais.portadores} pessoa(s) acima do limiar, cobertura ${cobMais.valor}%.`}
            ajuda={`Cobertura ${cobMais.valor}% · ${cobMais.nivel} · ${cobMais.portadores} portador(es) acima do limiar`} />
        </div>
        <Card titulo="Como ler estes dois índices"
          sub="A interpretação fica aqui, à vista. Cada bloco abre a razão de o cálculo ser assim.">
          <div className="grid g2">
            <div className="bloco" style={{ borderLeftColor: 'var(--grafite)' }}>
              <h4>IDF — Índice de Diversidade Funcional</h4>
              <p style={{ marginBottom: 0 }}>
                Mede <b>quanta variedade de perspectivas</b> existe. Não mede qualidade nem competência.
              </p>
              <ExplicaSigla sigla="IDF" titulo="Por que o IDF é calculado assim" />
            </div>
            <div className="bloco" style={{ borderLeftColor: 'var(--bronze)' }}>
              <h4>ICF — Índice de Cobertura Funcional</h4>
              <p style={{ marginBottom: 0 }}>
                Mede se a equipe <b>possui os recursos</b> que o trabalho coletivo exige.
              </p>
              <ExplicaSigla sigla="ICF" titulo="Por que o ICF é calculado assim" />
            </div>
          </div>
          <Aviso tipo="info" titulo="São independentes — e é aí que a leitura fica útil">
            Pode haver <b>IDF alto com ICF baixo</b>: gente muito diferente entre si e, ainda assim, ninguém
            forte naquilo que o trabalho exige. E o contrário também acontece. Um número único esconderia
            essa distinção.
            <ExplicaSigla sigla="IDF × ICF" titulo="Por que são dois índices, e não um" />
          </Aviso>
          <Aviso tipo="limite" titulo="O que estes números NÃO são">
            As faixas (baixa, moderada, alta) são <b>parâmetros internos exploratórios</b>, não normas
            populacionais — o instrumento não foi normatizado, então não existe "IDF bom".
            <b> Diversidade não é qualidade</b>: a configuração adequada depende da natureza do trabalho.
          </Aviso>
        </Card>
      </Secao>

      {/* ══ 2 · COMPOSIÇÃO (itens 44 e 49 a 55) ═════════════════════════ */}
      <Secao n="2" titulo="Composição">
        <Card titulo="Composição simbólica da equipe"
          sub="Os oito animais do instrumento, com quantidade e percentual. As categorias sem ninguém continuam visíveis.">
          <FaixaAnimais linhas={animais.linhas} />

          <div className="grid g2" style={{ marginTop: 18 }}>
            <div className="bloco" style={{ borderLeftColor: animais.maisRepresentado?.cor }}>
              <h4>Maior representação relativa</h4>
              <p style={{ marginBottom: 0 }}>
                <b>{animais.maisRepresentado?.animal}</b> — {animais.maisRepresentado?.n} pessoa(s),
                {' '}{animais.maisRepresentado?.pct}% da equipe.
                <br /><span style={{ fontSize: 13, color: 'var(--ink3)' }}>{animais.maisRepresentado?.nomeJung}</span>
              </p>
            </div>
            <div className="bloco">
              <h4>Menor representação relativa</h4>
              <p style={{ marginBottom: 0 }}>
                <b>{animais.menosRepresentado?.animal}</b> — {animais.menosRepresentado?.n} pessoa(s),
                {' '}{animais.menosRepresentado?.pct}% da equipe.
                <br /><span style={{ fontSize: 13, color: 'var(--ink3)' }}>{animais.menosRepresentado?.nomeJung}</span>
              </p>
            </div>
          </div>

          <h4 style={{ fontSize: 14, margin: '20px 0 8px' }}>Tabela completa</h4>
          <Tabela colunas={['Animal', 'Configuração junguiana', 'Quantidade', 'Percentual']}
            linhas={animais.linhas.map(l => [
              <b key="a" style={{ color: l.n ? l.cor : 'var(--ink4)' }}>{l.animal}</b>,
              l.nomeJung,
              <span key="n" style={{ fontVariantNumeric: 'tabular-nums' }}>{l.n}</span>,
              <span key="p" style={{ fontVariantNumeric: 'tabular-nums' }}>{l.pct}%</span>
            ])} />
          <p style={{ fontSize: 12.5, color: 'var(--ink3)', marginTop: 10, marginBottom: 0 }}>
            Soma dos oito animais: <b>{animais.somaAnimais}</b> · total de avaliações válidas da equipe:
            {' '}<b>{animais.total}</b>{animais.somaConfere ? ' — conferem.' : ' — NÃO conferem.'}
          </p>
        </Card>

        <div className="grid g3">
          <Card titulo="Funções (média dos escores)">
            <Barras max={60} altura={32} dados={a.distribuicaoFuncoes.map(f => ({
              rotulo: f.nome, valor: f.media, cor: CORES_FUNCAO[f.funcao], nota: `${f.n} com dominância (${f.pct}%)`
            }))} />
          </Card>
          <Card titulo="Atitudes">
            <BarraDupla a={{ rotulo: 'Extroversão', valor: a.distribuicaoAtitudes[0].media }}
              b={{ rotulo: 'Introversão', valor: a.distribuicaoAtitudes[1].media }}
              corA={CORES_ATITUDE.E} corB={CORES_ATITUDE.I} />
            <p style={{ fontSize: 12.5, color: 'var(--ink3)', marginTop: 6 }}>
              {a.distribuicaoAtitudes[0].n} participante(s) com predominância extrovertida ·
              {' '}{a.distribuicaoAtitudes[1].n} introvertida.
            </p>
          </Card>
          <Card titulo="Perfis junguianos">
            <Barras sufixo="%" altura={30} dados={a.distribuicaoPerfis
              .map(p => ({ rotulo: p.animal, valor: p.pct, cor: p.n ? p.cor : '#B4A996', nota: `${p.n} · ${p.nome}` }))} />
          </Card>
        </div>
      </Secao>

      {/* ══ 3 · DIVERSIDADE (item 45) ═══════════════════════════════════ */}
      <Secao n="3" titulo="Diversidade">
        <Card titulo={`IDF — Índice de Diversidade Funcional: ${a.idf} (${a.idfFaixa})`}
          sub="Fórmula preservada: 25% entropia dos perfis + 25% entropia das funções + 50% dispersão real dos escores.">
          <div className="grid g3">
            <Kpi rotulo="Componente · perfis (peso 25%)" valor={a.idfComponentes.perfis} cor="var(--grafite)"
              leitura="Quão espalhadas as pessoas estão pelos oito perfis."
              ajuda="Entropia normalizada da distribuição dos 8 perfis" />
            <Kpi rotulo="Componente · funções (peso 25%)" valor={a.idfComponentes.funcoes} cor="var(--grafite-3)"
              leitura="Quão espalhadas as pessoas estão pelas quatro funções dominantes."
              ajuda="Entropia normalizada da distribuição das 4 funções dominantes" />
            <Kpi rotulo="Componente · dispersão (peso 50%)" valor={a.idfComponentes.dispersaoVetorial} cor="var(--bronze-2)"
              leitura="A variação nos escores reais, e não apenas nos rótulos. É o componente de maior peso."
              ajuda="Desvio-padrão médio dos 22 escores contínuos de cada participante" />
          </div>
          <PorQue titulo="Por que a dispersão pesa mais do que as duas entropias somadas">
            <p>
              Contar rótulos é grosseiro. Duas equipes podem ter exatamente a mesma contagem de
              "três Lobos e dois Ursos" e ser muito diferentes por dentro, porque o rótulo esconde a
              distância entre os escores que o produziram — alguém com Pensamento 51 e alguém com
              Pensamento 92 recebem o mesmo rótulo.
            </p>
            <p>
              A dispersão olha os 22 escores contínuos de cada pessoa e mede o quanto eles de fato variam
              dentro do grupo. As duas entropias continuam entrando porque variedade de rótulos é
              informação legítima — mas seriam uma leitura pobre se usadas sozinhas.
            </p>
          </PorQue>
          <h4 style={{ fontSize: 14, margin: '18px 0 8px' }}>Distribuição que sustenta o índice</h4>
          <Barras sufixo="%" altura={28} dados={a.distribuicaoPerfis.map(p => ({
            rotulo: `${p.animal} · ${p.nome}`, valor: p.pct, cor: p.n ? p.cor : '#B4A996', nota: `${p.n} pessoa(s)`
          }))} />
          <h4 style={{ fontSize: 14, margin: '18px 0 8px' }}>Seis eixos comportamentais</h4>
          <Barras max={60} dados={a.distribuicaoEixos.map(e => ({ rotulo: e.nome, valor: e.media, cor: 'var(--grafite-3)' }))} />
        </Card>
      </Secao>

      {/* ══ 4 · COBERTURA (item 46) ═════════════════════════════════════ */}
      <Secao n="4" titulo="Cobertura">
        <Card titulo={`ICF — Índice de Cobertura Funcional: ${a.icf} (${a.icfFaixa})`}
          sub="Calculada a partir dos escores comportamentais individuais; referência funcional inspirada nos nove papéis de Belbin.">
          <p style={{ marginTop: 0 }}>{leituraICF(a)}</p>
          <Cobertura dados={a.cobertura} />
          <ExplicaSigla sigla="ICF" titulo="Por que a presença de portadores pesa mais que a média" />
          <ExplicaSigla sigla="Portador" titulo="Por que o limiar é 50 — e por que isso é uma escolha, não uma medição" />
        </Card>
        <Card titulo="Mapa de complementaridade"
          sub="O ciclo completo do trabalho coletivo e o nível de cobertura de cada etapa">
          <FluxoComplementaridade etapas={CAPACIDADES.map(c => {
            const x = a.cobertura.find(v => v.capacidade === c.id)!;
            return { nome: c.nome, valor: x.valor, nivel: x.nivel };
          })} />
        </Card>
        <Card titulo="Leitura funcional da equipe"
          sub="Referencial inspirado nos Papéis de Equipe de Belbin — valores calculados a partir das respostas dos participantes">
          <Aviso tipo="limite">{AVISO_BELBIN}</Aviso>
          <div className="grid g2">
            <Barras max={100} altura={30} dados={a.belbinEquipe.map(b => ({
              rotulo: b.nome, valor: b.media, cor: b.dimensao === 'tarefa' ? 'var(--grafite)' : 'var(--amarelo)',
              nota: `${b.intensidade} · ${b.portadores} acima do limiar`
            }))} />
            <div>
              {a.leituraBelbin.map((t, i) => (
                <p key={i} style={{ fontSize: 14, color: i === a.leituraBelbin.length - 1 ? 'var(--ink3)' : undefined }}>{t}</p>
              ))}
              <p style={{ fontSize: 12, color: 'var(--ink3)', marginBottom: 0 }}>
                Azul: papéis da dimensão tarefa. Cobre: dimensão relacionamento.
              </p>
            </div>
          </div>
        </Card>
      </Secao>

      {/* ══ 5 · INTERPRETAÇÃO (item 47) ═════════════════════════════════ */}
      <Secao n="5" titulo="Interpretação">
        <Card titulo="Leitura executiva"
          sub="Quem somos · onde somos fortes · onde estamos concentrados · o que aparece menos · onde existe complementaridade">
          {blocos.map(b => (
            <div className="bloco" key={b.titulo} style={{ marginBottom: 22 }}>
              <h4 style={{ fontSize: 17 }}>{b.titulo}</h4>
              <p>{b.texto}</p>
              {b.itens?.length ? <ul>{b.itens.map((i, k) => <li key={k}>{i}</li>)}</ul> : null}
            </div>
          ))}
        </Card>

        <div className="grid g2">
          <Card titulo="Potências coletivas" sub="Toda conclusão é sustentada pelos dados agregados">
            {a.potencias.map((p, i) => (
              <div className="bloco" key={i} style={{ borderLeftColor: 'var(--bronze)' }}>
                <h4>{p.titulo}</h4><p style={{ marginBottom: 0, fontSize: 13.5 }}>{p.evidencia}</p>
              </div>
            ))}
          </Card>
          <Card titulo="Quando uma força coletiva passa do ponto"
            sub="A sombra coletiva é sempre o excesso de uma potência — não é diagnóstico da equipe">
            {a.sombraColetiva.length ? a.sombraColetiva.map((s, i) => (
              <div className="bloco" key={i} style={{ borderLeftColor: 'var(--amarelo)' }}>
                <h4>{s.titulo}</h4>
                <p style={{ marginBottom: 3, fontSize: 13.5 }}><b>Potência:</b> {s.potencia.join(', ')}.</p>
                <p style={{ marginBottom: 0, fontSize: 13.5 }}><b>Possível sombra coletiva:</b> {s.sombra.join(', ')}.</p>
              </div>
            )) : <p style={{ marginBottom: 0 }}>Nenhum padrão de excesso coletivo foi identificado nos dados atuais.</p>}
          </Card>
        </div>

        <Card titulo="Recursos pouco representados" sub="Capacidades com menor cobertura na configuração atual">
          {a.lacunas.map(l => (
            <div className="bloco" key={l.capacidade} style={{ borderLeftColor: 'var(--limite)' }}>
              <h4>{l.nome} — cobertura {l.valor}%</h4>
              <p style={{ marginBottom: 0, fontSize: 13.5 }}>{l.interpretacao}</p>
            </div>
          ))}
        </Card>
      </Secao>

      {/* ══ 6 · AÇÃO (item 48) ══════════════════════════════════════════ */}
      <Secao n="6" titulo="Ação">
        <Card titulo="Como liderar esta configuração"
          sub="Sugestões de desenvolvimento e de organização do trabalho, condicionadas aos dados acima.">
          <Aviso tipo="limite" titulo="O que estas sugestões não são">
            Nenhuma delas prescreve cargo, e o instrumento não recomenda contratar, promover, transferir,
            punir ou desligar. Servem a desenvolvimento e à organização consciente do trabalho.
          </Aviso>
          <div className="grid g2">
            {a.acoesLideranca.map((x, i) => (
              <div className="bloco" key={i}>
                <h4>{x.titulo}</h4>
                <ul>{x.itens.map((it, k) => <li key={k}>{it}</li>)}</ul>
              </div>
            ))}
          </div>
          <h4 style={{ fontSize: 14, margin: '18px 0 8px' }}>Frentes de desenvolvimento</h4>
          <Tabela colunas={['Frente', 'Possibilidade de desenvolvimento']}
            linhas={a.recomendacoes.map(r => [<b key="t">{r.tipo}</b>, r.texto])} />
        </Card>
      </Secao>
    </div>
  );
}



/* ══════════════ VISÃO ORGANIZACIONAL (item 35) ══════════════════════════ */

export function TelaVisaoOrganizacional({ a, resumo, animais }: {
  a: AnaliseEquipe;
  resumo: { totalParticipantes: number; concluidas: number; incompletas: number; setores: number };
  /** Item 66 — mesma rotina que alimenta o Excel. */
  animais: ComposicaoAnimais;
}) {
  /* Item 23 — zero respondentes é um estado válido e informativo. Os quatro
     contadores reais continuam visíveis; o que não existe é análise inventada. */
  if (a.n === 0) {
    return (
      <div>
        <div className="grid g4">
          <Kpi rotulo="Total de participantes" valor={resumo.totalParticipantes} cor="var(--grafite)" />
          <Kpi rotulo="Avaliações concluídas" valor={resumo.concluidas} cor="var(--bronze)" />
          <Kpi rotulo="Avaliações em andamento" valor={resumo.incompletas} cor="var(--amarelo)" ajuda="Iniciadas e ainda não finalizadas" />
          <Kpi rotulo="Setores" valor={resumo.setores} cor="var(--grafite)" />
        </div>
        <Card titulo="Análise organizacional">
          <Vazio>
            {resumo.incompletas > 0
              ? <>Há {resumo.incompletas} avaliação(ões) em andamento e nenhuma concluída ainda. Os indicadores —
                  IDF, ICF, distribuição de perfis, cobertura funcional e comparação entre equipes — passam a ser
                  calculados assim que a primeira avaliação for finalizada.</>
              : <>Nenhuma avaliação concluída até o momento. Assim que os participantes responderem, os
                  indicadores aparecem aqui, calculados a partir dos dados reais.</>}
          </Vazio>
        </Card>
      </div>
    );
  }

  const perfilMais = [...a.distribuicaoPerfis].sort((x, y) => y.n - x.n)[0];
  const perfilMenos = [...a.distribuicaoPerfis].filter(p => p.n > 0).sort((x, y) => x.n - y.n)[0];
  const fnMais = [...a.distribuicaoFuncoes].sort((x, y) => y.media - x.media)[0];
  const fnMenos = [...a.distribuicaoFuncoes].sort((x, y) => x.media - y.media)[0];
  const cobMais = [...a.cobertura].sort((x, y) => y.valor - x.valor)[0];
  const cobMenos = [...a.cobertura].sort((x, y) => x.valor - y.valor)[0];

  return (
    <div>
      <div className="grid g4">
        <Kpi rotulo="Total de participantes" valor={resumo.totalParticipantes} cor="var(--grafite)" />
        <Kpi rotulo="Avaliações concluídas" valor={resumo.concluidas} cor="var(--bronze)" />
        <Kpi rotulo="Avaliações incompletas" valor={resumo.incompletas} cor="var(--amarelo)" ajuda="Iniciadas e ainda não finalizadas" />
        <Kpi rotulo="Setores" valor={resumo.setores} cor="var(--grafite)" />
      </div>
      <div className="grid g4">
        <Kpi rotulo="IDF geral" valor={a.idf} faixa={a.idfFaixa} cor="var(--grafite)" />
        <Kpi rotulo="ICF geral" valor={a.icf} faixa={a.icfFaixa} cor="var(--bronze)" />
        <Kpi rotulo="Perfil mais frequente" valor={perfilMais?.animal ?? '—'} cor={perfilMais?.cor}
          ajuda={perfilMais ? `${perfilMais.nome} · ${perfilMais.n} pessoa(s), ${perfilMais.pct}%` : ''} />
        <Kpi rotulo="Perfil menos frequente" valor={perfilMenos?.animal ?? '—'} cor={perfilMenos?.cor}
          ajuda={perfilMenos ? `${perfilMenos.nome} · ${perfilMenos.n} pessoa(s), ${perfilMenos.pct}%` : ''} />
      </div>
      <div className="grid g4">
        <Kpi rotulo="Função mais presente" valor={fnMais.nome} cor={CORES_FUNCAO[fnMais.funcao]} ajuda={`Média ${fnMais.media}`} />
        <Kpi rotulo="Função menos presente" valor={fnMenos.nome} cor={CORES_FUNCAO[fnMenos.funcao]} ajuda={`Média ${fnMenos.media}`} />
        <Kpi rotulo="Capacidade mais coberta" valor={cobMais.nome} cor="var(--bronze)" ajuda={`${cobMais.valor}% · ${cobMais.nivel}`} />
        <Kpi rotulo="Capacidade menos coberta" valor={cobMenos.nome} cor="var(--limite)" ajuda={`${cobMenos.valor}% · ${cobMenos.nivel}`} />
      </div>
      <TelaEquipe titulo="Organização (todos os setores)" a={a} animais={animais} />
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   VISÃO ORGANIZACIONAL DOS ANIMAIS — Parte J (itens 57 a 59)
   --------------------------------------------------------------------------
   Matriz Equipe × Animal, alternando quantidade e percentual. A fonte é a
   MESMA rotina do Excel (`matrizAnimais`), o que garante o item 67.
   ══════════════════════════════════════════════════════════════════════════ */

export function TelaAnimais({ m, filtros }: {
  m: MatrizAnimais;
  /** Item 59 — descrição textual dos filtros aplicados, para leitura e auditoria. */
  filtros?: { rotulo: string; valor: string }[];
}) {
  const [modo, setModo] = useState<'quantidade' | 'percentual'>('quantidade');

  if (m.organizacao.total === 0) {
    return (
      <Card titulo="Composição simbólica da organização">
        <Vazio>Nenhuma avaliação concluída até o momento. A matriz por equipe aparece assim que houver respondentes.</Vazio>
      </Card>
    );
  }

  const colunas = ['Equipe', ...m.animais.map(a => a.animal), 'Total'];

  return (
    <div>
      {m.inconsistencias.length > 0 && (
        <Aviso tipo="alerta" titulo="Inconsistência detectada">
          <ul style={{ marginBottom: 0 }}>{m.inconsistencias.map((x, i) => <li key={i}>{x}</li>)}</ul>
        </Aviso>
      )}

      {filtros && filtros.length > 0 && (
        <Card titulo="Filtros aplicados" sub="Os mesmos filtros valem para a matriz abaixo e para a exportação.">
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {filtros.map(f => <Pill key={f.rotulo}>{f.rotulo}: {f.valor}</Pill>)}
          </div>
        </Card>
      )}

      <Secao n="1" titulo="Composição simbólica da organização">
        <Card sub={`${m.organizacao.total} avaliações válidas concluídas em ${m.equipes.length} equipe(s).`}>
          <FaixaAnimais linhas={m.organizacao.linhas} />
          <div className="grid g2" style={{ marginTop: 18 }}>
            <div className="bloco" style={{ borderLeftColor: m.organizacao.maisRepresentado?.cor }}>
              <h4>Maior representação relativa</h4>
              <p style={{ marginBottom: 0 }}>
                <b>{m.organizacao.maisRepresentado?.animal}</b> — {m.organizacao.maisRepresentado?.n} pessoa(s),
                {' '}{m.organizacao.maisRepresentado?.pct}% da organização.
              </p>
            </div>
            <div className="bloco">
              <h4>Menor representação relativa</h4>
              <p style={{ marginBottom: 0 }}>
                <b>{m.organizacao.menosRepresentado?.animal}</b> — {m.organizacao.menosRepresentado?.n} pessoa(s),
                {' '}{m.organizacao.menosRepresentado?.pct}% da organização.
              </p>
            </div>
          </div>
        </Card>
      </Secao>

      <Secao n="2" titulo="Matriz equipe por animal">
        <Card titulo="Equipe por animal"
          sub="Cada linha soma o total de avaliações válidas da equipe. As células em zero permanecem visíveis."
          acao={
            <div className="filters" style={{ margin: 0 }}>
              {([['quantidade', 'Quantidade'], ['percentual', 'Percentual']] as const).map(([k, l]) => (
                <button key={k} aria-pressed={modo === k} onClick={() => setModo(k)}>{l}</button>
              ))}
            </div>
          }>
          <TabelaMatriz colunas={colunas}
            legenda={`Matriz de equipes por animal, em ${modo}.`}
            linhas={[
              ...m.equipes.map(e => ({
                rotulo: e.equipe,
                valores: e.linhas.map(l => (modo === 'quantidade' ? l.n : l.pct)),
                total: modo === 'quantidade' ? e.total : '100%'
              })),
              {
                rotulo: 'ORGANIZAÇÃO',
                valores: m.organizacao.linhas.map(l => (modo === 'quantidade' ? l.n : l.pct)),
                total: modo === 'quantidade' ? m.organizacao.total : '100%',
                destaque: true
              }
            ]} />
          <p style={{ fontSize: 12.5, color: 'var(--ink3)', marginTop: 10, marginBottom: 0 }}>
            {modo === 'quantidade'
              ? 'Valores em número de pessoas. A coluna Total repete o número de avaliações válidas da equipe.'
              : 'Valores em percentual da própria equipe. Cada linha totaliza 100%, salvo arredondamento de uma casa decimal.'}
          </p>
        </Card>
      </Secao>

      <Secao n="3" titulo="Detalhe por equipe">
        {m.equipes.map(e => (
          <Card key={e.equipe} titulo={e.equipe}
            sub={`${e.total} avaliação(ões) válida(s) · maior representação: ${e.maisRepresentado?.animal} (${e.maisRepresentado?.pct}%) · menor: ${e.menosRepresentado?.animal} (${e.menosRepresentado?.pct}%)`}>
            <FaixaAnimais linhas={e.linhas} />
          </Card>
        ))}
      </Secao>

      <Aviso tipo="limite" titulo="Como ler esta composição">
        Os animais são <b>metáforas didáticas</b> da configuração junguiana predominante, não classificação de
        pessoas. Uma equipe sem determinado animal não tem uma falha: tem uma configuração. A leitura correta é
        de <b>menor representação relativa</b>, e a decisão sobre o que fazer com isso depende da natureza do
        trabalho, não do instrumento.
      </Aviso>
    </div>
  );
}

/* ══════════════ COMPARATIVO ORGANIZACIONAL (item 51) ════════════════════ */

type LinhaComp = ReturnType<typeof import('../lib/aggregate').compararSetores>[number];

export function TelaComparacao({ linhas }: { linhas: LinhaComp[] }) {
  /* Item 23 */
  if (!linhas.length) return (
    <Card titulo="Comparativo entre equipes">
      <Vazio>Ainda não há equipes com avaliações concluídas para comparar.</Vazio>
    </Card>
  );
  const [aba, setAba] = useState<'indices' | 'jung' | 'eixos' | 'capacidades' | 'belbin'>('indices');
  const abas: [typeof aba, string][] = [
    ['indices', 'IDF e ICF'], ['jung', 'Funções e atitudes'], ['eixos', 'Seis eixos'],
    ['capacidades', 'Capacidades'], ['belbin', 'Belbin']
  ];
  const nome = (l: LinhaComp) => (
    <span><b>{l.setor}</b>{!l.amostraSuficiente && <> <Pill cor="var(--limite)">n&lt;5</Pill></>}</span>
  );

  return (
    <div>
      <Aviso tipo="info" titulo="Sem ranking de melhor equipe">
        A comparação mostra <b>diferenças estruturais</b> de configuração, não qualidade. Equipes com poucos
        respondentes aparecem marcadas: seus indicadores são instáveis.
      </Aviso>
      <Card titulo="Comparativo organizacional" acao={
        <div className="filters" style={{ margin: 0 }}>
          {abas.map(([k, l]) => <button key={k} aria-pressed={aba === k} onClick={() => setAba(k)}>{l}</button>)}
        </div>
      }>
        {aba === 'indices' && <Tabela colunas={['Equipe', 'N', 'IDF', 'ICF', 'Perfil mais presente', 'Capacidade mais coberta', 'Menos coberta']}
          linhas={linhas.map(l => [nome(l), l.n, l.idf, l.icf, `${l.perfilTop?.animal ?? '—'} (${l.perfilTop?.n ?? 0})`, l.coberturaTopo, l.coberturaBase])} />}
        {aba === 'jung' && <Tabela colunas={['Equipe', 'N', 'Pensamento', 'Sentimento', 'Sensação', 'Intuição', 'Extroversão', 'Introversão']}
          linhas={linhas.map(l => [nome(l), l.n, l.funcoes.T, l.funcoes.F, l.funcoes.S, l.funcoes.N, l.atitudes.E, l.atitudes.I])} />}
        {aba === 'eixos' && <Tabela colunas={['Equipe', 'N', ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => NOME_EIXO[e])]}
          linhas={linhas.map(l => [nome(l), l.n, ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => l.eixos[e])])} />}
        {aba === 'capacidades' && <Tabela colunas={['Equipe', 'N', ...CAPACIDADES.map(c => c.nome)]}
          linhas={linhas.map(l => [nome(l), l.n, ...CAPACIDADES.map(c => {
            const v = l.capacidades[c.id];
            return <span key={c.id} style={{ fontWeight: v >= 70 ? 700 : 400, color: v >= 70 ? 'var(--bronze)' : v < 40 ? 'var(--limite)' : undefined }}>{v}</span>;
          })])} />}
        {aba === 'belbin' && <Tabela colunas={['Equipe', 'N', ...PAPEIS_BELBIN.map(p => p.nome)]}
          linhas={linhas.map(l => [nome(l), l.n, ...PAPEIS_BELBIN.map(p => l.belbin[p.id])])} />}
      </Card>
    </div>
  );
}

/* ══════════════ LEITURA EXECUTIVA INDIVIDUAL (itens 30 a 33) ════════════ */

export function TelaLeituraExecutivaIndividual({ r, dados }: {
  r: ResultadoIndividual; dados: { nome: string; matricula: string; setor: string; data: string };
}) {
  const L = leituraExecutivaIndividual(r);
  const p = PERFIL_POR_ID[r.perfilPrincipal];
  const linha = (t: string, c: React.ReactNode) => [<b key="t">{t}</b>, c];

  return (
    <div>
      <Aviso tipo="limite" titulo="Leitura executiva — acesso restrito">
        Esta camada é diferente da devolutiva entregue ao participante e é visível apenas a administradores e
        líderes autorizados. {L.limite}
      </Aviso>
      <Card>
        <div style={{ display: 'flex', gap: 16, alignItems: 'center', flexWrap: 'wrap' }}>
          <div style={{ width: 54, height: 54, borderRadius: 13, background: p.cor, color: '#fff', display: 'grid', placeItems: 'center', fontFamily: 'var(--serif)', fontSize: 19 }}>{p.id}</div>
          <div>
            <h3 style={{ fontSize: 21 }}>{dados.nome}</h3>
            <div style={{ fontSize: 12.5, color: '#7C756B' }}>
              {dados.matricula} · {dados.setor} · {dataBR(dados.data)} · {r.versao}
            </div>
          </div>
        </div>
      </Card>

      <Card titulo="Síntese executiva">
        <Tabela colunas={['Dimensão', 'Leitura']} linhas={[
          linha('Configuração predominante', L.configuracao),
          linha('Contribuição principal', L.contribuicaoPrincipal),
          linha('Segunda contribuição', L.segundaContribuicao),
          linha('Recursos menos espontâneos', L.recursosMenosEspontaneos.join(' · ')),
          linha('Como tende a decidir', L.comoDecide),
          linha('Como tende a comunicar', L.comoComunica),
          linha('Como atua sob pressão', L.sobPressao),
          linha('Problemas em que pode contribuir', L.tiposDeProblema.join(' · ')),
          linha('Quando o recurso é especialmente valioso', L.quandoValioso),
          linha('Recursos complementares', L.recursosComplementares)
        ]} />
      </Card>

      <div className="grid g2">
        <Card titulo="Possíveis pontos cegos">
          <ul style={{ paddingLeft: 18, margin: 0 }}>{L.pontosCegos.map((x, i) => <li key={i} style={{ marginBottom: 7 }}>{x}</li>)}</ul>
        </Card>
        <Card titulo="Possibilidades de desenvolvimento">
          <ul style={{ paddingLeft: 18, margin: 0 }}>{L.desenvolvimento.map((x, i) => <li key={i} style={{ marginBottom: 7 }}>{x}</li>)}</ul>
        </Card>
      </div>

      <Card titulo="Como aproveitar melhor esses recursos" sub="Sugestões exibidas apenas quando sustentadas pelos escores. Não prescrevem cargos.">
        <ul style={{ paddingLeft: 18, margin: 0 }}>{L.aproveitar.map((x, i) => <li key={i} style={{ marginBottom: 6 }}>{x}</li>)}</ul>
      </Card>

      <div className="grid g2">
        <Card titulo="Capacidades funcionais" sub="Calculadas a partir das respostas do próprio participante">
          <Barras max={100} altura={28} dados={r.capacidadesOrdenadas.map(c => ({ rotulo: c.nome, valor: c.valor, cor: p.cor, nota: c.intensidade }))} />
        </Card>
        <Card titulo="Proximidades funcionais (Belbin)">
          <Barras max={100} altura={28} dados={r.belbinOrdenado.map(b => ({ rotulo: b.nome, valor: b.valor, cor: p.cor, nota: b.intensidade }))} />
          <Aviso tipo="limite">{AVISO_BELBIN}</Aviso>
        </Card>
      </div>
    </div>
  );
}

/* ══════════════ HISTÓRICO DE APLICAÇÕES E FOLHA DE RESPOSTAS ════════════ */

export interface AplicacaoNaTela {
  avaliacaoId: string;
  numero: number;
  versao: string;
  status: string;
  iniciadaEm: string | null;
  concluidaEm: string | null;
  arquivadaEm: string | null;
  vigente: boolean;
  perfilPrincipal: string | null;
  perfilSecundario: string | null;
  respostasGravadas: number;
}

/**
 * A LINHA DO TEMPO DE UMA PESSOA.
 *
 * Uma reaplicação não apaga a leitura anterior: arquiva. Arquivada quer dizer
 * "fora dos indicadores", não "inexistente" — as 48 respostas continuam
 * gravadas e o resultado continua reproduzível a partir delas. Esta tabela é o
 * lugar onde isso fica visível; sem ela, a aplicação anterior existia no banco
 * e em lugar nenhum da interface.
 *
 * A linha VIGENTE é a que alimenta os painéis: a concluída mais recente e não
 * arquivada. É sempre uma só, por pessoa.
 */
export function HistoricoAplicacoes({ aplicacoes, atual, onAbrir }: {
  aplicacoes: AplicacaoNaTela[];
  /** Qual aplicação está sendo exibida agora, para destacá-la na lista. */
  atual?: string;
  onAbrir?: (avaliacaoId: string) => void;
}) {
  if (aplicacoes.length === 0) return <Vazio titulo="Nenhuma aplicação registrada para esta pessoa." />;

  return (
    <Card titulo="Histórico de aplicações"
      sub="Cada aplicação guarda as próprias respostas, data, horário e resultado. Nenhuma sobrescreve a anterior.">
      <Tabela
        colunas={['Aplicação', 'Situação', 'Iniciada em', 'Concluída em', 'Respostas', 'Perfil', 'Secundário', '']}
        linhas={aplicacoes.map(a => [
          <b key="n">{String(a.numero).padStart(2, '0')}</b>,
          a.vigente
            ? <Pill key="s" cor="var(--ok)">vigente</Pill>
            : a.arquivadaEm
              ? <Pill key="s">arquivada</Pill>
              : <Pill key="s">{a.status === 'CONCLUIDA' ? 'concluída' : 'em andamento'}</Pill>,
          dataHoraBR(a.iniciadaEm),
          dataHoraBR(a.concluidaEm),
          `${a.respostasGravadas} de ${TOTAL_QUESTOES}`,
          a.perfilPrincipal ?? '—',
          a.perfilSecundario ?? '—',
          a.avaliacaoId === atual
            ? <span key="a" style={{ fontSize: 12, color: '#7C756B' }}>exibindo</span>
            : onAbrir && a.status === 'CONCLUIDA'
              ? <button key="a" className="btn btn-sec nao-imprime" onClick={() => onAbrir(a.avaliacaoId)}>Abrir</button>
              : <span key="a" />
        ])} />
      {aplicacoes.some(a => a.arquivadaEm) && (
        <Aviso tipo="info" titulo="Sobre as aplicações arquivadas">
          Uma aplicação arquivada não entra em nenhum indicador, relatório ou planilha — é o que arquivar
          significa. As respostas continuam gravadas e o resultado continua reproduzível a partir delas, que é
          por isso que ela aparece aqui.
        </Aviso>
      )}
    </Card>
  );
}

/**
 * AS 48 SITUAÇÕES COM A ALTERNATIVA ESCOLHIDA.
 *
 * SIGILO — este componente NÃO mostra o polo junguiano, o eixo nem o peso de
 * nenhuma alternativa, e não tem como mostrar: `QUESTOES` (data/questions.ts) é
 * a camada pública, que traz só identificador, contexto, enunciado e texto. A
 * chave de pontuação vive em `questions.server.ts` e é `server-only`; se este
 * arquivo a importasse, o `next build` falharia. As respostas chegam por
 * `carregarRespostas`, cujo `select` pede apenas o código da alternativa.
 *
 * Quem vê: o MASTER. `respostas_acesso` (02_policies.sql) nega ao ADMIN_SETOR
 * de propósito — resposta item a item é dado sensível e só interessa à análise
 * psicométrica. A página não renderiza este bloco para quem não é MASTER, e o
 * RLS negaria a leitura de qualquer forma.
 */
export function FolhaDeRespostas({ respostas }: {
  respostas: { questaoId: string; alternativaId: string; respondidaEm: string | null; posicaoExibida: number | null }[];
}) {
  const porQuestao = new Map(respostas.map(r => [r.questaoId, r]));
  const respondidas = QUESTOES.filter(q => porQuestao.has(q.id)).length;

  return (
    <Card titulo="O teste completo, item a item"
      sub={`${respondidas} de ${TOTAL_QUESTOES} situações respondidas. A alternativa escolhida aparece destacada.`}>
      <Aviso tipo="limite" titulo="Rastreabilidade — acesso restrito ao Administrador Master">
        Respostas item a item são dado sensível. Elas existem para conferência, auditoria e análise
        psicométrica, não para leitura sobre a pessoa: uma escolha isolada não significa nada fora do conjunto
        das 48. A alternativa escolhida está registrada com a chave de pontuação congelada no instante da
        escolha, e é por isso que o resultado é reproduzível anos depois.
      </Aviso>

      {QUESTOES.map((q, i) => {
        const r = porQuestao.get(q.id);
        return (
          <div key={q.id} className="bloco" style={{ marginBottom: 12 }}>
            <div style={{ fontSize: 12, color: '#7C756B', marginBottom: 4 }}>
              {String(i + 1).padStart(2, '0')} · {q.id} · {q.contexto}
              {r?.respondidaEm && <> · respondida em {dataHoraBR(r.respondidaEm)}</>}
              {r?.posicaoExibida != null && <> · exibida na posição {r.posicaoExibida}</>}
            </div>
            <p style={{ margin: '0 0 8px', fontSize: 14.5 }}>{q.enunciado}</p>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
              {q.alternativas.map(a => {
                const escolhida = r?.alternativaId === a.id;
                return (
                  <li key={a.id} style={{
                    padding: '6px 10px', marginBottom: 4, borderRadius: 6, fontSize: 13.5,
                    background: escolhida ? 'rgba(43,74,91,.09)' : 'transparent',
                    borderLeft: `3px solid ${escolhida ? 'var(--azul)' : 'transparent'}`,
                    fontWeight: escolhida ? 600 : 400
                  }}>
                    {escolhida ? '● ' : '○ '}{a.texto}
                  </li>
                );
              })}
            </ul>
            {!r && <p style={{ margin: '6px 0 0', fontSize: 12.5, color: 'var(--limite)' }}>Sem resposta gravada para esta situação.</p>}
          </div>
        );
      })}
    </Card>
  );
}

/* ══════════════ PESSOAS — PAINEL NOMINAL (itens 44, 45) ═════════════════ */

/**
 * Duas formas de abrir o detalhe, e as duas existem por um motivo:
 *
 *  · `avaliacaoId` → link para `/dashboard/pessoas/<id>`. É o caminho da
 *    aplicação. O detalhe tem endereço próprio, então pode ser recarregado,
 *    aberto em outra aba, enviado a quem tem permissão e impresso sozinho.
 *  · `onAbrir` → callback. É o caminho da `dist/demo.html`, que roda tudo num
 *    único documento sem roteador. É também o motivo de este arquivo não
 *    importar `next/link`: a demo é montada por esbuild, sem Next, e um import
 *    de framework aqui quebraria `npm run test:ui`.
 */
export function TelaPessoas({ pessoas, onAbrir }: {
  pessoas: {
    nome: string; matricula: string; setor: string; perfil: string; secundario: string;
    data: string; status: string; demo?: boolean; ehAdministrador?: boolean;
    avaliacaoId?: string; aplicacao?: number;
  }[];
  onAbrir?: (matricula: string) => void;
}) {
  const [f, setF] = useState('');
  const [setor, setSetor] = useState('');
  const setores = Array.from(new Set(pessoas.map(p => p.setor))).sort();
  const filtradas = pessoas.filter(p =>
    (!setor || p.setor === setor) &&
    (!f || [p.nome, p.matricula, p.setor, PERFIL_POR_ID[p.perfil as keyof typeof PERFIL_POR_ID]?.animal].join(' ').toLowerCase().includes(f.toLowerCase())));

  return (
    <div>
      <Aviso tipo="limite" titulo="Acesso restrito">
        Visível apenas a administradores autorizados. Participantes não acessam resultados de colegas, dados
        nominais nem dashboards. A restrição é aplicada no banco por Row Level Security, não apenas na interface.
      </Aviso>
      {pessoas.length === 0 && (
        <Card titulo="Pessoas">
          <Vazio titulo="Nenhuma avaliação concluída até o momento.">
            O painel nominal lista apenas participantes reais que finalizaram as 48 situações.
          </Vazio>
        </Card>
      )}
      {pessoas.length > 0 && <Card titulo={`Pessoas — ${filtradas.length} de ${pessoas.length}`} acao={
        <div style={{ display: 'flex', gap: 8 }}>
          <select value={setor} onChange={e => setSetor(e.target.value)} style={{ width: 150 }}>
            <option value="">Todos os setores</option>
            {setores.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
          <input placeholder="Filtrar por nome, matrícula ou animal" value={f} onChange={e => setF(e.target.value)} style={{ width: 250 }} />
        </div>
      }>
        <Tabela colunas={['Nome', 'Matrícula', 'Setor', 'Tendência predominante', 'Secundária', 'Animal', 'Data', 'Aplicação', '']}
          linhas={filtradas.map(p => {
            const perf = PERFIL_POR_ID[p.perfil as keyof typeof PERFIL_POR_ID];
            const sec = PERFIL_POR_ID[p.secundario as keyof typeof PERFIL_POR_ID];
            return [
              <span key="n">{p.nome}{p.demo && <> <Pill cor="var(--bronze)">demo</Pill></>}
                {/* A conta que administra o instrumento pode responder; a linha
                    dela conta como qualquer outra, mas fica identificada. */}
                {p.ehAdministrador && <> <Pill cor="var(--bronze)">administração</Pill></>}</span>,
              p.matricula, p.setor, perf?.nomeJung ?? '—', sec?.nomeJung ?? '—',
              <Pill key="a" cor={perf?.cor}>{perf?.animal}</Pill>,
              dataBR(p.data),
              /* O ordinal da aplicação VIGENTE. Um número acima de 1 diz, na
                 própria listagem, que existe histórico a consultar. */
              <Pill key="s" cor="var(--bronze)">{String(p.aplicacao ?? 1).padStart(2, '0')}</Pill>,
              onAbrir
                ? <button key="b" className="btn btn-sec" style={{ padding: '5px 11px', fontSize: 12.5 }}
                    onClick={() => onAbrir(p.matricula)}>Leitura executiva</button>
                : p.avaliacaoId
                  ? <a key="b" className="btn btn-sec" style={{ padding: '5px 11px', fontSize: 12.5 }}
                      href={`/dashboard/pessoas/${p.avaliacaoId}`}>Abrir</a>
                  : <span key="b" />
            ];
          })} />
      </Card>}
    </div>
  );
}

/* ══════════════ METODOLOGIA E QUALIDADE DO INSTRUMENTO (itens 5, 66 a 68) ══ */

export interface QualidadeItem {
  questaoId: string; contexto: string; n: number;
  distribuicao: { alternativaId: string; n: number; pct: number }[];
  concentracaoMax: number; discriminativo: boolean;
}

export function TelaMetodologia({ qualidade, empates, distribuicoes, matriz }: {
  qualidade: QualidadeItem[];
  /* A matriz é a chave de pontuação: chega por prop, montada no servidor para o
     Master autenticado, e nunca faz parte do bundle estático. */
  matriz: LinhaMatriz[];
  empates: { n: number; pct: number };
  distribuicoes: { perfis: { nome: string; n: number }[]; funcoes: { nome: string; n: number }[]; atitudes: { nome: string; n: number }[]; capacidades: { nome: string; media: number }[] };
}) {
  const [aba, setAba] = useState<'qualidade' | 'matriz' | 'psicometria'>('qualidade');
  const concentrados = qualidade.filter(q => q.concentracaoMax >= 70);
  const poucoDiscriminativos = qualidade.filter(q => !q.discriminativo);

  return (
    <div>
      <Aviso tipo="limite" titulo="Área exclusiva do Administrador Master">
        Esta é a área de <b>qualidade do instrumento</b>, separada do dashboard executivo. A matriz de pontuação
        nunca é visível ao participante.
      </Aviso>
      <div className="filters">
        {([['qualidade', 'Qualidade dos itens'], ['matriz', 'Matriz de pontuação'], ['psicometria', 'Preparação psicométrica']] as const)
          .map(([k, l]) => <button key={k} aria-pressed={aba === k} onClick={() => setAba(k)}>{l}</button>)}
      </div>

      {aba === 'qualidade' && (
        <>
          <div className="grid g4">
            <Kpi rotulo="Itens analisados" valor={qualidade.length} cor="var(--grafite)" />
            <Kpi rotulo="Concentração excessiva" valor={concentrados.length} cor="var(--amarelo)" ajuda="Itens em que ≥70% escolheram a mesma alternativa" />
            <Kpi rotulo="Pouco discriminativos" valor={poucoDiscriminativos.length} cor="var(--limite)" ajuda="Itens em que alguma alternativa nunca foi escolhida" />
            <Kpi rotulo="Empates de função" valor={`${empates.n} (${empates.pct}%)`} cor="var(--grafite)" ajuda="Avaliações em que a regra de desempate foi acionada" />
          </div>
          <Card titulo="Frequência de resposta por alternativa" sub="Base para revisão de itens após o piloto (Etapa 51)">
            <Tabela colunas={['Item', 'Contexto', 'N', 'Distribuição das alternativas', 'Maior concentração', 'Situação']}
              linhas={qualidade.map(q => [
                <b key="i">{q.questaoId}</b>, q.contexto, q.n,
                <div key="d" style={{ minWidth: 240 }}>
                  {q.distribuicao.map(d => (
                    <div key={d.alternativaId} style={{ display: 'flex', gap: 7, alignItems: 'center', fontSize: 12 }}>
                      <span style={{ width: 46 }}>{d.alternativaId.slice(-1)}</span>
                      <div style={{ flex: 1 }}><Medidor valor={d.pct} cor={d.pct >= 70 ? 'var(--amarelo)' : 'var(--grafite)'} /></div>
                    </div>
                  ))}
                </div>,
                `${q.concentracaoMax}%`,
                q.concentracaoMax >= 70 ? <Pill key="s" cor="var(--amarelo)">concentrado</Pill>
                  : !q.discriminativo ? <Pill key="s" cor="var(--limite)">alternativa sem uso</Pill>
                    : <Pill key="s" cor="var(--bronze)">adequado</Pill>
              ])} />
          </Card>
          <div className="grid g4">
            <Card titulo="Distribuição dos perfis"><Barras dados={distribuicoes.perfis.map(x => ({ rotulo: x.nome, valor: x.n }))} max={1} /></Card>
            <Card titulo="Funções"><Barras dados={distribuicoes.funcoes.map(x => ({ rotulo: x.nome, valor: x.n }))} max={1} /></Card>
            <Card titulo="Atitudes"><Barras dados={distribuicoes.atitudes.map(x => ({ rotulo: x.nome, valor: x.n }))} max={1} /></Card>
            <Card titulo="Capacidades (média)"><Barras dados={distribuicoes.capacidades.map(x => ({ rotulo: x.nome, valor: x.media }))} max={100} /></Card>
          </div>
        </>
      )}

      {aba === 'matriz' && (
        <Card titulo={`Matriz de pontuação — ${VERSAO_MATRIZ}`}
          sub="Uma linha por alternativa. As capacidades e as proximidades Belbin derivam do conteúdo comportamental da alternativa, não do polo junguiano.">
          <Tabela colunas={['Questão', 'Alternativa', 'Texto', 'Jung', 'Eixo', 'Capacidades', 'Proximidades Belbin']}
            linhas={matriz.map(l => [
              <b key="q">{l.questaoId}</b>, l.alternativaId,
              <span key="t" style={{ fontSize: 12.5 }}>{l.texto}</span>,
              <Pill key="j" cor={CORES_FUNCAO[l.jung] ?? CORES_ATITUDE[l.jung]}>{l.jung}</Pill>,
              <span key="e" style={{ fontSize: 12 }}>{NOME_EIXO[l.eixo]}</span>,
              <span key="c" style={{ fontSize: 12 }}>{Object.entries(l.capacidades).map(([k, v]) => `${CAPACIDADES.find(c => c.id === k)?.nome} +${v}`).join(', ')}</span>,
              <span key="b" style={{ fontSize: 12 }}>{Object.entries(l.belbin).map(([k, v]) => `${PAPEIS_BELBIN.find(p => p.id === k)?.nome} +${v}`).join(', ')}</span>
            ])} />
        </Card>
      )}

      {aba === 'psicometria' && (
        <>
          <Card titulo="Estado do instrumento">
            <Tabela colunas={['Propriedade', 'Valor']} linhas={[
              ['Versão do questionário', VERSAO_INSTRUMENTO],
              ['Versão da matriz de pontuação', VERSAO_MATRIZ],
              ['Itens', `${TOTAL_QUESTOES} (24 de função + 24 de atitude)`],
              ['Alternativas', `${TOTAL_ALTERNATIVAS}`],
              ['Denominador da atitude', '27 (ímpar — empate E/I impossível)'],
              ['Denominador das funções', '27'],
              ['Auditoria estrutural dos itens', <Pill key="a" cor="var(--bronze)">0 erros · 0 alertas</Pill>],
              ['Auditoria da matriz de pontuação', <Pill key="b" cor="var(--bronze)">0 erros · 0 alertas</Pill>],
              ['Estado psicométrico', <Pill key="c" cor="var(--limite)">NÃO validado — versão piloto</Pill>]
            ]} />
          </Card>
          <Card titulo="Preparação para análise psicométrica (item 68)">
            <p>As respostas brutas são preservadas item a item, com a chave de pontuação congelada, o que permite exportar os dados necessários para:</p>
            <ul style={{ paddingLeft: 18 }}>
              <li>Alfa de Cronbach e Ômega de McDonald (consistência interna por dimensão)</li>
              <li>Correlação item-total corrigida</li>
              <li>Análise fatorial exploratória e confirmatória</li>
              <li>Teste-reteste, quando houver reaplicação</li>
            </ul>
            <Aviso tipo="limite">
              Enquanto essas etapas não forem executadas, o instrumento <b>não deve ser descrito como validado</b>.
              Use a exportação de respostas brutas na área de Gestão de Dados para conduzir as análises.
            </Aviso>
          </Card>
          <Card titulo="Oportunidade máxima por dimensão" sub="Denominadores usados na normalização dos escores relativos internos">
            <div className="grid g2">
              <Barras max={100} dados={CAPACIDADES.map(c => ({ rotulo: c.nome, valor: MAXIMO_CAPACIDADE[c.id] }))} />
              <Barras max={100} dados={PAPEIS_BELBIN.map(p => ({ rotulo: p.nome, valor: MAXIMO_BELBIN[p.id] }))} />
            </div>
          </Card>
        </>
      )}
    </div>
  );
}

/* ══════════════ GESTÃO DE DADOS ═════════════════════════════════════════
 * Itens 6 a 12 · 25 · 27 · 28 · 31 · 32 · 33 · 34
 * ------------------------------------------------------------------------
 * Quatro áreas: Exportação, Preparar aplicação, Zona de segurança e
 * Auditoria. Tudo aqui é exclusivo do Administrador Master.
 * ======================================================================== */

export interface AlvoReset {
  escopo: 'participante' | 'setor' | 'periodo' | 'demo' | 'tudo';
  participantes: number; avaliacoes: number; respostas: number; descricao: string;
}

export interface ItemChecklistUI { chave: string; item: string; ok: boolean; detalhe: string }

/** Estado do bloco de produção — limpeza DEMO, preparação e checklist. */
export interface PainelProducao {
  ambiente: string;
  emProducao: boolean;
  /** Quantos registros artificiais existem hoje. `null` = ainda carregando. */
  contagem: { participantes: number; avaliacoes: number; testes: number } | null;
  previaDemo: { participantes: number; avaliacoes: number; respostas: number; resultados: number; reaisPreservados: number } | null;
  onPreviaDemo: () => void;
  onCancelarPrevia: () => void;
  onLimparDemo: (confirmacao: string) => void;
  resultadoDemo: { participantes: number; avaliacoes: number; respostas: number; restantes: number } | null;
  onPreparar: () => void;
  checklist: ItemChecklistUI[] | null;
  onLimparTeste: () => void;
  onLiberarReaplicacao: (matricula: string) => void;
  /** Recálculo dos derivados com o algoritmo vigente — prévia e aplicação. */
  onPreviaRecalculo: () => void;
  onRecalcular: (confirmacao: string) => void;
  previaRecalculo: {
    total: number; avaliacoesAfetadas: number; porCampo: Record<string, number>; algoritmo: string;
  } | null;
  onCancelarRecalculo: () => void;
  resultadoRecalculo: { total: number; gravados: number; completo: boolean; avaliacoesAfetadas: number } | null;
  /** Operação em curso: 'previa' | 'limpeza' | 'preparo' | 'teste' | 'reaplicacao' */
  ocupado: string | null;
  mensagem: string | null;
  erro: string | null;
}

export const CONFIRMACAO_DEMO = 'LIMPAR DADOS DEMO';
export const CONFIRMACAO_RECALCULO = 'RECALCULAR RESULTADOS';

export function TelaGestaoDados({
  setores, exportar, exportando, previa, onPrevia, onConfirmar, resultadoReset, logs,
  producao, embutido = false, erroExport = null, arquivoPronto = null, abaInicial
}: {
  setores: string[];
  exportar: (tipo: string, setor?: string) => void;
  exportando: string | null;
  previa: AlvoReset | null;
  onPrevia: (escopo: AlvoReset['escopo'], param?: string) => void;
  onConfirmar: (escopo: AlvoReset['escopo'], param?: string) => void;
  resultadoReset: string | null;
  logs: { data: string; usuario: string; acao: string; detalhe: string }[];
  producao: PainelProducao;
  /** true quando a página roda dentro de um visualizador embutido (iframe). */
  embutido?: boolean;
  erroExport?: string | null;
  /** Arquivo gerado e disponível por link manual — salva o caso do iframe. */
  arquivoPronto?: { nome: string; url: string; kb: number; embutido: boolean } | null;
  /** Item 68 — o menu abre direto na aba pedida (?aba=exportacao, auditoria, configuracoes). */
  abaInicial?: string;
}) {
  type Aba = 'exportacao' | 'preparar' | 'seguranca' | 'configuracoes' | 'auditoria';
  const ABAS: Aba[] = ['exportacao', 'preparar', 'seguranca', 'configuracoes', 'auditoria'];
  const [aba, setAba] = useState<Aba>(
    ABAS.includes(abaInicial as Aba) ? (abaInicial as Aba) : 'exportacao');
  const [setorSel, setSetorSel] = useState(setores[0] ?? '');
  const [confirmacao, setConfirmacao] = useState('');
  const [confirmaDemo, setConfirmaDemo] = useState('');
  const [matricula, setMatricula] = useState('');
  const [matriculaRe, setMatriculaRe] = useState('');
  const [confirmaRecalculo, setConfirmaRecalculo] = useState('');
  const [periodo, setPeriodo] = useState('');

  const temDemo = (producao.contagem?.participantes ?? 0) > 0 || (producao.contagem?.avaliacoes ?? 0) > 0;
  const temTeste = (producao.contagem?.testes ?? 0) > 0;

  const EXPORTS: [string, string, string][] = [
    ['completo', 'Excel completo', '13 abas: participantes, respostas brutas, resultados Jung, funcionais, Belbin, perfis, equipes, distribuições, animais, cobertura, indicadores, dicionário e informações da exportação.'],
    ['anonimizado', 'Excel anonimizado', 'Mesmos dados sem nome e sem matrícula. Cada pessoa recebe um identificador P00001, P00002, P00003…'],
    ['respostas', 'Respostas brutas', 'Uma linha por resposta, com a chave de pontuação congelada. Formato para análise psicométrica.'],
    ['individual', 'Resultado individual', 'Uma linha por participante, com todos os escores.'],
    ['equipes', 'Resumo por equipe', 'Indicadores agregados de todas as equipes.'],
    ['metodologia', 'Dados metodológicos', 'Matriz de pontuação, denominadores e frequência de resposta por alternativa.']
  ];

  const CaixaArquivo = () => (
    <>
      {erroExport && <Aviso tipo="limite" titulo="Não foi possível gerar a planilha">{erroExport}</Aviso>}
      {arquivoPronto && (
        <Card titulo="Arquivo gerado" sub="Disponível para download manual enquanto esta aba estiver aberta.">
          <p style={{ fontSize: 13.5, margin: '0 0 10px' }}>
            <b>{arquivoPronto.nome}</b> — {arquivoPronto.kb} KB.
            {arquivoPronto.embutido
              ? ' O arquivo foi gerado, mas o visualizador embutido bloqueia o salvamento. Tente o link abaixo; se ele não responder, abra a aplicação em uma aba própria do navegador e repita a exportação.'
              : ' Se o download automático não tiver iniciado, use o link abaixo.'}
          </p>
          <a className="btn" href={arquivoPronto.url} download={arquivoPronto.nome} target="_blank" rel="noopener">
            Baixar {arquivoPronto.nome}
          </a>
        </Card>
      )}
    </>
  );

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 8, marginBottom: 10 }}>
        <div className="filters" style={{ margin: 0 }}>
          {/* Item 69 — Exportação e Zona de segurança visualmente separadas. */}
          {([['exportacao', 'Exportação'], ['preparar', 'Preparar aplicação'],
             ['seguranca', 'Zona de segurança'], ['configuracoes', 'Configurações'],
             ['auditoria', 'Auditoria']] as const)
            .map(([k, l]) => (
              <button key={k} aria-pressed={aba === k} onClick={() => setAba(k)}
                className={k === 'seguranca' ? 'aba-perigo' : undefined}>{l}</button>
            ))}
        </div>
        {/* Item 31 — indicador discreto, só para o Master. */}
        <Pill cor={producao.emProducao ? 'var(--bronze)' : 'var(--amarelo)'}>{producao.ambiente}</Pill>
      </div>

      {producao.erro && <Aviso tipo="limite" titulo="Operação não concluída">{producao.erro}</Aviso>}
      {producao.mensagem && <Aviso tipo="info" titulo="Operação concluída">{producao.mensagem}</Aviso>}

      {/* ─────────────────────────── EXPORTAÇÃO ─────────────────────────── */}
      {aba === 'exportacao' && (
        <>
          {embutido && (
            <Aviso tipo="alerta" titulo="Esta página está aberta dentro de um visualizador">
              Navegadores bloqueiam downloads quando a página roda embutida em outro documento (iframe). A
              planilha continua sendo gerada corretamente, mas o arquivo não chega ao seu computador — e o
              bloqueio é silencioso, sem mensagem de erro. Nenhum código consegue contorná-lo.
              <b> Abra a aplicação em uma aba própria do navegador</b> e a exportação funciona normalmente.
            </Aviso>
          )}
          <CaixaArquivo />

          <Aviso tipo="info" titulo="O que estas planilhas contêm">
            Por padrão, <b>somente dados reais</b>: registros de demonstração e de validação controlada são
            excluídos na própria definição da view do banco, não por um filtro de tela. O conteúdo do Excel
            coincide exatamente com o que os dashboards mostram.
          </Aviso>

          <Card titulo="Exportar Excel (.xlsx)" sub="Todos os arquivos são gerados a partir da mesma fonte de dados dos dashboards.">
            <div className="grid g2">
              {EXPORTS.map(([tipo, nome, desc]) => (
                <div className="bloco" key={tipo}>
                  <h4>{nome}</h4>
                  <p style={{ fontSize: 13.5 }}>{desc}</p>
                  <button className="btn" disabled={!!exportando} onClick={() => exportar(tipo)}>
                    {exportando === tipo ? 'Gerando…' : 'Baixar'}
                  </button>
                </div>
              ))}
            </div>
          </Card>

          <Card titulo="Equipe selecionada">
            <div style={{ display: 'flex', gap: 10, alignItems: 'center', flexWrap: 'wrap' }}>
              <select value={setorSel} onChange={e => setSetorSel(e.target.value)} style={{ width: 220 }}>
                {setores.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
              <button className="btn" disabled={!!exportando} onClick={() => exportar('setor', setorSel)}>
                {exportando === 'setor' ? 'Gerando…' : `Exportar ${setorSel}`}
              </button>
            </div>
          </Card>

          {/* Item 25 — a opção só existe enquanto houver dado DEMO no banco. */}
          {temDemo && (
            <Card titulo="Exportar dados DEMO"
              sub="Disponível apenas enquanto existirem registros de demonstração. Depois da limpeza, esta opção desaparece.">
              <p style={{ fontSize: 13.5 }}>
                Gera uma planilha <b>separada</b>, contendo somente os {producao.contagem?.participantes} registros de
                demonstração. Serve como backup antes da limpeza. Estes dados nunca entram nas planilhas acima.
              </p>
              <button className="btn btn-sec" disabled={!!exportando} onClick={() => exportar('demo')}>
                {exportando === 'demo' ? 'Gerando…' : 'Baixar planilha dos dados DEMO'}
              </button>
            </Card>
          )}
        </>
      )}

      {/* ──────────────────── PREPARAR APLICAÇÃO (itens 6 a 12, 32 a 34) ── */}
      {aba === 'preparar' && (
        <>
          <CaixaArquivo />

          {/* Estado atual do banco */}
          <div className="grid g4">
            <Kpi rotulo="Participantes DEMO" valor={producao.contagem?.participantes ?? '—'}
              cor={temDemo ? 'var(--limite)' : 'var(--bronze)'} ajuda="Registros marcados com is_demo = true" />
            <Kpi rotulo="Avaliações DEMO" valor={producao.contagem?.avaliacoes ?? '—'}
              cor={temDemo ? 'var(--limite)' : 'var(--bronze)'} />
            <Kpi rotulo="Registros de validação" valor={producao.contagem?.testes ?? '—'}
              cor={temTeste ? 'var(--amarelo)' : 'var(--bronze)'} ajuda="is_test = true — não é DEMO e não entra em nenhum indicador" />
            <Kpi rotulo="Ambiente" valor={producao.emProducao ? 'Produção' : 'Desenvolvimento'}
              cor={producao.emProducao ? 'var(--bronze)' : 'var(--amarelo)'}
              ajuda={producao.emProducao ? 'Geração de dados fictícios bloqueada' : 'Seed permitido apenas com variável explícita'} />
          </div>

          {/* Item 6 — o botão obrigatório */}
          <div className="zona">
            <h4>Limpar dados da demonstração</h4>
            <p style={{ fontSize: 13.5 }}>
              Remove <b>somente</b> os registros marcados como demonstração (<code>is_demo = true</code>).
              Nunca remove participantes ou avaliações reais, e nunca toca na estrutura do instrumento.
            </p>

            {!temDemo && producao.contagem && (
              <Aviso tipo="info" titulo="Não há dados de demonstração no banco">
                O sistema já opera somente com dados reais. Nada a limpar.
              </Aviso>
            )}

            {temDemo && !producao.previaDemo && (
              <button className="btn" disabled={producao.ocupado === 'previa'} onClick={producao.onPreviaDemo}>
                {producao.ocupado === 'previa' ? 'Consultando…' : 'LIMPAR DADOS DA DEMONSTRAÇÃO'}
              </button>
            )}

            {/* Item 7 — a janela de confirmação, com as três contagens */}
            {producao.previaDemo && (
              <div className="bloco" style={{ marginTop: 14, borderLeftColor: 'var(--limite)', background: '#fff', padding: 16, borderRadius: 10 }}>
                <h4>O que será removido</h4>
                <ul style={{ fontSize: 14.5, marginTop: 6 }}>
                  <li>Existem <b>{producao.previaDemo.participantes}</b> participantes de demonstração.</li>
                  <li>Existem <b>{producao.previaDemo.avaliacoes}</b> avaliações de demonstração.</li>
                  <li>Existem <b>{producao.previaDemo.respostas}</b> respostas vinculadas a esses registros.</li>
                </ul>
                <Aviso tipo="info" titulo="ESTA AÇÃO NÃO AFETARÁ PARTICIPANTES OU AVALIAÇÕES REAIS">
                  {producao.previaDemo.reaisPreservados} participante(s) real(is) permanecem intactos. Perguntas,
                  alternativas, pesos, algoritmo, perfis, animais, luz e sombra, matriz funcional, matriz Belbin,
                  setores, administradores, configurações, versões e os parâmetros de IDF e ICF <b>não são tocados</b>.
                </Aviso>

                {/* Item 8 — backup opcional antes de limpar */}
                <p style={{ fontSize: 13.5, marginTop: 4 }}><b>Antes de executar</b>, você pode guardar os registros que serão eliminados:</p>
                <button className="btn btn-sec" disabled={!!exportando} onClick={() => exportar('demo')}>
                  {exportando === 'demo' ? 'Gerando…' : 'EXPORTAR BACKUP DOS DADOS DEMO'}
                </button>

                {/* Item 9 — confirmação de segurança */}
                <p style={{ fontSize: 13.5, marginTop: 16 }}>
                  Para habilitar a limpeza, digite exatamente <b>{CONFIRMACAO_DEMO}</b>:
                </p>
                <input value={confirmaDemo} onChange={e => setConfirmaDemo(e.target.value)} placeholder={CONFIRMACAO_DEMO} />
                <div style={{ display: 'flex', gap: 9, marginTop: 10, flexWrap: 'wrap' }}>
                  <button className="perigo"
                    disabled={confirmaDemo !== CONFIRMACAO_DEMO || producao.ocupado === 'limpeza'}
                    onClick={() => { producao.onLimparDemo(confirmaDemo); setConfirmaDemo(''); }}>
                    {producao.ocupado === 'limpeza' ? 'Limpando…' : 'CONFIRMAR LIMPEZA'}
                  </button>
                  <button className="btn btn-sec" onClick={() => { setConfirmaDemo(''); producao.onCancelarPrevia(); }}>Cancelar</button>
                </div>
              </div>
            )}

            {/* Item 12 — o que aparece depois */}
            {producao.resultadoDemo && (
              <Aviso tipo="info" titulo="Dados da demonstração removidos com sucesso.">
                <ul style={{ marginTop: 4 }}>
                  <li>{producao.resultadoDemo.participantes} participante(s), {producao.resultadoDemo.avaliacoes} avaliação(ões) e {producao.resultadoDemo.respostas} resposta(s) removidos.</li>
                  <li><b>{producao.resultadoDemo.restantes} registros DEMO permanecem no sistema.</b></li>
                  <li>Os dados reais foram preservados.</li>
                </ul>
                <b>Sistema pronto para aplicação.</b>
              </Aviso>
            )}
          </div>

          {/* Item 32 — rotina de preparação, e item 33 — o checklist */}
          <Card titulo="Preparar sistema para aplicação real"
            sub="Verifica o banco, a estrutura do instrumento, a segurança e exercita os fluxos críticos de ponta a ponta.">
            <p style={{ fontSize: 13.5 }}>
              A rotina confere conexão, tabelas, as 48 perguntas com suas alternativas, o algoritmo, os setores,
              o RLS, o administrador autenticado e a auditoria; conta os registros artificiais; e executa sondas
              reais de salvamento, retomada, finalização, resultado individual, comparação com a equipe,
              dashboard e Excel. Nada é gravado em definitivo: a sonda cria um registro <code>is_test</code> e o
              remove ao final.
            </p>
            <button className="btn" disabled={producao.ocupado === 'preparo'} onClick={producao.onPreparar}>
              {producao.ocupado === 'preparo' ? 'Verificando…' : 'PREPARAR SISTEMA PARA APLICAÇÃO REAL'}
            </button>

            {producao.checklist && (
              <div style={{ marginTop: 16 }}>
                <h4 style={{ fontSize: 14, marginBottom: 6 }}>Checklist de pré-aplicação</h4>
                <Checklist itens={producao.checklist.map(c => ({ item: c.item, ok: c.ok, detalhe: c.detalhe }))} />
                {producao.checklist.every(c => c.ok)
                  ? <Aviso tipo="info" titulo="SISTEMA PREPARADO PARA APLICAÇÃO.">
                      Todos os itens do checklist foram verificados contra o banco e contra os fluxos reais.
                      O instrumento permanece em <b>fase piloto</b>: aplicação em produção não significa validação psicométrica.
                    </Aviso>
                  : <Aviso tipo="alerta" titulo="Ainda há itens pendentes">
                      Resolva os itens marcados com ✗ e execute a verificação novamente. Enquanto houver pendência,
                      o sistema não deve ser declarado pronto para aplicação.
                    </Aviso>}
              </div>
            )}
          </Card>

          {/* Item 34 — o registro único de validação controlada */}
          {temTeste && (
            <Card titulo="Registro de validação controlada"
              sub="Criado pela rotina de preparação para exercitar o fluxo real. Não é DEMO e não entra em nenhum indicador.">
              <p style={{ fontSize: 13.5 }}>
                Existe(m) <b>{producao.contagem?.testes}</b> registro(s) marcado(s) com <code>is_test = true</code>.
                Depois de conferir o fluxo, remova-o para deixar o banco com <b>zero avaliações artificiais</b>.
              </p>
              <button className="btn btn-sec" disabled={producao.ocupado === 'teste'} onClick={producao.onLimparTeste}>
                {producao.ocupado === 'teste' ? 'Removendo…' : 'Remover registro de validação'}
              </button>
            </Card>
          )}

          {/* Recálculo dos derivados com o algoritmo vigente.
              Existe porque as telas individuais recalculam sempre a partir das
              respostas, mas os PAINÉIS leem a tabela `resultados`, gravada uma
              vez na conclusão. Quando o algoritmo muda, os dois discordam sem
              que nada esteja quebrado. */}
          <Card titulo="Recalcular resultados com o algoritmo vigente"
            sub="Reprocessa os resultados gravados a partir das respostas brutas, que não são tocadas.">
            <p style={{ fontSize: 13.5 }}>
              As <b>respostas continuam intocadas</b> — são o dado bruto e são imutáveis. O que muda é a
              tabela de resultados derivados, regravada a partir delas. Use quando a versão do algoritmo
              mudar: as telas individuais já recalculam sozinhas, mas os painéis leem o valor gravado.
            </p>
            {!producao.previaRecalculo && !producao.resultadoRecalculo && (
              <button className="btn btn-sec" disabled={producao.ocupado === 'recalculo'}
                onClick={producao.onPreviaRecalculo}>
                {producao.ocupado === 'recalculo' ? 'Analisando…' : 'Analisar o que mudaria'}
              </button>
            )}

            {producao.previaRecalculo && !producao.resultadoRecalculo && (
              <>
                <Aviso tipo={producao.previaRecalculo.avaliacoesAfetadas > 0 ? 'alerta' : 'info'}
                  titulo={producao.previaRecalculo.avaliacoesAfetadas > 0
                    ? `${producao.previaRecalculo.avaliacoesAfetadas} avaliação(ões) mudariam de resultado`
                    : 'Nenhum resultado mudaria'}>
                  {producao.previaRecalculo.total} avaliação(ões) seriam reprocessadas com o algoritmo{' '}
                  <b>{producao.previaRecalculo.algoritmo}</b>.
                  {Object.keys(producao.previaRecalculo.porCampo).length > 0 && (
                    <Tabela colunas={['Campo', 'Linhas que mudam']}
                      linhas={Object.entries(producao.previaRecalculo.porCampo)
                        .map(([campo, n]) => [campo, String(n)])} />
                  )}
                </Aviso>
                <p style={{ fontSize: 13.5, marginTop: 16 }}>
                  Para habilitar o recálculo, digite exatamente <b>{CONFIRMACAO_RECALCULO}</b>:
                </p>
                <input value={confirmaRecalculo} onChange={e => setConfirmaRecalculo(e.target.value)}
                  placeholder={CONFIRMACAO_RECALCULO} />
                <div style={{ display: 'flex', gap: 9, marginTop: 10, flexWrap: 'wrap' }}>
                  <button className="btn"
                    disabled={confirmaRecalculo !== CONFIRMACAO_RECALCULO || producao.ocupado === 'recalculo'}
                    onClick={() => { producao.onRecalcular(confirmaRecalculo); setConfirmaRecalculo(''); }}>
                    {producao.ocupado === 'recalculo' ? 'Recalculando…' : 'CONFIRMAR RECÁLCULO'}
                  </button>
                  <button className="btn btn-sec"
                    onClick={() => { setConfirmaRecalculo(''); producao.onCancelarRecalculo(); }}>Cancelar</button>
                </div>
              </>
            )}

            {producao.resultadoRecalculo && (
              <Aviso tipo={producao.resultadoRecalculo.completo ? 'info' : 'alerta'}
                titulo={producao.resultadoRecalculo.completo ? 'Recálculo concluído' : 'Recálculo incompleto'}>
                {producao.resultadoRecalculo.gravados} de {producao.resultadoRecalculo.total} resultado(s)
                regravado(s); {producao.resultadoRecalculo.avaliacoesAfetadas} mudaram de valor.
                {!producao.resultadoRecalculo.completo && <> Algumas linhas não puderam ser gravadas — verifique a auditoria antes de considerar a base consistente.</>}
              </Aviso>
            )}
          </Card>

          {/* Item 17 — liberação de reaplicação */}
          <Card titulo="Liberar reaplicação de um participante"
            sub="Único caminho autorizado para que uma matrícula que já concluiu responda novamente.">
            <p style={{ fontSize: 13.5 }}>
              A avaliação anterior é <b>arquivada</b>, não apagada: as respostas continuam no banco para fins de
              histórico e análise psicométrica, mas deixam de compor os indicadores atuais. Ela continua
              visível na linha do tempo da pessoa, em <b>Pessoas e resultados</b>, e a nova aplicação recebe o
              número seguinte — 02, 03, e assim por diante.
            </p>
            <div style={{ display: 'flex', gap: 9, alignItems: 'center', flexWrap: 'wrap' }}>
              <input placeholder="Matrícula" value={matriculaRe} onChange={e => setMatriculaRe(e.target.value)} style={{ width: 220 }} />
              <button className="btn btn-sec" disabled={!matriculaRe || producao.ocupado === 'reaplicacao'}
                onClick={() => { producao.onLiberarReaplicacao(matriculaRe.trim()); setMatriculaRe(''); }}>
                {producao.ocupado === 'reaplicacao' ? 'Liberando…' : 'Liberar reaplicação'}
              </button>
            </div>
          </Card>
        </>
      )}

      {/* ────────────────────── ZONA DE SEGURANÇA ───────────────────────── */}
      {aba === 'seguranca' && (
        <>
          <Aviso tipo="alerta" titulo="Antes de qualquer reset">
            Zerar arquiva <b>avaliações, respostas e resultados</b>. Nunca remove perguntas, alternativas, matrizes,
            animais, perfis, parâmetros funcionais, configuração Belbin, setores, administradores nem versões.
            Exporte um backup antes de continuar.
          </Aviso>
          <Card titulo="Exportar backup antes de continuar">
            <button className="btn" disabled={!!exportando} onClick={() => exportar('completo')}>
              {exportando === 'completo' ? 'Gerando…' : 'Baixar backup Excel completo'}
            </button>
          </Card>
          <CaixaArquivo />

          <div className="zona">
            <h4>Zona de segurança</h4>
            <p style={{ fontSize: 13.5 }}>Disponível apenas ao Administrador Master. Toda operação é registrada na auditoria.</p>

            <div className="grid g2" style={{ marginTop: 12 }}>
              <div className="bloco"><h4>Zerar um participante</h4>
                <input placeholder="Matrícula" value={matricula} onChange={e => setMatricula(e.target.value)} />
                <button className="btn btn-sec" style={{ marginTop: 8 }} disabled={!matricula} onClick={() => onPrevia('participante', matricula)}>Ver o que será afetado</button>
              </div>
              <div className="bloco"><h4>Zerar um setor</h4>
                <select value={setorSel} onChange={e => setSetorSel(e.target.value)}>{setores.map(s => <option key={s}>{s}</option>)}</select>
                <button className="btn btn-sec" style={{ marginTop: 8 }} onClick={() => onPrevia('setor', setorSel)}>Ver o que será afetado</button>
              </div>
              <div className="bloco"><h4>Zerar um período</h4>
                <input type="date" value={periodo} onChange={e => setPeriodo(e.target.value)} />
                <p style={{ fontSize: 12, color: '#7C756B', margin: '5px 0 0' }}>Arquiva avaliações concluídas até a data informada.</p>
                <button className="btn btn-sec" style={{ marginTop: 8 }} disabled={!periodo} onClick={() => onPrevia('periodo', periodo)}>Ver o que será afetado</button>
              </div>
              <div className="bloco"><h4>Dados de demonstração</h4>
                <p style={{ fontSize: 13 }}>
                  A exclusão definitiva dos registros <code>is_demo</code>, com prévia, backup e confirmação, fica
                  na aba <b>Preparar aplicação</b>.
                </p>
                <button className="btn btn-sec" onClick={() => setAba('preparar')}>Ir para Preparar aplicação</button>
              </div>
            </div>

            <div className="bloco" style={{ marginTop: 16, borderLeftColor: 'var(--limite)' }}>
              <h4>Zerar todas as avaliações</h4>
              <p style={{ fontSize: 13.5 }}>Operação sobre avaliações, respostas e resultados de toda a organização.</p>
              <button className="btn btn-sec" onClick={() => onPrevia('tudo')}>Ver o que será afetado</button>
            </div>

            {previa && (
              <div className="bloco" style={{ marginTop: 16, borderLeftColor: 'var(--limite)', background: '#fff', padding: 16, borderRadius: 10 }}>
                <h4>Confirmação necessária</h4>
                <p style={{ fontSize: 13.5 }}>{previa.descricao}</p>
                <Tabela colunas={['Participantes afetados', 'Avaliações', 'Respostas brutas']}
                  linhas={[[previa.participantes, previa.avaliacoes, previa.respostas]]} />
                {previa.escopo === 'tudo' ? (
                  <>
                    <p style={{ fontSize: 13.5, marginTop: 12 }}>Para confirmar, digite <b>ZERAR RESULTADOS</b>:</p>
                    <input value={confirmacao} onChange={e => setConfirmacao(e.target.value)} placeholder="ZERAR RESULTADOS" />
                    <button className="perigo" style={{ marginTop: 10 }} disabled={confirmacao !== 'ZERAR RESULTADOS'}
                      onClick={() => { onConfirmar('tudo'); setConfirmacao(''); }}>Confirmar reset geral</button>
                  </>
                ) : (
                  <button className="perigo" style={{ marginTop: 10 }}
                    onClick={() => onConfirmar(previa.escopo, previa.escopo === 'participante' ? matricula : previa.escopo === 'setor' ? setorSel : periodo)}>
                    Confirmar
                  </button>
                )}
              </div>
            )}
            {resultadoReset && <Aviso tipo="info" titulo="Operação concluída">{resultadoReset}</Aviso>}
          </div>
        </>
      )}

      {/* ───────────────────────── CONFIGURAÇÕES ────────────────────────── */}
      {/* Item 68 — configuração do instrumento em LEITURA. Deliberadamente sem
          edição: alterar peso, chave ou fórmula mudaria resultados já colhidos,
          e nenhuma alteração metodológica foi autorizada nesta etapa. */}
      {aba === 'configuracoes' && (
        <>
          <Aviso tipo="alerta" titulo="Esta tela é de leitura">
            A configuração metodológica do instrumento é exibida aqui para conferência e auditoria, e
            <b> não é editável pela interface</b>. Alterar peso, chave de pontuação, denominador ou fórmula
            mudaria o resultado de avaliações já respondidas — uma mudança dessa natureza exige nova versão
            do instrumento e decisão explícita da área responsável.
          </Aviso>

          <Card titulo="Versões em vigor">
            <Tabela colunas={['Parâmetro', 'Valor']} linhas={[
              ['Versão do instrumento', <b key="a">{VERSAO_INSTRUMENTO}</b>],
              ['Versão da matriz de pontuação', <b key="b">{VERSAO_MATRIZ}</b>],
              ['Total de itens', `${TOTAL_QUESTOES} situações`],
              ['Total de alternativas', `${TOTAL_ALTERNATIVAS} (quatro por item)`],
              ['Itens com peso 2 (âncoras)', `${TOTAL_ANCORAS}`],
              ['Máximo por capacidade', `${MAXIMO_CAPACIDADE}`],
              ['Máximo por papel de Belbin', `${MAXIMO_BELBIN}`]
            ]} />
          </Card>

          <Card titulo="Parâmetros das análises coletivas"
            sub="Preservados desta versão. Os valores de faixa são parâmetros internos exploratórios, não normas populacionais.">
            <Tabela colunas={['Parâmetro', 'Valor', 'Onde é usado']} linhas={[
              ['Composição do IDF', '25% entropia dos perfis + 25% entropia das funções + 50% dispersão dos escores',
                'Índice de Diversidade Funcional'],
              ['Composição do ICF', '70% proporção de portadores + 30% média da capacidade',
                'Índice de Cobertura Funcional'],
              ['Limiar de portador', `${LIMIAR_PORTADOR}`, 'Contagem de portadores por capacidade e por papel'],
              ['Amostra mínima para distribuição detalhada', `${MIN_PARTICIPANTES_INTERPRETACAO} respondentes`,
                'Proteção de identificação em grupos pequenos'],
              ['Confirmação do reset geral', 'ZERAR RESULTADOS', 'Zona de segurança'],
              ['Confirmação da limpeza de demonstração', CONFIRMACAO_DEMO, 'Preparar aplicação'],
              ['Confirmação do recálculo de resultados', CONFIRMACAO_RECALCULO, 'Preparar aplicação']
            ]} />
          </Card>

          <Card titulo="Equipes cadastradas" sub="A criação e a desativação de setores são feitas no banco pela área responsável.">
            <div style={{ display: 'flex', gap: 7, flexWrap: 'wrap' }}>
              {setores.map(x => <Pill key={x}>{x}</Pill>)}
            </div>
            <p style={{ fontSize: 13, color: 'var(--ink3)', marginTop: 12, marginBottom: 0 }}>
              {setores.length} equipe(s) ativa(s).
            </p>
          </Card>
        </>
      )}

      {/* ─────────────────────────── AUDITORIA ──────────────────────────── */}
      {aba === 'auditoria' && (
        <Card titulo="Registro de auditoria"
          sub="Login, conclusão de avaliação, exportação, reset, limpeza DEMO e alteração de configurações">
          {logs.length ? (
            <Tabela colunas={['Data e hora', 'Usuário', 'Ação', 'Detalhe']}
              linhas={logs.map(l => [dataHoraBR(l.data), l.usuario, <b key="a">{l.acao}</b>, l.detalhe])} />
          ) : <Vazio titulo="Nenhuma operação registrada ainda.">
                Os eventos aparecem aqui à medida que participantes acessam, concluem avaliações e
                administradores exportam ou administram dados.
              </Vazio>}
        </Card>
      )}
    </div>
  );
}
