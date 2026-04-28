#!/bin/sh

echo "⏳ Aguardando banco..."

for i in $(seq 1 15); do
  npx prisma db push && break
  echo "⏳ Tentando novamente..."
  sleep 3
done

echo "✅ Prisma sincronizado"

npx prisma generate

node prisma/seed.js || true

echo "🚀 Iniciando Next.js"

exec npx next start -p 3000
