#*****************************************************************************
# ipi.S
#-----------------------------------------------------------------------------
#
# Test ipi interrupt.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32S
RVTEST_CODE_BEGIN

  la t0, evec
  csrw evec, t0

  csrw clear_ipi, x0
  li t1, 1<<21
  csrs status, t1 # turn on timer IRQ 5
  csrsi status, 4 # enable interrupts

  li t1,1
  csrw send_ipi, t1

  li TESTNUM, 2
  li a0,1000
loop:
  div x0, x0, x0
  addi a0, a0, -1
  bne a0, x0, loop
  j fail # assumption is that you will get an ipi before this loop ends

  TEST_PASSFAIL

evec:
  li t1, 0x80000000|IRQ_IPI
  csrr t0, cause
  bne t0, t1, fail
  j pass

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
