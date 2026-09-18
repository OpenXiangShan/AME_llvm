// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -emit-obj -O0 %s -o %t.o
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -S -O2 %s -o - | FileCheck %s

#include <RISCVBoscZtt.h>

// CHECK-LABEL: move_i8:
// CHECK: mmov.m.a
// CHECK: mmov.a.m
boscztt_acc_i8_t move_i8(boscztt_m_i8_t m, boscztt_acc_i8_t acc) {
  mmov_m_a(m, acc);
  mmov_a_m(acc, m);
  return acc;
}

// CHECK-LABEL: move_i16:
// CHECK: mmov.m.a
// CHECK: mmov.a.m
boscztt_acc_i16_t move_i16(boscztt_m_i16_t m, boscztt_acc_i16_t acc) {
  mmov_m_a(m, acc);
  mmov_a_m(acc, m);
  return acc;
}

// CHECK-LABEL: move_f16:
// CHECK: mmov.m.a
// CHECK: mmov.a.m
boscztt_acc_f16_t move_f16(boscztt_m_f16_t m, boscztt_acc_f16_t acc) {
  mmov_m_a(m, acc);
  mmov_a_m(acc, m);
  return acc;
}

// CHECK-LABEL: move_bf16:
// CHECK: mmov.m.a
// CHECK: mmov.a.m
boscztt_acc_bf16_t move_bf16(boscztt_m_bf16_t m, boscztt_acc_bf16_t acc) {
  mmov_m_a(m, acc);
  mmov_a_m(acc, m);
  return acc;
}
