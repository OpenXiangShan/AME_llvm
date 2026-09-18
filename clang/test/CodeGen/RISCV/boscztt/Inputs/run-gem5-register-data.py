"""Run the AME profile's FastCC, select and clobber data regressions.

Defaults to eight Atomic executions (C/C++, RV32/RV64, O0/O2). Sources are
tracked beside this script; commands, assembly and simulator output are kept
under --output. No simulator rebuild or source changes are needed.
"""

import argparse
import json
from pathlib import Path
import runpy
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("clang", "gem5", "output"):
        parser.add_argument("--" + option, type=Path, required=True)
    parser.add_argument("--cpu", nargs="+", choices=("atomic", "timing", "minor", "o3"),
                        default=["atomic"])
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--cache-line-bytes", type=int, choices=(64, 128, 256),
                        default=64)
    parser.add_argument("--source", type=Path,
                        help="Override the register-data C/C++ execution fixture")
    args = parser.parse_args()
    inputs = Path(__file__).resolve().parent
    source = args.source.resolve() if args.source else inputs.parent / "ame-gem5-register-data.c"
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    clang = str(args.clang.resolve())
    linker = runpy.run_path(str(inputs / "run-gem5.py"))["find_linker"]()
    results = []

    with (output / "build.log").open("w") as log:
        def build(command):
            log.write(json.dumps(command) + "\n")
            log.flush()
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT,
                           check=True)

        for xlen in (32, 64):
            flags = [f"--target=riscv{xlen}-unknown-linux-gnu",
                     f"-march=rv{xlen}im_boscztt", "-mboscztt-profile=ame-gem5",
                     "-ffreestanding", "-fno-builtin", "-fno-stack-protector",
                     "-fno-pic", "-mcmodel=medany"]
            common = []
            for filename in ("gem5-start.S", "gem5-runtime.c", "gem5-register-data.S"):
                obj = output / f"{filename}-{xlen}.o"
                build([clang, *flags, "-O2", "-c", str(inputs / filename),
                       "-o", str(obj)])
                common.append(str(obj))
            for language, standard in (("c", "c11"), ("c++", "c++17")):
                for opt in ("O0", "O2"):
                    name = f"register-data-{language.replace('+', 'p')}-{xlen}-{opt}"
                    obj, binary = output / (name + ".o"), output / (name + ".elf")
                    compile_args = [clang, *flags, "-" + opt, "-x", language,
                                    "-std=" + standard,
                                    str(source)]
                    build([*compile_args, "-c", "-o", str(obj)])
                    build([*compile_args, "-S", "-o", str(output / (name + ".s"))])
                    build([*linker, "-m", f"elf{xlen}lriscv", "-static", "-e", "_start",
                           "--build-id=none", "--no-dynamic-linker", "--no-relax",
                           "--gc-sections",
                           *common, str(obj), "-o", str(binary)])
                    for cpu in args.cpu:
                        run_dir = output / (name + "-" + cpu)
                        run_dir.mkdir(exist_ok=True)
                        report_path = run_dir / "result.json"
                        report_path.unlink(missing_ok=True)
                        command = [str(args.gem5.resolve()), "-d", str(run_dir),
                                   str(inputs / "gem5-se.py"), "--binary", str(binary),
                                   "--xlen", str(xlen), "--cpu", cpu,
                                   "--profile", "ame-gem5", "--cache-line-bytes",
                                   str(args.cache_line_bytes)]
                        with (run_dir / "run.log").open("w") as run_log:
                            try:
                                code = subprocess.run(command, stdout=run_log,
                                                      stderr=subprocess.STDOUT,
                                                      timeout=args.timeout).returncode
                            except subprocess.TimeoutExpired:
                                code = -1
                        result = json.loads(report_path.read_text()) if report_path.exists() else {}
                        result.update(name=name, cpu=cpu, host_exit_code=code)
                        result["passed"] = code == 0 and result.get("passed", False)
                        results.append(result)
                        print(("PASS" if result["passed"] else "FAIL") + f": {name} {cpu} "
                              + "guest_exit=" + str(result.get("guest_exit_code")), flush=True)
                        (output / "results.json").write_text(json.dumps(results, indent=2) + "\n")
    return 0 if all(r["passed"] for r in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
