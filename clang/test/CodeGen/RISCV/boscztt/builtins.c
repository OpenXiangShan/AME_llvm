// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-llvm -O0 %s -o %t.o0.ll
// RUN: FileCheck %s --check-prefix=IR64 < %t.o0.ll
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-llvm -O1 -disable-llvm-passes %s -o %t.64.ll
// RUN: FileCheck %s --check-prefix=IR64 < %t.64.ll
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -emit-llvm -O1 -disable-llvm-passes %s -o %t.32.ll
// RUN: FileCheck %s --check-prefix=IR32 < %t.32.ll
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -S -O1 %s -o - | FileCheck %s --check-prefix=ASM
// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -S -O1 %s -o - | FileCheck %s --check-prefix=ASM
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -emit-obj -O1 %s -o %t.o
// RUN: llvm-objdump -d --mattr=+boscztt %t.o | FileCheck %s --check-prefix=OBJ

// RUN: %clang_cc1 -triple riscv32 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -S -O1 %s -o - | FileCheck %s --check-prefix=ASM
// RUN: %clang_cc1 -triple riscv64 -target-feature +boscztt -target-feature +boscztt-ame-gem5 -S -O1 %s -o - | FileCheck %s --check-prefix=ASM

#include <RISCVBoscZtt.h>
#if !__has_builtin(mand_ew_x) || !__has_builtin(msettyp)
#error missing boscztt builtins
#endif

// All 138 Ztt v0.6 instructions. Matrix outputs are writable variables;
// returned scalars are unsigned long on both RV32 and RV64.

// ASM-LABEL: test_ame_acquire:
// OBJ-LABEL: <test_ame_acquire>:
// ASM: ame.acquire a0, a0{{$}}
// OBJ: ame.acquire a0, a0{{$}}
// IR32-LABEL: @test_ame_acquire(
// IR32: call i32 @llvm.riscv.ztt.ame.acquire.i32(i32 {{[^,)]+}})
// IR64-LABEL: @test_ame_acquire(
// IR64: call i64 @llvm.riscv.ztt.ame.acquire.i64(i64 {{[^,)]+}})
unsigned long test_ame_acquire(unsigned long p0) {
  return ame_acquire(p0);
}

// ASM-LABEL: test_ame_release:
// OBJ-LABEL: <test_ame_release>:
// ASM: ame.release{{$}}
// OBJ: ame.release{{$}}
// IR32-LABEL: @test_ame_release(
// IR32: call void @llvm.riscv.ztt.ame.release()
// IR64-LABEL: @test_ame_release(
// IR64: call void @llvm.riscv.ztt.ame.release()
void test_ame_release(void) {
  ame_release();
}

// ASM-LABEL: test_agettyp:
// OBJ-LABEL: <test_agettyp>:
// ASM: agettyp a0, acc0{{$}}
// OBJ: agettyp a0, acc0{{$}}
// IR32-LABEL: @test_agettyp(
// IR32: call i32 @llvm.riscv.ztt.agettyp.i32.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_agettyp(
// IR64: call i64 @llvm.riscv.ztt.agettyp.i64.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}})
unsigned long test_agettyp(boscztt_acc_i32_t p0) {
  return agettyp(p0);
}

// ASM-LABEL: test_asettyp:
// OBJ-LABEL: <test_asettyp>:
// ASM: asettyp acc0, a0{{$}}
// OBJ: asettyp acc0, a0{{$}}
// IR32-LABEL: @test_asettyp(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i32(target("riscv.ztt.acc", i32, 8, 8) undef, i32 {{[^,)]+}})
// IR64-LABEL: @test_asettyp(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.asettyp.triscv.ztt.acc_i32_8_8t.i64(target("riscv.ztt.acc", i32, 8, 8) undef, i64 {{[^,)]+}})
boscztt_acc_i32_t test_asettyp(unsigned long p1) {
  boscztt_acc_i32_t p0;
  asettyp(p0, p1);
  return p0;
}

// ASM-LABEL: test_mabs_ew:
// OBJ-LABEL: <test_mabs_ew>:
// ASM: mabs.ew m0, m1{{$}}
// OBJ: mabs.ew m0, m1{{$}}
// IR32-LABEL: @test_mabs_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabs.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mabs_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabs.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mabs_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mabs_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mabsdiff_ew:
// OBJ-LABEL: <test_mabsdiff_ew>:
// ASM: mabsdiff.ew m0, m1, m2{{$}}
// OBJ: mabsdiff.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mabsdiff_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mabsdiff_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mabsdiff_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mabsdiff_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mabsdiff_ew_x:
// OBJ-LABEL: <test_mabsdiff_ew_x>:
// ASM: mabsdiff.ew.x m0, a0, m1{{$}}
// OBJ: mabsdiff.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mabsdiff_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mabsdiff_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mabsdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mabsdiff_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mabsdiff_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_madd_ew:
// OBJ-LABEL: <test_madd_ew>:
// ASM: madd.ew m0, m1, m2{{$}}
// OBJ: madd.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_madd_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_madd_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_madd_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  madd_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_madd_ew_x:
// OBJ-LABEL: <test_madd_ew_x>:
// ASM: madd.ew.x m0, a0, m1{{$}}
// OBJ: madd.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_madd_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_madd_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.madd.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_madd_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  madd_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mand_ew:
// OBJ-LABEL: <test_mand_ew>:
// ASM: mand.ew m0, m1, m2{{$}}
// OBJ: mand.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mand_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mand_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mand_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mand_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mand_ew_x:
// OBJ-LABEL: <test_mand_ew_x>:
// ASM: mand.ew.x m0, a0, m1{{$}}
// OBJ: mand.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mand_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mand_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mand.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mand_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mand_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mandnot_ew:
// OBJ-LABEL: <test_mandnot_ew>:
// ASM: mandnot.ew m0, m1, m2{{$}}
// OBJ: mandnot.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mandnot_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mandnot_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mandnot_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mandnot_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mandnot_ew_x:
// OBJ-LABEL: <test_mandnot_ew_x>:
// ASM: mandnot.ew.x m0, a0, m1{{$}}
// OBJ: mandnot.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mandnot_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mandnot_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mandnot.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mandnot_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mandnot_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcmovge_ew:
// OBJ-LABEL: <test_mcmovge_ew>:
// ASM: mcmovge.ew m0, m1, m2{{$}}
// OBJ: mcmovge.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcmovge_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcmovge_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcmovge_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcmovge_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcmovlt_ew:
// OBJ-LABEL: <test_mcmovlt_ew>:
// ASM: mcmovlt.ew m0, m1, m2{{$}}
// OBJ: mcmovlt.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcmovlt_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovlt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcmovlt_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmovlt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcmovlt_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcmovlt_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcmpge_ew:
// OBJ-LABEL: <test_mcmpge_ew>:
// ASM: mcmpge.ew m0, m1, m2{{$}}
// OBJ: mcmpge.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcmpge_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcmpge_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcmpge_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcmpge_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcmpge_ew_x:
// OBJ-LABEL: <test_mcmpge_ew_x>:
// ASM: mcmpge.ew.x m0, a0, m1{{$}}
// OBJ: mcmpge.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mcmpge_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcmpge_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmpge.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcmpge_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mcmpge_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcmplt_ew:
// OBJ-LABEL: <test_mcmplt_ew>:
// ASM: mcmplt.ew m0, m1, m2{{$}}
// OBJ: mcmplt.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcmplt_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcmplt_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcmplt_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcmplt_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcmplt_ew_x:
// OBJ-LABEL: <test_mcmplt_ew_x>:
// ASM: mcmplt.ew.x m0, a0, m1{{$}}
// OBJ: mcmplt.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mcmplt_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcmplt_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcmplt.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcmplt_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mcmplt_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcolbcast_ew_x:
// OBJ-LABEL: <test_mcolbcast_ew_x>:
// ASM: mcolbcast.ew.x m0, a0, m1{{$}}
// OBJ: mcolbcast.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mcolbcast_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolbcast_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcolbcast_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mcolbcast_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcolgather_ew:
// OBJ-LABEL: <test_mcolgather_ew>:
// ASM: mcolgather.ew m0, m1, m2{{$}}
// OBJ: mcolgather.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcolgather_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolgather_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcolgather_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcolgather_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcolid_ew:
// OBJ-LABEL: <test_mcolid_ew>:
// ASM: mcolid.ew m0{{$}}
// OBJ: mcolid.ew m0{{$}}
// IR32-LABEL: @test_mcolid_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolid_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcolid_ew(boscztt_m_i32_t p0) {
  mcolid_ew(p0);
  return p0;
}

