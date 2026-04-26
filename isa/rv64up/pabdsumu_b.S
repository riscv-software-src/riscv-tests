# See LICENSE for license details.

#*****************************************************************************
# pabdsumu_b.S
#-----------------------------------------------------------------------------
#
# Test pabdsumu.b instruction (packed absolute difference sum unsigned byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pabdsumu.b rd, rs1, rs2
  # Computes sum of absolute differences of unsigned bytes

  # Test case 1: Simple absolute difference sum
  # rs1 = 0x0102030405060708, rs2 = 0x0101010101010101
  # abs_diff per byte: |1-1|+|2-1|+|3-1|+|4-1|+|5-1|+|6-1|+|7-1|+|8-1| = 0+1+2+3+4+5+6+7 = 28
  TEST_RR_OP( 2, pabdsumu.b, 0x000000000000001c, 0x0102030405060708, 0x0101010101010101 );

  # Test case 2: Zero difference
  TEST_RR_OP( 3, pabdsumu.b, 0x0000000000000000, 0x0101010101010101, 0x0101010101010101 );

  # Test case 3: Reversed operands (same result due to absolute value)
  TEST_RR_OP( 4, pabdsumu.b, 0x000000000000001c, 0x0101010101010101, 0x0102030405060708 );

  # Test case 4: Max difference (0xFF - 0x00 = 0xFF per byte)
  # 8 bytes * 0xFF = 0x7F8
  TEST_RR_OP( 5, pabdsumu.b, 0x00000000000007f8, 0xffffffffffffffff, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

