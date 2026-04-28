#!/bin/sh

echo "🔄 Running Prisma..."
npx prisma generate
npx prisma db push

echo "🚀 Starting Next..."
next start -p $PORT
