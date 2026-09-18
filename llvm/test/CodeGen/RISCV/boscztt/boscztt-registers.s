# RUN: llvm-mc -triple=riscv32 -mattr=+boscztt -show-encoding < %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt -show-encoding < %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv32 -mattr=+boscztt -filetype=obj < %s | llvm-objdump -d --mattr=+boscztt - | FileCheck %s --check-prefix=ASM
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt -filetype=obj < %s | llvm-objdump -d --mattr=+boscztt - | FileCheck %s --check-prefix=ASM

# Exercise every newly available register and the high register-number bit in
# each operand position. Encodings follow the draft's instruction fields.
madd.ew m8, m9, m10
# ASM: madd.ew m8, m9, m10
# ENC-SAME: encoding: [0x2b,0x84,0xa4,0x04]
mand.ew m11, m12, m13
# ASM: mand.ew m11, m12, m13
# ENC-SAME: encoding: [0xab,0x05,0xd6,0x34]
msub.ew m15, m14, m8
# ASM: msub.ew m15, m14, m8
# ENC-SAME: encoding: [0xab,0x07,0x87,0x30]
msettyp m15, a0
# ASM: msettyp m15, a0
# ENC-SAME: encoding: [0xab,0x07,0x35,0xa2]
mgettyp a0, m15
# ASM: mgettyp a0, m15
# ENC-SAME: encoding: [0x2b,0x85,0x27,0xa2]
mls.st m15, (a0), a1
# ASM: mls.st m15, (a0), a1
# ENC-SAME: encoding: [0xab,0x07,0xb5,0xa8]
mss.1r m15, a0
# ASM: mss.1r m15, a0
# ENC-SAME: encoding: [0xab,0x07,0x95,0xa3]
mmulacc.2d acc7, m14, m8
# ASM: mmulacc.2d acc7, m14, m8
# ENC-SAME: encoding: [0xab,0x03,0x87,0x94]
mmov.m.a m15, acc7
# ASM: mmov.m.a m15, acc7
# ENC-SAME: encoding: [0xab,0x87,0xc3,0xa3]
mrowzip.ew m14, m15
# ASM: mrowzip.ew m14, m15
# ENC-SAME: encoding: [0x2b,0x00,0xf7,0x70]
