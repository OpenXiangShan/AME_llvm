// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O0 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -c %s -o %t.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -x c++ -std=c++17 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O0 -x c++ -std=c++17 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -S -emit-llvm %s -o - | FileCheck %s
// CHECK-DAG: call fastcc target("riscv.ztt.matrix", i64, 4, 4) @choose(
// CHECK-DAG: call fastcc target("riscv.ztt.matrix", i32, 4, 4, 32) @choose_full(
// CHECK-DAG: select i1 {{.*}}, target("riscv.ztt.matrix", i32, 4, 4, 32)
//
// Executed by Inputs/run-gem5-register-data.py. Check every element across
// destructive callees, full-file selects, and explicit inline-asm clobbers.

#include <RISCVBoscZtt.h>

#if __riscv_boscztt_tile_side != 4 || __riscv_boscztt_m_registers != 32
#error This execution fixture requires the ame-gem5 profile
#endif
#ifdef __cplusplus
extern "C" {
#endif
void destroy_all_matrices(void);
unsigned long check_full_group(const int *, const int *, int *, unsigned long);
#ifdef __cplusplus
}
#endif

#define PRESERVE(Name, MType, AType, Scalar, Elements, Descriptor) \
__attribute__((noinline)) static unsigned long preserve_##Name( \
    Scalar *out, const Scalar *in) { \
  MType m, result; \
  AType acc; \
  msettyp(m, Descriptor); \
  msettyp(result, Descriptor); \
  asettyp(acc, Descriptor); \
  mls_rm(m, in); \
  mmov_a_m(acc, m); \
  destroy_all_matrices(); \
  mmov_m_a(result, acc); \
  mss_rm(result, out); \
  return agettyp(acc); \
} \
static int check_##Name(void) { \
  Scalar input[Elements]; \
  struct { unsigned long long before; Scalar data[Elements]; \
           unsigned long long after; } output; \
  output.before = output.after = 0x123456789abcdefULL; \
  for (int i = 0; i < Elements; ++i) { \
    input[i] = (Scalar)(i*7-131); \
    if (sizeof(Scalar) == 8) \
      input[i] = (Scalar)(((long long)i-9)*0x10000000000LL + 31*i); \
    output.data[i] = 0; \
  } \
  if (preserve_##Name(output.data, input) != Descriptor) return 1; \
  if (output.before != 0x123456789abcdefULL || \
      output.after != 0x123456789abcdefULL) return 2; \
  for (int i = 0; i < Elements; ++i) \
    if (output.data[i] != input[i]) return 3; \
  return 0; \
}

PRESERVE(acc8, boscztt_m_i8_t, boscztt_acc_i8_x4_t, signed char, 64, 0x40000008UL)
PRESERVE(acc16, boscztt_m_i16_t, boscztt_acc_i16_x2_t, short, 32, 0x40000010UL)
PRESERVE(acc32, boscztt_m_i32_t, boscztt_acc_i32_t, int, 16, 0x40000020UL)
PRESERVE(acc64, boscztt_m_i64_t, boscztt_acc_i64_t, long long, 16, 0x40000040UL)

__attribute__((noinline)) static boscztt_m_i64_t choose(
    int c, boscztt_m_i64_t a, boscztt_m_i64_t b) {
  return c ? a : b;
}

__attribute__((noinline)) static int mixed(int c) {
  long long input64[16], output64[16];
  int input32[16], output32[16];
  signed char input8[64], output8[64];
  for (int i = 0; i < 16; ++i) {
    input64[i] = ((long long)i-9)*0x10000000000LL + 31*i;
    input32[i] = 97*i-1024;
  }
  for (int i = 0; i < 64; ++i) input8[i]=(signed char)(i*3-97);
  boscztt_m_i64_t m64;
  boscztt_m_i8_t m8;
  boscztt_m_i32_t m32;
  boscztt_acc_i32_t acc;
  msettyp(m64, 0x40000040UL); mls_rm(m64, input64);
  msettyp(m8, 0x40000008UL); mls_rm(m8, input8);
  msettyp(m32, 0x40000020UL); mls_rm(m32, input32);
  asettyp(acc, 0x40000020UL); mmov_a_m(acc, m32);
  destroy_all_matrices();
  m64 = choose(c, m64, m64);
  mss_rm(m64, output64); mss_rm(m8, output8);
  mmov_m_a(m32, acc); mss_rm(m32, output32);
  for (int i = 0; i < 16; ++i)
    if (input64[i] != output64[i] || input32[i] != output32[i]) return 1;
  for (int i = 0; i < 64; ++i) if (input8[i] != output8[i]) return 2;
  return 0;
}


