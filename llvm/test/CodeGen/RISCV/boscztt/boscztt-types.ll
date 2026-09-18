; RUN: opt -passes=verify -disable-output %s
; RUN: llvm-as %s -o - | llvm-dis -o - | llvm-as -o /dev/null
; RUN: llc -mattr=+boscztt -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mattr=+boscztt -O0 -verify-machineinstrs -filetype=obj < %s -o /dev/null

target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "riscv64"

; CHECK-LABEL: add_32:
; CHECK: madd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @add_32(target("riscv.ztt.matrix", i32, 8, 8) %d, target("riscv.ztt.matrix", i32, 8, 8) %a, target("riscv.ztt.matrix", i32, 8, 8) %b) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %d, target("riscv.ztt.matrix", i32, 8, 8) %a, target("riscv.ztt.matrix", i32, 8, 8) %b)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

; CHECK-LABEL: add_64:
; CHECK: madd.ew m0, m2, m4{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i64, 8, 8) @add_64(target("riscv.ztt.matrix", i64, 8, 8) %d, target("riscv.ztt.matrix", i64, 8, 8) %a, target("riscv.ztt.matrix", i64, 8, 8) %b) {
  %r = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i64_8_8t.triscv.ztt.matrix_i64_8_8t.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %d, target("riscv.ztt.matrix", i64, 8, 8) %a, target("riscv.ztt.matrix", i64, 8, 8) %b)
  ret target("riscv.ztt.matrix", i64, 8, 8) %r
}

; CHECK-LABEL: add_float:
; CHECK: madd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", float, 8, 8) @add_float(target("riscv.ztt.matrix", float, 8, 8) %d, target("riscv.ztt.matrix", float, 8, 8) %a, target("riscv.ztt.matrix", float, 8, 8) %b) {
  %r = call target("riscv.ztt.matrix", float, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_float_8_8t.triscv.ztt.matrix_float_8_8t.triscv.ztt.matrix_float_8_8t(target("riscv.ztt.matrix", float, 8, 8) %d, target("riscv.ztt.matrix", float, 8, 8) %a, target("riscv.ztt.matrix", float, 8, 8) %b)
  ret target("riscv.ztt.matrix", float, 8, 8) %r
}

; CHECK-LABEL: add_double:
; CHECK: madd.ew m0, m2, m4{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", double, 8, 8) @add_double(target("riscv.ztt.matrix", double, 8, 8) %d, target("riscv.ztt.matrix", double, 8, 8) %a, target("riscv.ztt.matrix", double, 8, 8) %b) {
  %r = call target("riscv.ztt.matrix", double, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_double_8_8t.triscv.ztt.matrix_double_8_8t.triscv.ztt.matrix_double_8_8t(target("riscv.ztt.matrix", double, 8, 8) %d, target("riscv.ztt.matrix", double, 8, 8) %a, target("riscv.ztt.matrix", double, 8, 8) %b)
  ret target("riscv.ztt.matrix", double, 8, 8) %r
}

; CHECK-LABEL: add_bfloat:
; CHECK: madd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", bfloat, 8, 8) @add_bfloat(target("riscv.ztt.matrix", bfloat, 8, 8) %d, target("riscv.ztt.matrix", bfloat, 8, 8) %a, target("riscv.ztt.matrix", bfloat, 8, 8) %b) {
  %r = call target("riscv.ztt.matrix", bfloat, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_bfloat_8_8t.triscv.ztt.matrix_bfloat_8_8t.triscv.ztt.matrix_bfloat_8_8t(target("riscv.ztt.matrix", bfloat, 8, 8) %d, target("riscv.ztt.matrix", bfloat, 8, 8) %a, target("riscv.ztt.matrix", bfloat, 8, 8) %b)
  ret target("riscv.ztt.matrix", bfloat, 8, 8) %r
}

; CHECK-LABEL: widen_8:
; CHECK: li a1, 8{{$}}
; CHECK-NEXT: msettyp m0, a1{{$}}
; CHECK-NEXT: mls.rm m0, a0{{$}}
; CHECK-NEXT: li a0, 32{{$}}
; CHECK-NEXT: msettyp m4, a0{{$}}
; CHECK-NEXT: mconv.ew m4, m0{{$}}
; CHECK-NEXT: ret{{$}}
define void @widen_8(ptr %p) {
  %a0 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a0, ptr %p)
  %d = call target("riscv.ztt.matrix", i32, 8, 8, 4) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8_4t.i64(target("riscv.ztt.matrix", i32, 8, 8, 4) undef, i64 32)
  %r = call target("riscv.ztt.matrix", i32, 8, 8, 4) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i32_8_8_4t.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8, 4) %d, target("riscv.ztt.matrix", i8, 8, 8) %a)
  ret void
}

