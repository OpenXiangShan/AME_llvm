// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -fsyntax-only -verify %s
#include <RISCVBoscZtt.h>

boscztt_m_i32_t global; // expected-error {{non-local variable with sizeless type}}
struct Bad { boscztt_m_i32_t member; }; // expected-error {{field has sizeless type}}
boscztt_m_i32_t array[2]; // expected-error {{array has sizeless element type}}
boscztt_m_i32_t *ptr; // expected-error {{cannot be used through pointers or references}}

void errors(boscztt_m_i32_t m, boscztt_acc_i32_t acc,
            boscztt_m_i8_t narrow, boscztt_m_i64_t wide, void *p) {
  const boscztt_m_i32_t c = m;
  msettyp(m); // expected-error {{too few arguments}}
  msettyp(m, 8); // expected-error {{descriptor width must match}}
  msettyp(acc, 32); // expected-error {{expected an M matrix}}
  asettyp(m, 32); // expected-error {{expected an ACC matrix}}
  msettyp(c, 32); // expected-error {{destination must be a writable local matrix variable}}
  mand_ew_x(m, 1.0, m); // expected-error {{expected an integer scalar}}
  mand_ew_x(m, 0, acc); // expected-error {{expected an M matrix}}
  mand_ew_x(0, 0, m); // expected-error {{expected an M matrix}}
  mgettyp(m, m); // expected-error {{too many arguments}}
  mls_rm(m, 42); // expected-error {{expected an object pointer}}
  mss_rm(m, (const int *)p); // expected-error {{store requires a pointer to writable memory}}
  mconv_ew(m, narrow); // expected-error {{elementwise operands must contain max(pack_factor) squares}}
  mls_1r(wide, p); // expected-error {{raw register operations require exactly one M register}}
  mmov_a_m(acc, narrow); // expected-error {{M/ACC moves require matching complete packed-square groups}}
  mpack_ew_x(m, 0, m); // expected-error {{pack/unpack requires one packed register}}
  mrowzip_ew(m, m); // expected-error {{destinations must be distinct variables}}
  mrowzip_ew(m, wide); // expected-error {{requires two identical non-packed square types}}
  mrowzip_ew(narrow, narrow); // expected-error {{requires two identical non-packed square types}}
  (void)&m; // expected-error {{cannot be used through pointers or references}}
  (void)sizeof(m); // expected-error {{invalid application of 'sizeof' to sizeless type}}
  _Atomic(boscztt_m_i32_t) atomic; // expected-error {{cannot be applied to sizeless type}}
  boscztt_m_i32_t empty = {}; // expected-error {{initializer for sizeless type}}
  volatile boscztt_m_i32_t v; // expected-error {{register types cannot be volatile}}
  m = acc; // expected-error {{incompatible type}}
  __asm__("" : "=r"(m)); // expected-error {{invalid type}}
  __asm__("" : : "r"(m)); // expected-error {{invalid type}}
  (void)(m + m); // expected-error {{invalid operands to binary expression}}
}
