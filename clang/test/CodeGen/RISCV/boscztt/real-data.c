// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64im_boscztt -std=c11 -ffreestanding -Wall -Wextra -Werror -O0 -S -emit-llvm %s -o %t.64.ll
// RUN: opt -passes=verify -disable-output %t.64.ll
// RUN: FileCheck %s --check-prefix=IR < %t.64.ll
// RUN: %clang -target riscv32 -march=rv32im_boscztt -std=c11 -ffreestanding -Wall -Wextra -Werror -O0 -S -emit-llvm %s -o %t.32.ll
// RUN: opt -passes=verify -disable-output %t.32.ll
// RUN: FileCheck %s --check-prefix=IR < %t.32.ll
// RUN: %clang -target riscv64 -march=rv64im_boscztt -std=c11 -ffreestanding -O2 -S %s -o %t.64.s
// RUN: FileCheck %s --check-prefix=ASM < %t.64.s
// RUN: %clang -target riscv32 -march=rv32im_boscztt -std=c11 -ffreestanding -O2 -S %s -o %t.32.s
// RUN: FileCheck %s --check-prefix=ASM < %t.32.s
// RUN: llvm-mc -triple=riscv64 -mattr=+m,+boscztt -filetype=obj %t.64.s -o %t.64.o
// RUN: llvm-objdump -d --mattr=+m,+boscztt %t.64.o | FileCheck %s --check-prefix=OBJ
// RUN: llvm-mc -triple=riscv32 -mattr=+m,+boscztt -filetype=obj %t.32.s -o %t.32.o
// RUN: llvm-objdump -d --mattr=+m,+boscztt %t.32.o | FileCheck %s --check-prefix=OBJ
// RUN: %clang -target riscv64 -march=rv64im_boscztt -ffreestanding -O0 -c %s -o %t.64.o0.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -ffreestanding -O0 -c %s -o %t.32.o0.o

// This is also a standalone target program. Exit 0 means all elements and
// canaries match; 77 means AME ownership or a datatype/operation is unavailable.
// The lit RUN lines compile it; execution requires an AME-capable environment.
#include "Inputs/matrix-data.h"

_Static_assert(sizeof(int) == 4, "the fixture contains 32-bit elements");

#ifdef BOSCZTT_REFERENCE_ONLY
// Validate the shared golden data on the host, without emulating AME builtins.
int main(void) {
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j) {
      int sum = 0;
      for (int k = 0; k < TileSide; ++k)
        sum += Left[i][k] * Right[k][j];
      if (sum != Product[i][j])
        return 1;
    }
  return 0;
}
#else
#include <RISCVBoscZtt.h>

// IR-LABEL: define {{.*}} @ztt_i32_gemm(
// IR: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.{{.*}}(target("riscv.ztt.matrix", i32, 8, 8) undef, i{{32|64}} 1073741856)
// IR: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.
// IR: @llvm.riscv.ztt.mls.rm.
// IR: @llvm.riscv.ztt.mls.rm.
// IR: @llvm.riscv.ztt.mzero.2d.acc.
// IR: @llvm.riscv.ztt.mmulacc.2d.
// IR: @llvm.riscv.ztt.mmov.m.a.
// IR: @llvm.riscv.ztt.mss.rm.
__attribute__((noinline)) void ztt_i32_gemm(int out[TileSide][TileSide],
                                          const int a[TileSide][TileSide],
                                          const int b[TileSide][TileSide]) {
#if __riscv_boscztt_tile_side == 4
  // Keep the complete 8-by-8 fixture; execute it as 4-by-4 hardware tiles.
  for (int row = 0; row < TileSide; row += 4)
    for (int col = 0; col < TileSide; col += 4) {
      boscztt_m_i32_t ma, mb, result;
      boscztt_acc_i32_t acc;
      msettyp(ma, 0x40000020UL);
      msettyp(mb, 0x40000020UL);
      msettyp(result, 0x40000020UL);
      asettyp(acc, 0x40000020UL);
      mzero_2d_acc(acc);
      for (int k = 0; k < TileSide; k += 4) {
        mls_st(ma, &a[row][k], sizeof(a[0]));
        mls_st(mb, &b[k][col], sizeof(b[0]));
        mmulacc_2d(acc, ma, mb);
      }
      mmov_m_a(result, acc);
      mss_st(result, &out[row][col], sizeof(out[0]));
    }
#else
  boscztt_m_i32_t ma, mb, result;
  boscztt_acc_i32_t acc;
  msettyp(ma, 0x40000020UL);
  msettyp(mb, 0x40000020UL);
  msettyp(result, 0x40000020UL);
  asettyp(acc, 0x40000020UL);
  mls_rm(ma, a);
  mls_rm(mb, b);
  mzero_2d_acc(acc);
  mmulacc_2d(acc, ma, mb);
  mmov_m_a(result, acc);
  mss_rm(result, out);
#endif
}

