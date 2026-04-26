# See LICENSE for license details.

#*****************************************************************************
# pmulhu_w.S
#-----------------------------------------------------------------------------
#
# Test pmulhu.w instruction (packed multiply high word unsigned, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulhu.w rd, rs1, rs2 = (zext(rs1) * zext(rs2)) >> 32 for each 32-bit word

  # Test case 1: Large values
  TEST_RR_OP( 2, pmulhu.w, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values
  TEST_RR_OP( 3, pmulhu.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: Unsigned large values (0x80000000 * 0x80000000)
  TEST_RR_OP( 4, pmulhu.w, 0x4000000040000000, 0x8000000080000000, 0x8000000080000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

