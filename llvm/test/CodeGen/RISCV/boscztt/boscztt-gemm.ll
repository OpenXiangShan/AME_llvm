; RUN: opt -passes=verify -disable-output %s
; RUN: llc -mattr=+boscztt -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mattr=+boscztt -O0 -verify-machineinstrs -filetype=obj < %s -o /dev/null
; RUN: opt -passes='default<O2>' -S %s | llc -mattr=+boscztt -verify-machineinstrs | FileCheck %s --check-prefix=OPT

; A/B/C point to naturally aligned 8 x 8 unsigned i32 row-major matrices.
; Privileged software must have enabled AME. Return 1 on acquisition failure,
; 0 after storing C = A * B. The example assumes the uint32 tuple is supported.
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "riscv64"

; Keep separate checks for the GPR allocation after IR optimization.
; CHECK-LABEL: gemm_u32:
; CHECK: ame.acquire a3, zero{{$}}
; CHECK-NEXT: li a4, 1{{$}}
; CHECK-NEXT: bne a3, a4, .LBB0_2{{$}}
; CHECK: li a3, 32{{$}}
; CHECK-NEXT: msettyp m0, a3{{$}}
; CHECK-NEXT: msettyp m1, a3{{$}}
; CHECK-NEXT: asettyp acc0, a3{{$}}
; CHECK-NEXT: mls.rm m0, a0{{$}}
; CHECK-NEXT: mls.rm m1, a1{{$}}
; CHECK-NEXT: mmulacc.2d acc0, m0, m1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: mss.rm m0, a2{{$}}
; CHECK-NEXT: ame.release{{$}}
; CHECK-NEXT: li a0, 0{{$}}
; CHECK-NEXT: ret{{$}}
; CHECK-NEXT: .LBB0_2:
; CHECK-NEXT: li a0, 1{{$}}
; CHECK-NEXT: ret{{$}}

; OPT-LABEL: gemm_u32:
; OPT: ame.acquire a4, zero{{$}}
; OPT-NEXT: li a3, 1{{$}}
; OPT-NEXT: bne a4, a3, .LBB0_2{{$}}
; OPT: li a3, 32{{$}}
; OPT-NEXT: msettyp m0, a3{{$}}
; OPT-NEXT: msettyp m1, a3{{$}}
; OPT-NEXT: asettyp acc0, a3{{$}}
; OPT-NEXT: mls.rm m0, a0{{$}}
; OPT-NEXT: mls.rm m1, a1{{$}}
; OPT-NEXT: mmulacc.2d acc0, m0, m1{{$}}
; OPT-NEXT: mmov.m.a m0, acc0{{$}}
; OPT-NEXT: mss.rm m0, a2{{$}}
; OPT-NEXT: ame.release{{$}}
; OPT-NEXT: li a3, 0{{$}}
; OPT-NEXT: .LBB0_2:
; OPT-NEXT: mv a0, a3{{$}}
; OPT-NEXT: ret{{$}}
define i64 @gemm_u32(ptr %a, ptr %b, ptr %c) {
entry:
  %owned = call i64 @llvm.riscv.ztt.ame.acquire.i64(i64 0)
  %ok = icmp eq i64 %owned, 1
  br i1 %ok, label %compute, label %unavailable

compute:
  %ma = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %mb = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %acc = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %av = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %ma, ptr %a)
  %bv = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %mb, ptr %b)
  %product = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %acc, target("riscv.ztt.matrix", i32, 8, 8) %av, target("riscv.ztt.matrix", i32, 8, 8) %bv)
  %result = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i32_8_8t.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %av, target("riscv.ztt.acc", i32, 8, 8) %product)
  call void @llvm.riscv.ztt.mss.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %result, ptr %c)
  call void @llvm.riscv.ztt.ame.release()
  ret i64 0

unavailable:
  ret i64 1
}

declare i64 @llvm.riscv.ztt.ame.acquire.i64(i64)
declare void @llvm.riscv.ztt.ame.release()
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), i64)
declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8), i64)
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i32_8_8t.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.acc", i32, 8, 8))
declare void @llvm.riscv.ztt.mss.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
