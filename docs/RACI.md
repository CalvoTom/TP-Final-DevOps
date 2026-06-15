# Matrice RACI

Repartition des responsabilites sur le projet ShopLite.

## Roles

| Role | Description |
|------|-------------|
| **Dev** | Developpeur : ecriture du code applicatif et des tests |
| **Ops** | Ingenieur DevOps : pipeline CI/CD, infra Docker, scripts |
| **PO** | Product Owner (encadrant) : validation fonctionnelle et acceptance |

Legende : **R** Responsible, **A** Accountable, **C** Consulted, **I** Informed

## Matrice

| Activite | Dev | Ops | PO |
|----------|-----|-----|----|
| Ecriture des features (API, routes) | R/A | C | I |
| Ecriture des tests unitaires | R/A | C | I |
| Tests d'integration PostgreSQL | R | A | I |
| Configuration Dockerfile multi-stage | C | R/A | I |
| Configuration Docker Compose | C | R/A | I |
| Pipeline CI (lint, tests, trivy) | C | R/A | I |
| Pipeline CD (staging, production) | C | R/A | I |
| Review de code (PR) | R/A | R/A | I |
| Deploiement staging | I | R/A | I |
| Approbation deploiement production | C | R | A |
| Gestion des incidents (rollback) | C | R/A | I |
| Sauvegarde et restauration (backup) | I | R/A | C |
| Gestion des secrets (rotation) | C | R/A | I |
| Documentation technique | R/A | R/A | C |
| Rapport post-incident | R | A | C |
| Definition des criteres de done | C | C | R/A |

## Decisions cles

| Decision | Responsable (A) | Executants (R) |
|----------|-----------------|----------------|
| Merger une PR vers `dev` | Dev + Ops | Dev + Ops |
| Creer un tag de version | Ops | Ops |
| Valider un deploiement production | PO | Ops |
| Declencher un rollback | Ops | Ops |
| Accepter un risque securite sans correctif | PO | Ops |
