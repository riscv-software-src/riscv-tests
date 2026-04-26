# See LICENSE for license details.

#*****************************************************************************
# pabdsumau_b.S
#-----------------------------------------------------------------------------
#
# Test pabdsumau.b instruction (packed absolute difference sum accumulate unsigned byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pabdsumau.b rd, rs1, rs2
  # Computes sum of absolute differences of unsigned bytes and accumulates to rd

  # Test case 1: Simple absolute difference sum accumulate
  # rs1 = 0x0102030405060708, rs2 = 0x0101010101010101
  # abs_diff per byte: |1-1|+|2-1|+|3-1|+|4-1|+|5-1|+|6-1|+|7-1|+|8-1| = 0+1+2+3+4+5+6+7 = 28
  # rd (initial 0) + 28 = 28 = 0x1c
  TEST_CASE( 2, x14, 0x000000000000001c, li x14, 0; li a1, 0x0102030405060708; li a2, 0x0101010101010101; pabdsumau.b x14, a1, a2 );

  # Test case 2: Zero difference
  TEST_CASE( 3, x14, 0x0000000000000000, li x14, 0; li a1, 0x0101010101010101; li a2, 0x0101010101010101; pabdsumau.b x14, a1, a2 );

  # Test case 3: With accumulation
  # Start with rd = 0x10, add absolute difference sum
  TEST_CASE( 4, x14, 0x000000000000002c, li x14, 0x10; li a1, 0x0102030405060708; li a2, 0x0101010101010101; pabdsumau.b x14, a1, a2 );

  # Test case 4: Max difference (0xFF - 0x00 = 0xFF per byte)
  # 8 bytes * 0xFF = 0x7F8
  TEST_CASE( 5, x14, 0x00000000000007f8, li x14, 0; li a1, 0xffffffffffffffff; li a2, 0x0000000000000000; pabdsumau.b x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

