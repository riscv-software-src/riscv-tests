# See LICENSE for license details.

#*****************************************************************************
# psrai_w.S
#-----------------------------------------------------------------------------
#
# Test psrai.w instruction (packed shift right arithmetic immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psrai.w rd, rs1, imm
  # Performs packed word shift right arithmetic by immediate

  # Test case 1: Shift right by 1
  TEST_CASE( 2, x14, 0x0000000100000000, li a1, 0x0000000200000001; psrai.w x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x0000000200000001, li a1, 0x0000000200000001; psrai.w x14, a1, 0 );

  # Test case 3: Shift right by 4 with sign extension
  TEST_CASE( 4, x14, 0xf8000000f8000000, li a1, 0x8000000080000000; psrai.w x14, a1, 4 );

  # Test case 4: Positive value shift
  TEST_CASE( 5, x14, 0x0400000004000000, li a1, 0x4000000040000000; psrai.w x14, a1, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

