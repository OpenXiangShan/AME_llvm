// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -DAME -fsyntax-only -verify %s

void clobbers(void) {
  __asm__ volatile("" ::: "m0", "m7", "m15", "acc0", "acc3");
#ifdef AME
  __asm__ volatile("" ::: "m16", "m31");
  __asm__ volatile("" ::: "acc4"); // expected-error {{unknown register name 'acc4' in asm}}
#else
  __asm__ volatile("" ::: "acc4", "acc7");
  __asm__ volatile("" ::: "m16"); // expected-error {{unknown register name 'm16' in asm}}
#endif
  __asm__ volatile("" ::: "m32"); // expected-error {{unknown register name 'm32' in asm}}
  __asm__ volatile("" ::: "acc8"); // expected-error {{unknown register name 'acc8' in asm}}
}
