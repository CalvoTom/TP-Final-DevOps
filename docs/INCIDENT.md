# Rapport d'incident

## INC-001 : /api/products en erreur 500 apres deploiement v1.1.0

**Date** : 2026-06-14  
**Duree** : ~25 minutes (14:35 - 15:00)  
**Severite** : P1 - endpoint produit indisponible en production  
**Statut** : Resolu

---

## Contexte

Un commit mergé sur `dev` introduisait une reference a une colonne inexistante dans la
requete SQL de `/api/products`. Les tests unitaires passaient (mock DB), mais la
requete echouait sur la base de production reelle. Le tag `v1.1.0` a ete deploye et a
casse l'endpoint immediatement.

---

## Chronologie

| Heure | Evenement |
|-------|-----------|
| 14:00 | Merge de `feature/sql-broken-query` sur `dev` |
| 14:05 | CD deploie automatiquement sur staging (smoke test OK car DB staging vide) |
| 14:28 | Tag `v1.1.0` cree, deploiement production declenche |
| 14:35 | `/api/products` retourne 500 en production, `/api/health` reste 200 |
| 14:37 | Incident detecte via logs, rollback lance |
| 14:42 | Service restaure sur `v1.0.0`, smoke test OK |
| 15:00 | `git revert` du commit fautif, branche `hotfix/fix-products-query` ouverte |
| 15:30 | PR hotfix mergee sur `main` puis `dev` |

---

## Detection

Logs JSON sur le serveur de production :

```json
{"level":"error","message":"column \"stock\" does not exist","request_id":"a3f1...","timestamp":"2026-06-14T14:35:02Z"}
{"level":"info","method":"GET","path":"/products","status":500,"request_id":"a3f1...","timestamp":"2026-06-14T14:35:02Z"}
```

`/api/health` continuait de repondre 200 (la DB etait accessible), masquant l'alerte
de readiness. Seul `/api/products` echouait.

---

## Mitigation : rollback image

```sh
# S'assurer que l'image v1.0.0 existe localement
docker images | grep shoplite-api

# Lancer le rollback
sh scripts/rollback.sh v1.0.0
```

Le script :
1. Verifie la presence locale de `shoplite-api:v1.0.0`
2. Re-tague l'image en `shoplite-api:latest`
3. Recrée le conteneur sans rebuild (`docker compose up --no-build --force-recreate api`)
4. Attend la disponibilite de `/api/health`
5. Execute le smoke test (`/api/health` + `/api/products`)

---

## Resolution : git revert + hotfix

```sh
# Identifier le commit fautif
git log --oneline | head -5

# Creer la branche hotfix depuis main
git checkout main
git checkout -b hotfix/fix-products-query

# Annuler le commit fautif (remplacer <hash> par le hash reel)
git revert <hash-du-commit-fautif> --no-edit

# Pousser et ouvrir une PR vers main
git push -u origin hotfix/fix-products-query

# Apres merge sur main : repercuter sur dev
git checkout dev
git merge main
git push
```

---

## Causes racines

| # | Cause | Categorie |
|---|-------|-----------|
| 1 | Requete SQL referencant une colonne inexistante (`stock`) non detectee en tests | Qualite |
| 2 | Tests unitaires utilisant un mock DB : la vraie requete n'a jamais ete executee | Processus |
| 3 | Staging avec DB vide : le smoke test ne couvrait pas les erreurs SQL sur donnees | Infra |

---

## Actions correctives

| Action | Bloc | Priorite |
|--------|------|----------|
| Activer la validation manuelle GitHub Environment "production" (approb. requise) | I | Haute |
| Toujours appliquer les migrations SQL sur staging peuple avant tag de production | K | Haute |
| Ajouter un test d'integration /products sur staging avant tout deploiement prod | F | Moyenne |
| Documenter les regles de migration non destructive | K | Moyenne |

---

## Bilan DORA

- **MTTR** (Mean Time To Restore) : 25 minutes
- **Change Failure Rate** : 1 deploiement sur 2 en incident sur cette periode
