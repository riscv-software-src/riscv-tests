# See LICENSE for license details.

#*****************************************************************************
# psabs_h.S
#-----------------------------------------------------------------------------
#
# Test psabs.h instruction (packed saturating absolute halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psabs.h rd, rs1
  # Performs packed saturating absolute value: rd[i] = |rs1[i]| for each halfword (signed)

  # Test case 1: Positive values remain unchanged
  # rs1 = 0x0005000500050005
  # Expected: 0x0005000500050005
  TEST_R_OP( 2, psabs.h, 0x0005000500050005, 0x0005000500050005 );

  # Test case 2: Negative values become positive (-5 -> 5, 0xFFFB -> 0x0005)
  # rs1 = 0xfffbfffbfffbfffb (-5 in each halfword)
  # Expected: 0x0005000500050005
  TEST_R_OP( 3, psabs.h, 0x0005000500050005, 0xfffbfffbfffbfffb );

  # Test case 3: Zero remains zero
  TEST_R_OP( 4, psabs.h, 0x0000000000000000, 0x0000000000000000 );

  # Test case 4: Most negative value saturates (0x8000 -> 0x7FFF)
  # rs1 = 0x8000800080008000 (-32768 in each halfword)
  # Expected: 0x7fff7fff7fff7fff (saturates to 32767)
  TEST_R_OP( 5, psabs.h, 0x7fff7fff7fff7fff, 0x8000800080008000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

