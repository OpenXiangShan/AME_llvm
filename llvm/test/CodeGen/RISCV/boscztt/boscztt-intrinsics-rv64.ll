; RUN: sed 's/, 8, 8)/, 4, 4)/g; s/_8_8t/_4_4t/g' %s > %t.ame.ll
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs < %t.ame.ll | FileCheck %s
; RUN: opt -passes=verify -disable-output %t.ame.ll
; RUN: opt -passes=verify -disable-output %s
; RUN: llvm-as %s -o - | llvm-dis -o - | llvm-as -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -O0 -verify-machineinstrs < %s | FileCheck %s

; Check the complete instruction operands and return at both optimization levels.
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
target triple = "riscv64"

declare i64 @llvm.riscv.ztt.ame.acquire.i64(i64)
; CHECK-LABEL: test_ame_acquire:
; CHECK: ame.acquire a0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_ame_acquire(i64 %p0) {
  %r = call i64 @llvm.riscv.ztt.ame.acquire.i64(i64 %p0)
  ret i64 %r
}

declare void @llvm.riscv.ztt.ame.release()
; CHECK-LABEL: test_ame_release:
; CHECK: ame.release{{$}}
; CHECK-NEXT: ret{{$}}
define void @test_ame_release() {
  call void @llvm.riscv.ztt.ame.release()
  ret void
}

declare i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))
; CHECK-LABEL: test_agettyp:
; CHECK: agettyp a0, acc0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_agettyp(target("riscv.ztt.acc", i32, 8, 8) %p0) {
  %r = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0)
  ret i64 %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8), i64)
; CHECK-LABEL: test_asettyp:
; CHECK: asettyp acc0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_asettyp(i64 %p0) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 %p0)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabs.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mabs_ew:
; CHECK: mabs.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mabs_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabs.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mabsdiff_ew:
; CHECK: mabsdiff.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mabsdiff_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mabsdiff_ew_x:
; CHECK: mabsdiff.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mabsdiff_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_madd_ew:
; CHECK: madd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_madd_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_madd_ew_x:
; CHECK: madd.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_madd_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mand_ew:
; CHECK: mand.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mand_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mand_ew_x:
; CHECK: mand.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mand_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mandnot_ew:
; CHECK: mandnot.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mandnot_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mandnot_ew_x:
; CHECK: mandnot.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mandnot_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcmovge_ew:
; CHECK: mcmovge.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcmovge_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovlt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcmovlt_ew:
; CHECK: mcmovlt.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcmovlt_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovlt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcmpge_ew:
; CHECK: mcmpge.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcmpge_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcmpge_ew_x:
; CHECK: mcmpge.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcmpge_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcmplt_ew:
; CHECK: mcmplt.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcmplt_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcmplt_ew_x:
; CHECK: mcmplt.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcmplt_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolbcast_ew_x:
; CHECK: mcolbcast.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcolbcast_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolgather_ew:
; CHECK: mcolgather.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcolgather_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolid_ew:
; CHECK: mcolid.ew m0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcolid_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolshift.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolshift_ew_x:
; CHECK: mcolshift.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcolshift_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolshift.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolunzip_ew:
; CHECK: mcolunzip.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @test_mcolunzip_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } %r
}

declare { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolzip_ew:
; CHECK: mcolzip.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @test_mcolzip_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mconv_ew:
; CHECK: mconv.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mconv_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mbcast.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8), i64, i64)
; CHECK-LABEL: test_mbcast_m_x:
; CHECK: mbcast.m.x m0, a0, a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mbcast_m_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mbcast.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcos.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcos_ew:
; CHECK: mcos.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcos_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcos.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mexp2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mexp2_ew:
; CHECK: mexp2.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mexp2_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mexp2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintm.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mfrintm_ew:
; CHECK: mfrintm.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mfrintm_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintm.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintn.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mfrintn_ew:
; CHECK: mfrintn.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mfrintn_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintn.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mfrintp_ew:
; CHECK: mfrintp.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mfrintp_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintz.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mfrintz_ew:
; CHECK: mfrintz.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mfrintz_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintz.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mgettyp:
; CHECK: mgettyp a0, m0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_mgettyp(target("riscv.ztt.matrix", i32, 8, 8) %p0) {
  %r = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0)
  ret i64 %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mhdiff_ew:
