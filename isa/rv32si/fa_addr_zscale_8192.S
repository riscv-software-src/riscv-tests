#*****************************************************************************
# fa_addr.S
#-----------------------------------------------------------------------------
#
# Test fault load/store trap.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  li s0, 0x2000
  li s1, 1

loop:
  addi s1, s1, -1

  la t0, evec_load
  csrw evec, t0

  li TESTNUM, 2
  lw x0, 0(s0)
  j fail

  li TESTNUM, 3
  lh x0, 0(s0)
  j fail

  li TESTNUM, 4
  lhu x0, 0(s0)
  j fail

  li TESTNUM, 5
  lb x0, 0(s0)
  j fail

  li TESTNUM, 6
  lbu x0, 0(s0)
  j fail

  la t0, evec_store
  csrw evec, t0

  li TESTNUM, 7
  sw x0, 0(s0)
  j fail

  li TESTNUM, 8
  sh x0, 0(s0)
  j fail

  li TESTNUM, 9
  sb x0, 0(s0)
  j fail

  li s0, 0xbad1dea0
  beq s1, x0, loop

  j pass

  TEST_PASSFAIL

evec_load:
  li t1, CAUSE_FAULT_LOAD
  csrr t0, cause
  bne t0, t1, fail
  csrr t0, epc
  addi t0, t0, 8
  csrw epc, t0
  sret

evec_store:
  li t1, CAUSE_FAULT_STORE
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
