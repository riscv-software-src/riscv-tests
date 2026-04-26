# See LICENSE for license details.

#*****************************************************************************
# pssha_ws.S
#-----------------------------------------------------------------------------
#
# Test pssha.ws instruction (packed saturating shift arithmetic word scalar, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pssha.ws rd, rs1, rs2
  # Performs packed word saturating shift arithmetic by signed scalar amount
  # Positive shift = left shift with saturation, negative shift = right shift

  # Test case 1: Shift left by 1 (no saturation)
  TEST_RR_OP( 2, pssha.ws, 0x0000000400000002, 0x0000000200000001, 0x0000000000000001 );

  # Test case 2: Shift left with saturation
  TEST_RR_OP( 3, pssha.ws, 0x7fffffff7fffffff, 0x4000000040000000, 0x0000000000000002 );

  # Test case 3: Shift right (negative shift amount)
  TEST_RR_OP( 4, pssha.ws, 0x0000000100000000, 0x0000000200000001, 0xffffffffffffffff );

  # Test case 4: Zero input
  TEST_RR_OP( 5, pssha.ws, 0x0000000000000000, 0x0000000000000000, 0x0000000000000004 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

