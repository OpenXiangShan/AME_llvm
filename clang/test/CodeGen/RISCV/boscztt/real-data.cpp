// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -std=c++17 -DBOSCZTT_REFERENCE_ONLY -fsyntax-only %s
// RUN: %clang_cc1 -triple riscv64 -std=c++17 -DBOSCZTT_REFERENCE_ONLY -fexperimental-new-constant-interpreter -fsyntax-only %s
// RUN: %clang -target riscv64 -march=rv64im_boscztt -std=c++17 -ffreestanding -Wall -Wextra -Werror -O0 -S -emit-llvm %s -o %t.64.ll
// RUN: opt -passes=verify -disable-output %t.64.ll
// RUN: FileCheck %s --check-prefix=IR < %t.64.ll
// RUN: %clang -target riscv32 -march=rv32im_boscztt -std=c++17 -ffreestanding -Wall -Wextra -Werror -O0 -S -emit-llvm %s -o %t.32.ll
// RUN: opt -passes=verify -disable-output %t.32.ll
// RUN: FileCheck %s --check-prefix=IR < %t.32.ll
// RUN: %clang -target riscv64 -march=rv64im_boscztt -std=c++17 -ffreestanding -O2 -S %s -o %t.64.s
// RUN: FileCheck %s --check-prefix=ASM < %t.64.s
// RUN: %clang -target riscv32 -march=rv32im_boscztt -std=c++17 -ffreestanding -O2 -S %s -o %t.32.s
// RUN: FileCheck %s --check-prefix=ASM < %t.32.s
// RUN: llvm-mc -triple=riscv64 -mattr=+m,+boscztt -filetype=obj %t.64.s -o %t.64.o
// RUN: llvm-objdump -d --mattr=+m,+boscztt %t.64.o | FileCheck %s --check-prefix=OBJ
// RUN: llvm-mc -triple=riscv32 -mattr=+m,+boscztt -filetype=obj %t.32.s -o %t.32.o
// RUN: llvm-objdump -d --mattr=+m,+boscztt %t.32.o | FileCheck %s --check-prefix=OBJ
// RUN: %clang -target riscv64 -march=rv64im_boscztt -std=c++17 -ffreestanding -O0 -c %s -o %t.64.o0.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -std=c++17 -ffreestanding -O0 -c %s -o %t.32.o0.o

#include "Inputs/matrix-data.h"

// These structs hold ordinary memory buffers, not AME register values.
template <class T> struct Tile {
  T data[TileSide][TileSide];
};

constexpr bool checkIntegerProduct() {
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j) {
      int sum = 0;
      for (int k = 0; k < TileSide; ++k)
        sum += Left[i][k] * Right[k][j];
      if (sum != Product[i][j])
        return false;
    }
  return true;
}

constexpr Tile<float> scale(const int (&source)[TileSide][TileSide], int n) {
  Tile<float> result{};
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j)
      result.data[i][j] = static_cast<float>(source[i][j]) / n;
  return result;
}

static constexpr auto FloatLeft = scale(Left, 2);
static constexpr auto FloatRight = scale(Right, 4);
static constexpr auto Bias = scale(Left, 8);

// Dyadic inputs and small exact sums avoid dependence on reduction order or
// scalar versus fused rounding. C = bias + 2 * (Left / 2) * (Right / 4).
constexpr Tile<float> floatReference() {
  Tile<float> result = Bias;
  for (int tile = 0; tile < 2; ++tile)
    for (int i = 0; i < TileSide; ++i)
      for (int j = 0; j < TileSide; ++j)
        for (int k = 0; k < TileSide; ++k)
          result.data[i][j] += FloatLeft.data[i][k] * FloatRight.data[k][j];
  return result;
}

static constexpr auto FloatExpected = floatReference();
constexpr bool checkFloatProduct() {
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j)
      if (FloatExpected.data[i][j] != Product[i][j] / 4.0f + Bias.data[i][j])
        return false;
  return true;
}

constexpr Tile<long long> wideData(bool left) {
  Tile<long long> result{};
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j)
      result.data[i][j] = left ? Left[i][j] * (1LL << 40) : Right[i][j];
  return result;
}

static_assert(checkIntegerProduct(), "incorrect integer golden table");
static_assert(checkFloatProduct(), "incorrect floating-point reference");
static_assert(sizeof(float) == 4 && sizeof(long long) == 8, "element widths");

#ifdef BOSCZTT_REFERENCE_ONLY
// Host mode validates the data/reference only. It does not emulate AME or test
// compiled target instructions. Target execution uses the other main below.
extern "C" int main() { return !(checkIntegerProduct() && checkFloatProduct()); }
#else
#include <RISCVBoscZtt.h>

template <class M, class A>
__attribute__((noinline)) A accumulate(A acc, M a, M b) {
  mmulacc_2d(acc, a, b);
  return acc;
}

