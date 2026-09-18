// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64i_boscztt -ffreestanding -O2 -S %s -o - | FileCheck %s --check-prefix=ASM
// RUN: %clang -target riscv32 -march=rv32i_boscztt -ffreestanding -O2 -S -emit-llvm %s -o - | FileCheck %s --check-prefix=IR
// RUN: %clang -target riscv64 -march=rv64i_boscztt -ffreestanding -O0 -c %s -o %t.o
#include <RISCVBoscZtt.h>

// A complete 8-by-8 matrix product through the public header, with no V or F.
// IR-LABEL: @gemm(
// IR: @llvm.riscv.ztt.ame.acquire.i32
// IR: @llvm.riscv.ztt.msettyp.
// IR: @llvm.riscv.ztt.asettyp.
// IR: @llvm.riscv.ztt.mls.rm.
// IR: @llvm.riscv.ztt.mls.rm.
// IR: @llvm.riscv.ztt.mzero.2d.acc.
// IR: @llvm.riscv.ztt.mmulacc.2d.
// IR: @llvm.riscv.ztt.mmov.m.a.
// IR: @llvm.riscv.ztt.mss.rm.
// IR: @llvm.riscv.ztt.ame.release
// ASM-LABEL: gemm:
// ASM: ame.acquire a3, zero{{$}}
// ASM: andi a4, a3, 1{{$}}
// ASM: li a3, 0{{$}}
// ASM: beqz a4, .LBB0_2{{$}}
// ASM: li a3, 32{{$}}
// ASM: msettyp m0, a3{{$}}
// ASM: msettyp m1, a3{{$}}
// ASM: msettyp m2, a3{{$}}
// ASM: asettyp acc0, a3{{$}}
// ASM: mls.rm m0, a1{{$}}
// ASM: mls.rm m1, a2{{$}}
// ASM: mzero.2d.acc acc0{{$}}
// ASM: mmulacc.2d acc0, m0, m1{{$}}
// ASM: mmov.m.a m2, acc0{{$}}
// ASM: mss.rm m2, a0{{$}}
// ASM: ame.release{{$}}
// ASM: li a3, 1{{$}}
// ASM: mv a0, a3{{$}}
// ASM: ret{{$}}
int gemm(void *out, const void *left, const void *right) {
  if (!(ame_acquire(0) & 1))
    return 0;
  boscztt_m_i32_t a, b, c;
  boscztt_acc_i32_t acc;
  msettyp(a, 32);
  msettyp(b, 32);
  msettyp(c, 32);
  asettyp(acc, 32);
  mls_rm(a, left);
  mls_rm(b, right);
  mzero_2d_acc(acc);
  mmulacc_2d(acc, a, b);
  mmov_m_a(c, acc);
  mss_rm(c, out);
  ame_release();
  return 1;
}
