/**
 * ETAPA 17 — BATERIA DE TESTES (itens 72, 73 e 74)
 * ---------------------------------------------------------------------------
 * Sem framework, sem rede. Falha com exit 1.
 * Cobre: consistência, determinismo, as duas trilhas, retomada, agregação,
 * privacidade, exportação Excel e coincidência dashboard × Excel.
 */
import { VERSAO_INSTRUMENTO } from '../src/data/questions';
import { QUESTOES_COMPLETAS as QUESTOES, ALTERNATIVA_POR_ID, PESO_TOTAL_ATITUDE, PESO_TOTAL_FUNCAO } from '../src/data/questions.server';
import { MATRIZ_PONTUACAO, LINHA_POR_ALTERNATIVA } from '../src/data/scoringMatrix';
import { avaliar, calcularEscores, calcularFuncional, determinarPerfil, desempatar, vetorDe, intensidade, type Resposta } from '../src/lib/scoring';
import { analisarEquipe, compararSetores, compararComEquipe, MIN_PARTICIPANTES_INTERPRETACAO, type MembroAgregado } from '../src/lib/aggregate';
import { gerarExcel, type RegistroExport } from '../src/lib/excel';
import { comoVoceFunciona, luz, sombra, belbinDetalhado, contribuicaoFuncional, leituraExecutivaIndividual, blocosLeituraExecutiva } from '../src/lib/narrative';
import { PERFIS, perfilDe, OPOSTA } from '../src/data/profiles';
import { CAPACIDADES, PAPEIS_BELBIN } from '../src/data/functional';
import { gerarParticipantes, prng, respostasComVies } from './simulate';

let falhas = 0, testes = 0;
const ok = (nome: string, cond: boolean, det = '') => {
  testes++;
  if (cond) console.log(`  ✓ ${nome}`);
  else { falhas++; console.log(`  ✗ ${nome}${det ? ' — ' + det : ''}`); }
};
const secao = (t: string) => console.log(`\n${t}\n${'─'.repeat(t.length)}`);

console.log('═'.repeat(78));
console.log('BATERIA DE TESTES — v2.0 (duas trilhas independentes)');
console.log('═'.repeat(78));

const coorte = gerarParticipantes();
const avaliacoes = coorte.map(p => avaliar(p.respostas));
const membros: MembroAgregado[] = coorte.map((p, i) => ({ id: p.matricula, setor: p.setor, ...vetorDe(avaliacoes[i]) }));

/* ── 1. CONSISTÊNCIA (item 73) ───────────────────────────────────────────── */
secao('1. Consistência — as três regras fundamentais do item 73');
{
  const r1 = respostasComVies(prng(1), 'E', 'N', 0.8);
  ok('mesmas respostas ⇒ mesmos escores', JSON.stringify(calcularEscores(r1)) === JSON.stringify(calcularEscores(r1)));
  ok('mesmos escores ⇒ mesmo resultado Jung',
    JSON.stringify(determinarPerfil(calcularEscores(r1))) === JSON.stringify(determinarPerfil(calcularEscores(r1))));

  // A REGRA CENTRAL DA REFATORAÇÃO
  const porPerfil: Record<string, number[]> = {};
  avaliacoes.forEach((a, i) => (porPerfil[a.perfilPrincipal] ||= []).push(i));
  let paresTestados = 0, paresComBelbinDiferente = 0, paresComTop3Diferente = 0;
  for (const idxs of Object.values(porPerfil)) {
    for (let i = 0; i + 1 < idxs.length; i += 2) {
      const A = avaliacoes[idxs[i]], B = avaliacoes[idxs[i + 1]];
      const mesmasRespostas = JSON.stringify(coorte[idxs[i]].respostas) === JSON.stringify(coorte[idxs[i + 1]].respostas);
      if (mesmasRespostas) continue;
      paresTestados++;
      if (JSON.stringify(A.funcional.belbin) !== JSON.stringify(B.funcional.belbin)) paresComBelbinDiferente++;
      if (A.top3Belbin.map(x => x.id).join() !== B.top3Belbin.map(x => x.id).join()) paresComTop3Diferente++;
    }
  }
  ok(`mesmo perfil Jung + respostas diferentes ⇒ Belbin diferente (${paresComBelbinDiferente}/${paresTestados})`,
    paresTestados > 0 && paresComBelbinDiferente === paresTestados);
  ok(`ordem do top-3 Belbin também varia dentro do mesmo perfil (${paresComTop3Diferente}/${paresTestados})`,
    paresComTop3Diferente >= paresTestados * 0.6, `${paresComTop3Diferente} de ${paresTestados}`);

  let identicas = true;
  for (let i = 0; i < 150; i++) {
    const rr = respostasComVies(prng(i), i % 2 ? 'E' : 'I', 'TFSN'[i % 4] as any, 0.4 + (i % 6) / 10);
    if (JSON.stringify(avaliar(rr)) !== JSON.stringify(avaliar(rr))) identicas = false;
  }
  ok('150 execuções repetidas: nenhuma variação', identicas);
  ok('ordem das respostas não altera o resultado',
    JSON.stringify(avaliar([...r1].reverse())) === JSON.stringify(avaliar(r1)));
}

