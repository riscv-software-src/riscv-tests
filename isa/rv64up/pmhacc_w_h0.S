# See LICENSE for license details.

#*****************************************************************************
# pmhacc_w_h0.S
#-----------------------------------------------------------------------------
#
# Test pmhacc.w.h0 instruction (packed multiply-high accumulate word h0, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhacc.w.h0 (per P-ext spec):
  #   p_i = sext_48(rs1.w_i) * sext_48(rs2.w_i[15:0])
  #   d_i = X[rd].w_i + p_i[47:16]
  # The multiplier is the LOW halfword of each rs2 word (bits[15:0] of the word).

  # Test 1: rs2.w_i[15:0] = 0x0000 (low halfword zero) -> p = 0, d = rd_init.
  TEST_CASE( 2, x14, 0x0000001000000010, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000010000000100; \
    li a2, 0x0001000000010000; \
    pmhacc.w.h0 x14, a1, a2 );

  # Test 2: rs2.w_i[15:0] = 0x0000 -> p = 0, d = rd_init = 0.
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000020000000200; \
    li a2, 0x0002000000020000; \
    pmhacc.w.h0 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
