# See LICENSE for license details.

#*****************************************************************************
# privileged.S
#-----------------------------------------------------------------------------
#
# Test privileged instruction trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  la t0, evec
  csrw evec, t0

  csrci status, 1

  li TESTNUM, 2
  sret
  j fail

  TEST_PASSFAIL

evec:
  li t1, CAUSE_PRIVILEGED_INSTRUCTION
  csrr t0, cause
  bne t0, t1, fail
  j pass

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