// ASM-LABEL: test_mcolshift_ew_x:
// OBJ-LABEL: <test_mcolshift_ew_x>:
// ASM: mcolshift.ew.x m0, a0, m1{{$}}
// OBJ: mcolshift.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mcolshift_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolshift.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolshift_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolshift.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcolshift_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mcolshift_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcolunzip_ew:
// OBJ-LABEL: <test_mcolunzip_ew>:
// ASM: mcolunzip.ew m0, m1{{$}}
// OBJ: mcolunzip.ew m0, m1{{$}}
// IR32-LABEL: @test_mcolunzip_ew(
// IR32: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolunzip_ew(
// IR64: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
void test_mcolunzip_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, void *out) {
  mcolunzip_ew(p0, p1);
  mss_1r(p0, out);
  mss_1r(p1, (char *)out + 256);
}

// ASM-LABEL: test_mcolzip_ew:
// OBJ-LABEL: <test_mcolzip_ew>:
// ASM: mcolzip.ew m0, m1{{$}}
// OBJ: mcolzip.ew m0, m1{{$}}
// IR32-LABEL: @test_mcolzip_ew(
// IR32: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolzip_ew(
// IR64: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mcolzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
void test_mcolzip_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, void *out) {
  mcolzip_ew(p0, p1);
  mss_1r(p0, out);
  mss_1r(p1, (char *)out + 256);
}

// ASM-LABEL: test_mconv_ew:
// OBJ-LABEL: <test_mconv_ew>:
// ASM: mconv.ew m0, m1{{$}}
// OBJ: mconv.ew m0, m1{{$}}
// IR32-LABEL: @test_mconv_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mconv_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mconv.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mconv_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mconv_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mbcast_m_x:
// OBJ-LABEL: <test_mbcast_m_x>:
// ASM: mbcast.m.x m0, a0, a1{{$}}
// OBJ: mbcast.m.x m0, a0, a1{{$}}
// IR32-LABEL: @test_mbcast_m_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mbcast.m.x.triscv.ztt.matrix_i32_8_8t.i32.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mbcast_m_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mbcast.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mbcast_m_x(boscztt_m_i32_t p0, unsigned long p1, unsigned long p2) {
  mbcast_m_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcos_ew:
// OBJ-LABEL: <test_mcos_ew>:
// ASM: mcos.ew m0, m1{{$}}
// OBJ: mcos.ew m0, m1{{$}}
// IR32-LABEL: @test_mcos_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcos.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcos_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcos.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcos_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mcos_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mexp2_ew:
// OBJ-LABEL: <test_mexp2_ew>:
// ASM: mexp2.ew m0, m1{{$}}
// OBJ: mexp2.ew m0, m1{{$}}
// IR32-LABEL: @test_mexp2_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mexp2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mexp2_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mexp2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mexp2_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mexp2_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mfrintm_ew:
// OBJ-LABEL: <test_mfrintm_ew>:
// ASM: mfrintm.ew m0, m1{{$}}
// OBJ: mfrintm.ew m0, m1{{$}}
// IR32-LABEL: @test_mfrintm_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintm.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mfrintm_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintm.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mfrintm_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mfrintm_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mfrintn_ew:
// OBJ-LABEL: <test_mfrintn_ew>:
// ASM: mfrintn.ew m0, m1{{$}}
// OBJ: mfrintn.ew m0, m1{{$}}
// IR32-LABEL: @test_mfrintn_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintn.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mfrintn_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintn.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mfrintn_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mfrintn_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mfrintp_ew:
// OBJ-LABEL: <test_mfrintp_ew>:
// ASM: mfrintp.ew m0, m1{{$}}
// OBJ: mfrintp.ew m0, m1{{$}}
// IR32-LABEL: @test_mfrintp_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mfrintp_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mfrintp_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mfrintp_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mfrintz_ew:
// OBJ-LABEL: <test_mfrintz_ew>:
// ASM: mfrintz.ew m0, m1{{$}}
// OBJ: mfrintz.ew m0, m1{{$}}
// IR32-LABEL: @test_mfrintz_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintz.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mfrintz_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mfrintz.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mfrintz_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mfrintz_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mgettyp:
// OBJ-LABEL: <test_mgettyp>:
// ASM: mgettyp a0, m0{{$}}
// OBJ: mgettyp a0, m0{{$}}
// IR32-LABEL: @test_mgettyp(
// IR32: call i32 @llvm.riscv.ztt.mgettyp.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mgettyp(
// IR64: call i64 @llvm.riscv.ztt.mgettyp.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
unsigned long test_mgettyp(boscztt_m_i32_t p0) {
  return mgettyp(p0);
}

