; RUN: opt -passes=verify -disable-output %s
; RUN: llvm-as %s -o - | llvm-dis -o - | llvm-as -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -O0 -verify-machineinstrs -filetype=obj < %s -o /dev/null

; Calling-convention allocation must reach the top of the 16-register M file
; for single registers and aligned groups. The scalar result stays XLEN-wide.
; The Clang type-roundtrip test also covers these group types on RV32.
target triple = "riscv64"

; CHECK-LABEL: last_single:
; CHECK: mgettyp a0, m15{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @last_single(target("riscv.ztt.matrix", i32, 8, 8) %m0, target("riscv.ztt.matrix", i32, 8, 8) %m1, target("riscv.ztt.matrix", i32, 8, 8) %m2, target("riscv.ztt.matrix", i32, 8, 8) %m3, target("riscv.ztt.matrix", i32, 8, 8) %m4, target("riscv.ztt.matrix", i32, 8, 8) %m5, target("riscv.ztt.matrix", i32, 8, 8) %m6, target("riscv.ztt.matrix", i32, 8, 8) %m7, target("riscv.ztt.matrix", i32, 8, 8) %m8, target("riscv.ztt.matrix", i32, 8, 8) %m9, target("riscv.ztt.matrix", i32, 8, 8) %m10, target("riscv.ztt.matrix", i32, 8, 8) %m11, target("riscv.ztt.matrix", i32, 8, 8) %m12, target("riscv.ztt.matrix", i32, 8, 8) %m13, target("riscv.ztt.matrix", i32, 8, 8) %m14, target("riscv.ztt.matrix", i32, 8, 8) %m15) {
  %r = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %m15)
  ret i64 %r
}
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))

; CHECK-LABEL: last_pair:
; CHECK: mgettyp a0, m14{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @last_pair(target("riscv.ztt.matrix", i64, 8, 8) %m0, target("riscv.ztt.matrix", i64, 8, 8) %m1, target("riscv.ztt.matrix", i64, 8, 8) %m2, target("riscv.ztt.matrix", i64, 8, 8) %m3, target("riscv.ztt.matrix", i64, 8, 8) %m4, target("riscv.ztt.matrix", i64, 8, 8) %m5, target("riscv.ztt.matrix", i64, 8, 8) %m6, target("riscv.ztt.matrix", i64, 8, 8) %m7) {
  %r = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %m7)
  ret i64 %r
}
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8))

; CHECK-LABEL: last_quad:
; CHECK: mgettyp a0, m12{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @last_quad(target("riscv.ztt.matrix", i32, 8, 8, 4) %m0, target("riscv.ztt.matrix", i32, 8, 8, 4) %m1, target("riscv.ztt.matrix", i32, 8, 8, 4) %m2, target("riscv.ztt.matrix", i32, 8, 8, 4) %m3) {
  %r = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8_4t(target("riscv.ztt.matrix", i32, 8, 8, 4) %m3)
  ret i64 %r
}
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8_4t(target("riscv.ztt.matrix", i32, 8, 8, 4))

; CHECK-LABEL: last_octet:
; CHECK: mgettyp a0, m8{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @last_octet(target("riscv.ztt.matrix", i32, 8, 8, 8) %m0, target("riscv.ztt.matrix", i32, 8, 8, 8) %m1) {
  %r = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8_8t(target("riscv.ztt.matrix", i32, 8, 8, 8) %m1)
  ret i64 %r
}
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8_8t(target("riscv.ztt.matrix", i32, 8, 8, 8))

; The largest group preserves all 16 raw images and its descriptor across
; a call; the high half must not alias or disappear during spill expansion.
; CHECK-LABEL: preserve_full_group:
; CHECK: mgettyp t1, m0{{$}}
; CHECK: mss.1r m0, t0{{$}}
; CHECK: mss.1r m1, t0{{$}}
; CHECK: mss.1r m2, t0{{$}}
; CHECK: mss.1r m3, t0{{$}}
; CHECK: mss.1r m4, t0{{$}}
; CHECK: mss.1r m5, t0{{$}}
; CHECK: mss.1r m6, t0{{$}}
; CHECK: mss.1r m7, t0{{$}}
; CHECK: mss.1r m8, t0{{$}}
; CHECK: mss.1r m9, t0{{$}}
; CHECK: mss.1r m10, t0{{$}}
; CHECK: mss.1r m11, t0{{$}}
; CHECK: mss.1r m12, t0{{$}}
; CHECK: mss.1r m13, t0{{$}}
; CHECK: mss.1r m14, t0{{$}}
; CHECK: mss.1r m15, t0{{$}}
; CHECK: call external{{$}}
; CHECK: msettyp m0, t1{{$}}
; CHECK: mls.1r m0, t0{{$}}
; CHECK: mls.1r m1, t0{{$}}
; CHECK: mls.1r m2, t0{{$}}
; CHECK: mls.1r m3, t0{{$}}
; CHECK: mls.1r m4, t0{{$}}
; CHECK: mls.1r m5, t0{{$}}
; CHECK: mls.1r m6, t0{{$}}
; CHECK: mls.1r m7, t0{{$}}
; CHECK: mls.1r m8, t0{{$}}
; CHECK: mls.1r m9, t0{{$}}
; CHECK: mls.1r m10, t0{{$}}
; CHECK: mls.1r m11, t0{{$}}
; CHECK: mls.1r m12, t0{{$}}
; CHECK: mls.1r m13, t0{{$}}
; CHECK: mls.1r m14, t0{{$}}
; CHECK: mls.1r m15, t0{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8, 16) @preserve_full_group(target("riscv.ztt.matrix", i32, 8, 8, 16) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 8, 8, 16) %m
}
declare void @external()

; CHECK-LABEL: select_full_group:
; CHECK: msettyp m0, a1{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8, 16) @select_full_group(i1 %c, target("riscv.ztt.matrix", i32, 8, 8, 16) %m, i64 %desc) {
  %other = call target("riscv.ztt.matrix", i32, 8, 8, 16) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8_16t.i64(target("riscv.ztt.matrix", i32, 8, 8, 16) undef, i64 %desc)
  %r = select i1 %c, target("riscv.ztt.matrix", i32, 8, 8, 16) %m, target("riscv.ztt.matrix", i32, 8, 8, 16) %other
  ret target("riscv.ztt.matrix", i32, 8, 8, 16) %r
}
declare target("riscv.ztt.matrix", i32, 8, 8, 16) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8_16t.i64(target("riscv.ztt.matrix", i32, 8, 8, 16), i64)
