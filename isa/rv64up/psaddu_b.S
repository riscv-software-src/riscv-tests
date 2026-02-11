# See LICENSE for license details.

#*****************************************************************************
# psaddu_b.S
#-----------------------------------------------------------------------------
#
# Test psaddu.b instruction (packed byte saturating add, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psaddu.b rd, rs1, rs2
  # Performs packed unsigned saturating add

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP( 2, psaddu.b, 0x0203040506070809, 0x0102030405060708, 0x0101010101010101 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, psaddu.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned saturation (0xF0 + 0xF0 saturates to 0xFF)
  TEST_RR_OP( 4, psaddu.b, 0xffffffffffffffff, 0xf0f0f0f0f0f0f0f0, 0xf0f0f0f0f0f0f0f0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