// ASM-LABEL: test_mhdiff_ew:
// OBJ-LABEL: <test_mhdiff_ew>:
// ASM: mhdiff.ew m0, m1, m2{{$}}
// OBJ: mhdiff.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mhdiff_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mhdiff_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mhdiff_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mhdiff_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mhdiff_ew_x:
// OBJ-LABEL: <test_mhdiff_ew_x>:
// ASM: mhdiff.ew.x m0, a0, m1{{$}}
// OBJ: mhdiff.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mhdiff_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mhdiff_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mhdiff.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mhdiff_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mhdiff_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mldexp_ew:
// OBJ-LABEL: <test_mldexp_ew>:
// ASM: mldexp.ew m0, m1, m2{{$}}
// OBJ: mldexp.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mldexp_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mldexp_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mldexp_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mldexp_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mldexp_ew_x:
// OBJ-LABEL: <test_mldexp_ew_x>:
// ASM: mldexp.ew.x m0, a0, m1{{$}}
// OBJ: mldexp.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mldexp_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mldexp_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexp.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mldexp_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mldexp_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mldexpacc_ew:
// OBJ-LABEL: <test_mldexpacc_ew>:
// ASM: mldexpacc.ew m0, m1, m2{{$}}
// OBJ: mldexpacc.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mldexpacc_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mldexpacc_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mldexpacc_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mldexpacc_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mldexpacc_ew_x:
// OBJ-LABEL: <test_mldexpacc_ew_x>:
// ASM: mldexpacc.ew.x m0, a0, m1{{$}}
// OBJ: mldexpacc.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mldexpacc_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mldexpacc_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mldexpacc.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mldexpacc_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mldexpacc_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mlog2_ew:
// OBJ-LABEL: <test_mlog2_ew>:
// ASM: mlog2.ew m0, m1{{$}}
// OBJ: mlog2.ew m0, m1{{$}}
// IR32-LABEL: @test_mlog2_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mlog2_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mlog2_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mlog2_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mlog2sub_ew:
// OBJ-LABEL: <test_mlog2sub_ew>:
// ASM: mlog2sub.ew m0, m1, m2{{$}}
// OBJ: mlog2sub.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mlog2sub_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mlog2sub_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mlog2sub_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mlog2sub_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mlog2sub_ew_x:
// OBJ-LABEL: <test_mlog2sub_ew_x>:
// ASM: mlog2sub.ew.x m0, a0, m1{{$}}
// OBJ: mlog2sub.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mlog2sub_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mlog2sub_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mlog2sub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mlog2sub_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mlog2sub_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mls_1r:
// OBJ-LABEL: <test_mls_1r>:
// ASM: mls.1r m0, a0{{$}}
// OBJ: mls.1r m0, a0{{$}}
// IR32-LABEL: @test_mls_1r(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
// IR64-LABEL: @test_mls_1r(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
boscztt_m_i32_t test_mls_1r(boscztt_m_i32_t p0, void * p1) {
  mls_1r(p0, p1);
  return p0;
}

// ASM-LABEL: test_mls_cm:
// OBJ-LABEL: <test_mls_cm>:
// ASM: mls.cm m0, a0{{$}}
// OBJ: mls.cm m0, a0{{$}}
// IR32-LABEL: @test_mls_cm(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
// IR64-LABEL: @test_mls_cm(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
boscztt_m_i32_t test_mls_cm(boscztt_m_i32_t p0, void * p1) {
  mls_cm(p0, p1);
  return p0;
}

// ASM-LABEL: test_mls_rm:
// OBJ-LABEL: <test_mls_rm>:
// ASM: mls.rm m0, a0{{$}}
// OBJ: mls.rm m0, a0{{$}}
// IR32-LABEL: @test_mls_rm(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
// IR64-LABEL: @test_mls_rm(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
boscztt_m_i32_t test_mls_rm(boscztt_m_i32_t p0, void * p1) {
  mls_rm(p0, p1);
  return p0;
}

// ASM-LABEL: test_mls_st:
// OBJ-LABEL: <test_mls_st>:
// ASM: mls.st m0, (a0), a1{{$}}
// OBJ: mls.st m0, (a0), a1{{$}}
// IR32-LABEL: @test_mls_st(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.st.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mls_st(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.st.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mls_st(boscztt_m_i32_t p0, void * p1, unsigned long p2) {
  mls_st(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mls_tst:
// OBJ-LABEL: <test_mls_tst>:
// ASM: mls.tst m0, (a0), a1{{$}}
// OBJ: mls.tst m0, (a0), a1{{$}}
// IR32-LABEL: @test_mls_tst(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.tst.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mls_tst(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mls.tst.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mls_tst(boscztt_m_i32_t p0, void * p1, unsigned long p2) {
  mls_tst(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmax_ew:
// OBJ-LABEL: <test_mmax_ew>:
// ASM: mmax.ew m0, m1, m2{{$}}
// OBJ: mmax.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmax_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmax_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmax_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmax_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmax_ew_x:
// OBJ-LABEL: <test_mmax_ew_x>:
// ASM: mmax.ew.x m0, a0, m1{{$}}
// OBJ: mmax.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmax_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmax_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmax.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmax_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmax_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmean_ew:
// OBJ-LABEL: <test_mmean_ew>:
// ASM: mmean.ew m0, m1, m2{{$}}
// OBJ: mmean.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmean_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmean_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmean_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmean_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmean_ew_x:
// OBJ-LABEL: <test_mmean_ew_x>:
// ASM: mmean.ew.x m0, a0, m1{{$}}
// OBJ: mmean.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmean_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmean_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmean.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmean_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmean_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmin_ew:
// OBJ-LABEL: <test_mmin_ew>:
// ASM: mmin.ew m0, m1, m2{{$}}
// OBJ: mmin.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmin_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmin_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmin_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmin_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmin_ew_x:
// OBJ-LABEL: <test_mmin_ew_x>:
// ASM: mmin.ew.x m0, a0, m1{{$}}
// OBJ: mmin.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmin_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmin_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmin.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmin_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmin_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmov_m_a:
// OBJ-LABEL: <test_mmov_m_a>:
// ASM: mmov.m.a m0, acc0{{$}}
// OBJ: mmov.m.a m0, acc0{{$}}
// IR32-LABEL: @test_mmov_m_a(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i32_8_8t.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmov_m_a(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.a.triscv.ztt.matrix_i32_8_8t.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmov_m_a(boscztt_m_i32_t p0, boscztt_acc_i32_t p1) {
  mmov_m_a(p0, p1);
  return p0;
}

// ASM-LABEL: test_mmov_a_m:
// OBJ-LABEL: <test_mmov_a_m>:
// ASM: mmov.a.m acc0, m0{{$}}
// OBJ: mmov.a.m acc0, m0{{$}}
// IR32-LABEL: @test_mmov_a_m(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmov_a_m(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmov.a.m.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmov_a_m(boscztt_acc_i32_t p0, boscztt_m_i32_t p1) {
  mmov_a_m(p0, p1);
  return p0;
}

