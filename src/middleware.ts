/**
 * RENOVAÇÃO DA SESSÃO — pré-requisito dos Server Components.
 * ---------------------------------------------------------------------------
 * Todas as páginas de dashboard são Server Components e leem a sessão por
 * `src/lib/sessao.ts`. Um Server Component do Next não pode gravar cookie: o
 * `set`/`remove` de lá está dentro de `try/catch` justamente porque a gravação
 * lança. Sem este middleware, o token de acesso expira (1 h) e não há onde
 * escrever o token renovado — a pessoa que deixou a aba aberta volta e encontra
 * "acesso restrito" sem ter feito nada de errado.
 *
 * O middleware roda ANTES da página, onde a resposta ainda é editável: chama
 * `auth.getUser()`, que dispara a renovação quando necessário, e devolve a
 * resposta já com os cookies atualizados. Vale para as duas sessões — a
 * anônima de quem responde e a nominal de quem administra.
 */
import { NextResponse, type NextRequest } from 'next/server';
import { createServerClient, type CookieOptions } from '@supabase/ssr';

export async function middleware(req: NextRequest) {
  let resposta = NextResponse.next({ request: { headers: req.headers } });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => req.cookies.getAll(),
        setAll: (cookies: { name: string; value: string; options?: CookieOptions }[]) => {
          for (const { name, value } of cookies) req.cookies.set(name, value);
          resposta = NextResponse.next({ request: { headers: req.headers } });
          for (const { name, value, options } of cookies) resposta.cookies.set(name, value, options);
        }
      }
    }
  );

  // Um erro aqui NÃO pode derrubar a página: banco fora do ar precisa chegar à
  // tela como <ErroConsulta />, e não como um 500 do middleware (item 24).
  try { await supabase.auth.getUser(); } catch { /* segue sem renovar */ }

  return resposta;
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico)$).*)']
};
