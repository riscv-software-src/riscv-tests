# See LICENSE for license details.

#*****************************************************************************
# aadd.S
#-----------------------------------------------------------------------------
#
# Test aadd instruction (signed averaging add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # aadd rd, rs1, rs2 = (rs1 + rs2) >> 1 (signed)

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, aadd, 0x00000003, 0x00000004, 0x00000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, aadd, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Odd sum (5 + 4) / 2 = 4 (truncated)
  TEST_RR_OP( 4, aadd, 0x00000004, 0x00000005, 0x00000004 );

  # Test case 4: Negative odd sum — floor rounding (-1 + 0) >> 1 = floor(-0.5) = -1
  # Truncation toward 0 would give 0; floor gives -1. This verifies floor semantics.
  TEST_RR_OP( 5, aadd, 0xffffffff, 0xffffffff, 0x00000000 );

  # Test case 5: Negative odd sum (-3 + 0) >> 1 = floor(-1.5) = -2
  # Truncation toward 0 would give -1; floor gives -2.
  TEST_RR_OP( 6, aadd, 0xfffffffe, 0xfffffffd, 0x00000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

