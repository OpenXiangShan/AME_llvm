// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-llvm %s -o - | FileCheck %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -emit-obj %s -o %t.o
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-obj %s -o %t.o
#include <RISCVBoscZtt.h>

// Every public type has a distinct matrix IR identity and direct register ABI.

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i1, 8, 8) @identity_boscztt_m_i1(
// CHECK: ret target("riscv.ztt.matrix", i1, 8, 8)
boscztt_m_i1_t identity_boscztt_m_i1(boscztt_m_i1_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i1, 8, 8, 64) @identity_boscztt_m_i1_x64(
// CHECK: ret target("riscv.ztt.matrix", i1, 8, 8, 64)
boscztt_m_i1_x64_t identity_boscztt_m_i1_x64(boscztt_m_i1_x64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i1, 8, 8, 128) @identity_boscztt_m_i1_x128(
// CHECK: ret target("riscv.ztt.matrix", i1, 8, 8, 128)
boscztt_m_i1_x128_t identity_boscztt_m_i1_x128(boscztt_m_i1_x128_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i1, 8, 8, 256) @identity_boscztt_m_i1_x256(
// CHECK: ret target("riscv.ztt.matrix", i1, 8, 8, 256)
boscztt_m_i1_x256_t identity_boscztt_m_i1_x256(boscztt_m_i1_x256_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i1, 8, 8, 512) @identity_boscztt_m_i1_x512(
// CHECK: ret target("riscv.ztt.matrix", i1, 8, 8, 512)
boscztt_m_i1_x512_t identity_boscztt_m_i1_x512(boscztt_m_i1_x512_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i2, 8, 8) @identity_boscztt_m_i2(
// CHECK: ret target("riscv.ztt.matrix", i2, 8, 8)
boscztt_m_i2_t identity_boscztt_m_i2(boscztt_m_i2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i2, 8, 8, 32) @identity_boscztt_m_i2_x32(
// CHECK: ret target("riscv.ztt.matrix", i2, 8, 8, 32)
boscztt_m_i2_x32_t identity_boscztt_m_i2_x32(boscztt_m_i2_x32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i2, 8, 8, 64) @identity_boscztt_m_i2_x64(
// CHECK: ret target("riscv.ztt.matrix", i2, 8, 8, 64)
boscztt_m_i2_x64_t identity_boscztt_m_i2_x64(boscztt_m_i2_x64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i2, 8, 8, 128) @identity_boscztt_m_i2_x128(
// CHECK: ret target("riscv.ztt.matrix", i2, 8, 8, 128)
boscztt_m_i2_x128_t identity_boscztt_m_i2_x128(boscztt_m_i2_x128_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i2, 8, 8, 256) @identity_boscztt_m_i2_x256(
// CHECK: ret target("riscv.ztt.matrix", i2, 8, 8, 256)
boscztt_m_i2_x256_t identity_boscztt_m_i2_x256(boscztt_m_i2_x256_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i4, 8, 8) @identity_boscztt_m_i4(
// CHECK: ret target("riscv.ztt.matrix", i4, 8, 8)
boscztt_m_i4_t identity_boscztt_m_i4(boscztt_m_i4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i4, 8, 8, 16) @identity_boscztt_m_i4_x16(
// CHECK: ret target("riscv.ztt.matrix", i4, 8, 8, 16)
boscztt_m_i4_x16_t identity_boscztt_m_i4_x16(boscztt_m_i4_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i4, 8, 8, 32) @identity_boscztt_m_i4_x32(
// CHECK: ret target("riscv.ztt.matrix", i4, 8, 8, 32)
boscztt_m_i4_x32_t identity_boscztt_m_i4_x32(boscztt_m_i4_x32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i4, 8, 8, 64) @identity_boscztt_m_i4_x64(
// CHECK: ret target("riscv.ztt.matrix", i4, 8, 8, 64)
boscztt_m_i4_x64_t identity_boscztt_m_i4_x64(boscztt_m_i4_x64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i4, 8, 8, 128) @identity_boscztt_m_i4_x128(
// CHECK: ret target("riscv.ztt.matrix", i4, 8, 8, 128)
boscztt_m_i4_x128_t identity_boscztt_m_i4_x128(boscztt_m_i4_x128_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i8, 8, 8) @identity_boscztt_m_i8(
// CHECK: ret target("riscv.ztt.matrix", i8, 8, 8)
boscztt_m_i8_t identity_boscztt_m_i8(boscztt_m_i8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i8, 8, 8, 8) @identity_boscztt_m_i8_x8(
// CHECK: ret target("riscv.ztt.matrix", i8, 8, 8, 8)
boscztt_m_i8_x8_t identity_boscztt_m_i8_x8(boscztt_m_i8_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i8, 8, 8, 16) @identity_boscztt_m_i8_x16(
// CHECK: ret target("riscv.ztt.matrix", i8, 8, 8, 16)
boscztt_m_i8_x16_t identity_boscztt_m_i8_x16(boscztt_m_i8_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i8, 8, 8, 32) @identity_boscztt_m_i8_x32(
// CHECK: ret target("riscv.ztt.matrix", i8, 8, 8, 32)
boscztt_m_i8_x32_t identity_boscztt_m_i8_x32(boscztt_m_i8_x32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i8, 8, 8, 64) @identity_boscztt_m_i8_x64(
// CHECK: ret target("riscv.ztt.matrix", i8, 8, 8, 64)
boscztt_m_i8_x64_t identity_boscztt_m_i8_x64(boscztt_m_i8_x64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i16, 8, 8) @identity_boscztt_m_i16(
// CHECK: ret target("riscv.ztt.matrix", i16, 8, 8)
boscztt_m_i16_t identity_boscztt_m_i16(boscztt_m_i16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i16, 8, 8, 4) @identity_boscztt_m_i16_x4(
// CHECK: ret target("riscv.ztt.matrix", i16, 8, 8, 4)
boscztt_m_i16_x4_t identity_boscztt_m_i16_x4(boscztt_m_i16_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i16, 8, 8, 8) @identity_boscztt_m_i16_x8(
// CHECK: ret target("riscv.ztt.matrix", i16, 8, 8, 8)
boscztt_m_i16_x8_t identity_boscztt_m_i16_x8(boscztt_m_i16_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i16, 8, 8, 16) @identity_boscztt_m_i16_x16(
// CHECK: ret target("riscv.ztt.matrix", i16, 8, 8, 16)
boscztt_m_i16_x16_t identity_boscztt_m_i16_x16(boscztt_m_i16_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i16, 8, 8, 32) @identity_boscztt_m_i16_x32(
// CHECK: ret target("riscv.ztt.matrix", i16, 8, 8, 32)
boscztt_m_i16_x32_t identity_boscztt_m_i16_x32(boscztt_m_i16_x32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i32, 8, 8) @identity_boscztt_m_i32(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8)
boscztt_m_i32_t identity_boscztt_m_i32(boscztt_m_i32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i32, 8, 8, 2) @identity_boscztt_m_i32_x2(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8, 2)
boscztt_m_i32_x2_t identity_boscztt_m_i32_x2(boscztt_m_i32_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i32, 8, 8, 4) @identity_boscztt_m_i32_x4(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8, 4)
boscztt_m_i32_x4_t identity_boscztt_m_i32_x4(boscztt_m_i32_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i32, 8, 8, 8) @identity_boscztt_m_i32_x8(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8, 8)
boscztt_m_i32_x8_t identity_boscztt_m_i32_x8(boscztt_m_i32_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i32, 8, 8, 16) @identity_boscztt_m_i32_x16(
// CHECK: ret target("riscv.ztt.matrix", i32, 8, 8, 16)
boscztt_m_i32_x16_t identity_boscztt_m_i32_x16(boscztt_m_i32_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i64, 8, 8) @identity_boscztt_m_i64(
// CHECK: ret target("riscv.ztt.matrix", i64, 8, 8)
boscztt_m_i64_t identity_boscztt_m_i64(boscztt_m_i64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i64, 8, 8, 2) @identity_boscztt_m_i64_x2(
// CHECK: ret target("riscv.ztt.matrix", i64, 8, 8, 2)
boscztt_m_i64_x2_t identity_boscztt_m_i64_x2(boscztt_m_i64_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i64, 8, 8, 4) @identity_boscztt_m_i64_x4(
// CHECK: ret target("riscv.ztt.matrix", i64, 8, 8, 4)
boscztt_m_i64_x4_t identity_boscztt_m_i64_x4(boscztt_m_i64_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", i64, 8, 8, 8) @identity_boscztt_m_i64_x8(
// CHECK: ret target("riscv.ztt.matrix", i64, 8, 8, 8)
boscztt_m_i64_x8_t identity_boscztt_m_i64_x8(boscztt_m_i64_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", half, 8, 8) @identity_boscztt_m_f16(
// CHECK: ret target("riscv.ztt.matrix", half, 8, 8)
boscztt_m_f16_t identity_boscztt_m_f16(boscztt_m_f16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", half, 8, 8, 4) @identity_boscztt_m_f16_x4(
// CHECK: ret target("riscv.ztt.matrix", half, 8, 8, 4)
boscztt_m_f16_x4_t identity_boscztt_m_f16_x4(boscztt_m_f16_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", half, 8, 8, 8) @identity_boscztt_m_f16_x8(
// CHECK: ret target("riscv.ztt.matrix", half, 8, 8, 8)
boscztt_m_f16_x8_t identity_boscztt_m_f16_x8(boscztt_m_f16_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", half, 8, 8, 16) @identity_boscztt_m_f16_x16(
// CHECK: ret target("riscv.ztt.matrix", half, 8, 8, 16)
boscztt_m_f16_x16_t identity_boscztt_m_f16_x16(boscztt_m_f16_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", half, 8, 8, 32) @identity_boscztt_m_f16_x32(
// CHECK: ret target("riscv.ztt.matrix", half, 8, 8, 32)
boscztt_m_f16_x32_t identity_boscztt_m_f16_x32(boscztt_m_f16_x32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", bfloat, 8, 8) @identity_boscztt_m_bf16(
// CHECK: ret target("riscv.ztt.matrix", bfloat, 8, 8)
boscztt_m_bf16_t identity_boscztt_m_bf16(boscztt_m_bf16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", bfloat, 8, 8, 4) @identity_boscztt_m_bf16_x4(
// CHECK: ret target("riscv.ztt.matrix", bfloat, 8, 8, 4)
boscztt_m_bf16_x4_t identity_boscztt_m_bf16_x4(boscztt_m_bf16_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", bfloat, 8, 8, 8) @identity_boscztt_m_bf16_x8(
// CHECK: ret target("riscv.ztt.matrix", bfloat, 8, 8, 8)
boscztt_m_bf16_x8_t identity_boscztt_m_bf16_x8(boscztt_m_bf16_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", bfloat, 8, 8, 16) @identity_boscztt_m_bf16_x16(
// CHECK: ret target("riscv.ztt.matrix", bfloat, 8, 8, 16)
boscztt_m_bf16_x16_t identity_boscztt_m_bf16_x16(boscztt_m_bf16_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", bfloat, 8, 8, 32) @identity_boscztt_m_bf16_x32(
// CHECK: ret target("riscv.ztt.matrix", bfloat, 8, 8, 32)
boscztt_m_bf16_x32_t identity_boscztt_m_bf16_x32(boscztt_m_bf16_x32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", float, 8, 8) @identity_boscztt_m_f32(
// CHECK: ret target("riscv.ztt.matrix", float, 8, 8)
boscztt_m_f32_t identity_boscztt_m_f32(boscztt_m_f32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", float, 8, 8, 2) @identity_boscztt_m_f32_x2(
// CHECK: ret target("riscv.ztt.matrix", float, 8, 8, 2)
boscztt_m_f32_x2_t identity_boscztt_m_f32_x2(boscztt_m_f32_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", float, 8, 8, 4) @identity_boscztt_m_f32_x4(
// CHECK: ret target("riscv.ztt.matrix", float, 8, 8, 4)
boscztt_m_f32_x4_t identity_boscztt_m_f32_x4(boscztt_m_f32_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", float, 8, 8, 8) @identity_boscztt_m_f32_x8(
// CHECK: ret target("riscv.ztt.matrix", float, 8, 8, 8)
boscztt_m_f32_x8_t identity_boscztt_m_f32_x8(boscztt_m_f32_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", float, 8, 8, 16) @identity_boscztt_m_f32_x16(
// CHECK: ret target("riscv.ztt.matrix", float, 8, 8, 16)
boscztt_m_f32_x16_t identity_boscztt_m_f32_x16(boscztt_m_f32_x16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", double, 8, 8) @identity_boscztt_m_f64(
// CHECK: ret target("riscv.ztt.matrix", double, 8, 8)
boscztt_m_f64_t identity_boscztt_m_f64(boscztt_m_f64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", double, 8, 8, 2) @identity_boscztt_m_f64_x2(
// CHECK: ret target("riscv.ztt.matrix", double, 8, 8, 2)
boscztt_m_f64_x2_t identity_boscztt_m_f64_x2(boscztt_m_f64_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", double, 8, 8, 4) @identity_boscztt_m_f64_x4(
// CHECK: ret target("riscv.ztt.matrix", double, 8, 8, 4)
boscztt_m_f64_x4_t identity_boscztt_m_f64_x4(boscztt_m_f64_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.matrix", double, 8, 8, 8) @identity_boscztt_m_f64_x8(
// CHECK: ret target("riscv.ztt.matrix", double, 8, 8, 8)
boscztt_m_f64_x8_t identity_boscztt_m_f64_x8(boscztt_m_f64_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i4, 8, 8) @identity_boscztt_acc_i4(
// CHECK: ret target("riscv.ztt.acc", i4, 8, 8)
boscztt_acc_i4_t identity_boscztt_acc_i4(boscztt_acc_i4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i4, 8, 8, 8) @identity_boscztt_acc_i4_x8(
// CHECK: ret target("riscv.ztt.acc", i4, 8, 8, 8)
boscztt_acc_i4_x8_t identity_boscztt_acc_i4_x8(boscztt_acc_i4_x8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i8, 8, 8) @identity_boscztt_acc_i8(
// CHECK: ret target("riscv.ztt.acc", i8, 8, 8)
boscztt_acc_i8_t identity_boscztt_acc_i8(boscztt_acc_i8_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i8, 8, 8, 4) @identity_boscztt_acc_i8_x4(
// CHECK: ret target("riscv.ztt.acc", i8, 8, 8, 4)
boscztt_acc_i8_x4_t identity_boscztt_acc_i8_x4(boscztt_acc_i8_x4_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i16, 8, 8) @identity_boscztt_acc_i16(
// CHECK: ret target("riscv.ztt.acc", i16, 8, 8)
boscztt_acc_i16_t identity_boscztt_acc_i16(boscztt_acc_i16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i16, 8, 8, 2) @identity_boscztt_acc_i16_x2(
// CHECK: ret target("riscv.ztt.acc", i16, 8, 8, 2)
boscztt_acc_i16_x2_t identity_boscztt_acc_i16_x2(boscztt_acc_i16_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i32, 8, 8) @identity_boscztt_acc_i32(
// CHECK: ret target("riscv.ztt.acc", i32, 8, 8)
boscztt_acc_i32_t identity_boscztt_acc_i32(boscztt_acc_i32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", i64, 8, 8) @identity_boscztt_acc_i64(
// CHECK: ret target("riscv.ztt.acc", i64, 8, 8)
boscztt_acc_i64_t identity_boscztt_acc_i64(boscztt_acc_i64_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", half, 8, 8) @identity_boscztt_acc_f16(
// CHECK: ret target("riscv.ztt.acc", half, 8, 8)
boscztt_acc_f16_t identity_boscztt_acc_f16(boscztt_acc_f16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", half, 8, 8, 2) @identity_boscztt_acc_f16_x2(
// CHECK: ret target("riscv.ztt.acc", half, 8, 8, 2)
boscztt_acc_f16_x2_t identity_boscztt_acc_f16_x2(boscztt_acc_f16_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", bfloat, 8, 8) @identity_boscztt_acc_bf16(
// CHECK: ret target("riscv.ztt.acc", bfloat, 8, 8)
boscztt_acc_bf16_t identity_boscztt_acc_bf16(boscztt_acc_bf16_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", bfloat, 8, 8, 2) @identity_boscztt_acc_bf16_x2(
// CHECK: ret target("riscv.ztt.acc", bfloat, 8, 8, 2)
boscztt_acc_bf16_x2_t identity_boscztt_acc_bf16_x2(boscztt_acc_bf16_x2_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", float, 8, 8) @identity_boscztt_acc_f32(
// CHECK: ret target("riscv.ztt.acc", float, 8, 8)
boscztt_acc_f32_t identity_boscztt_acc_f32(boscztt_acc_f32_t x) { return x; }

// CHECK-LABEL: define {{.*}}target("riscv.ztt.acc", double, 8, 8) @identity_boscztt_acc_f64(
// CHECK: ret target("riscv.ztt.acc", double, 8, 8)
boscztt_acc_f64_t identity_boscztt_acc_f64(boscztt_acc_f64_t x) { return x; }
