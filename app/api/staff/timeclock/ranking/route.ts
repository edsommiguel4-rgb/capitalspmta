import { NextResponse } from "next/server";
import { requireRole } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
// import { _internals } from "../route";

export async function POST() {
  try {
    await requireRole("SUPPORT");
    const ranking = await _internals.computeRanking(new Date());
    return NextResponse.json({ ranking });
  } catch {
    return NextResponse.json({ message: "Sem permissão." }, { status: 403 });
  }
}
