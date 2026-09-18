//===- RISCVBoscZtt.h - Fixed AME implementation profiles ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_RISCVBOSCZTT_H
#define LLVM_SUPPORT_RISCVBOSCZTT_H

namespace llvm::RISCV {

struct BoscZttProfile {
  unsigned TileSide;
  unsigned MRegisters;
  unsigned AccRegisters;
  // Maximum element width whose complete ACC value can be preserved through
  // the M-register spill path. This is also the public element-width limit
  // for the profile.
  unsigned MaxElementBits;
  static constexpr unsigned UnitBits = 32;

  constexpr unsigned getMRegisterBytes() const {
    // The .1r instructions transfer one logical M register. This can be
    // smaller than the simulator's backing storage container.
    return TileSide * TileSide * UnitBits / 8;
  }

  constexpr unsigned getAccMImages() const {
    return MaxElementBits / UnitBits;
  }
};

inline constexpr BoscZttProfile BoscZttDefaultProfile{8, 16, 8, 64};
// AME_gem5's unmodified Ztt v0.6 configuration. Its integer execution engine
// also supports 128-bit elements.
inline constexpr BoscZttProfile BoscZttAMEGem5Profile{4, 32, 4, 128};

constexpr BoscZttProfile getBoscZttProfile(bool AMEGem5) {
  return AMEGem5 ? BoscZttAMEGem5Profile : BoscZttDefaultProfile;
}

} // namespace llvm::RISCV

#endif
