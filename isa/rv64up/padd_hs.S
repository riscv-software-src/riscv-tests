# See LICENSE for license details.

#*****************************************************************************
# padd_hs.S
#-----------------------------------------------------------------------------
#
# Test padd.hs instruction (packed halfword add with saturation to signed).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.hs rd, rs1, rs2
  # Performs packed halfword addition with signed saturation

  # Test case 1: Simple addition (no saturation)
  TEST_RR_OP( 2, padd.hs, 0x0002000300040005, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Zero + Zero = Zero
  TEST_RR_OP( 3, padd.hs, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 );

  # Test case 3: Positive saturation (0x7000 + 0x7000 = 0x7FFF saturated)
  TEST_RR_OP( 4, padd.hs, 0x7fff7fff7fff7fff, 0x7000700070007000, 0x7000700070007000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