/* ── 2. INDEPENDÊNCIA DAS TRILHAS ────────────────────────────────────────── */
secao('2. Independência entre as duas trilhas');
{
  ok('a trilha funcional não consulta o perfil junguiano',
    !/perfilPrincipal|PERFIL_POR_ID|MATRIZ_FUNCIONAL/.test(calcularFuncional.toString()));

  // Mesmo perfil Jung, capacidades diferentes
  const grupos: Record<string, Set<string>> = {};
  avaliacoes.forEach(a => {
    (grupos[a.perfilPrincipal] ||= new Set()).add(a.capacidadesOrdenadas.slice(0, 3).map(c => c.id).join('>'));
  });
  const variados = Object.entries(grupos).filter(([, s]) => s.size > 1).length;
  ok(`perfis com mais de uma configuração de capacidades: ${variados}/${Object.keys(grupos).length}`,
    variados === Object.keys(grupos).length);

  // A trilha Jung continua determinada apenas pelos polos Jung
  const a1 = avaliar(respostasComVies(prng(5), 'I', 'T', 0.9));
  ok('trilha Jung preservada: perfil = atitude + função dominante',
    a1.perfilPrincipal === perfilDe(a1.atitude, a1.funcaoDominante).id);
  ok('função auxiliar vem sempre do outro par de opostos',
    avaliacoes.every(a => a.funcaoAuxiliar !== a.funcaoDominante && a.funcaoAuxiliar !== OPOSTA[a.funcaoDominante]));
  ok('função inferior é sempre a oposta da dominante',
    avaliacoes.every(a => a.funcaoInferior === OPOSTA[a.funcaoDominante]));
}

/* ── 3. INVARIANTES E MATRIZ ─────────────────────────────────────────────── */
secao('3. Invariantes de escore e matriz de pontuação');
{
  ok(`E + I = ${PESO_TOTAL_ATITUDE} em todas as avaliações`,
    avaliacoes.every(a => a.escores.bruto.E + a.escores.bruto.I === PESO_TOTAL_ATITUDE));
  ok(`T + F + S + N = ${PESO_TOTAL_FUNCAO} em todas as avaliações`,
    avaliacoes.every(a => ['T', 'F', 'S', 'N'].reduce((s, f) => s + (a.escores.bruto as any)[f], 0) === PESO_TOTAL_FUNCAO));
  ok('E + I é ímpar → empate de atitude impossível', PESO_TOTAL_ATITUDE % 2 === 1);
  ok('todos os escores relativos ficam entre 0 e 100',
    avaliacoes.every(a => [...Object.values(a.escores.relativo), ...Object.values(a.funcional.capacidades), ...Object.values(a.funcional.belbin)]
      .every(v => v >= 0 && v <= 100)));
  ok('matriz cobre as 192 alternativas', MATRIZ_PONTUACAO.length === 192);
  ok('todas as 10 capacidades são alcançáveis',
    CAPACIDADES.every(c => avaliacoes.some(a => a.funcional.capacidades[c.id] >= 50)));
  ok('todos os 9 papéis Belbin são alcançáveis',
    PAPEIS_BELBIN.every(p => avaliacoes.some(a => a.funcional.belbin[p.id] >= 50)));
  ok('rótulos de intensidade cobrem toda a escala',
    ['Muito baixa', 'Baixa', 'Moderada', 'Alta', 'Muito alta'].every(r => [0, 20, 35, 50, 70].map(intensidade).includes(r as any)));
}

