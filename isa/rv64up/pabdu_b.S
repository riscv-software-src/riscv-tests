# See LICENSE for license details.

#*****************************************************************************
# pabdu_b.S
#-----------------------------------------------------------------------------
#
# Test pabdu.b instruction (packed unsigned absolute difference byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pabdu.b rd, rs1, rs2
  # Performs packed unsigned absolute difference: rd[i] = |rs1[i] - rs2[i]| for each byte

  # Test case 1: Simple absolute difference (5 - 3 = 2)
  # rs1 = 0x0505050505050505, rs2 = 0x0303030303030303
  # Expected: 0x0202020202020202
  TEST_RR_OP( 2, pabdu.b, 0x0202020202020202, 0x0505050505050505, 0x0303030303030303 );

  # Test case 2: Reverse order (3 - 5 = |-2| = 2)
  # rs1 = 0x0303030303030303, rs2 = 0x0505050505050505
  # Expected: 0x0202020202020202
  TEST_RR_OP( 3, pabdu.b, 0x0202020202020202, 0x0303030303030303, 0x0505050505050505 );

  # Test case 3: Zero difference
  TEST_RR_OP( 4, pabdu.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

