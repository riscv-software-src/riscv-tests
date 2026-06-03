# See LICENSE for license details.

#*****************************************************************************
# pnclipp_b.S
#-----------------------------------------------------------------------------
#
# Test pnclipp.b instruction (packed narrow clip signed byte).
# RV64-only instruction.
# Narrows 8 halfwords (from rs1 and rs2) to 8 bytes with signed saturation.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pnclipp.b rd, rs1, rs2
  # Concatenates rs2:rs1 (128 bits), extracts 8 halfwords, clips each to signed byte

  # Test case 1: No saturation needed
  # rs1 = 0x0005000400030002, rs2 = 0x0009000800070006
  # Expected: 0x0908070605040302
  TEST_RR_OP_VXSAT( 2, pnclipp.b, 0x0908070605040302, 0x0005000400030002, 0x0009000800070006, 0  );

  # Test case 2: Positive saturation
  # rs1 = 0x0100010001000100, rs2 = 0x0100010001000100
  # Expected: 0x7F7F7F7F7F7F7F7F (saturated to 127)
  TEST_RR_OP_VXSAT( 3, pnclipp.b, 0x7F7F7F7F7F7F7F7F, 0x0100010001000100, 0x0100010001000100, 1  );

  # Test case 3: Negative saturation
  # rs1 = 0xFF80FF80FF80FF80, rs2 = 0xFF80FF80FF80FF80
  # Expected: 0x8080808080808080 (saturated to -128)
  TEST_RR_OP_VXSAT( 4, pnclipp.b, 0x8080808080808080, 0xFF80FF80FF80FF80, 0xFF80FF80FF80FF80, 0  );

  # Test case 4: Mixed values
  # rs1 = 0x007FFF80007FFF80, rs2 = 0x007FFF80007FFF80
  # Expected: 0x7F807F807F807F80
  TEST_RR_OP_VXSAT( 5, pnclipp.b, 0x7F807F807F807F80, 0x007FFF80007FFF80, 0x007FFF80007FFF80, 0  );

  # Test case 5: Zero
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000000
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 6, pnclipp.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

