# RUN: llvm-mc -triple=riscv64 < %s | FileCheck %s
# RUN: llvm-mc -triple=riscv64 -filetype=obj < %s | llvm-readobj --arch-specific - | FileCheck %s --check-prefix=OBJ

.attribute arch, "rv64i_boscztt0p6"
# CHECK: .attribute 5, "rv64i2p1_boscztt0p6"
# OBJ: rv64i2p1_boscztt0p6
madd.ew m0, m1, m2
# CHECK: madd.ew m0, m1, m2
.option push
.option arch, -boscztt
addi a0, a0, 1
.option pop
mzero.2d.acc acc7
# CHECK: mzero.2d.acc acc7