; CHECK: mhdiff.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mhdiff_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mhdiff_ew_x:
; CHECK: mhdiff.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mhdiff_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mldexp_ew:
; CHECK: mldexp.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mldexp_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mldexp_ew_x:
; CHECK: mldexp.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mldexp_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mldexpacc_ew:
; CHECK: mldexpacc.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mldexpacc_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mldexpacc_ew_x:
; CHECK: mldexpacc.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mldexpacc_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mlog2_ew:
; CHECK: mlog2.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mlog2_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mlog2sub_ew:
; CHECK: mlog2sub.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mlog2sub_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mlog2sub_ew_x:
; CHECK: mlog2sub.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mlog2sub_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
; CHECK-LABEL: test_mls_1r:
; CHECK: mls.1r m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mls_1r(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
; CHECK-LABEL: test_mls_cm:
; CHECK: mls.cm m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mls_cm(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
; CHECK-LABEL: test_mls_rm:
; CHECK: mls.rm m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mls_rm(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.st.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), ptr, i64)
; CHECK-LABEL: test_mls_st:
; CHECK: mls.st m0, (a0), a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mls_st(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.st.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.tst.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), ptr, i64)
; CHECK-LABEL: test_mls_tst:
; CHECK: mls.tst m0, (a0), a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mls_tst(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.tst.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmax_ew:
; CHECK: mmax.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmax_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmax_ew_x:
; CHECK: mmax.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmax_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmean_ew:
; CHECK: mmean.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmean_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmean_ew_x:
; CHECK: mmean.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmean_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmin_ew:
; CHECK: mmin.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmin_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmin_ew_x:
; CHECK: mmin.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmin_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i32_8_8t.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.acc", i32, 8, 8))
; CHECK-LABEL: test_mmov_m_a:
; CHECK: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmov_m_a(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.acc", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i32_8_8t.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.acc", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmov_a_m:
; CHECK: mmov.a.m acc0, m0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmov_a_m(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.m.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmov_m_m:
; CHECK: mmov.m.m m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmov_m_m(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.m.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove8.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8), i64, i64)
; CHECK-LABEL: test_mmove8_m_x:
; CHECK: mmove8.m.x m0, a0, a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmove8_m_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove8.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove16.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8), i64, i64)
; CHECK-LABEL: test_mmove16_m_x:
; CHECK: mmove16.m.x m0, a0, a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmove16_m_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove16.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove32.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8), i64, i64)
; CHECK-LABEL: test_mmove32_m_x:
; CHECK: mmove32.m.x m0, a0, a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmove32_m_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove32.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove64.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8), i64, i64)
; CHECK-LABEL: test_mmove64_m_x:
; CHECK: mmove64.m.x m0, a0, a1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmove64_m_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove64.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, i64 %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare i64 @llvm.riscv.ztt.mmove8.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64)
; CHECK-LABEL: test_mmove8_x_m:
; CHECK: mmove8.x.m a0, m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_mmove8_x_m(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1) {
  %r = call i64 @llvm.riscv.ztt.mmove8.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1)
  ret i64 %r
}

declare i64 @llvm.riscv.ztt.mmove16.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64)
; CHECK-LABEL: test_mmove16_x_m:
; CHECK: mmove16.x.m a0, m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_mmove16_x_m(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1) {
  %r = call i64 @llvm.riscv.ztt.mmove16.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1)
  ret i64 %r
}

declare i64 @llvm.riscv.ztt.mmove32.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64)
; CHECK-LABEL: test_mmove32_x_m:
; CHECK: mmove32.x.m a0, m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_mmove32_x_m(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1) {
  %r = call i64 @llvm.riscv.ztt.mmove32.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1)
  ret i64 %r
}

declare i64 @llvm.riscv.ztt.mmove64.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64)
; CHECK-LABEL: test_mmove64_x_m:
; CHECK: mmove64.x.m a0, m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define i64 @test_mmove64_x_m(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1) {
  %r = call i64 @llvm.riscv.ztt.mmove64.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1)
  ret i64 %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmul_ew:
