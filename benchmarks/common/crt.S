#include "pcr.h"

  .data
  .globl _heapend
  .globl environ
_heapend:
  .word 0
environ:
  .word 0

  .text
  .globl _start

_start:
  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0

#ifdef __riscv64
  setpcr status, SR_S64
  setpcr status, SR_U64
#endif

  # enable fp
  setpcr status, SR_EF

  # enable vec
  setpcr t0, status, SR_EV

  ## if that didn't stick, we don't have an FPU, so don't initialize it
  and t0, t0, SR_EF
  beqz t0, 1f

  fssr    x0
  fmv.s.x f0, x0
  fmv.s.x f1, x0
  fmv.s.x f2, x0
  fmv.s.x f3, x0
  fmv.s.x f4, x0
  fmv.s.x f5, x0
  fmv.s.x f6, x0
  fmv.s.x f7, x0
  fmv.s.x f8, x0
  fmv.s.x f9, x0
  fmv.s.x f10,x0
  fmv.s.x f11,x0
  fmv.s.x f12,x0
  fmv.s.x f13,x0
  fmv.s.x f14,x0
  fmv.s.x f15,x0
  fmv.s.x f16,x0
  fmv.s.x f17,x0
  fmv.s.x f18,x0
  fmv.s.x f19,x0
  fmv.s.x f20,x0
  fmv.s.x f21,x0
  fmv.s.x f22,x0
  fmv.s.x f23,x0
  fmv.s.x f24,x0
  fmv.s.x f25,x0
  fmv.s.x f26,x0
  fmv.s.x f27,x0
  fmv.s.x f28,x0
  fmv.s.x f29,x0
  fmv.s.x f30,x0
  fmv.s.x f31,x0
1:

  lui a0, %hi(trap_entry)    
  add a0, a0, %lo(trap_entry)
  mtpcr a0, evec

  lui a0, %hi(main)    
  add a0, a0, %lo(main)
  mtpcr a0, epc

  # only allow core 0 to proceed
1:mfpcr a0, hartid
  bnez a0, 1b

  la  sp,stacktop
  
  # jmp to main as a user program
  eret 
1:b 1b

.align 4
.globl trap_entry
trap_entry:                # only check for SYS_exit, otherwise crash out
  li a3, 1337              # magic "bad things" happened error code
  mfpcr a1, cause
  li a2, 6                 # syscall exception number
  bne a1, a2, exit_error
handle_syscall:
  li a1, 93                # SYS_exit number
  bne v0, a1, exit_error
  li a1, 1                 # successful exit code
  move a3, a0
  bne a3, a1, exit_error
  mtpcr a1, tohost         # exit successfully (tohost == 1)
1:b 1b
exit_error:
  sll a3, a3, 1
  or  a3, a3, 1
  mtpcr a3, tohost
1:b 1b

  .bss
  .globl stacktop

  .align 4
  .skip 131072
stacktop:
