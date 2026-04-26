# See LICENSE for license details.

#*****************************************************************************
# pmqacc_w_h00.S
#-----------------------------------------------------------------------------
#
# Test pmqacc.w.h00 instruction (packed multiply Q-format accumulate word h0*h0, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmqacc.w.h00: packed multiply Q-format accumulate for words using h0*h0
  # rd[i] += (sext(rs1[i].h0) * sext(rs2[i].h0)) << 1 for each 32-bit word

  # Test: 0x10 + (2 * 3) << 1 = 16 + 12 = 28 = 0x1c
  TEST_CASE( 2, x14, 0x0000001c0000001c, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000000200000002; \
    li a2, 0x0000000300000003; \
    pmqacc.w.h00 x14, a1, a2 );

  # Test: 0x100 + (4 * 5) << 1 = 256 + 40 = 296 = 0x128
  TEST_CASE( 3, x14, 0x0000012800000128, \
    li x14, 0x0000010000000100; \
    li a1, 0x0000000400000004; \
    li a2, 0x0000000500000005; \
    pmqacc.w.h00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