// ASM-LABEL: test_mmov_m_m:
// OBJ-LABEL: <test_mmov_m_m>:
// ASM: mmov.m.m m0, m1{{$}}
// OBJ: mmov.m.m m0, m1{{$}}
// IR32-LABEL: @test_mmov_m_m(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.m.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmov_m_m(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmov.m.m.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmov_m_m(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mmov_m_m(p0, p1);
  return p0;
}

// ASM-LABEL: test_mmove8_m_x:
// OBJ-LABEL: <test_mmove8_m_x>:
// ASM: mmove8.m.x m0, a0, a1{{$}}
// OBJ: mmove8.m.x m0, a0, a1{{$}}
// IR32-LABEL: @test_mmove8_m_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove8.m.x.triscv.ztt.matrix_i32_8_8t.i32.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove8_m_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove8.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mmove8_m_x(boscztt_m_i32_t p0, unsigned long p1, unsigned long p2) {
  mmove8_m_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmove16_m_x:
// OBJ-LABEL: <test_mmove16_m_x>:
// ASM: mmove16.m.x m0, a0, a1{{$}}
// OBJ: mmove16.m.x m0, a0, a1{{$}}
// IR32-LABEL: @test_mmove16_m_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove16.m.x.triscv.ztt.matrix_i32_8_8t.i32.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove16_m_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove16.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mmove16_m_x(boscztt_m_i32_t p0, unsigned long p1, unsigned long p2) {
  mmove16_m_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmove32_m_x:
// OBJ-LABEL: <test_mmove32_m_x>:
// ASM: mmove32.m.x m0, a0, a1{{$}}
// OBJ: mmove32.m.x m0, a0, a1{{$}}
// IR32-LABEL: @test_mmove32_m_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove32.m.x.triscv.ztt.matrix_i32_8_8t.i32.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove32_m_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove32.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mmove32_m_x(boscztt_m_i32_t p0, unsigned long p1, unsigned long p2) {
  mmove32_m_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmove64_m_x:
