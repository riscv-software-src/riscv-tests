# See LICENSE for license details.

#*****************************************************************************
# pnclipriu_h.S
#-----------------------------------------------------------------------------
#
# Test pnclipriu.h instruction (packed narrow clip rounding immediate unsigned halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclipriu.h rd, rs1, imm
  # Narrows 32-bit elements to 16-bit by shifting right with rounding by immediate and saturating (unsigned)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with rounding (0x00000003 >> 1 = 1 + round = 2)
  TEST_CASE( 2, x14, 0x00020002, \
    li x10, 0x00000003; \
    li x11, 0x00000003; \
    pnclipriu.h x14, x10, 1 );

  # Test case 2: Shift right by 1 no rounding
  TEST_CASE( 3, x14, 0x00010001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    pnclipriu.h x14, x10, 1 );

  # Test case 3: Saturation to max unsigned (0xFFFF)
  TEST_CASE( 4, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    pnclipriu.h x14, x10, 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

