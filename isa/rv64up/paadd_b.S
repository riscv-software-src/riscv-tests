# See LICENSE for license details.

#*****************************************************************************
# paadd_b.S
#-----------------------------------------------------------------------------
#
# Test paadd.b instruction (packed byte averaging add, signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paadd.b rd, rs1, rs2
  # Performs packed signed averaging add: rd[i] = (rs1[i] + rs2[i]) >> 1

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, paadd.b, 0x0303030303030303, 0x0404040404040404, 0x0202020202020202 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paadd.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Averaging with odd sum (5 + 4) / 2 = 4 (truncated)
  TEST_RR_OP( 4, paadd.b, 0x0404040404040404, 0x0505050505050505, 0x0404040404040404 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

