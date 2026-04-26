# See LICENSE for license details.

#*****************************************************************************
# psll_hs.S
#-----------------------------------------------------------------------------
#
# Test psll.hs instruction (packed shift left logical halfword - shift by rs2).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psll.hs rd, rs1, rs2
  # Performs packed halfword shift left logical by rs2

  # Test case 1: Simple shift left by 1
  TEST_RR_OP( 2, psll.hs, 0x0002000400060008, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psll.hs, 0x0001000200030004, 0x0001000200030004, 0x0000000000000000 );

  # Test case 3: Shift left by 4
  TEST_RR_OP( 4, psll.hs, 0x0010002000300040, 0x0001000200030004, 0x0004000400040004 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


