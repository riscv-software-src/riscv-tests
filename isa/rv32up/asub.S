# See LICENSE for license details.

#*****************************************************************************
# asub.S
#-----------------------------------------------------------------------------
#
# Test asub instruction (signed averaging subtract).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # asub rd, rs1, rs2 = (rs1 - rs2) >> 1 (signed)

  # Test case 1: Simple averaging (6 - 2) / 2 = 2
  TEST_RR_OP( 2, asub, 0x00000002, 0x00000006, 0x00000002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, asub, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Same values (4 - 4) / 2 = 0
  TEST_RR_OP( 4, asub, 0x00000000, 0x00000004, 0x00000004 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

