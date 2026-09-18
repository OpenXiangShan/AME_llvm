; RUN: split-file %s %t
; RUN: not llvm-as %t/scalar.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=SCALAR
; RUN: not llvm-as %t/vector.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=VECTOR
; RUN: not llvm-as %t/pointer.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=POINTER
; RUN: not llvm-as %t/aggregate.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=AGGREGATE
; RUN: not llvm-as %t/other-target.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=OTHER
; RUN: not llvm-as %t/m-operand.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=M-OPERAND
; RUN: not llvm-as %t/acc-operand.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ACC-OPERAND
; RUN: not llvm-as %t/m-result.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=M-RESULT
; RUN: not llvm-as %t/acc-result.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ACC-RESULT
; RUN: not llvm-as %t/second-source.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=SOURCE
; RUN: not llvm-as %t/passthrough.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=MATCH
; RUN: llvm-as %t/valid.ll -o - | llvm-dis -o - | FileCheck %s --check-prefix=VALID

; These declarations have no call sites: only the generic intrinsic signature
; checker runs, not the ZTT-specific checks in visitIntrinsicCall. Matrix and
; accumulator overloads must reject non-matrices and each other's register file.

;--- scalar.ll
; SCALAR: expected any riscv.ztt.matrix type, but got i32
declare i64 @llvm.riscv.ztt.mgettyp.i64.i32(i32)

;--- vector.ll
; VECTOR: expected any riscv.ztt.matrix type, but got <64 x i32>
declare i64 @llvm.riscv.ztt.mgettyp.i64.v64i32(<64 x i32>)

;--- pointer.ll
; POINTER: expected any riscv.ztt.acc type, but got ptr
declare i64 @llvm.riscv.ztt.agettyp.i64.p0(ptr)

;--- aggregate.ll
; AGGREGATE: expected any riscv.ztt.matrix type, but got [8 x [8 x i32]]
declare i64 @llvm.riscv.ztt.mgettyp.i64.a8a8i32([8 x [8 x i32]])

;--- other-target.ll
; OTHER: expected any riscv.ztt.matrix type, but got target("aarch64.svcount")
declare i64 @llvm.riscv.ztt.mgettyp.i64.taarch64.svcountt(target("aarch64.svcount"))

;--- m-operand.ll
; M-OPERAND: expected any riscv.ztt.matrix type, but got target("riscv.ztt.acc", i32, 8, 8)
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))

;--- acc-operand.ll
; ACC-OPERAND: expected any riscv.ztt.acc type, but got target("riscv.ztt.matrix", i32, 8, 8)
declare i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))

;--- m-result.ll
; M-RESULT: expected any riscv.ztt.matrix type, but got i32
declare i32 @llvm.riscv.ztt.msettyp.i32.i64(i32, i64)

;--- acc-result.ll
; ACC-RESULT: expected any riscv.ztt.acc type, but got target("riscv.ztt.matrix", i32, 8, 8)
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), i64)

;--- second-source.ll
; SOURCE: expected any riscv.ztt.matrix type, but got ptr
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.p0(target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8), ptr)

;--- passthrough.ll
; MATCH: expected target("riscv.ztt.matrix", i32, 8, 8), but got target("riscv.ztt.matrix", float, 8, 8)
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", float, 8, 8), ptr)

;--- valid.ll
; Implicit declarations exercise signature matching and overload inference.
; Independent matrix overloads may have different element types and group sizes.
; VALID-LABEL: define target("riscv.ztt.matrix", half, 8, 8) @convert(
; VALID: call target("riscv.ztt.matrix", half, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_f16_8_8t.triscv.ztt.matrix_i32_8_8_2t(
define target("riscv.ztt.matrix", half, 8, 8) @convert(target("riscv.ztt.matrix", half, 8, 8) %d, target("riscv.ztt.matrix", i32, 8, 8, 2) %s) {
  %r = call target("riscv.ztt.matrix", half, 8, 8) @llvm.riscv.ztt.mconv.ew(target("riscv.ztt.matrix", half, 8, 8) %d, target("riscv.ztt.matrix", i32, 8, 8, 2) %s)
  ret target("riscv.ztt.matrix", half, 8, 8) %r
}

; VALID-LABEL: define target("riscv.ztt.acc", double, 8, 8) @zero_acc(
; VALID: call target("riscv.ztt.acc", double, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_f64_8_8t(
define target("riscv.ztt.acc", double, 8, 8) @zero_acc(target("riscv.ztt.acc", double, 8, 8) %d) {
  %r = call target("riscv.ztt.acc", double, 8, 8) @llvm.riscv.ztt.mzero.2d.acc(target("riscv.ztt.acc", double, 8, 8) %d)
  ret target("riscv.ztt.acc", double, 8, 8) %r
}
