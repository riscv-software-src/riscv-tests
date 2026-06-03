# See LICENSE for license details.

#*****************************************************************************
# psub_b.S
#-----------------------------------------------------------------------------
#
# Test psub.b instruction (packed byte subtract).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psub.b rd, rs1, rs2
  # Performs packed byte subtraction: rd[i] = rs1[i] - rs2[i] for each byte

  # Test case 1: Simple subtraction
  # rs1 = 0x0203040506070809, rs2 = 0x0101010101010101
  # Expected: 0x0102030405060708
  TEST_RR_OP( 2, psub.b, 0x0102030405060708, 0x0203040506070809, 0x0101010101010101 );

  # Test case 2: Zero - Zero = Zero
  TEST_RR_OP( 3, psub.b, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Underflow within byte (wraps around)
  # 0x00 - 0x01 = 0xFF (with wrap)
  TEST_RR_OP( 4, psub.b, 0xffffffffffffffff, 0x0000000000000000, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

