# See LICENSE for license details.

#*****************************************************************************
# illegal.S
#-----------------------------------------------------------------------------
#
# Test illegal instruction trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  li TESTNUM, 2
bad2:
  .word 0
  j fail

  # Skip the rest of the test if S-mode is not present.
  li t0, MSTATUS_MPIE
  csrc mstatus, t0
  li t0, MSTATUS_MPP
  csrc mstatus, t0
  li t1, (MSTATUS_MPP & ~(MSTATUS_MPP << 1)) * PRV_S
  csrs mstatus, t1
  csrr t2, mstatus
  and t2, t2, t0
  bne t1, t2, pass

  # Set a software interrupt pending so WFI won't stall.
  csrwi mideleg, MIP_SSIP
  csrwi mip, MIP_SSIP
  csrwi mie, MIP_SSIP
  la t0, 1f
  csrw mepc, t0
  mret

1:
  # Make sure WFI doesn't trap when TW=0.
  wfi
bad3:
  .word 0
  j fail

bad4:
  # Make sure WFI does trap when TW=1.
  wfi
  j fail

  # Make sure SFENCE.VMA and sptbr don't trap when TVM=0.
  sfence.vma
  csrr t0, sptbr
bad5:
  .word 0
  j fail

bad6:
  # Make sure SFENCE.VMA and sptbr do trap when TVM=1.
  sfence.vma
  j fail
bad7:
  csrr t0, sptbr
  j fail

  # Make sure SRET doesn't trap when TSR=0.
  la t0, bad8
  csrw sepc, t0
  li t0, SSTATUS_SPP
  csrs sstatus, t0
  li t0, SSTATUS_SPIE
  csrc sstatus, t0
  sret
bad8:
  .word 0
  j fail

  # Make sure SRET does trap when TSR=1.
  la t0, 1f
  csrw sepc, t0
bad9:
  sret
1:
  j fail

  TEST_PASSFAIL

mtvec_handler:
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  csrr t0, mcause
  bne t0, t1, fail
  csrr t0, mepc
  la t1, bad2
  beq t0, t1, 2f
  la t1, bad3
  beq t0, t1, 3f
  la t1, bad4
  beq t0, t1, 4f
  la t1, bad5
  beq t0, t1, 5f
  la t1, bad6
  beq t0, t1, 6f
  la t1, bad7
  beq t0, t1, 7f
  la t1, bad8
  beq t0, t1, 8f
  la t1, bad9
  beq t0, t1, 9f
  j fail
2:
4:
6:
7:
  addi t0, t0, 8
  csrw mepc, t0
  mret

3:
  li t1, MSTATUS_TW
  csrs mstatus, t1
  j 2b

5:
  li t1, MSTATUS_TVM
  csrs mstatus, t1
  j 2b

8:
  li t1, MSTATUS_TSR
  csrs mstatus, t1
  j 2b

9:
  j pass

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
