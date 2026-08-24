/**
 * ETAPA 3 — MATRIZ FUNCIONAL: PERFIS × CAPACIDADES DE EQUIPE
 * ---------------------------------------------------------------------------
 * Referência: Teoria dos Papéis de Equipe de Meredith Belbin, conforme
 * MIRANDA, A. L. B. B.; VASCONCELOS, C. R. M. "A 'teoria da equipe' de Meredith
 * Belbin na percepção de gestores decisores". Pretexto, v.21, n.3, p.31-48,
 * jul/set 2020 (Universidade FUMEC) — em especial a Tabela 01 (características e
 * função dos nove papéis, fonte Belbin 2014) e a Tabela 02 (papel de Belbin ×
 * dimensões de personalidade).
 *
 * REGRA DO PROMPT-MESTRE (item 24): NÃO existe correspondência rígida
 * perfil → papel. Esta é uma MATRIZ DE PROXIMIDADE FUNCIONAL: cada perfil
 * contribui, em graus diferentes, para várias capacidades. Um perfil nunca "é"
 * um papel de Belbin.
 *
 * Belbin NÃO é usado como um terceiro teste de personalidade (item 22). Ele
 * responde a uma única pergunta: quais contribuições funcionais a equipe possui
 * e quais precisam ser fortalecidas.
 *
 * Escala de afinidade: 0 (ausente) a 5 (muito alta). Toda célula ≥4 ou ≤1 tem
 * justificativa registrada em `JUSTIFICATIVAS`.
 */

import type { PerfilId } from './profiles';

export type Capacidade =
  | 'CRIAR' | 'EXPLORAR' | 'ANALISAR' | 'DECIDIR' | 'ORGANIZAR'
  | 'EXECUTAR' | 'RELACIONAR' | 'COORDENAR' | 'FINALIZAR' | 'ESPECIALIZAR';

export const CAPACIDADES: { id: Capacidade; nome: string; desc: string; belbin: string }[] = [
  { id: 'CRIAR',        nome: 'Criar',        desc: 'Gerar ideias e soluções; desafiar as formas convencionais de fazer as coisas.', belbin: 'Planta' },
  { id: 'EXPLORAR',     nome: 'Explorar',     desc: 'Buscar oportunidades e recursos; configurar contatos externos e realizar negociações.', belbin: 'Investigador de Recursos' },
  { id: 'ANALISAR',     nome: 'Analisar',     desc: 'Avaliar criticamente ideias e problemas; ponderar as opções pró e contra.', belbin: 'Monitor Avaliador' },
  { id: 'DECIDIR',      nome: 'Decidir/Mobilizar', desc: 'Impulsionar a ação e enfrentar obstáculos; exigir decisões rápidas sob pressão.', belbin: 'Formador' },
  { id: 'ORGANIZAR',    nome: 'Organizar',    desc: 'Estruturar e transformar ideias em processos práticos e aplicáveis.', belbin: 'Implementador' },
  { id: 'EXECUTAR',     nome: 'Executar',     desc: 'Colocar decisões em prática de forma confiável e disciplinada.', belbin: 'Implementador' },
  { id: 'RELACIONAR',   nome: 'Relacionar',   desc: 'Favorecer cooperação e equilíbrio interpessoal; resolver problemas interpessoais.', belbin: 'Trabalhador em Equipe' },
  { id: 'COORDENAR',    nome: 'Coordenar',    desc: 'Integrar pessoas e objetivos; detectar talentos e usá-los em busca dos objetivos do grupo.', belbin: 'Coordenador' },
  { id: 'FINALIZAR',    nome: 'Finalizar',    desc: 'Garantir qualidade, detalhes e conclusão; concentração e padrões elevados.', belbin: 'Finalizador' },
  { id: 'ESPECIALIZAR', nome: 'Especializar', desc: 'Fornecer conhecimento técnico aprofundado e orientar os demais.', belbin: 'Especialista' }
];

