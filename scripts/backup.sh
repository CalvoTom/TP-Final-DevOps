#!/bin/sh
# Sauvegarde PostgreSQL avec retention automatique.
# Usage : sh scripts/backup.sh
# Variables : BACKUP_DIR (defaut ./backups), RETENTION_DAYS (defaut 7),
#             DATABASE_URL ou POSTGRES_HOST/PORT/USER/PASSWORD/DB
set -eu

BACKUP_DIR="${BACKUP_DIR:-./backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

if [ -n "${DATABASE_URL:-}" ]; then
  pg_dump --dbname="$DATABASE_URL" -f "$BACKUP_FILE"
else
  export PGPASSWORD="${POSTGRES_PASSWORD:-shoplite_password}"
  pg_dump \
    -h "${POSTGRES_HOST:-localhost}" \
    -p "${POSTGRES_PORT:-5432}" \
    -U "${POSTGRES_USER:-shoplite}" \
    -d "${POSTGRES_DB:-shoplite}" \
    -f "$BACKUP_FILE"
fi

echo "Backup cree : $BACKUP_FILE ($(du -h "$BACKUP_FILE" | cut -f1))"

find "$BACKUP_DIR" -name "backup-*.sql" -mtime "+$RETENTION_DAYS" -delete
echo "Retention $RETENTION_DAYS j appliquee"
