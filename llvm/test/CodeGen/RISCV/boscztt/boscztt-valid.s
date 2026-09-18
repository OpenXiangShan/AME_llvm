# RUN: llvm-mc -triple=riscv32 -mattr=+boscztt -show-encoding < %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt -show-encoding < %s | FileCheck %s --check-prefixes=ASM,ENC
# RUN: llvm-mc -triple=riscv64 -mattr=+boscztt -filetype=obj < %s | llvm-objdump -d --mattr=+boscztt - | FileCheck %s --check-prefix=ASM
# RUN: not llvm-mc -triple=riscv64 -show-encoding < %s 2>&1 | FileCheck %s --check-prefix=DISABLED

ame.acquire x3, x4
# ASM: ame.acquire gp, tp
# ENC-SAME: encoding: [0xab,0x01,0x92,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

ame.release
# ASM: ame.release
# ENC-SAME: encoding: [0x2b,0x00,0xa0,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

agettyp x3, acc3
# ASM: agettyp gp, acc3
# ENC-SAME: encoding: [0xab,0x81,0x01,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

asettyp acc3, x4
# ASM: asettyp acc3, tp
# ENC-SAME: encoding: [0xab,0x01,0x12,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mabs.ew m3, m4
# ASM: mabs.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x42,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mabsdiff.ew m3, m4, m6
# ASM: mabsdiff.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x00]
# DISABLED: instruction requires the following: 'boscztt'

mabsdiff.ew.x m3, x4, m6
# ASM: mabsdiff.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x02]
# DISABLED: instruction requires the following: 'boscztt'

madd.ew m3, m4, m6
# ASM: madd.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x04]
# DISABLED: instruction requires the following: 'boscztt'

madd.ew.x m3, x4, m6
# ASM: madd.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x06]
# DISABLED: instruction requires the following: 'boscztt'

mand.ew m3, m4, m6
# ASM: mand.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x34]
# DISABLED: instruction requires the following: 'boscztt'

mand.ew.x m3, x4, m6
# ASM: mand.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x36]
# DISABLED: instruction requires the following: 'boscztt'

mandnot.ew m3, m4, m6
# ASM: mandnot.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x38]
# DISABLED: instruction requires the following: 'boscztt'

mandnot.ew.x m3, x4, m6
# ASM: mandnot.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x3a]
# DISABLED: instruction requires the following: 'boscztt'

mcmovge.ew m3, m4, m6
# ASM: mcmovge.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x54]
# DISABLED: instruction requires the following: 'boscztt'

mcmovlt.ew m3, m4, m6
# ASM: mcmovlt.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x56]
# DISABLED: instruction requires the following: 'boscztt'

mcmpge.ew m3, m4, m6
# ASM: mcmpge.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x58]
# DISABLED: instruction requires the following: 'boscztt'

mcmpge.ew.x m3, x4, m6
# ASM: mcmpge.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x5a]
# DISABLED: instruction requires the following: 'boscztt'

mcmplt.ew m3, m4, m6
# ASM: mcmplt.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x5c]
# DISABLED: instruction requires the following: 'boscztt'

mcmplt.ew.x m3, x4, m6
# ASM: mcmplt.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x5e]
# DISABLED: instruction requires the following: 'boscztt'

mcolbcast.ew.x m3, x4, m6
# ASM: mcolbcast.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x64]
# DISABLED: instruction requires the following: 'boscztt'

mcolgather.ew m3, m4, m6
# ASM: mcolgather.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x66]
# DISABLED: instruction requires the following: 'boscztt'

mcolid.ew m3
# ASM: mcolid.ew m3
# ENC-SAME: encoding: [0xab,0x01,0x01,0xa6]
# DISABLED: instruction requires the following: 'boscztt'

mcolshift.ew.x m3, x4, m6
# ASM: mcolshift.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x68]
# DISABLED: instruction requires the following: 'boscztt'

mcolunzip.ew m4, m6
# ASM: mcolunzip.ew m4, m6
# ENC-SAME: encoding: [0x2b,0x00,0x62,0xc2]
# DISABLED: instruction requires the following: 'boscztt'

