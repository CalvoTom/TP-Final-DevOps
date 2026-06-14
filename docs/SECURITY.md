# Securite

Controles de securite en place sur le projet ShopLite (bloc M).

## Controles automatises en CI

| Controle | Outil | Job CI | Comportement |
|----------|-------|--------|--------------|
| Vulnerabilites image Docker CRITICAL | Trivy | `trivy` | Bloquant (exit 1, ignore-unfixed) |
| Vulnerabilites image Docker HIGH/MEDIUM | Trivy | `trivy` | Informatif (exit 0) |
| Dependances npm vulnerables | npm audit | `security` | Informatif (exit 0) |
| Dependances npm obsoletes | npm outdated | `security` | Informatif (exit 0) |
| Secrets en dur dans le code | git grep | Manuel | Voir SECRETS.md |

## Checklist de securite

### Image Docker

- [x] Build multi-stage : seules les dependances de production dans l'image finale
- [x] Image base `node:20-alpine` : surface minimale
- [x] `USER node` : execution en non-root
- [x] Aucun secret fige dans le Dockerfile (variables injectees a l'execution)
- [x] Scan Trivy automatise en CI

### Application

- [x] Variables sensibles dans `.env` (hors git) ou GitHub Secrets
- [x] `.env` present dans `.gitignore`
- [x] Logs sanitises : query params sensibles masques (token, key, password, secret)
- [x] Aucun secret affiche dans les logs (voir middleware logger)
- [x] Validation en entree : parameterisee via `pg` (protection injection SQL)

### Infrastructure

- [x] Seul le proxy nginx expose un port vers l'hote (8080/8081)
- [x] DB et API accessibles uniquement sur le reseau interne `shoplite_net`
- [x] Healthcheck configure sur le conteneur API

### Git

- [x] Aucun fichier `.env` commite (verifiable avec `git check-ignore .env`)
- [x] Recherche de secrets commites par erreur :
  ```sh
  git grep -nE "(password|secret|token|api_key)" -- . ':!*.example' ':!docs/'
  ```

## Classement des risques

| Risque | Severite | Vecteur | Controle en place | Statut |
|--------|----------|---------|-------------------|--------|
| CVE corrigeable dans l'image de base | Critique | Remote | Trivy CI (exit 1) | Automatise |
| Secret commite dans git | Critique | Interne | git grep + .gitignore | Manuel |
| Injection SQL | Haute | Remote | Requetes parametrisees pg | Automatise |
| CVE non corrigeable image base | Haute | Remote | Trivy CI (rapport) | Informatif |
| Dependance npm vulnerables | Haute | Supply chain | npm audit CI | Informatif |
| Fuite de donnees dans les logs | Moyenne | Interne | Sanitization logger | Automatise |
| Port DB expose vers l'hote | Moyenne | Reseau | Reseau Docker isole | Controle |
| Conteneur en root | Moyenne | Local | USER node Dockerfile | Controle |
| Dependances obsoletes | Basse | Supply chain | npm outdated CI | Informatif |

## Procedure de traitement d'une vulnerabilite Trivy

1. Identifier le package concerne dans le rapport Trivy (colonne `LIBRARY`)
2. Verifier si une version corrigee existe (`FIXED VERSION`)
3. Mettre a jour l'image de base dans le Dockerfile si la CVE vient de l'OS Alpine
4. Mettre a jour la dependance npm si la CVE vient de node_modules
5. Rebuilder et relancer le scan pour confirmer la correction
6. Si aucun fix disponible : documenter ici le risque accepte avec justification
