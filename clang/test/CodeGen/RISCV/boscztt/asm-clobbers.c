// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64im_boscztt -O2 -S -emit-llvm %s -o - | FileCheck %s
// RUN: %clang -target riscv32 -march=rv32im_boscztt -O2 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -O2 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im -DONLY_ATTR -O2 -c %s -o %t.o

#ifndef ONLY_ATTR
#include <RISCVBoscZtt.h>
// CHECK-LABEL: @preserve(
// CHECK: asm sideeffect "", "~{m0},~{m1},~{m7},~{m15},~{acc0},~{acc3},~{memory}"
unsigned long preserve(boscztt_m_i64_t m, boscztt_acc_i32_t a) {
  __asm__ volatile("" ::: "m0", "m1", "m7", "m15", "acc0", "acc3", "memory");
  return mgettyp(m) + agettyp(a);
}

void last_registers(void) {
#if __riscv_boscztt_m_registers == 32
  __asm__ volatile("" ::: "m31", "acc3");
#else
  __asm__ volatile("" ::: "m15", "acc7");
#endif
}
#endif

// Function-specific enabling must also work when the TU lacks boscztt.
__attribute__((target("arch=+boscztt"))) void enabled_function(void) {
  __asm__ volatile("" ::: "m0", "acc0");
}
