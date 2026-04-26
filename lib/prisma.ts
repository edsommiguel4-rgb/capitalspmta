import { PrismaClient } from "@prisma/client";
import { ensureDb } from "./db-init";

ensureDb(); // 🔥 FORÇA criar as tabelas

const globalForPrisma = global as unknown as {
  prisma: PrismaClient;
};

export const prisma =
  globalForPrisma.prisma ||
  new PrismaClient();

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;
