# boscztt: fixed-parameter Attached Matrix Extension

This local extension implements the instruction encodings in **Ztt v0.6**, built
2026-08-16, specification commit `8d27acd`. The reference PDF has SHA-256
`9a231ca414e03f0771599de22e461fee6a9e73e2d1cd81a34d678f3d29d574ba`;
it is not distributed with this source release. The specification is
© RISC-V International, CC BY 4.0. It is a draft, and its encodings and CSR
numbers are provisional.

Enable it with `-mattr=+boscztt` in `llc`, `llvm-mc`, or `llvm-objdump`.
The ISA attribute spelling is `rv32i_boscztt0p6` or `rv64i_boscztt0p6`.
`boscztt` is the local name requested for this implementation; it is not a
ratified RISC-V extension name and does not follow the usual `xvendor` spelling.
There is no dependency on RVV, scalar floating-point registers, or `vscale`.

## Hardware configuration

| Parameter | Value |
| --- | --- |
| Square shape | 8 × 8 elements (`AME_NELEM = 64`) |
| Unit datatype width | 32 bits |
| Unit-width row | 256 bits |
| M register file | default `m0`–`m15`, 2048 bits per physical register |
| ACC register file | `acc0`–`acc7`, 4096 bits of capacity per physical register |
| Datatype descriptors | 16 Md and 8 Ad registers, 32 bits each |
| Maximum element width | 64 bits |

The default LLVM profile uses the 16-register M file, one of v0.6's permitted
register counts. A 64-bit M square occupies an aligned pair;
a 64-bit ACC square fits in one accumulator. `mgettyp`/`msettyp` use `mN`
assembly operands, and `agettyp`/`asettyp` use `accN`, as in the draft examples.
Md and Ad are coupled to their data registers, not independently allocated.

### AME_gem5 compatibility profile

The external AME_gem5 simulator uses a different fixed profile:
four-by-four element squares, 32 M registers (`m0`–`m31`), and four ACC
registers (`acc0`–`acc3`). LLVM supports that configuration as an explicit
compatibility profile matching those register capacities:

```text
clang --target=riscv64 -march=rv64i_boscztt -mboscztt-profile=ame-gem5 ...
llc -mattr=+boscztt,+boscztt-ame-gem5 ...
llvm-mc -triple=riscv64 -mattr=+boscztt,+boscztt-ame-gem5 ...
```

The driver turns `-mboscztt-profile=ame-gem5` into the backend feature
`+boscztt-ame-gem5`. Clang defines `__riscv_boscztt_tile_side` as `4`,
`__riscv_boscztt_m_registers` as `32`, and `__riscv_boscztt_acc_registers` as
`4`. `__riscv_boscztt_max_element_bits` is `128` in this profile and `64`
in the default profile. The default profile remains selected when the option is omitted. The
profile also changes register-group allocation, spill transfers, assembly parsing,
disassembly, and the target extension shape emitted by Clang from 8×8 to 4×4.

The simulator's 2048-bit backing containers must not be confused with logical
register images. Its `.1r` instructions transfer `4 * 4 * 32 / 8 = 64` bytes.
A 4×4 i64 ACC square therefore needs two M images (128 bytes) when spilled
through `mmov.m.a`; i128 needs four images (256 bytes). The AME profile
preserves four images and the base descriptor. It also saves and restores
scratch M0-M3, because restoring an old 128-bit Md0 clears all four registers
even when the transferred ACC value uses a narrower datatype. Register
class sizes currently reserve stack slots large enough for the default
profile; this overallocates some space for AME_gem5 but does not change the
actual transfer length or the hardware register count.

The shared header declares 83 base storage types, plus unsigned and FP8 aliases: 67 are usable in the default
profile and 81 in AME_gem5. Eleven types extend the original types to complete
32-M groups; the two i4 ACC types require eight ACC registers and are unavailable in
AME_gem5. Five additional AME-only names expose Int128: `boscztt_m_i128_t`,
`boscztt_m_i128_x2_t`, `boscztt_m_i128_x4_t`, `boscztt_m_i128_x8_t`, and
`boscztt_acc_i128_t`. Their physical spans are 4/8/16/32 M registers and
one ACC register, respectively. The element-width limit is 128 bits in
AME_gem5 and 64 bits in the default profile.