// OBJ-LABEL: <test_mmove64_m_x>:
// ASM: mmove64.m.x m0, a0, a1{{$}}
// OBJ: mmove64.m.x m0, a0, a1{{$}}
// IR32-LABEL: @test_mmove64_m_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove64.m.x.triscv.ztt.matrix_i32_8_8t.i32.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove64_m_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmove64.m.x.triscv.ztt.matrix_i32_8_8t.i64.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, i64 {{[^,)]+}})
boscztt_m_i32_t test_mmove64_m_x(boscztt_m_i32_t p0, unsigned long p1, unsigned long p2) {
  mmove64_m_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmove8_x_m:
// OBJ-LABEL: <test_mmove8_x_m>:
// ASM: mmove8.x.m a0, m0, a0{{$}}
// OBJ: mmove8.x.m a0, m0, a0{{$}}
// IR32-LABEL: @test_mmove8_x_m(
// IR32: call i32 @llvm.riscv.ztt.mmove8.x.m.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove8_x_m(
// IR64: call i64 @llvm.riscv.ztt.mmove8.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}})
unsigned long test_mmove8_x_m(boscztt_m_i32_t p0, unsigned long p1) {
  return mmove8_x_m(p0, p1);
}

// ASM-LABEL: test_mmove16_x_m:
// OBJ-LABEL: <test_mmove16_x_m>:
// ASM: mmove16.x.m a0, m0, a0{{$}}
// OBJ: mmove16.x.m a0, m0, a0{{$}}
// IR32-LABEL: @test_mmove16_x_m(
// IR32: call i32 @llvm.riscv.ztt.mmove16.x.m.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove16_x_m(
// IR64: call i64 @llvm.riscv.ztt.mmove16.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}})
unsigned long test_mmove16_x_m(boscztt_m_i32_t p0, unsigned long p1) {
  return mmove16_x_m(p0, p1);
}

// ASM-LABEL: test_mmove32_x_m:
// OBJ-LABEL: <test_mmove32_x_m>:
// ASM: mmove32.x.m a0, m0, a0{{$}}
// OBJ: mmove32.x.m a0, m0, a0{{$}}
// IR32-LABEL: @test_mmove32_x_m(
// IR32: call i32 @llvm.riscv.ztt.mmove32.x.m.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove32_x_m(
// IR64: call i64 @llvm.riscv.ztt.mmove32.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}})
unsigned long test_mmove32_x_m(boscztt_m_i32_t p0, unsigned long p1) {
  return mmove32_x_m(p0, p1);
}

// ASM-LABEL: test_mmove64_x_m:
// OBJ-LABEL: <test_mmove64_x_m>:
// ASM: mmove64.x.m a0, m0, a0{{$}}
// OBJ: mmove64.x.m a0, m0, a0{{$}}
// IR32-LABEL: @test_mmove64_x_m(
// IR32: call i32 @llvm.riscv.ztt.mmove64.x.m.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mmove64_x_m(
// IR64: call i64 @llvm.riscv.ztt.mmove64.x.m.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}})
unsigned long test_mmove64_x_m(boscztt_m_i32_t p0, unsigned long p1) {
  return mmove64_x_m(p0, p1);
}

// ASM-LABEL: test_mmul_ew:
// OBJ-LABEL: <test_mmul_ew>:
// ASM: mmul.ew m0, m1, m2{{$}}
// OBJ: mmul.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmul_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmul_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmul_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmul_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmul_ew_x:
// OBJ-LABEL: <test_mmul_ew_x>:
// ASM: mmul.ew.x m0, a0, m1{{$}}
// OBJ: mmul.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmul_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmul_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmul.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmul_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmul_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulacc_2d:
// OBJ-LABEL: <test_mmulacc_2d>:
// ASM: mmulacc.2d acc0, m0, m1{{$}}
// OBJ: mmulacc.2d acc0, m0, m1{{$}}
// IR32-LABEL: @test_mmulacc_2d(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulacc_2d(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmulacc_2d(boscztt_acc_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulacc_2d(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulacc_ew:
// OBJ-LABEL: <test_mmulacc_ew>:
// ASM: mmulacc.ew m0, m1, m2{{$}}
// OBJ: mmulacc.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmulacc_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulacc_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulacc_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulacc_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulacc_ew_x:
// OBJ-LABEL: <test_mmulacc_ew_x>:
// ASM: mmulacc.ew.x m0, a0, m1{{$}}
// OBJ: mmulacc.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmulacc_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulacc_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulacc.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulacc_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmulacc_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulaccneg_2d:
// OBJ-LABEL: <test_mmulaccneg_2d>:
// ASM: mmulaccneg.2d acc0, m0, m1{{$}}
// OBJ: mmulaccneg.2d acc0, m0, m1{{$}}
// IR32-LABEL: @test_mmulaccneg_2d(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulaccneg_2d(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmulaccneg_2d(boscztt_acc_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulaccneg_2d(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulaccneg_ew:
// OBJ-LABEL: <test_mmulaccneg_ew>:
// ASM: mmulaccneg.ew m0, m1, m2{{$}}
// OBJ: mmulaccneg.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmulaccneg_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulaccneg_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulaccneg_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulaccneg_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulaccneg_ew_x:
// OBJ-LABEL: <test_mmulaccneg_ew_x>:
// ASM: mmulaccneg.ew.x m0, a0, m1{{$}}
// OBJ: mmulaccneg.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmulaccneg_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulaccneg_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulaccneg.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulaccneg_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmulaccneg_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmuladd_ew:
// OBJ-LABEL: <test_mmuladd_ew>:
// ASM: mmuladd.ew m0, m1, m2{{$}}
// OBJ: mmuladd.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmuladd_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmuladd_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmuladd_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmuladd_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmuladd_ew_x:
// OBJ-LABEL: <test_mmuladd_ew_x>:
// ASM: mmuladd.ew.x m0, a0, m1{{$}}
// OBJ: mmuladd.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmuladd_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmuladd_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmuladd.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmuladd_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmuladd_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulatacc_2d:
// OBJ-LABEL: <test_mmulatacc_2d>:
// ASM: mmulatacc.2d acc0, m0, m1{{$}}
// OBJ: mmulatacc.2d acc0, m0, m1{{$}}
// IR32-LABEL: @test_mmulatacc_2d(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulatacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulatacc_2d(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulatacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmulatacc_2d(boscztt_acc_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulatacc_2d(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulataccneg_2d:
// OBJ-LABEL: <test_mmulataccneg_2d>:
// ASM: mmulataccneg.2d acc0, m0, m1{{$}}
// OBJ: mmulataccneg.2d acc0, m0, m1{{$}}
// IR32-LABEL: @test_mmulataccneg_2d(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulataccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulataccneg_2d(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulataccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmulataccneg_2d(boscztt_acc_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulataccneg_2d(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulbtacc_2d:
// OBJ-LABEL: <test_mmulbtacc_2d>:
// ASM: mmulbtacc.2d acc0, m0, m1{{$}}
// OBJ: mmulbtacc.2d acc0, m0, m1{{$}}
// IR32-LABEL: @test_mmulbtacc_2d(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulbtacc_2d(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtacc.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmulbtacc_2d(boscztt_acc_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulbtacc_2d(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulbtaccneg_2d:
// OBJ-LABEL: <test_mmulbtaccneg_2d>:
// ASM: mmulbtaccneg.2d acc0, m0, m1{{$}}
// OBJ: mmulbtaccneg.2d acc0, m0, m1{{$}}
// IR32-LABEL: @test_mmulbtaccneg_2d(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulbtaccneg_2d(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mmulbtaccneg.2d.triscv.ztt.acc_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mmulbtaccneg_2d(boscztt_acc_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulbtaccneg_2d(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulneg_ew:
// OBJ-LABEL: <test_mmulneg_ew>:
// ASM: mmulneg.ew m0, m1, m2{{$}}
// OBJ: mmulneg.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmulneg_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulneg_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulneg_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulneg_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulneg_ew_x:
// OBJ-LABEL: <test_mmulneg_ew_x>:
// ASM: mmulneg.ew.x m0, a0, m1{{$}}
// OBJ: mmulneg.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmulneg_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulneg_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulneg.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulneg_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmulneg_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulsub_ew:
// OBJ-LABEL: <test_mmulsub_ew>:
// ASM: mmulsub.ew m0, m1, m2{{$}}
// OBJ: mmulsub.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mmulsub_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulsub_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulsub_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mmulsub_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mmulsub_ew_x:
// OBJ-LABEL: <test_mmulsub_ew_x>:
// ASM: mmulsub.ew.x m0, a0, m1{{$}}
// OBJ: mmulsub.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mmulsub_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mmulsub_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mmulsub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mmulsub_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mmulsub_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mor_ew:
// OBJ-LABEL: <test_mor_ew>:
// ASM: mor.ew m0, m1, m2{{$}}
// OBJ: mor.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mor_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mor_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mor_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mor_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mor_ew_x:
// OBJ-LABEL: <test_mor_ew_x>:
// ASM: mor.ew.x m0, a0, m1{{$}}
// OBJ: mor.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mor_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mor_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mor.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mor_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mor_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mornot_ew:
// OBJ-LABEL: <test_mornot_ew>:
// ASM: mornot.ew m0, m1, m2{{$}}
// OBJ: mornot.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mornot_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mornot_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mornot_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mornot_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mornot_ew_x:
// OBJ-LABEL: <test_mornot_ew_x>:
// ASM: mornot.ew.x m0, a0, m1{{$}}
// OBJ: mornot.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mornot_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mornot_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mornot.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mornot_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mornot_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mpack_ew_x:
// OBJ-LABEL: <test_mpack_ew_x>:
// ASM: mpack.ew.x m0, a0, m1{{$}}
// OBJ: mpack.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mpack_ew_x(
// IR32: call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mpack.ew.x.triscv.ztt.matrix_i8_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i8, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mpack_ew_x(
// IR64: call target("riscv.ztt.matrix", i8, 8, 8) @llvm.riscv.ztt.mpack.ew.x.triscv.ztt.matrix_i8_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i8, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i8_t test_mpack_ew_x(boscztt_m_i8_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mpack_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mprefixadd_col:
// OBJ-LABEL: <test_mprefixadd_col>:
// ASM: mprefixadd.col m0, m1{{$}}
// OBJ: mprefixadd.col m0, m1{{$}}
// IR32-LABEL: @test_mprefixadd_col(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mprefixadd_col(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mprefixadd_col(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mprefixadd_col(p0, p1);
  return p0;
}

