# Etape build: installation des dependances de production
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# Etape runtime: image finale minimale
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production
ENV API_PORT=3000

COPY --from=build /app/node_modules ./node_modules
COPY package*.json ./
COPY src ./src

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD wget -qO- http://127.0.0.1:3000/health || exit 1

CMD ["node", "src/server.js"]
