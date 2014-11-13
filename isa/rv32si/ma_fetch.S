#*****************************************************************************
# ma_fetch.S
#-----------------------------------------------------------------------------
#
# Test misaligned fetch trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  la t0, evec
  csrw evec, t0

  li TESTNUM, 2
  la t0, evec
  jr t0, 2
  j fail

  li TESTNUM, 3
  la t0, next
  jr t0, 1
  // this test should pass, since the low bit should be masked off

next:
  li TESTNUM, 4
  la t0, evec
  jr t0, 3
  j fail

  j pass

  TEST_PASSFAIL

evec:
  li t0, 3
  beq TESTNUM, t0, fail

  li t1, CAUSE_MISALIGNED_FETCH
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
