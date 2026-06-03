# See LICENSE for license details.

#*****************************************************************************
# pm2add_wx.S
#-----------------------------------------------------------------------------
#
# Test pm2add.wx instruction (packed multiply 2-way add word cross, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2add.wx: packed multiply 2-way add for words (cross)
  # rd = (rs1[0] * rs2[1]) + (rs1[1] * rs2[0]) for two 32-bit words -> 64-bit result

  # Test: (2 * 5) + (4 * 3) = 10 + 12 = 22 = 0x16
  TEST_CASE( 2, x14, 0x0000000000000016, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2add.wx x14, a1, a2 );

  # Test: (1*1) + (1*1) = 2
  TEST_CASE( 3, x14, 0x0000000000000002, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000100000001; \
    li a2, 0x0000000100000001; \
    pm2add.wx x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