/* ── 3B. CASCATA DE DESEMPATE D1 → D2 → D3 ───────────────────────────────── */
/**
 * A cascata decide DOIS perfis: o principal (função dominante) e o secundário
 * (função auxiliar). Até `v1.0-piloto` a auxiliar não passava por aqui — era
 * resolvida em silêncio, sem registro, e de fora isso era indistinguível de um
 * sorteio. Esta seção existe para que a cascata deixe de ser código sem prova:
 * antes dela, D1, D2 e D3 podiam ser reescritos sem que nenhum teste caísse.
 *
 * Cada caso confere as DUAS coisas: quem venceu e qual degrau foi declarado.
 * O texto da regra vai para o banco e para o Excel, e é lido por gente.
 */
secao('3B. Cascata de desempate — D1, D2, D3 e o texto declarado');
{
  const bru = (T: number, F: number, S: number, N: number) => ({ E: 0, I: 0, T, F, S, N });
  const eix = (EST: number, EXE: number, COO: number, EXP: number) =>
    ({ EST, EXE, COO, EXP, AUT: 0, FLE: 0 } as any);
  const neutro = eix(5, 5, 5, 5);

  // Candidata única: não há degrau nenhum a declarar.
  {
    const d = desempatar(['T'], bru(10, 0, 0, 0), neutro);
    ok('candidata única ⇒ nenhuma regra declarada', d.vencedora === 'T' && d.regra === null);
  }

  // D1 — vence a função cuja oposta tem o menor escore.
  {
    const d = desempatar(['T', 'S'], bru(10, 2, 10, 5), neutro);
    ok('D1 resolve: oposta de T (F=2) < oposta de S (N=5) ⇒ T',
      d.vencedora === 'T', `veio ${d.vencedora}`);
    ok('D1 é o único degrau declarado',
      d.regra !== null && d.regra.startsWith('D1:') && !d.regra.includes('D2') && !d.regra.includes('D3'),
      String(d.regra));
  }

  // D2 — evidência convergente nos eixos. D1 é inerte (as duas distâncias são 5).
  {
    const d = desempatar(['T', 'N'], bru(10, 5, 5, 10), eix(9, 9, 1, 1));
    ok('D2 resolve: T se apoia em Estrutura+Execução (18) contra N em Cooperação+Exploração (2) ⇒ T',
      d.vencedora === 'T', `veio ${d.vencedora}`);
    ok('D1 não é declarado quando não elimina ninguém',
      d.regra !== null && d.regra.startsWith('D2:') && !d.regra.includes('D1'), String(d.regra));

    const inverso = desempatar(['T', 'N'], bru(10, 5, 5, 10), eix(1, 1, 9, 9));
    ok('D2 inverte quando os eixos invertem ⇒ N', inverso.vencedora === 'N', `veio ${inverso.vencedora}`);
  }

  // D2 é estruturalmente incapaz de separar {T,S} e {F,N}: mesma fórmula de
  // afinidade para os dois membros. Estes casos precisam cair em D3 — e o texto
  // NÃO pode afirmar que D2 foi aplicado.
  {
    const d = desempatar(['T', 'S'], bru(10, 4, 10, 4), eix(9, 9, 1, 1));
    ok('D3 resolve {T,S}: D2 dá o mesmo valor aos dois ⇒ ordem canônica ⇒ T',
      d.vencedora === 'T', `veio ${d.vencedora}`);
    ok('o texto NÃO afirma D2 num caso que D2 não resolveu',
      d.regra === 'D3: ordem canônica fixa (critério arbitrário de último recurso).', String(d.regra));

    const fn = desempatar(['F', 'N'], bru(4, 10, 4, 10), eix(1, 1, 9, 9));
    ok('D3 resolve {F,N}: ordem canônica T,S,F,N ⇒ F', fn.vencedora === 'F', `veio ${fn.vencedora}`);
  }

  // A cascata sempre termina: D3 é total sobre as quatro funções.
  {
    const d = desempatar(['T', 'F', 'S', 'N'], bru(6, 6, 6, 6), neutro);
    ok('empate das quatro funções ainda resolve (D3 fecha a cascata)',
      d.vencedora === 'T' && d.regra !== null && d.regra.includes('D3'));
  }

  // Determinismo: sem Math.random, sem sort instável, sem ordem de objeto.
  {
    const cem = Array.from({ length: 200 }, () =>
      JSON.stringify(desempatar(['T', 'N'], bru(10, 5, 5, 10), eix(9, 9, 1, 1))));
    ok('200 execuções do desempate ⇒ resultado idêntico', new Set(cem).size === 1);
    ok('a ordem das candidatas não altera o vencedor',
      desempatar(['N', 'T'], bru(10, 5, 5, 10), eix(9, 9, 1, 1)).vencedora
      === desempatar(['T', 'N'], bru(10, 5, 5, 10), eix(9, 9, 1, 1)).vencedora);
  }

  /* A auxiliar passa pela MESMA cascata. Como as duas candidatas do par auxiliar
     são opostas UMA DA OUTRA e estão empatadas, D1 é sempre inerte ali — quem
     decide é D2, e é exatamente isso que mudou em v1.1. */
  {
    const escoresFake = (T: number, F: number, S: number, N: number, e: any) => ({
      bruto: { E: 20, I: 7, T, F, S, N },
      relativo: {} as any,
      eixos: { bruto: e, relativo: {} as any },
      denominadores: { atitude: 27, funcao: T + F + S + N }
    }) as any;

    const p1 = determinarPerfil(escoresFake(15, 3, 6, 6, eix(9, 9, 1, 1)));
    ok('auxiliar: par {S,N} empatado ⇒ empate declarado, não silencioso',
      p1.funcaoDominante === 'T' && p1.empateAuxiliar === true && p1.regraDesempateAuxiliar !== null);
    ok('auxiliar: D2 escolhe S quando os eixos são Estrutura+Execução',
      p1.funcaoAuxiliar === 'S' && p1.regraDesempateAuxiliar!.startsWith('D2:'),
      `${p1.funcaoAuxiliar} · ${p1.regraDesempateAuxiliar}`);

    const p2 = determinarPerfil(escoresFake(15, 3, 6, 6, eix(1, 1, 9, 9)));
    ok('auxiliar: D2 escolhe N quando os eixos são Cooperação+Exploração',
      p2.funcaoAuxiliar === 'N', `veio ${p2.funcaoAuxiliar}`);
    ok('o perfil SECUNDÁRIO muda junto com a auxiliar',
      p1.perfilSecundario !== p2.perfilSecundario,
      `${p1.perfilSecundario} vs ${p2.perfilSecundario}`);

    const p3 = determinarPerfil(escoresFake(15, 3, 8, 4, eix(1, 1, 9, 9)));
    ok('auxiliar sem empate ⇒ nenhuma regra declarada',
      p3.funcaoAuxiliar === 'S' && p3.empateAuxiliar === false && p3.regraDesempateAuxiliar === null);
  }

  // Coerência do par declarado, na coorte inteira.
  ok('empate de dominante ⟺ regra de dominante declarada',
    avaliacoes.every(a => a.empateFuncoes === (a.regraDesempate !== null)));
  ok('empate de auxiliar ⟺ regra de auxiliar declarada',
    avaliacoes.every(a => a.empateAuxiliar === (a.regraDesempateAuxiliar !== null)));
  ok('nenhuma regra declarada é texto vazio',
    avaliacoes.every(a => (a.regraDesempate ?? 'x') !== '' && (a.regraDesempateAuxiliar ?? 'x') !== ''));
}

