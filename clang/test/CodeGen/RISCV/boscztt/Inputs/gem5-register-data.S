// Helpers for ame-gem5-register-data.c, RV32 and RV64 with the AME profile.
#if __riscv_xlen == 64
#define REG_S sd
#define REG_L ld
#else
#define REG_S sw
#define REG_L lw
#endif
#define REGBYTES (__riscv_xlen / 8)

.bss
.p2align 3
full_a_pointer: .quad 0
full_b_pointer: .quad 0

.section .text.destroy_all_matrices,"ax",@progbits
.globl destroy_all_matrices
destroy_all_matrices:
  li a0, 32
  .irp N,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    msettyp m\N, a0
  .endr
  .irp N,0,1,2,3
    asettyp acc\N, a0
  .endr
  ret

// Supply two different nonzero full-file values to compiler-generated code.
.text
.globl make_full_a
make_full_a:
  la a0, full_a_pointer
  REG_L a0, 0(a0)
  li a1, 0x40000020
  .irp N,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    msettyp m\N, a1
    mls.1r m\N, a0
    addi a0, a0, 64
  .endr
  ret

.globl make_full_b
make_full_b:
  la a0, full_b_pointer
  REG_L a0, 0(a0)
  li a1, 32
  .irp N,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    msettyp m\N, a1
    mls.1r m\N, a0
    addi a0, a0, 64
  .endr
  ret

// unsigned long check_full_group(a, b, out, condition)
.globl check_full_group
check_full_group:
  addi sp, sp, -(4 * REGBYTES)
  REG_S ra, (3 * REGBYTES)(sp)
  REG_S s0, (2 * REGBYTES)(sp)
  la a4, full_a_pointer
  REG_S a0, 0(a4)
  la a4, full_b_pointer
  REG_S a1, 0(a4)
  mv s0, a2
  mv a0, a3
  call select_full
  .irp N,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    mss.1r m\N, s0
    addi s0, s0, 64
  .endr
  mgettyp a0, m0
  REG_L s0, (2 * REGBYTES)(sp)
  REG_L ra, (3 * REGBYTES)(sp)
  addi sp, sp, (4 * REGBYTES)
  ret
.section .note.GNU-stack,"",@progbits
