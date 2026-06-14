# Images Docker, tags et registry

Comment construire, taguer, inspecter et comparer les images Docker de
ShopLite (bloc G).

## Construire les images

Build manuel :

```sh
docker build -t shoplite-api:local ./api
docker build -t shoplite-frontend:local ./frontend
```

Script outille (tague aussi en latest et reprend le tag git si disponible) :

```sh
sh scripts/build-images.sh v1.0.0
```

## Tags et lien avec le tag Git

Regle : le tag Docker suit le tag Git semver.

| Tag Git | Image API | Image frontend |
|---|---|---|
| v1.0.0 | shoplite-api:v1.0.0 | shoplite-frontend:v1.0.0 |
| v1.1.0 | shoplite-api:v1.1.0 | shoplite-frontend:v1.1.0 |

Procedure type pour une version :

```sh
git tag v1.0.0
sh scripts/build-images.sh v1.0.0
```

## Inspecter une image

```sh
docker inspect shoplite-api:v1.0.0
docker image inspect shoplite-api:v1.0.0 --format '{{.Config.Env}}'
docker image inspect shoplite-api:v1.0.0 --format '{{.Config.Cmd}}'
```

On verifie ainsi les variables d'environnement, la commande de demarrage et
le healthcheck de l'image.

## Historique et comparaison

Lister les images disponibles (utile avant un rollback) :

```sh
docker images | grep shoplite
```

Comparer la version courante et une version stable :

```sh
docker images shoplite-api
```

Une image taguee v1.0.0 sert de point de retour fiable pour le rollback
(bloc O), contrairement a latest qui peut avoir change entre temps.