mcolzip.ew m4, m6
# ASM: mcolzip.ew m4, m6
# ENC-SAME: encoding: [0x2b,0x00,0x62,0xc4]
# DISABLED: instruction requires the following: 'boscztt'

mconv.ew m3, m4
# ASM: mconv.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0xd2,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mbcast.m.x m3, x4, x6
# ASM: mbcast.m.x m3, tp, t1
# ENC-SAME: encoding: [0xab,0x01,0x62,0xb0]
# DISABLED: instruction requires the following: 'boscztt'

mcos.ew m3, m4
# ASM: mcos.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0xe2,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mexp2.ew m3, m4
# ASM: mexp2.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0xf2,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mfrintm.ew m3, m4
# ASM: mfrintm.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x52,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mfrintn.ew m3, m4
# ASM: mfrintn.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x62,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mfrintp.ew m3, m4
# ASM: mfrintp.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x72,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mfrintz.ew m3, m4
# ASM: mfrintz.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x82,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mgettyp x3, m4
# ASM: mgettyp gp, m4
# ENC-SAME: encoding: [0xab,0x01,0x22,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

mhdiff.ew m3, m4, m6
# ASM: mhdiff.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x08]
# DISABLED: instruction requires the following: 'boscztt'

mhdiff.ew.x m3, x4, m6
# ASM: mhdiff.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x0a]
# DISABLED: instruction requires the following: 'boscztt'

mldexp.ew m3, m4, m6
# ASM: mldexp.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x7e]
# DISABLED: instruction requires the following: 'boscztt'

mldexp.ew.x m3, x4, m6
# ASM: mldexp.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x80]
# DISABLED: instruction requires the following: 'boscztt'

mldexpacc.ew m3, m4, m6
# ASM: mldexpacc.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x82]
# DISABLED: instruction requires the following: 'boscztt'

mldexpacc.ew.x m3, x4, m6
# ASM: mldexpacc.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x84]
# DISABLED: instruction requires the following: 'boscztt'

mlog2.ew m3, m4
# ASM: mlog2.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x02,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mlog2sub.ew m3, m4, m6
# ASM: mlog2sub.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x86]
# DISABLED: instruction requires the following: 'boscztt'

mlog2sub.ew.x m3, x4, m6
# ASM: mlog2sub.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x88]
# DISABLED: instruction requires the following: 'boscztt'

mls.1r m3, x4
# ASM: mls.1r m3, tp
# ENC-SAME: encoding: [0xab,0x01,0x62,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mls.cm m3, x4
# ASM: mls.cm m3, tp
# ENC-SAME: encoding: [0xab,0x01,0x72,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mls.rm m3, x4
# ASM: mls.rm m3, tp
# ENC-SAME: encoding: [0xab,0x01,0x82,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mls.st m3, (x4), x6
# ASM: mls.st m3, (tp), t1
# ENC-SAME: encoding: [0xab,0x01,0x62,0xa8]
# DISABLED: instruction requires the following: 'boscztt'

mls.tst m3, (x4), x6
# ASM: mls.tst m3, (tp), t1
# ENC-SAME: encoding: [0xab,0x01,0x62,0xaa]
# DISABLED: instruction requires the following: 'boscztt'

mmax.ew m3, m4, m6
# ASM: mmax.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x0c]
# DISABLED: instruction requires the following: 'boscztt'

mmax.ew.x m3, x4, m6
# ASM: mmax.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x0e]
# DISABLED: instruction requires the following: 'boscztt'

mmean.ew m3, m4, m6
# ASM: mmean.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x10]
# DISABLED: instruction requires the following: 'boscztt'

mmean.ew.x m3, x4, m6
# ASM: mmean.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x12]
# DISABLED: instruction requires the following: 'boscztt'

mmin.ew m3, m4, m6
# ASM: mmin.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x14]
# DISABLED: instruction requires the following: 'boscztt'

mmin.ew.x m3, x4, m6
# ASM: mmin.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x16]
# DISABLED: instruction requires the following: 'boscztt'