export type PapelBelbin =
  | 'PLANTA' | 'INV_RECURSOS' | 'COORDENADOR' | 'FORMADOR' | 'MONITOR'
  | 'IMPLEMENTADOR' | 'TRAB_EQUIPE' | 'FINALIZADOR' | 'ESPECIALISTA';

export const PAPEIS_BELBIN: { id: PapelBelbin; nome: string; dimensao: 'tarefa' | 'relacionamento'; resumo: string }[] = [
  { id: 'PLANTA',        nome: 'Planta',                  dimensao: 'tarefa',          resumo: 'Inovadores e inventores, altamente criativos. Introvertidos e independentes. Nem sempre conseguem se comunicar de forma convincente.' },
  { id: 'INV_RECURSOS',  nome: 'Investigador de Recursos',dimensao: 'relacionamento',  resumo: 'Extrovertidos e entusiasmados. Exploram novas oportunidades e desenvolvem contatos. Seus entusiasmos desaparecem rapidamente.' },
  { id: 'COORDENADOR',   nome: 'Coordenador',             dimensao: 'relacionamento',  resumo: 'Maduros e confiantes, delegam prontamente. Rápidos em detectar talentos individuais e usá-los em busca dos objetivos do grupo.' },
  { id: 'FORMADOR',      nome: 'Formador',                dimensao: 'tarefa',          resumo: 'Altamente assertivos e direcionados. Superam obstáculos por pura determinação. Exigem decisões rápidas sob pressão.' },
  { id: 'MONITOR',       nome: 'Monitor Avaliador',       dimensao: 'tarefa',          resumo: 'Sérios e prudentes. Lentos para decidir por pensar cuidadosamente. Lidam com fatos e lógica em vez de emoção. Excessivamente críticos.' },
  { id: 'IMPLEMENTADOR', nome: 'Implementador',           dimensao: 'tarefa',          resumo: 'Práticos, autocontrolados e disciplinados. Sistemáticos e confiáveis. Inflexíveis ao aceitar novas formas de fazer as coisas.' },
  { id: 'TRAB_EQUIPE',   nome: 'Trabalhador em Equipe',   dimensao: 'relacionamento',  resumo: 'Preocupados com os outros, perceptivos e diplomáticos. Bons ouvintes. Preocupados com a harmonia e em evitar conflitos.' },
  { id: 'FINALIZADOR',   nome: 'Finalizador',             dimensao: 'tarefa',          resumo: 'Atentos aos detalhes, esforçados. Confiáveis para concluir trabalhos de alto padrão em tempo. Relutam em confiar em outros.' },
  { id: 'ESPECIALISTA',  nome: 'Especialista',            dimensao: 'tarefa',          resumo: 'Fontes de conhecimento técnico. Amam aprender e acumular conhecimentos. Pouco flexíveis quando questionados sobre seus conhecimentos.' }
];

