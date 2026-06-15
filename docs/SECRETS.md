# Secrets et configuration

Regles d'hygiene pour la configuration et les secrets (bloc H).

## Principes

- Aucune vraie valeur sensible dans le depot Git.
- `.env.example` documente toutes les variables avec des valeurs d'exemple.
- Le vrai `.env` reste local et n'est jamais commite (present dans `.gitignore`).
- Aucun secret en dur dans les Dockerfile ni dans les images construites.
- Aucun secret affiche dans les logs.

## Verifications rapides

Verifier que le vrai .env est bien ignore :

```sh
git check-ignore .env
```

Chercher d'eventuels secrets commites par erreur :

```sh
git grep -nE "(password|secret|token|api_key)" -- . ':!*.example'
```

Verifier qu'aucun secret n'est fige dans un Dockerfile :

```sh
grep -RniE "password|secret|token" api/Dockerfile frontend/Dockerfile || echo "Aucun secret trouve"
```

## Secrets par environnement (GitHub)

Les secrets reels (mot de passe de la base, etc.) sont stockes dans GitHub via
des Secrets par environment (dev, staging, prod) et injectes au moment du run,
jamais dans le code. A configurer dans Settings > Environments du depot (lie au
bloc I).

## Variables sensibles

Voir `.env.example` pour la liste complete. Variables a proteger :

- `POSTGRES_PASSWORD`
- `DATABASE_URL` (contient le mot de passe)

## Rotation des secrets

- Renouveler `POSTGRES_PASSWORD` et `DATABASE_URL` apres le depart d'un membre
  de l'equipe ou en cas de suspicion de fuite, et au minimum a chaque release
  majeure.
- Mettre a jour le secret dans GitHub Environments puis redeployer.
- Ne jamais reutiliser un ancien mot de passe.

## Ports exposes

Seul le proxy nginx expose un port vers l'hote (8080 en dev, 8081 en staging).
L'API et PostgreSQL ne sont accessibles que sur le reseau interne Compose
`shoplite_net`, ce qui reduit la surface exposee.
```

