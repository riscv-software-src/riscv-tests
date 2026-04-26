# See LICENSE for license details.

#*****************************************************************************
# pm2add_w.S
#-----------------------------------------------------------------------------
#
# Test pm2add.w instruction (packed multiply 2-way add word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2add.w: packed multiply 2-way add for words
  # rd = (rs1[0] * rs2[0]) + (rs1[1] * rs2[1]) for two 32-bit words -> 64-bit result

  # Test: (2 * 3) + (4 * 5) = 6 + 20 = 26 = 0x1a
  TEST_CASE( 2, x14, 0x000000000000001a, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2add.w x14, a1, a2 );

  # Test: (1*1) + (1*1) = 2
  TEST_CASE( 3, x14, 0x0000000000000002, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000100000001; \
    li a2, 0x0000000100000001; \
    pm2add.w x14, a1, a2 );

  # Test: (0x10 * 0x10) + (0x10 * 0x10) = 0x100 + 0x100 = 0x200
  TEST_CASE( 4, x14, 0x0000000000000200, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000001000000010; \
    li a2, 0x0000001000000010; \
    pm2add.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

