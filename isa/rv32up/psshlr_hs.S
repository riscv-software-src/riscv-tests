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

RVTEST_RV32U
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
  TEST_RR_OP( 2, psshlr.hs, 0x00140014, 0x00050005, 0x00000002 );

  # Test case 2: Left shift with saturation
  # rs1 = 0x40004000, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated to 0xFFFF in each halfword)
  TEST_RR_OP( 3, psshlr.hs, 0xFFFFFFFF, 0x40004000, 0x00000002 );

  # Test case 3: Right shift with rounding
  # rs1 = 0x00070007, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x00040004 (rounding)
  TEST_RR_OP( 4, psshlr.hs, 0x00040004, 0x00070007, 0xFFFFFFFF );

  # Test case 4: Right shift with rounding
  # rs1 = 0x00060006, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x00030003 (rounding)
  TEST_RR_OP( 5, psshlr.hs, 0x00030003, 0x00060006, 0xFFFFFFFF );

  # Test case 5: Right shift by large negative amount with rounding
  # rs1 = 0xFFFFFFFF, rs2 = 0xFFFFFFF0 (shamt=-16). Spec: y = (zext32(h)<<1)[32:16]
  # = 0x00001 for h=0xFFFF; result = (y+1)[16:1] = 0x0001 per halfword.
  TEST_RR_OP( 6, psshlr.hs, 0x00010001, 0xFFFFFFFF, 0xFFFFFFF0 );

  # Test case 6: Left shift by 0
  # rs1 = 0x12345678, rs2 = 0x00000000
  # Expected: 0x12345678 (no change)
  TEST_RR_OP( 7, psshlr.hs, 0x12345678, 0x12345678, 0x00000000 );

  # Test case 7: 0x7FFF << 1 in sign-extended 32-bit = 0xFFFE; <= 0xFFFF, no sat
  # rs1 = 0x7FFF7FFF, rs2 = 0x00000001 -> 0xFFFEFFFE
  TEST_RR_OP( 8, psshlr.hs, 0xFFFEFFFE, 0x7FFF7FFF, 0x00000001 );

  # Test case 8: Zero shifted
  # rs1 = 0x00000000, rs2 = 0x00000005
  # Expected: 0x00000000
  TEST_RR_OP( 9, psshlr.hs, 0x00000000, 0x00000000, 0x00000005 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


