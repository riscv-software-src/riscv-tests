# See LICENSE for license details.

#*****************************************************************************
# pm2adda_w.S
#-----------------------------------------------------------------------------
#
# Test pm2adda.w instruction (packed multiply 2-way add accumulate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2adda.w: packed multiply 2-way add accumulate for words
  # rd = rd + (rs1[0] * rs2[0]) + (rs1[1] * rs2[1]) for two 32-bit words -> 64-bit result

  # Test: 0x10 + (2 * 3) + (4 * 5) = 16 + 6 + 20 = 42 = 0x2a
  TEST_CASE( 2, x14, 0x000000000000002a, \
    li x14, 0x0000000000000010; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2adda.w x14, a1, a2 );

  # Test: 0x100 + (1*1) + (1*1) = 256 + 2 = 258 = 0x102
  TEST_CASE( 3, x14, 0x0000000000000102, \
    li x14, 0x0000000000000100; \
    li a1, 0x0000000100000001; \
    li a2, 0x0000000100000001; \
    pm2adda.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