#ifdef __cplusplus
extern "C" {
#endif
boscztt_m_i32_x32_t make_full_a(void);
boscztt_m_i32_x32_t make_full_b(void);
#ifdef __cplusplus
}
#endif
__attribute__((noinline)) static boscztt_m_i32_x32_t choose_full(
    unsigned long c, boscztt_m_i32_x32_t a) {
  boscztt_m_i32_x32_t b = make_full_b();
  return c ? a : b;
}
#ifdef __cplusplus
extern "C"
#endif
boscztt_m_i32_x32_t select_full(unsigned long c) {
  return choose_full(c, make_full_a());
}

static int full_group(void) {
  int a[512], b[512];
  struct { unsigned long long before; int data[512]; unsigned long long after; } out;
  out.before = out.after = 0x123456789abcdefULL;
  for (int i = 0; i < 512; ++i) { a[i]=i*37-10000; b[i]=i*17+9123; }
  for (unsigned long c = 0; c < 2; ++c) {
    unsigned long descriptor = check_full_group(a, b, out.data, c);
    if (descriptor != (c ? 0x40000020UL : 32UL)) return 1;
    if (out.before != 0x123456789abcdefULL || out.after != 0x123456789abcdefULL) return 2;
    for (int i = 0; i < 512; ++i) if (out.data[i] != (c ? a[i] : b[i])) return 3;
  }
  return 0;
}

__attribute__((noinline)) static int asm_clobbers(void) {
  long long in[16], out[16];
  for (int i = 0; i < 16; ++i) in[i]=((long long)i-9)*0x10000000000LL+37*i;
  boscztt_m_i64_t m, result;
  boscztt_acc_i64_t a;
  msettyp(m, 0x40000040UL); mls_rm(m, in);
  msettyp(result, 0x40000040UL);
  asettyp(a, 0x40000040UL); mmov_a_m(a, m);
  __asm__ volatile(
      "msettyp m0, %0\n\t"
      "msettyp m1, %0\n\t"
      "msettyp m2, %0\n\t"
      "msettyp m3, %0\n\t"
      "msettyp m4, %0\n\t"
      "msettyp m5, %0\n\t"
      "msettyp m6, %0\n\t"
      "msettyp m7, %0\n\t"
      "msettyp m8, %0\n\t"
      "msettyp m9, %0\n\t"
      "msettyp m10, %0\n\t"
      "msettyp m11, %0\n\t"
      "msettyp m12, %0\n\t"
      "msettyp m13, %0\n\t"
      "msettyp m14, %0\n\t"
      "msettyp m15, %0\n\t"
      "msettyp m16, %0\n\t"
      "msettyp m17, %0\n\t"
      "msettyp m18, %0\n\t"
      "msettyp m19, %0\n\t"
      "msettyp m20, %0\n\t"
      "msettyp m21, %0\n\t"
      "msettyp m22, %0\n\t"
      "msettyp m23, %0\n\t"
      "msettyp m24, %0\n\t"
      "msettyp m25, %0\n\t"
      "msettyp m26, %0\n\t"
      "msettyp m27, %0\n\t"
      "msettyp m28, %0\n\t"
      "msettyp m29, %0\n\t"
      "msettyp m30, %0\n\t"
      "msettyp m31, %0\n\t"
      "asettyp acc0, %0\n\t"
      "asettyp acc1, %0\n\t"
      "asettyp acc2, %0\n\t"
      "asettyp acc3, %0\n\t"
      :
      : "r"(32UL)
      : "m0", "m1", "m2", "m3", "m4", "m5", "m6", "m7",
        "m8", "m9", "m10", "m11", "m12", "m13", "m14", "m15",
        "m16", "m17", "m18", "m19", "m20", "m21", "m22", "m23",
        "m24", "m25", "m26", "m27", "m28", "m29", "m30", "m31",
        "acc0", "acc1", "acc2", "acc3", "memory");
  mss_rm(m, out);
  for (int i = 0; i < 16; ++i) if (out[i] != in[i]) return 1;
  if (mgettyp(m) != 0x40000040UL || agettyp(a) != 0x40000040UL) return 2;
  mmov_m_a(result, a); mss_rm(result, out);
  for (int i = 0; i < 16; ++i) if (out[i] != in[i]) return 3;
  return 0;
}

#ifdef __cplusplus
extern "C"
#endif
int main(void) {
  if (!(ame_acquire(0) & 1)) return 77;
  __asm__ volatile("csrw amestatus, zero" ::: "memory");
  int error;
  if ((error = check_acc8())) return 10 + error;
  if ((error = check_acc16())) return 20 + error;
  if ((error = check_acc32())) return 30 + error;
  if ((error = check_acc64())) return 40 + error;
  if ((error = mixed(0))) return 50 + error;
  if ((error = mixed(1))) return 60 + error;
  if ((error = full_group())) return 70 + error;
  if ((error = asm_clobbers())) return 80 + error;
  unsigned long status;
  __asm__ volatile("csrr %0, amestatus" : "=r"(status) : : "memory");
  ame_release();
  return status & 1 ? 77 : 0;
}
