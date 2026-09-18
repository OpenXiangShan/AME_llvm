// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -std=c11 -ffreestanding -Wall -Wextra -Werror -O0 -S -emit-llvm %s -o %t.ll
// RUN: opt -passes=verify -disable-output %t.ll
// RUN: FileCheck %s --check-prefix=IR < %t.ll
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -std=c11 -ffreestanding -Wall -Wextra -Werror -O0 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -std=c11 -ffreestanding -O2 -S %s -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=riscv64 -mattr=+m,+boscztt,+boscztt-ame-gem5 -filetype=obj %t.s -o %t.o

// Exercise the same complete 8-by-8 data/golden tables with 4-by-4 registers.
#include "real-data.c"

// IR-LABEL: define {{.*}} @ztt_i32_gemm(
// IR: call target("riscv.ztt.matrix", i32, 4, 4) @llvm.riscv.ztt.msettyp.
// IR: call target("riscv.ztt.acc", i32, 4, 4) @llvm.riscv.ztt.asettyp.
// IR: @llvm.riscv.ztt.mls.st.
// IR: @llvm.riscv.ztt.mmulacc.2d.
// ASM-LABEL: ztt_i32_gemm:
// ASM: mmulacc.2d acc0, m1, m2{{$}}
// ASM-LABEL: ztt_i32_strided:
// ASM: mls.cm m2, a5{{$}}
// ASM-LABEL: ztt_i32_pressure:
// ASM: msettyp m31, a3{{$}}
// ASM-NEXT: mls.st m31, (t4), s6{{$}}
// ASM-NEXT: li a5, 29{{$}}
// ASM-NEXT: madd.ew.x m31, a5, m31{{$}}
// ASM: mss.1r m4, t0{{$}}
// ASM: mss.st m31, (ra), s6{{$}}
// ASM: mls.1r m4, t0{{$}}
