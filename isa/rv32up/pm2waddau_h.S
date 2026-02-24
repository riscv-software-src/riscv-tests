# See LICENSE for license details.

#*****************************************************************************
# pm2waddau_h.S
#-----------------------------------------------------------------------------
#
# Test pm2waddau.h instruction (packed 2-way widening multiply add accumulate unsigned halfword, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pm2waddau.h rd, rs1, rs2
  # Widening 2-way unsigned multiply-add accumulate: rd_pair += rs1[15:0]*rs2[15:0] + rs1[31:16]*rs2[31:16]

  # Test case 1: Simple unsigned accumulate (rd starts at 0)
  # 0 + (1 * 1) + (2 * 2) = 5
  TEST_CASE( 2, x14, 0x00000005, \
    li x14, 0x00000000; \
    li x15, 0x00000000; \
    li x10, 0x00020001; \
    li x12, 0x00020001; \
    pm2waddau.h x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000000, nop );

  # Test case 2: Accumulate with initial value
  # 10 + (1 * 1) + (1 * 1) = 10 + 2 = 12
  TEST_CASE( 4, x14, 0x0000000c, \
    li x14, 0x0000000a; \
    li x15, 0x00000000; \
    li x10, 0x00010001; \
    li x12, 0x00010001; \
    pm2waddau.h x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

