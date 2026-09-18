# RUN: not llvm-mc -triple=riscv32 -mattr=+boscztt < %s 2>&1 | FileCheck %s
# RUN: not llvm-mc -triple=riscv64 -mattr=+boscztt < %s 2>&1 | FileCheck %s

madd.ew m16, m0, m1
# CHECK: error: invalid operand for instruction
madd.ew m15, m16, m0
# CHECK: error: invalid operand for instruction
madd.ew m0, m15, m31
# CHECK: error: invalid operand for instruction
madd.ew m0, acc0, m1
# CHECK: error: invalid operand for instruction
mmulacc.2d acc8, m0, m1
# CHECK: error: invalid operand for instruction
mmulacc.2d m0, m0, m1
# CHECK: error: invalid operand for instruction
mls.rm m0, 4
# CHECK: error: register must be a GPR
msettyp m0, 32
# CHECK: error: register must be a GPR
mrowzip.ew m0, m0
# CHECK: error: boscztt zip operands must be distinct matrix registers
mcolzip.ew m15, m15
# CHECK: error: boscztt zip operands must be distinct matrix registers
mrowunzip.ew m2, m2
# CHECK: error: boscztt zip operands must be distinct matrix registers
mcolunzip.ew m6, m6
# CHECK: error: boscztt zip operands must be distinct matrix registers
