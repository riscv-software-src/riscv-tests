# See LICENSE for license details.

#*****************************************************************************
# mulq.S
#-----------------------------------------------------------------------------
#
# Test mulq instruction (Q-format signed multiply).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mulq rd, rs1, rs2 = (rs1 * rs2) >> 31 (with saturation)

  # Test case 1: Simple Q-format multiply
  TEST_RR_OP( 2, mulq, 0x00000000, 0x00000002, 0x00000003 );

  # Test case 2: Zero multiply
  TEST_RR_OP( 3, mulq, 0x00000000, 0x00000000, 0x00000005 );

  # Test case 3: Large positive values
  TEST_RR_OP( 4, mulq, 0x3fffffff, 0x7fffffff, 0x7fffffff );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

