"""Run a boscztt real-data ELF under the external Ztt gem5 fork."""

import argparse
import json
from pathlib import Path
import sys

import m5
from m5.objects import (
    AddrRange, Cache, Process, RiscvAtomicSimpleCPU, RiscvMinorCPU, RiscvO3CPU,
    RiscvTimingSimpleCPU, Root, SEWorkload, SimpleMemory, SrcClockDomain,
    System, SystemXBar, VoltageDomain,
)

parser = argparse.ArgumentParser()
parser.add_argument("--binary", required=True)
parser.add_argument("--xlen", type=int, choices=(32, 64), default=64)
parser.add_argument("--cpu", choices=("atomic", "timing", "minor", "o3"), default="atomic")
parser.add_argument("--m-regs", type=int, choices=(16, 32), default=16)
parser.add_argument("--profile", choices=("default", "ame-gem5"), default="default")
parser.add_argument("--max-ticks", type=int, default=10_000_000_000)
parser.add_argument("--cache-line-bytes", type=int, choices=(64, 128, 256), default=64)
args = parser.parse_args()

system = System()
system.clk_domain = SrcClockDomain(clock="1GHz", voltage_domain=VoltageDomain())
system.mem_mode = "atomic" if args.cpu == "atomic" else "timing"
system.mem_ranges = [AddrRange("64MiB")]
system.cache_line_size = args.cache_line_bytes
cpu_class = {"atomic": RiscvAtomicSimpleCPU, "timing": RiscvTimingSimpleCPU,
             "minor": RiscvMinorCPU, "o3": RiscvO3CPU}[args.cpu]
system.cpu = cpu_class()
system.cpu.max_insts_any_thread = 5_000_000
system.membus = SystemXBar()

class L1Cache(Cache):
    assoc = 2
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 4
    tgts_per_mshr = 8

system.icache = L1Cache(size="32KiB")
system.dcache = L1Cache(size="32KiB")
system.cpu.icache_port = system.icache.cpu_side
system.cpu.dcache_port = system.dcache.cpu_side
system.icache.mem_side = system.membus.cpu_side_ports
system.dcache.mem_side = system.membus.cpu_side_ports
system.cpu.createInterruptController()
system.memory = SimpleMemory(range=system.mem_ranges[0], latency="20ns")
system.memory.port = system.membus.mem_side_ports
system.system_port = system.membus.cpu_side_ports

system.workload = SEWorkload.init_compatible(args.binary)
system.cpu.workload = Process(cmd=[str(Path(args.binary).resolve())])
system.cpu.createThreads()
isa = system.cpu.isa[0]
if args.profile == "default":
    isa.riscv_type = "RV" + str(args.xlen)
    isa.enable_rvv = False
    isa.enable_rvmatrix = True
    isa.ztt_nelem = 64
    isa.ztt_unit_datatype_size = 32
    isa.ztt_num_m_regs = args.m_regs
    isa.ztt_num_acc_regs = 8
    isa.ztt_ew_profile = 0
else:
    # This newer fork selects XLEN through an ISA reporting profile. Its
    # extension list controls reporting, not decoder availability.
    isa.riscv_profile = "RVI20U" + str(args.xlen)
    isa.extra_extensions = ["M", "Zicsr", "Zifencei"]
# AME_gem5 fixes these values in C++; it has no ztt_* Python parameters.
tile_side, m_regs, acc_regs = ((4, 32, 4) if args.profile == "ame-gem5"
                               else (8, args.m_regs, 8))

root = Root(full_system=False, system=system)
m5.instantiate()
event = m5.simulate(args.max_ticks)
result = {
    "binary": args.binary,
    "xlen": args.xlen,
    "cpu": args.cpu,
    "profile": args.profile,
    "tile_side": tile_side,
    "nelem": tile_side * tile_side,
    "unit_bits": 32,
    "cache_line_bytes": args.cache_line_bytes,
    "m_registers": m_regs,
    "acc_registers": acc_regs,
    "rvv_enabled": False if args.profile == "default" else None,
    "rvv_reported": ("V" in isa.get_reported_extensions()
                     if args.profile == "ame-gem5" else False),
    "rvv_in_program": False,
    "tick": m5.curTick(),
    "cause": event.getCause(),
    "guest_exit_code": event.getCode(),
}
result["passed"] = (result["cause"] == "exiting with last active thread context"
                    and result["guest_exit_code"] == 0)
Path(m5.options.outdir, "result.json").write_text(json.dumps(result, indent=2) + "\n")
print("boscztt-result: " + json.dumps(result))
sys.exit(0 if result["passed"] else 1)
