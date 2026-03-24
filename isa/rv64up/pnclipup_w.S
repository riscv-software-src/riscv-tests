# See LICENSE for license details.

#*****************************************************************************
# pnclipup_w.S
#-----------------------------------------------------------------------------
#
# Test pnclipup.w instruction (packed narrow clip unsigned word).
# RV64-only instruction.
# Narrows 2 doublewords (from rs1 and rs2) to 2 words with unsigned saturation.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pnclipup.w rd, rs1, rs2
  # Takes rs1 and rs2 as 64-bit values, clips each to unsigned word

  # Test case 1: No saturation needed
  # rs1 = 0x0000000000000005, rs2 = 0x0000000000000007
  # Expected: 0x0000000700000005
  TEST_RR_OP_VXSAT( 2, pnclipup.w, 0x0000000700000005, 0x0000000000000005, 0x0000000000000007, 0  );

  # Test case 2: Positive saturation
  # rs1 = 0x0000000100000000, rs2 = 0x0000000100000000
  # Expected: 0xFFFFFFFFFFFFFFFF (saturated to 4294967295)
  TEST_RR_OP_VXSAT( 3, pnclipup.w, 0xFFFFFFFFFFFFFFFF, 0x0000000100000000, 0x0000000100000000, 1  );

  # Test case 3: Maximum unsigned word values
  # rs1 = 0x00000000FFFFFFFF, rs2 = 0x00000000FFFFFFFF
  # Expected: 0xFFFFFFFFFFFFFFFF
  TEST_RR_OP_VXSAT( 4, pnclipup.w, 0xFFFFFFFFFFFFFFFF, 0x00000000FFFFFFFF, 0x00000000FFFFFFFF, 0  );

  # Test case 4: Zero
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000000
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 5, pnclipup.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

