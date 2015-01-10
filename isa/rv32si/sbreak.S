# See LICENSE for license details.

#*****************************************************************************
# scall.S
#-----------------------------------------------------------------------------
#
# Test syscall trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  la t0, evec
  csrw evec, t0

  li TESTNUM, 2
  sbreak
  j fail

  j pass

  TEST_PASSFAIL

evec:
  li t1, CAUSE_BREAKPOINT
  csrr t0, cause
  bne t0, t1, fail
  csrr t0, epc
  addi t0, t0, 8
  csrw epc, t0
  sret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
