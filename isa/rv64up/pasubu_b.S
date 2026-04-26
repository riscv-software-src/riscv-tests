# See LICENSE for license details.

#*****************************************************************************
# pasubu_b.S
#-----------------------------------------------------------------------------
#
# Test pasubu.b instruction (packed byte averaging subtract, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasubu.b rd, rs1, rs2
  # Performs packed unsigned averaging subtract: rd[i] = (rs1[i] - rs2[i]) >> 1

  # Test case 1: Simple averaging (6 - 2) / 2 = 2
  TEST_RR_OP( 2, pasubu.b, 0x0202020202020202, 0x0606060606060606, 0x0202020202020202 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, pasubu.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Same values (0x80 - 0x80) / 2 = 0
  TEST_RR_OP( 4, pasubu.b, 0x0000000000000000, 0x8080808080808080, 0x8080808080808080 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

