# See LICENSE for license details.

#*****************************************************************************
# timer.S
#-----------------------------------------------------------------------------
#
# Test timer interrupt.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  la t0, evec
  csrw evec, t0

  csrr t0, count
  add t0, t0, 1000
  csrw compare, t0

  li t1, 1<<23
  csrs status, t1 # turn on timer IRQ 7
  csrsi status, 4 # enable interrupts

  li TESTNUM, 2
  li a0,10000
loop:
  div x0, x0, x0
  addi a0, a0, -1
  bne a0, x0, loop
  j fail # assumption is that you can't divide in one cycle

  TEST_PASSFAIL

evec:
  li TESTNUM, 3
  li t1, 0x80000000|IRQ_TIMER
  csrr t0, cause
  bne t0, t1, fail
  j pass

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