// IR-LABEL: define {{.*}} @ztt_f32_accumulate(
// IR: @llvm.riscv.ztt.msettyp.{{.*}}(target("riscv.ztt.matrix", float, 8, 8) undef, i{{32|64}} 540016928)
// IR: @llvm.riscv.ztt.mmov.a.m.
// IR: phi target("riscv.ztt.acc", float, 8, 8)
// IR: call {{.*}} @_Z10accumulate
// IR: @llvm.riscv.ztt.mmov.m.a.
// IR: @llvm.riscv.ztt.mss.rm.
extern "C" __attribute__((noinline)) void ztt_f32_accumulate(
    float out[TileSide][TileSide], const float a[TileSide][TileSide],
    const float b[TileSide][TileSide], const float bias[TileSide][TileSide]) {
  // Standard FP32, round to nearest even, infinities and denormals enabled.
  constexpr unsigned long F32 = (8UL << 26) | (1UL << 21) | (1UL << 20) | 0x120;
#if __riscv_boscztt_tile_side == 4
  for (int row = 0; row < TileSide; row += 4)
    for (int col = 0; col < TileSide; col += 4) {
      boscztt_m_f32_t ma, mb, result;
      boscztt_acc_f32_t acc;
      msettyp(ma, F32);
      msettyp(mb, F32);
      msettyp(result, F32);
      asettyp(acc, F32);
      mls_st(result, &bias[row][col], sizeof(bias[0]));
      mmov_a_m(acc, result);
      for (int repeat = 0; repeat < 2; ++repeat)
        for (int k = 0; k < TileSide; k += 4) {
          mls_st(ma, &a[row][k], sizeof(a[0]));
          mls_st(mb, &b[k][col], sizeof(b[0]));
          acc = accumulate(acc, ma, mb);
        }
      mmov_m_a(result, acc);
      mss_st(result, &out[row][col], sizeof(out[0]));
    }
#else
  boscztt_m_f32_t ma, mb, result;
  boscztt_acc_f32_t acc;
  msettyp(ma, F32);
  msettyp(mb, F32);
  msettyp(result, F32);
  asettyp(acc, F32);
  mls_rm(ma, a);
  mls_rm(mb, b);
  mls_rm(result, bias);
  mmov_a_m(acc, result);
  for (int i = 0; i < 2; ++i)
    acc = accumulate(acc, ma, mb);
  mmov_m_a(result, acc);
  mss_rm(result, out);
#endif
}

// IR-LABEL: define {{.*}} @ztt_i64_subtract(
// IR: call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.{{.*}}(target("riscv.ztt.matrix", i64, 8, 8) undef, i{{32|64}} 1073741888)
// IR: @llvm.riscv.ztt.mls.rm.
// IR: @llvm.riscv.ztt.mls.rm.
// IR: call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msub.ew.
// IR: @llvm.riscv.ztt.mss.rm.
extern "C" __attribute__((noinline)) void ztt_i64_subtract(
    long long out[TileSide][TileSide], const long long a[TileSide][TileSide],
    const long long b[TileSide][TileSide]) {
#if __riscv_boscztt_tile_side == 4
  for (int row = 0; row < TileSide; row += 4)
    for (int col = 0; col < TileSide; col += 4) {
      boscztt_m_i64_t ma, mb, result;
      msettyp(ma, 0x40000040UL);
      msettyp(mb, 0x40000040UL);
      msettyp(result, 0x40000040UL);
      mls_st(ma, &a[row][col], sizeof(a[0]));
      mls_st(mb, &b[row][col], sizeof(b[0]));
      msub_ew(result, mb, ma);
      mss_st(result, &out[row][col], sizeof(out[0]));
    }
#else
  boscztt_m_i64_t ma, mb, result;
  msettyp(ma, 0x40000040UL);
  msettyp(mb, 0x40000040UL);
  msettyp(result, 0x40000040UL);
  mls_rm(ma, a);
  mls_rm(mb, b);
  // Ztt 0.6: msub.ew md, ms1, ms2 computes ms2 - ms1.
  msub_ew(result, mb, ma);
  mss_rm(result, out);
#endif
}

