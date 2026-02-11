# See LICENSE for license details.

#*****************************************************************************
# cls.S
#-----------------------------------------------------------------------------
#
# Test cls instruction (count leading sign bits, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # cls rd, rs1 - count leading sign bits (excluding the sign bit itself)

  # Test case 1: All zeros - 31 leading sign bits
  TEST_R_OP( 2, cls, 31, 0x00000000 );

  # Test case 2: All ones - 31 leading sign bits
  TEST_R_OP( 3, cls, 31, 0xffffffff );

  # Test case 4: Positive with some leading zeros
  TEST_R_OP( 4, cls, 30, 0x00000001 );

  # Test case 5: Negative with some leading ones
  TEST_R_OP( 5, cls, 30, 0xfffffffe );

  # Test case 6: 0x7fffffff - 0 leading sign bits
  TEST_R_OP( 6, cls, 0, 0x7fffffff );

  # Test case 7: 0x80000000 - 0 leading sign bits
  TEST_R_OP( 7, cls, 0, 0x80000000 );

  # Test case 8: 0x0f000000 - 3 leading sign bits
  TEST_R_OP( 8, cls, 3, 0x0f000000 );

  # Test case 9: 0xf0000000 - 3 leading sign bits
  TEST_R_OP( 9, cls, 3, 0xf0000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

