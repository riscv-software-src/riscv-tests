# See LICENSE for license details.

#*****************************************************************************
# psslai_h.S
#-----------------------------------------------------------------------------
#
# Test psslai.h instruction (packed saturating shift left arithmetic immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psslai.h rd, rs1, imm
  # Performs packed halfword saturating shift left by immediate

  # Test case 1: Shift left by 1 (no saturation)
  TEST_CASE( 2, x14, 0x0002000400060008, li a1, 0x0001000200030004; psslai.h x14, a1, 1 );

  # Test case 2: Shift by 0 (no change)
  TEST_CASE( 3, x14, 0x0001000200030004, li a1, 0x0001000200030004; psslai.h x14, a1, 0 );

  # Test case 3: Shift with saturation (0x7000 << 4 saturates to 0x7FFF)
  TEST_CASE( 4, x14, 0x7fff7fff7fff7fff, li a1, 0x7000700070007000; psslai.h x14, a1, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


