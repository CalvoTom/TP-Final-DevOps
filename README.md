# ShopLite

[![CI](https://github.com/CalvoTom/TP-Final-DevOps/actions/workflows/ci.yml/badge.svg)](https://github.com/CalvoTom/TP-Final-DevOps/actions/workflows/ci.yml)
[![CD](https://github.com/CalvoTom/TP-Final-DevOps/actions/workflows/cd.yml/badge.svg)](https://github.com/CalvoTom/TP-Final-DevOps/actions/workflows/cd.yml)

API e-commerce minimaliste en Node.js / Express avec PostgreSQL, deployee via
Docker Compose et GitHub Actions.

## Demarrage rapide

### Prerequis

- Docker >= 24 et Docker Compose v2
- Node.js >= 18 (pour le developpement local uniquement)

### Environnement de developpement

```sh
cp .env.example .env          # adapter les valeurs si besoin
docker compose up -d --build
```

Verifier que la stack est operationnelle :

```sh
curl http://localhost:8080/api/health
curl http://localhost:8080/api/products
```

Frontend : [http://localhost:8080](http://localhost:8080)

### Environnement de staging

```sh
docker compose -f docker-compose.yml -f docker-compose.staging.yml up -d --build
```

Stack disponible sur le port `8081`.

### Arreter la stack

```sh
docker compose down          # conserve les donnees (volume pgdata)
docker compose down -v       # supprime egalement le volume
```

## Endpoints API

| Methode | Route | Description |
|---------|-------|-------------|
| GET | `/` | Informations et version de l'API |
| GET | `/api/health` | Liveness probe (etat DB inclus) |
| GET | `/api/ready` | Readiness probe |
| GET | `/api/products` | Liste des produits |

## Tests et qualite

```sh
cd api
npm ci
npm run lint          # ESLint
npm run format:check  # Prettier
npm test              # Jest (couverture >= 80 %)
```

## CI/CD

Le pipeline GitHub Actions comporte deux workflows :

**CI** (sur chaque push et PR) :
- `quality` : lint ESLint + format Prettier
- `test` : tests Jest sur Node 18 et 20 avec PostgreSQL reel
- `security` : npm audit + npm outdated
- `trivy` : scan des vulnerabilites de l'image Docker (CRITICAL bloquant)
- `build` : build des images Docker

**CD** (sur push `dev` et tag `v*`) :
- `deploy-staging` : stack staging + smoke test automatique
- `deploy-production` : deploiement sur tag `v*`, approbation manuelle requise (GitHub Environment)

## Scripts operationnels

| Script | Usage |
|--------|-------|
| `sh scripts/build-images.sh <version>` | Construire et taguer les images |
| `sh scripts/backup.sh` | Sauvegarde pg_dump avec retention 7 jours |
| `sh scripts/restore-test.sh [fichier]` | Test de restauration en base temporaire |
| `sh scripts/rollback.sh <version>` | Rollback vers une image stable versionnee |
| `sh scripts/smoke-test.sh` | Smoke test `/health` et `/products` |

## Documentation

| Document | Contenu |
|----------|---------|
| [CONTRIBUTING.md](CONTRIBUTING.md) | Branches, commits conventionnels, PR |
| [CHANGELOG.md](CHANGELOG.md) | Historique des versions |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Schemas d'architecture (Mermaid) |
| [docs/DEPLOYMENTS.md](docs/DEPLOYMENTS.md) | Journal des deploiements |
| [docs/INCIDENT.md](docs/INCIDENT.md) | Rapport d'incident INC-001 |
| [docs/SECURITY.md](docs/SECURITY.md) | Checklist et classement des risques |
| [docs/SECRETS.md](docs/SECRETS.md) | Hygiene des secrets et configuration |
| [docs/REGISTRY.md](docs/REGISTRY.md) | Images Docker, tags et registry |
| [docs/DORA.md](docs/DORA.md) | Indicateurs DORA |
| [docs/RACI.md](docs/RACI.md) | Matrice de responsabilites |