mmov.m.a m3, acc3
# ASM: mmov.m.a m3, acc3
# ENC-SAME: encoding: [0xab,0x81,0xc1,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mmov.a.m acc3, m4
# ASM: mmov.a.m acc3, m4
# ENC-SAME: encoding: [0xab,0x01,0xd2,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mmov.m.m m3, m4
# ASM: mmov.m.m m3, m4
# ENC-SAME: encoding: [0xab,0x01,0xe2,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mmove8.m.x m3, x6, x4
# ASM: mmove8.m.x m3, t1, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xb2]
# DISABLED: instruction requires the following: 'boscztt'

mmove16.m.x m3, x6, x4
# ASM: mmove16.m.x m3, t1, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xb4]
# DISABLED: instruction requires the following: 'boscztt'

mmove32.m.x m3, x6, x4
# ASM: mmove32.m.x m3, t1, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xb6]
# DISABLED: instruction requires the following: 'boscztt'

mmove64.m.x m3, x6, x4
# ASM: mmove64.m.x m3, t1, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xb8]
# DISABLED: instruction requires the following: 'boscztt'

mmove8.x.m x3, m6, x4
# ASM: mmove8.x.m gp, m6, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xba]
# DISABLED: instruction requires the following: 'boscztt'

mmove16.x.m x3, m6, x4
# ASM: mmove16.x.m gp, m6, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xbc]
# DISABLED: instruction requires the following: 'boscztt'

mmove32.x.m x3, m6, x4
# ASM: mmove32.x.m gp, m6, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xbe]
# DISABLED: instruction requires the following: 'boscztt'

mmove64.x.m x3, m6, x4
# ASM: mmove64.x.m gp, m6, tp
# ENC-SAME: encoding: [0xab,0x01,0x43,0xc0]
# DISABLED: instruction requires the following: 'boscztt'

mmul.ew m3, m4, m6
# ASM: mmul.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x18]
# DISABLED: instruction requires the following: 'boscztt'

mmul.ew.x m3, x4, m6
# ASM: mmul.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x1a]
# DISABLED: instruction requires the following: 'boscztt'

mmulacc.2d acc3, m4, m6
# ASM: mmulacc.2d acc3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x94]
# DISABLED: instruction requires the following: 'boscztt'

mmulacc.ew m3, m4, m6
# ASM: mmulacc.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x1c]
# DISABLED: instruction requires the following: 'boscztt'

mmulacc.ew.x m3, x4, m6
# ASM: mmulacc.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x1e]
# DISABLED: instruction requires the following: 'boscztt'

mmulaccneg.2d acc3, m4, m6
# ASM: mmulaccneg.2d acc3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x96]
# DISABLED: instruction requires the following: 'boscztt'

mmulaccneg.ew m3, m4, m6
# ASM: mmulaccneg.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x20]
# DISABLED: instruction requires the following: 'boscztt'

mmulaccneg.ew.x m3, x4, m6
# ASM: mmulaccneg.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x22]
# DISABLED: instruction requires the following: 'boscztt'

mmuladd.ew m3, m4, m6
# ASM: mmuladd.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x24]
# DISABLED: instruction requires the following: 'boscztt'

mmuladd.ew.x m3, x4, m6
# ASM: mmuladd.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x26]
# DISABLED: instruction requires the following: 'boscztt'

mmulatacc.2d acc3, m4, m6
# ASM: mmulatacc.2d acc3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x9a]
# DISABLED: instruction requires the following: 'boscztt'

mmulataccneg.2d acc3, m4, m6
# ASM: mmulataccneg.2d acc3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x9c]
# DISABLED: instruction requires the following: 'boscztt'

mmulbtacc.2d acc3, m4, m6
# ASM: mmulbtacc.2d acc3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x9e]
# DISABLED: instruction requires the following: 'boscztt'

mmulbtaccneg.2d acc3, m4, m6
# ASM: mmulbtaccneg.2d acc3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0xa0]
# DISABLED: instruction requires the following: 'boscztt'

mmulneg.ew m3, m4, m6
# ASM: mmulneg.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x28]
# DISABLED: instruction requires the following: 'boscztt'