/** MATRIZ DE PROXIMIDADE FUNCIONAL — perfil × capacidade, 0 a 5. */
export const MATRIZ_FUNCIONAL: Record<PerfilId, Record<Capacidade, number>> = {
  //        CRIAR EXPLORAR ANALISAR DECIDIR ORGANIZAR EXECUTAR RELACIONAR COORDENAR FINALIZAR ESPECIALIZAR
  Te: { CRIAR: 2, EXPLORAR: 3, ANALISAR: 4, DECIDIR: 5, ORGANIZAR: 5, EXECUTAR: 4, RELACIONAR: 2, COORDENAR: 4, FINALIZAR: 3, ESPECIALIZAR: 3 },
  Ti: { CRIAR: 3, EXPLORAR: 1, ANALISAR: 5, DECIDIR: 2, ORGANIZAR: 4, EXECUTAR: 2, RELACIONAR: 2, COORDENAR: 2, FINALIZAR: 4, ESPECIALIZAR: 5 },
  Fe: { CRIAR: 2, EXPLORAR: 3, ANALISAR: 1, DECIDIR: 2, ORGANIZAR: 3, EXECUTAR: 3, RELACIONAR: 5, COORDENAR: 4, FINALIZAR: 3, ESPECIALIZAR: 1 },
  Fi: { CRIAR: 3, EXPLORAR: 1, ANALISAR: 3, DECIDIR: 2, ORGANIZAR: 2, EXECUTAR: 3, RELACIONAR: 5, COORDENAR: 3, FINALIZAR: 3, ESPECIALIZAR: 3 },
  Se: { CRIAR: 2, EXPLORAR: 4, ANALISAR: 2, DECIDIR: 4, ORGANIZAR: 2, EXECUTAR: 5, RELACIONAR: 4, COORDENAR: 2, FINALIZAR: 3, ESPECIALIZAR: 2 },
  Si: { CRIAR: 1, EXPLORAR: 1, ANALISAR: 4, DECIDIR: 2, ORGANIZAR: 5, EXECUTAR: 4, RELACIONAR: 3, COORDENAR: 2, FINALIZAR: 5, ESPECIALIZAR: 4 },
  Ne: { CRIAR: 5, EXPLORAR: 5, ANALISAR: 2, DECIDIR: 3, ORGANIZAR: 1, EXECUTAR: 2, RELACIONAR: 4, COORDENAR: 3, FINALIZAR: 1, ESPECIALIZAR: 1 },
  Ni: { CRIAR: 5, EXPLORAR: 3, ANALISAR: 4, DECIDIR: 3, ORGANIZAR: 2, EXECUTAR: 1, RELACIONAR: 1, COORDENAR: 2, FINALIZAR: 2, ESPECIALIZAR: 4 }
};

/** AFINIDADE COM OS NOVE PAPÉIS — proximidade, nunca identidade (item 24). */
export const AFINIDADE_BELBIN: Record<PerfilId, Record<PapelBelbin, number>> = {
  Te: { PLANTA: 1, INV_RECURSOS: 2, COORDENADOR: 4, FORMADOR: 5, MONITOR: 3, IMPLEMENTADOR: 4, TRAB_EQUIPE: 1, FINALIZADOR: 3, ESPECIALISTA: 2 },
  Ti: { PLANTA: 3, INV_RECURSOS: 1, COORDENADOR: 2, FORMADOR: 1, MONITOR: 5, IMPLEMENTADOR: 3, TRAB_EQUIPE: 1, FINALIZADOR: 3, ESPECIALISTA: 5 },
  Fe: { PLANTA: 1, INV_RECURSOS: 3, COORDENADOR: 4, FORMADOR: 1, MONITOR: 1, IMPLEMENTADOR: 3, TRAB_EQUIPE: 5, FINALIZADOR: 2, ESPECIALISTA: 1 },
  Fi: { PLANTA: 2, INV_RECURSOS: 1, COORDENADOR: 3, FORMADOR: 1, MONITOR: 3, IMPLEMENTADOR: 2, TRAB_EQUIPE: 4, FINALIZADOR: 3, ESPECIALISTA: 3 },
  Se: { PLANTA: 1, INV_RECURSOS: 3, COORDENADOR: 2, FORMADOR: 4, MONITOR: 1, IMPLEMENTADOR: 5, TRAB_EQUIPE: 3, FINALIZADOR: 2, ESPECIALISTA: 2 },
  Si: { PLANTA: 1, INV_RECURSOS: 1, COORDENADOR: 2, FORMADOR: 1, MONITOR: 4, IMPLEMENTADOR: 5, TRAB_EQUIPE: 3, FINALIZADOR: 5, ESPECIALISTA: 4 },
  Ne: { PLANTA: 4, INV_RECURSOS: 5, COORDENADOR: 3, FORMADOR: 3, MONITOR: 1, IMPLEMENTADOR: 1, TRAB_EQUIPE: 3, FINALIZADOR: 1, ESPECIALISTA: 1 },
  Ni: { PLANTA: 5, INV_RECURSOS: 2, COORDENADOR: 2, FORMADOR: 2, MONITOR: 4, IMPLEMENTADOR: 1, TRAB_EQUIPE: 1, FINALIZADOR: 2, ESPECIALISTA: 4 }
};

