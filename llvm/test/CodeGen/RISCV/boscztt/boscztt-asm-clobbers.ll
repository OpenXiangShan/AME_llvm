; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs -stop-after=finalize-isel %s -o - | FileCheck %s --check-prefix=MIR
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -stop-after=finalize-isel %s -o - | FileCheck %s --check-prefix=MIR
; RUN: llc -mtriple=riscv32 -mattr=+boscztt -verify-machineinstrs -filetype=obj %s -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -verify-machineinstrs -filetype=obj %s -o /dev/null

; Check the physical bank, not just its assembly name: XAIFET mask registers
; also print as m0-m7. Clobbers must invalidate every alias of the ZTT register.
; MIR-LABEL: name: clobbers
; MIR: INLINEASM
; MIR-SAME: implicit-def early-clobber $zttm0
; MIR-SAME: implicit-def early-clobber $zttm1
; MIR-SAME: implicit-def early-clobber $zttm7
; MIR-SAME: implicit-def early-clobber $zttm15
; MIR-SAME: implicit-def early-clobber $ztta0
; MIR-SAME: implicit-def early-clobber $ztta3
define void @clobbers() {
  call void asm sideeffect "", "~{m0},~{m1},~{m7},~{m15},~{acc0},~{acc3},~{memory}"()
  ret void
}
