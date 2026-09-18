; REQUIRES: riscv-registered-target
; RUN: llc -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs < %s | FileCheck %s

target triple = "riscv64"

; CHECK-LABEL: add_ame_gem5:
; CHECK: madd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 4, 4) @add_ame_gem5(
    target("riscv.ztt.matrix", i32, 4, 4) %d,
    target("riscv.ztt.matrix", i32, 4, 4) %a,
    target("riscv.ztt.matrix", i32, 4, 4) %b) {
  %r = call target("riscv.ztt.matrix", i32, 4, 4)
      @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_4_4t.triscv.ztt.matrix_i32_4_4t.triscv.ztt.matrix_i32_4_4t(
        target("riscv.ztt.matrix", i32, 4, 4) %d,
        target("riscv.ztt.matrix", i32, 4, 4) %a,
        target("riscv.ztt.matrix", i32, 4, 4) %b)
  ret target("riscv.ztt.matrix", i32, 4, 4) %r
}

declare target("riscv.ztt.matrix", i32, 4, 4)
    @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_4_4t.triscv.ztt.matrix_i32_4_4t.triscv.ztt.matrix_i32_4_4t(
      target("riscv.ztt.matrix", i32, 4, 4),
      target("riscv.ztt.matrix", i32, 4, 4),
      target("riscv.ztt.matrix", i32, 4, 4))

; RUN: llc -mattr=+boscztt,+boscztt-ame-gem5 -O0 -verify-machineinstrs -filetype=obj < %s -o /dev/null
; RUN: opt -passes=verify -disable-output %s
; RUN: llvm-as %s -o - | llvm-dis -o - | llvm-as -o /dev/null
; RUN: not --crash llc -mattr=+boscztt < %s 2>&1 | FileCheck %s --check-prefix=BAD-SHAPE
; BAD-SHAPE: ZTT matrix shape does not match the selected boscztt profile

; A full M file and a wide ACC must both survive an arbitrary callee.
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
; CHECK: mss.1r m16, t0{{$}}
; CHECK: mss.1r m17, t0{{$}}
; CHECK: mss.1r m18, t0{{$}}
; CHECK: mss.1r m19, t0{{$}}
; CHECK: mss.1r m20, t0{{$}}
; CHECK: mss.1r m21, t0{{$}}
; CHECK: mss.1r m22, t0{{$}}
; CHECK: mss.1r m23, t0{{$}}
; CHECK: mss.1r m24, t0{{$}}
; CHECK: mss.1r m25, t0{{$}}
; CHECK: mss.1r m26, t0{{$}}
; CHECK: mss.1r m27, t0{{$}}
; CHECK: mss.1r m28, t0{{$}}
; CHECK: mss.1r m29, t0{{$}}
; CHECK: mss.1r m30, t0{{$}}
; CHECK: mss.1r m31, t0{{$}}
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
; CHECK: mls.1r m16, t0{{$}}
; CHECK: mls.1r m17, t0{{$}}
; CHECK: mls.1r m18, t0{{$}}
; CHECK: mls.1r m19, t0{{$}}
; CHECK: mls.1r m20, t0{{$}}
; CHECK: mls.1r m21, t0{{$}}
; CHECK: mls.1r m22, t0{{$}}
; CHECK: mls.1r m23, t0{{$}}
; CHECK: mls.1r m24, t0{{$}}
; CHECK: mls.1r m25, t0{{$}}
; CHECK: mls.1r m26, t0{{$}}
; CHECK: mls.1r m27, t0{{$}}
; CHECK: mls.1r m28, t0{{$}}
; CHECK: mls.1r m29, t0{{$}}
; CHECK: mls.1r m30, t0{{$}}
; CHECK: mls.1r m31, t0{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.matrix", i32, 4, 4, 32) @preserve_full_group(
    target("riscv.ztt.matrix", i32, 4, 4, 32) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 32) %m
}

; CHECK-LABEL: preserve_acc64:
; CHECK: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 88{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 152{{$}}
; CHECK-NEXT: mss.1r m2, t0{{$}}
; CHECK-NEXT: addi t0, sp, 216{{$}}
; CHECK-NEXT: mss.1r m3, t0{{$}}
; CHECK: call external{{$}}
; CHECK: asettyp acc0, t1{{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 88{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 152{{$}}
; CHECK-NEXT: mls.1r m2, t0{{$}}
; CHECK-NEXT: addi t0, sp, 216{{$}}
; CHECK-NEXT: mls.1r m3, t0{{$}}
; CHECK-NEXT: mmov.a.m acc0, m0{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.acc", i64, 4, 4) @preserve_acc64(
    target("riscv.ztt.acc", i64, 4, 4) %acc) {
  call void @external()
  ret target("riscv.ztt.acc", i64, 4, 4) %acc
}
declare void @external()
