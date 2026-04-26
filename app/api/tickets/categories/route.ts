export const dynamic = "force-dynamic";

import { prisma } from "@/lib/prisma";

export async function GET() {
   const categories = await prisma.ticketCategory.findMany({
      orderBy: { order: "asc" }
   });

   return Response.json(categories);
}
