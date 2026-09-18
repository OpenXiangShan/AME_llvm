//===-- RISCVBoscZtt.cpp - AME register state preservation ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "RISCV.h"
#include "RISCVInstrInfo.h"
#include "RISCVRegisterInfo.h"
#include "RISCVSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/Support/RISCVBoscZtt.h"
#include <algorithm>

using namespace llvm;

namespace {
class RISCVBoscZtt : public MachineFunctionPass {
public:
  static char ID;
  RISCVBoscZtt() : MachineFunctionPass(ID) {}
  StringRef getPassName() const override {
    return "RISC-V boscztt register state preservation";
  }
  bool runOnMachineFunction(MachineFunction &MF) override;
  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    MachineFunctionPass::getAnalysisUsage(AU);
  }
};

// Expand before PEI: copies may create stack objects, and every address is
// materialized with a normal frame-index ADDI. No vector-length state is used.
static void transfer(MachineInstr &At, Register Reg, int FI, bool Reload,
                     const RISCVInstrInfo &TII, const RISCVRegisterInfo &TRI) {
  MachineBasicBlock &MBB = *At.getParent();
  DebugLoc DL = At.getDebugLoc();
  bool Acc = RISCV::ZTTAAnyRegClass.contains(Reg);
  const auto &ST = MBB.getParent()->getSubtarget<RISCVSubtarget>();
  const auto Profile = RISCV::getBoscZttProfile(ST.hasBoscZttAMEGem5());
  unsigned MBytes = Profile.getMRegisterBytes();
  unsigned AccMImages = Profile.getAccMImages();
  unsigned Base = TRI.getEncodingValue(Reg);
  const auto *RC = TRI.getMinimalPhysRegClass(Reg);
  unsigned Count =
      TRI.getRegSizeInBits(*RC).getFixedValue() / (Acc ? 4096 : 2048);
  constexpr Register Addr = RISCV::X5, Desc = RISCV::X6, Status = RISCV::X7;
  auto emit = [&](unsigned Op) { return BuildMI(MBB, At, DL, TII.get(Op)); };
  auto address = [&](unsigned Offset) {
    // A 16-register M image exceeds ADDI's immediate range. Keep every
    // instruction valid even before PEI resolves the frame index.
    unsigned Chunk = std::min(Offset, 2047U);
    emit(RISCV::ADDI).addDef(Addr).addFrameIndex(FI).addImm(Chunk);
    while (Offset > Chunk) {
      Offset -= Chunk;
      Chunk = std::min(Offset, 2047U);
      emit(RISCV::ADDI).addDef(Addr).addReg(Addr).addImm(Chunk);
    }
  };
  auto word = [&](bool Load, unsigned Offset, Register R) {
    address(Offset);
    emit(Load ? RISCV::LW : RISCV::SW)
        .addReg(R, Load ? RegState::Define : RegState::NoFlags)
        .addReg(Addr)
        .addImm(0);
  };
  auto getType = [&](Register R, bool A) {
    emit(A ? RISCV::ZTT_AGETTYP : RISCV::ZTT_MGETTYP)
        .addDef(Desc).addReg(R, RegState::Undef);
  };
  auto setType = [&](Register R, bool A) {
    emit(A ? RISCV::ZTT_ASETTYP : RISCV::ZTT_MSETTYP)
        .addDef(R).addReg(Desc);
  };
  auto raw = [&](Register R, unsigned Offset, bool Load) {
    address(Offset);
    if (Load)
      emit(RISCV::ZTT_MLS_1R).addDef(R).addReg(R, RegState::Undef).addReg(Addr);
    else
      emit(RISCV::ZTT_MSS_1R).addReg(R, RegState::Undef).addReg(Addr);
  };
  // Do not expose status changes made while programming spill scratch state.
  emit(RISCV::CSRRS).addDef(Status).addImm(0x800).addReg(RISCV::X0);
  if (!Acc) {
    Register M = RISCV::ZTTM0 + Base;
    if (Reload) {
      word(true, 0, Desc);
      setType(M, false);
    } else {
      getType(M, false);
      word(false, 0, Desc);
    }
    for (unsigned I = 0; I < Count; ++I)
      raw(RISCV::ZTTM0 + Base + I, 8 + I * MBytes, Reload);
  } else {
    // A packed M/ACC move accesses a consecutive ACC group; its allocation
    // reserves that complete group. Save enough M images for the profile's
    // widest descriptor: restoring an old Md0 can clear that entire group,
    // even when the ACC being transferred has a narrower datatype.
    unsigned Scratch = 8 + AccMImages * MBytes;
    getType(RISCV::ZTTM0, false);
    word(false, Scratch, Desc);
    for (unsigned I = 0; I < AccMImages; ++I)
      raw(RISCV::ZTTM0 + I, Scratch + 8 + I * MBytes, false);
    Register A = RISCV::ZTTA0 + Base;
    if (Reload) {
      word(true, 0, Desc);
      setType(A, true);
      setType(RISCV::ZTTM0, false);
      for (unsigned I = 0; I < AccMImages; ++I)
        raw(RISCV::ZTTM0 + I, 8 + I * MBytes, true);
      emit(RISCV::ZTT_MMOV_A_M).addDef(A).addReg(A, RegState::Undef)
          .addReg(RISCV::ZTTM0);
    } else {
      getType(A, true);
      word(false, 0, Desc);
      setType(RISCV::ZTTM0, false);
      emit(RISCV::ZTT_MMOV_M_A).addDef(RISCV::ZTTM0)
          .addReg(RISCV::ZTTM0, RegState::Undef).addReg(A, RegState::Undef);
      raw(RISCV::ZTTM0, 8, false);
      for (unsigned I = 1; I < AccMImages; ++I)
        raw(RISCV::ZTTM0 + I, 8 + I * MBytes, false);
    }
    word(true, Scratch, Desc);
    setType(RISCV::ZTTM0, false);
    for (unsigned I = 0; I < AccMImages; ++I)
      raw(RISCV::ZTTM0 + I, Scratch + 8 + I * MBytes, true);
  }
  auto End = emit(RISCV::CSRRW).addDef(RISCV::X0).addImm(0x800).addReg(Status);
  if (Reload)
    End.addReg(Reg, RegState::ImplicitDefine);
  else
    End.addReg(Reg, RegState::Implicit | RegState::Undef);
}
} // namespace

