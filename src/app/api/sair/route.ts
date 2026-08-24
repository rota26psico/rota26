/**
 * ENCERRAR A SESSÃO — no servidor, de propósito.
 *
 * Fazer isto no cliente custaria caro: bastava o `Nav` importar o cliente do
 * Supabase para que a biblioteca inteira (~66 kB) entrasse no bundle de TODA
 * página, inclusive a abertura e o glossário, que não precisam dela para nada.
 * Aqui o menu só precisa de um formulário.
 *
 * POST, e não GET, porque encerrar sessão altera estado: um `<img src>` de
 * terceiro em qualquer página seria suficiente para deslogar a pessoa.
 */
import { NextRequest } from 'next/server';
import { db } from '@/lib/sessao';

export const dynamic = 'force-dynamic';

export async function POST(req: NextRequest) {
  try { await db().auth.signOut(); } catch { /* sessão já inválida: seguir mesmo assim */ }
  const base = `${req.nextUrl.protocol}//${req.headers.get('host') ?? req.nextUrl.host}`;
  return Response.redirect(new URL('/', base), 303);
}