The CSR names are `amenlen` (0xcc0), `ameudsz` (0xcc1), `amestype` (0xcc2),
`ameown` (0xcc3), `amefflags` (0xcc4), `amexsat` (0xcc5), and `amestatus` (0x800).
The draft assigns some described writable state to the read-only CSR address
range; this implementation retains the PDF's numbers rather than choosing new
ones. Hardware and privileged software must agree on these provisional numbers.

## LLVM IR matrix values

Matrices use distinct first-class **target extension types**, not LLVM vectors:

```llvm
target("riscv.ztt.matrix", i32, 8, 8)
target("riscv.ztt.acc", float, 8, 8)
target("riscv.ztt.matrix", double, 8, 8)
```

The element type describes representation and bit width. Signedness, rounding,
saturation, and custom datatype properties are in the runtime descriptor. For
example, unsigned i32 uses descriptor 32; signed i32 uses `0x40000020`.
The supported type parameters are power-of-two integer widths up to the
profile's maximum (64 bits by default, 128 bits for AME_gem5),
`half`, `bfloat`, `float`, and `double`. This does not imply that hardware
implements every operation/datatype tuple; v0.6 defines runtime discovery.

A third integer parameter specifies the number of logical squares in a value:

```llvm
; Four packed i8 squares in one physical M register.
target("riscv.ztt.matrix", i8, 8, 8)
; Four i32 squares in an aligned four-register group, for mixed-width compute.
target("riscv.ztt.matrix", i32, 8, 8, 4)
; Sixteen i32 squares occupying the complete M register file.
target("riscv.ztt.matrix", i32, 8, 8, 16)
; Four i8 accumulator squares, for a packed M/ACC transfer.
target("riscv.ztt.acc", i8, 8, 8, 4)
```

For M, the default square count is `max(1, 32 / element_width)`. The physical
span is `square_count * element_width / 32`. For ordinary compute, every M
operand must contain `max(pack_factor)` squares across the operands. A 2D
multiply's accumulator contains one square. Pack/unpack and zip/unzip use the
special shapes specified by the draft. Whole-register memory operations and
scalar debug moves use exactly one physical M register.
Aligned M groups of 1, 2, 4, 8, and 16 physical registers are supported, with
32-register groups additionally available in AME_gem5. The register count
does not change the square shape selected by the profile.

For ACC, the default square count is one. A packed M/ACC move requires the
complete `32 / element_width` accumulator group. The allocator conservatively
reserves that group even for a single narrow ACC square so that it can spill
through the only available ACC-to-M path without touching another live value.
Both the single-square and explicit-group types can be used for M/ACC moves
when their allocated register span matches the M packing factor. This lets a
single-square `mmulacc_2d` result flow directly into `mmov_m_a`. The move still
accesses the entire packed ACC group: initialize its other squares with a
complete M-to-ACC transfer before relying on their contents.
For ACC values of at least 32 bits all configured accumulators remain independently
allocatable. Types requiring a span larger than the configured register file
are rejected.

These types can flow through SSA values, PHIs, selects, function arguments and
returns, and intrinsics. They cannot be used in ordinary LLVM loads/stores,
allocas, or globals: an LLVM byte layout would not carry the datatype descriptor.
Use AME memory intrinsics for interoperable matrix data. Bitcode, textual IR,
and overloaded intrinsic names retain the element type and both dimensions.
A new generic `<rows x columns x element>` grammar would require unrelated
LLVM vector operations and optimizers to acquire matrix semantics. Target
extension types give these fixed matrices a distinct IR identity using LLVM's
existing extension mechanism.

## Intrinsics

There are 138 intrinsic families, one for each instruction mnemonic in v0.6.
The base name is `llvm.riscv.ztt.` followed by the complete mnemonic, for example
`llvm.riscv.ztt.madd.ew` and `llvm.riscv.ztt.mls.rm`. The name `mls.mm` does not
occur in this version of the draft. LLVM appends its usual overload suffixes
for matrix and scalar types. C++ clients should use
`Intrinsic::getOrInsertDeclaration` with `Intrinsic::riscv_ztt_*` and the
appropriate overload types instead of constructing these suffixes manually.

