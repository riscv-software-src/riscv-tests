# See LICENSE for license details.

#*****************************************************************************
# pabdsumau_b.S (RV32)
#-----------------------------------------------------------------------------
#
# Test pabdsumau.b on RV32. Sums |a-b| over XLEN/8 = 4 unsigned byte lanes
# and accumulates into rd. rv32up needs its own literals because the rv64up
# source sums over 8 lanes.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # Test 1: rs1 = 0x05060708, rs2 = 0x01010101
  # Per byte |5-1|+|6-1|+|7-1|+|8-1| = 4+5+6+7 = 22 = 0x16; rd_init = 0
  TEST_CASE( 2, x14, 0x00000016, li x14, 0; li a1, 0x05060708; li a2, 0x01010101; pabdsumau.b x14, a1, a2 );

  # Test 2: zero difference
  TEST_CASE( 3, x14, 0x00000000, li x14, 0; li a1, 0x01010101; li a2, 0x01010101; pabdsumau.b x14, a1, a2 );

  # Test 3: with non-zero accumulator
  # rd_init = 0x10, sum = 22 -> 0x10 + 0x16 = 0x26
  TEST_CASE( 4, x14, 0x00000026, li x14, 0x10; li a1, 0x05060708; li a2, 0x01010101; pabdsumau.b x14, a1, a2 );

  # Test 4: max byte difference (0xFF - 0x00) over 4 lanes -> 4 * 0xFF = 0x3FC
  TEST_CASE( 5, x14, 0x000003fc, li x14, 0; li a1, 0xffffffff; li a2, 0x00000000; pabdsumau.b x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
