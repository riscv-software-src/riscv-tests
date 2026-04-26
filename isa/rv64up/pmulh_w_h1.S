# See LICENSE for license details.

#*****************************************************************************
# pmulh_w_h1.S
#-----------------------------------------------------------------------------
#
# Test pmulh.w.h1 instruction (packed multiply high word, high halfword selection, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pmulh.w.h1 rd, rs1, rs2 = multiply high using high halfword of each word

  # Test case 1: Large values
  TEST_RR_OP( 2, pmulh.w.h1, 0x1000000010000000, 0x4000000040000000, 0x4000000040000000 );

  # Test case 2: Small values
  TEST_RR_OP( 3, pmulh.w.h1, 0x0000000000000000, 0x0002000000020000, 0x0003000000030000 );

  # Test case 3: Mixed values
  TEST_RR_OP( 4, pmulh.w.h1, 0x0400000004000000, 0x2000000020000000, 0x2000000020000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

