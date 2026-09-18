// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// One intrinsic per Ztt v0.6 mnemonic. Matrix destination operands are
// explicit passthrough values: their descriptors (and data on unsupported
// tuples) survive an instruction. All operations access ordered AME state.

// These overload constraints accept only the corresponding target extension
// type. Element types, dimensions and register groups are checked by
// TargetExtType; relationships between operands are checked by the verifier.
def llvm_any_ztt_matrix_ty : LLVMAnyType<Any,
    AnyKindVectorConstraint.Scalar, AnyKindElementConstraint.RISCVZttMatrix>;
def llvm_any_ztt_acc_ty : LLVMAnyType<Any,
    AnyKindVectorConstraint.Scalar,
    AnyKindElementConstraint.RISCVZttAccumulator>;

let TargetPrefix = "riscv", TargetFeatures = "boscztt" in {
  def int_riscv_ztt_ame_acquire : Intrinsic<
      [llvm_anyint_ty], [LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_ame_release : Intrinsic<
      [], [],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_agettyp : Intrinsic<
      [llvm_anyint_ty], [llvm_any_ztt_acc_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_asettyp : Intrinsic<
      [llvm_any_ztt_acc_ty], [LLVMMatchType<0>, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mabs_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mabsdiff_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mabsdiff_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_madd_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_madd_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mand_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mand_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mandnot_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mandnot_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcmovge_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcmovlt_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcmpge_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcmpge_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcmplt_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcmplt_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolbcast_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolgather_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolid_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolshift_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolunzip_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [LLVMMatchType<0>, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolzip_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [LLVMMatchType<0>, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mconv_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mbcast_m_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcos_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mexp2_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mfrintm_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mfrintn_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mfrintp_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mfrintz_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mgettyp : Intrinsic<
      [llvm_anyint_ty], [llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mhdiff_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mhdiff_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mldexp_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mldexp_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mldexpacc_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mldexpacc_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mlog2_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mlog2sub_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mlog2sub_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mls_1r : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_ptr_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mls_cm : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_ptr_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mls_rm : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_ptr_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mls_st : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_ptr_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mls_tst : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_ptr_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmax_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmax_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmean_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmean_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmin_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmin_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmov_m_a : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_acc_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmov_a_m : Intrinsic<
      [llvm_any_ztt_acc_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmov_m_m : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove8_m_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove16_m_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove32_m_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove64_m_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove8_x_m : Intrinsic<
      [llvm_anyint_ty], [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove16_x_m : Intrinsic<
      [llvm_anyint_ty], [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove32_x_m : Intrinsic<
      [llvm_anyint_ty], [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmove64_x_m : Intrinsic<
      [llvm_anyint_ty], [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmul_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmul_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulacc_2d : Intrinsic<
      [llvm_any_ztt_acc_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulacc_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulacc_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulaccneg_2d : Intrinsic<
      [llvm_any_ztt_acc_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulaccneg_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulaccneg_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmuladd_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmuladd_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulatacc_2d : Intrinsic<
      [llvm_any_ztt_acc_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulataccneg_2d : Intrinsic<
      [llvm_any_ztt_acc_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulbtacc_2d : Intrinsic<
      [llvm_any_ztt_acc_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulbtaccneg_2d : Intrinsic<
      [llvm_any_ztt_acc_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulneg_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulneg_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulsub_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mmulsub_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mor_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mor_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mornot_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mornot_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mpack_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mprefixadd_col : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mprefixadd_row : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mprefixmax_col : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mprefixmax_row : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrdexp_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrdexpacc_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrec_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mreduceadd_col : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mreduceadd_row : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mreducemax_col : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mreducemax_row : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mreducemin_col : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mreducemin_row : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowbcast_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowgather_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowid_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowshift_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowunzip_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [LLVMMatchType<0>, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowzip_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty, LLVMMatchType<0>],
      [LLVMMatchType<0>, LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrsqrt_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowscatadd_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolscatadd_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mrowscatmax_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mcolscatmax_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mselge_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msellt_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msettyp : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msin_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msll_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msll_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msqrt_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msra_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msra_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msrl_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msrl_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mss_1r : Intrinsic<
      [], [llvm_any_ztt_matrix_ty, llvm_ptr_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mss_cm : Intrinsic<
      [], [llvm_any_ztt_matrix_ty, llvm_ptr_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mss_rm : Intrinsic<
      [], [llvm_any_ztt_matrix_ty, llvm_ptr_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mss_st : Intrinsic<
      [], [llvm_any_ztt_matrix_ty, llvm_ptr_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mss_tst : Intrinsic<
      [], [llvm_any_ztt_matrix_ty, llvm_ptr_ty, llvm_anyint_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msub_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msub_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msublog2_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_msublog2_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mtanh_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_munpack_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mxor_ew : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_any_ztt_matrix_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mxor_ew_x : Intrinsic<
      [llvm_any_ztt_matrix_ty],
      [LLVMMatchType<0>, llvm_anyint_ty, llvm_any_ztt_matrix_ty],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mzero_2d_acc : Intrinsic<
      [llvm_any_ztt_acc_ty], [LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
  def int_riscv_ztt_mzero_2d_m : Intrinsic<
      [llvm_any_ztt_matrix_ty], [LLVMMatchType<0>],
      [IntrConvergent, IntrNoCallback, IntrNoFree, IntrHasSideEffects]>;
}
