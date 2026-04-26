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

  # pmulhru.w rd, rs1, rs2 = ((zext(rs1) * zext(rs2)) >> 31 + 1) >> 1 for each 32-bit word

  # Test case 1: Large values
  TEST_RR_OP( 2, pmulhru.w, 0x2000000020000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values
  TEST_RR_OP( 3, pmulhru.w, 0x0000000000000000, 0x0000000200000002, 0x0000000300000003 );

  # Test case 3: Unsigned large values (0x80000000 treated as positive)
  TEST_RR_OP( 4, pmulhru.w, 0x8000000080000000, 0x8000000080000000, 0x8000000080000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

