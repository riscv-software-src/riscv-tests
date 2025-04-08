# See LICENSE for license details.

#*****************************************************************************
# minstret_overflow.S
#-----------------------------------------------------------------------------
#
# Test if overflow of instret is handled correctly
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # The value written to instret will be the value read by the following
  # instruction (i.e. the increment is suppressed)
  TEST_CASE(2, a0, 0, csrwi minstret, 0; csrr a0, minstret);

#if __riscv_xlen == 32
  # Writes to instreth are considered writes to instret and so also
  # suppress the increment
  TEST_CASE(3, a0, 0, li t0, 0xffffffff; csrw minstret, t0; csrw minstreth, t0; nop; csrr a0, minstret);
  TEST_CASE(4, a0, 0, csrr a0, minstreth);
#endif

2:
  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  j fail

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
