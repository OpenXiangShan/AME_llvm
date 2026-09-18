// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -x c++ -std=c++17 -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -x c++ -std=c++17 -fsyntax-only -verify %s

#include <RISCVBoscZtt.h>
void cleanup(void *);

void direct(void) {
  boscztt_m_i32_t m __attribute__((cleanup(cleanup))); // expected-error {{matrix register values cannot have a cleanup attribute}}
  boscztt_acc_i64_t a __attribute__((cleanup(cleanup))); // expected-error {{matrix register values cannot have a cleanup attribute}}
  int scalar __attribute__((cleanup(cleanup))) = 0;
}

#ifdef __cplusplus
template <class T> void templated(T value) {
  T m __attribute__((cleanup(cleanup))) = value; // expected-error {{matrix register values cannot have a cleanup attribute}}
}

void deduced(boscztt_m_i32_t value) {
  auto m __attribute__((cleanup(cleanup))) = value; // expected-error {{matrix register values cannot have a cleanup attribute}}
  templated(value); // expected-note {{in instantiation of function template specialization}}
  templated(42);
}
#endif
