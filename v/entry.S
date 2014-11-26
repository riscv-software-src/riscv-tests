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
  STORE  x3,1*REGBYTES(x2)          # x1 is in sup0
  csrr   x3,sup1
  STORE  x3,2*REGBYTES(x2)          # x2 is in sup1

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

  jr x1

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
  csrw sup0,x1
  csrw sup1,x2

  # coming from kernel?
  csrr  x1,status
  and   x1,x1,SR_PS
  bnez  x1, 1f

  # no, so start at the top of the stack
  la    x2,STACK_TOP-SIZEOF_TRAPFRAME_T
  jal   x1, save_tf
  move  sp,x2
  csrs  status,SR_EI
  move  a0,sp
  csrr  t0,status
  and   t0,t0,SR_EA
  beqz  t0,2f
  addi  t0,sp,SIZEOF_TRAPFRAME_T_SCALAR

  # rocket currently doesn't support vxcptsave/vxcptrestore natively
  csrr  x3,impl 
  li    x4,IMPL_ROCKET
  bne   x3,x4,3f
  vgetcfg x4
  STORE x4,0*REGBYTES(t0)
  vgetvl x4
  STORE x4,1*REGBYTES(t0)
  addi  t0,t0,2*REGBYTES
  vxcptevac t0
  j     2f

  # native vxcptsave
3:vxcptsave t0
2:jal   handle_trap

  # when coming from kernel, continue below its stack
  # we assume vector unit wasn't used in kernel
1:addi  x2,sp,-SIZEOF_TRAPFRAME_T_SCALAR
  jal   x1, save_tf
  move  sp,x2
  csrs  status,SR_EI
  move  a0,sp
  jal   handle_trap
  unimp
