// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Provisional encodings from Ztt-v0.6.pdf (2026-08-16, commit 8d27acd).

class ZTTInst<dag outs, dag ins, string mnemonic, string operands>
    : RVInst<outs, ins, mnemonic, operands, [], InstFormatR> {
  let Predicates = [HasVendorBoscZtt];
  let hasSideEffects = 1;
  let mayLoad = 0;
  let mayStore = 0;
  let hasNoSchedulingInfo = 1;
  let Uses = [ZTT_STATE];
  let Defs = [ZTT_STATE];
}

def ZTT_AME_ACQUIRE : ZTTInst<(outs GPR:$rd),
    (ins GPR:$rs1), "ame.acquire", "$rd, $rs1"> {
  let Inst = 0xa490002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> rd;
  let Inst{11-7} = rd;
  // Ownership transitions order ordinary state-save memory accesses too.
  let mayLoad = 1;
  let mayStore = 1;
}

def ZTT_AME_ACQUIRE_CG : ZTTInst<(outs GPR:$rd),
    (ins GPR:$rs1), "ame.acquire", "$rd, $rs1"> {
  let Inst = 0xa490002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
  // Ownership transitions order ordinary state-save memory accesses too.
  let mayLoad = 1;
  let mayStore = 1;
}

def ZTT_AME_RELEASE : ZTTInst<(outs),
    (ins), "ame.release", ""> {
  let Inst = 0xa4a0002b;
  // Ownership transitions order ordinary state-save memory accesses too.
  let mayLoad = 1;
  let mayStore = 1;
}

def ZTT_AME_RELEASE_CG : ZTTInst<(outs),
    (ins), "ame.release", ""> {
  let Inst = 0xa4a0002b;
  let isCodeGenOnly = 1;
  // Ownership transitions order ordinary state-save memory accesses too.
  let mayLoad = 1;
  let mayStore = 1;
}

def ZTT_AGETTYP : ZTTInst<(outs GPR:$rd),
    (ins ZTTAR:$ad), "agettyp", "$rd, $ad"> {
  let Inst = 0xa200002b;
  bits<5> ad;
  let Inst{19-15} = ad;
  bits<5> rd;
  let Inst{11-7} = rd;
}

def ZTT_AGETTYP_CG : ZTTInst<(outs GPR:$rd),
    (ins ZTTAAny:$ad), "agettyp", "$rd, $ad"> {
  let Inst = 0xa200002b;
  bits<5> ad;
  let Inst{19-15} = ad;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
}

def ZTT_ASETTYP : ZTTInst<(outs ZTTAR:$ad),
    (ins GPR:$rs1), "asettyp", "$ad, $rs1"> {
  let Inst = 0xa210002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ad;
  let Inst{11-7} = ad;
}

def ZTT_ASETTYP_CG : ZTTInst<(outs ZTTAAny:$ad),
    (ins ZTTAAny:$ad_in, GPR:$rs1), "asettyp", "$ad, $rs1"> {
  let Inst = 0xa210002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ad;
  let Inst{11-7} = ad;
  let isCodeGenOnly = 1;
  let Constraints = "$ad = $ad_in";
}

