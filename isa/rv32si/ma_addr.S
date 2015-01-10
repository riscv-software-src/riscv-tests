# See LICENSE for license details.

#*****************************************************************************
# ma_addr.S
#-----------------------------------------------------------------------------
#
# Test misaligned ld/st trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  la s0, evec_load

  la t0, evec_load
  csrw evec, t0

  li TESTNUM, 2
  lw x0, 1(s0)
  j fail

  li TESTNUM, 3
  lw x0, 2(s0)
  j fail

  li TESTNUM, 4
  lw x0, 3(s0)
  j fail

  li TESTNUM, 5
  lh x0, 1(s0)
  j fail

  li TESTNUM, 6
  lhu x0, 1(s0)
  j fail

  la t0, evec_store
  csrw evec, t0

  li TESTNUM, 7
  sw x0, 1(s0)
  j fail

  li TESTNUM, 8
  sw x0, 2(s0)
  j fail

  li TESTNUM, 9
  sw x0, 3(s0)
  j fail

  li TESTNUM, 10
  sh x0, 1(s0)
  j fail

  j pass

  TEST_PASSFAIL

evec_load:
  li t1, CAUSE_MISALIGNED_LOAD
  csrr t0, cause
  bne t0, t1, fail
  csrr t0, epc
  addi t0, t0, 8
  csrw epc, t0
  sret

evec_store:
  li t1, CAUSE_MISALIGNED_STORE
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