// IR-LABEL: define {{.*}} @ztt_i32_strided(
// IR: @llvm.riscv.ztt.mls.st.{{.*}}(target("riscv.ztt.matrix", i32, 8, 8) {{.*}}, ptr {{.*}}, i{{32|64}} 40)
// IR: @llvm.riscv.ztt.mls.cm.
// IR: @llvm.riscv.ztt.msub.ew.
// IR: @llvm.riscv.ztt.mss.st.{{.*}}(target("riscv.ztt.matrix", i32, 8, 8) {{.*}}, ptr {{.*}}, i{{32|64}} 40)
__attribute__((noinline)) void ztt_i32_strided(
    int out[TileSide][PaddedColumns], const int a[TileSide][PaddedColumns],
    const int b[TileSide][TileSide]) {
#if __riscv_boscztt_tile_side == 4
  for (int row = 0; row < TileSide; row += 4)
    for (int col = 0; col < TileSide; col += 4) {
      // Gather this input tile contiguously so mls.cm exercises a genuine
      // column-major load, including off-diagonal 4-by-4 tiles.
      int bt[4][4];
      for (int i = 0; i < 4; ++i)
        for (int j = 0; j < 4; ++j)
          bt[i][j] = b[col + i][row + j];
      boscztt_m_i32_t ma, mb, result;
      msettyp(ma, 0x40000020UL);
      msettyp(mb, 0x40000020UL);
      msettyp(result, 0x40000020UL);
      mls_st(ma, &a[row][col], sizeof(a[0]));
      mls_cm(mb, bt);
      msub_ew(result, mb, ma);
      mss_st(result, &out[row][col], sizeof(out[0]));
    }
#else
  boscztt_m_i32_t ma, mb, result;
  msettyp(ma, 0x40000020UL);
  msettyp(mb, 0x40000020UL);
  msettyp(result, 0x40000020UL);
  mls_st(ma, a, sizeof(a[0]));
  mls_cm(mb, b);
  // Ztt 0.6: msub.ew md, ms1, ms2 computes ms2 - ms1.
  msub_ew(result, mb, ma);
  mss_st(result, out, sizeof(out[0]));
#endif
}

enum { PressureTiles = __riscv_boscztt_m_registers + 2 };

