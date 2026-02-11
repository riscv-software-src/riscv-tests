# See LICENSE for license details.

#*****************************************************************************
# pslli_h.S
#-----------------------------------------------------------------------------
#
# Test pslli.h instruction (packed shift left logical immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pslli.h rd, rs1, imm
  # Performs packed halfword shift left logical by immediate

  # Test case 1: Shift left by 1
  TEST_CASE( 2, x14, 0x0002000400060008, li a1, 0x0001000200030004; pslli.h x14, a1, 1 );

  # Test case 2: Shift left by 0 (no change)
  TEST_CASE( 3, x14, 0x0001000200030004, li a1, 0x0001000200030004; pslli.h x14, a1, 0 );

  # Test case 3: Shift left by 4
  TEST_CASE( 4, x14, 0x0010002000300040, li a1, 0x0001000200030004; pslli.h x14, a1, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


