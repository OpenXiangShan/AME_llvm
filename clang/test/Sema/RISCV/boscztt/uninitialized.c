// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -Wuninitialized -fsyntax-only -verify %s
#include <RISCVBoscZtt.h>

void initialized(const void *p) {
  boscztt_m_i32_t m;
  msettyp(m, 32);
  mls_rm(m, p);
  mand_ew_x(m, 1, m);
}

void uninitialized(void) {
  boscztt_m_i32_t m; // expected-note {{variable 'm' is declared here}}
  mand_ew_x(m, 1, m); // expected-warning {{variable 'm' is uninitialized when used here}}
}
