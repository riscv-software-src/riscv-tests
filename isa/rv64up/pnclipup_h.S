# See LICENSE for license details.

#*****************************************************************************
# pnclipup_h.S
#-----------------------------------------------------------------------------
#
# Test pnclipup.h instruction (packed narrow clip unsigned halfword).
# RV64-only instruction.
# Narrows 4 words (from rs1 and rs2) to 4 halfwords with unsigned saturation.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pnclipup.h rd, rs1, rs2
  # Concatenates rs2:rs1 (128 bits), extracts 4 words, clips each to unsigned halfword

  # Test case 1: No saturation needed
  # rs1 = 0x0000000500000004, rs2 = 0x0000000700000006
  # Expected: 0x0007000600050004
  TEST_RR_OP_VXSAT( 2, pnclipup.h, 0x0007000600050004, 0x0000000500000004, 0x0000000700000006, 0  );

  # Test case 2: Positive saturation
  # rs1 = 0x0001000000010000, rs2 = 0x0001000000010000
  # Expected: 0xFFFFFFFFFFFFFFFF (saturated to 65535)
  TEST_RR_OP_VXSAT( 3, pnclipup.h, 0xFFFFFFFFFFFFFFFF, 0x0001000000010000, 0x0001000000010000, 1  );

  # Test case 3: Maximum unsigned halfword values
  # rs1 = 0x0000FFFF0000FFFF, rs2 = 0x0000FFFF0000FFFF
  # Expected: 0xFFFFFFFFFFFFFFFF
  TEST_RR_OP_VXSAT( 4, pnclipup.h, 0xFFFFFFFFFFFFFFFF, 0x0000FFFF0000FFFF, 0x0000FFFF0000FFFF, 0  );

  # Test case 4: Zero
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000000
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 5, pnclipup.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

