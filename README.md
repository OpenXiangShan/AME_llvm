# The LLVM Compiler Infrastructure

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/llvm/llvm-project/badge)](https://securityscorecards.dev/viewer/?uri=github.com/llvm/llvm-project)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/8273/badge)](https://www.bestpractices.dev/projects/8273)
[![libc++](https://github.com/llvm/llvm-project/actions/workflows/libcxx-pr-conformance-tests.yaml/badge.svg?branch=main&event=schedule)](https://github.com/llvm/llvm-project/actions/workflows/libcxx-pr-conformance-tests.yaml?query=event%3Aschedule)

Welcome to the LLVM project!

This repository contains the source code for LLVM, a toolkit for the
construction of highly optimized compilers, optimizers, and run-time
environments.

The LLVM project has multiple components. The core of the project is
itself called "LLVM". This contains all of the tools, libraries, and header
files needed to process intermediate representations and convert them into
object files. Tools include an assembler, disassembler, bitcode analyzer, and
bitcode optimizer.

C-like languages use the [Clang](https://clang.llvm.org/) frontend. This
component compiles C, C++, Objective-C, and Objective-C++ code into LLVM bitcode
-- and from there into object files, using LLVM.

Other components include:
the [libc++ C++ standard library](https://libcxx.llvm.org),
the [LLD linker](https://lld.llvm.org), and more.

## RISC-V ZTT v0.6 (`boscztt`)

This checkout contains an experimental compiler implementation of the draft
RISC-V Attached Matrix Extension ZTT v0.6. The local LLVM/Clang feature name
is `boscztt`; it is intentionally not presented as a ratified RISC-V
extension or as an upstream LLVM feature. The implementation targets the
Ztt v0.6 draft built on 2026-08-16, specification commit `8d27acd`.
The draft PDF and internal audit reports are not distributed with this source
release. The detailed implementation reference is
[`llvm/docs/RISCVBoscZtt.md`](llvm/docs/RISCVBoscZtt.md).

The status below describes what the compiler implements. It does not claim
that an arbitrary processor, simulator, or operating-system runtime supports
every ZTT datatype and operation combination.

### Implemented

* **Instruction and assembler support.** The backend has one LLVM intrinsic
  family and one Clang builtin family for each of the 138 instruction
  mnemonics in the v0.6 inventory. This includes AME ownership and type
  state, element-wise arithmetic and logical operations, matrix multiply and
  accumulate, reductions and prefix operations, conversions, packing and
  zip/unzip, scalar moves, and the `mls.*`/`mss.*` memory forms. The MC layer
  contains the v0.6 match/mask/operand encodings, assembly parsing, and
  disassembly. The checked inventory is
  [`boscztt-v0.6.json`](llvm/test/CodeGen/RISCV/boscztt/Inputs/boscztt-v0.6.json).
* **Target feature selection.** `+boscztt` is available to `llc`, `llvm-mc`,
  and `llvm-objdump`. Clang accepts `-march=rv32im_boscztt` and
  `-march=rv64im_boscztt`, and accepts `-mboscztt-profile=default` or
  `-mboscztt-profile=ame-gem5`.
* **Fixed implementation profiles.** The default profile is an 8x8 logical
  square with 32-bit units, 16 M registers (`m0`-`m15`), 8 ACC registers
  (`acc0`-`acc7`), and a public element-width limit of 64 bits. The
  `ame-gem5` profile is a compatibility profile for the AME_gem5 tree: 4x4,
  32 M registers (`m0`-`m31`), 4 ACC registers (`acc0`-`acc3`), and a 128-bit
  public element-width limit. In the latter profile one logical M image is
  64 bytes; the simulator's larger backing container does not change that
  transfer size. Md/Ad descriptor state is coupled to the corresponding M/ACC
  values. The provisional CSR names and numbers from the PDF are retained:
  `amenlen` (`0xcc0`), `ameudsz` (`0xcc1`), `amestype` (`0xcc2`), `ameown`
  (`0xcc3`), `amefflags` (`0xcc4`), `amexsat` (`0xcc5`), and `amestatus`
  (`0x800`).
* **LLVM IR matrix values.** M and ACC values are distinct first-class target
  extension types, for example
  `target("riscv.ztt.matrix", i32, 8, 8)` and
  `target("riscv.ztt.acc", float, 8, 8)`. An optional square-count parameter
  represents a packed or aligned register group. The verifier checks the
  target-extension kind, dimensions, element width, group count, profile
  limits, XLEN operands, and relationships between intrinsic operands.
* **Element-type declarations.** The Clang header provides fixed-shape M and
  ACC register types for signed and unsigned integer storage widths from 4 to
  64 bits, `half`, `bfloat`, `float`, `double`, and FP8 storage aliases. The
  AME profile additionally exposes 128-bit integer storage types and their
  valid M groups. Signedness, rounding, saturation, and custom datatype
  properties remain in the runtime descriptor, as required by the draft.
  The `i1` and `i2` storage names are implementation extensions and are not
  additional standard v0.6 integer datatypes.
* **Clang source interface.** `<RISCVBoscZtt.h>` exposes the generated builtin
  interface, descriptor constants, and the ownership operations
  `ame_acquire`/`ame_release`. Matrix values are sizeless register values:
  they can be used as locals, SSA values, function arguments and returns, C++
  template values, PHIs, and selects. Sema diagnoses invalid profiles,
  widths, operands, addresses, ordinary object-layout uses, and unsupported
  register groups. Matrix values use the dedicated AME load/store builtins;
  ordinary LLVM loads, stores, allocas or globals containing matrix values,
  taking a matrix value's address, and `sizeof` are deliberately not used to
  represent them. Ordinary pointer operands remain available for the explicit
  AME memory builtins.
* **Register allocation and preservation.** The RISC-V backend models aligned
  M and ACC register groups, profile-specific register names, matrix copies,
  calls and `fastcc`, spills and reloads, descriptor state, and ACC transfers
  through the draft M/ACC move path. Set-type operations carry the old value
  through the compiler IR and tied machine operand so an unsupported runtime
  set preserves an already initialized destination. Inline assembly can list
  M and ACC register clobbers by name; larger aliases must list every register
  modified by the instruction's span.
* **State ordering.** ZTT intrinsics are convergent, side-effecting operations
  with ordered AME state. Ownership transitions also carry memory effects, so
  ordinary state-save and state-restore memory operations are not moved across
  `ame.acquire` or `ame.release` by the backend.
* **Dedicated tests.** The repository has MC, CodeGen, IR verifier, register
  group, spill, calling-convention, select, inline-assembly, C, C++, PCH, and
  diagnostic tests under:
  [`llvm/test/CodeGen/RISCV/boscztt`](llvm/test/CodeGen/RISCV/boscztt),
  [`clang/test/CodeGen/RISCV/boscztt`](clang/test/CodeGen/RISCV/boscztt), and
  [`clang/test/Sema/RISCV/boscztt`](clang/test/Sema/RISCV/boscztt). The
  current dedicated lit run discovers 49 tests and passes all 49.

The main implementation points are
[`llvm/lib/Target/RISCV/RISCVInstrInfoBoscZtt.td`](llvm/lib/Target/RISCV/RISCVInstrInfoBoscZtt.td)
for encodings and machine operands,
[`llvm/include/llvm/IR/IntrinsicsRISCVBoscZtt.td`](llvm/include/llvm/IR/IntrinsicsRISCVBoscZtt.td)
for intrinsic contracts,
[`llvm/include/llvm/Support/RISCVBoscZtt.h`](llvm/include/llvm/Support/RISCVBoscZtt.h)
for profile geometry,
[`clang/include/clang/Basic/BuiltinsRISCVBoscZtt.td`](clang/include/clang/Basic/BuiltinsRISCVBoscZtt.td)
and [`clang/include/clang/Basic/RISCVBoscZttTypes.def`](clang/include/clang/Basic/RISCVBoscZttTypes.def)
for the source interface, and
[`llvm/lib/Target/RISCV/RISCVBoscZtt.cpp`](llvm/lib/Target/RISCV/RISCVBoscZtt.cpp)
for matrix register preservation.

### Current scope and remaining work

The following items are intentionally not claimed as complete ZTT v0.6
conformance:

1. **Exhaustive arithmetic execution has not been proven.** LLVM emits the
   instruction and preserves its descriptor-dependent type information; it
   does not emulate matrix arithmetic. The repository has representative C
   and C++ data tests, but it has not executed every one of the 138 mnemonics
   for every legal integer, unsigned, floating-point, FP8, rounding,
   saturation, conversion, and custom-datatype tuple on compliant hardware.
   A hardware or simulator implementation must validate those numerical
   semantics and its `amestatus`/unsupported-operation behavior.
2. **Runtime and privileged-state support is external.** Ownership, CSR
   behavior, AME context switching, OS save/restore, traps, and device-side
   late memory errors are not implemented by LLVM. The optional gem5 runners
   exercise a particular simulator profile; their result cannot certify the
   whole PDF or replace a hardware conformance suite.
3. **There is no standardized ZTT psABI.** Matrix argument and return
   allocation in this tree is a local compiler convention, including its
   `fastcc` behavior. Interoperability requires all callers and callees to use
   the same profile and compiler convention; a future standardized ABI would
   need a separate specification and implementation.
4. **The compiler does not auto-vectorize ordinary code into ZTT.** Matrix
   instructions are selected from the explicit builtins or LLVM intrinsics.
   No general C/C++ matrix language, optimizer cost model, or automatic
   lowering from ordinary scalar/vector loops is provided.
5. **The profiles expose different type sets.** The default profile stops at
   64-bit elements. AME exposes i128 M/ACC types, but narrow ACC values may
   require a complete packed ACC group for safe preservation; an i4 ACC group
   that exceeds the four-ACC AME profile is rejected. A representable type or
   descriptor is not a promise that a particular operation is supported by
   the target hardware.
6. **The C and IR interfaces are implementation interfaces.** The PDF defines
   the ISA, not LLVM target-extension syntax, Clang type names, C object
   layout, or a portable library ABI. Programs needing ordinary memory
   interchange must use the explicit AME memory instructions or a separately
   defined software representation.

These are the next conformance tasks if a release needs a stronger claim:
execute a complete instruction/datatype/descriptor matrix on a reference
implementation, add a documented ABI and runtime context-switch contract,
and define portable source-level memory and type-conversion interfaces.

### Build the ZTT-enabled tools

Build from the repository root. A CMake, Ninja, Python 3, and a working host
C++ compiler are required. The configuration below builds only the RISC-V
backend and Clang, while retaining assertions for development diagnostics:

```sh
cmake -S llvm -B build-boscztt -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_TARGETS_TO_BUILD=RISCV \
  -DLLVM_ENABLE_ASSERTIONS=ON

cmake --build build-boscztt --target \
  clang clang-resource-headers llc opt llvm-as llvm-dis llvm-mc \
  llvm-objdump llvm-readobj FileCheck count not split-file
```

The tools are written to `build-boscztt/bin`. A different build directory can
be used by replacing `build-boscztt` consistently in the commands below.

### Run the compiler tests

Run the dedicated ZTT tests with LLVM's lit harness:

```sh
build-boscztt/bin/llvm-lit -sv \
  -Dllvm_tools_dir="$PWD/build-boscztt/bin" \
  llvm/test/CodeGen/RISCV/boscztt \
  clang/test/CodeGen/RISCV/boscztt \
  clang/test/Sema/RISCV/boscztt
```

Add `-j <workers>` to `llvm-lit` when parallel test execution is appropriate
for the host. A single test file can be selected by passing its path instead
of the three directories.

### Use `clang`, `llc`, and the MC tools

Compile a C source file to a freestanding RISC-V object with the default
profile:

```sh
build-boscztt/bin/clang \
  --target=riscv64-unknown-elf -march=rv64im_boscztt \
  -ffreestanding -fno-builtin -O2 -c source.c -o source.o
```

Select the AME_gem5 compatibility profile explicitly when the target has its
4x4/32-M/4-ACC configuration:

```sh
build-boscztt/bin/clang \
  --target=riscv64-unknown-elf -march=rv64im_boscztt \
  -mboscztt-profile=ame-gem5 -ffreestanding -fno-builtin -O2 \
  -c source.c -o source-ame-gem5.o
```

The source can include `<RISCVBoscZtt.h>`. Add `-std=c++17` for C++ source.
These commands compile; linking and execution require a RISC-V linker,
startup code, memory routines, and a target runtime that implements ZTT.

Generate assembly from LLVM IR and assemble it with the default profile:

```sh
build-boscztt/bin/llc -mtriple=riscv64 -mattr=+boscztt input.ll -o output.s
build-boscztt/bin/llvm-mc -triple=riscv64 -mattr=+boscztt \
  -filetype=obj output.s -o output.o
build-boscztt/bin/llvm-objdump -d --mattr=+boscztt output.o
```

For `m16`-`m31`, 4x4 shapes, or i128 AME types, use the compatibility feature
on every backend tool:

```sh
build-boscztt/bin/llc -mtriple=riscv64 \
  -mattr=+boscztt,+boscztt-ame-gem5 input.ll -o output-ame-gem5.s
build-boscztt/bin/llvm-mc -triple=riscv64 \
  -mattr=+boscztt,+boscztt-ame-gem5 -filetype=obj \
  output-ame-gem5.s -o output-ame-gem5.o
```

`opt -passes=verify` can be used to validate textual IR containing the ZTT
target-extension types. `llvm-mc -show-encoding` prints the provisional
instruction encoding for an assembly instruction, and `llvm-objdump` checks
the corresponding object disassembly. LLVM bitcode can be inspected with:

```sh
build-boscztt/bin/llvm-as input.ll -o input.bc
build-boscztt/bin/llvm-dis input.bc -o -
```

### Optional gem5 execution

The scripts in
[`clang/test/CodeGen/RISCV/boscztt/Inputs`](clang/test/CodeGen/RISCV/boscztt/Inputs)
are optional integration checks, not part of the compiler-only lit suite. They
require a compatible ZTT gem5 binary and either `ld.lld` or a Rust toolchain
providing `rust-lld`:

```sh
python3 clang/test/CodeGen/RISCV/boscztt/Inputs/run-gem5.py \
  --gem5 /path/to/gem5.opt \
  --clang build-boscztt/bin/clang \
  --profile ame-gem5 --cpu atomic \
  --output build-boscztt/boscztt-validation/gem5
```

The runner builds freestanding C/C++ real-data programs for RV32/RV64 and
records each guest exit code and simulator log under the selected output
directory. Use `--profile default` only with a simulator configured for the
default 8x8/16-M/8-ACC profile. The register-preservation runner provides
additional AME_gem5 checks:

```sh
python3 clang/test/CodeGen/RISCV/boscztt/Inputs/run-gem5-register-data.py \
  --gem5 /path/to/gem5.opt \
  --clang build-boscztt/bin/clang \
  --cpu atomic \
  --output build-boscztt/boscztt-validation/register-data
```

The `ame-gem5` profile describes register geometry; it does not guarantee that
all simulator execution paths implement the draft correctly. With AME_gem5
commit `e958e81c08` and only the local-toolchain selection changes, the tested
Atomic real-data and register-preservation programs pass. The same real-data
suite fails on TimingSimple, Minor, and O3. Full integration on those CPU
models requires additional simulator fixes, which are not included in this
LLVM repository. See the [simulator compatibility details](llvm/docs/RISCVBoscZtt.md#ame_gem5-baseline-compatibility).
The compiler lit tests do not require gem5.

## Getting the Source Code and Building LLVM

Consult the
[Getting Started with LLVM](https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm)
page for information on building and running LLVM.

For information on how to contribute to the LLVM project, please take a look at
the [Contributing to LLVM](https://llvm.org/docs/Contributing.html) guide.

## Getting in touch

Join the [LLVM Discourse forums](https://discourse.llvm.org/), [Discord
chat](https://discord.gg/xS7Z362),
[LLVM Office Hours](https://llvm.org/docs/GettingInvolved.html#office-hours) or
[Regular sync-ups](https://llvm.org/docs/GettingInvolved.html#online-sync-ups).

The LLVM project has adopted a [code of conduct](https://llvm.org/docs/CodeOfConduct.html) for
participants to all modes of communication within the project.
