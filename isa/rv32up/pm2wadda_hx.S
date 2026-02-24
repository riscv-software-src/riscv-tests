# See LICENSE for license details.

#*****************************************************************************
# pm2wadda_hx.S
#-----------------------------------------------------------------------------
#
# Test pm2wadda.hx instruction (packed 2-way widening multiply add accumulate halfword cross, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2wadda.hx rd, rs1, rs2
  # Widening 2-way cross multiply-add accumulate: rd_pair += rs1[15:0]*rs2[31:16] + rs1[31:16]*rs2[15:0]

  # Test case 1: Simple cross accumulate (rd starts at 0)
  # 0 + (1 * 2) + (2 * 1) = 4
  TEST_CASE( 2, x14, 0x00000004, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00020001; \
    li x12, 0x00010002; \
    pm2wadda.hx x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Accumulate with initial value
  # 10 + (1 * 2) + (2 * 1) = 10 + 4 = 14
  TEST_CASE( 4, x14, 0x0000000e, \
    li x14, 0x0000000a; \
    li x15, 0x00000000; \
    li x10, 0x00020001; \
    li x12, 0x00010002; \
    pm2wadda.hx x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

