# See LICENSE for license details.

#*****************************************************************************
# pm2wsub_h.S
#-----------------------------------------------------------------------------
#
# Test pm2wsub.h instruction (packed 2-way widening multiply sub halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2wsub.h rd, rs1, rs2
  # Widening 2-way multiply-sub: rd_pair = -rs1[15:0]*rs2[15:0] + rs1[31:16]*rs2[31:16]
  # 16-bit signed elements, subtract first pair, add second pair

  # Test case 1: Simple multiply-sub
  # -(1 * 1) + (2 * 2) = -1 + 4 = 3
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00020001; \
    li x12, 0x00020001; \
    pm2wsub.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Equal terms cancel
  # -(2 * 2) + (2 * 2) = -4 + 4 = 0
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00020002; \
    li x12, 0x00020002; \
    pm2wsub.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Negative result
  # -(3 * 3) + (1 * 1) = -9 + 1 = -8
  TEST_CASE( 6, x14, 0xfffffff8, \
    li x10, 0x00010003; \
    li x12, 0x00010003; \
    pm2wsub.h x14, x10, x12 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

