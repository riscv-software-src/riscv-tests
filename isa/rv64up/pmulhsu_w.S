# See LICENSE for license details.

#*****************************************************************************
# pmulhsu_w.S
#-----------------------------------------------------------------------------
#
# Test pmulhsu.w instruction (packed multiply high word signed*unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhsu.w (per P-ext spec):
  #   d_w_i = (sext_64(rs1.w_i) * zext_64(rs2.w_i))[63:32]

  # Test case 1: 0x40000000 * 0x40000000 = 2^60, [63:32]=0x10000000.
  TEST_RR_OP( 2, pmulhsu.w, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: 2 * 3 = 6, [63:32]=0.
  TEST_RR_OP( 3, pmulhsu.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: -1 (signed) * 2 (unsigned) = -2, [63:32]=0xFFFFFFFF.
  TEST_RR_OP( 4, pmulhsu.w, 0xffffffffffffffff, 0xffffffffffffffff, 0x0000000200000002 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
