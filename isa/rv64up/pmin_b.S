# See LICENSE for license details.

#*****************************************************************************
# pmin_b.S
#-----------------------------------------------------------------------------
#
# Test pmin.b instruction (packed min byte signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmin.b rd, rs1, rs2
  # Performs packed signed min: rd[i] = min(rs1[i], rs2[i]) for each byte

  # Test case 1: Simple min (5 vs 3 = 3)
  TEST_RR_OP( 2, pmin.b, 0x0303030303030303, 0x0505050505050505, 0x0303030303030303 );

  # Test case 2: Reverse order (3 vs 5 = 3)
  TEST_RR_OP( 3, pmin.b, 0x0303030303030303, 0x0303030303030303, 0x0505050505050505 );

  # Test case 3: Equal values
  TEST_RR_OP( 4, pmin.b, 0x0404040404040404, 0x0404040404040404, 0x0404040404040404 );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = -1)
  # 0xff = -1, 0x01 = 1
  TEST_RR_OP( 5, pmin.b, 0xffffffffffffffff, 0xffffffffffffffff, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


