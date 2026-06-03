# See LICENSE for license details.

#*****************************************************************************
# pnclipp_h.S
#-----------------------------------------------------------------------------
#
# Test pnclipp.h instruction (packed narrow clip signed halfword).
# RV64-only instruction.
# Narrows 4 words (from rs1 and rs2) to 4 halfwords with signed saturation.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pnclipp.h rd, rs1, rs2
  # Concatenates rs2:rs1 (128 bits), extracts 4 words, clips each to signed halfword

  # Test case 1: No saturation needed
  # rs1 = 0x0000000500000004, rs2 = 0x0000000700000006
  # Expected: 0x0007000600050004
  TEST_RR_OP_VXSAT( 2, pnclipp.h, 0x0007000600050004, 0x0000000500000004, 0x0000000700000006, 0  );

  # Test case 2: Positive saturation
  # rs1 = 0x0001000000010000, rs2 = 0x0001000000010000
  # Expected: 0x7FFF7FFF7FFF7FFF (saturated to 32767)
  TEST_RR_OP_VXSAT( 3, pnclipp.h, 0x7FFF7FFF7FFF7FFF, 0x0001000000010000, 0x0001000000010000, 1  );

  # Test case 3: Negative saturation
  # rs1 = 0xFFFF8000FFFF8000, rs2 = 0xFFFF8000FFFF8000
  # Expected: 0x8000800080008000 (saturated to -32768)
  TEST_RR_OP_VXSAT( 4, pnclipp.h, 0x8000800080008000, 0xFFFF8000FFFF8000, 0xFFFF8000FFFF8000, 0  );

  # Test case 4: Mixed values
  # rs1 = 0x00007FFFFFFF8000, rs2 = 0x00007FFFFFFF8000
  # 4 source words (low to high): 0xFFFF8000, 0x00007FFF, 0xFFFF8000, 0x00007FFF
  # Each clipped to int16: -32768 -> 0x8000, 32767 -> 0x7FFF
  # Expected (high to low halfwords): 0x7FFF 0x8000 0x7FFF 0x8000 = 0x7FFF80007FFF8000
  TEST_RR_OP_VXSAT( 5, pnclipp.h, 0x7FFF80007FFF8000, 0x00007FFFFFFF8000, 0x00007FFFFFFF8000, 0  );

  # Test case 5: Zero
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000000
  # Expected: 0x0000000000000000
  TEST_RR_OP_VXSAT( 6, pnclipp.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

