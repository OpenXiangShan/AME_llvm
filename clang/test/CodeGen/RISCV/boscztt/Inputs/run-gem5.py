"""Build and execute the real-data tests with the external Ztt gem5 fork.

This is an optional integration check, separate from lit's compile-only tests.
"""

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys


def find_linker():
    linker = shutil.which("ld.lld")
    if linker:
        return [linker]
    rustc = shutil.which("rustc")
    if rustc:
        sysroot = subprocess.check_output([rustc, "--print", "sysroot"], text=True).strip()
        version = subprocess.check_output([rustc, "-vV"], text=True)
        host = next(line.removeprefix("host: ") for line in version.splitlines()
                    if line.startswith("host: "))
        linker = Path(sysroot, "lib", "rustlib", host, "bin", "rust-lld")
        if linker.is_file():
            return [str(linker), "-flavor", "gnu"]
    raise SystemExit("A RISC-V-capable ld.lld or Rust toolchain is required")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gem5", type=Path, required=True)
    parser.add_argument("--clang", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--xlen", nargs="+", type=int, choices=(32, 64), default=[32, 64])
    parser.add_argument("--opt", nargs="+", choices=("O0", "O1", "O2", "O3", "Os", "Oz"),
                        default=["O0", "O2"])
    parser.add_argument("--cpu", nargs="+", choices=("atomic", "timing", "minor", "o3"),
                        default=["atomic", "timing", "minor"])
    parser.add_argument("--m-regs", type=int, choices=(16, 32), default=16)
    parser.add_argument("--profile", choices=("default", "ame-gem5"), default="default")
    parser.add_argument("--timeout", type=int, default=60)
    args = parser.parse_args()
    inputs = Path(__file__).resolve().parent
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    clang, gem5 = str(args.clang.resolve()), str(args.gem5.resolve())
    linker = find_linker()
    results = []

    with (output / "build.log").open("w") as log:
        def build(command):
            log.write(json.dumps(command) + "\n")
            log.flush()
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)

        for xlen in args.xlen:
            flags = [f"--target=riscv{xlen}-unknown-linux-gnu",
                     f"-march=rv{xlen}im_boscztt", "-ffreestanding", "-fno-builtin",
                     "-fno-stack-protector", "-fno-pic", "-mcmodel=medany"]
            flags.append("-mboscztt-profile=" + args.profile)
            start = output / f"start-{xlen}.o"
            runtime = output / f"runtime-{xlen}.o"
            build([clang, *flags, "-c", str(inputs / "gem5-start.S"), "-o", str(start)])
            build([clang, *flags, "-O2", "-c", str(inputs / "gem5-runtime.c"),
                   "-o", str(runtime)])
            for opt in args.opt:
                for language, standard, suffix in [("c", "c11", "c"),
                                                    ("cpp", "c++17", "cpp")]:
                    name = f"real-data-{language}-{xlen}-{opt}"
                    obj, binary = output / (name + ".o"), output / (name + ".elf")
                    build([clang, *flags, "-" + opt, "-std=" + standard, "-c",
                           str(inputs.parent / ("real-data." + suffix)), "-o", str(obj)])
                    build([*linker, "-m", f"elf{xlen}lriscv", "-static", "-e", "_start",
                           "--build-id=none", "--no-dynamic-linker", "--no-relax",
                           str(obj), str(start), str(runtime), "-o", str(binary)])
                    for cpu in args.cpu:
                        run_dir = output / (name + "-" + cpu)
                        run_dir.mkdir(exist_ok=True)
                        # Do not allow a stale PASS to mask a simulator failure.
                        (run_dir / "result.json").unlink(missing_ok=True)
                        command = [gem5, "-d", str(run_dir), str(inputs / "gem5-se.py"),
                                   "--binary", str(binary), "--xlen", str(xlen),
                                   "--cpu", cpu, "--m-regs", str(args.m_regs),
                                   "--profile", args.profile]
                        with (run_dir / "run.log").open("w") as run_log:
                            try:
                                process = subprocess.run(command, stdout=run_log,
                                                         stderr=subprocess.STDOUT,
                                                         timeout=args.timeout)
                                host_code = process.returncode
                            except subprocess.TimeoutExpired:
                                host_code = -1
                        report_path = run_dir / "result.json"
                        result = json.loads(report_path.read_text()) if report_path.exists() else {}
                        result.update(name=name, cpu=cpu, host_exit_code=host_code,
                                      log=str(run_dir / "run.log"))
                        result["passed"] = host_code == 0 and result.get("passed", False)
                        results.append(result)
                        print(("PASS" if result["passed"] else "FAIL") + ": " + name +
                              " " + cpu + " guest_exit=" + str(result.get("guest_exit_code")),
                              flush=True)
                        (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
    passed = sum(result["passed"] for result in results)
    print(f"Passed {passed}/{len(results)} target executions")
    return 0 if passed == len(results) else 1


if __name__ == "__main__":
    sys.exit(main())
