# See LICENSE for license details.

#*****************************************************************************
# pnclip_hs.S
#-----------------------------------------------------------------------------
#
# Test pnclip.hs instruction (packed narrow clip halfword scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclip.hs rd, rs1, rs2
  # Narrows 32-bit elements to 16-bit by shifting right and saturating (signed)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with saturation
  TEST_CASE( 2, x14, 0x00010001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 0x00000001; \
    pnclip.hs x14, x10, x12 );

  # Test case 2: Saturation to max positive (0x7FFF)
  TEST_CASE( 3, x14, 0x7fff7fff, \
    li x10, 0x7fffffff; \
    li x11, 0x7fffffff; \
    li x12, 0x00000000; \
    pnclip.hs x14, x10, x12 );

  # Test case 3: Saturation to min negative (0x8000)
  TEST_CASE( 4, x14, 0x80008000, \
    li x10, 0x80000000; \
    li x11, 0x80000000; \
    li x12, 0x00000000; \
    pnclip.hs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

