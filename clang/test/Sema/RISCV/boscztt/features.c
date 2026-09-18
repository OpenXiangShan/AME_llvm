// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -fsyntax-only -verify %s
void bad(void) {
  __boscztt_m_i32_t m; // expected-error {{requires the 'boscztt' extension}}
  ame_release(); // expected-error {{builtin requires}}
}
__attribute__((target("arch=+boscztt"))) void good(void) {
  __boscztt_m_i32_t m;
  msettyp(m, 32);
  mand_ew_x(m, 1, m);
}
