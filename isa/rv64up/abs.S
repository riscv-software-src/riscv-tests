# See LICENSE for license details.

#*****************************************************************************
# abs.S
#-----------------------------------------------------------------------------
#
# Test abs instruction (absolute value, RV64).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # abs rd, rs1 - absolute value (64-bit)

  # Test case 1: Negative value
  TEST_CASE( 2, x14, 5, li a1, -5; abs x14, a1 );

  # Test case 2: Positive value (unchanged)
  TEST_CASE( 3, x14, 5, li a1, 5; abs x14, a1 );

  # Test case 3: Zero
  TEST_CASE( 4, x14, 0, li a1, 0; abs x14, a1 );

  # Test case 4: Large negative value (64-bit)
  TEST_CASE( 5, x14, 0x7fffffffffffffff, li a1, 0x8000000000000001; abs x14, a1 );

  # Test case 5: -1
  TEST_CASE( 6, x14, 1, li a1, -1; abs x14, a1 );

  # Test case 6: 32-bit boundary negative (should work as 64-bit)
  TEST_CASE( 7, x14, 0x80000000, li a1, -0x80000000; abs x14, a1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

