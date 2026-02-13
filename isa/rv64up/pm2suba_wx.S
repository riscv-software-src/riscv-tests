# See LICENSE for license details.

#*****************************************************************************
# pm2suba_wx.S
#-----------------------------------------------------------------------------
#
# Test pm2suba.wx instruction (packed multiply 2-way sub accumulate word cross, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2suba.wx: packed multiply 2-way sub accumulate for words (cross)
  # rd = rd + (rs1[0] * rs2[1]) - (rs1[1] * rs2[0]) for two 32-bit words -> 64-bit result

  # Test: 0x20 + (2 * 5) - (4 * 3) = 32 + 10 - 12 = 30 = 0x1e
  TEST_CASE( 2, x14, 0x000000000000001e, \
    li x14, 0x0000000000000020; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2suba.wx x14, a1, a2 );

  # Test: 0x100 + (3 * 4) - (2 * 3) = 256 + 12 - 6 = 262 = 0x106
  TEST_CASE( 3, x14, 0x0000000000000106, \
    li x14, 0x0000000000000100; \
    li a1, 0x0000000200000003; \
    li a2, 0x0000000400000003; \
    pm2suba.wx x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

