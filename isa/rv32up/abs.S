# See LICENSE for license details.

#*****************************************************************************
# abs.S
#-----------------------------------------------------------------------------
#
# Test abs instruction (absolute value, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # abs rd, rs1 - absolute value

  # Test case 1: Negative value
  TEST_CASE( 2, x14, 5, li a1, -5; abs x14, a1 );

  # Test case 2: Positive value (unchanged)
  TEST_CASE( 3, x14, 5, li a1, 5; abs x14, a1 );

  # Test case 4: Zero
  TEST_CASE( 4, x14, 0, li a1, 0; abs x14, a1 );

  # Test case 5: Large negative value
  TEST_CASE( 5, x14, 0x7fffffff, li a1, 0x80000001; abs x14, a1 );

  # Test case 6: -1
  TEST_CASE( 6, x14, 1, li a1, -1; abs x14, a1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

