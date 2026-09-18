// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-llvm -O0 %s -o %t.ll
// RUN: FileCheck %s --check-prefix=IR < %t.ll
// RUN: not grep -E '(alloca|load|store) target\("riscv.ztt' %t.ll
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -S -O1 %s -o - | FileCheck %s --check-prefix=ASM
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -emit-obj -O0 %s -o %t.o
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -debug-info-kind=limited -emit-llvm %s -o %t.debug.ll

#include <RISCVBoscZtt.h>

// Local variables, assignments and control flow must be promoted even at -O0.
// IR-LABEL: @choose(
// IR: phi target("riscv.ztt.matrix", i32, 8, 8)
// IR: ret target("riscv.ztt.matrix", i32, 8, 8)
// ASM-LABEL: choose:
// ASM: mgettyp a0, m1{{$}}
// ASM: mand.ew.x m1, a0, m1{{$}}
boscztt_m_i32_t choose(int cond, boscztt_m_i32_t a, boscztt_m_i32_t b) {
  boscztt_m_i32_t result;
  if (cond)
    result = a;
  else
    result = b;
  if (mgettyp(result) == 32)
    mand_ew_x(result, 255, result);
  return result;
}

// No scalar floating-point or vector ISA is required to hold a matrix of float.
// IR-LABEL: @float_matrix(
// IR: call target("riscv.ztt.matrix", float, 8, 8) @llvm.riscv.ztt.madd.ew.
// ASM-LABEL: float_matrix:
// ASM: madd.ew m0, m1, m2{{$}}
boscztt_m_f32_t float_matrix(boscztt_m_f32_t d, boscztt_m_f32_t a,
                              boscztt_m_f32_t b) {
  madd_ew(d, a, b);
  return d;
}

// IR-LABEL: @double_matrix(
// IR: call target("riscv.ztt.matrix", double, 8, 8) @llvm.riscv.ztt.madd.ew.
// ASM-LABEL: double_matrix:
// ASM: madd.ew m0, m2, m4{{$}}
boscztt_m_f64_t double_matrix(boscztt_m_f64_t d, boscztt_m_f64_t a,
                               boscztt_m_f64_t b) {
  madd_ew(d, a, b);
  return d;
}

// IR-LABEL: @widen(
// IR: call target("riscv.ztt.matrix", i32, 8, 8, 4) @llvm.riscv.ztt.mconv.ew.
// ASM-LABEL: widen:
// ASM: mconv.ew m0, m4{{$}}
boscztt_m_i32_x4_t widen(boscztt_m_i32_x4_t d, boscztt_m_i8_t a) {
  mconv_ew(d, a);
  return d;
}

// IR-LABEL: @packed_acc(
// IR: call target("riscv.ztt.acc", i8, 8, 8, 4) @llvm.riscv.ztt.mmov.a.m.
// ASM-LABEL: packed_acc:
// ASM: mmov.a.m acc0, m0{{$}}
boscztt_acc_i8_x4_t packed_acc(boscztt_acc_i8_x4_t d, boscztt_m_i8_t a) {
  mmov_a_m(d, a);
  return d;
}

// IR-LABEL: @bf16_matrix(
// IR: call target("riscv.ztt.matrix", bfloat, 8, 8) @llvm.riscv.ztt.mabs.ew.
// ASM-LABEL: bf16_matrix:
// ASM: mabs.ew m0, m1{{$}}
boscztt_m_bf16_t bf16_matrix(boscztt_m_bf16_t d, boscztt_m_bf16_t a) {
  mabs_ew(d, a);
  return d;
}

// IR-LABEL: @half_matrix(
// IR: call target("riscv.ztt.matrix", half, 8, 8) @llvm.riscv.ztt.mabs.ew.
// ASM-LABEL: half_matrix:
// ASM: mabs.ew m0, m1{{$}}
boscztt_m_f16_t half_matrix(boscztt_m_f16_t d, boscztt_m_f16_t a) {
  mabs_ew(d, a);
  return d;
}

// IR-LABEL: @tiny_matrix(
// IR: call target("riscv.ztt.matrix", i1, 8, 8) @llvm.riscv.ztt.mand.ew.
// ASM-LABEL: tiny_matrix:
// ASM: mand.ew m0, m1, m2{{$}}
boscztt_m_i1_t tiny_matrix(boscztt_m_i1_t d, boscztt_m_i1_t a, boscztt_m_i1_t b) {
  mand_ew(d, a, b);
  return d;
}

// IR-LABEL: @ordered_arguments(
// IR-SAME: target("riscv.ztt.matrix", i32, 8, 8) %d,
// IR-SAME: target("riscv.ztt.matrix", i32, 8, 8) %a,
// IR-SAME: target("riscv.ztt.matrix", i32, 8, 8) %b)
// IR: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.{{[^ (]+}}(target("riscv.ztt.matrix", i32, 8, 8) %d, target("riscv.ztt.matrix", i32, 8, 8) %a, target("riscv.ztt.matrix", i32, 8, 8) %b)
// ASM-LABEL: ordered_arguments:
// ASM: msub.ew m0, m1, m2{{$}}
boscztt_m_i32_t ordered_arguments(boscztt_m_i32_t d, boscztt_m_i32_t a,
                                    boscztt_m_i32_t b) {
  msub_ew(d, a, b);
  return d;
}
