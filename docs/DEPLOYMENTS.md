# Journal de deploiement

Chaque deploiement valide est trace ici. Le detail complet (logs, acteur, commit)
est visible dans l'onglet "Summary" du workflow GitHub Actions correspondant.

## Format

| Date UTC | Version | Environnement | Acteur | Resultat |
|----------|---------|---------------|--------|----------|

## Historique

| Date UTC | Version | Environnement | Acteur | Resultat |
|----------|---------|---------------|--------|----------|
| 2026-06-14T14:05Z | v1.0.0 | staging | CalvoTom | succes |
| 2026-06-14T14:28Z | v1.0.0 | production | CalvoTom | succes |
| 2026-06-14T14:30Z | v1.1.0 | staging | CalvoTom | succes |
| 2026-06-14T14:35Z | v1.1.0 | production | CalvoTom | echec (INC-001) |
| 2026-06-14T14:42Z | v1.0.0 | production | CalvoTom | succes (rollback) |

## Procedure de mise a jour

Le step "Journal de deploiement" dans `.github/workflows/cd.yml` ecrit automatiquement
un resume dans le Job Summary GitHub Actions (visible dans l'onglet "Summary" du run).

Pour chaque deploiement manuel ou rollback, ajouter une ligne dans ce tableau.

## Environnements

| Environnement | Declencheur | Validation requise |
|---------------|-------------|---------------------|
| staging | push sur `dev` | automatique (smoke test) |
| production | tag `v*` | manuelle (GitHub Environment "production") |

La validation manuelle de production est configuree dans :
Settings > Environments > production > Required reviewers
