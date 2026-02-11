# See LICENSE for license details.

#*****************************************************************************
# pasub_b.S
#-----------------------------------------------------------------------------
#
# Test pasub.b instruction (packed byte averaging subtract, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasub.b rd, rs1, rs2
  # Performs packed signed averaging subtract: rd[i] = (rs1[i] - rs2[i]) >> 1

  # Test case 1: Simple averaging (6 - 2) / 2 = 2
  TEST_RR_OP( 2, pasub.b, 0x0202020202020202, 0x0606060606060606, 0x0202020202020202 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pasub.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values (4 - 4) / 2 = 0
  TEST_RR_OP( 4, pasub.b, 0x0000000000000000, 0x0404040404040404, 0x0404040404040404 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