/* ── 4. ROBUSTEZ E RETOMADA (itens 53 a 55) ──────────────────────────────── */
secao('4. Robustez, salvamento incremental e retomada');
{
  const vazio = avaliar([]);
  ok('lista vazia não quebra e é marcada incompleta', !vazio.completo && vazio.respostasValidas === 0);
  ok('alternativa inexistente é ignorada',
    avaliar([{ questaoId: 'Q001', alternativaId: 'XXX' }]).respostasValidas === 0);
  ok('alternativa de outra questão é rejeitada',
    avaliar([{ questaoId: 'Q002', alternativaId: 'Q001A' }]).respostasValidas === 0);
  const base = respostasComVies(prng(9), 'I', 'S', 0.8);
  ok('resposta duplicada não conta duas vezes',
    JSON.stringify(avaliar([...base, ...base]).escores.bruto) === JSON.stringify(avaliar(base).escores.bruto));

  // Retomada: responder metade, "sair", voltar e concluir dá o mesmo resultado
  const metade = base.slice(0, 24);
  const parcial = avaliar(metade);
  ok('avaliação parcial é aceita e sinalizada', !parcial.completo && parcial.respostasValidas === 24);
  const retomada = avaliar([...metade, ...base.slice(24)]);
  ok('retomar e concluir produz o mesmo resultado de responder de uma vez',
    JSON.stringify(retomada) === JSON.stringify(avaliar(base)));
  ok('conclusão só é válida com as 48 respostas', avaliar(base.slice(0, 47)).completo === false && avaliar(base).completo === true);
}

