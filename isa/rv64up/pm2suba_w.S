# See LICENSE for license details.

#*****************************************************************************
# pm2suba_w.S
#-----------------------------------------------------------------------------
#
# Test pm2suba.w instruction (packed multiply 2-way sub accumulate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2suba.w: packed multiply 2-way sub accumulate for words
  # rd = rd + (rs1[0] * rs2[0]) - (rs1[1] * rs2[1]) for two 32-bit words -> 64-bit result

  # Test: 0x20 + (2 * 3) - (4 * 5) = 32 + 6 - 20 = 18 = 0x12
  TEST_CASE( 2, x14, 0x0000000000000012, \
    li x14, 0x0000000000000020; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2suba.w x14, a1, a2 );

  # Test: 0x100 + (5 * 5) - (2 * 2) = 256 + 25 - 4 = 277 = 0x115
  TEST_CASE( 3, x14, 0x0000000000000115, \
    li x14, 0x0000000000000100; \
    li a1, 0x0000000200000005; \
    li a2, 0x0000000200000005; \
    pm2suba.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

