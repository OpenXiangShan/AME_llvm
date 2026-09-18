# RUN: llvm-mc -triple=riscv32 -mattr=+boscztt -show-encoding < %s | FileCheck %s
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt -show-encoding < %s | FileCheck %s
# RUN: not llvm-mc -triple=riscv64 < %s 2>&1 | FileCheck %s --check-prefix=DISABLED

csrr a0, amenlen
# CHECK: csrr a0, amenlen
# CHECK-SAME: encoding: [0x73,0x25,0x00,0xcc]
# DISABLED: requires 'boscztt' to be enabled

csrr a0, ameudsz
# CHECK: csrr a0, ameudsz
# CHECK-SAME: encoding: [0x73,0x25,0x10,0xcc]
# DISABLED: requires 'boscztt' to be enabled

csrr a0, amestype
# CHECK: csrr a0, amestype
# CHECK-SAME: encoding: [0x73,0x25,0x20,0xcc]
# DISABLED: requires 'boscztt' to be enabled

csrr a0, ameown
# CHECK: csrr a0, ameown
# CHECK-SAME: encoding: [0x73,0x25,0x30,0xcc]
# DISABLED: requires 'boscztt' to be enabled

csrr a0, amefflags
# CHECK: csrr a0, amefflags
# CHECK-SAME: encoding: [0x73,0x25,0x40,0xcc]
# DISABLED: requires 'boscztt' to be enabled

csrr a0, amexsat
# CHECK: csrr a0, amexsat
# CHECK-SAME: encoding: [0x73,0x25,0x50,0xcc]
# DISABLED: requires 'boscztt' to be enabled

csrr a0, amestatus
# CHECK: csrr a0, amestatus
# CHECK-SAME: encoding: [0x73,0x25,0x00,0x80]
# DISABLED: requires 'boscztt' to be enabled
