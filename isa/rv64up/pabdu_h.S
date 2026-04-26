# See LICENSE for license details.

#*****************************************************************************
# pabdu_h.S
#-----------------------------------------------------------------------------
#
# Test pabdu.h instruction (packed unsigned absolute difference halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pabdu.h rd, rs1, rs2
  # Performs packed unsigned absolute difference: rd[i] = |rs1[i] - rs2[i]| for each halfword

  # Test case 1: Simple absolute difference (5 - 3 = 2)
  # rs1 = 0x0005000500050005, rs2 = 0x0003000300030003
  # Expected: 0x0002000200020002
  TEST_RR_OP( 2, pabdu.h, 0x0002000200020002, 0x0005000500050005, 0x0003000300030003 );

  # Test case 2: Reverse order (3 - 5 = |-2| = 2)
  # rs1 = 0x0003000300030003, rs2 = 0x0005000500050005
  # Expected: 0x0002000200020002
  TEST_RR_OP( 3, pabdu.h, 0x0002000200020002, 0x0003000300030003, 0x0005000500050005 );

  # Test case 3: Zero difference
  TEST_RR_OP( 4, pabdu.h, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

