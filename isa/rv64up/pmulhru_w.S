# See LICENSE for license details.

#*****************************************************************************
# pmulhru_w.S
#-----------------------------------------------------------------------------
#
# Test pmulhru.w instruction (packed multiply high rounding word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhru.w (per P-ext spec):
  #   d_w_i = (zext_64(rs1.w_i) * zext_64(rs2.w_i) + 2^31)[63:32]

  # Test case 1: 0x40000000 * 0x40000000 = 2^60, [63:32]=0x10000000.
  TEST_RR_OP( 2, pmulhru.w, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: small values, [63:32]=0.
  TEST_RR_OP( 3, pmulhru.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: 0x80000000 * 0x80000000 (unsigned) = 2^62, [63:32]=0x40000000.
  TEST_RR_OP( 4, pmulhru.w, 0x4000000040000000, 0x8000000080000000, 0x8000000080000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