// IR-LABEL: define {{.*}} @main(
// IR: @llvm.riscv.ztt.ame.acquire.
// IR: call void @ztt_f32_accumulate({{.*}}@_ZL9FloatLeft{{.*}}@_ZL10FloatRight{{.*}}@_ZL4Bias
// IR: call void @ztt_i64_subtract(
// IR: @llvm.riscv.ztt.ame.release
extern "C" int main() {
  if (!(ame_acquire(0) & 1))
    return 77;
  __asm__ volatile("csrw amestatus, zero" ::: "memory");
  struct {
    unsigned long long before;
    Tile<float> values;
    unsigned long long after;
  } floats;
  struct {
    unsigned long long before;
    Tile<long long> values;
    unsigned long long after;
  } wide;
  constexpr unsigned long long Canary = 0x0123456789abcdefULL;
  floats.before = floats.after = wide.before = wide.after = Canary;
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j) {
      floats.values.data[i][j] = -16384.0f;
      wide.values.data[i][j] = 16384;
    }
  static constexpr auto WideLeft = wideData(true);
  static constexpr auto WideRight = wideData(false);
  ztt_f32_accumulate(floats.values.data, FloatLeft.data, FloatRight.data, Bias.data);
  ztt_i64_subtract(wide.values.data, WideLeft.data, WideRight.data);
  unsigned long status;
  __asm__ volatile("csrr %0, amestatus" : "=r"(status) : : "memory");
  ame_release();
  if (status & 1)
    return 77;

  if (floats.before != Canary || floats.after != Canary ||
      wide.before != Canary || wide.after != Canary)
    return 1;
  for (int i = 0; i < TileSide; ++i)
    for (int j = 0; j < TileSide; ++j) {
      // Bit comparison avoids scalar floating-point runtime dependencies.
      if (__builtin_bit_cast(unsigned, floats.values.data[i][j]) !=
          __builtin_bit_cast(unsigned, FloatExpected.data[i][j]))
        return 2;
      if (wide.values.data[i][j] != WideLeft.data[i][j] - WideRight.data[i][j])
        return 3;
    }
  return 0;
}
#endif

// ASM-LABEL: ztt_f32_accumulate:
// ASM: msettyp m0, a0{{$}}
// ASM-NEXT: msettyp m1, a0{{$}}
// ASM-NEXT: msettyp m2, a0{{$}}
// ASM-NEXT: asettyp acc0, a0{{$}}
// ASM-NEXT: mls.rm m0, a1{{$}}
// ASM: mss.1r m0, t0{{$}}
// ASM: mls.rm m1, a2{{$}}
// ASM: mss.1r m1, t0{{$}}
// ASM: mls.rm m2, a3{{$}}
// ASM: mss.1r m2, t0{{$}}
// ASM: mmov.a.m acc0, m2{{$}}
// ASM: call _Z10accumulateIu17__boscztt_m_f32_tu19__boscztt_acc_f32_tET0_S0_T_S1_{{$}}
// ASM: mls.1r m0, t0{{$}}
// ASM: mls.1r m1, t0{{$}}
// ASM: call _Z10accumulateIu17__boscztt_m_f32_tu19__boscztt_acc_f32_tET0_S0_T_S1_{{$}}
// ASM: mls.1r m0, t0{{$}}
// ASM: mmov.m.a m0, acc0{{$}}
// ASM-NEXT: mss.rm m0, s0{{$}}
// ASM-LABEL: _Z10accumulateIu17__boscztt_m_f32_tu19__boscztt_acc_f32_tET0_S0_T_S1_:
// ASM: mmulacc.2d acc0, m0, m1{{$}}
// ASM-NEXT: ret{{$}}
// ASM-LABEL: ztt_i64_subtract:
// ASM: msettyp m0, a3{{$}}
// ASM-NEXT: msettyp m2, a3{{$}}
// ASM-NEXT: msettyp m4, a3{{$}}
// ASM-NEXT: mls.rm m0, a1{{$}}
// ASM-NEXT: mls.rm m2, a2{{$}}
// ASM-NEXT: msub.ew m4, m2, m0{{$}}
// ASM-NEXT: mss.rm m4, a0{{$}}
// ASM-NEXT: ret{{$}}
// ASM-LABEL: main:
// ASM: ame.acquire a0, zero{{$}}
// ASM: call ztt_f32_accumulate{{$}}
// ASM: call ztt_i64_subtract{{$}}
// ASM: ame.release{{$}}

// OBJ-LABEL: <ztt_f32_accumulate>:
// OBJ: mls.rm m0, a1{{$}}
// OBJ: mss.1r m0, t0{{$}}
// OBJ: mls.rm m1, a2{{$}}
// OBJ: mss.1r m1, t0{{$}}
// OBJ: mmov.a.m acc0, m2{{$}}
// OBJ: mls.1r m0, t0{{$}}
// OBJ: mls.1r m1, t0{{$}}
// OBJ: mmov.m.a m0, acc0{{$}}
// OBJ-NEXT: {{.*}}mss.rm m0, s0{{$}}
// OBJ-LABEL: <ztt_i64_subtract>:
// OBJ: mls.rm m0, a1{{$}}
// OBJ-NEXT: {{.*}}mls.rm m2, a2{{$}}
// OBJ-NEXT: {{.*}}msub.ew m4, m2, m0{{$}}
// OBJ-NEXT: {{.*}}mss.rm m4, a0{{$}}
// OBJ-LABEL: <main>:
// OBJ: ame.acquire a0, zero{{$}}
// OBJ: ame.release{{$}}
// OBJ-LABEL: <_Z10accumulateIu17__boscztt_m_f32_tu19__boscztt_acc_f32_tET0_S0_T_S1_>:
// OBJ: mmulacc.2d acc0, m0, m1{{$}}
