# See LICENSE for license details.

#*****************************************************************************
# pnclipriu_b.S
#-----------------------------------------------------------------------------
#
# Test pnclipriu.b instruction (packed narrow clip rounding immediate unsigned byte, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclipriu.b rd, rs1, imm
  # Narrows 16-bit elements to 8-bit by shifting right with rounding by immediate and saturating (unsigned)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with rounding (0x0003 >> 1 = 1 + round = 2)
  TEST_CASE( 2, x14, 0x02020202, \
    li x10, 0x00030003; \
    li x11, 0x00030003; \
    pnclipriu.b x14, x10, 1 );

  # Test case 2: Shift right by 1 no rounding (0x0002 >> 1 = 1)
  TEST_CASE( 3, x14, 0x01010101, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    pnclipriu.b x14, x10, 1 );

  # Test case 3: Saturation to max unsigned (0xFF)
  TEST_CASE( 4, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    pnclipriu.b x14, x10, 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

