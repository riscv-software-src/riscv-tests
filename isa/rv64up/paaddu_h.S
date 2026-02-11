# See LICENSE for license details.

#*****************************************************************************
# paaddu_h.S
#-----------------------------------------------------------------------------
#
# Test paaddu.h instruction (packed halfword averaging add, unsigned).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paaddu.h rd, rs1, rs2
  # Performs packed unsigned averaging add: rd[i] = (rs1[i] + rs2[i]) >> 1

  # Test case 1: Simple averaging (4 + 2) / 2 = 3
  TEST_RR_OP( 2, paaddu.h, 0x0003000300030003, 0x0004000400040004, 0x0002000200020002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, paaddu.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Unsigned averaging (0x8000 + 0x8000) / 2 = 0x8000
  TEST_RR_OP( 4, paaddu.h, 0x8000800080008000, 0x8000800080008000, 0x8000800080008000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

