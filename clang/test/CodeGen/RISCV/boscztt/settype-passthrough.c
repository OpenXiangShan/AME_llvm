// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-llvm -O1 %s -o - | FileCheck %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -emit-obj -O0 %s -o %t.o

#include <RISCVBoscZtt.h>

// CHECK-LABEL: @set_m(
// CHECK-SAME: target("riscv.ztt.matrix", i32, 8, 8) [[M:%[^,]+]], i64 {{[^%]*}}[[D:%[^)]+]])
// CHECK: @llvm.riscv.ztt.msettyp.{{[^ (]+}}(target("riscv.ztt.matrix", i32, 8, 8) [[M]], i64 [[D]])
boscztt_m_i32_t set_m(boscztt_m_i32_t m, unsigned long descriptor) {
  msettyp(m, descriptor);
  return m;
}

// CHECK-LABEL: @set_a(
// CHECK-SAME: target("riscv.ztt.acc", i32, 8, 8) [[A:%[^,]+]], i64 {{[^%]*}}[[D:%[^)]+]])
// CHECK: @llvm.riscv.ztt.asettyp.{{[^ (]+}}(target("riscv.ztt.acc", i32, 8, 8) [[A]], i64 [[D]])
boscztt_acc_i32_t set_a(boscztt_acc_i32_t acc, unsigned long descriptor) {
  asettyp(acc, descriptor);
  return acc;
}
