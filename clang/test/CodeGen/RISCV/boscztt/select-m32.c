// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -O2 -S -emit-llvm %s -o - | FileCheck %s
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -O2 -c %s -o %t.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -O2 -c %s -o %t.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -O0 -x c++ -std=c++17 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -O2 -x c++ -std=c++17 -c %s -o %t.o

#include <RISCVBoscZtt.h>

// CHECK-LABEL: @select_m32(
// CHECK: select i1 {{.*}}, target("riscv.ztt.matrix", i32, 4, 4, 32)
boscztt_m_i32_x32_t select_m32(int condition) {
  boscztt_m_i32_x32_t a, b;
  msettyp(a, 32);
  msettyp(b, 0x40000020UL);
  return condition ? a : b;
}
