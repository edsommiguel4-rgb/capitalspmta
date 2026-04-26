FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache openssl

COPY package*.json ./
RUN npm install

COPY . .

# Gera o client na build (não precisa de banco)
RUN npx prisma generate

# Build do Next
RUN npm run build

EXPOSE 8080
ENV PORT=8080

# Aqui roda o banco + app
CMD ["sh", "-c", "npx prisma db push && npm start"]
