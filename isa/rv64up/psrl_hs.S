# See LICENSE for license details.

#*****************************************************************************
# psrl_hs.S
#-----------------------------------------------------------------------------
#
# Test psrl.hs instruction (packed shift right logical halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrl.hs rd, rs1, rs2
  # Performs packed halfword shift right logical by rs2

  # Test case 1: Simple shift right by 1
  TEST_RR_OP( 2, psrl.hs, 0x0000000100010002, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psrl.hs, 0x8000800080008000, 0x8000800080008000, 0x0000000000000000 );

  # Test case 3: Shift right logical (0x8000 >> 1 = 0x4000, no sign extension)
  TEST_RR_OP( 4, psrl.hs, 0x4000400040004000, 0x8000800080008000, 0x0001000100010001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