char RISCVBoscZtt::ID = 0;
INITIALIZE_PASS(RISCVBoscZtt, "riscv-boscztt",
                "RISC-V boscztt register state preservation", false, false)

bool RISCVBoscZtt::runOnMachineFunction(MachineFunction &MF) {
  const auto &ST = MF.getSubtarget<RISCVSubtarget>();
  if (!ST.hasVendorBoscZtt())
    return false;
  const auto &TII = *ST.getInstrInfo();
  const auto &TRI = *ST.getRegisterInfo();
  bool Changed = false;
  for (MachineBasicBlock &MBB : MF) {
    for (MachineInstr &MI : make_early_inc_range(MBB)) {
      unsigned Op = MI.getOpcode();
      if (MI.isCopy() &&
          (RISCV::ZTTMAnyRegClass.contains(MI.getOperand(0).getReg()) ||
           RISCV::ZTTAAnyRegClass.contains(MI.getOperand(0).getReg()))) {
        Register Dst = MI.getOperand(0).getReg(), Src = MI.getOperand(1).getReg();
        if (Dst != Src) {
          const auto *RC = TRI.getMinimalPhysRegClass(Src);
          int FI = MF.getFrameInfo().CreateStackObject(TRI.getSpillSize(*RC),
                                                      Align(8), true);
          transfer(MI, Src, FI, false, TII, TRI);
          transfer(MI, Dst, FI, true, TII, TRI);
        }
      } else if (Op == RISCV::ZTT_SPILL_M || Op == RISCV::ZTT_SPILL_A ||
                 Op == RISCV::ZTT_RELOAD_M || Op == RISCV::ZTT_RELOAD_A) {
        transfer(MI, MI.getOperand(0).getReg(), MI.getOperand(1).getIndex(),
                 Op == RISCV::ZTT_RELOAD_M || Op == RISCV::ZTT_RELOAD_A, TII, TRI);
      } else {
        continue;
      }
      MI.eraseFromParent();
      Changed = true;
    }
  }
  return Changed;
}

FunctionPass *llvm::createRISCVBoscZttPass() { return new RISCVBoscZtt(); }
