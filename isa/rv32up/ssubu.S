# See LICENSE for license details.

#*****************************************************************************
# ssubu.S
#-----------------------------------------------------------------------------
#
# Test ssubu instruction (unsigned saturating subtract).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # ssubu rd, rs1, rs2 = sat(rs1 - rs2) (unsigned)

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, ssubu, 0x00000002, 0x00000006, 0x00000004 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, ssubu, 0x00000000, 0x00000000, 0x00000000 );

  # Test case 3: Unsigned saturation (0x10000000 - 0x20000000 saturates to 0x00000000)
  TEST_RR_OP( 4, ssubu, 0x00000000, 0x10000000, 0x20000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