mmulneg.ew.x m3, x4, m6
# ASM: mmulneg.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x2a]
# DISABLED: instruction requires the following: 'boscztt'

mmulsub.ew m3, m4, m6
# ASM: mmulsub.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x2c]
# DISABLED: instruction requires the following: 'boscztt'

mmulsub.ew.x m3, x4, m6
# ASM: mmulsub.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x2e]
# DISABLED: instruction requires the following: 'boscztt'

mor.ew m3, m4, m6
# ASM: mor.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x3c]
# DISABLED: instruction requires the following: 'boscztt'

mor.ew.x m3, x4, m6
# ASM: mor.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x3e]
# DISABLED: instruction requires the following: 'boscztt'

mornot.ew m3, m4, m6
# ASM: mornot.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x40]
# DISABLED: instruction requires the following: 'boscztt'

mornot.ew.x m3, x4, m6
# ASM: mornot.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x42]
# DISABLED: instruction requires the following: 'boscztt'

mpack.ew.x m3, x4, m6
# ASM: mpack.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x7a]
# DISABLED: instruction requires the following: 'boscztt'

mprefixadd.col m3, m4
# ASM: mprefixadd.col m3, m4
# ENC-SAME: encoding: [0xab,0x01,0xf2,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mprefixadd.row m3, m4
# ASM: mprefixadd.row m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x02,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mprefixmax.col m3, m4
# ASM: mprefixmax.col m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x12,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mprefixmax.row m3, m4
# ASM: mprefixmax.row m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x22,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mrdexp.ew m3, m4, m6
# ASM: mrdexp.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x8a]
# DISABLED: instruction requires the following: 'boscztt'

mrdexpacc.ew m3, m4, m6
# ASM: mrdexpacc.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x8c]
# DISABLED: instruction requires the following: 'boscztt'

mrec.ew m3, m4
# ASM: mrec.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x12,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mreduceadd.col m3, m4
# ASM: mreduceadd.col m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x32,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mreduceadd.row m3, m4
# ASM: mreduceadd.row m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x42,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mreducemax.col m3, m4
# ASM: mreducemax.col m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x52,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mreducemax.row m3, m4
# ASM: mreducemax.row m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x62,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mreducemin.col m3, m4
# ASM: mreducemin.col m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x72,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mreducemin.row m3, m4
# ASM: mreducemin.row m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x82,0xa4]
# DISABLED: instruction requires the following: 'boscztt'

mrowbcast.ew.x m3, x4, m6
# ASM: mrowbcast.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x6a]
# DISABLED: instruction requires the following: 'boscztt'

mrowgather.ew m3, m4, m6
# ASM: mrowgather.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x6c]
# DISABLED: instruction requires the following: 'boscztt'

mrowid.ew m3
# ASM: mrowid.ew m3
# ENC-SAME: encoding: [0xab,0x81,0x01,0xa6]
# DISABLED: instruction requires the following: 'boscztt'

mrowshift.ew.x m3, x4, m6
# ASM: mrowshift.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x6e]
# DISABLED: instruction requires the following: 'boscztt'

mrowunzip.ew m4, m6
# ASM: mrowunzip.ew m4, m6
# ENC-SAME: encoding: [0x2b,0x00,0x62,0xc6]
# DISABLED: instruction requires the following: 'boscztt'

mrowzip.ew m4, m6
# ASM: mrowzip.ew m4, m6
# ENC-SAME: encoding: [0x2b,0x00,0x62,0x70]
# DISABLED: instruction requires the following: 'boscztt'

mrsqrt.ew m3, m4
# ASM: mrsqrt.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x22,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mrowscatadd.ew m3, m4, m6
# ASM: mrowscatadd.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x72]
# DISABLED: instruction requires the following: 'boscztt'

mcolscatadd.ew m3, m4, m6
# ASM: mcolscatadd.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x74]
# DISABLED: instruction requires the following: 'boscztt'

mrowscatmax.ew m3, m4, m6
# ASM: mrowscatmax.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x76]
# DISABLED: instruction requires the following: 'boscztt'

