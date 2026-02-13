# See LICENSE for license details.

#*****************************************************************************
# pmulqr_w.S
#-----------------------------------------------------------------------------
#
# Test pmulqr.w instruction (packed multiply Q31 rounding word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulqr.w rd, rs1, rs2 = ((rs1 * rs2) + 0x40000000) >> 31 for each 32-bit word
  # Q31 format with rounding

  # Test case 1: Q31 multiply with rounding
  # 0x40000000 * 0x40000000 + 0x40000000 >> 31 = 0x20000000
  TEST_RR_OP( 2, pmulqr.w, 0x2000000020000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values
  TEST_RR_OP( 3, pmulqr.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: Values showing rounding effect
  TEST_RR_OP( 4, pmulqr.w, 0x0800000008000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

