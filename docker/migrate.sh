#!/bin/sh
# Aplica, na ordem documentada no README, o SQL do projeto sobre o banco local.
# Roda depois do GoTrue porque 01_schema.sql referencia auth.users(id).
set -e
export PGPASSWORD=postgres
PSQL="psql -v ON_ERROR_STOP=1 -h db -U postgres -d postgres"

if $PSQL -tAc "select 1 from pg_class where relname='participantes'" | grep -q 1; then
  echo "[migrate] esquema já aplicado — nada a fazer."
else
  echo "[migrate] cola local (papéis + auth.uid/jwt)"
  $PSQL -f /sql/local/00_pre.sql

  # 04_demo_seed.sql fica DE FORA de propósito: são 96 participantes fictícios.
  for f in 01_schema 02_policies 03_seed 05_migracao_v2 06_producao 07_papeis 08_reavaliacao_v2 09_aplicacoes; do
    echo "[migrate] $f.sql"
    $PSQL -f "/sql/projeto/$f.sql"
  done

  echo "[migrate] grants do PostgREST"
  $PSQL -f /sql/local/99_pos.sql
fi

# ── Administrador MASTER ────────────────────────────────────────────────────
# Depende de um usuário no GoTrue, que não pode ser criado por SQL. É o mesmo
# "único passo manual obrigatório" do README, feito aqui automaticamente.
UID_MASTER=$($PSQL -tAc "select id from auth.users where email='$MASTER_EMAIL'" | tr -d ' ')

if [ -z "$UID_MASTER" ]; then
  echo "[migrate] criando usuário MASTER $MASTER_EMAIL no GoTrue"
  wget -q -O /tmp/u.json --header="Content-Type: application/json" \
       --header="Authorization: Bearer $SERVICE_KEY" \
       --header="apikey: $SERVICE_KEY" \
       --post-data="{\"email\":\"$MASTER_EMAIL\",\"password\":\"$MASTER_PASSWORD\",\"email_confirm\":true}" \
       http://auth:9999/admin/users
  UID_MASTER=$($PSQL -tAc "select id from auth.users where email='$MASTER_EMAIL'" | tr -d ' ')
fi

if [ -z "$UID_MASTER" ]; then
  echo "[migrate] ERRO: não consegui criar o usuário MASTER." >&2
  exit 1
fi

$PSQL -c "insert into administradores (user_id, papel, nome)
          values ('$UID_MASTER', 'MASTER', 'Administrador Local')
          on conflict (user_id) do update set papel='MASTER';"

echo "[migrate] pronto. MASTER = $MASTER_EMAIL (uid $UID_MASTER)"
