# See LICENSE for license details.

#*****************************************************************************
# pmacc_w_h00.S
#-----------------------------------------------------------------------------
#
# Test pmacc.w.h00 instruction (packed multiply-accumulate word, h0*h0, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmacc.w.h00: packed multiply-accumulate for words using low halfwords
  # rd[i] += sext(rs1[i].h0) * sext(rs2[i].h0) for each 32-bit word

  # Test: 0x10 + (2 * 3) = 16 + 6 = 22 = 0x16
  TEST_CASE( 2, x14, 0x0000001600000016, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000000200000002; \
    li a2, 0x0000000300000003; \
    pmacc.w.h00 x14, a1, a2 );

  # Test: 0x100 + (4 * 5) = 256 + 20 = 276 = 0x114
  TEST_CASE( 3, x14, 0x0000011400000114, \
    li x14, 0x0000010000000100; \
    li a1, 0x0000000400000004; \
    li a2, 0x0000000500000005; \
    pmacc.w.h00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