def ZTT_MABS_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mabs.ew", "$md, $ms1"> {
  let Inst = 0xa240002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MABS_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mabs.ew", "$md, $ms1"> {
  let Inst = 0xa240002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MABSDIFF_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mabsdiff.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MABSDIFF_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mabsdiff.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MABSDIFF_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mabsdiff.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MABSDIFF_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mabsdiff.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MADD_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "madd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MADD_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "madd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MADD_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "madd.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MADD_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "madd.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MAND_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mand.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MAND_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mand.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MAND_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mand.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MAND_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mand.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MANDNOT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mandnot.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MANDNOT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mandnot.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MANDNOT_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mandnot.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MANDNOT_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mandnot.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMOVGE_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcmovge.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMOVGE_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcmovge.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMOVLT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcmovlt.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMOVLT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcmovlt.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPGE_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcmpge.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPGE_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcmpge.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPGE_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mcmpge.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x5a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPGE_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mcmpge.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x5a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPLT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcmplt.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPLT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcmplt.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPLT_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mcmplt.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x5e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCMPLT_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mcmplt.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x5e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLBCAST_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mcolbcast.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLBCAST_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mcolbcast.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLGATHER_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcolgather.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLGATHER_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcolgather.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLID_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in), "mcolid.ew", "$md"> {
  let Inst = 0xa601002b;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLID_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in), "mcolid.ew", "$md"> {
  let Inst = 0xa601002b;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLSHIFT_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mcolshift.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLSHIFT_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mcolshift.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLUNZIP_EW : ZTTInst<(outs ZTTMR:$ms1, ZTTMR:$ms2),
    (ins ZTTMR:$ms1_in, ZTTMR:$ms2_in), "mcolunzip.ew", "$ms1, $ms2"> {
  let Inst = 0xc200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MCOLUNZIP_EW_CG : ZTTInst<(outs ZTTMAny:$ms1, ZTTMAny:$ms2),
    (ins ZTTMAny:$ms1_in, ZTTMAny:$ms2_in), "mcolunzip.ew", "$ms1, $ms2"> {
  let Inst = 0xc200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let isCodeGenOnly = 1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MCOLZIP_EW : ZTTInst<(outs ZTTMR:$ms1, ZTTMR:$ms2),
    (ins ZTTMR:$ms1_in, ZTTMR:$ms2_in), "mcolzip.ew", "$ms1, $ms2"> {
  let Inst = 0xc400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MCOLZIP_EW_CG : ZTTInst<(outs ZTTMAny:$ms1, ZTTMAny:$ms2),
    (ins ZTTMAny:$ms1_in, ZTTMAny:$ms2_in), "mcolzip.ew", "$ms1, $ms2"> {
  let Inst = 0xc400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let isCodeGenOnly = 1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MCONV_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mconv.ew", "$md, $ms1"> {
  let Inst = 0xa2d0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCONV_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mconv.ew", "$md, $ms1"> {
  let Inst = 0xa2d0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MBCAST_M_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, GPR:$rs2), "mbcast.m.x", "$md, $rs1, $rs2"> {
  let Inst = 0xb000002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MBCAST_M_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, GPR:$rs2), "mbcast.m.x", "$md, $rs1, $rs2"> {
  let Inst = 0xb000002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOS_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mcos.ew", "$md, $ms1"> {
  let Inst = 0xa2e0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOS_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mcos.ew", "$md, $ms1"> {
  let Inst = 0xa2e0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MEXP2_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mexp2.ew", "$md, $ms1"> {
  let Inst = 0xa2f0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MEXP2_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mexp2.ew", "$md, $ms1"> {
  let Inst = 0xa2f0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTM_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mfrintm.ew", "$md, $ms1"> {
  let Inst = 0xa250002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTM_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mfrintm.ew", "$md, $ms1"> {
  let Inst = 0xa250002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTN_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mfrintn.ew", "$md, $ms1"> {
  let Inst = 0xa260002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTN_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mfrintn.ew", "$md, $ms1"> {
  let Inst = 0xa260002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTP_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mfrintp.ew", "$md, $ms1"> {
  let Inst = 0xa270002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTP_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mfrintp.ew", "$md, $ms1"> {
  let Inst = 0xa270002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTZ_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mfrintz.ew", "$md, $ms1"> {
  let Inst = 0xa280002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MFRINTZ_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mfrintz.ew", "$md, $ms1"> {
  let Inst = 0xa280002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MGETTYP : ZTTInst<(outs GPR:$rd),
    (ins ZTTMR:$ms1), "mgettyp", "$rd, $ms1"> {
  let Inst = 0xa220002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> rd;
  let Inst{11-7} = rd;
}

def ZTT_MGETTYP_CG : ZTTInst<(outs GPR:$rd),
    (ins ZTTMAny:$ms1), "mgettyp", "$rd, $ms1"> {
  let Inst = 0xa220002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
}

def ZTT_MHDIFF_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mhdiff.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MHDIFF_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mhdiff.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MHDIFF_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mhdiff.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MHDIFF_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mhdiff.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXP_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mldexp.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXP_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mldexp.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXP_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mldexp.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x8000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXP_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mldexp.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x8000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXPACC_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mldexpacc.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXPACC_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mldexpacc.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXPACC_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mldexpacc.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x8400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLDEXPACC_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mldexpacc.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x8400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLOG2_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mlog2.ew", "$md, $ms1"> {
  let Inst = 0xa300002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLOG2_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mlog2.ew", "$md, $ms1"> {
  let Inst = 0xa300002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLOG2SUB_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mlog2sub.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLOG2SUB_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mlog2sub.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLOG2SUB_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mlog2sub.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x8800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MLOG2SUB_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mlog2sub.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x8800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MLS_1R : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1), "mls.1r", "$md, $rs1"> {
  let Inst = 0xa360002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_1R_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1), "mls.1r", "$md, $rs1"> {
  let Inst = 0xa360002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_CM : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1), "mls.cm", "$md, $rs1"> {
  let Inst = 0xa370002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_CM_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1), "mls.cm", "$md, $rs1"> {
  let Inst = 0xa370002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_RM : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1), "mls.rm", "$md, $rs1"> {
  let Inst = 0xa380002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_RM_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1), "mls.rm", "$md, $rs1"> {
  let Inst = 0xa380002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_ST : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, GPR:$rs2), "mls.st", "$md, (${rs1}), $rs2"> {
  let Inst = 0xa800002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_ST_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, GPR:$rs2), "mls.st", "$md, (${rs1}), $rs2"> {
  let Inst = 0xa800002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_TST : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, GPR:$rs2), "mls.tst", "$md, (${rs1}), $rs2"> {
  let Inst = 0xaa00002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MLS_TST_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, GPR:$rs2), "mls.tst", "$md, (${rs1}), $rs2"> {
  let Inst = 0xaa00002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
  let mayLoad = 1;
}

def ZTT_MMAX_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmax.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMAX_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmax.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x0c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMAX_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmax.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMAX_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmax.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x0e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMEAN_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmean.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMEAN_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmean.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMEAN_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmean.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMEAN_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmean.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMIN_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmin.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMIN_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmin.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMIN_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmin.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMIN_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmin.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOV_M_A : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTAR:$acc), "mmov.m.a", "$md, $acc"> {
  let Inst = 0xa3c0002b;
  bits<5> acc;
  let Inst{19-15} = acc;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOV_M_A_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTAAny:$acc), "mmov.m.a", "$md, $acc"> {
  let Inst = 0xa3c0002b;
  bits<5> acc;
  let Inst{19-15} = acc;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOV_A_M : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms), "mmov.a.m", "$acc, $ms"> {
  let Inst = 0xa3d0002b;
  bits<5> ms;
  let Inst{19-15} = ms;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMOV_A_M_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms), "mmov.a.m", "$acc, $ms"> {
  let Inst = 0xa3d0002b;
  bits<5> ms;
  let Inst{19-15} = ms;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMOV_M_M : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms), "mmov.m.m", "$md, $ms"> {
  let Inst = 0xa3e0002b;
  bits<5> ms;
  let Inst{19-15} = ms;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOV_M_M_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms), "mmov.m.m", "$md, $ms"> {
  let Inst = 0xa3e0002b;
  bits<5> ms;
  let Inst{19-15} = ms;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE8_M_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs2, GPR:$rs1), "mmove8.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb200002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE8_M_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs2, GPR:$rs1), "mmove8.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb200002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE16_M_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs2, GPR:$rs1), "mmove16.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb400002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE16_M_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs2, GPR:$rs1), "mmove16.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb400002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE32_M_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs2, GPR:$rs1), "mmove32.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb600002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE32_M_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs2, GPR:$rs1), "mmove32.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb600002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE64_M_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs2, GPR:$rs1), "mmove64.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb800002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE64_M_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs2, GPR:$rs1), "mmove64.m.x", "$md, $rs2, $rs1"> {
  let Inst = 0xb800002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> rs2;
  let Inst{19-15} = rs2;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMOVE8_X_M : ZTTInst<(outs GPR:$rd),
    (ins ZTTMR:$ms2, GPR:$rs1), "mmove8.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xba00002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
}

