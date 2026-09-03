'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { VERSAO_INSTRUMENTO } from '@/data/questions';
import { MARCA, ROTULO_AMBIENTE } from '@/lib/env';
import { Marca } from './ui';

/**
 * Itens 1, 2, 30 e 31 — cabeçalho da aplicação organizacional.
 * O menu exibe apenas o que o papel do usuário pode acessar; o indicador de
 * ambiente aparece somente para o Administrador Master.
 *
 * A última entrada é a da sessão. Para quem responde — sessão anônima, papel
 * PARTICIPANTE — é "Entrar", a porta da administração. Para quem já é
 * administrador é "Sair", que encerra a sessão e devolve a pessoa à abertura.
 */
export function Nav({ papel }: { papel: 'MASTER' | 'ADMIN_SETOR' | 'PARTICIPANTE' }) {
  const p = usePathname();
  /* Item 68 — organização do menu. Cada entrada leva a uma tela que existe de
     verdade; nenhuma foi inventada para preencher a lista. */
  const itens: [string, string][] = [
    ['/questionario', 'Minha avaliação'],
    /* Quem já respondeu não precisa reabrir o percurso para reler o resultado.
       A entrada vale para todos os papéis: administrador também responde. */
    ['/meu-resultado', 'Meu resultado'],
    ['/glossario', 'Siglas']
  ];
  if (papel !== 'PARTICIPANTE') {
    itens.push(
      ['/dashboard', 'Visão geral'],
      ['/dashboard/equipe', 'Equipes'],
      ['/dashboard/comparar', 'Comparativo'],
      ['/dashboard/animais', 'Animais'],
      ['/dashboard/pessoas', 'Pessoas e resultados']
    );
  }
  if (papel === 'MASTER') {
    itens.push(
      ['/admin/metodologia', 'Metodologia'],
      ['/admin/dados?aba=exportacao', 'Exportações'],
      ['/admin/dados', 'Gestão de dados'],
      ['/admin/dados?aba=configuracoes', 'Configurações'],
      ['/admin/dados?aba=auditoria', 'Auditoria']
    );
  }

  return (
    <header className="topo">
      <div className="wrap">
        {/* Item 23 — marca corporativa à esquerda, instrumento à direita,
            separados por um filete. A marca nunca fica minúscula nem perdida. */}
        <Marca />
        <div className="divisor-marca" />
        <div style={{ minWidth: 0 }}>
          <div className="marca">
            <span>{papel === 'PARTICIPANTE' ? MARCA.selo : 'Inteligência de Equipes'}</span>
            <span aria-hidden="true">·</span>
            <span>{VERSAO_INSTRUMENTO}</span>
            {papel === 'MASTER' && <><span aria-hidden="true">·</span><span>{ROTULO_AMBIENTE}</span></>}
          </div>
          <h1 style={{ marginTop: 4 }}>{MARCA.titulo}</h1>
        </div>
        <nav className="nav">
          {itens.map(([href, label]) => (
            <Link key={href} href={href}>
              <button aria-current={p === href.split('?')[0] && !href.includes('?')}>{label}</button>
            </Link>
          ))}
          {papel === 'PARTICIPANTE'
            ? <Link href="/entrar"><button aria-current={p === '/entrar'}>Entrar</button></Link>
            : <form method="post" action="/api/sair" style={{ display: 'inline' }}>
                <button type="submit">Sair</button>
              </form>}
        </nav>
      </div>
    </header>
  );
}
