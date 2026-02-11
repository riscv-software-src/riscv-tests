# See LICENSE for license details.

#*****************************************************************************
# pssub_h.S
#-----------------------------------------------------------------------------
#
# Test pssub.h instruction (packed halfword saturating subtract, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssub.h rd, rs1, rs2
  # Performs packed signed saturating subtract

  # Test case 1: Simple subtraction (no saturation)
  TEST_RR_OP( 2, pssub.h, 0x0001000200030004, 0x0002000300040005, 0x0001000100010001 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pssub.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Negative saturation (0x8000 - 0x7000 saturates to 0x8000)
  TEST_RR_OP( 4, pssub.h, 0x8000800080008000, 0x8000800080008000, 0x7000700070007000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

