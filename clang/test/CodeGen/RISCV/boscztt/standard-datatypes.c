// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -S -emit-llvm %s -o - | FileCheck %s
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -ffreestanding -O2 -c %s -o %t.default.o
#include <RISCVBoscZtt.h>
#if __riscv_boscztt_tile_side == 4
_Static_assert(__riscv_boscztt_max_element_bits == 128, "AME width");
#else
_Static_assert(__riscv_boscztt_max_element_bits == 64, "default width");
#endif
_Static_assert(BOSCZTT_DTYPE_FP8_E4M3 == 0x10100108, "E4M3 descriptor");
_Static_assert(BOSCZTT_DTYPE_FP8_E5M2 == 0x14300108, "E5M2 descriptor");
// CHECK-LABEL: define {{.*}} @fp8_add(
// CHECK: @llvm.riscv.ztt.msettyp.{{.*}}i64 269484296
// CHECK: @llvm.riscv.ztt.madd.ew.
void fp8_add(const void *a, const void *b, void *out) {
  boscztt_m_fp8_e4m3_t x, y, z;
  msettyp(x, BOSCZTT_DTYPE_FP8_E4M3);
  msettyp(y, BOSCZTT_DTYPE_FP8_E4M3);
  msettyp(z, BOSCZTT_DTYPE_FP8_E4M3);
  mls_rm(x, a); mls_rm(y, b);
  madd_ew(z, x, y); mss_rm(z, out);
}
void fp8_acc(const void *a, void *out) {
  boscztt_m_fp8_e5m2_t x;
  boscztt_acc_fp8_e5m2_t acc;
  msettyp(x, BOSCZTT_DTYPE_FP8_E5M2);
  asettyp(acc, BOSCZTT_DTYPE_FP8_E5M2);
  mls_rm(x, a); mmov_a_m(acc, x); mmov_m_a(x, acc); mss_rm(x, out);
}
void unsigned_sat(const void *a, void *out) {
  boscztt_m_u16_t x;
  msettyp(x, BOSCZTT_DTYPE_U16 | BOSCZTT_INT_SAT | BOSCZTT_INT_ROD);
  mls_rm(x, a); madd_ew(x, x, x); mss_rm(x, out);
}
