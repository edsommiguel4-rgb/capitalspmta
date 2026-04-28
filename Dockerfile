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

EXPOSE 3000
ENV PORT=3000

# 🚀 START ROBUSTO COM RETRY DE BANCO
CMD ["sh", "-c", "\
echo '⏳ Aguardando banco e aplicando schema...' && \
for i in $(seq 1 15); do \
  npx prisma db push && break || echo '⏳ Tentando novamente...' && sleep 3; \
done && \
echo '✅ Prisma pronto' && \
npx prisma generate && \
node prisma/seed.js || true && \
echo '🚀 Iniciando Next.js' && \
npx next start -p 3000 \
"]
