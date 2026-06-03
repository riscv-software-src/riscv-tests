# See LICENSE for license details.

#*****************************************************************************
# mulhru.S
#-----------------------------------------------------------------------------
#
# Test mulhru instruction (unsigned high multiply with rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulhru rd, rs1, rs2 = ((zext(rs1) * zext(rs2)) >> 31 + 1) >> 1

  # Test case 1: Simple multiply with rounding
  TEST_RR_OP( 2, mulhru, 0x00000000, 0x00000002, 0x00000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulhru, 0x00000000, 0x00000000, 0x00000005 );

  # Test case 3: Large unsigned values
  TEST_RR_OP( 4, mulhru, 0x7fffffff, 0xffffffff, 0x7fffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

