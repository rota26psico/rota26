'use client';
/**
 * O painel nominal virou uma listagem pura: o detalhe de cada pessoa mora em
 * `/dashboard/pessoas/[avaliacaoId]`, com endereço próprio.
 *
 * Antes o detalhe era estado local — abrir uma pessoa não mudava a URL, então
 * não dava para recarregar, abrir em outra aba, mandar o link a quem tem
 * permissão nem imprimir só aquela pessoa. E o recálculo acontecia por `fetch`
 * no cliente; agora acontece no servidor, na própria página, que é onde o resto
 * do projeto já calculava.
 */
import { TelaPessoas } from '@/components/views-gestao';

type P = {
  nome: string; matricula: string; setor: string; perfil: string; secundario: string;
  data: string; status: string; demo?: boolean; ehAdministrador?: boolean;
  avaliacaoId: string; aplicacao?: number;
};

export function Pessoas({ pessoas }: { pessoas: P[] }) {
  return <TelaPessoas pessoas={pessoas} />;
}
