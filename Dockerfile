FROM node:20-alpine

WORKDIR /app

# Dependência necessária pro Prisma
RUN apk add --no-cache openssl

# Instala dependências
COPY package*.json ./
RUN npm install

# Copia projeto
COPY . .

# Gera Prisma Client
RUN npx prisma generate

# Build do Next
RUN npm run build

# Porta correta do Next.js
EXPOSE 3000
ENV PORT=3000

# Start limpo (SEM db push aqui)
CMD ["npm", "run", "start"]
