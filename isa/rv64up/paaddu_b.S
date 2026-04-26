# See LICENSE for license details.

#*****************************************************************************
# paaddu_b.S
#-----------------------------------------------------------------------------
#
# Test paaddu.b instruction (packed byte averaging add, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paaddu.b rd, rs1, rs2
  # Performs packed unsigned averaging add: rd[i] = (rs1[i] + rs2[i]) >> 1

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, paaddu.b, 0x0303030303030303, 0x0404040404040404, 0x0202020202020202 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paaddu.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned averaging (0x80 + 0x80) / 2 = 0x80
  TEST_RR_OP( 4, paaddu.b, 0x8080808080808080, 0x8080808080808080, 0x8080808080808080 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

