import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  await prisma.ticketCategory.createMany({
    data: [
      { name: "Suporte", slug: "suporte", order: 1 },
      { name: "Denúncia", slug: "denuncia", order: 2 },
      { name: "Compras", slug: "compras", order: 3 },
      { name: "Whitelist", slug: "whitelist", order: 4 }
    ],
    skipDuplicates: true
  });

  console.log("Categorias criadas.");
}

main()
  .finally(async () => {
    await prisma.$disconnect();
  });
