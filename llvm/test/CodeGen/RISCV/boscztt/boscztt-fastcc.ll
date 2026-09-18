; REQUIRES: riscv-registered-target
; RUN: split-file %s %t
; RUN: llc -mtriple=riscv32 -mattr=+boscztt -verify-machineinstrs %t/default.ll -o - | FileCheck %s --check-prefix=DEFAULT
; RUN: llc -mtriple=riscv32 -mattr=+boscztt -verify-machineinstrs -O0 -filetype=obj %t/default.ll -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs %t/default.ll -o - | FileCheck %s --check-prefix=DEFAULT
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs -O0 -filetype=obj %t/default.ll -o /dev/null
; RUN: llc -mtriple=riscv32 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs %t/ame.ll -o - | FileCheck %s --check-prefix=AME
; RUN: llc -mtriple=riscv32 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -O0 -filetype=obj %t/ame.ll -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs %t/ame.ll -o - | FileCheck %s --check-prefix=AME
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -O0 -filetype=obj %t/ame.ll -o /dev/null

;--- default.ll
declare void @external()

; DEFAULT-LABEL: preserve_matrix1:
; DEFAULT: mgettyp t1, m0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: msettyp m0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 8, 8, 1) @preserve_matrix1(target("riscv.ztt.matrix", i32, 8, 8, 1) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 8, 8, 1) %m
}

; DEFAULT-LABEL: preserve_matrix2:
; DEFAULT: mgettyp t1, m0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: msettyp m0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 8, 8, 2) @preserve_matrix2(target("riscv.ztt.matrix", i32, 8, 8, 2) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 8, 8, 2) %m
}

; DEFAULT-LABEL: preserve_matrix4:
; DEFAULT: mgettyp t1, m0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: msettyp m0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 8, 8, 4) @preserve_matrix4(target("riscv.ztt.matrix", i32, 8, 8, 4) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 8, 8, 4) %m
}

; DEFAULT-LABEL: preserve_matrix8:
; DEFAULT: mgettyp t1, m0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: msettyp m0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 8, 8, 8) @preserve_matrix8(target("riscv.ztt.matrix", i32, 8, 8, 8) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 8, 8, 8) %m
}

; DEFAULT-LABEL: preserve_matrix16:
; DEFAULT: mgettyp t1, m0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: msettyp m0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 8, 8, 16) @preserve_matrix16(target("riscv.ztt.matrix", i32, 8, 8, 16) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 8, 8, 16) %m
}

; DEFAULT-LABEL: preserve_acc1:
; DEFAULT: agettyp t1, acc0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: asettyp acc0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.acc", i32, 8, 8, 1) @preserve_acc1(target("riscv.ztt.acc", i32, 8, 8, 1) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i32, 8, 8, 1) %m
}

; DEFAULT-LABEL: preserve_acc2:
; DEFAULT: agettyp t1, acc0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: asettyp acc0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.acc", i16, 8, 8, 2) @preserve_acc2(target("riscv.ztt.acc", i16, 8, 8, 2) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i16, 8, 8, 2) %m
}

; DEFAULT-LABEL: preserve_acc4:
; DEFAULT: agettyp t1, acc0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: asettyp acc0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.acc", i8, 8, 8, 4) @preserve_acc4(target("riscv.ztt.acc", i8, 8, 8, 4) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i8, 8, 8, 4) %m
}

; DEFAULT-LABEL: preserve_acc8:
; DEFAULT: agettyp t1, acc0{{$}}
; DEFAULT: call external{{$}}
; DEFAULT: asettyp acc0, t1{{$}}
; DEFAULT: ret{{$}}
define fastcc target("riscv.ztt.acc", i4, 8, 8, 8) @preserve_acc8(target("riscv.ztt.acc", i4, 8, 8, 8) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i4, 8, 8, 8) %m
}


;--- ame.ll
declare void @external()

; AME-LABEL: preserve_matrix1:
; AME: mgettyp t1, m0{{$}}
; AME: call external{{$}}
; AME: msettyp m0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 4, 4, 1) @preserve_matrix1(target("riscv.ztt.matrix", i32, 4, 4, 1) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 1) %m
}

; AME-LABEL: preserve_matrix2:
; AME: mgettyp t1, m0{{$}}
; AME: call external{{$}}
; AME: msettyp m0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 4, 4, 2) @preserve_matrix2(target("riscv.ztt.matrix", i32, 4, 4, 2) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 2) %m
}

; AME-LABEL: preserve_matrix4:
; AME: mgettyp t1, m0{{$}}
; AME: call external{{$}}
; AME: msettyp m0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 4, 4, 4) @preserve_matrix4(target("riscv.ztt.matrix", i32, 4, 4, 4) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 4) %m
}

; AME-LABEL: preserve_matrix8:
; AME: mgettyp t1, m0{{$}}
; AME: call external{{$}}
; AME: msettyp m0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 4, 4, 8) @preserve_matrix8(target("riscv.ztt.matrix", i32, 4, 4, 8) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 8) %m
}

; AME-LABEL: preserve_matrix16:
; AME: mgettyp t1, m0{{$}}
; AME: call external{{$}}
; AME: msettyp m0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 4, 4, 16) @preserve_matrix16(target("riscv.ztt.matrix", i32, 4, 4, 16) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 16) %m
}

; AME-LABEL: preserve_matrix32:
; AME: mgettyp t1, m0{{$}}
; AME: call external{{$}}
; AME: msettyp m0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.matrix", i32, 4, 4, 32) @preserve_matrix32(target("riscv.ztt.matrix", i32, 4, 4, 32) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 32) %m
}

; AME-LABEL: preserve_acc1:
; AME: agettyp t1, acc0{{$}}
; AME: call external{{$}}
; AME: asettyp acc0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.acc", i32, 4, 4, 1) @preserve_acc1(target("riscv.ztt.acc", i32, 4, 4, 1) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i32, 4, 4, 1) %m
}

; AME-LABEL: preserve_acc2:
; AME: agettyp t1, acc0{{$}}
; AME: call external{{$}}
; AME: asettyp acc0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.acc", i16, 4, 4, 2) @preserve_acc2(target("riscv.ztt.acc", i16, 4, 4, 2) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i16, 4, 4, 2) %m
}

; AME-LABEL: preserve_acc4:
; AME: agettyp t1, acc0{{$}}
; AME: call external{{$}}
; AME: asettyp acc0, t1{{$}}
; AME: ret{{$}}
define fastcc target("riscv.ztt.acc", i8, 4, 4, 4) @preserve_acc4(target("riscv.ztt.acc", i8, 4, 4, 4) %m) {
  call void @external()
  ret target("riscv.ztt.acc", i8, 4, 4, 4) %m
}
