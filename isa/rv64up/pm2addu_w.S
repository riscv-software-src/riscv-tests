# See LICENSE for license details.

#*****************************************************************************
# pm2addu_w.S
#-----------------------------------------------------------------------------
#
# Test pm2addu.w instruction (packed multiply 2-way add word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pm2addu.w: packed multiply 2-way add unsigned for words
  # rd = (zext(rs1[0]) * zext(rs2[0])) + (zext(rs1[1]) * zext(rs2[1])) -> 64-bit result

  # Test: (2 * 3) + (4 * 5) = 6 + 20 = 26 = 0x1a
  TEST_CASE( 2, x14, 0x000000000000001a, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000000400000002; \
    li a2, 0x0000000500000003; \
    pm2addu.w x14, a1, a2 );

  # Test with large unsigned: (0xFFFFFFFF * 1) + (1 * 1) = 0xFFFFFFFF + 1 = 0x100000000
  TEST_CASE( 3, x14, 0x0000000100000000, \
    li x14, 0x0000000000000000; \
    li a1, 0x00000001ffffffff; \
    li a2, 0x0000000100000001; \
    pm2addu.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

