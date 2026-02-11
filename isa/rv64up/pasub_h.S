# See LICENSE for license details.

#*****************************************************************************
# pasub_h.S
#-----------------------------------------------------------------------------
#
# Test pasub.h instruction (packed halfword averaging subtract, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasub.h rd, rs1, rs2
  # Performs packed signed averaging subtract: rd[i] = (rs1[i] - rs2[i]) >> 1

  # Test case 1: Simple averaging (6 - 2) / 2 = 2
  TEST_RR_OP( 2, pasub.h, 0x0002000200020002, 0x0006000600060006, 0x0002000200020002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pasub.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values (4 - 4) / 2 = 0
  TEST_RR_OP( 4, pasub.h, 0x0000000000000000, 0x0004000400040004, 0x0004000400040004 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

