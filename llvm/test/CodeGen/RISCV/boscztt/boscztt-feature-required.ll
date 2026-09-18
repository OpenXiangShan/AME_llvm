; RUN: not llc -mtriple=riscv64 -mattr=-boscztt < %s 2>&1 | FileCheck %s
; CHECK: llvm.riscv.ztt.ame.release
; CHECK-SAME: boscztt

declare void @llvm.riscv.ztt.ame.release()
define void @disabled() {
  call void @llvm.riscv.ztt.ame.release()
  ret void
}
