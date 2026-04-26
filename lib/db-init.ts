import { execSync } from "child_process";

let initialized = false;

export function ensureDb() {
  if (initialized) return;

  try {
    console.log("🚀 Rodando prisma db push...");
    execSync("npx prisma db push", { stdio: "inherit" });
    initialized = true;
  } catch (err) {
    console.error("❌ Erro ao rodar prisma db push:", err);
  }
}