In TableGen, matrix positions use `llvm_any_ztt_matrix_ty` and accumulator
positions use `llvm_any_ztt_acc_ty`. These are constrained overload types,
not aliases for `llvm_any_ty`: the generic intrinsic signature checker requires
the corresponding `riscv.ztt.matrix` or `riscv.ztt.acc` target extension type,
including on unused declarations. `LLVMMatchType` requires exactly the same
type as its referenced overload. Element types and group counts can still vary
between independent overload positions. `TargetExtType` validates each type's
parameters, and the ZTT verifier checks the relationships between operands,
XLEN and constant descriptor widths.

| Instruction kind | Intrinsic contract |
| --- | --- |
| M/ACC destination | Return the new matrix; first argument is its old value, followed by the explicit assembly source operands |
| `msettyp` / `asettyp` | Return the updated matrix; arguments are the old matrix and the XLEN descriptor |
| `mgettyp` / `agettyp` | Return the XLEN descriptor; argument is the matrix value |
| `mls.*` | Return the matrix; arguments are old matrix, pointer, and stride where present |
| `mss.*` | Return void; arguments are matrix, pointer, and stride where present |
| `*zip.ew` / `*unzip.ew` | Return a struct containing both updated matrices; arguments are the two old matrices |
| `mmove*.x.m` | Return XLEN scalar; arguments are matrix and XLEN index |
| `ame.acquire` | Return XLEN result; argument is the XLEN acquisition descriptor |
| `ame.release` | No arguments or result |

The destination passthrough carries its descriptor and supports read/modify/write
instructions and v0.6's no-write behavior for unsupported tuples. In particular,
`mls.*` needs a destination whose datatype was already programmed. Passing
`poison` does not program hardware state. Set-type intrinsics also carry the
old destination and use a tied machine operand, preserving its data and
descriptor when the requested datatype is unsupported. Use `undef` as the
old value only for initial construction, when no prior value must survive.
The caller must keep the runtime descriptor width consistent with the static
type; a conflicting constant width is rejected. Probing supported descriptors
with different widths requires separate appropriately sized types or assembly.
Hand-written IR using the former single-argument set-type signature must add
the matrix passthrough argument; the C/C++ source signature is unchanged.

All AME intrinsics require `boscztt`, are convergent, and conservatively access
ordered AME state and memory. Acquire and release also carry both memory-read
and memory-write effects in the machine instruction description, preserving
ordering against ordinary state-save/restore loads and stores during scheduling. No ordinary LLVM matrix arithmetic is
automatically converted to AME operations.

## Clang interface

Enable the extension with `-march=rv64i_boscztt` (or `rv32i_boscztt`) and include
`<RISCVBoscZtt.h>`. CMake generates and installs this resource header; it does
not depend on a target C library. Each instruction is a compiler builtin with
its dots replaced by underscores, without an additional prefix: `mand_ew_x`,
`mmulacc_2d`, `msettyp`, etc. `__has_builtin(mand_ew_x)` can test recognition.

Clang has independent builtin M and ACC types, rather than vector typedefs or
wrapper structs. The header exposes `boscztt_m_i32_t`, `boscztt_acc_i32_t`,
`boscztt_m_f32_t`, and corresponding types for the other supported elements.
The integer element names are `i1`, `i2`, `i4`, `i8`, `i16`, `i32`, `i64`, and
AME-only `i128`; the floating element names are `f16`, `bf16`, `f32`, `f64`.
The header also provides `u4` through `u128` storage aliases and
`fp8_e4m3` / `fp8_e5m2` aliases, including their valid `_xN` groups. FP8
uses the existing 8-bit integer storage type in IR. The aliases do not insert
conversions or set the hardware descriptor. For example:

```c
boscztt_m_fp8_e4m3_t x;
msettyp(x, BOSCZTT_DTYPE_FP8_E4M3 | BOSCZTT_FP_RNE);
```

