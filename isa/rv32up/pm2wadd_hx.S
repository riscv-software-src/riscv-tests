# See LICENSE for license details.

#*****************************************************************************
# pm2wadd_hx.S
#-----------------------------------------------------------------------------
#
# Test pm2wadd.hx instruction (packed 2-way widening multiply add halfword cross, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2wadd.hx rd, rs1, rs2
  # Widening 2-way cross multiply-add: rd_pair = rs1[15:0]*rs2[31:16] + rs1[31:16]*rs2[15:0]
  # 16-bit signed elements widened to 32-bit result

  # Test case 1: Simple cross multiply-add
  # (1 * 2) + (2 * 1) = 2 + 2 = 4
  TEST_CASE( 2, x14, 0x00000004, \
    li x10, 0x00020001; \
    li x12, 0x00010002; \
    pm2wadd.hx x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Zero result
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00010001; \
    pm2wadd.hx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Cross multiplication
  # (1 * 3) + (2 * 4) = 3 + 8 = 11
  TEST_CASE( 6, x14, 0x0000000b, \
    li x10, 0x00020001; \
    li x12, 0x00040003; \
    pm2wadd.hx x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