/** Justificativa teórica de cada célula extrema (≥4 ou ≤1) da matriz funcional. */
export const JUSTIFICATIVAS: Record<string, string> = {
  'Te.DECIDIR': 'Nota 5. O Formador de Belbin "supera os obstáculos por pura determinação" e "exige decisões rápidas para superar ameaças e dificuldades". O tipo Te "estabelece ordem lógica entre coisas externas" e decide rápido quando o critério está claro; o lobo, no livro, planeja a emboscada e coordena o bando para executá-la.',
  'Te.ORGANIZAR': 'Nota 5. Etologicamente o lobo "obedece a leis e hierarquias bem definidas" e escolhe a rota por critério (fila indiana para não deixar pegadas). Jung: submete a própria conduta e a dos outros a um sistema de ideias.',
  'Te.ANALISAR': 'Nota 4. Função dominante racional voltada ao objeto externo; analisa para agir, não para compreender — daí 4 e não 5, reservado ao Ti.',
  'Te.EXECUTAR': 'Nota 4. Alta persistência em esforço longo quando enxerga a lógica; afinidade com o Implementador, "confiável e com capacidade de aplicação".',
  'Te.COORDENAR': 'Nota 4. Coordena por função e papel, não por leitura de talento individual — o que mantém abaixo do Fe, que coordena por vínculo.',
  'Te.PLANTA': 'Nota 1. O Planta é introvertido e criativo por ruptura; Te é extrovertido e melhora o existente. Tabela 02 do artigo situa Planta entre os comportamentos introvertidos.',
  'Te.TRAB_EQUIPE': 'Nota 1. Sentimento é a função inferior deste tipo; o Trabalhador em Equipe é definido pela preocupação com a harmonia, exatamente o recurso menos diferenciado aqui.',
  'Ti.ANALISAR': 'Nota 5. O Monitor Avaliador é "sério e prudente", "lento em tomar decisão por pensar cuidadosamente" e "lida com fatos e lógicas ao invés de emoção" — descrição que coincide ponto a ponto com o pensamento introvertido de Jung, atraído "pelas abstrações teóricas do que pelos fatos em si".',
  'Ti.ESPECIALIZAR': 'Nota 5. O Especialista "ama aprender; acumular conhecimentos como principal motivo de sua existência". O elefante condensa "a memória, a paciência e a autoconfiança" e a sabedoria de Ganesha.',
  'Ti.FINALIZAR': 'Nota 4. Exigência de coerência e padrão elevado sustentam a conclusão de alto rigor — mas o mesmo perfeccionismo conceitual atrasa a entrega, o que impede a nota 5.',
  'Ti.ORGANIZAR': 'Nota 4. Organiza no plano conceitual (modelos, padrões, arquitetura), não no operacional cotidiano.',
  'Ti.EXPLORAR': 'Nota 1. O Investigador de Recursos é extrovertido e desenvolve contatos externos; Ti é o polo oposto em atitude e no livro o elefante "sugere mudanças lentas, porém duradouras".',
  'Ti.INV_RECURSOS': 'Nota 1. Mesma razão: a Tabela 02 do artigo classifica Investigador de Recursos como comportamento extrovertido e espontâneo.',
  'Ti.FORMADOR': 'Nota 1. O Formador é assertivo, competitivo e exige decisão rápida; Ti recusa decidir com informação que considera insuficiente.',
  'Ti.TRAB_EQUIPE': 'Nota 1. Sentimento inferior; vínculos poucos e a autossuficiência que o próprio livro critica.',
  'Fe.RELACIONAR': 'Nota 5. O Trabalhador em Equipe é "perceptivo, diplomático, bom ouvinte, preocupado com a harmonia e em evitar conflitos". Jung: o sentimento extrovertido "capta o que outras pessoas necessitam" e é "capaz de se sacrificar por elas".',
  'Fe.COORDENAR': 'Nota 4. Coordena por vínculo e por leitura de necessidade — próximo do Coordenador, "rápido em detectar talentos individuais" —, mas sem a assertividade de delegar que Belbin atribui ao papel.',
  'Fe.ANALISAR': 'Nota 1. Pensamento é a função inferior; o livro registra que a argumentação lógica correta do cordeiro não o salva — o raciocínio existe, mas não é o recurso que organiza a conduta.',
  'Fe.ESPECIALIZAR': 'Nota 1. Adaptabilidade ampla é o oposto do aprofundamento técnico exclusivo que define o Especialista.',
  'Fe.TRAB_EQUIPE': 'Nota 5. Correspondência mais direta da matriz inteira.',
  'Fe.PLANTA': 'Nota 1. Orientação por valores coletivos, não por ruptura independente.',
  'Fe.FORMADOR': 'Nota 1. Evita o confronto aberto — o oposto do papel argumentativo e competitivo.',
  'Fe.MONITOR': 'Nota 1. Função inferior pensamento; o Monitor é definido pela crítica desapaixonada.',
  'Fi.RELACIONAR': 'Nota 5. Vínculo denso e escuta de alta qualidade; a baleia "não é abandonada até a morte". Relaciona por profundidade, não por articulação.',
  'Fi.EXPLORAR': 'Nota 1. Introversão marcada e ritmo próprio; nenhum material de busca ativa de oportunidade externa.',
  'Fi.TRAB_EQUIPE': 'Nota 4. Próxima do papel, mas exerce a função por presença e coerência, não por diplomacia ativa — o que a distingue do Fe.',
  'Fi.INV_RECURSOS': 'Nota 1. Mesma razão da célula EXPLORAR.',
  'Fi.FORMADOR': 'Nota 1. Não confronta; absorve.',
  'Se.EXECUTAR': 'Nota 5. O Implementador é "prático, autocontrolado e disciplinado" e valorizado pela "capacidade de aplicação". Jung: a sensação extrovertida "só se move na realidade palpável" e tem agudo senso de realidade.',
  'Se.EXPLORAR': 'Nota 4. Busca ativa no campo externo e presença em contato direto — mas explora o disponível agora, não a possibilidade futura, o que reserva a nota 5 ao Ne.',
  'Se.DECIDIR': 'Nota 4. Decide rápido e mobiliza; próximo do Formador, sem a orientação a confronto sistemático deste.',
  'Se.RELACIONAR': 'Nota 4. Alta responsividade interpessoal e leitura fina de tom e postura, ainda que a serviço da ação e não do vínculo.',
  'Se.IMPLEMENTADOR': 'Nota 5. Correspondência direta.',
  'Se.MONITOR': 'Nota 1. Intuição inferior e baixa tolerância a análise prolongada.',
  'Se.PLANTA': 'Nota 1. Inova por experimento concreto, não por ideia original abstrata.',
  'Si.FINALIZAR': 'Nota 5. O Finalizador é "atento aos detalhes", "confiável para fazer trabalhos de alto padrão e concluí-lo em tempo" e "busca a perfeição". Jung: percepção sensorial diferenciada e atenção às qualidades estéticas.',
  'Si.ORGANIZAR': 'Nota 5. Reserva acumulada, rastreabilidade e ritmo calendárico; o urso "comporta-se segundo regras rígidas".',
  'Si.EXECUTAR': 'Nota 4. Execução constante e confiável, em ritmo próprio — o que a diferencia da execução veloz do Se.',
  'Si.ANALISAR': 'Nota 4. Analisa por comparação com o precedente concreto, não por modelo abstrato.',
  'Si.ESPECIALIZAR': 'Nota 4. Acúmulo profundo de repertório concreto em um domínio.',
  'Si.CRIAR': 'Nota 1. Intuição é a função inferior; o livro documenta a ingenuidade como incapacidade específica de imaginar o que ainda não ocorreu.',
  'Si.EXPLORAR': 'Nota 1. Mesma razão, somada à introversão e ao apego ao ambiente previsível.',
  'Si.IMPLEMENTADOR': 'Nota 5. Correspondência direta com "práticos, autocontrolados e disciplinados; sistemáticos".',
  'Si.FINALIZADOR': 'Nota 5. Correspondência direta.',
  'Si.INV_RECURSOS': 'Nota 1. Polo oposto em atitude e em função.',
  'Si.FORMADOR': 'Nota 1. Evita confronto e decide devagar.',
  'Si.PLANTA': 'Nota 1. Função inferior intuição.',
  'Ne.CRIAR': 'Nota 5. O Planta "desafia as formas convencionais e estabelecidas de fazer as coisas" e "fornece soluções para resolver problemas complexos". A raposa, no volume 1, é a portadora da "idéia criativa" que vence a força bruta.',
  'Ne.EXPLORAR': 'Nota 5. O Investigador de Recursos é "extrovertido e entusiasmado", "bom negociador", "explora novas oportunidades e desenvolve contatos". Jung: apreende o movimento das coisas como possibilidades e tem "faro" para o que vai dar certo.',
  'Ne.RELACIONAR': 'Nota 4. Articulação e rede ampla — relaciona-se para conectar e persuadir, não para cuidar, o que a distingue de Fe e Fi.',
  'Ne.ORGANIZAR': 'Nota 1. Jung: "raras vezes colhem o que plantam"; não suporta rotina nem estrutura.',
  'Ne.FINALIZAR': 'Nota 1. Abandona projetos empreendendo algo novo — o oposto exato do Finalizador.',
  'Ne.ESPECIALIZAR': 'Nota 1. Amplitude e versatilidade em vez de aprofundamento em um domínio.',
  'Ne.INV_RECURSOS': 'Nota 5. Correspondência direta.',
  'Ne.PLANTA': 'Nota 4. Cria por percepção de possibilidade externa; o Planta de Belbin é introvertido, o que impede a nota 5.',
  'Ne.MONITOR': 'Nota 1. Alta tolerância a informação incompleta, oposta à prudência crítica do papel.',
  'Ne.IMPLEMENTADOR': 'Nota 1. Sensação é a função inferior.',
  'Ne.FINALIZADOR': 'Nota 1. Mesma razão.',
  'Ni.CRIAR': 'Nota 5. O Planta é "introvertido, independente e altamente criativo" e "prefere operar a uma certa distância dos outros membros" — descrição que coincide com a intuição introvertida de Jung e com a onça solitária e clarividente do livro. Belbin observa ainda que o Planta "nem sempre consegue se comunicar de forma convincente", o que corresponde à conclusão que chega sem a demonstração.',
  'Ni.ANALISAR': 'Nota 4. Analisa por leitura de padrão e de dinâmica implícita, não por verificação de fatos.',
  'Ni.ESPECIALIZAR': 'Nota 4. Aprofundamento em um domínio de longo prazo (cenários, risco estrutural).',
  'Ni.EXECUTAR': 'Nota 1. Sensação extrovertida é a função inferior; o livro registra que "o real lhe escapa".',
  'Ni.RELACIONAR': 'Nota 1. Solitária por estrutura; não constrói base de apoio.',
  'Ni.PLANTA': 'Nota 5. Correspondência direta.',
  'Ni.IMPLEMENTADOR': 'Nota 1. Indiferente ao processo e ao detalhe operacional.',
  'Ni.TRAB_EQUIPE': 'Nota 1. Presença intermitente e baixa preocupação com harmonia.'
};

/** Verificação estrutural: toda capacidade precisa ter ao menos um portador possível (≥4). */
export function verificarCoberturaPossivel(): { capacidade: Capacidade; portadores: PerfilId[] }[] {
  return CAPACIDADES.map(c => ({
    capacidade: c.id,
    portadores: (Object.keys(MATRIZ_FUNCIONAL) as PerfilId[]).filter(p => MATRIZ_FUNCIONAL[p][c.id] >= 4)
  }));
}
