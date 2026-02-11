# See LICENSE for license details.

#*****************************************************************************
# pnclipi_b.S
#-----------------------------------------------------------------------------
#
# Test pnclipi.b instruction (packed narrow clip immediate byte, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pnclipi.b rd, rs1, imm
  # Narrows 16-bit elements to 8-bit by shifting right by immediate and saturating (signed)
  # Uses rs1 register pair (rs1, rs1+1) as 64-bit input

  # Test case 1: Shift right by 1 with saturation
  TEST_CASE( 2, x14, 0x01010101, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    pnclipi.b x14, x10, 1 );

  # Test case 2: Saturation to max positive (0x007F = 127)
  TEST_CASE( 3, x14, 0x7f7f7f7f, \
    li x10, 0x7fff7fff; \
    li x11, 0x7fff7fff; \
    pnclipi.b x14, x10, 0 );

  # Test case 3: Shift right by 8 (0x0100 >> 8 = 1)
  TEST_CASE( 4, x14, 0x01010101, \
    li x10, 0x01000100; \
    li x11, 0x01000100; \
    pnclipi.b x14, x10, 8 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

