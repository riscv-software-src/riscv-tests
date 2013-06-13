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

  # enable fp
  mfpcr  x1,cr0
  ori  x1,x1,0x2
  mtpcr  x1,cr0

  # enable vec
  mfpcr  x1,cr0
  ori  x1,x1,0x4
  mtpcr  x1,cr0

  ## if that didn't stick, we don't have an FPU, so don't initialize it
  mfpcr x1,cr0
  andi x1,x1,0x2
  beqz x1,1f

  mtfsr   x0
  mxtf.s  f0, x0
  mxtf.s  f1, x0
  mxtf.s  f2, x0
  mxtf.s  f3, x0
  mxtf.s  f4, x0
  mxtf.s  f5, x0
  mxtf.s  f6, x0
  mxtf.s  f7, x0
  mxtf.s  f8, x0
  mxtf.s  f9, x0
  mxtf.s  f10,x0
  mxtf.s  f11,x0
  mxtf.s  f12,x0
  mxtf.s  f13,x0
  mxtf.s  f14,x0
  mxtf.s  f15,x0
  mxtf.s  f16,x0
  mxtf.s  f17,x0
  mxtf.s  f18,x0
  mxtf.s  f19,x0
  mxtf.s  f20,x0
  mxtf.s  f21,x0
  mxtf.s  f22,x0
  mxtf.s  f23,x0
  mxtf.s  f24,x0
  mxtf.s  f25,x0
  mxtf.s  f26,x0
  mxtf.s  f27,x0
  mxtf.s  f28,x0
  mxtf.s  f29,x0
  mxtf.s  f30,x0
  mxtf.s  f31,x0
1:

  # only allow core 0 to proceed
1:mfpcr a0, cr10
  bnez a0, 1b

  la  sp,stacktop
  jal main
1:b 1b

  .bss
  .globl stacktop

  .align 4
  .skip 131072
stacktop:
