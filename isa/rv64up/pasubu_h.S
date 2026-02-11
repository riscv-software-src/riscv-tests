# See LICENSE for license details.

#*****************************************************************************
# pasubu_h.S
#-----------------------------------------------------------------------------
#
# Test pasubu.h instruction (packed halfword averaging subtract, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasubu.h rd, rs1, rs2
  # Performs packed unsigned averaging subtract: rd[i] = (rs1[i] - rs2[i]) >> 1

  # Test case 1: Simple averaging (6 - 2) / 2 = 2
  TEST_RR_OP( 2, pasubu.h, 0x0002000200020002, 0x0006000600060006, 0x0002000200020002 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pasubu.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values (0x8000 - 0x8000) / 2 = 0
  TEST_RR_OP( 4, pasubu.h, 0x0000000000000000, 0x8000800080008000, 0x8000800080008000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

