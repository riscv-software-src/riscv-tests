# See LICENSE for license details.

#*****************************************************************************
# psslai_w.S
#-----------------------------------------------------------------------------
#
# Test psslai.w instruction (packed saturating shift left arithmetic immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psslai.w rd, rs1, imm
  # Performs packed word saturating shift left arithmetic by immediate

  # Test case 1: Shift left by 1 (no saturation)
  TEST_CASE( 2, x14, 0x0000000400000002, li a1, 0x0000000200000001; psslai.w x14, a1, 1 );

  # Test case 2: Shift left by 0 (no change)
  TEST_CASE( 3, x14, 0x0000000200000001, li a1, 0x0000000200000001; psslai.w x14, a1, 0 );

  # Test case 3: Shift left with positive saturation
  TEST_CASE( 4, x14, 0x7fffffff7fffffff, li a1, 0x4000000040000000; psslai.w x14, a1, 2 );

  # Test case 4: Shift left with negative saturation
  TEST_CASE( 5, x14, 0x8000000080000000, li a1, 0xc0000000c0000000; psslai.w x14, a1, 2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

