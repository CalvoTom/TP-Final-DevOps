# Architecture

Vue d'ensemble de l'architecture du projet ShopLite.

## Infrastructure (Docker Compose)

```mermaid
graph TD
    Client["Navigateur / Client"]
    Proxy["nginx:1.27-alpine\nproxy inverse\nport 8080"]
    Frontend["nginx\nfrontend statique"]
    API["Node.js 20\nAPI Express\nport 3000"]
    DB["PostgreSQL 16\nport 5432"]

    Client -->|HTTP :8080| Proxy
    Proxy -->|/api/*| API
    Proxy -->|/*| Frontend
    API -->|SQL| DB
```

Tous les services communiquent sur le reseau Docker interne `shoplite_net`.
Seul le proxy expose un port vers l'hote.

## Flux de deploiement CI/CD

```mermaid
flowchart LR
    Push["git push\nfeature/*"]
    PR["Pull Request\nvers dev"]
    CI["CI\nquality / test\nsecurity / trivy\nbuild"]
    Dev["merge\nsur dev"]
    CDStaging["CD staging\ndocker compose\nsmoke test"]
    Tag["git tag v*\nsur main"]
    Gate["Approbation\nmanuelle\nGitHub Env"]
    CDProd["CD production\ndocker compose\nsmoke test"]

    Push --> PR
    PR --> CI
    CI -->|"CI verte +\nreview binome"| Dev
    Dev --> CDStaging
    Dev -->|"apres validation"| Tag
    Tag --> Gate
    Gate --> CDProd
```

## Strategie de branches

```mermaid
gitGraph
    commit id: "init"
    branch dev
    checkout dev
    branch feature/example
    checkout feature/example
    commit id: "feat: ..."
    checkout dev
    merge feature/example id: "merge PR"
    checkout main
    merge dev id: "v1.0.0" tag: "v1.0.0"
    checkout dev
    branch hotfix/fix
    checkout hotfix/fix
    commit id: "fix: revert"
    checkout main
    merge hotfix/fix id: "v1.0.1" tag: "v1.0.1"
    checkout dev
    merge main
```

## Couches applicatives

| Couche | Technologie | Role |
|--------|-------------|------|
| Proxy | nginx 1.27 Alpine | Reverse proxy, routage /api/* et /* |
| Frontend | HTML/CSS/JS + nginx | Interface utilisateur statique |
| API | Node.js 20 + Express | Logique metier, endpoints REST |
| Base de donnees | PostgreSQL 16 Alpine | Persistance des donnees |
| Observabilite | Logs JSON (stdout) | `level`, `request_id`, `duration_ms` |

## Variables d'environnement cles

| Variable | Valeur par defaut | Role |
|----------|-------------------|------|
| `DATABASE_URL` | `postgres://...@db:5432/shoplite` | Connexion PostgreSQL |
| `API_PORT` | `3000` | Port interne de l'API |
| `LOG_LEVEL` | `info` | Niveau de log (debug/info/warn/error) |
| `APP_VERSION` | `starter` | Version affichee dans /health |
| `HTTP_PORT` | `8080` | Port expose par le proxy |
