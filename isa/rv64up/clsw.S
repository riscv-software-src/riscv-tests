# See LICENSE for license details.

#*****************************************************************************
# clsw.S
#-----------------------------------------------------------------------------
#
# Test clsw instruction (count leading sign bits word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # clsw rd, rs1 - count leading sign bits of low 32 bits (excluding the sign bit itself)

  # Test case 1: All zeros (low 32 bits) - 31 leading sign bits
  TEST_R_OP( 2, clsw, 31, 0x0000000000000000 );

  # Test case 2: All ones (low 32 bits) - 31 leading sign bits
  TEST_R_OP( 3, clsw, 31, 0x00000000ffffffff );

  # Test case 4: Positive with some leading zeros
  TEST_R_OP( 4, clsw, 30, 0x0000000000000001 );

  # Test case 5: Negative with some leading ones
  TEST_R_OP( 5, clsw, 30, 0x00000000fffffffe );

  # Test case 6: 0x7fffffff - 0 leading sign bits
  TEST_R_OP( 6, clsw, 0, 0x000000007fffffff );

  # Test case 7: 0x80000000 - 0 leading sign bits
  TEST_R_OP( 7, clsw, 0, 0x0000000080000000 );

  # Test case 8: 0x0f000000 - 3 leading sign bits
  TEST_R_OP( 8, clsw, 3, 0x000000000f000000 );

  # Test case 9: 0xf0000000 - 3 leading sign bits
  TEST_R_OP( 9, clsw, 3, 0x00000000f0000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


