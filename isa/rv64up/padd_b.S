# See LICENSE for license details.

#*****************************************************************************
# padd_b.S
#-----------------------------------------------------------------------------
#
# Test padd.b instruction (packed byte add).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.b rd, rs1, rs2
  # Performs packed byte addition: rd[i] = rs1[i] + rs2[i] for each byte

  # Test case 1: Simple addition
  # rs1 = 0x0102030405060708, rs2 = 0x0101010101010101
  # Expected: 0x0203040506070809
  TEST_RR_OP( 2, padd.b, 0x0203040506070809, 0x0102030405060708, 0x0101010101010101 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Overflow within byte (wraps around)
  # 0xFF + 0x01 = 0x00 (with wrap)
  TEST_RR_OP( 4, padd.b, 0x0000000000000000, 0xffffffffffffffff, 0x0101010101010101 );

  # Test case 4: Mixed values
  TEST_RR_OP( 5, padd.b, 0x8080808080808080, 0x4040404040404040, 0x4040404040404040 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

