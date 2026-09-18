// REQUIRES: riscv-registered-target
// RUN: %clang -target riscv64 -march=rv64i_boscztt -mboscztt-profile=ame-gem5 -### -c %s 2>&1 | FileCheck %s --check-prefix=FEATURE
// RUN: %clang -target riscv32 -march=rv32i_boscztt -mboscztt-profile=ame-gem5 -dM -E %s | FileCheck %s --check-prefix=AME
// RUN: %clang -target riscv64 -march=rv64i_boscztt -mboscztt-profile=ame-gem5 -mboscztt-profile=default -dM -E %s | FileCheck %s --check-prefix=DEFAULT
// RUN: not %clang -target riscv64 -march=rv64i_boscztt -mboscztt-profile=unknown -c %s -o %t.o 2>&1 | FileCheck %s --check-prefix=BAD
// RUN: not %clang -target riscv64 -march=rv64i -mboscztt-profile=ame-gem5 -c %s -o %t.o 2>&1 | FileCheck %s --check-prefix=DISABLED
// FEATURE: "-target-feature" "+boscztt-ame-gem5"
// AME-DAG: #define __riscv_boscztt_tile_side 4
// AME-DAG: #define __riscv_boscztt_m_registers 32
// AME-DAG: #define __riscv_boscztt_acc_registers 4
// AME-DAG: #define __riscv_boscztt_unit_bits 32
// AME-DAG: #define __riscv_boscztt_max_element_bits 128
// DEFAULT-DAG: #define __riscv_boscztt_tile_side 8
// DEFAULT-DAG: #define __riscv_boscztt_m_registers 16
// DEFAULT-DAG: #define __riscv_boscztt_acc_registers 8
// BAD: unsupported argument 'unknown' to option '-mboscztt-profile='
// DISABLED: the ame-gem5 profile requires the boscztt extension
