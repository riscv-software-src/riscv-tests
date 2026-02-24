# See LICENSE for license details.

#*****************************************************************************
# pm2wsuba_hx.S
#-----------------------------------------------------------------------------
#
# Test pm2wsuba.hx instruction (packed 2-way widening multiply sub accumulate halfword cross, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2wsuba.hx rd, rs1, rs2
  # Widening 2-way cross multiply-sub accumulate: rd_pair += -rs1[15:0]*rs2[31:16] + rs1[31:16]*rs2[15:0]

  # Test case 1: Simple cross accumulate (rd starts at 0)
  # 0 + (-(1 * 2) + (2 * 1)) = -2 + 2 = 0
  TEST_CASE( 2, x14, 0x00000000, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00020001; \
    li x12, 0x00010002; \
    pm2wsuba.hx x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Accumulate with initial value
  # 10 + (-(1 * 1) + (2 * 3)) = 10 + (-1 + 6) = 15
  TEST_CASE( 4, x14, 0x0000000f, \
    li x14, 0x0000000a; \
    li x15, 0x00000000; \
    li x10, 0x00020001; \
    li x12, 0x00030001; \
    pm2wsuba.hx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

