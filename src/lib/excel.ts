/**
 * ETAPA 15 — EXPORTAÇÃO EXCEL (.xlsx) — itens 58 a 60 e 74
 * ---------------------------------------------------------------------------
 * Roda tanto no servidor (Next.js) quanto no navegador (demo), a partir da
 * MESMA fonte de dados usada pelos dashboards. Isso é o que garante o item 74:
 * se o dashboard mostra "MEC — 47 participantes", o Excel mostra 47.
 *
 * Requisitos aplicados: fonte profissional (Arial), aba de dicionário de dados
 * e aba de informações da exportação documentando premissas e denominadores.
 * Não há fórmulas — é uma exportação de dados, e todos os valores são
 * calculados pelo algoritmo determinístico antes de chegarem aqui.
 */
import ExcelJS from 'exceljs';
import { QUESTOES, NOME_EIXO, VERSAO_INSTRUMENTO, MAXIMO_POR_EIXO, PESO_TOTAL_ATITUDE, PESO_TOTAL_FUNCAO } from '../data/questions';
import { PERFIS, NOME_FUNCAO, NOME_ATITUDE } from '../data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN } from '../data/functional';
import { MATRIZ_PONTUACAO, MAXIMO_CAPACIDADE, MAXIMO_BELBIN, VERSAO_MATRIZ } from '../data/scoringMatrix';
import { analisarEquipe, compararSetores, type MembroAgregado } from './aggregate';
import {
  matrizAnimais, linhasComposicaoParaExcel, linhasMatrizParaExcel, cabecalhoMatriz
} from './animais';
import type { ResultadoIndividual } from './scoring';

export interface RegistroExport {
  participanteId: string;
  nome: string; matricula: string; setor: string; email?: string;
  concluidaEm: string; versao: string; isDemo: boolean;
  /** Verdadeiro quando o respondente também administra o instrumento.
      Opcional: a demo em memória e os testes não têm noção de administrador. */
  ehAdministrador?: boolean;
  respostas: { questaoId: string; alternativaId: string; jung: string; eixo: string; peso: number }[];
  resultado: ResultadoIndividual;
}

export type TipoExport = 'completo' | 'anonimizado' | 'respostas' | 'individual' | 'equipes' | 'metodologia' | 'setor';

const FONTE = { name: 'Arial', size: 10 };
const FONTE_CAB = { name: 'Arial', size: 10, bold: true, color: { argb: 'FFFFFFFF' } };

function aba(wb: ExcelJS.Workbook, nome: string, colunas: string[], linhas: (string | number | boolean | null)[][]) {
  const ws = wb.addWorksheet(nome.slice(0, 31));
  ws.addRow(colunas);
  const cab = ws.getRow(1);
  cab.font = FONTE_CAB;
  cab.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF31556B' } };
  cab.alignment = { vertical: 'middle', wrapText: true };
  cab.height = 26;
  for (const l of linhas) ws.addRow(l);
  ws.columns.forEach((c, i) => {
    const larguras = linhas.slice(0, 200).map(l => String(l[i] ?? '').length);
    c.width = Math.min(58, Math.max(11, colunas[i].length + 2, ...larguras.map(x => Math.min(x + 2, 58))));
    c.font = FONTE;
  });
  ws.views = [{ state: 'frozen', ySplit: 1 }];
  ws.autoFilter = { from: { row: 1, column: 1 }, to: { row: 1, column: colunas.length } };
  return ws;
}

const dataBR = (s: string) => (s ? new Date(s).toLocaleString('pt-BR') : '');

/** Identificador anônimo estável: P00001, P00002… na ordem de conclusão. */
function anonimos(regs: RegistroExport[]) {
  const ord = [...regs].sort((a, b) => a.concluidaEm.localeCompare(b.concluidaEm) || a.matricula.localeCompare(b.matricula));
  return new Map(ord.map((r, i) => [r.participanteId, `P${String(i + 1).padStart(5, '0')}`]));
}

