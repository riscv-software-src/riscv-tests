#*****************************************************************************
# csr.S
#-----------------------------------------------------------------------------
#
# Test CSRRx and CSRRxI instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  # Set up evec in case we trap.
  la t0, evec
  csrw evec, t0
  csrwi count, 0

  csrwi sup0, 3
  TEST_CASE( 2, a0,         3, csrr a0, sup0);
  TEST_CASE( 3, a1,         3, csrrci a1, sup0, 1);
  TEST_CASE( 4, a2,         2, csrrsi a2, sup0, 4);
  TEST_CASE( 5, a3,         6, csrrwi a3, sup0, 2);
  TEST_CASE( 6, a1,         2, li a0, 0xbad1dea; csrrw a1, sup0, a0);
  TEST_CASE( 7, a0, 0xbad1dea, li a0, 0x0001dea; csrrc a0, sup0, a0);
  TEST_CASE( 8, a0, 0xbad0000, li a0, 0x000beef; csrrs a0, sup0, a0);
  TEST_CASE( 9, a0, 0xbadbeef, csrr a0, sup0);

  # Make sure writing the cycle counter causes an exception.
  TEST_CASE(10, a0, 255, li a0, 255; csrrw a0, cycle, x0);

  # Make sure reading status in user mode causes an exception.
  csrci status, SR_S|SR_PS
  TEST_CASE(11, a0, 255, li a0, 255; csrr a0, status);

  # Make sure rdcycle is legal in user mode.
  TEST_CASE(12, x0, 0, rdcycle a0)

  # Exit by doing a syscall.
  TEST_CASE(13, x0, 1, scall)

  # We should only fall through to this if scall failed.
  TEST_PASSFAIL

evec:
  # Trapping on tests 10, 11, and 13 is usually good news.
  # Note that since the test didn't complete, TESTNUM is smaller by 1.
  li t0, 9
  beq TESTNUM, t0, privileged
  li t0, 10
  beq TESTNUM, t0, privileged
  li t0, 12
  beq TESTNUM, t0, syscall

  # Trapping on other tests is bad news.
  j fail

privileged:
  # Make sure CAUSE indicates a lack of privilege.
  csrr t0, cause
  li t1, CAUSE_PRIVILEGED_INSTRUCTION
  bne t0, t1, fail
  # Return to user mode, but skip the trapping instruction.
  csrr t0, epc
  addi t0, t0, 4
  csrw epc, t0
  sret

syscall:
  # Make sure CAUSE indicates a syscall.
  csrr t0, cause
  li t1, CAUSE_SYSCALL
  bne t0, t1, fail

  # We're done.
  j pass

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