/* ── 5. AGREGAÇÃO POR VETORES COMPLETOS (itens 38 a 41) ──────────────────── */
secao('5. Agregação por vetores completos');
{
  const mk = (perfis: string[], capOverride?: number): MembroAgregado[] => perfis.map((pid, i) => {
    const idx = avaliacoes.findIndex(a => a.perfilPrincipal === pid);
    const v = vetorDe(avaliacoes[idx >= 0 ? idx : 0]);
    if (capOverride !== undefined) {
      v.capacidades = Object.fromEntries(CAPACIDADES.map(c => [c.id, capOverride])) as any;
    }
    return { id: `m${i}`, setor: 'X', ...v, perfil: pid as any };
  });

  const homogenea = analisarEquipe(mk(Array(8).fill('Si')));
  const diversa = analisarEquipe(mk(PERFIS.map(p => p.id)));
  ok(`IDF homogênea (${homogenea.idf}) < IDF diversa (${diversa.idf})`, homogenea.idf < diversa.idf);
  ok('IDF usa dispersão real dos escores, não só rótulos', diversa.idfComponentes.dispersaoVetorial > 0);

  // Duas equipes com os MESMOS rótulos mas escores diferentes → IDF diferente
  const rotulosIguaisEscoresIguais = analisarEquipe(mk(PERFIS.map(p => p.id), 50));
  ok('mesmos rótulos com escores idênticos ⇒ IDF menor que com escores dispersos',
    rotulosIguaisEscoresIguais.idf < diversa.idf,
    `${rotulosIguaisEscoresIguais.idf} vs ${diversa.idf}`);

  ok(`ICF diversa (${diversa.icf}) > ICF homogênea (${homogenea.icf})`, diversa.icf > homogenea.icf);
  ok('IDF e ICF entre 0 e 100', [diversa.idf, diversa.icf, homogenea.idf, homogenea.icf].every(v => v >= 0 && v <= 100));
  ok('equipe vazia não quebra', analisarEquipe([]).n === 0);
  ok('grupo pequeno dispara aviso (item 46)', analisarEquipe(mk(['Te', 'Si', 'Fe'])).avisoAmostra !== null);
  ok('Belbin da equipe é calculado das respostas', diversa.belbinEquipe.every(b => b.media >= 0 && b.media <= 100));
  ok('sombra coletiva é sempre derivada de uma força',
    diversa.sombraColetiva.every(s => s.potencia.length > 0 && s.sombra.length > 0));
  ok('recomendações nunca concluem contratação automaticamente',
    diversa.recomendacoes.some(r => r.tipo === 'Recrutamento' && /nunca como conclusão automática/.test(r.texto)));
  ok('ações de liderança são condicionadas aos dados', diversa.acoesLideranca.length > 0);
  ok('leitura Belbin é texto interpretado, não apenas números',
    diversa.leituraBelbin.length >= 3 && diversa.leituraBelbin.join(' ').length > 300);
}

