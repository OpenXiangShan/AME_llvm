"""Execute AME_gem5 register-pressure and destructive-call data checks.

Generated sources and every compile command are retained in --output.
This complements run-gem5.py's C/C++ real-data execution matrix.
"""

import argparse
import json
from pathlib import Path
import runpy
import subprocess


def pressure_ir():
    ir = ['target triple = "riscv64"']
    checks = []
    for bank, width, count in [("matrix", 32, 34), ("matrix", 64, 18),
                               ("matrix", 8, 34), ("acc", 32, 6),
                               ("acc", 64, 6), ("acc", 8, 3)]:
        name = f"pressure_{bank}{width}"
        ty = f'target("riscv.ztt.{bank}", i{width}, 4, 4)'
        suffix = f"triscv.ztt.{bank}_i{width}_4_4t"
        prefix = "a" if bank == "acc" else "m"
        setter = f"@llvm.riscv.ztt.{prefix}settyp.{suffix}.i64"
        getter = f"@llvm.riscv.ztt.{prefix}gettyp.i64.{suffix}"
        zero = f"@llvm.riscv.ztt.mzero.2d.{'acc' if bank == 'acc' else 'm'}.{suffix}"
        ir += [f"declare {ty} {setter}({ty}, i64)", f"declare i64 {getter}({ty})",
               f"declare {ty} {zero}({ty})", f"define i64 @{name}() {{"]
        ir += [f"  %v{i} = call {ty} {setter}({ty} undef, i64 {width})"
               for i in range(count)]
        ir += [f"  %z{i} = call {ty} {zero}({ty} %v{i})" for i in range(count)]
        ir += [f"  %d{i} = call i64 {getter}({ty} %z{i})" for i in range(count)]
        ir += ["  %s0 = add i64 %d0, 0"]
        ir += [f"  %s{i} = add i64 %s{i-1}, %d{i}" for i in range(1, count)]
        ir += [f"  ret i64 %s{count-1}", "}"]
        checks.append((name, width * count))
    return "\n".join(ir) + "\n", checks


