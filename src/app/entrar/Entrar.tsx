'use client';
/**
 * ENTRADA DA ADMINISTRAÇÃO.
 *
 * Quem responde ao instrumento não passa por aqui — a sessão dele é anônima e
 * abre sozinha em /questionario. Esta tela existe para as contas que estão em
 * `administradores`: é o login com e-mail e senha do Supabase Auth que o
 * MANUAL_ADMINISTRADOR sempre descreveu.
 *
 * Não existe cadastro nem recuperação de senha aqui de propósito: contas de
 * administração são criadas no painel do Supabase e inseridas em
 * `administradores` por SQL (GUIA_TECNICO_TI, 3.5). Uma tela de auto-cadastro
 * seria uma porta para o painel de gestão.
 */
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { supabaseBrowser } from '@/lib/supabase';
import { Card, Aviso } from '@/components/ui';

export function Entrar() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [erro, setErro] = useState<string | null>(null);
  const [ocupado, setOcupado] = useState(false);

  const valido = email.trim().length > 3 && senha.length > 0;

  const entrar = async () => {
    setErro(null); setOcupado(true);
    try {
      const db = supabaseBrowser();
      /* Uma sessão anônima em curso é substituída por esta — não é preciso
         encerrar antes. */
      const { error } = await db.auth.signInWithPassword({ email: email.trim(), password: senha });
      // Mensagem única: dizer "e-mail não existe" entregaria quem é administrador.
      if (error) throw new Error('E-mail ou senha incorretos.');
      router.replace('/dashboard');
      router.refresh();
    } catch (e: any) {
      setErro(e?.message ?? String(e));
      setOcupado(false);
    }
  };

  return (
    <div style={{ maxWidth: 520, margin: '0 auto' }}>
      <Card titulo="Entrar" sub="Acesso à administração do instrumento.">
        {erro && <Aviso tipo="limite" titulo="Não foi possível entrar">{erro}</Aviso>}

        <div className="campo"><label htmlFor="e-email">E-mail</label>
          <input id="e-email" name="email" type="email" autoComplete="username"
            value={email} aria-invalid={!!erro} aria-describedby={erro ? 'e-erro' : undefined}
            onChange={x => setEmail(x.target.value)}
            onKeyDown={x => { if (x.key === 'Enter' && valido && !ocupado) entrar(); }}
            placeholder="seu.email@organizacao" /></div>

        <div className="campo"><label htmlFor="e-senha">Senha</label>
          <input id="e-senha" name="senha" type="password" autoComplete="current-password"
            value={senha} aria-invalid={!!erro} aria-describedby={erro ? 'e-erro' : undefined}
            onChange={x => setSenha(x.target.value)}
            onKeyDown={x => { if (x.key === 'Enter' && valido && !ocupado) entrar(); }} /></div>

        {erro && <p id="e-erro" role="alert" style={{ color: '#A8503C', fontSize: 13, margin: '0 0 12px' }}>{erro}</p>}

        <button className="btn btn-marca" disabled={!valido || ocupado} onClick={entrar}>
          {ocupado ? 'Entrando…' : 'Entrar'}
        </button>

        <Aviso tipo="info" titulo="Você não precisa entrar para responder">
          O percurso das 48 situações é aberto em <b>Minha avaliação</b>, sem login.
          Esta tela é apenas para quem administra o instrumento.
        </Aviso>
      </Card>
    </div>
  );
}