// ASM-LABEL: test_mprefixadd_row:
// OBJ-LABEL: <test_mprefixadd_row>:
// ASM: mprefixadd.row m0, m1{{$}}
// OBJ: mprefixadd.row m0, m1{{$}}
// IR32-LABEL: @test_mprefixadd_row(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mprefixadd_row(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mprefixadd_row(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mprefixadd_row(p0, p1);
  return p0;
}

// ASM-LABEL: test_mprefixmax_col:
// OBJ-LABEL: <test_mprefixmax_col>:
// ASM: mprefixmax.col m0, m1{{$}}
// OBJ: mprefixmax.col m0, m1{{$}}
// IR32-LABEL: @test_mprefixmax_col(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mprefixmax_col(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mprefixmax_col(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mprefixmax_col(p0, p1);
  return p0;
}

// ASM-LABEL: test_mprefixmax_row:
// OBJ-LABEL: <test_mprefixmax_row>:
// ASM: mprefixmax.row m0, m1{{$}}
// OBJ: mprefixmax.row m0, m1{{$}}
// IR32-LABEL: @test_mprefixmax_row(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mprefixmax_row(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mprefixmax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mprefixmax_row(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mprefixmax_row(p0, p1);
  return p0;
}

// ASM-LABEL: test_mrdexp_ew:
// OBJ-LABEL: <test_mrdexp_ew>:
// ASM: mrdexp.ew m0, m1, m2{{$}}
// OBJ: mrdexp.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mrdexp_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrdexp_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexp.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrdexp_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mrdexp_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mrdexpacc_ew:
// OBJ-LABEL: <test_mrdexpacc_ew>:
// ASM: mrdexpacc.ew m0, m1, m2{{$}}
// OBJ: mrdexpacc.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mrdexpacc_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrdexpacc_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrdexpacc.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrdexpacc_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mrdexpacc_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mrec_ew:
// OBJ-LABEL: <test_mrec_ew>:
// ASM: mrec.ew m0, m1{{$}}
// OBJ: mrec.ew m0, m1{{$}}
// IR32-LABEL: @test_mrec_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrec.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrec_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrec.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrec_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mrec_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mreduceadd_col:
// OBJ-LABEL: <test_mreduceadd_col>:
// ASM: mreduceadd.col m0, m1{{$}}
// OBJ: mreduceadd.col m0, m1{{$}}
// IR32-LABEL: @test_mreduceadd_col(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mreduceadd_col(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mreduceadd_col(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mreduceadd_col(p0, p1);
  return p0;
}

// ASM-LABEL: test_mreduceadd_row:
// OBJ-LABEL: <test_mreduceadd_row>:
// ASM: mreduceadd.row m0, m1{{$}}
// OBJ: mreduceadd.row m0, m1{{$}}
// IR32-LABEL: @test_mreduceadd_row(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mreduceadd_row(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreduceadd.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mreduceadd_row(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mreduceadd_row(p0, p1);
  return p0;
}

// ASM-LABEL: test_mreducemax_col:
// OBJ-LABEL: <test_mreducemax_col>:
// ASM: mreducemax.col m0, m1{{$}}
// OBJ: mreducemax.col m0, m1{{$}}
// IR32-LABEL: @test_mreducemax_col(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mreducemax_col(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mreducemax_col(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mreducemax_col(p0, p1);
  return p0;
}

// ASM-LABEL: test_mreducemax_row:
// OBJ-LABEL: <test_mreducemax_row>:
// ASM: mreducemax.row m0, m1{{$}}
// OBJ: mreducemax.row m0, m1{{$}}
// IR32-LABEL: @test_mreducemax_row(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mreducemax_row(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemax.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mreducemax_row(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mreducemax_row(p0, p1);
  return p0;
}

// ASM-LABEL: test_mreducemin_col:
// OBJ-LABEL: <test_mreducemin_col>:
// ASM: mreducemin.col m0, m1{{$}}
// OBJ: mreducemin.col m0, m1{{$}}
// IR32-LABEL: @test_mreducemin_col(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mreducemin_col(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.col.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mreducemin_col(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mreducemin_col(p0, p1);
  return p0;
}

// ASM-LABEL: test_mreducemin_row:
// OBJ-LABEL: <test_mreducemin_row>:
// ASM: mreducemin.row m0, m1{{$}}
// OBJ: mreducemin.row m0, m1{{$}}
// IR32-LABEL: @test_mreducemin_row(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mreducemin_row(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mreducemin.row.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mreducemin_row(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mreducemin_row(p0, p1);
  return p0;
}

// ASM-LABEL: test_mrowbcast_ew_x:
// OBJ-LABEL: <test_mrowbcast_ew_x>:
// ASM: mrowbcast.ew.x m0, a0, m1{{$}}
// OBJ: mrowbcast.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mrowbcast_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowbcast_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowbcast.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrowbcast_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mrowbcast_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mrowgather_ew:
// OBJ-LABEL: <test_mrowgather_ew>:
// ASM: mrowgather.ew m0, m1, m2{{$}}
// OBJ: mrowgather.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mrowgather_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowgather_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowgather.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrowgather_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mrowgather_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mrowid_ew:
// OBJ-LABEL: <test_mrowid_ew>:
// ASM: mrowid.ew m0{{$}}
// OBJ: mrowid.ew m0{{$}}
// IR32-LABEL: @test_mrowid_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowid_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowid.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrowid_ew(boscztt_m_i32_t p0) {
  mrowid_ew(p0);
  return p0;
}

// ASM-LABEL: test_mrowshift_ew_x:
// OBJ-LABEL: <test_mrowshift_ew_x>:
// ASM: mrowshift.ew.x m0, a0, m1{{$}}
// OBJ: mrowshift.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mrowshift_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowshift.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowshift_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowshift.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrowshift_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mrowshift_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mrowunzip_ew:
// OBJ-LABEL: <test_mrowunzip_ew>:
// ASM: mrowunzip.ew m0, m1{{$}}
// OBJ: mrowunzip.ew m0, m1{{$}}
// IR32-LABEL: @test_mrowunzip_ew(
// IR32: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowunzip_ew(
// IR64: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowunzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
void test_mrowunzip_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, void *out) {
  mrowunzip_ew(p0, p1);
  mss_1r(p0, out);
  mss_1r(p1, (char *)out + 256);
}