export async function gerarExcel(
  tipo: TipoExport,
  regs: RegistroExport[],
  opcoes: { setor?: string; geradoPor: string; geradoEm: string } = { geradoPor: 'sistema', geradoEm: '' }
): Promise<ArrayBuffer> {
  const anon = tipo === 'anonimizado';
  const ids = anonimos(regs);
  const dados = tipo === 'setor' && opcoes.setor ? regs.filter(r => r.setor === opcoes.setor) : regs;

  const wb = new ExcelJS.Workbook();
  wb.creator = 'Mapeamento da Diversidade de Equipes';
  wb.created = opcoes.geradoEm ? new Date(opcoes.geradoEm) : new Date(0);

  const idDe = (r: RegistroExport) => (anon ? ids.get(r.participanteId)! : r.matricula);
  const membros: MembroAgregado[] = dados.map(r => ({
    id: r.participanteId, setor: r.setor,
    perfil: r.resultado.perfilPrincipal, perfilSecundario: r.resultado.perfilSecundario,
    atitude: r.resultado.atitude, funcaoDominante: r.resultado.funcaoDominante,
    jung: r.resultado.escores.relativo, eixos: r.resultado.escores.eixos.relativo,
    capacidades: r.resultado.funcional.capacidades, belbin: r.resultado.funcional.belbin
  }));

  /* ── Abas por tipo ── */
  /* Item 65 — o animal predominante consta também na tabela individual. */
  const animalDe = (r: RegistroExport) =>
    PERFIS.find(p => p.id === r.resultado.perfilPrincipal)?.animal ?? '';

  const abaParticipantes = () => aba(wb, 'Participantes',
    anon ? ['ID', 'Setor', 'Perfil predominante', 'Animal predominante', 'Concluída em', 'Versão', 'Demo', 'Administrador']
      : ['ID', 'Nome', 'Matrícula', 'Setor', 'E-mail', 'Perfil predominante', 'Animal predominante',
         'Concluída em', 'Versão', 'Demo', 'Administrador'],
    dados.map(r => anon
      ? [idDe(r), r.setor, r.resultado.perfilPrincipal, animalDe(r), dataBR(r.concluidaEm), r.versao,
         r.isDemo, !!r.ehAdministrador]
      : [idDe(r), r.nome, r.matricula, r.setor, r.email ?? '', r.resultado.perfilPrincipal, animalDe(r),
         dataBR(r.concluidaEm), r.versao, r.isDemo, !!r.ehAdministrador]));

  const abaRespostas = () => aba(wb, 'Respostas Brutas',
    ['ID', 'Setor', 'Questão', 'Alternativa', 'Polo Jung', 'Eixo comportamental', 'Peso do item', 'Texto da alternativa'],
    dados.flatMap(r => r.respostas.map(x => [
      idDe(r), r.setor, x.questaoId, x.alternativaId, x.jung, NOME_EIXO[x.eixo as keyof typeof NOME_EIXO] ?? x.eixo, x.peso,
      QUESTOES.find(q => q.id === x.questaoId)?.alternativas.find(a => a.id === x.alternativaId)?.texto ?? ''
    ])));

  const abaJung = () => aba(wb, 'Resultados Jung',
    ['ID', 'Setor', 'Perfil principal', 'Animal', 'Perfil secundário', 'Atitude', 'Função dominante', 'Função auxiliar',
      'Função inferior', 'Empate', 'Regra de desempate',
      'Extroversão', 'Introversão', 'Pensamento', 'Sentimento', 'Sensação', 'Intuição'],
    dados.map(r => {
      const x = r.resultado, rel = x.escores.relativo;
      return [idDe(r), r.setor, x.perfilPrincipal, PERFIS.find(p => p.id === x.perfilPrincipal)!.animal,
        x.perfilSecundario, NOME_ATITUDE[x.atitude], NOME_FUNCAO[x.funcaoDominante], NOME_FUNCAO[x.funcaoAuxiliar],
        NOME_FUNCAO[x.funcaoInferior], x.empateFuncoes, x.regraDesempate ?? '',
        rel.E, rel.I, rel.T, rel.F, rel.S, rel.N];
    }));

  const abaFuncionais = () => aba(wb, 'Resultados Funcionais',
    ['ID', 'Setor', ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => NOME_EIXO[e]),
      ...CAPACIDADES.map(c => c.nome)],
    dados.map(r => [idDe(r), r.setor,
      ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => r.resultado.escores.eixos.relativo[e]),
      ...CAPACIDADES.map(c => r.resultado.funcional.capacidades[c.id])]));

  const abaBelbin = () => aba(wb, 'Resultados Belbin',
    ['ID', 'Setor', '1ª proximidade', 'Intensidade', '2ª proximidade', 'Intensidade', '3ª proximidade', 'Intensidade',
      ...PAPEIS_BELBIN.map(p => p.nome)],
    dados.map(r => {
      const t = r.resultado.top3Belbin;
      return [idDe(r), r.setor,
        t[0]?.nome ?? '', t[0]?.intensidade ?? '', t[1]?.nome ?? '', t[1]?.intensidade ?? '', t[2]?.nome ?? '', t[2]?.intensidade ?? '',
        ...PAPEIS_BELBIN.map(p => r.resultado.funcional.belbin[p.id])];
    }));

  const abaPerfis = () => aba(wb, 'Oito Perfis',
    ['Código', 'Perfil junguiano', 'Animal', 'Atitude', 'Função', 'Função inferior', 'Síntese'],
    PERFIS.map(p => [p.id, p.nomeJung, p.animal, NOME_ATITUDE[p.atitude], NOME_FUNCAO[p.funcao], NOME_FUNCAO[p.funcaoInferior], p.sintese]));

  const abaEquipes = () => {
    const grupos: Record<string, MembroAgregado[]> = {};
    for (const m of membros) (grupos[m.setor] ||= []).push(m);
    const comp = compararSetores(grupos);
    return aba(wb, 'Equipes',
      ['Equipe', 'Participantes', 'IDF', 'ICF', 'Amostra suficiente', 'Perfil mais presente',
        'Capacidade mais coberta', 'Capacidade menos coberta',
        'Pensamento', 'Sentimento', 'Sensação', 'Intuição', 'Extroversão', 'Introversão',
        ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => NOME_EIXO[e])],
      comp.map(l => [l.setor, l.n, l.idf, l.icf, l.amostraSuficiente, `${l.perfilTop?.animal ?? '—'} (${l.perfilTop?.n ?? 0})`,
        l.coberturaTopo, l.coberturaBase,
        l.funcoes.T, l.funcoes.F, l.funcoes.S, l.funcoes.N, l.atitudes.E, l.atitudes.I,
        ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => l.eixos[e])]));
  };

  const abaDistribuicao = () => {
    const a = analisarEquipe(membros);
    return aba(wb, 'Distribuição dos Perfis',
      ['Perfil', 'Animal', 'Nome junguiano', 'Participantes', 'Percentual'],
      a.distribuicaoPerfis.map(p => [p.perfil, p.animal, p.nome, p.n, p.pct]));
  };

  const abaAnimais = () => aba(wb, 'Animais',
    ['Animal', 'Perfil', 'Correspondência junguiana', 'Luz (síntese)', 'Sombra (síntese)'],
    PERFIS.map(p => [p.animal, p.id, p.nomeJung, p.luz.slice(0, 400), p.sombra.slice(0, 400)]));

  /* ══════════════════════════════════════════════════════════════════════
     COMPOSIÇÃO DOS ANIMAIS — Parte K (itens 62 a 64, 66 e 67)
     ----------------------------------------------------------------------
     As três abas abaixo saem da MESMA rotina que alimenta o dashboard
     (`src/lib/animais.ts`). Não há uma segunda contagem: se a tela mostra
     "MEC · Raposa · 8 · 20%", estas abas mostram exatamente a mesma linha.
     ══════════════════════════════════════════════════════════════════════ */
  const abaComposicaoAnimais = () => aba(wb, 'Composição dos Animais',
    ['Equipe', 'Animal', 'Quantidade', 'Percentual', 'Total da Equipe'],
    linhasComposicaoParaExcel(matrizAnimais(membros)));

  const abaAnimaisPorEquipe = () => aba(wb, 'Animais por Equipe',
    cabecalhoMatriz(matrizAnimais(membros)),
    linhasMatrizParaExcel(matrizAnimais(membros), 'quantidade'));

  const abaPercentualAnimais = () => aba(wb, 'Percentual de Animais',
    cabecalhoMatriz(matrizAnimais(membros)),
    linhasMatrizParaExcel(matrizAnimais(membros), 'percentual'));

  const abaCobertura = () => {
    const a = analisarEquipe(membros);
    return aba(wb, 'Cobertura Funcional',
      ['Capacidade', 'Referência Belbin', 'Cobertura (%)', 'Nível', 'Portadores', 'Média da equipe', 'Descrição'],
      a.cobertura.map(c => [c.nome, c.belbin, c.valor, c.nivel, c.portadores, c.media, c.desc]));
  };

  const abaIndicadores = () => {
    const a = analisarEquipe(membros);
    return aba(wb, 'Indicadores',
      ['Indicador', 'Valor', 'Faixa', 'Observação'],
      [
        ['Participantes com avaliação concluída', a.n, '', 'Mesma base usada nos dashboards'],
        ['IDF — Índice de Diversidade Funcional', a.idf, a.idfFaixa, '25% entropia dos perfis + 25% entropia das funções + 50% dispersão real dos escores'],
        ['IDF — componente perfis', a.idfComponentes.perfis, '', 'Entropia normalizada da distribuição dos 8 perfis'],
        ['IDF — componente funções', a.idfComponentes.funcoes, '', 'Entropia normalizada da distribuição das 4 funções'],
        ['IDF — componente dispersão vetorial', a.idfComponentes.dispersaoVetorial, '', 'Desvio-padrão médio dos 22 escores contínuos, normalizado'],
        ['ICF — Índice de Cobertura Funcional', a.icf, a.icfFaixa, '70% presença de portadores + 30% média, por capacidade'],
        ['Complementaridade', a.complementaridade.pct, '', `${a.complementaridade.capacidadesCobertas} de ${a.complementaridade.total} capacidades com ao menos um portador`],
        ['Concentração de perfis (HHI)', a.concentracao.hhi, '', 'Herfindahl sobre a distribuição dos perfis'],
        ['Perfis presentes', a.concentracao.perfisPresentes, '', 'De um total de 8'],
        ...a.belbinEquipe.map(b => [`Belbin — ${b.nome} (média)`, b.media, b.intensidade, `${b.portadores} participante(s) acima do limiar`])
      ] as (string | number)[][]);
  };

  const abaMetodologia = () => {
    aba(wb, 'Matriz de Pontuação',
      ['Questão', 'Alternativa', 'Tipo', 'Peso', 'Contexto', 'Texto', 'Jung', 'Eixo', 'Capacidades', 'Proximidades Belbin'],
      MATRIZ_PONTUACAO.map(l => [l.questaoId, l.alternativaId, l.tipo, l.peso, l.contexto, l.texto, l.jung, NOME_EIXO[l.eixo],
        Object.entries(l.capacidades).map(([k, v]) => `${k}+${v}`).join(' '),
        Object.entries(l.belbin).map(([k, v]) => `${k}+${v}`).join(' ')]));
    aba(wb, 'Denominadores',
      ['Dimensão', 'Tipo', 'Máximo obtenível', 'Uso'],
      [
        ['Extroversão / Introversão', 'Atitude', PESO_TOTAL_ATITUDE, 'Denominador do escore relativo interno'],
        ['Pensamento / Sentimento / Sensação / Intuição', 'Função', PESO_TOTAL_FUNCAO, 'Denominador do escore relativo interno'],
        ...(['EXP', 'EXE', 'AUT', 'COO', 'FLE', 'EST'] as const).map(e => [NOME_EIXO[e], 'Eixo comportamental', MAXIMO_POR_EIXO[e], 'Denominador do escore relativo interno']),
        ...CAPACIDADES.map(c => [c.nome, 'Capacidade funcional', MAXIMO_CAPACIDADE[c.id], 'Denominador do escore relativo interno']),
        ...PAPEIS_BELBIN.map(p => [p.nome, 'Proximidade Belbin', MAXIMO_BELBIN[p.id], 'Denominador do escore relativo interno'])
      ] as (string | number)[][]);
    // Frequência de resposta por alternativa
    const freq: Record<string, number> = {};
    for (const r of dados) for (const x of r.respostas) freq[x.alternativaId] = (freq[x.alternativaId] ?? 0) + 1;
    aba(wb, 'Frequência das Alternativas',
      ['Questão', 'Alternativa', 'Escolhas', 'Percentual do item', 'Texto'],
      QUESTOES.flatMap(q => {
        const total = q.alternativas.reduce((s, a) => s + (freq[a.id] ?? 0), 0) || 1;
        return q.alternativas.map(a => [q.id, a.id, freq[a.id] ?? 0, Math.round(((freq[a.id] ?? 0) / total) * 1000) / 10, a.texto]);
      }));
  };

  const abaDicionario = () => aba(wb, 'Dicionário de Dados',
    ['Campo', 'Significado', 'Observação'],
    [
      ['ID', anon ? 'Identificador anônimo sequencial (P00001, P00002…), atribuído por ordem de conclusão' : 'Matrícula do participante', anon ? 'Nome e matrícula foram removidos desta exportação' : 'Dado pessoal — trate conforme a política de privacidade da organização'],
      ['Escores relativos internos', 'Participação de cada polo no conjunto das respostas do próprio respondente, de 0 a 100', 'NÃO são percentis populacionais. O instrumento não foi normatizado.'],
      ['Perfil principal', 'Combinação de atitude e função dominante (Te, Ti, Fe, Fi, Se, Si, Ne, Ni)', 'Trilha psicológica'],
      ['Perfil secundário', 'Mesma atitude somada à função auxiliar, que vem do outro par de opostos', 'Regra junguiana, não conveniência'],
      ['Função inferior', 'Oposta da dominante — base da leitura de comportamento sob pressão', 'Conceito de Jung'],
      ['Empate', 'Verdadeiro quando duas funções tiveram o mesmo escore e a regra de desempate foi acionada', 'A regra aplicada consta na coluna seguinte'],
      ['Capacidades funcionais', 'Dez capacidades calculadas a partir das respostas comportamentais do participante', 'Trilha funcional — independente do perfil junguiano'],
      ['Proximidades Belbin', 'Proximidade funcional com os nove papéis, calculada a partir das respostas', 'Não corresponde ao instrumento oficial de Belbin'],
      ['IDF', 'Índice de Diversidade Funcional, 0 a 100', 'Faixas são parâmetros internos exploratórios, não normas'],
      ['ICF', 'Índice de Cobertura Funcional, 0 a 100', 'Idem'],
      ['Portador', 'Participante com escore relativo ≥ 50 em uma capacidade', 'Limiar interno declarado'],
      ['Demo', 'Verdadeiro para registros de demonstração', 'Devem ser excluídos de qualquer análise real'],
      ['Administrador', 'Verdadeiro quando quem respondeu também administra o instrumento', 'Continua contando nos indicadores — a coluna existe para que a leitura saiba de quem é a linha'],
      ['Animal predominante', 'Metáfora didática associada ao perfil principal do participante', 'Símbolo de comportamento, nunca classificação da pessoa'],
      ['Aba Composição dos Animais', 'Uma linha por equipe e animal: quantidade, percentual e total da equipe', 'Mesma rotina de agregação que alimenta o dashboard — os números coincidem'],
      ['Aba Animais por Equipe', 'Matriz Equipe × Animal em quantidade de pessoas', 'A coluna Total repete o número de avaliações válidas da equipe'],
      ['Aba Percentual de Animais', 'A mesma matriz em percentual da própria equipe', 'Cada linha totaliza 100%, salvo arredondamento de uma casa decimal'],
      ['Animais com zero', 'Categorias sem nenhum respondente permanecem nas tabelas', 'Esconder a categoria vazia distorceria a leitura da composição']
    ]);

  const abaInfo = () => {
    const setores = Array.from(new Set(dados.map(d => d.setor))).sort();
    return aba(wb, 'Informações da Exportação',
      ['Item', 'Valor'],
      [
        ['Tipo de exportação', tipo],
        ['Gerado em', opcoes.geradoEm || '(não informado)'],
        ['Gerado por', opcoes.geradoPor],
        ['Registros exportados', dados.length],
        ['Registros de demonstração incluídos', dados.filter(d => d.isDemo).length],
        ['Respondentes que administram o instrumento', dados.filter(d => d.ehAdministrador).length],
        ['Equipes representadas', setores.length],
        ['Equipes', setores.join(', ')],
        ['Versão do instrumento', VERSAO_INSTRUMENTO],
        ['Versão da matriz de pontuação', VERSAO_MATRIZ],
        ['Anonimização', anon ? 'SIM — nome e matrícula removidos' : 'NÃO — contém dados pessoais'],
        ['Fonte dos números', 'Os valores desta planilha são produzidos pelo mesmo algoritmo determinístico que alimenta os dashboards. Contagens e percentuais coincidem com o que a interface exibe.'],
        ['Premissa declarada', 'Escores são relativos internos, normalizados pelo máximo obtenível em cada dimensão. Não há percentis populacionais.'],
        ['Estado psicométrico', 'Instrumento em versão piloto, NÃO validado psicometricamente. Não usar para seleção, promoção, transferência ou desligamento.'],
        ['Limite metodológico', 'Este instrumento representa tendências de autorrelato e possui finalidade de desenvolvimento organizacional. Não constitui diagnóstico psicológico, avaliação clínica ou instrumento psicométrico validado.']
      ]);
  };

  switch (tipo) {
    case 'completo':
    case 'anonimizado':
      abaParticipantes(); abaRespostas(); abaJung(); abaFuncionais(); abaBelbin();
      abaPerfis(); abaEquipes(); abaDistribuicao(); abaAnimais();
      abaComposicaoAnimais(); abaAnimaisPorEquipe(); abaPercentualAnimais();
      abaCobertura(); abaIndicadores(); abaDicionario(); abaInfo();
      break;
    case 'respostas': abaRespostas(); abaDicionario(); abaInfo(); break;
    case 'individual': abaJung(); abaFuncionais(); abaBelbin(); abaDicionario(); abaInfo(); break;
    case 'equipes':
      abaEquipes(); abaDistribuicao();
      abaComposicaoAnimais(); abaAnimaisPorEquipe(); abaPercentualAnimais();
      abaCobertura(); abaIndicadores(); abaDicionario(); abaInfo();
      break;
    case 'metodologia': abaMetodologia(); abaDicionario(); abaInfo(); break;
    case 'setor':
      abaParticipantes(); abaJung(); abaFuncionais(); abaBelbin();
      abaComposicaoAnimais(); abaCobertura(); abaIndicadores();
      abaDicionario(); abaInfo();
      break;
  }

  return wb.xlsx.writeBuffer() as Promise<ArrayBuffer>;
}

export const NOME_ARQUIVO: Record<TipoExport, string> = {
  completo: 'mapeamento-completo', anonimizado: 'mapeamento-anonimizado',
  respostas: 'respostas-brutas', individual: 'resultados-individuais',
  equipes: 'resumo-por-equipe', metodologia: 'dados-metodologicos', setor: 'equipe'
};
