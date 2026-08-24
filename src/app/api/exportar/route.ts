import { NextRequest } from 'next/server';
import { db, papel } from '@/lib/sessao';
import { carregarParaExport } from '@/lib/repo-supabase';
import { gerarExcel, NOME_ARQUIVO, type TipoExport } from '@/lib/excel';

export const dynamic = 'force-dynamic';

/**
 * Gera o .xlsx no servidor a partir da MESMA view que alimenta os dashboards
 * (item 74). O RLS continua valendo: um ADMIN_SETOR só exporta o próprio setor.
 *
 * Item 25 — por padrão a exportação traz SOMENTE dados reais. O filtro está na
 * definição da view `vw_resultados`, no banco, e não em uma cláusula desta
 * rota: não há caminho por onde um registro de demonstração entre em uma
 * planilha comum.
 *
 * `tipo=demo` é a única exceção: existe para o backup do item 8, é restrito ao
 * Master e deixa de retornar qualquer linha assim que a limpeza é executada.
 *
 * Item 30 — o autor registrado é o administrador autenticado de verdade.
 */
export async function GET(req: NextRequest) {
  const p = await papel();
  if (p === 'PARTICIPANTE') return new Response('Acesso restrito.', { status: 403 });

  const bruto = req.nextUrl.searchParams.get('tipo') ?? 'completo';
  const setor = req.nextUrl.searchParams.get('setor') ?? undefined;

  const ehDemo = bruto === 'demo';
  if (ehDemo && p !== 'MASTER') {
    return new Response('A exportação dos dados de demonstração é exclusiva do Administrador Master.', { status: 403 });
  }
  const tipo = (ehDemo ? 'completo' : bruto) as TipoExport;
  if (!(tipo in NOME_ARQUIVO)) return new Response('Tipo de exportação inválido.', { status: 400 });

  const s = db() as any;
  const regs = await carregarParaExport(s, tipo === 'setor' ? setor : undefined, ehDemo ? 'demo' : 'reais');
  const { data: user } = await s.auth.getUser();
  const autor = user?.user?.email ?? 'administrador autenticado';

  if (ehDemo && regs.length === 0) {
    return new Response('Não há registros de demonstração no banco.', { status: 404 });
  }

  const buf = await gerarExcel(tipo, regs, {
    setor, geradoPor: autor, geradoEm: new Date().toISOString()
  });

  const nome = ehDemo
    ? 'backup-dados-demonstracao.xlsx'
    : `${NOME_ARQUIVO[tipo]}${setor && tipo === 'setor' ? '-' + setor.replace(/\s+/g, '_') : ''}.xlsx`;
  return new Response(buf, {
    headers: {
      'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'Content-Disposition': `attachment; filename="${nome}"`,
      'X-Nome-Arquivo': nome,
      'X-Registros': String(regs.length)
    }
  });
}
