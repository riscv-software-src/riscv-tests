# See LICENSE for license details.

#*****************************************************************************
# pm2wadd_h.S
#-----------------------------------------------------------------------------
#
# Test pm2wadd.h instruction (packed 2-way widening multiply add halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2wadd.h rd, rs1, rs2
  # Widening 2-way multiply-add: rd_pair = rs1[15:0]*rs2[15:0] + rs1[31:16]*rs2[31:16]
  # 16-bit signed elements widened to 32-bit result

  # Test case 1: Simple multiply-add
  # (1 * 1) + (2 * 2) = 1 + 4 = 5
  TEST_CASE( 2, x14, 0x00000005, \
    li x10, 0x00020001; \
    li x12, 0x00020001; \
    pm2wadd.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Zero result
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x12, 0x00010001; \
    pm2wadd.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Signed multiplication
  # (-1 * 1) + (1 * 1) = -1 + 1 = 0
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x0001ffff; \
    li x12, 0x00010001; \
    pm2wadd.h x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

