# See LICENSE for license details.

#*****************************************************************************
# pmqracc_w_h11.S
#-----------------------------------------------------------------------------
#
# Test pmqracc.w.h11 instruction (packed multiply Q-format rounding accumulate word h1*h1, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqracc.w.h11: packed multiply Q-format rounding accumulate for words using h1*h1
  # rd[i] += ((sext(rs1[i].h1) * sext(rs2[i].h1)) << 1) + 1 for each 32-bit word

  # Test: 0x10 + ((2 * 3) << 1) + 1 = 16 + 12 + 1 = 29 = 0x1d (rs1.h1=2, rs2.h1=3)
  TEST_CASE( 2, x14, 0x0000001d0000001d, \
    li x14, 0x0000001000000010; \
    li a1, 0x0002000000020000; \
    li a2, 0x0003000000030000; \
    pmqracc.w.h11 x14, a1, a2 );

  # Test: 0x100 + ((4 * 5) << 1) + 1 = 256 + 40 + 1 = 297 = 0x129
  TEST_CASE( 3, x14, 0x0000012900000129, \
    li x14, 0x0000010000000100; \
    li a1, 0x0004000000040000; \
    li a2, 0x0005000000050000; \
    pmqracc.w.h11 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

