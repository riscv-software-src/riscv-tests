#include "encoding.h"

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
  li a0, SR_U64 | SR_S64
  csrs status, a0
#endif

  # enable fp and accelerator
  li a0, SR_EF | SR_EA
  csrs status, a0

  ## if that didn't stick, we don't have an FPU, so don't initialize it
  csrr t0, status
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

  la t0, trap_entry
  csrw evec, t0

  la  tp, _end + 63
  and tp, tp, -64

  # get core id and number of cores
  csrr a0, hartid
  lw a1, 4(zero)

  # give each core a 1KB TLS and a 127KB stack
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp
  add tp, tp, 1024

  jal _init
  unimp

trap_entry:
  csrw sup0, t0
  csrw sup1, t1
  la t0, uarch_insn
  lw t0, (t0)
  csrr t1, epc
  and t1, t1, ~3
  lw t1, (t1)
  and t1, t1, t0
  beq t1, t0, handle_uarch_insn

  # a trap occurred that shouldn't have.
  li t0, 1337
  csrw tohost, t0
1:j 1b

handle_uarch_insn:
  # we trapped on an illegal uarch-specific CSR.  just skip over it.
  csrr t1, epc
  add t1, t1, 4
  csrw epc, t1
  csrr t0, sup0
  csrr t1, sup1
  sret

uarch_insn:
  csrr x0, uarch0
