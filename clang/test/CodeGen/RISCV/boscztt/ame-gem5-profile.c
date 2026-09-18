// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -emit-llvm -O0 %s -o - | FileCheck %s --check-prefix=IR
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -S -O1 %s -o - | FileCheck %s --check-prefix=ASM

// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -emit-obj -O0 %s -o %t.o
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -emit-pch -x c-header %s -o %t.pch
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -include-pch %t.pch -x c /dev/null -emit-llvm -o - | FileCheck %s --check-prefix=IR

#include <RISCVBoscZtt.h>

_Static_assert(__riscv_boscztt_tile_side == 4, "AME_gem5 tile side");
_Static_assert(__riscv_boscztt_m_registers == 32, "AME_gem5 M count");
_Static_assert(__riscv_boscztt_acc_registers == 4, "AME_gem5 ACC count");

// IR-LABEL: @identity(
// IR-SAME: target("riscv.ztt.matrix", i32, 4, 4, 32)
// IR: ret target("riscv.ztt.matrix", i32, 4, 4, 32)
// ASM-LABEL: identity:
// ASM: ret{{$}}
boscztt_m_i32_x32_t identity(boscztt_m_i32_x32_t value) { return value; }

// IR-LABEL: @add(
// IR-SAME: target("riscv.ztt.matrix", i32, 4, 4)
// IR: call target("riscv.ztt.matrix", i32, 4, 4) @llvm.riscv.ztt.madd.ew.
// ASM-LABEL: add:
// ASM: madd.ew m0, m1, m2{{$}}
boscztt_m_i32_t add(boscztt_m_i32_t d, boscztt_m_i32_t a,
                    boscztt_m_i32_t b) {
  madd_ew(d, a, b);
  return d;
}

// IR-LABEL: @clear_acc(
// IR: target("riscv.ztt.acc", i32, 4, 4)
// ASM-LABEL: clear_acc:
// ASM: mzero.2d.acc acc0{{$}}
boscztt_acc_i32_t clear_acc(boscztt_acc_i32_t value) {
  mzero_2d_acc(value);
  return value;
}

// Every additional full-file type keeps its element and square count in IR.
// IR-LABEL: @full_i1(
// IR: ret target("riscv.ztt.matrix", i1, 4, 4, 1024)
// ASM-LABEL: full_i1:
// ASM: ret{{$}}
boscztt_m_i1_x1024_t full_i1(boscztt_m_i1_x1024_t value) { return value; }

// IR-LABEL: @full_i2(
// IR: ret target("riscv.ztt.matrix", i2, 4, 4, 512)
// ASM-LABEL: full_i2:
// ASM: ret{{$}}
boscztt_m_i2_x512_t full_i2(boscztt_m_i2_x512_t value) { return value; }

// IR-LABEL: @full_i4(
// IR: ret target("riscv.ztt.matrix", i4, 4, 4, 256)
// ASM-LABEL: full_i4:
// ASM: ret{{$}}
boscztt_m_i4_x256_t full_i4(boscztt_m_i4_x256_t value) { return value; }

// IR-LABEL: @full_i8(
// IR: ret target("riscv.ztt.matrix", i8, 4, 4, 128)
// ASM-LABEL: full_i8:
// ASM: ret{{$}}
boscztt_m_i8_x128_t full_i8(boscztt_m_i8_x128_t value) { return value; }

// IR-LABEL: @full_i16(
// IR: ret target("riscv.ztt.matrix", i16, 4, 4, 64)
// ASM-LABEL: full_i16:
// ASM: ret{{$}}
boscztt_m_i16_x64_t full_i16(boscztt_m_i16_x64_t value) { return value; }

// IR-LABEL: @full_i32(
// IR: ret target("riscv.ztt.matrix", i32, 4, 4, 32)
// ASM-LABEL: full_i32:
// ASM: ret{{$}}
boscztt_m_i32_x32_t full_i32(boscztt_m_i32_x32_t value) { return value; }

// IR-LABEL: @full_i64(
// IR: ret target("riscv.ztt.matrix", i64, 4, 4, 16)
// ASM-LABEL: full_i64:
// ASM: ret{{$}}
boscztt_m_i64_x16_t full_i64(boscztt_m_i64_x16_t value) { return value; }

// A 128-bit square spans four M registers or one ACC register.
// IR-LABEL: @wide_i128(
// IR: ret target("riscv.ztt.matrix", i128, 4, 4)
// ASM-LABEL: wide_i128:
// ASM: ret{{$}}
boscztt_m_i128_t wide_i128(boscztt_m_i128_t value) { return value; }

// IR-LABEL: @wide_i128_x2(
// IR: ret target("riscv.ztt.matrix", i128, 4, 4, 2)
// ASM-LABEL: wide_i128_x2:
// ASM: ret{{$}}
boscztt_m_i128_x2_t wide_i128_x2(boscztt_m_i128_x2_t value) { return value; }

// IR-LABEL: @wide_i128_x4(
// IR: ret target("riscv.ztt.matrix", i128, 4, 4, 4)
// ASM-LABEL: wide_i128_x4:
// ASM: ret{{$}}
boscztt_m_i128_x4_t wide_i128_x4(boscztt_m_i128_x4_t value) { return value; }

// IR-LABEL: @full_i128(
// IR: ret target("riscv.ztt.matrix", i128, 4, 4, 8)
// ASM-LABEL: full_i128:
// ASM: ret{{$}}
boscztt_m_i128_x8_t full_i128(boscztt_m_i128_x8_t value) { return value; }

// IR-LABEL: @acc_i128(
// IR: ret target("riscv.ztt.acc", i128, 4, 4)
// ASM-LABEL: acc_i128:
// ASM: ret{{$}}
boscztt_acc_i128_t acc_i128(boscztt_acc_i128_t value) { return value; }

// IR-LABEL: @full_f16(
// IR: ret target("riscv.ztt.matrix", half, 4, 4, 64)
// ASM-LABEL: full_f16:
// ASM: ret{{$}}
boscztt_m_f16_x64_t full_f16(boscztt_m_f16_x64_t value) { return value; }

// IR-LABEL: @full_bf16(
// IR: ret target("riscv.ztt.matrix", bfloat, 4, 4, 64)
// ASM-LABEL: full_bf16:
// ASM: ret{{$}}
boscztt_m_bf16_x64_t full_bf16(boscztt_m_bf16_x64_t value) { return value; }

// IR-LABEL: @full_f32(
// IR: ret target("riscv.ztt.matrix", float, 4, 4, 32)
// ASM-LABEL: full_f32:
// ASM: ret{{$}}
boscztt_m_f32_x32_t full_f32(boscztt_m_f32_x32_t value) { return value; }

// IR-LABEL: @full_f64(
// IR: ret target("riscv.ztt.matrix", double, 4, 4, 16)
// ASM-LABEL: full_f64:
// ASM: ret{{$}}
boscztt_m_f64_x16_t full_f64(boscztt_m_f64_x16_t value) { return value; }
