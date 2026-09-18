; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs %s -o - | FileCheck %s
; RUN: llc -mtriple=riscv32 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -filetype=obj %s -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5,+zicond -verify-machineinstrs -filetype=obj %s -o /dev/null
; RUN: llc -mtriple=riscv32 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -O0 -filetype=obj %s -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -O0 -filetype=obj %s -o /dev/null

; Two full-file values require a spill. The chosen value returns in m0-m31.
declare target("riscv.ztt.matrix", i32, 4, 4, 32) @make_a()
declare target("riscv.ztt.matrix", i32, 4, 4, 32) @make_b()

; CHECK-LABEL: select_m32:
; CHECK: call make_a{{$}}
; CHECK: mss.1r m0, t0{{$}}
; CHECK: mss.1r m31, t0{{$}}
; CHECK: call make_b{{$}}
; CHECK: bnez s0, .LBB0_2{{$}}
; CHECK: mls.1r m0, t0{{$}}
; CHECK: mls.1r m31, t0{{$}}
; CHECK: ret{{$}}
define target("riscv.ztt.matrix", i32, 4, 4, 32) @select_m32(i1 %condition) {
  %a = call target("riscv.ztt.matrix", i32, 4, 4, 32) @make_a()
  %b = call target("riscv.ztt.matrix", i32, 4, 4, 32) @make_b()
  %r = select i1 %condition, target("riscv.ztt.matrix", i32, 4, 4, 32) %a, target("riscv.ztt.matrix", i32, 4, 4, 32) %b
  ret target("riscv.ztt.matrix", i32, 4, 4, 32) %r
}
