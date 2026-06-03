# See LICENSE for license details.

#*****************************************************************************
# pnclipp_w.S
#-----------------------------------------------------------------------------
#
# Test pnclipp.w instruction (packed narrow clip signed word).
# RV64-only instruction.
# Narrows 2 doublewords (from rs1 and rs2) to 2 words with signed saturation.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pnclipp.w rd, rs1, rs2
  # Takes rs1 and rs2 as 64-bit values, clips each to signed word

  # Test case 1: No saturation needed
  # rs1 = 0x0000000000000005, rs2 = 0x0000000000000007
  # Expected: 0x0000000700000005
  TEST_RR_OP_VXSAT( 2, pnclipp.w, 0x0000000700000005, 0x0000000000000005, 0x0000000000000007, 0  );

  # Test case 2: Positive saturation
  # rs1 = 0x0000000100000000, rs2 = 0x0000000100000000
  # Expected: 0x7FFFFFFF7FFFFFFF (saturated to 2147483647)
  TEST_RR_OP_VXSAT( 3, pnclipp.w, 0x7FFFFFFF7FFFFFFF, 0x0000000100000000, 0x0000000100000000, 1  );

  # Test case 3: Negative saturation
  # rs1 = 0xFFFFFFFF80000000, rs2 = 0xFFFFFFFF80000000
  # Expected: 0x8000000080000000 (saturated to -2147483648)
  TEST_RR_OP_VXSAT( 4, pnclipp.w, 0x8000000080000000, 0xFFFFFFFF80000000, 0xFFFFFFFF80000000, 0  );

  # Test case 5: Mixed values
  # rs1 = 0x000000007FFFFFFF, rs2 = 0xFFFFFFFF80000000
  # Expected: 0x800000007FFFFFFF
  TEST_RR_OP_VXSAT( 5, pnclipp.w, 0x800000007FFFFFFF, 0x000000007FFFFFFF, 0xFFFFFFFF80000000, 0  );

  # Test case 6: Zero
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000000
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 6, pnclipp.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

