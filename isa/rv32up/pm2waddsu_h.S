# See LICENSE for license details.

#*****************************************************************************
# pm2waddsu_h.S
#-----------------------------------------------------------------------------
#
# Test pm2waddsu.h instruction (packed 2-way widening multiply add signed-unsigned halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2waddsu.h rd, rs1, rs2
  # Widening 2-way signed-unsigned multiply-add: rd_pair = rs1[15:0]*rs2[15:0] + rs1[31:16]*rs2[31:16]
  # rs1 signed, rs2 unsigned, 16-bit to 32-bit widening

  # Test case 1: Simple signed-unsigned multiply-add
  # (1 * 1) + (2 * 2) = 1 + 4 = 5
  TEST_CASE( 2, x14, 0x00000005, \
    li x10, 0x00020001; \
    li x12, 0x00020001; \
    pm2waddsu.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Signed negative with unsigned
  # (-1 * 1) + (1 * 1) = -1 + 1 = 0
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x0001ffff; \
    li x12, 0x00010001; \
    pm2waddsu.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

