; RUN: split-file %s %t
; RUN: not llvm-as %t/shape.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=SHAPE
; RUN: not llvm-as %t/width.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=WIDTH
; RUN: not llvm-as %t/scalar.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=SCALAR
; RUN: not llvm-as %t/arity.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ARITY
; RUN: not llvm-as %t/packed.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=PACKED
; RUN: not llvm-as %t/group.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=GROUP
; RUN: not llvm-as %t/acc.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ACC
; RUN: not llvm-as %t/acc-span.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=ACC

;--- shape.ll
; SHAPE: boscztt requires 4 by 4 or 8 by 8 element squares
declare target("riscv.ztt.matrix", i32, 16, 16) @invalid()

;--- width.ll
; WIDTH: ZTT element width must be a power of two from 1 to the profile's maximum width
declare target("riscv.ztt.matrix", i128, 8, 8) @invalid()

;--- scalar.ll
; SCALAR: ZTT element width must be a power of two from 1 to the profile's maximum width
declare target("riscv.ztt.acc", ptr, 8, 8) @invalid()

;--- arity.ll
; ARITY: ZTT types require an element type, rows, columns, and an optional square count
declare target("riscv.ztt.matrix", i32, 8) @invalid()

;--- packed.ll
; PACKED: ZTT square count must form a power-of-two group
declare target("riscv.ztt.matrix", i8, 8, 8, 1) @invalid()

;--- group.ll
; GROUP: ZTT square count must form a power-of-two group
declare target("riscv.ztt.matrix", i64, 8, 8, 16) @invalid()

;--- acc.ll
; ACC: ZTT square count must form a power-of-two group
declare target("riscv.ztt.acc", i32, 8, 8, 2) @invalid()

;--- acc-span.ll
; M now has 16 registers, but narrow ACC preservation still cannot exceed 8.
declare target("riscv.ztt.acc", i2, 8, 8) @invalid()