`BOSCZTT_DTYPE_I4` through `BOSCZTT_DTYPE_I128` select signed standard
integers; `BOSCZTT_DTYPE_U4` through `BOSCZTT_DTYPE_U128` select unsigned
integers. Combine them with `BOSCZTT_INT_SAT` and one of
`BOSCZTT_INT_RNU/RNE/RDN/ROD`. Floating descriptors are
`BOSCZTT_DTYPE_F16/BF16/F32/F64/FP8_E4M3/FP8_E5M2`; their rounding fields
are `BOSCZTT_FP_RNE/RTZ/RDN/RUP/RMM/RNO`. The two rounding-field families
occupy different descriptor bits and must not be mixed. The existing 1-bit
and 2-bit integer storage names describe implementation extensions rather
than additional standard v0.6 datatypes.

As in IR, signedness is a
descriptor property. ACC `i1` and `i2` types would require more than eight
registers for preservation and are unavailable. Explicit groups add `_xN`,
for example `boscztt_m_i32_x4_t` and `boscztt_acc_i8_x4_t`.
M group types extend through the complete 16-register file, for example
`boscztt_m_i32_x16_t` and `boscztt_m_i64_x8_t`; ACC group limits are unchanged.

These are fixed-shape register types classified as *sizeless* by the C type
system: no C object layout, `sizeof`, arrays, fields, global storage, pointers,
references, or volatile accesses are provided. Automatic variables, same-type
assignment, function parameters/returns, C++ overloads/templates and PCH retain
their matrix identity. Local temporaries are converted to SSA before emitting
LLVM IR, including at `-O0`. Matrix data enters or leaves memory through AME
load/store builtins; the backend preserves register values across spills/calls.

The C interface follows the instruction's operand order:

| Instruction kind | C interface |
| --- | --- |
| Matrix destination | `void mand_ew_x(M destination, unsigned long x, M source)`; destination is a writable local variable and is updated in place |
| Set descriptor | `void msettyp(M destination, unsigned long descriptor)`; retains the old value on failure |
| ACC descriptor | `void asettyp(ACC destination, unsigned long descriptor)` |
| Scalar destination | `unsigned long mgettyp(M source)`, `unsigned long mmove32_x_m(M source, unsigned long index)` |
| Load/store | `void mls_rm(M destination, const void *address)`, `void mss_rm(M source, void *address)` |
| zip/unzip | `void mrowzip_ew(M first, M second)`; updates two distinct writable variables of the same non-packed type |
| Ownership | `unsigned long ame_acquire(unsigned long descriptor)`, `void ame_release(void)` |

`M` and `ACC` in this table describe polymorphic operands, not C typedef names.
All scalar operands/results are XLEN-wide `unsigned long`. Integer C operands
are converted to this type; scalar floating-point arguments are rejected, since
the instructions read X registers and interpret their bits using AME state.
Before arithmetic `.ew.x` operations, program `amestype` with the scalar
datatype descriptor; programming a matrix descriptor does not set scalar state.
The generated header lists all 138 builtin signatures using this notation.
In particular, the draft defines `msub.ew md, ms1, ms2` as `ms2 - ms1`.
To compute `a - b`, call `msub_ew(destination, b, a)`.

```c
#include <RISCVBoscZtt.h>

boscztt_m_i32_t mask_tile(const void *src, unsigned long mask) {
  boscztt_m_i32_t tile;
  msettyp(tile, 32);
  mls_rm(tile, src);
  mand_ew_x(tile, mask, tile);
  return tile;
}
```

The acquisition result encodes success in bit 0; use `ame_acquire(desc) & 1`,
not a nonzero test of the whole status word.

As with the intrinsic API, the caller must own the AME and keep runtime
descriptor widths consistent with the types. Setters may initialize a new
local or update an existing one; only an initialized old value can be relied
on after a failed set. A successful set-type instruction clears only the physical span
specified by the draft: one datatype group for `msettyp`, one ACC for `asettyp`.
If a C/IR value reserves a larger group, its remaining data is initially
unspecified. Subsequent operations retain their architectural write footprint;
for example, `mzero.2d.acc` clears the base square only. Group types do not
implicitly turn an instruction into a loop over registers.

