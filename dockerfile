# ----------- ESTAGIO 1: BUILD & DEPENDENCIAS -----------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
# Adicionada a flag para permitir a instalação das ferramentas de build
RUN npm install --legacy-peer-deps
COPY . .

# ----------- ESTAGIO 2: Imagem de produção leve -----------
FROM node:20-alpine
WORKDIR /app

# Em vez de rodar o npm install de novo, copiamos apenas o que a produção precisa
COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./server.js

USER node
EXPOSE 3000
CMD ["node", "server.js"]
