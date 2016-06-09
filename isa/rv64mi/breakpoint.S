# See LICENSE for license details.

#*****************************************************************************
# breakpoint.S
#-----------------------------------------------------------------------------
#
# Test breakpoints, if they are implemented.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # Set up breakpoint to trap on M-mode fetches.
  li TESTNUM, 2
  csrw tdrselect, x0
  la t2, 1f
  csrw tdrdata2, t2
  li t0, (BPCONTROL_MATCHCOND & (BPCONTROL_MATCHCOND>>1)) | BPCONTROL_M | BPCONTROL_X
  csrw tdrdata1, t0
  # Skip if breakpoint type is unsupported.
  csrr t1, tdrdata1
  bne t0, t1, 2f
1:
  # Trap handler should skip this instruction.
  j fail

  # Make sure reads don't trap.
  li TESTNUM, 3
  lw t0, (t2)

2:
  # Set up breakpoint to trap on M-mode reads.
  li TESTNUM, 4
  li t0, (BPCONTROL_MATCHCOND & (BPCONTROL_MATCHCOND>>1)) | BPCONTROL_M | BPCONTROL_R
  csrw tdrdata1, t0
  # Skip if breakpoint type is unsupported.
  csrr t1, tdrdata1
  bne t0, t1, 2f
  la t2, write_data
  csrw tdrdata2, t2

  # Trap handler should skip this instruction.
  lw t2, (t2)
  beqz t2, fail

  # Make sure writes don't trap.
  li TESTNUM, 5
  sw x0, (t2)

2:
  # Set up breakpoint to trap on M-mode stores.
  li TESTNUM, 6
  li t0, (BPCONTROL_MATCHCOND & (BPCONTROL_MATCHCOND>>1)) | BPCONTROL_M | BPCONTROL_W
  csrw tdrdata1, t0
  # Skip if breakpoint type is unsupported.
  csrr t1, tdrdata1
  bne t0, t1, 2f

  # Trap handler should skip this instruction.
  sw t2, (t2)

  # Make sure store didn't succeed.
  li TESTNUM, 7
  lw t2, (t2)
  bnez t2, fail

2:
  TEST_PASSFAIL

mtvec_handler:
  # Only even-numbered tests should trap.
  andi a0, TESTNUM, 1
  bnez a0, fail

  li a0, CAUSE_BREAKPOINT
  csrr a1, mcause
  bne a0, a1, fail

  csrr a0, mepc
  addi a0, a0, 4
  csrw mepc, a0
  mret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

write_data: .word 0

RVTEST_DATA_END
