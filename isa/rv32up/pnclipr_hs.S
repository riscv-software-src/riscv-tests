# See LICENSE for license details.

#*****************************************************************************
# pnclipr_hs.S
#-----------------------------------------------------------------------------
#
# Test pnclipr.hs instruction (packed narrow clip rounding halfword scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclipr.hs rd, rs1, rs2
  # Narrows 32-bit elements to 16-bit by shifting right with rounding and saturating (signed)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with rounding (0x00000003 >> 1 = 1 + round = 2)
  TEST_CASE( 2, x14, 0x00020002, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    li x12, 0x00000001; \
    pnclipr.hs x14, x10, x12 );

  # Test case 2: Shift right by 1 no rounding
  TEST_CASE( 3, x14, 0x00010001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 0x00000001; \
    pnclipr.hs x14, x10, x12 );

  # Test case 3: Saturation after rounding
  TEST_CASE( 4, x14, 0x7fff7fff, \
    li x10, 0x7fffffff; \
    li x11, 0x7fffffff; \
    li x12, 0x00000000; \
    pnclipr.hs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

