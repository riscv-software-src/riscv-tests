# See LICENSE for license details.

#*****************************************************************************
# mulhr.S
#-----------------------------------------------------------------------------
#
# Test mulhr instruction (signed high multiply with rounding).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulhr rd, rs1, rs2 = ((sext64(rs1) * sext64(rs2)) >> 31 + 1) >> 1

  # Test case 1: Simple multiply with rounding
  TEST_RR_OP( 2, mulhr, 0x00000000, 0x00000002, 0x00000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulhr, 0x00000000, 0x00000000, 0x00000005 );

  # Test case 3: Large values
  TEST_RR_OP( 4, mulhr, 0x3fffffff, 0x7fffffff, 0x7fffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

