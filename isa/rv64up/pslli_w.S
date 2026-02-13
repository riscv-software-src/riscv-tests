# See LICENSE for license details.

#*****************************************************************************
# pslli_w.S
#-----------------------------------------------------------------------------
#
# Test pslli.w instruction (packed shift left logical immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # pslli.w rd, rs1, imm
  # Performs packed word shift left logical by immediate

  # Test case 1: Shift left by 1
  TEST_CASE( 2, x14, 0x0000000400000002, li a1, 0x0000000200000001; pslli.w x14, a1, 1 );

  # Test case 2: Shift left by 0 (no change)
  TEST_CASE( 3, x14, 0x0000000200000001, li a1, 0x0000000200000001; pslli.w x14, a1, 0 );

  # Test case 3: Shift left by 4
  TEST_CASE( 4, x14, 0x0000002000000010, li a1, 0x0000000200000001; pslli.w x14, a1, 4 );

  # Test case 4: Shift left by 16
  TEST_CASE( 5, x14, 0x0002000000010000, li a1, 0x0000000200000001; pslli.w x14, a1, 16 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

