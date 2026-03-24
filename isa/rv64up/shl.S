# See LICENSE for license details.

#*****************************************************************************
# shl.S
#-----------------------------------------------------------------------------
#
# Test shl instruction (scalar shift left).
# RV64-only instruction.
# Bidirectional shift: positive shamt = left shift, negative shamt = right shift (logical).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # shl rd, rs1, rs2
  # If rs2[7:0] >= 0: left shift
  # If rs2[7:0] < 0: right shift logical

  # Test case 1: Left shift
  # rs1 = 0x0000000000000005, rs2 = 0x0000000000000002
  # Expected: 0x0000000000000014 (5 << 2 = 20)
  TEST_RR_OP( 2, shl, 0x0000000000000014, 0x0000000000000005, 0x0000000000000002 );

  # Test case 2: Left shift by 0
  # rs1 = 0x123456789ABCDEF0, rs2 = 0x0000000000000000
  # Expected: 0x123456789ABCDEF0
  TEST_RR_OP( 3, shl, 0x123456789ABCDEF0, 0x123456789ABCDEF0, 0x0000000000000000 );

  # Test case 4: Left shift by large amount (>= 64)
  # rs1 = 0x0000000000000001, rs2 = 0x0000000000000040
  # Expected: 0x0000000000000000
  TEST_RR_OP( 5, shl, 0x0000000000000000, 0x0000000000000001, 0x0000000000000040 );

  # Test case 5: Right shift (negative shamt)
  # rs1 = 0x8000000000000000, rs2 = 0xFFFFFFFFFFFFFFFC (shift right by 4)
  # Expected: 0x0800000000000000
  TEST_RR_OP( 6, shl, 0x0800000000000000, 0x8000000000000000, 0xFFFFFFFFFFFFFFFC );

  # Test case 6: Right shift by large negative amount (<= -64)
  # rs1 = 0xFFFFFFFFFFFFFFFF, rs2 = 0xFFFFFFFFFFFFFFC0 (shift right by 64)
  # Expected: 0x0000000000000000
  TEST_RR_OP( 7, shl, 0x0000000000000000, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFC0 );

  # Test case 7: Right shift by -1
  # rs1 = 0x123456789ABCDEF0, rs2 = 0xFFFFFFFFFFFFFFFF
  # Expected: 0x091A2B3C4D5E6F78
  TEST_RR_OP( 8, shl, 0x091A2B3C4D5E6F78, 0x123456789ABCDEF0, 0xFFFFFFFFFFFFFFFF );

  # Test case 8: Left shift with high bits
  # rs1 = 0x0000000000000001, rs2 = 0x000000000000003F (shift left by 63)
  # Expected: 0x8000000000000000
  TEST_RR_OP( 9, shl, 0x8000000000000000, 0x0000000000000001, 0x000000000000003F );

  # Test case 9: Zero shifted
  # rs1 = 0x0000000000000000, rs2 = 0x0000000000000005
  # Expected: 0x0000000000000000
  TEST_RR_OP( 10, shl, 0x0000000000000000, 0x0000000000000000, 0x0000000000000005 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


