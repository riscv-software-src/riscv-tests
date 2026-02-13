# See LICENSE for license details.

#*****************************************************************************
# pssh1sadd_w.S
#-----------------------------------------------------------------------------
#
# Test pssh1sadd.w instruction (packed word saturating shift-1-and-add, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pssh1sadd.w rd, rs1, rs2
  # Performs packed saturating shift-1-and-add: rd[i] = sat((sat(rs1[i] << 1)) + rs2[i])

  # Test case 1: Simple shift and add (2 << 1) + 1 = 5 (no saturation)
  TEST_RR_OP( 2, pssh1sadd.w, 0x0000000500000005, 0x0000000200000002, 0x0000000100000001 );

  # Test case 2: Zero operations
  TEST_RR_OP( 3, pssh1sadd.w, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Saturation on shift (0x40000000 << 1 saturates to 0x7FFFFFFF)
  # 0x7FFFFFFF + 0 = 0x7FFFFFFF
  TEST_RR_OP( 4, pssh1sadd.w, 0x7fffffff7fffffff, 0x4000000040000000, 0x0000000000000000 );

  # Test case 4: Saturation on add
  # (0x3FFFFFFF << 1) + 0x10000000 = 0x7FFFFFFE + 0x10000000 saturates to 0x7FFFFFFF
  TEST_RR_OP( 5, pssh1sadd.w, 0x7fffffff7fffffff, 0x3fffffff3fffffff, 0x1000000010000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

