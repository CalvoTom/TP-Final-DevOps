# Indicateurs DORA

Mesures des quatre indicateurs DevOps Research and Assessment (DORA) pour
le projet ShopLite sur la periode du TP (2026-06-01 au 2026-06-15).

## Definitions

| Indicateur | Definition | Niveau Elite |
|------------|------------|--------------|
| Deployment Frequency | Frequence des mises en production | Plusieurs fois par jour |
| Lead Time for Changes | Temps entre commit et production | Moins d'une heure |
| Change Failure Rate | Pourcentage de deploiements causant un incident | < 5 % |
| MTTR | Temps moyen de restauration apres incident | Moins d'une heure |

## Mesures ShopLite

### Deployment Frequency

**Valeur mesuree** : 2 deploiements en production (`v1.0.0`, `v1.1.0` annule)
sur 14 jours, soit environ 1 deploiement par semaine.

**Niveau** : Medium (objectif : passer a plusieurs fois par semaine sur `dev`
grace au CD automatique sur chaque push).

### Lead Time for Changes

**Valeur mesuree** : environ 20 minutes.

| Etape | Duree estimee |
|-------|---------------|
| CI (quality + test + trivy + build) | ~8 min |
| Review PR + merge | ~5 min |
| CD staging (build + smoke test) | ~5 min |
| Approbation manuelle production | variable |
| CD production (build + smoke test) | ~5 min |

**Hors approbation manuelle** : ~20 minutes de commit a staging.
**Avec approbation** : depend du disponibilite du reviewer.

**Niveau** : Medium (objectif : High a mesure que la CI s'optimise).

### Change Failure Rate

**Valeur mesuree** : 1 incident sur 2 deploiements production = **50 %**.

| Deploiement | Version | Resultat |
|-------------|---------|---------|
| 2026-06-14 14:28 | v1.0.0 | succes |
| 2026-06-14 14:35 | v1.1.0 | echec (INC-001) |

**Apres actions correctives** (test d'integration sur staging peuple,
validation manuelle production) : objectif < 5 %.

**Niveau actuel** : Low. Objectif post-incident : Elite.

### MTTR (Mean Time To Restore)

**Valeur mesuree** : **25 minutes** (incident INC-001).

| Etape | Duree |
|-------|-------|
| Detection (logs JSON level=error) | ~2 min |
| Diagnostic (identification du commit) | ~5 min |
| Rollback (`sh scripts/rollback.sh v1.0.0`) | ~5 min |
| Smoke test de validation | ~2 min |
| Git revert + PR hotfix | ~11 min |

**Niveau** : Elite (objectif < 1 heure atteint).

## Bilan et plan d'amelioration

| Indicateur | Niveau actuel | Objectif | Action |
|------------|---------------|----------|--------|
| Deployment Frequency | Medium | High | CD automatique sur `dev` actif |
| Lead Time | Medium | High | Optimiser le cache CI npm |
| Change Failure Rate | Low (50 %) | Elite (< 5 %) | Tests integration staging + gate production |
| MTTR | Elite (25 min) | Elite | Maintenir rollback.sh + monitoring |
