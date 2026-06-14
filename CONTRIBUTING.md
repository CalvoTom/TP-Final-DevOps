# Contribution

Ce document decrit comment contribuer a ShopLite : modele de branches,
convention de commits, pull requests et review.

## Modele de branches

- `main` : versions stables uniquement, taguees en semver (v1.0.0, v1.1.0).
- `dev` : branche d'integration ou arrivent les features validees.
- `feature/*` : une branche par chantier, partant de `dev`.
- `hotfix/*` : correction urgente partant de `main`, remergee vers `main` et `dev`.

Schema:

```text
feature/*  ->  dev  ->  main (tags v*)
hotfix/*   ->  main + dev
```

## Convention de commits

Format : `type(scope optionnel): description courte a l'imperatif`.

Types utilises :

- `feat` : nouvelle fonctionnalite
- `fix` : correction de bug
- `test` : ajout ou modification de tests
- `ci` : CI/CD et automatisation
- `docs` : documentation
- `chore` : configuration, outillage, dependances

Exemples :

- `feat(docker): build multi-stage pour image API plus legere`
- `test(api): tests health et products`
- `ci: workflow CI lint, format et tests`

## Pull requests

- Toujours passer par une PR vers `dev` (pas de push direct sur `dev` ni `main`).
- Remplir le template de PR (objectif, type, verifications, risques et rollback).
- La CI doit etre verte avant le merge.
- Au moins une review d'un binome est requise.

## Versions et tags

- Taguer une version stable sur `main` avec `git tag vX.Y.Z`.
- Mettre a jour le CHANGELOG a chaque version.

## Rollback

- Annuler un changement fautif avec `git revert <hash>`.
- Pour revenir a une version d'image stable, utiliser un tag d'image versionne
  (voir `scripts/rollback.sh`).
