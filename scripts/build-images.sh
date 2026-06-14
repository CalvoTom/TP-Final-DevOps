#!/bin/sh
set -eu

# Construit et tague les images Docker ShopLite.
# Version = 1er argument, sinon dernier tag git, sinon "local".
VERSION="${1:-$(git describe --tags --abbrev=0 2>/dev/null || echo local)}"

echo "Construction des images ShopLite version: $VERSION"

docker build -t "shoplite-api:$VERSION" -t shoplite-api:latest ./api
docker build -t "shoplite-frontend:$VERSION" -t shoplite-frontend:latest ./frontend

echo "Images construites:"
docker images | grep -E "shoplite-(api|frontend)" || true
