// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -fsyntax-only -verify %s

#include <RISCVBoscZtt.h>

// Four ACC registers are available in the AME_gem5 profile. An eight-register
// narrow ACC group is therefore rejected at the C type boundary.
boscztt_acc_i4_x8_t too_many_acc(boscztt_acc_i4_x8_t value) { // expected-error 2 {{is not available in the ame-gem5 profile}}
  return value; // expected-error {{is not available in the ame-gem5 profile}}
}

// The default single-square i4 ACC also needs an eight-register spill group.
void narrow(void) {
  boscztt_acc_i4_t acc; // expected-error {{is not available in the ame-gem5 profile}}
}