mcolscatmax.ew m3, m4, m6
# ASM: mcolscatmax.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x78]
# DISABLED: instruction requires the following: 'boscztt'

mselge.ew m3, m4, m6
# ASM: mselge.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x60]
# DISABLED: instruction requires the following: 'boscztt'

msellt.ew m3, m4, m6
# ASM: msellt.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x62]
# DISABLED: instruction requires the following: 'boscztt'

msettyp m3, x4
# ASM: msettyp m3, tp
# ENC-SAME: encoding: [0xab,0x01,0x32,0xa2]
# DISABLED: instruction requires the following: 'boscztt'

msin.ew m3, m4
# ASM: msin.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x32,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

msll.ew m3, m4, m6
# ASM: msll.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x44]
# DISABLED: instruction requires the following: 'boscztt'

msll.ew.x m3, x4, m6
# ASM: msll.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x46]
# DISABLED: instruction requires the following: 'boscztt'

msqrt.ew m3, m4
# ASM: msqrt.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x42,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

msra.ew m3, m4, m6
# ASM: msra.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x48]
# DISABLED: instruction requires the following: 'boscztt'

msra.ew.x m3, x4, m6
# ASM: msra.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x4a]
# DISABLED: instruction requires the following: 'boscztt'

msrl.ew m3, m4, m6
# ASM: msrl.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x4c]
# DISABLED: instruction requires the following: 'boscztt'

msrl.ew.x m3, x4, m6
# ASM: msrl.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x4e]
# DISABLED: instruction requires the following: 'boscztt'

mss.1r m4, x4
# ASM: mss.1r m4, tp
# ENC-SAME: encoding: [0x2b,0x02,0x92,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mss.cm m4, x4
# ASM: mss.cm m4, tp
# ENC-SAME: encoding: [0x2b,0x02,0xa2,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mss.rm m4, x4
# ASM: mss.rm m4, tp
# ENC-SAME: encoding: [0x2b,0x02,0xb2,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

mss.st m4, (x4), x6
# ASM: mss.st m4, (tp), t1
# ENC-SAME: encoding: [0x2b,0x02,0x62,0xac]
# DISABLED: instruction requires the following: 'boscztt'

mss.tst m4, (x4), x6
# ASM: mss.tst m4, (tp), t1
# ENC-SAME: encoding: [0x2b,0x02,0x62,0xae]
# DISABLED: instruction requires the following: 'boscztt'

msub.ew m3, m4, m6
# ASM: msub.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x30]
# DISABLED: instruction requires the following: 'boscztt'

msub.ew.x m3, x4, m6
# ASM: msub.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x32]
# DISABLED: instruction requires the following: 'boscztt'

msublog2.ew m3, m4, m6
# ASM: msublog2.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x8e]
# DISABLED: instruction requires the following: 'boscztt'

msublog2.ew.x m3, x4, m6
# ASM: msublog2.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x90]
# DISABLED: instruction requires the following: 'boscztt'

mtanh.ew m3, m4
# ASM: mtanh.ew m3, m4
# ENC-SAME: encoding: [0xab,0x01,0x52,0xa3]
# DISABLED: instruction requires the following: 'boscztt'

munpack.ew.x m3, x4, m6
# ASM: munpack.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x7c]
# DISABLED: instruction requires the following: 'boscztt'

mxor.ew m3, m4, m6
# ASM: mxor.ew m3, m4, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x50]
# DISABLED: instruction requires the following: 'boscztt'

mxor.ew.x m3, x4, m6
# ASM: mxor.ew.x m3, tp, m6
# ENC-SAME: encoding: [0xab,0x01,0x62,0x52]
# DISABLED: instruction requires the following: 'boscztt'

mzero.2d.acc acc3
# ASM: mzero.2d.acc acc3
# ENC-SAME: encoding: [0xab,0x01,0x00,0xa6]
# DISABLED: instruction requires the following: 'boscztt'

mzero.2d.m m3
# ASM: mzero.2d.m m3
# ENC-SAME: encoding: [0xab,0x81,0x00,0xa6]
# DISABLED: instruction requires the following: 'boscztt'
