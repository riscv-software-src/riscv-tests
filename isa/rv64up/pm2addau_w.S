# See LICENSE for license details.

#*****************************************************************************
# pm2addau_w.S
#-----------------------------------------------------------------------------
#
# Test pm2addau.w instruction (packed multiply 2-way add accumulate word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2addau.w: packed multiply 2-way add accumulate unsigned for words
  # rd = rd + (zext(rs1[0]) * zext(rs2[0])) + (zext(rs1[1]) * zext(rs2[1])) -> 64-bit result

  # Test: 0x10 + (2 * 3) + (4 * 5) = 16 + 6 + 20 = 42 = 0x2a
  TEST_CASE( 2, x14, 0x000000000000002a, \
    li x14, 0x0000000000000010; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2addau.w x14, a1, a2 );

  # Test: 0x100 + (0xFFFFFFFF * 1) + (1 * 1) = 256 + 0xFFFFFFFF + 1 = 0x100000100
  TEST_CASE( 3, x14, 0x0000000100000100, \
    li x14, 0x0000000000000100; \
    li a1, 0x00000001ffffffff; \
    li a2, 0x0000000100000001; \
    pm2addau.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