// ASM-LABEL: test_mrowzip_ew:
// OBJ-LABEL: <test_mrowzip_ew>:
// ASM: mrowzip.ew m0, m1{{$}}
// OBJ: mrowzip.ew m0, m1{{$}}
// IR32-LABEL: @test_mrowzip_ew(
// IR32: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowzip_ew(
// IR64: call { target("riscv.ztt.matrix", i32, 8, 8), target("riscv.ztt.matrix", i32, 8, 8) } @llvm.riscv.ztt.mrowzip.ew.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
void test_mrowzip_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, void *out) {
  mrowzip_ew(p0, p1);
  mss_1r(p0, out);
  mss_1r(p1, (char *)out + 256);
}

// ASM-LABEL: test_mrsqrt_ew:
// OBJ-LABEL: <test_mrsqrt_ew>:
// ASM: mrsqrt.ew m0, m1{{$}}
// OBJ: mrsqrt.ew m0, m1{{$}}
// IR32-LABEL: @test_mrsqrt_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrsqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrsqrt_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrsqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrsqrt_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mrsqrt_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_mrowscatadd_ew:
// OBJ-LABEL: <test_mrowscatadd_ew>:
// ASM: mrowscatadd.ew m0, m1, m2{{$}}
// OBJ: mrowscatadd.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mrowscatadd_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowscatadd_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrowscatadd_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mrowscatadd_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcolscatadd_ew:
// OBJ-LABEL: <test_mcolscatadd_ew>:
// ASM: mcolscatadd.ew m0, m1, m2{{$}}
// OBJ: mcolscatadd.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcolscatadd_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolscatadd_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatadd.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcolscatadd_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcolscatadd_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mrowscatmax_ew:
// OBJ-LABEL: <test_mrowscatmax_ew>:
// ASM: mrowscatmax.ew m0, m1, m2{{$}}
// OBJ: mrowscatmax.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mrowscatmax_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mrowscatmax_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mrowscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mrowscatmax_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mrowscatmax_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mcolscatmax_ew:
// OBJ-LABEL: <test_mcolscatmax_ew>:
// ASM: mcolscatmax.ew m0, m1, m2{{$}}
// OBJ: mcolscatmax.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mcolscatmax_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mcolscatmax_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mcolscatmax.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mcolscatmax_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mcolscatmax_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mselge_ew:
// OBJ-LABEL: <test_mselge_ew>:
// ASM: mselge.ew m0, m1, m2{{$}}
// OBJ: mselge.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mselge_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mselge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mselge_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mselge.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mselge_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mselge_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msellt_ew:
// OBJ-LABEL: <test_msellt_ew>:
// ASM: msellt.ew m0, m1, m2{{$}}
// OBJ: msellt.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_msellt_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msellt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msellt_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msellt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msellt_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  msellt_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msettyp:
// OBJ-LABEL: <test_msettyp>:
// ASM: msettyp m0, a0{{$}}
// OBJ: msettyp m0, a0{{$}}
// IR32-LABEL: @test_msettyp(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8) undef, i32 {{[^,)]+}})
// IR64-LABEL: @test_msettyp(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msettyp.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) undef, i64 {{[^,)]+}})
boscztt_m_i32_t test_msettyp(unsigned long p1) {
  boscztt_m_i32_t p0;
  msettyp(p0, p1);
  return p0;
}

// ASM-LABEL: test_msin_ew:
// OBJ-LABEL: <test_msin_ew>:
// ASM: msin.ew m0, m1{{$}}
// OBJ: msin.ew m0, m1{{$}}
// IR32-LABEL: @test_msin_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msin_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msin.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msin_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  msin_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_msll_ew:
// OBJ-LABEL: <test_msll_ew>:
// ASM: msll.ew m0, m1, m2{{$}}
// OBJ: msll.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_msll_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msll_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msll_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  msll_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msll_ew_x:
// OBJ-LABEL: <test_msll_ew_x>:
// ASM: msll.ew.x m0, a0, m1{{$}}
// OBJ: msll.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_msll_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msll_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msll.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msll_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  msll_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msqrt_ew:
// OBJ-LABEL: <test_msqrt_ew>:
// ASM: msqrt.ew m0, m1{{$}}
// OBJ: msqrt.ew m0, m1{{$}}
// IR32-LABEL: @test_msqrt_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msqrt_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msqrt.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msqrt_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  msqrt_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_msra_ew:
// OBJ-LABEL: <test_msra_ew>:
// ASM: msra.ew m0, m1, m2{{$}}
// OBJ: msra.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_msra_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msra_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msra_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  msra_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msra_ew_x:
// OBJ-LABEL: <test_msra_ew_x>:
// ASM: msra.ew.x m0, a0, m1{{$}}
// OBJ: msra.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_msra_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msra_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msra.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msra_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  msra_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msrl_ew:
// OBJ-LABEL: <test_msrl_ew>:
// ASM: msrl.ew m0, m1, m2{{$}}
// OBJ: msrl.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_msrl_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msrl_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msrl_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  msrl_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msrl_ew_x:
// OBJ-LABEL: <test_msrl_ew_x>:
// ASM: msrl.ew.x m0, a0, m1{{$}}
// OBJ: msrl.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_msrl_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msrl_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msrl.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msrl_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  msrl_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mss_1r:
// OBJ-LABEL: <test_mss_1r>:
// ASM: mss.1r m0, a0{{$}}
// OBJ: mss.1r m0, a0{{$}}
// IR32-LABEL: @test_mss_1r(
// IR32: call void @llvm.riscv.ztt.mss.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
// IR64-LABEL: @test_mss_1r(
// IR64: call void @llvm.riscv.ztt.mss.1r.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
void test_mss_1r(boscztt_m_i32_t p0, void * p1) {
  mss_1r(p0, p1);
}

// ASM-LABEL: test_mss_cm:
// OBJ-LABEL: <test_mss_cm>:
// ASM: mss.cm m0, a0{{$}}
// OBJ: mss.cm m0, a0{{$}}
// IR32-LABEL: @test_mss_cm(
// IR32: call void @llvm.riscv.ztt.mss.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
// IR64-LABEL: @test_mss_cm(
// IR64: call void @llvm.riscv.ztt.mss.cm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
void test_mss_cm(boscztt_m_i32_t p0, void * p1) {
  mss_cm(p0, p1);
}

