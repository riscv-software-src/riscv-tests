# See LICENSE for license details.

#*****************************************************************************
# pssubu_b.S
#-----------------------------------------------------------------------------
#
# Test pssubu.b instruction (packed byte saturating subtract, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssubu.b rd, rs1, rs2
  # Performs packed unsigned saturating subtract

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, pssubu.b, 0x0102030405060708, 0x0203040506070809, 0x0101010101010101 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pssubu.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned saturation (0x10 - 0x20 saturates to 0x00)
  TEST_RR_OP( 4, pssubu.b, 0x0000000000000000, 0x1010101010101010, 0x2020202020202020 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

