#!/bin/sh
# Test de restauration d'un backup PostgreSQL dans une base temporaire.
# Usage : sh scripts/restore-test.sh [fichier_backup.sql]
#   Sans argument : utilise le backup le plus recent dans BACKUP_DIR.
# Variables : BACKUP_DIR (defaut ./backups), TEST_DB (defaut shoplite_restore_test),
#             DATABASE_URL ou POSTGRES_HOST/PORT/USER/PASSWORD
set -eu

BACKUP_DIR="${BACKUP_DIR:-./backups}"
TEST_DB="${TEST_DB:-shoplite_restore_test}"

# Choisir le fichier : argument ou derniere sauvegarde
if [ -n "${1:-}" ]; then
  BACKUP_FILE="$1"
else
  BACKUP_FILE=$(ls -t "$BACKUP_DIR"/backup-*.sql 2>/dev/null | head -1)
  if [ -z "$BACKUP_FILE" ]; then
    echo "Erreur : aucun backup trouve dans $BACKUP_DIR"
    exit 1
  fi
fi

echo "Test de restauration : $BACKUP_FILE"

# Extraire les parametres de connexion
if [ -n "${DATABASE_URL:-}" ]; then
  _url="${DATABASE_URL#postgres://}"
  DB_USER="${_url%%:*}"
  _rest="${_url#*:}"
  export PGPASSWORD="${_rest%%@*}"
  _rest="${_rest#*@}"
  DB_HOST="${_rest%%:*}"
  _rest="${_rest#*:}"
  DB_PORT="${_rest%%/*}"
else
  DB_HOST="${POSTGRES_HOST:-localhost}"
  DB_PORT="${POSTGRES_PORT:-5432}"
  DB_USER="${POSTGRES_USER:-shoplite}"
  export PGPASSWORD="${POSTGRES_PASSWORD:-shoplite_password}"
fi

psql_run() {
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$@"
}

# Creer la base temporaire
psql_run -d postgres -c "DROP DATABASE IF EXISTS $TEST_DB;" 2>/dev/null || true
psql_run -d postgres -c "CREATE DATABASE $TEST_DB;"

# Restaurer le backup
psql_run -d "$TEST_DB" -f "$BACKUP_FILE" -q

# Verifier l'integrite minimale
COUNT=$(psql_run -d "$TEST_DB" -t -A -c "SELECT COUNT(*) FROM products;")
echo "Verification : $COUNT produit(s) dans la base restauree"
if [ "$COUNT" -eq 0 ]; then
  echo "Avertissement : aucun produit trouve apres restauration"
fi

# Nettoyer la base temporaire
psql_run -d postgres -c "DROP DATABASE $TEST_DB;"

echo "Test de restauration reussi"
