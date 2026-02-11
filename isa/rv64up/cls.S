# See LICENSE for license details.

#*****************************************************************************
# cls.S
#-----------------------------------------------------------------------------
#
# Test cls instruction (count leading sign bits, RV64).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # cls rd, rs1 - count leading sign bits (excluding the sign bit itself)
  # For 64-bit, max is 63

  # Test case 1: All zeros - 63 leading sign bits
  TEST_CASE( 2, x14, 63, li a1, 0x0000000000000000; cls x14, a1 );

  # Test case 2: All ones - 63 leading sign bits
  TEST_CASE( 3, x14, 63, li a1, 0xffffffffffffffff; cls x14, a1 );

  # Test case 3: Positive with some leading zeros
  TEST_CASE( 4, x14, 62, li a1, 0x0000000000000001; cls x14, a1 );

  # Test case 4: Negative with some leading ones
  TEST_CASE( 5, x14, 62, li a1, 0xfffffffffffffffe; cls x14, a1 );

  # Test case 5: 0x7fffffffffffffff - 0 leading sign bits
  TEST_CASE( 6, x14, 0, li a1, 0x7fffffffffffffff; cls x14, a1 );

  # Test case 6: 0x8000000000000000 - 0 leading sign bits
  TEST_CASE( 7, x14, 0, li a1, 0x8000000000000000; cls x14, a1 );

  # Test case 7: 0x0f00000000000000 - 3 leading sign bits
  TEST_CASE( 8, x14, 3, li a1, 0x0f00000000000000; cls x14, a1 );

  # Test case 8: 0xf000000000000000 - 3 leading sign bits
  TEST_CASE( 9, x14, 3, li a1, 0xf000000000000000; cls x14, a1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

