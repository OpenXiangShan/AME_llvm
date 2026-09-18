// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O0 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -c %s -o %t.o
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O2 -x c++ -std=c++17 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -ffreestanding -O0 -x c++ -std=c++17 -c %s -o %t.o
// Executed by Inputs/run-gem5-register-data.py --source %s.

#include <RISCVBoscZtt.h>

#ifdef __cplusplus
extern "C" {
#endif
void destroy_all_matrices(void);
#ifdef __cplusplus
}
#endif

__attribute__((noinline)) static int scratch(unsigned long width) {
  unsigned input[16], m_output[16], acc_output[16];
  unsigned saved[32] __attribute__((aligned(16)));
  for (unsigned i = 0; i < 16; ++i) {
    input[i] = 1009 + 7 * i;
    m_output[i] = acc_output[i] = 0;
  }
  boscztt_m_i32_t matrix, result;
  boscztt_acc_i32_t acc;
  msettyp(matrix, 32);
  mls_rm(matrix, input);
  asettyp(acc, 32);
  mmov_a_m(acc, matrix);

  // Md2/Md3 are sticky. Restore their raw data after changing Md0, so
  // the observable clobber is only M0/M1 even for the 128-bit descriptor.
  __asm__ volatile(
      "mss.1r m2, %0\n\t"
      "mss.1r m3, %1\n\t"
      "msettyp m0, %2\n\t"
      "mls.1r m2, %0\n\t"
      "mls.1r m3, %1"
      : : "r"(saved), "r"(saved + 16), "r"(width)
      : "m0", "m1", "memory");
  mmov_a_m(acc, matrix);
  __asm__ volatile(
      "asettyp acc0, %0\n\t"
      "asettyp acc1, %0\n\t"
      "asettyp acc2, %0\n\t"
      "asettyp acc3, %0"
      : : "r"(32UL) : "acc0", "acc1", "acc2", "acc3", "memory");
  mss_rm(matrix, m_output);
  msettyp(result, 32);
  mmov_m_a(result, acc);
  mss_rm(result, acc_output);
  for (unsigned i = 0; i < 16; ++i) {
    if (m_output[i] != input[i]) return 1;
    if (acc_output[i] != input[i]) return 2;
  }
  return 0;
}

__attribute__((noinline)) static int wide(void) {
  unsigned char input[256] __attribute__((aligned(16)));
  struct {
    unsigned long long before;
    unsigned char data[256] __attribute__((aligned(16)));
    unsigned long long after;
  } m_out, a_out;
  for (unsigned i = 0; i < 256; ++i) {
    input[i] = (unsigned char)(i * 17 + 29);
    m_out.data[i] = a_out.data[i] = 0;
  }
  m_out.before = m_out.after = a_out.before = a_out.after = 0x123456789abcdefULL;
  boscztt_m_i128_t m, result;
  boscztt_acc_i128_t acc;
  msettyp(m, 0x40000080UL);
  msettyp(result, 0x40000080UL);
  asettyp(acc, 0x40000080UL);
  mls_rm(m, input);
  mmov_a_m(acc, m);
  destroy_all_matrices();
  mss_rm(m, m_out.data);
  mmov_m_a(result, acc);
  mss_rm(result, a_out.data);
  if (mgettyp(m) != 0x40000080UL || agettyp(acc) != 0x40000080UL) return 1;
  for (unsigned i = 0; i < 256; ++i)
    if (m_out.data[i] != input[i] || a_out.data[i] != input[i]) return 2;
  if (m_out.before != 0x123456789abcdefULL || m_out.after != 0x123456789abcdefULL ||
      a_out.before != 0x123456789abcdefULL || a_out.after != 0x123456789abcdefULL)
    return 3;
  return 0;
}

