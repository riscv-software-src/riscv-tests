# See LICENSE for license details.

#*****************************************************************************
# pnclipup_b.S
#-----------------------------------------------------------------------------
#
# Test pnclipup.b instruction (packed narrow clip unsigned byte).
# RV64-only instruction.
# Narrows 8 halfwords (from rs1 and rs2) to 8 bytes with unsigned saturation.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pnclipup.b rd, rs1, rs2
  # Concatenates rs2:rs1 (128 bits), extracts 8 halfwords, clips each to unsigned byte

  # Test case 1: No saturation needed
  # rs1 = 0x0005000400030002, rs2 = 0x0009000800070006
  # Expected: 0x0908070605040302
  TEST_RR_OP_VXSAT( 2, pnclipup.b, 0x0908070605040302, 0x0005000400030002, 0x0009000800070006, 0  );

  # Test case 2: Positive saturation
  # rs1 = 0x0100010001000100, rs2 = 0x0100010001000100
  # Expected: 0xFFFFFFFFFFFFFFFF (saturated to 255)
  TEST_RR_OP_VXSAT( 3, pnclipup.b, 0xFFFFFFFFFFFFFFFF, 0x0100010001000100, 0x0100010001000100, 1  );

  # Test case 3: Maximum unsigned byte values
  # rs1 = 0x00FF00FF00FF00FF, rs2 = 0x00FF00FF00FF00FF
  # Expected: 0xFFFFFFFFFFFFFFFF
  TEST_RR_OP_VXSAT( 4, pnclipup.b, 0xFFFFFFFFFFFFFFFF, 0x00FF00FF00FF00FF, 0x00FF00FF00FF00FF, 0  );

  # Test case 4: Zero
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000000
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 5, pnclipup.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