/* ── 6. VOCÊ NA SUA EQUIPE E PRIVACIDADE (itens 20 a 29) ─────────────────── */
secao('6. Comparação individual com a equipe e privacidade');
{
  const mec = membros.filter(m => m.setor === 'MEC');
  const eu = vetorDe(avaliacoes[coorte.findIndex(p => p.setor === 'MEC')]);
  const c = compararComEquipe(eu, mec);
  ok('comparação disponível com amostra suficiente', c.disponivel && c.nSetor === mec.length);
  ok('mostra quantidade e percentual do mesmo perfil', c.mesmoPerfil.n > 0 && c.mesmoPerfil.pct > 0);
  ok('mostra posição relativa do perfil', c.mesmoPerfil.posicao >= 1);
  ok('mostra mesma função dominante', c.mesmaFuncao.n > 0);
  ok('mostra distribuição de atitudes', c.atitudes.E + c.atitudes.I === mec.length);
  ok('produz interpretação de contribuição', c.contribuicao.length > 80);
  ok('não usa linguagem de raridade especial', !/você é raro|precisa de mais pessoas como você/i.test(c.nota + c.contribuicao));

  const pequeno = compararComEquipe(eu, membros.filter(m => m.setor === 'SESMT'));
  ok('grupo com menos de 5 não expõe distribuição (item 29)',
    !pequeno.disponivel && /confidencialidade/.test(pequeno.motivo ?? ''));
  ok('comparação nunca devolve nomes ou matrículas de colegas',
    !JSON.stringify(c).includes(coorte.find(p => p.setor === 'MEC')!.nome));
}

/* ── 7. INTERPRETAÇÃO EM LINGUAGEM NATURAL ───────────────────────────────── */
secao('7. Interpretação individual');
{
  const r = avaliacoes[0];
  ok('as 10 leituras de "como você funciona" são geradas', comoVoceFunciona(r).length === 10);
  ok('todas as leituras usam escores reais', comoVoceFunciona(r).every(d => /\d/.test(d.texto)));
  ok('luz apresenta entre 4 e 6 manifestações', luz(r).length >= 4 && luz(r).length <= 6);
  ok('cada manifestação de luz tem evidência', luz(r).every(l => l.evidencia.length > 15));
  ok('sombra traz força, equilíbrio e excesso', sombra(r).every(s => s.forca && s.equilibrio && s.excesso));
  ok('Belbin individual detalha as 3 maiores proximidades', belbinDetalhado(r).length === 3);
  ok('cada proximidade traz contribuição, uso, excesso e complementaridade',
    belbinDetalhado(r).every(b => b.contribuicao && b.ondeAgrega.length && b.excesso && b.complementaridade));
  ok('contribuição funcional traz significado e uso', contribuicaoFuncional(r).every(c => c.significado && c.noTrabalho && c.quandoUtil));

  const L = leituraExecutivaIndividual(r);
  ok('leitura executiva individual difere da devolutiva do participante',
    !!L.pontosCegos.length && !!L.aproveitar.length && L.limite.includes('Não deve ser usada'));
  ok('leitura executiva não prescreve cargo nem decisão de emprego',
    !/promov|demit|contrat|desligar|transferir/i.test(L.aproveitar.join(' ') + L.quandoValioso));

  const blocos = blocosLeituraExecutiva('MEC', analisarEquipe(membros.filter(m => m.setor === 'MEC')));
  ok('leitura executiva da equipe tem os 5 blocos', blocos.length === 5);
  ok('blocos seguem a ordem exigida',
    blocos.map(b => b.titulo.slice(0, 2)).join() === '1.,2.,3.,4.,5.');
}

