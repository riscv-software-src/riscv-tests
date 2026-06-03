# See LICENSE for license details.

#*****************************************************************************
# psshl_hs.S
#-----------------------------------------------------------------------------
#
# Test psshl.hs instruction (packed saturating shift left halfword).
# Bidirectional saturating shift on each 16-bit element:
# positive shamt = left shift with saturation, negative shamt = right shift (logical).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psshl.hs rd, rs1, rs2
  # For each 16-bit element:
  # If rs2[7:0] >= 0: left shift with saturation to 16-bit max
  # If rs2[7:0] < 0: right shift logical

  # Test case 1: Left shift without saturation
  # rs1 = 0x00050005, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0x00140014 (5 << 2 = 20 in each halfword)
  TEST_RR_OP( 2, psshl.hs, 0x00140014, 0x00050005, 0x00000002 );

  # Test case 2: Left shift with saturation
  # rs1 = 0x40004000, rs2 = 0x00000002 (shift left by 2)
  # Expected: 0xFFFFFFFF (saturated to 0xFFFF in each halfword)
  TEST_RR_OP( 3, psshl.hs, 0xFFFFFFFF, 0x40004000, 0x00000002 );

  # Test case 3: Left shift by 0
  # rs1 = 0x12345678, rs2 = 0x00000000
  # Expected: 0x12345678 (no change)
  TEST_RR_OP( 4, psshl.hs, 0x12345678, 0x12345678, 0x00000000 );

  # Test case 4: Left shift by large amount (>= 16)
  # rs1 = 0x00010001, rs2 = 0x00000010 (shift left by 16)
  # Per spec, sshamt >= 16 -> shx = (h @ 0x0000) = 0x00010000, exceeds 0xFFFF
  # so each halfword saturates to 0xFFFF.
  TEST_RR_OP( 5, psshl.hs, 0xFFFFFFFF, 0x00010001, 0x00000010 );

  # Test case 5: Right shift (negative shamt)
  # rs1 = 0x80008000, rs2 = 0xFFFFFFFC (shift right by 4)
  # Expected: 0x08000800 (logical right shift in each halfword)
  TEST_RR_OP( 6, psshl.hs, 0x08000800, 0x80008000, 0xFFFFFFFC );

  # Test case 6: Right shift by large negative amount (<= -16)
  # rs1 = 0xFFFFFFFF, rs2 = 0xFFFFFFF0 (shift right by 16)
  # Expected: 0x00000000
  TEST_RR_OP( 7, psshl.hs, 0x00000000, 0xFFFFFFFF, 0xFFFFFFF0 );

  # Test case 7: Right shift by -1
  # rs1 = 0x12345678, rs2 = 0xFFFFFFFF (shift right by 1)
  # Expected: 0x091A2B3C
  TEST_RR_OP( 8, psshl.hs, 0x091A2B3C, 0x12345678, 0xFFFFFFFF );

  # Test case 8: 0x7FFF << 1 = 0xFFFE in zero-extended 32-bit, no unsigned 16-bit saturation
  # rs1 = 0x7FFF7FFF, rs2 = 0x00000001 (shift left by 1) -> 0xFFFEFFFE
  TEST_RR_OP( 9, psshl.hs, 0xFFFEFFFE, 0x7FFF7FFF, 0x00000001 );

  # Test case 9: Zero shifted
  # rs1 = 0x00000000, rs2 = 0x00000005
  # Expected: 0x00000000
  TEST_RR_OP( 10, psshl.hs, 0x00000000, 0x00000000, 0x00000005 );

  # Test case 10: Mixed values
  # rs1 = 0x0001FFFF, rs2 = 0x00000001 (shift left by 1)
  # Expected: 0x0002FFFF (0x0001 << 1 = 0x0002, 0xFFFF saturates to 0xFFFF)
  TEST_RR_OP( 11, psshl.hs, 0x0002FFFF, 0x0001FFFF, 0x00000001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


