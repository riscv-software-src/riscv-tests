# See LICENSE for license details.

#*****************************************************************************
# pnclip_bs.S
#-----------------------------------------------------------------------------
#
# Test pnclip.bs instruction (packed narrow clip byte scalar, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclip.bs rd, rs1, rs2
  # Narrows 16-bit elements to 8-bit by shifting right and saturating (signed)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with saturation
  TEST_CASE( 2, x14, 0x01010101, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    li x12, 0x00000001; \
    pnclip.bs x14, x10, x12 );

  # Test case 2: Saturation to max positive (0x007F = 127)
  TEST_CASE( 3, x14, 0x7f7f7f7f, \
    li x10, 0x7fff7fff; \
    li x11, 0x7fff7fff; \
    li x12, 0x00000000; \
    pnclip.bs x14, x10, x12 );

  # Test case 3: Saturation to min negative (0xFF80 = -128)
  TEST_CASE( 4, x14, 0x80808080, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    li x12, 0x00000000; \
    pnclip.bs x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