; CHECK-LABEL: widen_4:
; CHECK: li a1, 4{{$}}
; CHECK-NEXT: msettyp m0, a1{{$}}
; CHECK-NEXT: mls.rm m0, a0{{$}}
; CHECK-NEXT: li a0, 16{{$}}
; CHECK-NEXT: msettyp m4, a0{{$}}
; CHECK-NEXT: mconv.ew m4, m0{{$}}
; CHECK-NEXT: ret{{$}}
define void @widen_4(ptr %p) {
  %a0 = call target("riscv.ztt.matrix", i4, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i4_8_8t.i64(target("riscv.ztt.matrix", i4, 8, 8) undef, i64 4)
  %a = call target("riscv.ztt.matrix", i4, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i4_8_8t(target("riscv.ztt.matrix", i4, 8, 8) %a0, ptr %p)
  %d = call target("riscv.ztt.matrix", i16, 8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i16_8_8_8t.i64(target("riscv.ztt.matrix", i16, 8, 8, 8) undef, i64 16)
  %r = call target("riscv.ztt.matrix", i16, 8, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i16_8_8_8t.triscv.ztt.matrix_i4_8_8t(target("riscv.ztt.matrix", i16, 8, 8, 8) %d, target("riscv.ztt.matrix", i4, 8, 8) %a)
  ret void
}

; CHECK-LABEL: packed_acc:
; CHECK: mmov.a.m acc0, m0{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i8, 8, 8) @packed_acc(target("riscv.ztt.matrix", i8, 8, 8) %src, target("riscv.ztt.acc", i8, 8, 8, 4) %dst) {
  %a = call target("riscv.ztt.acc", i8, 8, 8, 4) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i8_8_8_4t.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8, 4) %dst, target("riscv.ztt.matrix", i8, 8, 8) %src)
  %r = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i8_8_8t.triscv.ztt.acc_i8_8_8_4t(target("riscv.ztt.matrix", i8, 8, 8) %src, target("riscv.ztt.acc", i8, 8, 8, 4) %a)
  ret target("riscv.ztt.matrix", i8, 8, 8) %r
}

; CHECK-LABEL: across_call_matrix:
; CHECK: addi sp, sp, -272{{$}}
; CHECK: sd ra, 264(sp){{ *}}#
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: mv t0, sp{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: call external{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mv t0, sp{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.m m0{{$}}
; CHECK-NEXT: ld ra, 264(sp){{ *}}#
; CHECK: addi sp, sp, 272{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @across_call_matrix(target("riscv.ztt.matrix", i32, 8, 8) %m) {
  call void @external()
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %m)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

; CHECK-LABEL: across_call_acc:
; CHECK: addi sp, sp, -1072{{$}}
; CHECK: sd ra, 1064(sp){{ *}}#
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 800{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 800{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: call external{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 800{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: asettyp acc0, t1{{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: mmov.a.m acc0, m0{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 800{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.acc acc0{{$}}
; CHECK-NEXT: ld ra, 1064(sp){{ *}}#
; CHECK: addi sp, sp, 1072{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @across_call_acc(target("riscv.ztt.acc", i32, 8, 8) %m) {
  call void @external()
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %m)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare void @external()
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
declare target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i64_8_8t.triscv.ztt.matrix_i64_8_8t.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8), target("riscv.ztt.matrix", i64, 8, 8), target("riscv.ztt.matrix", i64, 8, 8))
declare target("riscv.ztt.matrix", float, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_float_8_8t.triscv.ztt.matrix_float_8_8t.triscv.ztt.matrix_float_8_8t(target("riscv.ztt.matrix", float, 8, 8), target("riscv.ztt.matrix", float, 8, 8), target("riscv.ztt.matrix", float, 8, 8))
declare target("riscv.ztt.matrix", double, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_double_8_8t.triscv.ztt.matrix_double_8_8t.triscv.ztt.matrix_double_8_8t(target("riscv.ztt.matrix", double, 8, 8), target("riscv.ztt.matrix", double, 8, 8), target("riscv.ztt.matrix", double, 8, 8))
declare target("riscv.ztt.matrix", bfloat, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_bfloat_8_8t.triscv.ztt.matrix_bfloat_8_8t.triscv.ztt.matrix_bfloat_8_8t(target("riscv.ztt.matrix", bfloat, 8, 8), target("riscv.ztt.matrix", bfloat, 8, 8), target("riscv.ztt.matrix", bfloat, 8, 8))
declare target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8), i64)
declare target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8), ptr)
declare target("riscv.ztt.matrix", i32, 8, 8, 4) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8_4t.i64(target("riscv.ztt.matrix", i32, 8, 8, 4), i64)
declare target("riscv.ztt.matrix", i32, 8, 8, 4) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i32_8_8_4t.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8, 4), target("riscv.ztt.matrix", i8, 8, 8))
declare target("riscv.ztt.matrix", i4, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i4_8_8t.i64(target("riscv.ztt.matrix", i4, 8, 8), i64)
declare target("riscv.ztt.matrix", i4, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i4_8_8t(target("riscv.ztt.matrix", i4, 8, 8), ptr)
declare target("riscv.ztt.matrix", i16, 8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i16_8_8_8t.i64(target("riscv.ztt.matrix", i16, 8, 8, 8), i64)
declare target("riscv.ztt.matrix", i16, 8, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i16_8_8_8t.triscv.ztt.matrix_i4_8_8t(target("riscv.ztt.matrix", i16, 8, 8, 8), target("riscv.ztt.matrix", i4, 8, 8))
declare target("riscv.ztt.acc", i8, 8, 8, 4) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i8_8_8_4t.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8, 4), target("riscv.ztt.matrix", i8, 8, 8))
declare target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i8_8_8t.triscv.ztt.acc_i8_8_8_4t(target("riscv.ztt.matrix", i8, 8, 8), target("riscv.ztt.acc", i8, 8, 8, 4))
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))
