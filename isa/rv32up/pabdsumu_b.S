# See LICENSE for license details.

#*****************************************************************************
# pabdsumu_b.S (RV32)
#-----------------------------------------------------------------------------
#
# Test pabdsumu.b on RV32. Sums |a-b| over XLEN/8 = 4 unsigned byte lanes.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # Test 1: rs1 = 0x05060708, rs2 = 0x01010101
  # |5-1|+|6-1|+|7-1|+|8-1| = 4+5+6+7 = 22 = 0x16
  TEST_RR_OP( 2, pabdsumu.b, 0x00000016, 0x05060708, 0x01010101 );

  # Test 2: zero difference
  TEST_RR_OP( 3, pabdsumu.b, 0x00000000, 0x01010101, 0x01010101 );

  # Test 3: reversed operands
  TEST_RR_OP( 4, pabdsumu.b, 0x00000016, 0x01010101, 0x05060708 );

  # Test 4: 4 * 0xFF = 0x3FC
  TEST_RR_OP( 5, pabdsumu.b, 0x000003fc, 0xffffffff, 0x00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