## Register allocation and calls

SelectionDAG selects the intrinsics on both RV32 and RV64. The register allocator
tracks aligned groups in the independent M/ACC files. Register copies and spills
preserve the base descriptor as well as data. M spills use `mss.1r`/`mls.1r`;
ACC spills use M scratch state and the draft's `mmov.m.a`/`mmov.a.m` path.
The initial spill implementation reserves `t0`–`t2` for scratch addressing,
descriptors, and saved status. ACC spill scratch images are kept in the frame,
and the scratch M data is restored before the next user instruction.

The local calling convention passes matrix values in available aligned M/ACC
registers, with all matrix registers caller-saved. It is not a standardized AME
psABI. The same matrix argument allocation applies to `fastcc`, including
internal C/C++ helpers converted to that convention by the optimizer. Full-file
32-register values in the AME_gem5 profile support PHIs and conditional selects;
two live full-file values are kept in spill slots as needed.
Functions with more matrix arguments than fit must use explicit memory
interfaces. Ordinary callees must leave the backend acquired when the caller has
live matrix values. Acquire/release and context switches must not invalidate
live SSA matrix values. Code generation assumes the hardware supports the
matched-datatype transfers needed to preserve live ACC values; v0.6 does not
provide an unconditional whole-ACC memory instruction.

Inline assembly can declare M and ACC clobbers by their assembly names, such as
`"m0"`, `"m1"`, and `"acc0"`. The selected profile determines the valid register
numbers. A clobber invalidates aliases in larger matrix register groups as well;
list every register modified by a datatype-dependent instruction span. This does
not add input/output constraints for C matrix values. Use the builtins for those
values, or standalone assembly with explicit memory interfaces. A `"memory"`
clobber alone does not describe overwritten matrix registers.

The C `cleanup` attribute is rejected on matrix variables, including deduced and
template-instantiated variables, because it implicitly takes their address.
The LLVM target type's logical byte layout uses the selected rows and columns;
it does not change the restrictions on ordinary loads, stores, globals or C
`sizeof`.

## Example and validation

`llvm/test/CodeGen/RISCV/boscztt/boscztt-gemm.ll` is a complete fixed-shape example that
acquires the backend, programs descriptors, loads two i32 matrices, multiplies
into ACC, stores the result through M, and releases the backend.

```sh
build-boscztt/bin/llc -mtriple=riscv64 -mattr=+boscztt \
  llvm/test/CodeGen/RISCV/boscztt/boscztt-gemm.ll -o gemm.s
build-boscztt/bin/llvm-mc -triple=riscv64 -mattr=+boscztt \
  -filetype=obj gemm.s -o gemm.o
```

All ZTT tests are in `llvm/test/CodeGen/RISCV/boscztt/`, including MC, CodeGen,
assembler type checks, and intrinsic verifier tests. The instruction inventory,
including PDF page, match, mask, and operand fields, is in
`llvm/test/CodeGen/RISCV/boscztt/Inputs/boscztt-v0.6.json`. MC tests check all 138
encodings and their disassembly. CodeGen tests cover all intrinsics on RV32 and
RV64, grouped/packed types, selects, calls, and register pressure. Negative tests
cover shape/type errors, feature requirements, invalid registers and zip operands.
Clang tests are grouped under `clang/test/CodeGen/RISCV/boscztt` and
`clang/test/Sema/RISCV/boscztt`. They cover C-to-IR, C-to-assembly, object emission,
RV32/RV64, different element types, grouped operations, C++/PCH, and diagnostics.
The lit suite contains compiler tests. Separate gem5 execution checks are
described below.

### Real-data C and C++ programs

The following tests also serve as standalone programs for an AME-capable target:

* `clang/test/CodeGen/RISCV/boscztt/real-data.c` multiplies two non-symmetric
  signed i32 8-by-8 matrices and checks all 64 results against a golden table.
  A second kernel combines strided row-major and column-major loads, subtracts
  their matrices, and stores into a padded buffer. It checks the padding, input
  buffer, and output canaries as well as every result.
  A third kernel keeps 18 distinct i32 matrix values live in the 16-register M
  file, exercising high registers and spills. It checks all 1,152 stored
  elements, the preserved descriptors, and output canaries.
