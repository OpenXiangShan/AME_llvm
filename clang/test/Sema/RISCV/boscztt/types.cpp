// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -std=c++17 -fsyntax-only -verify %s
#include <RISCVBoscZtt.h>
void reference(boscztt_m_i32_t &); // expected-error {{cannot be used through pointers or references}}
void rvalue_reference(boscztt_m_i32_t &&); // expected-error {{cannot be used through pointers or references}}
void volatile_parameter(volatile boscztt_m_i32_t m); // expected-error {{register types cannot be volatile}}
void errors(boscztt_m_i32_t m) {
  (void)boscztt_m_i32_t(); // expected-error {{matrix initialization requires msettyp or asettyp}}
  boscztt_m_i32_t empty{}; // expected-error {{initializer for sizeless type}}
  auto &&forward = m; // expected-error {{cannot be used through pointers or references}}
  auto &ref = m; // expected-error {{cannot be used through pointers or references}}
  auto *ptr = &m; // expected-error {{cannot be used through pointers or references}}
  (true ? m : m) = m; // expected-error {{destination must be a writable local matrix variable}}
  auto capture = [m]() {}; // expected-error {{matrix register values cannot be captured}}
}

decltype(auto) deduced_reference(boscztt_m_i32_t m) {
  return (m); // expected-error {{cannot be used through pointers or references}}
}

template <class T> void forwarding_reference(T &&m) {} // expected-note {{candidate template ignored: substitution failure}}
template <class T> void lvalue_reference(T &m) {} // expected-note {{candidate template ignored: substitution failure}}
void template_references(boscztt_m_i32_t m) {
  forwarding_reference(m); // expected-error {{no matching function}}
  lvalue_reference(m); // expected-error {{no matching function}}
  auto capture = [n = m]() {}; // expected-error {{field has sizeless type}}
}
