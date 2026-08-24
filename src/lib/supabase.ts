/**
 * OS TRÊS CLIENTES SUPABASE, EM MÓDULO PRÓPRIO.
 *
 * Separado de `repo-supabase.ts` por peso, não por estética: aquele módulo
 * importa as 48 questões e o algoritmo de pontuação, e qualquer componente de
 * cliente que só precise abrir uma sessão — o `Nav`, a tela de entrada —
 * arrastaria tudo isso para o bundle de toda página. `repo-supabase.ts`
 * reexporta os três, então nada que já importava de lá precisou mudar.
 */
import { createBrowserClient, createServerClient, type CookieOptions } from '@supabase/ssr';
import { createClient } from '@supabase/supabase-js';

const URL = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const ANON = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabaseBrowser = () => createBrowserClient(URL, ANON);

export const supabaseServer = (cookies: {
  get: (n: string) => string | undefined;
  set: (n: string, v: string, o: CookieOptions) => void;
  remove: (n: string, o: CookieOptions) => void;
}) => createServerClient(URL, ANON, { cookies });

/** Cliente de serviço — apenas em rotas de servidor. Ignora RLS. */
export const supabaseAdmin = () =>
  createClient(URL, process.env.SUPABASE_SERVICE_ROLE_KEY!, { auth: { persistSession: false } });
