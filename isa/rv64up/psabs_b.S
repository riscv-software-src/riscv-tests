# See LICENSE for license details.

#*****************************************************************************
# psabs_b.S
#-----------------------------------------------------------------------------
#
# Test psabs.b instruction (packed saturating absolute byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psabs.b rd, rs1
  # Performs packed saturating absolute value: rd[i] = |rs1[i]| for each byte (signed)

  # Test case 1: Positive values remain unchanged
  # rs1 = 0x0505050505050505
  # Expected: 0x0505050505050505
  TEST_R_OP( 2, psabs.b, 0x0505050505050505, 0x0505050505050505 );

  # Test case 2: Negative values become positive (-5 -> 5, 0xFB -> 0x05)
  # rs1 = 0xfbfbfbfbfbfbfbfb (-5 in each byte)
  # Expected: 0x0505050505050505
  TEST_R_OP( 3, psabs.b, 0x0505050505050505, 0xfbfbfbfbfbfbfbfb );

  # Test case 3: Zero remains zero
  TEST_R_OP( 4, psabs.b, 0x0000000000000000, 0x0000000000000000 );

  # Test case 4: Most negative value saturates (0x80 -> 0x7F)
  # rs1 = 0x8080808080808080 (-128 in each byte)
  # Expected: 0x7f7f7f7f7f7f7f7f (saturates to 127)
  TEST_R_OP( 5, psabs.b, 0x7f7f7f7f7f7f7f7f, 0x8080808080808080 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

