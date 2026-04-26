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

  # pmulhrsu.w rd, rs1, rs2 = ((sext(rs1) * zext(rs2)) >> 31 + 1) >> 1 for each 32-bit word

  # Test case 1: Large positive values
  TEST_RR_OP( 2, pmulhrsu.w, 0x2000000020000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values
  TEST_RR_OP( 3, pmulhrsu.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: Signed * unsigned
  TEST_RR_OP( 4, pmulhrsu.w, 0x0800000008000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