def ZTT_MMOVE8_X_M_CG : ZTTInst<(outs GPR:$rd),
    (ins ZTTMAny:$ms2, GPR:$rs1), "mmove8.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xba00002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
}

def ZTT_MMOVE16_X_M : ZTTInst<(outs GPR:$rd),
    (ins ZTTMR:$ms2, GPR:$rs1), "mmove16.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xbc00002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
}

def ZTT_MMOVE16_X_M_CG : ZTTInst<(outs GPR:$rd),
    (ins ZTTMAny:$ms2, GPR:$rs1), "mmove16.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xbc00002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
}

def ZTT_MMOVE32_X_M : ZTTInst<(outs GPR:$rd),
    (ins ZTTMR:$ms2, GPR:$rs1), "mmove32.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xbe00002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
}

def ZTT_MMOVE32_X_M_CG : ZTTInst<(outs GPR:$rd),
    (ins ZTTMAny:$ms2, GPR:$rs1), "mmove32.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xbe00002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
}

def ZTT_MMOVE64_X_M : ZTTInst<(outs GPR:$rd),
    (ins ZTTMR:$ms2, GPR:$rs1), "mmove64.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xc000002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
}

def ZTT_MMOVE64_X_M_CG : ZTTInst<(outs GPR:$rd),
    (ins ZTTMAny:$ms2, GPR:$rs1), "mmove64.x.m", "$rd, $ms2, $rs1"> {
  let Inst = 0xc000002b;
  bits<5> rs1;
  let Inst{24-20} = rs1;
  bits<5> ms2;
  let Inst{19-15} = ms2;
  bits<5> rd;
  let Inst{11-7} = rd;
  let isCodeGenOnly = 1;
}