; CHECK: mmul.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmul_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmul_ew_x:
; CHECK: mmul.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmul_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulacc_2d:
; CHECK: mmulacc.2d acc0, m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmulacc_2d(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulacc_ew:
; CHECK: mmulacc.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulacc_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulacc_ew_x:
; CHECK: mmulacc.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulacc_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulaccneg_2d:
; CHECK: mmulaccneg.2d acc0, m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmulaccneg_2d(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulaccneg_ew:
; CHECK: mmulaccneg.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulaccneg_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulaccneg_ew_x:
; CHECK: mmulaccneg.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulaccneg_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmuladd_ew:
; CHECK: mmuladd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmuladd_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmuladd_ew_x:
; CHECK: mmuladd.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmuladd_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulatacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulatacc_2d:
; CHECK: mmulatacc.2d acc0, m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmulatacc_2d(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulatacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulataccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulataccneg_2d:
; CHECK: mmulataccneg.2d acc0, m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmulataccneg_2d(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulataccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulbtacc_2d:
; CHECK: mmulbtacc.2d acc0, m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmulbtacc_2d(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulbtaccneg_2d:
; CHECK: mmulbtaccneg.2d acc0, m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mmulbtaccneg_2d(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulneg_ew:
; CHECK: mmulneg.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulneg_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulneg_ew_x:
; CHECK: mmulneg.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulneg_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulsub_ew:
; CHECK: mmulsub.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulsub_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mmulsub_ew_x:
; CHECK: mmulsub.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mmulsub_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mor_ew:
; CHECK: mor.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mor_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mor_ew_x:
; CHECK: mor.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mor_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mornot_ew:
; CHECK: mornot.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mornot_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mornot_ew_x:
; CHECK: mornot.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mornot_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mpack.ew.x.triscv.ztt.matrix_i8_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i8, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mpack_ew_x:
; CHECK: mpack.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i8, 8, 8) @test_mpack_ew_x(target("riscv.ztt.matrix", i8, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mpack.ew.x.triscv.ztt.matrix_i8_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i8, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mprefixadd_col:
; CHECK: mprefixadd.col m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mprefixadd_col(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mprefixadd_row:
; CHECK: mprefixadd.row m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mprefixadd_row(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mprefixmax_col:
; CHECK: mprefixmax.col m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mprefixmax_col(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mprefixmax_row:
; CHECK: mprefixmax.row m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mprefixmax_row(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrdexp_ew:
; CHECK: mrdexp.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrdexp_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrdexpacc_ew:
; CHECK: mrdexpacc.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrdexpacc_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrec.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrec_ew:
; CHECK: mrec.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrec_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrec.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mreduceadd_col:
; CHECK: mreduceadd.col m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mreduceadd_col(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mreduceadd_row:
; CHECK: mreduceadd.row m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mreduceadd_row(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mreducemax_col:
; CHECK: mreducemax.col m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mreducemax_col(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mreducemax_row:
; CHECK: mreducemax.row m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mreducemax_row(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mreducemin_col:
; CHECK: mreducemin.col m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mreducemin_col(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mreducemin_row:
; CHECK: mreducemin.row m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mreducemin_row(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowbcast_ew_x:
; CHECK: mrowbcast.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrowbcast_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowgather_ew:
; CHECK: mrowgather.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrowgather_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowid_ew:
; CHECK: mrowid.ew m0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrowid_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowshift.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowshift_ew_x:
; CHECK: mrowshift.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrowshift_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowshift.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowunzip_ew:
; CHECK: mrowunzip.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @test_mrowunzip_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } %r
}

declare { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowzip_ew:
; CHECK: mrowzip.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @test_mrowzip_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrsqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrsqrt_ew:
; CHECK: mrsqrt.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrsqrt_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrsqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowscatadd_ew:
; CHECK: mrowscatadd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrowscatadd_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolscatadd_ew:
; CHECK: mcolscatadd.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcolscatadd_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mrowscatmax_ew:
; CHECK: mrowscatmax.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mrowscatmax_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mcolscatmax_ew:
; CHECK: mcolscatmax.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mcolscatmax_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mselge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mselge_ew:
; CHECK: mselge.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mselge_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mselge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msellt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msellt_ew:
; CHECK: msellt.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msellt_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msellt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), i64)
; CHECK-LABEL: test_msettyp:
; CHECK: msettyp m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msettyp(i64 %p0) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 %p0)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msin_ew:
; CHECK: msin.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msin_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msll_ew:
; CHECK: msll.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msll_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msll_ew_x:
; CHECK: msll.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msll_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msqrt_ew:
; CHECK: msqrt.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msqrt_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msra_ew:
; CHECK: msra.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msra_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msra_ew_x:
; CHECK: msra.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msra_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msrl_ew:
; CHECK: msrl.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msrl_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msrl_ew_x:
; CHECK: msrl.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msrl_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare void @llvm.riscv.ztt.mss.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
; CHECK-LABEL: test_mss_1r:
; CHECK: mss.1r m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define void @test_mss_1r(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1) {
  call void @llvm.riscv.ztt.mss.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1)
  ret void
}

declare void @llvm.riscv.ztt.mss.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
; CHECK-LABEL: test_mss_cm:
; CHECK: mss.cm m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define void @test_mss_cm(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1) {
  call void @llvm.riscv.ztt.mss.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1)
  ret void
}

declare void @llvm.riscv.ztt.mss.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), ptr)
; CHECK-LABEL: test_mss_rm:
; CHECK: mss.rm m0, a0{{$}}
; CHECK-NEXT: ret{{$}}
define void @test_mss_rm(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1) {
  call void @llvm.riscv.ztt.mss.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1)
  ret void
}

declare void @llvm.riscv.ztt.mss.st.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), ptr, i64)
; CHECK-LABEL: test_mss_st:
; CHECK: mss.st m0, (a0), a1{{$}}
; CHECK-NEXT: ret{{$}}
define void @test_mss_st(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2) {
  call void @llvm.riscv.ztt.mss.st.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2)
  ret void
}

declare void @llvm.riscv.ztt.mss.tst.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), ptr, i64)
; CHECK-LABEL: test_mss_tst:
; CHECK: mss.tst m0, (a0), a1{{$}}
; CHECK-NEXT: ret{{$}}
define void @test_mss_tst(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2) {
  call void @llvm.riscv.ztt.mss.tst.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) %p0, ptr %p1, i64 %p2)
  ret void
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msub_ew:
; CHECK: msub.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msub_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msub_ew_x:
; CHECK: msub.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msub_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msublog2_ew:
; CHECK: msublog2.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msublog2_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_msublog2_ew_x:
; CHECK: msublog2.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_msublog2_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mtanh.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mtanh_ew:
; CHECK: mtanh.ew m0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mtanh_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mtanh.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.munpack.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i8, 8, 8))
; CHECK-LABEL: test_munpack_ew_x:
; CHECK: munpack.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_munpack_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i8, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.munpack.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i8, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mxor_ew:
; CHECK: mxor.ew m0, m1, m2{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mxor_ew(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, target("riscv.ztt.matrix", i32, 8, 8) %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mxor_ew_x:
; CHECK: mxor.ew.x m0, a0, m1{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mxor_ew_x(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0, i64 %p1, target("riscv.ztt.matrix", i32, 8, 8) %p2)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}

declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))
; CHECK-LABEL: test_mzero_2d_acc:
; CHECK: mzero.2d.acc acc0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.acc", i32, 8, 8) @test_mzero_2d_acc(target("riscv.ztt.acc", i32, 8, 8) %p0) {
  %r = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %p0)
  ret target("riscv.ztt.acc", i32, 8, 8) %r
}

declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: test_mzero_2d_m:
; CHECK: mzero.2d.m m0{{$}}
; CHECK-NEXT: ret{{$}}
define target("riscv.ztt.matrix", i32, 8, 8) @test_mzero_2d_m(target("riscv.ztt.matrix", i32, 8, 8) %p0) {
  %r = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %p0)
  ret target("riscv.ztt.matrix", i32, 8, 8) %r
}
