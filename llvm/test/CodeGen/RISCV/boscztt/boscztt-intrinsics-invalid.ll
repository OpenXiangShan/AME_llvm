; RUN: split-file %s %t
; RUN: not llvm-as %t/arity.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ARITY
; RUN: not llvm-as %t/load.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=LOAD
; RUN: not llvm-as %t/store.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=STORE
; RUN: not llvm-as %t/file.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=FILE
; RUN: not llvm-as %t/vector.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=VECTOR
; RUN: not llvm-as %t/xlen.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=XLEN
; RUN: not llvm-as %t/descriptor.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=DESCRIPTOR
; RUN: not llvm-as %t/raw.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=RAW
; RUN: not llvm-as %t/squares.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=SQUARES
; RUN: not llvm-as %t/pack.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=PACK
; RUN: not llvm-as %t/acc-move-span.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ACC-MOVE

;--- acc-move-span.ll
; ACC-MOVE: ZTT M/ACC moves require matching complete packed-square groups
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare target("riscv.ztt.acc", i32, 4, 4) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i32_4_4t.triscv.ztt.matrix_i8_4_4t(target("riscv.ztt.acc", i32, 4, 4), target("riscv.ztt.matrix", i8, 4, 4))
define void @test(target("riscv.ztt.acc", i32, 4, 4) %acc, target("riscv.ztt.matrix", i8, 4, 4) %m) {
  call target("riscv.ztt.acc", i32, 4, 4) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i32_4_4t.triscv.ztt.matrix_i8_4_4t(target("riscv.ztt.acc", i32, 4, 4) %acc, target("riscv.ztt.matrix", i8, 4, 4) %m)
  ret void
}

;--- file.ll
; FILE: ZTT operand has the wrong matrix register-file type
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))
define void @test() {
  call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) poison)
  ret void
}

;--- vector.ll
; VECTOR: ZTT operand has the wrong matrix register-file type
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare i64 @llvm.riscv.ztt.mgettyp.i64.v64i32(<64 x i32>)
define void @test() {
  call i64 @llvm.riscv.ztt.mgettyp.i64.v64i32(<64 x i32> poison)
  ret void
}

;--- xlen.ll
; XLEN: ZTT scalar operands must have XLEN width
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8), i32)
define void @test() {
  call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8) undef, i32 32)
  ret void
}

;--- descriptor.ll
; DESCRIPTOR: ZTT datatype descriptor width must match the result element width
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), i64)
define void @test() {
  call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 64)
  ret void
}

;--- raw.ll
; RAW: ZTT raw register operations require exactly one M register
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare void @llvm.riscv.ztt.mss.1r.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8), ptr)
define void @test() {
  call void @llvm.riscv.ztt.mss.1r.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) poison, ptr null)
  ret void
}

;--- squares.ll
; SQUARES: ZTT elementwise operands must contain max(pack_factor) squares
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i8_8_8t.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i8, 8, 8), target("riscv.ztt.matrix", i8, 8, 8))
define void @test() {
  call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i8_8_8t.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8) poison, target("riscv.ztt.matrix", i8, 8, 8) poison, target("riscv.ztt.matrix", i8, 8, 8) poison)
  ret void
}

;--- pack.ll
; PACK: ZTT pack/unpack requires one packed register and one non-packed square
target datalayout = "e-m:e-p:64:64-i64:64-n64-S128"
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mpack.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8), i64, target("riscv.ztt.matrix", i32, 8, 8))
define void @test() {
  call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mpack.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) poison, i64 0, target("riscv.ztt.matrix", i32, 8, 8) poison)
  ret void
}

;--- load.ll
; LOAD: ZTT matrices must be loaded with ZTT intrinsics
define target("riscv.ztt.matrix", i32, 8, 8) @load(ptr %p) {
  %m = load target("riscv.ztt.matrix", i32, 8, 8), ptr %p
  ret target("riscv.ztt.matrix", i32, 8, 8) %m
}
;--- store.ll
; STORE: ZTT matrices must be stored with ZTT intrinsics
define void @store(ptr %p, {target("riscv.ztt.acc", i32, 8, 8)} %m) {
  store {target("riscv.ztt.acc", i32, 8, 8)} %m, ptr %p
  ret void
}

;--- arity.ll
; ARITY: Invalid ZTT intrinsic arity
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabs.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t()
define void @arity() {
  call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabs.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t()
  ret void
}