/* ── 8. EXPORTAÇÃO EXCEL (itens 58 a 60 e 74) ────────────────────────────── */
secao('8. Exportação Excel');
{
  const regs: RegistroExport[] = coorte.map((p, i) => ({
    participanteId: `p${i}`, nome: p.nome, matricula: p.matricula, setor: p.setor, email: p.email,
    concluidaEm: p.concluidoEm, versao: VERSAO_INSTRUMENTO, isDemo: true,
    respostas: p.respostas.map(x => {
      const a = ALTERNATIVA_POR_ID[x.alternativaId];
      return { questaoId: x.questaoId, alternativaId: x.alternativaId, jung: a.jung, eixo: a.eixo, peso: a.peso };
    }),
    resultado: avaliacoes[i]
  }));

  const ExcelJS = require('exceljs');
  const ler = async (buf: ArrayBuffer) => {
    const wb = new ExcelJS.Workbook();
    await wb.xlsx.load(buf);
    return wb;
  };

  (async () => {
    const completo = await ler(await gerarExcel('completo', regs, { geradoPor: 'teste', geradoEm: '2026-01-01T00:00:00Z' }));
    const abas = completo.worksheets.map((w: any) => w.name);
    // A partir da v3.0 são 16 abas: as 13 originais MAIS as três de composição
    // dos animais, acrescentadas pelos itens 62 a 64 do prompt de evolução.
    // As 13 anteriores continuam obrigatórias — nenhuma exportação foi removida.
    ok(`Excel completo tem 16 abas (${abas.length})`, abas.length === 16, abas.join(', '));
    ok('as três abas novas de composição dos animais estão presentes',
      ['Composição dos Animais', 'Animais por Equipe', 'Percentual de Animais'].every(n => abas.includes(n)));
    ok('inclui as abas exigidas pelo item 59',
      ['Participantes', 'Respostas Brutas', 'Resultados Jung', 'Resultados Funcionais', 'Resultados Belbin',
        'Oito Perfis', 'Equipes', 'Distribuição dos Perfis', 'Animais', 'Cobertura Funcional', 'Indicadores',
        'Dicionário de Dados', 'Informações da Exportação'].every(n => abas.includes(n)));

    const respostas = completo.getWorksheet('Respostas Brutas');
    ok(`aba de respostas brutas tem ${coorte.length * 48} linhas`, respostas.rowCount === coorte.length * 48 + 1,
      `${respostas.rowCount - 1}`);

    // Item 74 — dashboard × Excel
    const mec = membros.filter(m => m.setor === 'MEC');
    const a = analisarEquipe(mec);
    const equipes = completo.getWorksheet('Equipes');
    let linhaMec: any = null;
    equipes.eachRow((row: any, i: number) => { if (i > 1 && row.getCell(1).value === 'MEC') linhaMec = row; });
    ok('Excel e dashboard mostram o MESMO n para MEC',
      linhaMec?.getCell(2).value === a.n, `excel=${linhaMec?.getCell(2).value} dashboard=${a.n}`);
    ok('Excel e dashboard mostram o MESMO IDF para MEC',
      linhaMec?.getCell(3).value === a.idf, `excel=${linhaMec?.getCell(3).value} dashboard=${a.idf}`);
    ok('Excel e dashboard mostram o MESMO ICF para MEC',
      linhaMec?.getCell(4).value === a.icf, `excel=${linhaMec?.getCell(4).value} dashboard=${a.icf}`);

    const anon = await ler(await gerarExcel('anonimizado', regs, { geradoPor: 'teste', geradoEm: '2026-01-01T00:00:00Z' }));
    const partAnon = anon.getWorksheet('Participantes');
    const cabAnon = (partAnon.getRow(1).values as any[]).filter(Boolean);
    ok('Excel anonimizado remove nome e matrícula',
      !cabAnon.includes('Nome') && !cabAnon.includes('Matrícula'), cabAnon.join(','));
    ok('Excel anonimizado usa IDs P00001, P00002…',
      /^P\d{5}$/.test(String(partAnon.getRow(2).getCell(1).value)));
    const nomes = coorte.map(p => p.nome);
    let vazouNome = false;
    partAnon.eachRow((row: any) => row.eachCell((c: any) => { if (nomes.includes(String(c.value))) vazouNome = true; }));
    ok('nenhum nome vaza na exportação anonimizada', !vazouNome);

    const setorial = await ler(await gerarExcel('setor', regs, { setor: 'MEC', geradoPor: 'teste', geradoEm: '2026-01-01T00:00:00Z' }));
    ok('exportação por equipe filtra corretamente',
      setorial.getWorksheet('Participantes').rowCount - 1 === regs.filter(r => r.setor === 'MEC').length);

    const metodologia = await ler(await gerarExcel('metodologia', regs, { geradoPor: 'teste', geradoEm: '2026-01-01T00:00:00Z' }));
    ok('exportação metodológica traz a matriz de pontuação completa',
      metodologia.getWorksheet('Matriz de Pontuação').rowCount === 193);

    finalizar();
  })();
}

