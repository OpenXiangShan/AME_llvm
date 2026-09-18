// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -fsyntax-only -verify %s

#include <RISCVBoscZtt.h>

void wide(void) {
  boscztt_m_i128_t m; // expected-error {{is not available in the default profile}}
  boscztt_acc_i128_t acc; // expected-error {{is not available in the default profile}}
}
