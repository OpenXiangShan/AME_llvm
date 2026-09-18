// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -std=c++17 -ffreestanding -Wall -Wextra -Werror -O0 -S -emit-llvm %s -o %t.ll
// RUN: opt -passes=verify -disable-output %t.ll
// RUN: FileCheck %s --check-prefix=IR < %t.ll
// RUN: %clang -target riscv32 -march=rv32im_boscztt -mboscztt-profile=ame-gem5 -std=c++17 -ffreestanding -Wall -Wextra -Werror -O0 -c %s -o %t.o
// RUN: %clang -target riscv64 -march=rv64im_boscztt -mboscztt-profile=ame-gem5 -std=c++17 -ffreestanding -O2 -S %s -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=riscv64 -mattr=+m,+boscztt,+boscztt-ame-gem5 -filetype=obj %t.s -o %t.o

// Exercise the same complete 8-by-8 data/golden tables with 4-by-4 registers.
#include "real-data.cpp"

// IR-LABEL: define {{.*}} @ztt_f32_accumulate(
// IR: call target("riscv.ztt.matrix", float, 4, 4) @llvm.riscv.ztt.msettyp.
// IR: @llvm.riscv.ztt.mmov.a.m.
// IR: call {{.*}} @_Z10accumulate
// IR-LABEL: define {{.*}} @ztt_i64_subtract(
// IR: call target("riscv.ztt.matrix", i64, 4, 4) @llvm.riscv.ztt.msettyp.
// ASM-LABEL: ztt_f32_accumulate:
// ASM: mls.st m2, (a3), s4{{$}}
// ASM: mmov.m.a m0, acc0{{$}}
// ASM-NEXT: mss.st m0, (a0), s4{{$}}
// ASM-LABEL: _Z10accumulateIu17__boscztt_m_f32_tu19__boscztt_acc_f32_tET0_S0_T_S1_:
// ASM: mmulacc.2d acc0, m0, m1{{$}}
// ASM-NEXT: ret{{$}}
