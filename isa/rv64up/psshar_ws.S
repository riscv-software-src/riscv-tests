# See LICENSE for license details.

#*****************************************************************************
# psshar_ws.S
#-----------------------------------------------------------------------------
#
# Test psshar.ws instruction (packed saturating shift arithmetic rounding word scalar, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psshar.ws rd, rs1, rs2
  # Performs packed word saturating shift arithmetic with rounding by signed scalar amount
  # Positive shift = left shift with saturation, negative shift = right shift with rounding

  # Test case 1: Shift left by 1 (no saturation)
  TEST_RR_OP_VXSAT( 2, psshar.ws, 0x0000000400000002, 0x0000000200000001, 0x0000000000000001, 0  );

  # Test case 2: Shift left with saturation
  TEST_RR_OP_VXSAT( 3, psshar.ws, 0x7fffffff7fffffff, 0x4000000040000000, 0x0000000000000002, 1  );

  # Test case 3: Shift right with rounding (negative shift amount)
  TEST_RR_OP_VXSAT( 4, psshar.ws, 0x0000000200000001, 0x0000000300000001, 0xffffffffffffffff, 0  );

  # Test case 4: Zero input
  TEST_RR_OP_VXSAT( 5, psshar.ws, 0x0000000000000000, 0x0000000000000000, 0x0000000000000004, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

