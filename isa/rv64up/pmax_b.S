# See LICENSE for license details.

#*****************************************************************************
# pmax_b.S
#-----------------------------------------------------------------------------
#
# Test pmax.b instruction (packed max byte signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmax.b rd, rs1, rs2
  # Performs packed signed max: rd[i] = max(rs1[i], rs2[i]) for each byte

  # Test case 1: Simple max (5 vs 3 = 5)
  TEST_RR_OP( 2, pmax.b, 0x0505050505050505, 0x0505050505050505, 0x0303030303030303 );

  # Test case 2: Reverse order (3 vs 5 = 5)
  TEST_RR_OP( 3, pmax.b, 0x0505050505050505, 0x0303030303030303, 0x0505050505050505 );

  # Test case 3: Equal values
  TEST_RR_OP( 4, pmax.b, 0x0404040404040404, 0x0404040404040404, 0x0404040404040404 );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = 1)
  # 0xff = -1, 0x01 = 1
  TEST_RR_OP( 5, pmax.b, 0x0101010101010101, 0xffffffffffffffff, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