* `clang/test/CodeGen/RISCV/boscztt/real-data.cpp` computes
  `bias + 2 * (Left / 2) * (Right / 4)` in FP32, using a non-inlined template
  that takes and returns matrix register values. This exercises preservation
  across calls. A second kernel subtracts signed i64 matrices whose inputs
  exceed 32 bits. Results and output canaries are checked element by element.
* `Inputs/matrix-data.h` contains the input data and the integer golden table.
  C++ constant evaluation independently checks the integer product and the
  floating-point reference with both Clang constant interpreters. All FP32
  products and sums in this fixture are exactly representable.

The lit tests compile both programs for RV32/RV64 at `-O0` and `-O2`, verify
the IR, check assembly with exact registers, and assemble/disassemble the
resulting object files. They do **not** execute AME instructions. The tests
use `rv32im_boscztt`/`rv64im_boscztt` and require neither RVV nor scalar F/D.

Each target program returns 0 only when every check passes. Return 77 means
ownership or a required operation/datatype is unavailable; other nonzero
values identify result or canary failures. AME must be enabled by the execution
environment. Compile with the target's startup code, linker and C runtime to
run these programs, for example using `--target=riscv64 -march=rv64im_boscztt`.
Add `-std=c++17` for the C++ program. No C++ standard library is needed.

`clang/test/CodeGen/RISCV/boscztt/ame-gem5-register-data.c` adds executable
regressions for packed i8/i16 ACC values, i32/i64 ACC values, mixed M/ACC state,
static helpers using `fastcc`, both outcomes of a full 32-register select, and
inline assembly that destroys all M/ACC registers. It checks every output
element, the base descriptors and buffer canaries. Its 64-bit inputs exceed
32 bits. The assembly helpers in `Inputs/gem5-register-data.S` fill and inspect
all 32 registers directly for the select test. Run C/C++, RV32/RV64 and O0/O2
under the AME_gem5 Atomic CPU with:

```sh
python3 clang/test/CodeGen/RISCV/boscztt/Inputs/run-gem5-register-data.py \
  --gem5 /path/to/AME_gem5/build/RISCV/gem5.opt \
  --clang build-boscztt/bin/clang \
  --output build-boscztt/boscztt-validation/register-data
```

`ame-gem5-register-boundaries.c` covers scratch M0-M3 preservation with an old
128-bit descriptor, all 256 bytes of an i128 M/ACC square across calls,
single-square i8/i16 accumulation followed by packed moves, and unsupported
set-type operations retaining both the old data and descriptor. It checks
data against scalar references and checks wide-result buffer canaries. Use the
same runner to execute its C/C++, RV32/RV64, O0/O2 combinations:

```sh
python3 clang/test/CodeGen/RISCV/boscztt/Inputs/run-gem5-register-data.py \
  --gem5 /path/to/AME_gem5/build/RISCV/gem5.opt \
  --clang build-boscztt/bin/clang \
  --source clang/test/CodeGen/RISCV/boscztt/ame-gem5-register-boundaries.c \
  --cpu atomic \
  --output build-boscztt/boscztt-validation/register-boundaries
```

### AME_gem5 baseline compatibility

The profile fixes the compiler's register geometry and transfer sizes. Simulator
execution support also depends on its source revision and CPU model. On
2026-09-18, the current LLVM tools were tested against AME_gem5 commit
`e958e81c08b88e84ba43204da820b80d22d86d6e`, with only four local-toolchain
selection/documentation changes and no simulator semantic fixes:

| Fixture | AtomicSimple | TimingSimple | Minor | O3 |
| --- | --- | --- | --- | --- |
| `real-data.c` / `real-data.cpp` | 8/8 | 0/8 | 0/8 | 0/8 |
| `ame-gem5-register-data.c` | 8/8 | Not run in this baseline check | Not run in this baseline check | Not run in this baseline check |

