/**
 * LOGIN DE DESENVOLVIMENTO — NÃO FAZ PARTE DA APLICAÇÃO.
 * ---------------------------------------------------------------------------
 * Este arquivo existe apenas dentro do container (montado pelo compose em
 * /app/src/app/api/dev-login/route.ts) e nunca no diretório do projeto.
 *
 * Motivo: a aplicação lê a sessão (`auth.getUser()`), mas não tem nenhuma tela
 * de login própria — e todas as políticas de RLS são `to authenticated`. Sem
 * uma sessão, nem a lista de setores do questionário carrega. Esta rota usa o
 * MESMO cliente da aplicação (`db()`), de modo que o cookie de sessão é escrito
 * pelo próprio @supabase/ssr, no formato que ele espera.
 *
 *   /api/dev-login                      → entra como o MASTER do compose
 *   /api/dev-login?email=..&senha=..    → entra como outro usuário
 *   /api/dev-login?sair=1               → encerra a sessão
 */
import { NextRequest } from 'next/server';
import { db } from '@/lib/sessao';

export const dynamic = 'force-dynamic';

export async function GET(req: NextRequest) {
  const s = db();
  const q = req.nextUrl.searchParams;
  // O origin de req.nextUrl usa o hostname de bind (0.0.0.0). Para o navegador
  // seguir o redirect, o destino tem de sair do Host que ele mesmo enviou.
  const base = `http://${req.headers.get('host') ?? 'localhost:3000'}`;
  const destino = new URL(q.get('destino') ?? '/', base);

  if (q.get('sair')) {
    await s.auth.signOut();
    return Response.redirect(destino, 303);
  }

  const email = q.get('email') ?? process.env.MASTER_EMAIL ?? '';
  const password = q.get('senha') ?? process.env.MASTER_PASSWORD ?? '';

  const { data, error } = await s.auth.signInWithPassword({ email, password });
  if (error) {
    return Response.json({ erro: error.message, email }, { status: 401 });
  }
  return Response.redirect(destino, 303);
}