#define NARROW(Name, Scalar, MType, AType, Width, Pack) \
__attribute__((noinline)) static int narrow_##Name(void) { \
  Scalar lhs[16 * Pack], rhs[16 * Pack], out[16 * Pack]; \
  for (unsigned i = 0; i < 16 * Pack; ++i) { \
    lhs[i] = (Scalar)(i % 7 + 1); \
    rhs[i] = (Scalar)(i % 5 + 1); \
    out[i] = (Scalar)0xa5; \
  } \
  MType a, b, result; \
  AType acc; \
  msettyp(a, Width); msettyp(b, Width); msettyp(result, Width); \
  asettyp(acc, Width); \
  mmov_a_m(acc, result); \
  mls_rm(a, lhs); mls_rm(b, rhs); \
  mmulacc_2d(acc, a, b); \
  destroy_all_matrices(); \
  mmov_m_a(result, acc); mss_rm(result, out); \
  for (unsigned i = 0; i < 4; ++i) \
    for (unsigned j = 0; j < 4; ++j) { \
      unsigned sum = 0; \
      for (unsigned sq = 0; sq < Pack; ++sq) \
        for (unsigned k = 0; k < 4; ++k) \
          sum += lhs[sq * 16 + i * 4 + k] * rhs[sq * 16 + k * 4 + j]; \
      if (out[i * 4 + j] != (Scalar)sum) return 1; \
    } \
  for (unsigned i = 16; i < 16 * Pack; ++i) \
    if (out[i] != 0) return 2; \
  return 0; \
}

NARROW(i8, unsigned char, boscztt_m_i8_t, boscztt_acc_i8_t, 8, 4)
NARROW(i16, unsigned short, boscztt_m_i16_t, boscztt_acc_i16_t, 16, 2)

__attribute__((noinline)) static int unsupported(void) {
  unsigned input[16], m_out[16], a_out[16], m_old[16], a_old[16];
  for (unsigned i = 0; i < 16; ++i) {
    input[i] = 101 + 13 * i;
    m_out[i] = a_out[i] = m_old[i] = a_old[i] = 0xdeadbeef;
  }
  boscztt_m_i32_t m, result;
  boscztt_acc_i32_t acc;
  msettyp(m, 32); msettyp(result, 32); asettyp(acc, 32);
  mls_rm(m, input); mmov_a_m(acc, m);
  boscztt_m_i32_t backup_m = m;
  boscztt_acc_i32_t backup_a = acc;
  // Custom datatypes are unsupported by this GEM5 implementation. Both
  // setters must leave the previous data and descriptor intact on failure.
  msettyp(m, 0x80000020UL);
  asettyp(acc, 0x80000020UL);
  if (mgettyp(m) != 32 || agettyp(acc) != 32) return 1;
  mss_rm(m, m_out); mss_rm(backup_m, m_old);
  mmov_m_a(result, acc); mss_rm(result, a_out);
  mmov_m_a(result, backup_a); mss_rm(result, a_old);
  for (unsigned i = 0; i < 16; ++i)
    if (m_out[i] != input[i] || a_out[i] != input[i] ||
        m_old[i] != input[i] || a_old[i] != input[i]) return 2;
  unsigned long status;
  __asm__ volatile("csrr %0, amestatus" : "=r"(status) : : "memory");
  if (!(status & 1)) return 3;
  __asm__ volatile("csrw amestatus, zero" : : : "memory");
  return 0;
}

#ifdef __cplusplus
extern "C"
#endif
int main(void) {
  if (!(ame_acquire(0) & 1)) return 77;
  __asm__ volatile("csrw amestatus, zero" : : : "memory");
  int error;
  if ((error = scratch(64))) return 10 + error;
  if ((error = scratch(128))) return 20 + error;
  if ((error = wide())) return 30 + error;
  if ((error = narrow_i8())) return 40 + error;
  if ((error = narrow_i16())) return 50 + error;
  unsigned long status;
  __asm__ volatile("csrr %0, amestatus" : "=r"(status) : : "memory");
  if (status & 1) return 60;
  if ((error = unsupported())) return 70 + error;
  ame_release();
  return 0;
}
