# See LICENSE for license details.

#*****************************************************************************
# pmulhrsu_w.S
#-----------------------------------------------------------------------------
#
# Test pmulhrsu.w instruction (packed multiply high rounding word signed*unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhrsu.w (per P-ext spec):
  #   d_w_i = (sext_64(rs1.w_i) * zext_64(rs2.w_i) + 2^31)[63:32]

  # Test case 1: signed 0x40000000 * unsigned 0x40000000 = 2^60, [63:32]=0x10000000.
  TEST_RR_OP( 2, pmulhrsu.w, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: small values, [63:32]=0.
  TEST_RR_OP( 3, pmulhrsu.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: signed 0x20000000 * unsigned 0x20000000 = 2^58, [63:32]=0x04000000.
  TEST_RR_OP( 4, pmulhrsu.w, 0x0400000004000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
