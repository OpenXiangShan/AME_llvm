; RUN: opt -S -passes=instcombine %s | FileCheck %s
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "riscv64"

; CHECK-LABEL: @matrix_i32_4_default(
; CHECK-NEXT: ret i64 64
define i64 @matrix_i32_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i32, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i1_4_default(
; CHECK-NEXT: ret i64 64
define i64 @matrix_i1_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i1, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i4_4_default(
; CHECK-NEXT: ret i64 64
define i64 @matrix_i4_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i4, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i16_4_default(
; CHECK-NEXT: ret i64 64
define i64 @matrix_i16_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i16, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i64_4_default(
; CHECK-NEXT: ret i64 128
define i64 @matrix_i64_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i64, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i128_4_default(
; CHECK-NEXT: ret i64 256
define i64 @matrix_i128_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i128, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i128_4_full(
; CHECK-NEXT: ret i64 2048
define i64 @matrix_i128_4_full() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i128, 4, 4, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i128_4_default(
; CHECK-NEXT: ret i64 256
define i64 @acc_i128_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i128, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_bfloat_4_4(
; CHECK-NEXT: ret i64 128
define i64 @matrix_bfloat_4_4() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", bfloat, 4, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_float_4_4(
; CHECK-NEXT: ret i64 256
define i64 @matrix_float_4_4() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", float, 4, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i16_4_default(
; CHECK-NEXT: ret i64 32
define i64 @acc_i16_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i16, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i16_4_2(
; CHECK-NEXT: ret i64 64
define i64 @acc_i16_4_2() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i16, 4, 4, 2), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i8_4_4(
; CHECK-NEXT: ret i64 64
define i64 @acc_i8_4_4() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i8, 4, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_double_4_default(
; CHECK-NEXT: ret i64 128
define i64 @acc_double_4_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", double, 4, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i32_4_32(
; CHECK-NEXT: ret i64 2048
define i64 @matrix_i32_4_32() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i32, 4, 4, 32), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i32_8_default(
; CHECK-NEXT: ret i64 256
define i64 @matrix_i32_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i32, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i1_8_default(
; CHECK-NEXT: ret i64 256
define i64 @matrix_i1_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i1, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i4_8_default(
; CHECK-NEXT: ret i64 256
define i64 @matrix_i4_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i4, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i16_8_default(
; CHECK-NEXT: ret i64 256
define i64 @matrix_i16_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i16, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i64_8_default(
; CHECK-NEXT: ret i64 512
define i64 @matrix_i64_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i64, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_bfloat_8_4(
; CHECK-NEXT: ret i64 512
define i64 @matrix_bfloat_8_4() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", bfloat, 8, 8, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_float_8_4(
; CHECK-NEXT: ret i64 1024
define i64 @matrix_float_8_4() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", float, 8, 8, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i16_8_default(
; CHECK-NEXT: ret i64 128
define i64 @acc_i16_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i16, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i16_8_2(
; CHECK-NEXT: ret i64 256
define i64 @acc_i16_8_2() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i16, 8, 8, 2), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_i8_8_4(
; CHECK-NEXT: ret i64 256
define i64 @acc_i8_8_4() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", i8, 8, 8, 4), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @acc_double_8_default(
; CHECK-NEXT: ret i64 512
define i64 @acc_double_8_default() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.acc", double, 8, 8), ptr null, i64 1) to i64)
}

; CHECK-LABEL: @matrix_i32_8_16(
; CHECK-NEXT: ret i64 4096
define i64 @matrix_i32_8_16() {
  ret i64 ptrtoint (ptr getelementptr (target("riscv.ztt.matrix", i32, 8, 8, 16), ptr null, i64 1) to i64)
}
