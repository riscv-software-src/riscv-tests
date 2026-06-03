# See LICENSE for license details.

#*****************************************************************************
# pmulh_w_h0.S
#-----------------------------------------------------------------------------
#
# Test pmulh.w.h0 instruction (packed multiply high word, low halfword selection, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulh.w.h0 (per P-ext spec):
  #   d_w_i = (sext_48(rs1.w_i) * sext_48(rs2.w_i[15:0]))[47:16]
  # Multiplier is the LOW halfword of each rs2 word.

  # Test case 1: rs2.w_i[15:0]=0 -> p=0, d=0.
  TEST_RR_OP( 2, pmulh.w.h0, 0x0000000000000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: rs1.w=2, rs2.h0=3, p=6, [47:16]=0, d=0.
  TEST_RR_OP( 3, pmulh.w.h0, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: rs2.w_i[15:0]=0 -> p=0, d=0.
  TEST_RR_OP( 4, pmulh.w.h0, 0x0000000000000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