def group_assembly():
    lines = [".text", ".globl round_trip_group", "round_trip_group:",
             "addi sp, sp, -16", "sd ra, 8(sp)", "sd s0, 0(sp)",
             "mv s0, a1", "li a2, 32"]
    for i in range(32):
        lines += [f"msettyp m{i}, a2", f"mls.1r m{i}, a0", "addi a0, a0, 64"]
    lines += ["call preserve_full_group"]
    for i in range(32):
        lines += [f"mss.1r m{i}, s0", "addi s0, s0, 64"]
    lines += ["mgettyp a0, m0", "ld s0, 0(sp)", "ld ra, 8(sp)",
              "addi sp, sp, 16", "ret", '.section .note.GNU-stack,"",@progbits']
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("gem5", "clang", "output"):
        parser.add_argument("--" + name, type=Path, required=True)
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--cpu", nargs="+", choices=("atomic", "timing", "minor", "o3"),
                        default=["atomic", "timing", "minor"])
    args = parser.parse_args()
    inputs = Path(__file__).resolve().parent
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    linker = runpy.run_path(str(inputs / "run-gem5.py"))["find_linker"]()
    clang = str(args.clang.resolve())
    flags = ["--target=riscv64-unknown-linux-gnu", "-march=rv64im_boscztt",
             "-mboscztt-profile=ame-gem5", "-ffreestanding", "-fno-builtin",
             "-fno-stack-protector", "-fno-pic", "-mcmodel=medany", "-O2"]

    def source(name, content):
        path = output / name
        path.write_text(content)
        return path

    prelude = '''#include <RISCVBoscZtt.h>
static int acquire(void) {
  if (!(ame_acquire(0) & 1)) return 0;
  __asm__ volatile("csrw amestatus, zero" ::: "memory");
  return 1;
}
static unsigned long finish(void) {
  unsigned long status;
  __asm__ volatile("csrr %0, amestatus" : "=r"(status) : : "memory");
  ame_release();
  return status;
}
'''
    pressure, checks = pressure_ir()
    source("pressure.ll", pressure)
    declarations = "".join(f"extern unsigned long {n}(void);\n" for n, _ in checks)
    calls = "".join(f"  if ({n}() != {v}) error = {i + 1};\n"
                    for i, (n, v) in enumerate(checks))
    source("pressure-main.c", prelude + declarations + '''int main(void) {
  if (!acquire()) return 77;
  int error = 0;
''' + calls + '''  if (finish() & 1) return 77;
  return error;
}
''')
    source("group.ll", '''target triple = "riscv64"
define target("riscv.ztt.matrix", i32, 4, 4, 32) @preserve_full_group(
    target("riscv.ztt.matrix", i32, 4, 4, 32) %m) {
  call void @external()
  ret target("riscv.ztt.matrix", i32, 4, 4, 32) %m
}
declare void @external()
''')
    source("group.S", group_assembly())
    source("group-main.c", prelude + '''extern unsigned long round_trip_group(const int *, int *);
int main(void) {
  int input[512];
  struct { int before, data[512], after; } output;
  output.before = output.after = 123456789;
  for (int i = 0; i < 512; ++i) {
    input[i] = 37 * i - 4113;
    output.data[i] = -100000;
  }
  if (!acquire()) return 77;
  unsigned long descriptor = round_trip_group(input, output.data);
  if (finish() & 1) return 77;
  if (descriptor != 32) return 1;
  if (output.before != 123456789 || output.after != 123456789) return 2;
  for (int i = 0; i < 512; ++i)
    if (input[i] != output.data[i]) return 3;
  return 0;
}
''')
    # msettyp/asettyp clear both the selected data and descriptor state.
    destroy = [".text", ".globl external", "external:", "li a0, 16"]
    destroy += [f"msettyp m{i}, a0" for i in range(32)]
    destroy += [f"asettyp acc{i}, a0" for i in range(4)]
    destroy += ["ret", '.section .note.GNU-stack,"",@progbits']
    source("destroy.S", "\n".join(destroy) + "\n")
    source("acc64.c", prelude + '''extern void external(void);
__attribute__((noinline)) unsigned long preserve(long long *out, const long long *in) {
  boscztt_m_i64_t m, result;
  boscztt_acc_i64_t acc;
  msettyp(m, 0x40000040UL);
  msettyp(result, 0x40000040UL);
  asettyp(acc, 0x40000040UL);
  mls_rm(m, in);
  mmov_a_m(acc, m);
  external();
  mmov_m_a(result, acc);
  mss_rm(result, out);
  return agettyp(acc);
}
int main(void) {
  long long input[16];
  struct { long long before, data[16], after; } output;
  output.before = output.after = 0x0123456789abcdefLL;
  for (int i = 0; i < 16; ++i) {
    input[i] = (i - 7LL) * (1LL << 40) + 37 * i;
    output.data[i] = -100000;
  }
  if (!acquire()) return 77;
  unsigned long descriptor = preserve(output.data, input);
  if (finish() & 1) return 77;
  if (descriptor != 0x40000040UL) return 1;
  if (output.before != 0x0123456789abcdefLL ||
      output.after != 0x0123456789abcdefLL) return 2;
  for (int i = 0; i < 16; ++i)
    if (input[i] != output.data[i]) return 3;
  return 0;
}
''')
    results = []
    with (output / "build.log").open("w") as log:
        def build(command):
            log.write(json.dumps(command) + "\n")
            log.flush()
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)

        def compile(path):
            obj = output / (path.name + ".o")
            build([clang, *flags, "-c", str(path), "-o", str(obj)])
            return str(obj)

        common = [compile(inputs / "gem5-start.S"), compile(inputs / "gem5-runtime.c")]
        for name, files in [("pressure", ["pressure.ll", "pressure-main.c"]),
                            ("group", ["group.ll", "group.S", "group-main.c", "destroy.S"]),
                            ("acc64", ["acc64.c", "destroy.S"])]:
            objects = [compile(output / f) for f in files]
            binary = output / (name + ".elf")
            build([*linker, "-m", "elf64lriscv", "-static", "-e", "_start",
                   "--build-id=none", "--no-dynamic-linker", "--no-relax",
                   *common, *objects, "-o", str(binary)])
            for cpu in args.cpu:
                run_dir = output / (name + "-" + cpu)
                run_dir.mkdir(exist_ok=True)
                report = run_dir / "result.json"
                report.unlink(missing_ok=True)
                command = [str(args.gem5.resolve()), "-d", str(run_dir),
                           str(inputs / "gem5-se.py"), "--binary", str(binary),
                           "--cpu", cpu, "--profile", "ame-gem5"]
                with (run_dir / "run.log").open("w") as run_log:
                    try:
                        code = subprocess.run(command, stdout=run_log,
                                              stderr=subprocess.STDOUT,
                                              timeout=args.timeout).returncode
                    except subprocess.TimeoutExpired:
                        code = -1
                result = json.loads(report.read_text()) if report.exists() else {}
                result.update(name=name, cpu=cpu, host_exit_code=code,
                              log=str(run_dir / "run.log"))
                result["passed"] = code == 0 and result.get("passed", False)
                results.append(result)
                print(("PASS" if result["passed"] else "FAIL") + f": {name} {cpu} "
                      + "guest_exit=" + str(result.get("guest_exit_code")), flush=True)
                (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
    return 0 if all(r["passed"] for r in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
