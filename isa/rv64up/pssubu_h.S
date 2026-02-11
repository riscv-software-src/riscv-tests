# See LICENSE for license details.

#*****************************************************************************
# pssubu_h.S
#-----------------------------------------------------------------------------
#
# Test pssubu.h instruction (packed halfword saturating subtract, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssubu.h rd, rs1, rs2
  # Performs packed unsigned saturating subtract

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, pssubu.h, 0x0001000200030004, 0x0002000300040005, 0x0001000100010001 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pssubu.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned saturation (0x1000 - 0x2000 saturates to 0x0000)
  TEST_RR_OP( 4, pssubu.h, 0x0000000000000000, 0x1000100010001000, 0x2000200020002000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

