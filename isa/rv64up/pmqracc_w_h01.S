# See LICENSE for license details.

#*****************************************************************************
# pmqracc_w_h01.S
#-----------------------------------------------------------------------------
#
# Test pmqracc.w.h01 instruction (packed multiply Q-format rounding accumulate word h0*h1, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqracc.w.h01: packed multiply Q-format rounding accumulate for words using h0*h1
  # rd[i] += ((sext(rs1[i].h0) * sext(rs2[i].h1)) << 1) + 1 for each 32-bit word

  # Test: 0x10 + ((2 * 3) << 1) + 1 = 16 + 12 + 1 = 29 = 0x1d (rs1.h0=2, rs2.h1=3)
  TEST_CASE( 2, x14, 0x0000001d0000001d, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000000200000002; \
    li a2, 0x0003000000030000; \
    pmqracc.w.h01 x14, a1, a2 );

  # Test: 0x100 + ((4 * 5) << 1) + 1 = 256 + 40 + 1 = 297 = 0x129
  TEST_CASE( 3, x14, 0x0000012900000129, \
    li x14, 0x0000010000000100; \
    li a1, 0x0000000400000004; \
    li a2, 0x0005000000050000; \
    pmqracc.w.h01 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

