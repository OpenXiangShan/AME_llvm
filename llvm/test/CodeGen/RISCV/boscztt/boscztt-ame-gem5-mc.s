# RUN: split-file %s %t
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -show-encoding %t/good.s | FileCheck %s --check-prefix=ENC
# RUN: llvm-mc -triple=riscv32 -mattr=+boscztt,+boscztt-ame-gem5 -show-encoding %t/good.s | FileCheck %s --check-prefix=ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 -filetype=obj %t/good.s -o %t.o
# RUN: llvm-objdump -d --mattr=+boscztt,+boscztt-ame-gem5 %t.o | FileCheck %s --check-prefix=DIS
# RUN: llvm-objdump -d --mattr=+boscztt %t.o | FileCheck %s --check-prefix=DEFAULT-DIS
# RUN: not llvm-mc -triple=riscv64 -mattr=+boscztt %t/good.s 2>&1 | FileCheck %s --check-prefix=DEFAULT-ERR
# RUN: not llvm-mc -triple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 %t/bad.s 2>&1 | FileCheck %s --check-prefix=ERR

# ENC: madd.ew m31, m0, m1 # encoding: [0xab,0x0f,0x10,0x04]
# ENC: mzero.2d.acc acc3 # encoding: [0xab,0x01,0x00,0xa6]
# DIS: madd.ew m31, m0, m1{{$}}
# DIS: mzero.2d.acc acc3{{$}}
# DEFAULT-DIS: <unknown>
# DEFAULT-DIS: mzero.2d.acc acc3{{$}}
# DEFAULT-ERR: error: invalid operand for instruction
# ERR: error: invalid operand for instruction
# ERR: mzero.2d.acc acc4
# ERR: error: invalid operand for instruction
# ERR: msettyp m32, a0

#--- good.s
madd.ew m31, m0, m1
mzero.2d.acc acc3
#--- bad.s
mzero.2d.acc acc4
msettyp m32, a0
