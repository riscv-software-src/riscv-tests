# See LICENSE for license details.

#*****************************************************************************
# padd_ws.S
#-----------------------------------------------------------------------------
#
# Test padd.ws instruction (packed word add with scalar, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.ws rd, rs1, rs2
  # Performs packed word addition with scalar broadcast:
  # rd[i] = rs1[i] + rs2[31:0] (low word broadcast to all elements)
  # Two 32-bit words in a 64-bit register

  # Test case 1: Simple scalar add (add 2 to both words)
  # rs1 = 0x0000000100000002, rs2[31:0] = 0x00000002
  # Expected: 0x0000000300000004
  TEST_RR_OP( 2, padd.ws, 0x0000000300000004, 0x0000000100000002, 0x0000000000000002 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.ws, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Add 1 to both words
  TEST_RR_OP( 4, padd.ws, 0x0000000600000006, 0x0000000500000005, 0x0000000000000001 );

  # Test case 4: Add 10 to both words
  TEST_RR_OP( 5, padd.ws, 0x0000001400000014, 0x0000000a0000000a, 0x000000000000000a );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

