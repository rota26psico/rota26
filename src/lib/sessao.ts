import { cookies } from 'next/headers';
import { supabaseServer } from './repo-supabase';

/** Cliente Supabase autenticado no servidor, com os cookies da sessão. */
export function db() {
  const c = cookies();
  return supabaseServer({
    get: (n) => c.get(n)?.value,
    set: (n, v, o) => { try { c.set({ name: n, value: v, ...o }); } catch {} },
    remove: (n, o) => { try { c.set({ name: n, value: '', ...o }); } catch {} }
  });
}

export type Papel = 'MASTER' | 'ADMIN_SETOR' | 'PARTICIPANTE';

/**
 * O filtro por `user_id` NÃO é redundante com o RLS. A policy `admins_leitura`
 * devolve ao MASTER **todas** as linhas de `administradores` (`eh_master()`),
 * então sem ele `maybeSingle()` recebe mais de uma linha assim que existe um
 * segundo administrador, erra, devolve `data` nulo — e o MASTER é rebaixado a
 * participante, perdendo todos os dashboards. Ou seja: cadastrar o primeiro
 * ADMIN_SETOR trancava o Master para fora.
 */
export async function papel(): Promise<Papel> {
  const s = db();
  const { data: sessao } = await s.auth.getUser();
  const uid = sessao.user?.id;
  if (!uid) return 'PARTICIPANTE';
  const { data } = await s.from('administradores').select('papel').eq('user_id', uid).maybeSingle();
  return (data?.papel as Papel | undefined) ?? 'PARTICIPANTE';
}

/* `exigirAdmin()` foi removido: lançar devolvia HTTP 500 para quem apenas não é
   administrador — e, com a aplicação publicada, isso é uso normal. As páginas
   comparam o papel e devolvem <AcessoRestrito />, com 200. */
