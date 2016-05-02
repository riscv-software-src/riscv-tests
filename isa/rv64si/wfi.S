# See LICENSE for license details.

#*****************************************************************************
# wfi.S
#-----------------------------------------------------------------------------
#
# Test wait-for-interrupt instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  # Make sure wfi doesn't stall if an interrupt is pending, even if masked
  csrc sstatus, SSTATUS_SIE
  csrs sip, MIP_SSIP
  wfi

  RVTEST_PASS

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