def ZTT_MMUL_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmul.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMUL_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmul.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMUL_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmul.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMUL_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmul.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACC_2D : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulacc.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULACC_2D_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulacc.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULACC_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulacc.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACC_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulacc.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x1c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACC_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmulacc.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACC_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmulacc.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x1e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACCNEG_2D : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulaccneg.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULACCNEG_2D_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulaccneg.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULACCNEG_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulaccneg.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACCNEG_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulaccneg.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACCNEG_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmulaccneg.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULACCNEG_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmulaccneg.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULADD_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmuladd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULADD_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmuladd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULADD_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmuladd.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULADD_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmuladd.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULATACC_2D : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulatacc.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULATACC_2D_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulatacc.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULATACCNEG_2D : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulataccneg.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULATACCNEG_2D_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulataccneg.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULBTACC_2D : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulbtacc.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULBTACC_2D_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulbtacc.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0x9e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULBTACCNEG_2D : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulbtaccneg.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0xa000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULBTACCNEG_2D_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulbtaccneg.2d", "$acc, $ms1, $ms2"> {
  let Inst = 0xa000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MMULNEG_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulneg.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULNEG_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulneg.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULNEG_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmulneg.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULNEG_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmulneg.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULSUB_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mmulsub.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULSUB_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mmulsub.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x2c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULSUB_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mmulsub.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MMULSUB_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mmulsub.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x2e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MOR_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mor.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MOR_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mor.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MOR_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mor.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MOR_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mor.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MORNOT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mornot.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MORNOT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mornot.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MORNOT_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mornot.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MORNOT_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mornot.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MPACK_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mpack.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x7a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MPACK_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mpack.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x7a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXADD_COL : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mprefixadd.col", "$md, $ms1"> {
  let Inst = 0xa3f0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXADD_COL_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mprefixadd.col", "$md, $ms1"> {
  let Inst = 0xa3f0002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXADD_ROW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mprefixadd.row", "$md, $ms1"> {
  let Inst = 0xa400002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXADD_ROW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mprefixadd.row", "$md, $ms1"> {
  let Inst = 0xa400002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXMAX_COL : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mprefixmax.col", "$md, $ms1"> {
  let Inst = 0xa410002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXMAX_COL_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mprefixmax.col", "$md, $ms1"> {
  let Inst = 0xa410002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXMAX_ROW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mprefixmax.row", "$md, $ms1"> {
  let Inst = 0xa420002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MPREFIXMAX_ROW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mprefixmax.row", "$md, $ms1"> {
  let Inst = 0xa420002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MRDEXP_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mrdexp.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MRDEXP_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mrdexp.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MRDEXPACC_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mrdexpacc.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MRDEXPACC_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mrdexpacc.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREC_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mrec.ew", "$md, $ms1"> {
  let Inst = 0xa310002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREC_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mrec.ew", "$md, $ms1"> {
  let Inst = 0xa310002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEADD_COL : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mreduceadd.col", "$md, $ms1"> {
  let Inst = 0xa430002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEADD_COL_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mreduceadd.col", "$md, $ms1"> {
  let Inst = 0xa430002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEADD_ROW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mreduceadd.row", "$md, $ms1"> {
  let Inst = 0xa440002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEADD_ROW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mreduceadd.row", "$md, $ms1"> {
  let Inst = 0xa440002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMAX_COL : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mreducemax.col", "$md, $ms1"> {
  let Inst = 0xa450002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMAX_COL_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mreducemax.col", "$md, $ms1"> {
  let Inst = 0xa450002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMAX_ROW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mreducemax.row", "$md, $ms1"> {
  let Inst = 0xa460002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMAX_ROW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mreducemax.row", "$md, $ms1"> {
  let Inst = 0xa460002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMIN_COL : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mreducemin.col", "$md, $ms1"> {
  let Inst = 0xa470002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMIN_COL_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mreducemin.col", "$md, $ms1"> {
  let Inst = 0xa470002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMIN_ROW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mreducemin.row", "$md, $ms1"> {
  let Inst = 0xa480002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MREDUCEMIN_ROW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mreducemin.row", "$md, $ms1"> {
  let Inst = 0xa480002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWBCAST_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mrowbcast.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWBCAST_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mrowbcast.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWGATHER_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mrowgather.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWGATHER_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mrowgather.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWID_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in), "mrowid.ew", "$md"> {
  let Inst = 0xa601802b;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWID_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in), "mrowid.ew", "$md"> {
  let Inst = 0xa601802b;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWSHIFT_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mrowshift.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWSHIFT_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mrowshift.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x6e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWUNZIP_EW : ZTTInst<(outs ZTTMR:$ms1, ZTTMR:$ms2),
    (ins ZTTMR:$ms1_in, ZTTMR:$ms2_in), "mrowunzip.ew", "$ms1, $ms2"> {
  let Inst = 0xc600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MROWUNZIP_EW_CG : ZTTInst<(outs ZTTMAny:$ms1, ZTTMAny:$ms2),
    (ins ZTTMAny:$ms1_in, ZTTMAny:$ms2_in), "mrowunzip.ew", "$ms1, $ms2"> {
  let Inst = 0xc600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let isCodeGenOnly = 1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MROWZIP_EW : ZTTInst<(outs ZTTMR:$ms1, ZTTMR:$ms2),
    (ins ZTTMR:$ms1_in, ZTTMR:$ms2_in), "mrowzip.ew", "$ms1, $ms2"> {
  let Inst = 0x7000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MROWZIP_EW_CG : ZTTInst<(outs ZTTMAny:$ms1, ZTTMAny:$ms2),
    (ins ZTTMAny:$ms1_in, ZTTMAny:$ms2_in), "mrowzip.ew", "$ms1, $ms2"> {
  let Inst = 0x7000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  let isCodeGenOnly = 1;
  let Constraints = "$ms1 = $ms1_in, $ms2 = $ms2_in";
}

def ZTT_MRSQRT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mrsqrt.ew", "$md, $ms1"> {
  let Inst = 0xa320002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MRSQRT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mrsqrt.ew", "$md, $ms1"> {
  let Inst = 0xa320002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWSCATADD_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mrowscatadd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWSCATADD_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mrowscatadd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLSCATADD_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcolscatadd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLSCATADD_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcolscatadd.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWSCATMAX_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mrowscatmax.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MROWSCATMAX_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mrowscatmax.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLSCATMAX_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mcolscatmax.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MCOLSCATMAX_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mcolscatmax.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x7800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSELGE_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mselge.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSELGE_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mselge.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSELLT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "msellt.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSELLT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "msellt.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x6200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSETTYP : ZTTInst<(outs ZTTMR:$md),
    (ins GPR:$rs1), "msettyp", "$md, $rs1"> {
  let Inst = 0xa230002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
}

def ZTT_MSETTYP_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1), "msettyp", "$md, $rs1"> {
  let Inst = 0xa230002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSIN_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "msin.ew", "$md, $ms1"> {
  let Inst = 0xa330002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSIN_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "msin.ew", "$md, $ms1"> {
  let Inst = 0xa330002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSLL_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "msll.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSLL_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "msll.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4400002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSLL_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "msll.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSLL_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "msll.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4600002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSQRT_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "msqrt.ew", "$md, $ms1"> {
  let Inst = 0xa340002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSQRT_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "msqrt.ew", "$md, $ms1"> {
  let Inst = 0xa340002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRA_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "msra.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRA_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "msra.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4800002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRA_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "msra.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRA_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "msra.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4a00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRL_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "msrl.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRL_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "msrl.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x4c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRL_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "msrl.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSRL_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "msrl.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x4e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSS_1R : ZTTInst<(outs),
    (ins ZTTMR:$ms1, GPR:$rs1), "mss.1r", "$ms1, $rs1"> {
  let Inst = 0xa390002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let mayStore = 1;
}

def ZTT_MSS_1R_CG : ZTTInst<(outs),
    (ins ZTTMAny:$ms1, GPR:$rs1), "mss.1r", "$ms1, $rs1"> {
  let Inst = 0xa390002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let isCodeGenOnly = 1;
  let mayStore = 1;
}

def ZTT_MSS_CM : ZTTInst<(outs),
    (ins ZTTMR:$ms1, GPR:$rs1), "mss.cm", "$ms1, $rs1"> {
  let Inst = 0xa3a0002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let mayStore = 1;
}

def ZTT_MSS_CM_CG : ZTTInst<(outs),
    (ins ZTTMAny:$ms1, GPR:$rs1), "mss.cm", "$ms1, $rs1"> {
  let Inst = 0xa3a0002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let isCodeGenOnly = 1;
  let mayStore = 1;
}

def ZTT_MSS_RM : ZTTInst<(outs),
    (ins ZTTMR:$ms1, GPR:$rs1), "mss.rm", "$ms1, $rs1"> {
  let Inst = 0xa3b0002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let mayStore = 1;
}

def ZTT_MSS_RM_CG : ZTTInst<(outs),
    (ins ZTTMAny:$ms1, GPR:$rs1), "mss.rm", "$ms1, $rs1"> {
  let Inst = 0xa3b0002b;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let isCodeGenOnly = 1;
  let mayStore = 1;
}

def ZTT_MSS_ST : ZTTInst<(outs),
    (ins ZTTMR:$ms1, GPR:$rs1, GPR:$rs2), "mss.st", "$ms1, (${rs1}), $rs2"> {
  let Inst = 0xac00002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let mayStore = 1;
}

def ZTT_MSS_ST_CG : ZTTInst<(outs),
    (ins ZTTMAny:$ms1, GPR:$rs1, GPR:$rs2), "mss.st", "$ms1, (${rs1}), $rs2"> {
  let Inst = 0xac00002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let isCodeGenOnly = 1;
  let mayStore = 1;
}

def ZTT_MSS_TST : ZTTInst<(outs),
    (ins ZTTMR:$ms1, GPR:$rs1, GPR:$rs2), "mss.tst", "$ms1, (${rs1}), $rs2"> {
  let Inst = 0xae00002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let mayStore = 1;
}

def ZTT_MSS_TST_CG : ZTTInst<(outs),
    (ins ZTTMAny:$ms1, GPR:$rs1, GPR:$rs2), "mss.tst", "$ms1, (${rs1}), $rs2"> {
  let Inst = 0xae00002b;
  bits<5> rs2;
  let Inst{24-20} = rs2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> ms1;
  let Inst{11-7} = ms1;
  let isCodeGenOnly = 1;
  let mayStore = 1;
}

def ZTT_MSUB_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "msub.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUB_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "msub.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x3000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUB_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "msub.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUB_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "msub.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x3200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUBLOG2_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "msublog2.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUBLOG2_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "msublog2.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x8e00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUBLOG2_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "msublog2.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x9000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MSUBLOG2_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "msublog2.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x9000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MTANH_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1), "mtanh.ew", "$md, $ms1"> {
  let Inst = 0xa350002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MTANH_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1), "mtanh.ew", "$md, $ms1"> {
  let Inst = 0xa350002b;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MUNPACK_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "munpack.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x7c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MUNPACK_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "munpack.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x7c00002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MXOR_EW : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, ZTTMR:$ms1, ZTTMR:$ms2), "mxor.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MXOR_EW_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, ZTTMAny:$ms1, ZTTMAny:$ms2), "mxor.ew", "$md, $ms1, $ms2"> {
  let Inst = 0x5000002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> ms1;
  let Inst{19-15} = ms1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MXOR_EW_X : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in, GPR:$rs1, ZTTMR:$ms2), "mxor.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x5200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MXOR_EW_X_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in, GPR:$rs1, ZTTMAny:$ms2), "mxor.ew.x", "$md, $rs1, $ms2"> {
  let Inst = 0x5200002b;
  bits<5> ms2;
  let Inst{24-20} = ms2;
  bits<5> rs1;
  let Inst{19-15} = rs1;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

def ZTT_MZERO_2D_ACC : ZTTInst<(outs ZTTAR:$acc),
    (ins ZTTAR:$acc_in), "mzero.2d.acc", "$acc"> {
  let Inst = 0xa600002b;
  bits<5> acc;
  let Inst{11-7} = acc;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MZERO_2D_ACC_CG : ZTTInst<(outs ZTTAAny:$acc),
    (ins ZTTAAny:$acc_in), "mzero.2d.acc", "$acc"> {
  let Inst = 0xa600002b;
  bits<5> acc;
  let Inst{11-7} = acc;
  let isCodeGenOnly = 1;
  let Constraints = "$acc = $acc_in";
}

def ZTT_MZERO_2D_M : ZTTInst<(outs ZTTMR:$md),
    (ins ZTTMR:$md_in), "mzero.2d.m", "$md"> {
  let Inst = 0xa600802b;
  bits<5> md;
  let Inst{11-7} = md;
  let Constraints = "$md = $md_in";
}

def ZTT_MZERO_2D_M_CG : ZTTInst<(outs ZTTMAny:$md),
    (ins ZTTMAny:$md_in), "mzero.2d.m", "$md"> {
  let Inst = 0xa600802b;
  bits<5> md;
  let Inst{11-7} = md;
  let isCodeGenOnly = 1;
  let Constraints = "$md = $md_in";
}

let Predicates = [HasVendorBoscZtt] in {
  defm Select_ZTTMR : SelectCC_GPR_rrirr<ZTTMR, riscv_ztt_m1>;
  defm Select_ZTTMR2 : SelectCC_GPR_rrirr<ZTTMR2, riscv_ztt_m2>;
  defm Select_ZTTMR4 : SelectCC_GPR_rrirr<ZTTMR4, riscv_ztt_m4>;
  defm Select_ZTTMR8 : SelectCC_GPR_rrirr<ZTTMR8, riscv_ztt_m8>;
  defm Select_ZTTMR16 : SelectCC_GPR_rrirr<ZTTMR16, riscv_ztt_m16>;
  defm Select_ZTTMR32 : SelectCC_GPR_rrirr<ZTTMR32, riscv_ztt_m32>;
  defm Select_ZTTAR : SelectCC_GPR_rrirr<ZTTAR, riscv_ztt_a1>;
  defm Select_ZTTAR2 : SelectCC_GPR_rrirr<ZTTAR2, riscv_ztt_a2>;
  defm Select_ZTTAR4 : SelectCC_GPR_rrirr<ZTTAR4, riscv_ztt_a4>;
  defm Select_ZTTAR8 : SelectCC_GPR_rrirr<ZTTAR8, riscv_ztt_a8>;
}

// Spill slots contain the descriptor followed by the raw register image. ACC
// transfers additionally save two M registers used as temporary storage.
let hasSideEffects = 1, Uses = [ZTT_STATE], Defs = [ZTT_STATE, X5, X6, X7] in {
  let mayStore = 1, mayLoad = 1 in {
    def ZTT_SPILL_M : Pseudo<(outs), (ins ZTTMAny:$src, GPR:$base, simm12:$offset), []>;
    def ZTT_SPILL_A : Pseudo<(outs), (ins ZTTAAny:$src, GPR:$base, simm12:$offset), []>;
    def ZTT_RELOAD_M : Pseudo<(outs ZTTMAny:$dst), (ins GPR:$base, simm12:$offset), []>;
    def ZTT_RELOAD_A : Pseudo<(outs ZTTAAny:$dst), (ins GPR:$base, simm12:$offset), []>;
  }
}
