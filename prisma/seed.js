const { PrismaClient } = require("@prisma/client");
const bcrypt = require("bcryptjs");

const prisma = new PrismaClient();

async function main() {
  const roles = [
    { name: "SUPPORT", rank: 30, description: "Cargo: Suporte" },
    { name: "MODERATOR", rank: 31, description: "Cargo: Moderador" },
    { name: "ADMIN", rank: 32, description: "Cargo: Administrador" },
    { name: "OWNER", rank: 33, description: "Cargo: Owner" },
    { name: "APOIADOR", rank: 10, description: "VIP Apoiador" },
    { name: "INVESTIDOR", rank: 11, description: "VIP Investidor" },
    { name: "PATROCINADOR", rank: 12, description: "VIP Patrocinador" },
    { name: "STAFF_SEMANAL", rank: 20, description: "Recompensa semanal de staff" },
  ];

  for (const r of roles) {
    await prisma.role.upsert({
      where: { name: r.name },
      update: { rank: r.rank, description: r.description },
      create: r,
    });
  }

  const passwordHash = await bcrypt.hash("@Edjanemiguel2715", 10);

  await prisma.user.upsert({
    where: { email: "cronosMTA@gmail.com" },
    update: {
      username: "cronos",
      passwordHash,
      role: "OWNER",
      whitelistStatus: "APPROVED",
      emailVerifiedAt: new Date(),
      emailVerifyToken: null,
      emailVerifyExpiresAt: null,
    },
    create: {
      email: "cronosMTA@gmail.com",
      username: "cronos",
      passwordHash,
      role: "OWNER",
      whitelistStatus: "APPROVED",
      avatarKey: "avatar1",
      emailVerifiedAt: new Date(),
    },
  });

  await prisma.whitelistConfig.upsert({
    where: { id: "singleton" },
    update: {},
    create: { id: "singleton" },
  });

  console.log("Seed OK");
}

main()
  .catch((e) => {
    console.error("SEED ERROR:", e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
