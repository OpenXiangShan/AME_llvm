; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -O0 -verify-machineinstrs -filetype=obj < %s -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+zicond -verify-machineinstrs -filetype=obj < %s -o /dev/null

target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"

; CHECK-LABEL: select_matrix32:
; CHECK: andi a0, a0, 1{{$}}
; CHECK-NEXT: bnez a0, .LBB0_2{{$}}
; CHECK: addi sp, sp, -272{{$}}
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m1{{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: addi sp, sp, 272{{$}}
; CHECK: .LBB0_2:
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @select_matrix32(i1 %c, target("riscv.ztt.matrix", i32, 8, 8) %a, target("riscv.ztt.matrix", i32, 8, 8) %b) {
  %r = select i1 %c, target("riscv.ztt.matrix", i32, 8, 8) %a, target("riscv.ztt.matrix", i32, 8, 8) %b
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

; CHECK-LABEL: select_matrix64:
; CHECK: andi a0, a0, 1{{$}}
; CHECK-NEXT: bnez a0, .LBB1_2{{$}}
; CHECK: addi sp, sp, -528{{$}}
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m2{{$}}
; CHECK-NEXT: mv t0, sp{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: mss.1r m2, t0{{$}}
; CHECK-NEXT: addi t0, sp, 264{{$}}
; CHECK-NEXT: mss.1r m3, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mv t0, sp{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 264{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: addi sp, sp, 528{{$}}
; CHECK: .LBB1_2:
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i64, 8, 8) @select_matrix64(i1 %c, target("riscv.ztt.matrix", i64, 8, 8) %a, target("riscv.ztt.matrix", i64, 8, 8) %b) {
  %r = select i1 %c, target("riscv.ztt.matrix", i64, 8, 8) %a, target("riscv.ztt.matrix", i64, 8, 8) %b
  ret target("riscv.ztt.matrix", i64, 8, 8) %r
}

; CHECK-LABEL: select_acc32:
; CHECK: andi a0, a0, 1{{$}}
; CHECK-NEXT: bnez a0, .LBB2_2{{$}}
; CHECK: addi sp, sp, -1056{{$}}
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 528{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 792{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc1{{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc1{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 272{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 528{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 792{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 528{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 792{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 8{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: asettyp acc0, t1{{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 272{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: mmov.a.m acc0, m0{{$}}
; CHECK-NEXT: addi t0, sp, 528{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 792{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: addi sp, sp, 1056{{$}}
; CHECK: .LBB2_2:
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @select_acc32(i1 %c, target("riscv.ztt.acc", i32, 8, 8) %a, target("riscv.ztt.acc", i32, 8, 8) %b) {
  %r = select i1 %c, target("riscv.ztt.acc", i32, 8, 8) %a, target("riscv.ztt.acc", i32, 8, 8) %b
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

; CHECK-LABEL: select_acc8:
; CHECK: andi a0, a0, 1{{$}}
; CHECK-NEXT: bnez a0, .LBB3_2{{$}}
; CHECK: addi sp, sp, -2048{{$}}
; CHECK-NEXT: addi sp, sp, -576{{$}}
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 800{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc4{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc4{{$}}
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
; CHECK-NEXT: addi sp, sp, 2032{{$}}
; CHECK-NEXT: addi sp, sp, 592{{$}}
; CHECK: .LBB3_2:
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i8, 8, 8) @select_acc8(i1 %c, target("riscv.ztt.acc", i8, 8, 8) %a, target("riscv.ztt.acc", i8, 8, 8) %b) {
  %r = select i1 %c, target("riscv.ztt.acc", i8, 8, 8) %a, target("riscv.ztt.acc", i8, 8, 8) %b
  ret target("riscv.ztt.acc", i8, 8, 8) %r
}
