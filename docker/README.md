# Stack local do ROTA26 (Docker)

Infraestrutura **de desenvolvimento**. Sobe o equivalente auto-hospedado do
Supabase que a aplicação espera, aplica as migrações do projeto na ordem do
README principal e deixa o Next.js rodando.

```bash
cd docker
docker compose up -d          # primeira vez: ~1 min (migrações + usuário MASTER)
docker compose logs -f app
```

| Endereço | O quê |
|---|---|
| http://localhost:3000 | aplicação Next.js |
| http://localhost:3000/api/dev-login | entra como MASTER (ver abaixo) |
| http://localhost:8000 | gateway Supabase (`/auth/v1`, `/rest/v1`) |
| localhost:54322 | PostgreSQL (`postgres` / `postgres`) |

## Serviços

| Serviço | Papel |
|---|---|
| `db` | PostgreSQL 16 — as views usam `security_invoker`, que exige 15+ |
| `auth` | GoTrue — cria o schema `auth` e emite os JWT da sessão |
| `rest` | PostgREST — é com ele que o `supabase-js` fala, com o RLS valendo |
| `gateway` | nginx — junta `/auth/v1` e `/rest/v1` sob uma origem só, como o Kong |
| `migrate` | aplica `01, 02, 03, 05, 06, 07, 08, 09` e cria o administrador MASTER |
| `app` | `next dev` |

`04_demo_seed.sql` **não** é aplicado: o banco começa vazio, como em produção.

### Por que `gateway` e `app` compartilham a rede

`NEXT_PUBLIC_SUPABASE_URL` é uma variável só, usada tanto pelo navegador quanto
pelo servidor Next. Para `http://localhost:8000` significar a mesma coisa nos
dois lados, o `app` roda com `network_mode: service:gateway`. O dono do
namespace é o nginx de propósito: reiniciar o `app` é rotina, e reiniciar o dono
derrubaria a rede do outro container.

Por isso, ao mexer em `nginx.conf`, use `docker compose exec gateway nginx -s
reload` em vez de `restart` — um `restart` do gateway exige reiniciar o `app`
logo em seguida.

## Login

A aplicação **não tem tela de login** — ela só lê a sessão (`auth.getUser()`), e
todas as políticas de RLS são `to authenticated`. Sem sessão, nem a lista de
setores do questionário carrega.

Enquanto não existir uma tela de autenticação no projeto, use a rota de
desenvolvimento, que é montada **apenas dentro do container** (o arquivo vive em
`docker/dev-login/route.ts`, nunca em `src/`):

```
http://localhost:3000/api/dev-login                    entra como o MASTER
http://localhost:3000/api/dev-login?email=..&senha=..  entra como outro usuário
http://localhost:3000/api/dev-login?sair=1             encerra a sessão
```

Credenciais do MASTER em `docker/.env` (`MASTER_EMAIL` / `MASTER_PASSWORD`).

## Operação

```bash
docker compose restart app                  # o gateway continua de pé
docker compose exec gateway nginx -s reload # recarrega o nginx SEM restart
docker compose down             # para tudo, preserva o banco
docker compose down -v          # apaga o banco e refaz as migrações no próximo up
docker compose exec db psql -U postgres -d postgres
```

## Avisos

- `docker/.env` tem `JWT_SECRET`, chaves e senha do MASTER **fixas e locais**.
  Servem só para esta máquina; não reutilize em nenhum outro ambiente.
- `GOTRUE_MAILER_AUTOCONFIRM=true` — e-mail é confirmado sem envio.
- `NEXT_PUBLIC_APP_MODE=development` aqui. A aplicação real usa `production`,
  que é o padrão quando a variável está ausente.
