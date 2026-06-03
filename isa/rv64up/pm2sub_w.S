# See LICENSE for license details.

#*****************************************************************************
# pm2sub_w.S
#-----------------------------------------------------------------------------
#
# Test pm2sub.w instruction (packed multiply 2-way sub word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2sub.w: packed multiply 2-way sub for words
  # rd = (rs1[0] * rs2[0]) - (rs1[1] * rs2[1]) for two 32-bit words -> 64-bit result

  # Test: (2 * 3) - (4 * 5) = 6 - 20 = -14 = 0xfffffffffffffff2
  TEST_CASE( 2, x14, 0xfffffffffffffff2, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2sub.w x14, a1, a2 );

  # Test: (5 * 5) - (2 * 2) = 25 - 4 = 21 = 0x15
  TEST_CASE( 3, x14, 0x0000000000000015, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000200000005; \
    li a2, 0x0000000200000005; \
    pm2sub.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

