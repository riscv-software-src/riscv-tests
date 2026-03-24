# See LICENSE for license details.

#*****************************************************************************
# psshlr_hs.S
#-----------------------------------------------------------------------------
#
# Test psshlr.hs instruction (packed saturating shift left with rounding halfword).
# Bidirectional saturating shift with rounding on each 16-bit element:
# positive shamt = left shift with saturation, negative shamt = right shift with rounding.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psshlr.hs rd, rs1, rs2
  # For each 16-bit element:
  # If rs2[7:0] >= 0: left shift with saturation to 16-bit max
  # If rs2[7:0] < 0: right shift with rounding

  # Test case 1: Left shift without saturation
  # rs1 = 0x00050005, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0x00140014 (5 << 2 = 20 in each halfword)
  TEST_RR_OP_VXSAT( 2, psshlr.hs, 0x00140014, 0x00050005, 0x00000002, 0  );

  # Test case 2: Left shift with saturation
  # rs1 = 0x40004000, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated to 0xFFFF in each halfword)
  TEST_RR_OP_VXSAT( 3, psshlr.hs, 0xFFFFFFFF, 0x40004000, 0x00000002, 1  );

  # Test case 3: Right shift with rounding
  # rs1 = 0x00070007, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x00040004 (rounding)
  TEST_RR_OP_VXSAT( 4, psshlr.hs, 0x00040004, 0x00070007, 0xFFFFFFFF, 0  );

  # Test case 4: Right shift with rounding
  # rs1 = 0x00060006, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x00030003 (rounding)
  TEST_RR_OP_VXSAT( 5, psshlr.hs, 0x00030003, 0x00060006, 0xFFFFFFFF, 0  );

  # Test case 5: Right shift by large negative amount
  # rs1 = 0xFFFFFFFF, rs2 = 0xFFFFFFF0 (shift right by 16)
  # Expected: 0x00000000
  TEST_RR_OP_VXSAT( 6, psshlr.hs, 0x00010001, 0xFFFFFFFF, 0xFFFFFFF0, 0  );

  # Test case 6: Left shift by 0
  # rs1 = 0x12345678, rs2 = 0x00000000
  # Expected: 0x12345678 (no change)
  TEST_RR_OP_VXSAT( 7, psshlr.hs, 0x12345678, 0x12345678, 0x00000000, 0  );

  # Test case 7: Saturation with maximum value
  # rs1 = 0x7FFF7FFF, rs2 = 0x00000001 (shift left by 1)
  # Expected: 0xFFFFFFFF (saturated in each halfword)
  TEST_RR_OP_VXSAT( 8, psshlr.hs, 0xFFFFFFFF, 0x7FFF7FFF, 0x00000002, 1  );

  # Test case 8: Zero shifted
  # rs1 = 0x00000000, rs2 = 0x00000005
  # Expected: 0x00000000
  TEST_RR_OP_VXSAT( 9, psshlr.hs, 0x00000000, 0x00000000, 0x00000005, 0  );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


