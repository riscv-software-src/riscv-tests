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

#ifdef __MACHINE_MODE
  #define sstatus mstatus
  #define sie mie
  #define sip mip
  #undef MIP_SSIP
  #define MIP_SSIP MIP_MSIP
#endif

  # Make sure wfi doesn't stall if an interrupt is pending
  csrc sstatus, SSTATUS_IE
  csrs sie, MIP_SSIP
  csrs sip, MIP_SSIP
  wfi

  RVTEST_PASS

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
