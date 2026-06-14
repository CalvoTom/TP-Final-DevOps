# Changelog

Toutes les modifications notables de ShopLite sont documentees ici.
Format base sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/).

## [1.1.0] - 2026-06-14 - ANNULE (revert INC-001)

Cette version a ete annulee immediatement apres deploiement suite a l'incident
INC-001 (endpoint /products en erreur 500). Voir [docs/INCIDENT.md](docs/INCIDENT.md).

### Tente

- Ajout de la colonne `stock` dans la table `products`

### Reverte

- Requete SQL referencant une colonne inexistante en production

## [1.0.0] - 2026-06-14

Premiere version stable du projet ShopLite.

### Ajoute

- API Node.js / Express avec endpoints `/health`, `/ready`, `/products`
- `request_id` par requete, niveaux de logs `LOG_LEVEL`, sanitization
- Build Docker multi-stage avec image `node:20-alpine` et `USER node`
- Docker Compose dev + override staging (logs, resource limits, ports)
- Pipeline CI : lint, tests Node 18/20, audit npm, scan Trivy, build Docker
- Pipeline CD : staging automatique, production sur tag avec approbation manuelle
- Tests Jest couverture >= 80 % (unit + integration PostgreSQL)
- Scripts : `backup.sh`, `restore-test.sh`, `rollback.sh`, `build-images.sh`
- Migration non destructive `database/migration-v1.1.0.sql`
- Documentation : ARCHITECTURE, SECURITY, INCIDENT, DEPLOYMENTS, DORA, RACI

## [0.1.0] - 2026-06-01

- Projet starter ShopLite (socle applicatif initial).
