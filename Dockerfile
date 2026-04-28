# ---------- BUILD STAGE ----------
FROM node:20-alpine AS builder

WORKDIR /app

RUN apk add --no-cache openssl

COPY package*.json ./
RUN npm install

COPY . .

# Gera o Prisma Client no build
RUN npx prisma generate

# Build do Next
RUN npm run build


# ---------- RUNTIME STAGE ----------
FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache openssl

# Instala dependências de produção + garante prisma client
COPY package*.json ./
RUN npm install --omit=dev && npx prisma generate

# Copia arquivos necessários
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# 👇 IMPORTANTE: copiar o start.sh
COPY --from=builder /app/start.sh ./start.sh

# Permissão de execução
RUN chmod +x start.sh

EXPOSE 3000
ENV PORT=3000

# 🚀 ENTRYPOINT FINAL (FORÇADO)
CMD sh -c "npx prisma generate && npx prisma db push && npx next start -p $PORT"
