#include "riscv_test.h"

#ifdef __riscv64
# define STORE    sd
# define LOAD     ld
# define REGBYTES 8
#else
# define STORE    sw
# define LOAD     lw
# define REGBYTES 4
#endif

#define STACK_TOP (_end + 131072)

  .text
  .global _start
_start:
  la sp, STACK_TOP
  li a1, 1337
  la a0, userstart
  j vm_boot

save_tf:  # write the trap frame onto the stack

  # save gprs
  STORE  x3,3*REGBYTES(x2)
  STORE  x4,4*REGBYTES(x2)
  STORE  x5,5*REGBYTES(x2)
  STORE  x6,6*REGBYTES(x2)
  STORE  x7,7*REGBYTES(x2)
  STORE  x8,8*REGBYTES(x2)
  STORE  x9,9*REGBYTES(x2)
  STORE  x10,10*REGBYTES(x2)
  STORE  x11,11*REGBYTES(x2)
  STORE  x12,12*REGBYTES(x2)
  STORE  x13,13*REGBYTES(x2)
  STORE  x14,14*REGBYTES(x2)
  STORE  x15,15*REGBYTES(x2)
  STORE  x16,16*REGBYTES(x2)
  STORE  x17,17*REGBYTES(x2)
  STORE  x18,18*REGBYTES(x2)
  STORE  x19,19*REGBYTES(x2)
  STORE  x20,20*REGBYTES(x2)
  STORE  x21,21*REGBYTES(x2)
  STORE  x22,22*REGBYTES(x2)
  STORE  x23,23*REGBYTES(x2)
  STORE  x24,24*REGBYTES(x2)
  STORE  x25,25*REGBYTES(x2)
  STORE  x26,26*REGBYTES(x2)
  STORE  x27,27*REGBYTES(x2)
  STORE  x28,28*REGBYTES(x2)
  STORE  x29,29*REGBYTES(x2)
  STORE  x30,30*REGBYTES(x2)
  STORE  x31,31*REGBYTES(x2)

  csrr   x3,sup0
  STORE  x3,1*REGBYTES(x2)          # x1 is in PCR_K0
  csrr   x3,sup1
  STORE  x3,2*REGBYTES(x2)          # x2 is in PCR_K1

  # get sr, epc, badvaddr, cause
  csrr   x3,status          # sr
  STORE  x3,32*REGBYTES(x2)
  csrr   x4,epc          # epc
  STORE  x4,33*REGBYTES(x2)
  csrr   x3,badvaddr      # badvaddr
  STORE  x3,34*REGBYTES(x2)
  csrr   x3,cause        # cause
  STORE  x3,35*REGBYTES(x2)

  # get hwacha cause if IRQ_COP
  # vxcptcause clears hwacha interrupt bit

  bge   x3,x0,1f
  slli  x3,x3,1 # clearing MSB of cause
  srli  x3,x3,1 # clearing MSB of cause
  li    x4,IRQ_COP
  bne   x3,x4,1f
  vxcptcause x3
  STORE  x3,36*REGBYTES(x2)
1:

  ret

  .globl  pop_tf
pop_tf:  # write the trap frame onto the stack
  # restore gprs
  LOAD  a1,32*REGBYTES(a0)  # restore sr (should disable interrupts)
  csrw  status,a1

  LOAD  x1,1*REGBYTES(a0)
  LOAD  x2,2*REGBYTES(a0)
  csrw  sup0,x1
  csrw  sup1,x2
  move  x1,a0
  LOAD  x3,3*REGBYTES(x1)
  LOAD  x4,4*REGBYTES(x1)
  LOAD  x5,5*REGBYTES(x1)
  LOAD  x6,6*REGBYTES(x1)
  LOAD  x7,7*REGBYTES(x1)
  LOAD  x8,8*REGBYTES(x1)
  LOAD  x9,9*REGBYTES(x1)
  LOAD  x10,10*REGBYTES(x1)
  LOAD  x11,11*REGBYTES(x1)
  LOAD  x12,12*REGBYTES(x1)
  LOAD  x13,13*REGBYTES(x1)
  LOAD  x14,14*REGBYTES(x1)
  LOAD  x15,15*REGBYTES(x1)
  LOAD  x16,16*REGBYTES(x1)
  LOAD  x17,17*REGBYTES(x1)
  LOAD  x18,18*REGBYTES(x1)
  LOAD  x19,19*REGBYTES(x1)
  LOAD  x20,20*REGBYTES(x1)
  LOAD  x21,21*REGBYTES(x1)
  LOAD  x22,22*REGBYTES(x1)
  LOAD  x23,23*REGBYTES(x1)
  LOAD  x24,24*REGBYTES(x1)
  LOAD  x25,25*REGBYTES(x1)
  LOAD  x26,26*REGBYTES(x1)
  LOAD  x27,27*REGBYTES(x1)
  LOAD  x28,28*REGBYTES(x1)
  LOAD  x29,29*REGBYTES(x1)
  LOAD  x30,30*REGBYTES(x1)
  LOAD  x31,31*REGBYTES(x1)

  # gtfo!
  LOAD  x2,33*REGBYTES(x1)
  csrw  epc,x2
  csrr  x1,sup0
  csrr  x2,sup1
  sret

  .global  trap_entry
trap_entry:
  csrw sup0,ra
  csrw sup1,x2

  # coming from kernel?
  csrr  ra,status
  and   ra,ra,SR_PS
  bnez  ra, 1f

  # no, so start at the top of the stack
  la    x2,STACK_TOP-SIZEOF_TRAPFRAME_T
  jal   save_tf
  move  sp,x2
  csrs  status,SR_EI
  move  a0,x2
  csrr  ra,status
  and   ra,ra,SR_EA
  beqz  ra,2f
  addi  x2,x2,37*REGBYTES

  # rocket currently doesn't support vxcptsave/vxcptrestore natively
  csrr  x3,impl 
  li    x4,IMPL_ROCKET
  bne   x3,x4,3f
  vgetcfg x4
  STORE x4,0*REGBYTES(x2)
  vgetvl x4
  STORE x4,1*REGBYTES(x2)
  addi  x2,x2,2*REGBYTES
  vxcptevac x2
  j     2f

  # native vxcptsave
3:vxcptsave x2
2:jal   handle_trap

  # when coming from kernel, continue below its stack
  # we assume vector unit wasn't used in kernel
1:li    x2,SIZEOF_TRAPFRAME_T_SCALAR
  sub   x2,sp,x2
  jal   save_tf
  move  sp,x2
  csrs  status,SR_EI
  move  a0,x2
  jal   handle_trap
  unimp
