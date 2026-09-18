// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -std=c++17 -emit-llvm %s -o - | FileCheck %s
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -std=c++17 -x c++-header -emit-pch %s -o %t.pch
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -std=c++17 -include-pch %t.pch -emit-llvm -x c++ /dev/null -o - | FileCheck %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -std=c++17 -emit-obj %s -o %t.o

#include <RISCVBoscZtt.h>

// Distinct builtin types participate in overload resolution and name mangling.
// CHECK-LABEL: define {{.*}} @_Z4copyu17__boscztt_m_i32_t(
boscztt_m_i32_t copy(boscztt_m_i32_t x) { return x; }
// CHECK-LABEL: define {{.*}} @_Z4copyu17__boscztt_m_f32_t(
boscztt_m_f32_t copy(boscztt_m_f32_t x) { return x; }
// CHECK-LABEL: define {{.*}} @_Z4copyu19__boscztt_acc_i32_t(
boscztt_acc_i32_t copy(boscztt_acc_i32_t x) { return x; }

// A complete 16-register group also survives C++ mangling and PCH round trips.
// CHECK-LABEL: define {{.*}} @_Z4copyu21__boscztt_m_i32_x16_t(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8, 16)
boscztt_m_i32_x16_t copy(boscztt_m_i32_x16_t x) { return x; }

// CHECK-LABEL: @templated(
extern "C" boscztt_m_i32_t templated(boscztt_m_i32_t x);
template<class T> T combine(T d, T a) {
  mand_ew_x(d, 7, a);
  return d;
}
boscztt_m_i32_t templated(boscztt_m_i32_t x) {
  auto d = copy(x);
  return combine(d, x);
}
// CHECK: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.x.

// Deducing a value type remains valid; only reference binding is disallowed.
// CHECK-LABEL: define {{.*}} @deduced_value(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8)
extern "C" decltype(auto) deduced_value(boscztt_m_i32_t x) { return x; }
