; RUN: opt -passes=verify -disable-output %s
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+boscztt -O0 -verify-machineinstrs -filetype=obj < %s -o /dev/null
; RUN: llc -mtriple=riscv64 -mattr=+boscztt,+v -verify-machineinstrs -filetype=obj < %s -o /dev/null

; Check the first spill and reload, including the descriptor and raw image,
; with exact physical registers and stack offsets.
; Force 18 live M values into 16 registers and ten ACC values into eight.
; Descriptors must survive
; the allocator's copies/spills as well as matrix bits. No RVV state is needed.
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "riscv64"
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8), i64)
declare target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8))
; CHECK-LABEL: pressure_matrix32:
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m2{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 288{{$}}
; CHECK-NEXT: mss.1r m2, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: msettyp m15, a0{{$}}
; CHECK-NEXT: msettyp m2, a0{{$}}
; CHECK-NEXT: msettyp m3, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m3{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mss.1r m3, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: msettyp m3, a0{{$}}
; CHECK-NEXT: msettyp m4, a0{{$}}
; CHECK-NEXT: msettyp m5, a0{{$}}
; CHECK-NEXT: msettyp m6, a0{{$}}
; CHECK-NEXT: msettyp m7, a0{{$}}
; CHECK-NEXT: msettyp m8, a0{{$}}
; CHECK-NEXT: msettyp m9, a0{{$}}
; CHECK-NEXT: msettyp m10, a0{{$}}
; CHECK-NEXT: msettyp m11, a0{{$}}
; CHECK-NEXT: msettyp m12, a0{{$}}
; CHECK-NEXT: msettyp m13, a0{{$}}
; CHECK-NEXT: msettyp m14, a0{{$}}
; CHECK-NEXT: mzero.2d.m m0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 808{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 816{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.m m1{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m1{{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 552{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m1, t1{{$}}
; CHECK-NEXT: addi t0, sp, 288{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK: ret{{$}}
define i64 @pressure_matrix32() {
  %a0 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a1 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a2 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a3 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a4 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a5 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a6 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a7 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a8 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a9 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a10 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a11 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a12 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a13 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a14 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a15 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a16 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %a17 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 32)
  %b0 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a0)
  %b1 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a1)
  %b2 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a2)
  %b3 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a3)
  %b4 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a4)
  %b5 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a5)
  %b6 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a6)
  %b7 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a7)
  %b8 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a8)
  %b9 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a9)
  %b10 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a10)
  %b11 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a11)
  %b12 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a12)
  %b13 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a13)
  %b14 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a14)
  %b15 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a15)
  %b16 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a16)
  %b17 = call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %a17)
  %v0 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b0)
  %v1 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b1)
  %v2 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b2)
  %v3 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b3)
  %v4 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b4)
  %v5 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b5)
  %v6 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b6)
  %v7 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b7)
  %v8 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b8)
  %v9 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b9)
  %v10 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b10)
  %v11 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b11)
  %v12 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b12)
  %v13 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b13)
  %v14 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b14)
  %v15 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b15)
  %v16 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b16)
  %v17 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) %b17)
  %sum1 = add i64 %v0, %v1
  %sum2 = add i64 %sum1, %v2
  %sum3 = add i64 %sum2, %v3
  %sum4 = add i64 %sum3, %v4
  %sum5 = add i64 %sum4, %v5
  %sum6 = add i64 %sum5, %v6
  %sum7 = add i64 %sum6, %v7
  %sum8 = add i64 %sum7, %v8
  %sum9 = add i64 %sum8, %v9
  %sum10 = add i64 %sum9, %v10
  %sum11 = add i64 %sum10, %v11
  %sum12 = add i64 %sum11, %v12
  %sum13 = add i64 %sum12, %v13
  %sum14 = add i64 %sum13, %v14
  %sum15 = add i64 %sum14, %v15
  %sum16 = add i64 %sum15, %v16
  %sum17 = add i64 %sum16, %v17
  ret i64 %sum17
}
declare target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8), i64)
declare target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8))
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8))
; CHECK-LABEL: pressure_matrix64:
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m4{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mss.1r m4, t0{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: mss.1r m5, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: msettyp m4, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m4{{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 552{{$}}
; CHECK-NEXT: mss.1r m4, t0{{$}}
; CHECK-NEXT: addi t0, sp, 808{{$}}
; CHECK-NEXT: mss.1r m5, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: msettyp m4, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m4{{$}}
; CHECK-NEXT: addi t0, sp, 1072{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 1080{{$}}
; CHECK-NEXT: mss.1r m4, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1336{{$}}
; CHECK-NEXT: mss.1r m5, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.m m8{{$}}
; CHECK-NEXT: mzero.2d.m m10{{$}}
; CHECK-NEXT: mzero.2d.m m12{{$}}
; CHECK-NEXT: mzero.2d.m m14{{$}}
; CHECK-NEXT: mzero.2d.m m0{{$}}
; CHECK-NEXT: mzero.2d.m m2{{$}}
; CHECK-NEXT: mzero.2d.m m6{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m4, t1{{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mls.1r m4, t0{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: mls.1r m5, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK: ret{{$}}
define i64 @pressure_matrix64() {
  %a0 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a1 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a2 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a3 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a4 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a5 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a6 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a7 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a8 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %a9 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i64_8_8t.i64(target("riscv.ztt.matrix", i64, 8, 8) undef, i64 64)
  %b0 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a0)
  %b1 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a1)
  %b2 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a2)
  %b3 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a3)
  %b4 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a4)
  %b5 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a5)
  %b6 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a6)
  %b7 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a7)
  %b8 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a8)
  %b9 = call target("riscv.ztt.matrix", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %a9)
  %v0 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b0)
  %v1 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b1)
  %v2 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b2)
  %v3 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b3)
  %v4 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b4)
  %v5 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b5)
  %v6 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b6)
  %v7 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b7)
  %v8 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b8)
  %v9 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i64_8_8t(target("riscv.ztt.matrix", i64, 8, 8) %b9)
  %sum1 = add i64 %v0, %v1
  %sum2 = add i64 %sum1, %v2
  %sum3 = add i64 %sum2, %v3
  %sum4 = add i64 %sum3, %v4
  %sum5 = add i64 %sum4, %v5
  %sum6 = add i64 %sum5, %v6
  %sum7 = add i64 %sum6, %v7
  %sum8 = add i64 %sum7, %v8
  %sum9 = add i64 %sum8, %v9
  ret i64 %sum9
}
declare target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8), i64)
declare target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8))
declare i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8))
; CHECK-LABEL: pressure_matrix8:
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m2{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 288{{$}}
; CHECK-NEXT: mss.1r m2, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: msettyp m15, a0{{$}}
; CHECK-NEXT: msettyp m2, a0{{$}}
; CHECK-NEXT: msettyp m3, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m3{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 24{{$}}
; CHECK-NEXT: mss.1r m3, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: msettyp m3, a0{{$}}
; CHECK-NEXT: msettyp m4, a0{{$}}
; CHECK-NEXT: msettyp m5, a0{{$}}
; CHECK-NEXT: msettyp m6, a0{{$}}
; CHECK-NEXT: msettyp m7, a0{{$}}
; CHECK-NEXT: msettyp m8, a0{{$}}
; CHECK-NEXT: msettyp m9, a0{{$}}
; CHECK-NEXT: msettyp m10, a0{{$}}
; CHECK-NEXT: msettyp m11, a0{{$}}
; CHECK-NEXT: msettyp m12, a0{{$}}
; CHECK-NEXT: msettyp m13, a0{{$}}
; CHECK-NEXT: msettyp m14, a0{{$}}
; CHECK-NEXT: mzero.2d.m m0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 808{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 816{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.m m1{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m1{{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 552{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: addi t0, sp, 280{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m1, t1{{$}}
; CHECK-NEXT: addi t0, sp, 288{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK: ret{{$}}
define i64 @pressure_matrix8() {
  %a0 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a1 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a2 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a3 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a4 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a5 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a6 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a7 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a8 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a9 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a10 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a11 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a12 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a13 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a14 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a15 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a16 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %a17 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i8_8_8t.i64(target("riscv.ztt.matrix", i8, 8, 8) undef, i64 8)
  %b0 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a0)
  %b1 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a1)
  %b2 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a2)
  %b3 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a3)
  %b4 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a4)
  %b5 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a5)
  %b6 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a6)
  %b7 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a7)
  %b8 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a8)
  %b9 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a9)
  %b10 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a10)
  %b11 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a11)
  %b12 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a12)
  %b13 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a13)
  %b14 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a14)
  %b15 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a15)
  %b16 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a16)
  %b17 = call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %a17)
  %v0 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b0)
  %v1 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b1)
  %v2 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b2)
  %v3 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b3)
  %v4 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b4)
  %v5 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b5)
  %v6 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b6)
  %v7 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b7)
  %v8 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b8)
  %v9 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b9)
  %v10 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b10)
  %v11 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b11)
  %v12 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b12)
  %v13 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b13)
  %v14 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b14)
  %v15 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b15)
  %v16 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b16)
  %v17 = call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i8, 8, 8) %b17)
  %sum1 = add i64 %v0, %v1
  %sum2 = add i64 %sum1, %v2
  %sum3 = add i64 %sum2, %v3
  %sum4 = add i64 %sum3, %v4
  %sum5 = add i64 %sum4, %v5
  %sum6 = add i64 %sum5, %v6
  %sum7 = add i64 %sum6, %v7
  %sum8 = add i64 %sum7, %v8
  %sum9 = add i64 %sum8, %v9
  %sum10 = add i64 %sum9, %v10
  %sum11 = add i64 %sum10, %v11
  %sum12 = add i64 %sum11, %v12
  %sum13 = add i64 %sum12, %v13
  %sum14 = add i64 %sum13, %v14
  %sum15 = add i64 %sum14, %v15
  %sum16 = add i64 %sum15, %v16
  %sum17 = add i64 %sum16, %v17
  ret i64 %sum17
}
declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8), i64)
declare target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))
declare i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8))
; CHECK-LABEL: pressure_acc32:
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 57{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 65{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 321{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 624{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 632{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 888{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 104{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 112{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 368{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 624{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 632{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 888{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: asettyp acc1, a0{{$}}
; CHECK-NEXT: asettyp acc3, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1625{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1633{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1889{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc3{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1105{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc3{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1113{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1369{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1625{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1633{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1889{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.acc acc4{{$}}
; CHECK-NEXT: mzero.2d.acc acc5{{$}}
; CHECK-NEXT: mzero.2d.acc acc6{{$}}
; CHECK-NEXT: mzero.2d.acc acc7{{$}}
; CHECK-NEXT: mzero.2d.acc acc2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 1576{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 1584{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1840{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc2{{$}}
; CHECK-NEXT: addi t0, sp, 1056{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc2{{$}}
; CHECK-NEXT: addi t0, sp, 1064{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1320{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1576{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 1584{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1840{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 57{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: asettyp acc3, t1{{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 65{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 321{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: mmov.a.m acc3, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK: ret{{$}}
define i64 @pressure_acc32() {
  %a0 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a1 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a2 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a3 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a4 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a5 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a6 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a7 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a8 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %a9 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 32)
  %b0 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a0)
  %b1 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a1)
  %b2 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a2)
  %b3 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a3)
  %b4 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a4)
  %b5 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a5)
  %b6 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a6)
  %b7 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a7)
  %b8 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a8)
  %b9 = call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %a9)
  %v0 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b0)
  %v1 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b1)
  %v2 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b2)
  %v3 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b3)
  %v4 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b4)
  %v5 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b5)
  %v6 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b6)
  %v7 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b7)
  %v8 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b8)
  %v9 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) %b9)
  %sum1 = add i64 %v0, %v1
  %sum2 = add i64 %sum1, %v2
  %sum3 = add i64 %sum2, %v3
  %sum4 = add i64 %sum3, %v4
  %sum5 = add i64 %sum4, %v5
  %sum6 = add i64 %sum5, %v6
  %sum7 = add i64 %sum6, %v7
  %sum8 = add i64 %sum7, %v8
  %sum9 = add i64 %sum8, %v9
  ret i64 %sum9
}
declare target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8), i64)
declare target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8))
declare i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8))
; CHECK-LABEL: pressure_acc64:
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 57{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 65{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 321{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 624{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 632{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 888{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 104{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 112{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 368{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 624{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 632{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 888{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: asettyp acc1, a0{{$}}
; CHECK-NEXT: asettyp acc3, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1625{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1633{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1889{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc3{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1105{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc3{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1113{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1369{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1625{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1633{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1889{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: mzero.2d.acc acc4{{$}}
; CHECK-NEXT: mzero.2d.acc acc5{{$}}
; CHECK-NEXT: mzero.2d.acc acc6{{$}}
; CHECK-NEXT: mzero.2d.acc acc7{{$}}
; CHECK-NEXT: mzero.2d.acc acc2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 1576{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 1584{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1840{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc2{{$}}
; CHECK-NEXT: addi t0, sp, 1056{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc2{{$}}
; CHECK-NEXT: addi t0, sp, 1064{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1320{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1576{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 1584{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 1840{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 57{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: asettyp acc3, t1{{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 65{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 321{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: mmov.a.m acc3, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK: ret{{$}}
define i64 @pressure_acc64() {
  %a0 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a1 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a2 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a3 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a4 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a5 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a6 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a7 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a8 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %a9 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i64_8_8t.i64(target("riscv.ztt.acc", i64, 8, 8) undef, i64 64)
  %b0 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a0)
  %b1 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a1)
  %b2 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a2)
  %b3 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a3)
  %b4 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a4)
  %b5 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a5)
  %b6 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a6)
  %b7 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a7)
  %b8 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a8)
  %b9 = call target("riscv.ztt.acc", i64, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %a9)
  %v0 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b0)
  %v1 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b1)
  %v2 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b2)
  %v3 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b3)
  %v4 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b4)
  %v5 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b5)
  %v6 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b6)
  %v7 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b7)
  %v8 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b8)
  %v9 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i64_8_8t(target("riscv.ztt.acc", i64, 8, 8) %b9)
  %sum1 = add i64 %v0, %v1
  %sum2 = add i64 %sum1, %v2
  %sum3 = add i64 %sum2, %v3
  %sum4 = add i64 %sum3, %v4
  %sum5 = add i64 %sum4, %v5
  %sum6 = add i64 %sum5, %v6
  %sum7 = add i64 %sum6, %v7
  %sum8 = add i64 %sum7, %v8
  %sum9 = add i64 %sum8, %v9
  ret i64 %sum9
}
declare target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8), i64)
declare target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8))
declare i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8))
; CHECK-LABEL: pressure_acc8:
; CHECK: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1097{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1105{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1361{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1097{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1105{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1361{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc4, a0{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 536{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 544{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 800{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: addi t0, sp, 16{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
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
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, 168{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, 176{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, 432{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, -352{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, -344{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, -88{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, 168{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, 176{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 2{{$}}
; CHECK-NEXT: addi a1, a1, 432{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1656{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1664{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1920{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1136{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1144{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1400{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1656{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1664{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 1{{$}}
; CHECK-NEXT: addi a1, a1, 1920{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1320{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1312{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1056{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1840{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1832{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1576{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1320{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1312{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, -1056{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1288{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1296{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1552{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 768{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 776{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1032{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1288{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1296{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 3{{$}}
; CHECK-NEXT: addi a1, a1, 1552{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -200{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -192{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, 64{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -720{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -712{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -456{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -200{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, -192{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 4{{$}}
; CHECK-NEXT: addi a1, a1, 64{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 920{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 928{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 1184{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 400{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 408{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 664{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 920{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 928{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a1, 5{{$}}
; CHECK-NEXT: addi a1, a1, 1184{{$}}
; CHECK-NEXT: add t0, sp, a1{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: asettyp acc0, a0{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1688{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1680{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1424{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: agettyp t1, acc0{{$}}
; CHECK-NEXT: lui a0, 4{{$}}
; CHECK-NEXT: addi a0, a0, 1888{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: mmov.m.a m0, acc0{{$}}
; CHECK-NEXT: lui a0, 4{{$}}
; CHECK-NEXT: addi a0, a0, 1896{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1944{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1688{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1680{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: lui a0, 5{{$}}
; CHECK-NEXT: addi a0, a0, -1424{{$}}
; CHECK-NEXT: add t0, sp, a0{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK-NEXT: csrr t2, amestatus{{$}}
; CHECK-NEXT: mgettyp t1, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1097{{$}}
; CHECK-NEXT: sw t1, 0(t0){{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1105{{$}}
; CHECK-NEXT: mss.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1361{{$}}
; CHECK-NEXT: mss.1r m1, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 577{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: asettyp acc0, t1{{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 585{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 841{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: mmov.a.m acc0, m0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1097{{$}}
; CHECK-NEXT: lw t1, 0(t0){{$}}
; CHECK-NEXT: msettyp m0, t1{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1105{{$}}
; CHECK-NEXT: mls.1r m0, t0{{$}}
; CHECK-NEXT: addi t0, sp, 2047{{$}}
; CHECK-NEXT: addi t0, t0, 1361{{$}}
; CHECK-NEXT: mls.1r m1, t0{{$}}
; CHECK-NEXT: csrw amestatus, t2{{$}}
; CHECK: ret{{$}}
define i64 @pressure_acc8() {
  %a0 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a1 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a2 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a3 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a4 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a5 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a6 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a7 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a8 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %a9 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i8_8_8t.i64(target("riscv.ztt.acc", i8, 8, 8) undef, i64 8)
  %b0 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a0)
  %b1 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a1)
  %b2 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a2)
  %b3 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a3)
  %b4 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a4)
  %b5 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a5)
  %b6 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a6)
  %b7 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a7)
  %b8 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a8)
  %b9 = call target("riscv.ztt.acc", i8, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %a9)
  %v0 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b0)
  %v1 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b1)
  %v2 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b2)
  %v3 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b3)
  %v4 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b4)
  %v5 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b5)
  %v6 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b6)
  %v7 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b7)
  %v8 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b8)
  %v9 = call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i8_8_8t(target("riscv.ztt.acc", i8, 8, 8) %b9)
  %sum1 = add i64 %v0, %v1
  %sum2 = add i64 %sum1, %v2
  %sum3 = add i64 %sum2, %v3
  %sum4 = add i64 %sum3, %v4
  %sum5 = add i64 %sum4, %v5
  %sum6 = add i64 %sum5, %v6
  %sum7 = add i64 %sum6, %v7
  %sum8 = add i64 %sum7, %v8
  %sum9 = add i64 %sum8, %v9
  ret i64 %sum9
}
