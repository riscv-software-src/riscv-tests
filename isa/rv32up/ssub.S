# See LICENSE for license details.

#*****************************************************************************
# ssub.S
#-----------------------------------------------------------------------------
#
# Test ssub instruction (signed saturating subtract).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ssub rd, rs1, rs2 = sat(rs1 - rs2) (signed)

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, ssub, 0x00000002, 0x00000006, 0x00000004 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, ssub, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Negative saturation (0x80000000 - 0x70000000 saturates to 0x80000000)
  TEST_RR_OP( 4, ssub, 0x80000000, 0x80000000, 0x70000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

