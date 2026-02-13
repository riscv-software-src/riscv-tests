# See LICENSE for license details.

#*****************************************************************************
# pm2sub_wx.S
#-----------------------------------------------------------------------------
#
# Test pm2sub.wx instruction (packed multiply 2-way sub word cross, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2sub.wx: packed multiply 2-way sub for words (cross)
  # rd = (rs1[0] * rs2[1]) - (rs1[1] * rs2[0]) for two 32-bit words -> 64-bit result

  # Test: (2 * 5) - (4 * 3) = 10 - 12 = -2 = 0xfffffffffffffffe
  TEST_CASE( 2, x14, 0xfffffffffffffffe, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2sub.wx x14, a1, a2 );

  # Test: (3 * 4) - (2 * 3) = 12 - 6 = 6
  TEST_CASE( 3, x14, 0x0000000000000006, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000200000003; \
    li a2, 0x0000000400000003; \
    pm2sub.wx x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

