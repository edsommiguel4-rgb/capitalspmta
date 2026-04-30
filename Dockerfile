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

# Instala dependências de produção
COPY package*.json ./
RUN npm install --omit=dev

# Copia arquivos necessários do builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# 👇 Garante que o Prisma Client seja gerado para o ambiente de runtime
RUN npx prisma generate

EXPOSE 3000
ENV PORT=3000

# 🚀 O SEGREDO ESTÁ AQUI: Adicionamos --accept-data-loss
# Isso força a criação da tabela 'users' mesmo que a 'Usuário' antiga exista.
CMD sh -c "npx prisma db push --accept-data-loss && npm start"
