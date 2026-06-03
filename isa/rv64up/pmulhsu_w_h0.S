# See LICENSE for license details.

#*****************************************************************************
# pmulhsu_w_h0.S
#-----------------------------------------------------------------------------
#
# Test pmulhsu.w.h0 instruction (packed multiply high word signed*unsigned, low halfword, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhsu.w.h0 (per P-ext spec):
  #   d_w_i = (sext_48(rs1.w_i) * zext_48(rs2.w_i[15:0]))[47:16]

  # Test case 1: rs2.w_i[15:0]=0 -> d=0.
  TEST_RR_OP( 2, pmulhsu.w.h0, 0x0000000000000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: small values, [47:16]=0.
  TEST_RR_OP( 3, pmulhsu.w.h0, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: rs2.w_i[15:0]=0 -> d=0.
  TEST_RR_OP( 4, pmulhsu.w.h0, 0x0000000000000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
