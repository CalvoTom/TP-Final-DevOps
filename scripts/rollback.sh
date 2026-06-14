#!/bin/sh
# Rollback de l'API vers une image stable versionnee.
# Usage : sh scripts/rollback.sh <version>
# Exemple : sh scripts/rollback.sh v1.0.0
# Prerequis : l'image shoplite-api:<version> doit exister localement
#             (construite avec sh scripts/build-images.sh <version>)
set -eu

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  echo "Usage : sh scripts/rollback.sh <version>"
  echo "Exemple : sh scripts/rollback.sh v1.0.0"
  exit 1
fi

echo "=== Rollback vers la version : $VERSION ==="

# Verifier que l'image cible existe localement
if ! docker image inspect "shoplite-api:$VERSION" >/dev/null 2>&1; then
  echo "Erreur : image shoplite-api:$VERSION introuvable en local"
  echo "Reconstruire avec : sh scripts/build-images.sh $VERSION"
  exit 1
fi

# Re-pointer le tag utilise par compose vers la version stable
docker tag "shoplite-api:$VERSION" shoplite-api:latest
echo "shoplite-api:latest -> $VERSION"

# Recreer uniquement le conteneur API sans rebuild depuis les sources
docker compose up -d --no-build --force-recreate api
echo "Conteneur API recrée depuis l'image $VERSION"

# Attendre que l'API soit disponible (max 60s)
echo "Attente de l'API..."
i=0
while [ $i -lt 20 ]; do
  if curl -fsS "http://localhost:${HTTP_PORT:-8080}/api/health" >/dev/null 2>&1; then
    echo "API disponible"
    break
  fi
  i=$((i + 1))
  if [ $i -eq 20 ]; then
    echo "Erreur : API non disponible apres 60s"
    exit 1
  fi
  sleep 3
done

# Smoke test de validation
BASE_URL="http://localhost:${HTTP_PORT:-8080}" sh scripts/smoke-test.sh

echo "=== Rollback $VERSION effectue et valide ==="
