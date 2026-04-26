# See LICENSE for license details.

#*****************************************************************************
# pmhraccsu_w.S
#-----------------------------------------------------------------------------
#
# Test pmhraccsu.w instruction (packed multiply-high rounding accumulate word signed*unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhraccsu.w: packed multiply-high rounding accumulate signed*unsigned for words
  # rd[i] += ((sext(rs1[i]) * zext(rs2[i])) + 0x80000000) >> 32 for each 32-bit word

  # Test: 0x10 + (0x10000 * 0x10000 + 0x80000000) >> 32 = 0x10 + 0x01 = 0x11
  TEST_CASE( 2, x14, 0x0000001100000011, \
    li x14, 0x0000001000000010; \
    li a1, 0x0001000000010000; \
    li a2, 0x0001000000010000; \
    pmhraccsu.w x14, a1, a2 );

  # Test: 0x10 + (-1 * 2 + 0x80000000) >> 32 = 0x10 + 0x00 = 0x10
  TEST_CASE( 3, x14, 0x0000001000000010, \
    li x14, 0x0000001000000010; \
    li a1, 0xffffffffffffffff; \
    li a2, 0x0000000200000002; \
    pmhraccsu.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

