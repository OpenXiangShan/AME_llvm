// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv32 -march=rv32im_boscztt -O2 -S -emit-llvm %s -o - | FileCheck %s --check-prefix=IR
// RUN: %clang -target riscv64 -march=rv64im_boscztt -O2 -S -emit-llvm %s -o - | FileCheck %s --check-prefix=IR
// RUN: %clang -target riscv32 -march=rv32im_boscztt -O2 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -O2 -c %s -o %t.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -O2 -x c++ -std=c++17 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -O2 -x c++ -std=c++17 -c %s -o %t.o

#include <RISCVBoscZtt.h>
#ifdef __cplusplus
extern "C" {
#endif

__attribute__((noinline)) static unsigned long descriptor(boscztt_m_i32_t m) {
  return mgettyp(m);
}
__attribute__((noinline)) static unsigned long acc_descriptor(boscztt_acc_i32_t a) {
  return agettyp(a);
}
__attribute__((noinline)) static boscztt_m_i64_t clear(boscztt_m_i64_t m) {
  mzero_2d_m(m);
  return m;
}

// IR-LABEL: define {{.*}} @test(
// IR: call fastcc {{.*}} @descriptor(
// IR: call fastcc {{.*}} @acc_descriptor(
// IR: call fastcc target("riscv.ztt.matrix", i64, {{[48]}}, {{[48]}}) @clear(
unsigned long test(boscztt_m_i32_t m, boscztt_acc_i32_t a, boscztt_m_i64_t wide) {
  unsigned long result = descriptor(m) + acc_descriptor(a);
  wide = clear(wide);
  return result + mgettyp(wide);
}

// IR-LABEL: define internal fastcc {{.*}} @descriptor(
// IR: call {{.*}} @llvm.riscv.ztt.mgettyp.
// IR-LABEL: define internal fastcc {{.*}} @acc_descriptor(
// IR: call {{.*}} @llvm.riscv.ztt.agettyp.
// IR-LABEL: define internal fastcc target("riscv.ztt.matrix", i64, {{[48]}}, {{[48]}}) @clear(
// IR: call {{.*}} @llvm.riscv.ztt.mzero.2d.m.

#ifdef __cplusplus
}
#endif
