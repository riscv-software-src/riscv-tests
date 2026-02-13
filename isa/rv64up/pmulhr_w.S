# See LICENSE for license details.

#*****************************************************************************
# pmulhr_w.S
#-----------------------------------------------------------------------------
#
# Test pmulhr.w instruction (packed multiply high rounding word signed, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhr.w rd, rs1, rs2 = ((sext(rs1) * sext(rs2)) >> 31 + 1) >> 1 for each 32-bit word

  # Test case 1: Large values
  TEST_RR_OP( 2, pmulhr.w, 0x2000000020000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values
  TEST_RR_OP( 3, pmulhr.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: Values that show rounding
  TEST_RR_OP( 4, pmulhr.w, 0x0800000008000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

