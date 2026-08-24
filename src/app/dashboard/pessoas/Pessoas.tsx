'use client';
import { useState } from 'react';
import { TelaPessoas, TelaLeituraExecutivaIndividual } from '@/components/views-gestao';
import { supabaseBrowser, recalcular } from '@/lib/repo-supabase';
import type { ResultadoIndividual } from '@/lib/scoring';

type P = { nome: string; matricula: string; setor: string; perfil: string; secundario: string; data: string; status: string; demo?: boolean; ehAdministrador?: boolean; avaliacaoId: string };

export function Pessoas({ pessoas }: { pessoas: P[] }) {
  const [aberto, setAberto] = useState<{ p: P; r: ResultadoIndividual } | null>(null);
  const db = supabaseBrowser();
  const abrir = async (matricula: string) => {
    const p = pessoas.find(x => x.matricula === matricula)!;
    // Recalcula a partir das respostas brutas — prova de reprodutibilidade.
    setAberto({ p, r: await recalcular(db, p.avaliacaoId) });
  };
  if (aberto) return (
    <>
      <button className="btn btn-sec" style={{ marginBottom: 14 }} onClick={() => setAberto(null)}>← Voltar</button>
      <TelaLeituraExecutivaIndividual r={aberto.r}
        dados={{ nome: aberto.p.nome, matricula: aberto.p.matricula, setor: aberto.p.setor, data: aberto.p.data }} />
    </>
  );
  return <TelaPessoas pessoas={pessoas} onAbrir={abrir} />;
}