Each set of eight runs covers C/C++, RV32/RV64, and O0/O2 with 64-byte cache
lines. TimingSimple aborts in the matrix memory-request splitting path. Minor
and O3 report incorrect data: the C program returns 7 (register-pressure output)
and the C++ program returns 2 (FP32 output). These are execution failures, not
compiler or linker failures.

Additional simulator changes have been tested separately for register and
memory preservation, arithmetic, late memory-response errors, AME context
switches, CPU takeover, and checkpoints. They are not part of this LLVM source
release and are not present in the baseline commit above. Select additional
models with `--cpu atomic timing minor o3` only when assessing a simulator with
the required fixes; report that simulator's exact revision with the results.
All such execution tests are separate from compiler lit tests.

The scalar reference can be checked separately with a host Clang installation
that supports the native target (the RISC-V-only build above is a cross compiler):

```sh
clang -std=c11 -O2 -DBOSCZTT_REFERENCE_ONLY \
  clang/test/CodeGen/RISCV/boscztt/real-data.c -o /tmp/boscztt-reference-c
/tmp/boscztt-reference-c
clang++ -std=c++17 -O2 -DBOSCZTT_REFERENCE_ONLY \
  clang/test/CodeGen/RISCV/boscztt/real-data.cpp -o /tmp/boscztt-reference-cxx
/tmp/boscztt-reference-cxx
```

This mode validates the fixtures and expected values only. It neither replaces
AME builtins with scalar implementations nor tests AME execution.

### Executing with the Ztt gem5 fork

`Inputs/run-gem5.py` builds freestanding ELF programs from the two real-data
tests and executes them with a separately built Ztt gem5 fork that exposes the
configuration parameters below. It finds `ld.lld` or Rust's bundled `rust-lld`, adds
minimal startup and memory routines, and propagates guest failure/skip codes
to the host. No RISC-V libc, C++ standard library, or scalar replacement for
AME instructions is involved. Simulator runs are sequential.

```sh
python3 clang/test/CodeGen/RISCV/boscztt/Inputs/run-gem5.py \
  --gem5 /path/to/default-profile/gem5.opt \
  --clang build-boscztt/bin/clang \
  --profile default \
  --output build-boscztt/boscztt-validation/gem5/final
```

The default execution matrix is RV32/RV64, `-O0`/`-O2`, C/C++, and gem5's
AtomicSimple, TimingSimple, and Minor CPU models: 24 runs. Each run records
the guest exit code, final tick, configuration and simulator log; `results.json`
summarizes them. Exit 77 is reported as a failed run, never a numerical PASS.

`gem5-se.py` selects 64 elements, 32-bit units, 16 M registers, eight ACC
registers, the full operation profile, and disables RVV. LLVM and this execution
configuration use the same register counts and square dimensions; the simulator
source's defaults of 32 M registers, four ACC registers, 16-by-16 squares, and
64-bit units are overridden. The simulator's larger physical containers are
used with the configured active M size; tested ACC datatypes need at most
the compiler's 4096-bit accumulator capacity.

The simulator profile supports integer 8/16/32/64 and RNE FP32/FP64 datatypes.
It reports unsupported tuples for other LLVM-representable types such as
Int4, FP16 and BF16, for cross-class integer/float conversions, and for 64-bit
integer matrix multiplication. A PASS for these real-data programs therefore
does not establish support for every instruction/datatype tuple or validate
the cycle timing model.

Build only the RISC-V backend and Clang when working on this extension. The
following is a general development configuration; choose the build and
parallelism settings appropriate for the host:

```sh
cmake -S llvm -B build-boscztt -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_TARGETS_TO_BUILD=RISCV \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_ENABLE_ASSERTIONS=ON
cmake --build build-boscztt --target \
  clang clang-resource-headers llc opt llvm-as llvm-dis llvm-mc llvm-objdump \
  llvm-readobj FileCheck count not split-file
build-boscztt/bin/llvm-lit -sv \
  -Dllvm_tools_dir="$PWD/build-boscztt/bin" \
  llvm/test/CodeGen/RISCV/boscztt \
  clang/test/CodeGen/RISCV/boscztt clang/test/Sema/RISCV/boscztt
```