function finalizar() {
  /* ── 9. COORTE E SETORES ───────────────────────────────────────────────── */
  secao('9. Coorte simulada e comparativo');
  const p2 = gerarParticipantes();
  ok('geração da coorte é determinística', JSON.stringify(p2) === JSON.stringify(coorte));
  ok(`coorte com ${coorte.length} participantes em 16 equipes`, new Set(coorte.map(p => p.setor)).size === 16);
  ok('todos responderam as 48 questões', coorte.every(p => p.respostas.length === 48));
  ok('todas as respostas têm chave válida',
    coorte.every(p => p.respostas.every(r => ALTERNATIVA_POR_ID[r.alternativaId]?.questaoId === r.questaoId)));
  ok(`coorte cobre os 8 perfis`, new Set(avaliacoes.map(a => a.perfilPrincipal)).size === 8);

  const grupos: Record<string, MembroAgregado[]> = {};
  for (const m of membros) (grupos[m.setor] ||= []).push(m);
  const comp = compararSetores(grupos);
  ok('comparativo cobre as 16 equipes', comp.length === 16);
  ok('comparativo traz capacidades e Belbin por equipe',
    comp.every(l => Object.keys(l.capacidades).length === 10 && Object.keys(l.belbin).length === 9));
  ok('equipes pequenas são sinalizadas', comp.some(l => !l.amostraSuficiente));
  ok('nenhum ranking de melhor equipe é produzido', !('posicao' in comp[0]) && !('nota' in comp[0]));

  const geral = analisarEquipe(membros);
  ok(`IDF organizacional calculado (${geral.idf})`, geral.idf > 0 && geral.idf <= 100);
  ok(`ICF organizacional calculado (${geral.icf})`, geral.icf > 0 && geral.icf <= 100);
  ok('mapa de lacunas produzido com interpretação', geral.lacunas.every(l => l.interpretacao.length > 60));

  console.log('\n' + '═'.repeat(78));
  console.log(`RESULTADO: ${testes - falhas}/${testes} testes aprovados.`);
  console.log('═'.repeat(78));
  process.exit(falhas ? 1 : 0);
}