// ASM-LABEL: test_mss_rm:
// OBJ-LABEL: <test_mss_rm>:
// ASM: mss.rm m0, a0{{$}}
// OBJ: mss.rm m0, a0{{$}}
// IR32-LABEL: @test_mss_rm(
// IR32: call void @llvm.riscv.ztt.mss.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
// IR64-LABEL: @test_mss_rm(
// IR64: call void @llvm.riscv.ztt.mss.rm.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}})
void test_mss_rm(boscztt_m_i32_t p0, void * p1) {
  mss_rm(p0, p1);
}

// ASM-LABEL: test_mss_st:
// OBJ-LABEL: <test_mss_st>:
// ASM: mss.st m0, (a0), a1{{$}}
// OBJ: mss.st m0, (a0), a1{{$}}
// IR32-LABEL: @test_mss_st(
// IR32: call void @llvm.riscv.ztt.mss.st.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mss_st(
// IR64: call void @llvm.riscv.ztt.mss.st.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i64 {{[^,)]+}})
void test_mss_st(boscztt_m_i32_t p0, void * p1, unsigned long p2) {
  mss_st(p0, p1, p2);
}

// ASM-LABEL: test_mss_tst:
// OBJ-LABEL: <test_mss_tst>:
// ASM: mss.tst m0, (a0), a1{{$}}
// OBJ: mss.tst m0, (a0), a1{{$}}
// IR32-LABEL: @test_mss_tst(
// IR32: call void @llvm.riscv.ztt.mss.tst.triscv.ztt.matrix_i32_8_8t.i32(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i32 {{[^,)]+}})
// IR64-LABEL: @test_mss_tst(
// IR64: call void @llvm.riscv.ztt.mss.tst.triscv.ztt.matrix_i32_8_8t.i64(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, ptr {{[^,)]+}}, i64 {{[^,)]+}})
void test_mss_tst(boscztt_m_i32_t p0, void * p1, unsigned long p2) {
  mss_tst(p0, p1, p2);
}

// ASM-LABEL: test_msub_ew:
// OBJ-LABEL: <test_msub_ew>:
// ASM: msub.ew m0, m1, m2{{$}}
// OBJ: msub.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_msub_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msub_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msub_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  msub_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msub_ew_x:
// OBJ-LABEL: <test_msub_ew_x>:
// ASM: msub.ew.x m0, a0, m1{{$}}
// OBJ: msub.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_msub_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msub_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msub.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msub_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  msub_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msublog2_ew:
// OBJ-LABEL: <test_msublog2_ew>:
// ASM: msublog2.ew m0, m1, m2{{$}}
// OBJ: msublog2.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_msublog2_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msublog2_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msublog2_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  msublog2_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_msublog2_ew_x:
// OBJ-LABEL: <test_msublog2_ew_x>:
// ASM: msublog2.ew.x m0, a0, m1{{$}}
// OBJ: msublog2.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_msublog2_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_msublog2_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.msublog2.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_msublog2_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  msublog2_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mtanh_ew:
// OBJ-LABEL: <test_mtanh_ew>:
// ASM: mtanh.ew m0, m1{{$}}
// OBJ: mtanh.ew m0, m1{{$}}
// IR32-LABEL: @test_mtanh_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mtanh.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mtanh_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mtanh.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mtanh_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1) {
  mtanh_ew(p0, p1);
  return p0;
}

// ASM-LABEL: test_munpack_ew_x:
// OBJ-LABEL: <test_munpack_ew_x>:
// ASM: munpack.ew.x m0, a0, m1{{$}}
// OBJ: munpack.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_munpack_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.munpack.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i8, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_munpack_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.munpack.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i8_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i8, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_munpack_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i8_t p2) {
  munpack_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mxor_ew:
// OBJ-LABEL: <test_mxor_ew>:
// ASM: mxor.ew m0, m1, m2{{$}}
// OBJ: mxor.ew m0, m1, m2{{$}}
// IR32-LABEL: @test_mxor_ew(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mxor_ew(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mxor_ew(boscztt_m_i32_t p0, boscztt_m_i32_t p1, boscztt_m_i32_t p2) {
  mxor_ew(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mxor_ew_x:
// OBJ-LABEL: <test_mxor_ew_x>:
// ASM: mxor.ew.x m0, a0, m1{{$}}
// OBJ: mxor.ew.x m0, a0, m1{{$}}
// IR32-LABEL: @test_mxor_ew_x(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.x.triscv.ztt.matrix_i32_8_8t.i32.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i32 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mxor_ew_x(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mxor.ew.x.triscv.ztt.matrix_i32_8_8t.i64.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}}, i64 {{[^,)]+}}, target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mxor_ew_x(boscztt_m_i32_t p0, unsigned long p1, boscztt_m_i32_t p2) {
  mxor_ew_x(p0, p1, p2);
  return p0;
}

// ASM-LABEL: test_mzero_2d_acc:
// OBJ-LABEL: <test_mzero_2d_acc>:
// ASM: mzero.2d.acc acc0{{$}}
// OBJ: mzero.2d.acc acc0{{$}}
// IR32-LABEL: @test_mzero_2d_acc(
// IR32: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mzero_2d_acc(
// IR64: call target("riscv.ztt.acc", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.acc.triscv.ztt.acc_i32_8_8t(target("riscv.ztt.acc", i32, 8, 8) {{[^,)]+}})
boscztt_acc_i32_t test_mzero_2d_acc(boscztt_acc_i32_t p0) {
  mzero_2d_acc(p0);
  return p0;
}

// ASM-LABEL: test_mzero_2d_m:
// OBJ-LABEL: <test_mzero_2d_m>:
// ASM: mzero.2d.m m0{{$}}
// OBJ: mzero.2d.m m0{{$}}
// IR32-LABEL: @test_mzero_2d_m(
// IR32: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
// IR64-LABEL: @test_mzero_2d_m(
// IR64: call target("riscv.ztt.matrix", i32, 8, 8) @llvm.riscv.ztt.mzero.2d.m.triscv.ztt.matrix_i32_8_8t(target("riscv.ztt.matrix", i32, 8, 8) {{[^,)]+}})
boscztt_m_i32_t test_mzero_2d_m(boscztt_m_i32_t p0) {
  mzero_2d_m(p0);
  return p0;
}