// Keep 18 distinct matrix values live together, exceeding the 16-M-register
// file. Check data and descriptors after using high registers and spilling.
// IR-LABEL: define {{.*}} @ztt_i32_pressure(
// IR: @llvm.riscv.ztt.mls.rm.
// IR: @llvm.riscv.ztt.madd.ew.x.
// IR: @llvm.riscv.ztt.mss.rm.
// IR: @llvm.riscv.ztt.mgettyp.
__attribute__((noinline)) unsigned long
ztt_i32_pressure(int out[PressureTiles][TileSide][TileSide],
                 const int a[TileSide][TileSide]) {
  // Arithmetic .ew.x instructions interpret X operands using amestype.
  __asm__ volatile("csrw amestype, %0" : : "r"(0x40000020UL) : "memory");
#if __riscv_boscztt_tile_side == 4
  unsigned long bad_descriptor = 0;
  for (int row = 0; row < TileSide; row += 4)
    for (int col = 0; col < TileSide; col += 4) {
#define EXTRA_TILES(F)                                                          \
  F(18) F(19) F(20) F(21) F(22) F(23) F(24) F(25)                              \
  F(26) F(27) F(28) F(29) F(30) F(31) F(32) F(33)
#define LOAD_DATA(M) mls_st(M, &a[row][col], sizeof(a[0]))
#define STORE_DATA(M, N) mss_st(M, &out[N][row][col], sizeof(out[N][0]))
#else
#define EXTRA_TILES(F)
#define LOAD_DATA(M) mls_rm(M, a)
#define STORE_DATA(M, N) mss_rm(M, out[N])
#endif
#define FOR_EACH_TILE(F)                                                        \
  F(0) F(1) F(2) F(3) F(4) F(5) F(6) F(7) F(8)                                 \
  F(9) F(10) F(11) F(12) F(13) F(14) F(15) F(16) F(17) EXTRA_TILES(F)
#define LOAD_TILE(N)                                                           \
  boscztt_m_i32_t m##N;                                                        \
  msettyp(m##N, 0x40000020UL);                                                 \
  LOAD_DATA(m##N);                                                             \
  madd_ew_x(m##N, N, m##N);
  FOR_EACH_TILE(LOAD_TILE)
#undef LOAD_TILE
#if __riscv_boscztt_tile_side != 4
  unsigned long bad_descriptor = 0;
#endif
#define STORE_TILE(N)                                                          \
  STORE_DATA(m##N, N);                                                        \
  bad_descriptor |= mgettyp(m##N) ^ 0x40000020UL;
  FOR_EACH_TILE(STORE_TILE)
#undef STORE_TILE
#undef FOR_EACH_TILE
#undef EXTRA_TILES
#undef LOAD_DATA
#undef STORE_DATA
#if __riscv_boscztt_tile_side == 4
    }
#endif
  return bad_descriptor;
}

// IR-LABEL: define {{.*}} @main(
// IR: @llvm.riscv.ztt.ame.acquire.
// IR: call void @ztt_i32_gemm({{.*}}@Left{{.*}}@Right
// IR: call void @ztt_i32_strided({{.*}}@Right
// IR: call i{{32|64}} @ztt_i32_pressure({{.*}}@Left
// IR: @llvm.riscv.ztt.ame.release
int main(void) {
  if (!(ame_acquire(0) & 1))
    return 77;
  __asm__ volatile("csrw amestatus, zero" ::: "memory");

  struct {
    int before;
    int values[TileSide][TileSide];
    int after;
  } product;
  product.before = product.after = 123456789;
  struct {
    int before;
    int values[PressureTiles][TileSide][TileSide];
    int after;
  } pressure;
  pressure.before = pressure.after = 123456789;
  for (int tile = 0; tile < PressureTiles; ++tile)
    for (int i = 0; i < TileSide; ++i)
      for (int j = 0; j < TileSide; ++j)
        pressure.values[tile][i][j] = 16384;
  int padded[TileSide][PaddedColumns], difference[TileSide][PaddedColumns];
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < PaddedColumns; ++j) {
      padded[i][j] = j < TileSide ? Left[i][j] : 16384;
      difference[i][j] = 16384;
      if (j < TileSide)
        product.values[i][j] = 16384;
    }

  ztt_i32_gemm(product.values, Left, Right);
  ztt_i32_strided(difference, padded, Right);
  unsigned long bad_descriptor = ztt_i32_pressure(pressure.values, Left);
  unsigned long status;
  __asm__ volatile("csrr %0, amestatus" : "=r"(status) : : "memory");
  ame_release();
  if (status & 1)
    return 77;

  if (product.before != 123456789 || product.after != 123456789)
    return 1;
  if (bad_descriptor || pressure.before != 123456789 ||
      pressure.after != 123456789)
    return 6;
  for (int tile = 0; tile < PressureTiles; ++tile)
    for (int i = 0; i < TileSide; ++i)
      for (int j = 0; j < TileSide; ++j)
        if (pressure.values[tile][i][j] != Left[i][j] + tile)
          return 7;
  for (int i = 0; i < TileSide; ++i) {
    for (int j = 0; j < TileSide; ++j) {
      if (product.values[i][j] != Product[i][j])
        return 2;
      if (difference[i][j] != Left[i][j] - Right[j][i])
        return 3;
      if (padded[i][j] != Left[i][j])
        return 4;
    }
    for (int j = TileSide; j < PaddedColumns; ++j)
      if (difference[i][j] != 16384 || padded[i][j] != 16384)
        return 5;
  }
  return 0;
}
#endif

// ASM-LABEL: ztt_i32_gemm:
// ASM: msettyp m0, a3{{$}}
// ASM-NEXT: msettyp m1, a3{{$}}
// ASM-NEXT: msettyp m2, a3{{$}}
// ASM-NEXT: asettyp acc0, a3{{$}}
// ASM-NEXT: mls.rm m0, a1{{$}}
// ASM-NEXT: mls.rm m1, a2{{$}}
// ASM-NEXT: mzero.2d.acc acc0{{$}}
// ASM-NEXT: mmulacc.2d acc0, m0, m1{{$}}
// ASM-NEXT: mmov.m.a m2, acc0{{$}}
// ASM-NEXT: mss.rm m2, a0{{$}}
// ASM-NEXT: ret{{$}}
// ASM-LABEL: ztt_i32_strided:
// ASM: msettyp m0, a3{{$}}
// ASM-NEXT: msettyp m1, a3{{$}}
// ASM-NEXT: msettyp m2, a3{{$}}
// ASM-NEXT: li a3, 40{{$}}
// ASM-NEXT: mls.st m0, (a1), a3{{$}}
// ASM-NEXT: mls.cm m1, a2{{$}}
// ASM-NEXT: msub.ew m2, m1, m0{{$}}
// ASM-NEXT: mss.st m2, (a0), a3{{$}}
// ASM-NEXT: ret{{$}}
// ASM-LABEL: ztt_i32_pressure:
// ASM: csrr t2, amestatus{{$}}
// ASM-NEXT: mgettyp t1, m0{{$}}
// ASM-NEXT: addi t0, sp, 536{{$}}
// ASM-NEXT: sw t1, 0(t0){{$}}
// ASM-NEXT: addi t0, sp, 544{{$}}
// ASM-NEXT: mss.1r m0, t0{{$}}
// ASM-NEXT: csrw amestatus, t2{{$}}
// ASM: msettyp m15, a2{{$}}
// ASM-NEXT: mls.rm m15, a1{{$}}
// ASM-NEXT: li a3, 12{{$}}
// ASM-NEXT: madd.ew.x m15, a3, m15{{$}}
// ASM: msettyp m8, a2{{$}}
// ASM-NEXT: mls.rm m8, a1{{$}}
// ASM-NEXT: li a3, 16{{$}}
// ASM-NEXT: madd.ew.x m8, a3, m8{{$}}
// ASM-NEXT: msettyp m14, a2{{$}}
// ASM-NEXT: mls.rm m14, a1{{$}}
// ASM-NEXT: li a3, 17{{$}}
// ASM-NEXT: madd.ew.x m14, a3, m14{{$}}
// ASM-NEXT: csrr t2, amestatus{{$}}
// ASM-NEXT: addi t0, sp, 536{{$}}
// ASM-NEXT: lw t1, 0(t0){{$}}
// ASM-NEXT: msettyp m0, t1{{$}}
// ASM-NEXT: addi t0, sp, 544{{$}}
// ASM-NEXT: mls.1r m0, t0{{$}}
// ASM-NEXT: csrw amestatus, t2{{$}}
// ASM: mss.rm m15, s3{{$}}
// ASM-NEXT: mgettyp s3, m15{{$}}
// ASM: mss.rm m8, s7{{$}}
// ASM-NEXT: mgettyp s7, m8{{$}}
// ASM-NEXT: add a0, a0, a3{{$}}
// ASM-NEXT: mss.rm m14, a0{{$}}
// ASM-NEXT: mgettyp a0, m14{{$}}
// ASM: ret{{$}}
// ASM-LABEL: main:
// ASM: ame.acquire a0, zero{{$}}
// ASM: call ztt_i32_gemm{{$}}
// ASM: call ztt_i32_strided{{$}}
// ASM: call ztt_i32_pressure{{$}}
// ASM: ame.release{{$}}

// OBJ-LABEL: <ztt_i32_gemm>:
// OBJ: mls.rm m0, a1{{$}}
// OBJ-NEXT: {{.*}}mls.rm m1, a2{{$}}
// OBJ-NEXT: {{.*}}mzero.2d.acc acc0{{$}}
// OBJ-NEXT: {{.*}}mmulacc.2d acc0, m0, m1{{$}}
// OBJ-NEXT: {{.*}}mmov.m.a m2, acc0{{$}}
// OBJ-NEXT: {{.*}}mss.rm m2, a0{{$}}
// OBJ-LABEL: <ztt_i32_strided>:
// OBJ: mls.st m0, (a1), a3{{$}}
// OBJ-NEXT: {{.*}}mls.cm m1, a2{{$}}
// OBJ-NEXT: {{.*}}msub.ew m2, m1, m0{{$}}
// OBJ-NEXT: {{.*}}mss.st m2, (a0), a3{{$}}
// OBJ-LABEL: <ztt_i32_pressure>:
// OBJ: msettyp m15, a2{{$}}
// OBJ-NEXT: {{.*}}mls.rm m15, a1{{$}}
// OBJ-NEXT: {{.*}}li a3, 0xc{{$}}
// OBJ-NEXT: {{.*}}madd.ew.x m15, a3, m15{{$}}
// OBJ: msettyp m8, a2{{$}}
// OBJ-NEXT: {{.*}}mls.rm m8, a1{{$}}
// OBJ: mss.rm m15, s3{{$}}
// OBJ-NEXT: {{.*}}mgettyp s3, m15{{$}}
// OBJ-LABEL: <main>:
// OBJ: ame.acquire a0, zero{{$}}
// OBJ: ame.release{{$}}
