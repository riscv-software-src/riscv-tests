# See LICENSE for license details.

#*****************************************************************************
# psrl_bs.S
#-----------------------------------------------------------------------------
#
# Test psrl.bs instruction (packed shift right logical byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrl.bs rd, rs1, rs2
  # Performs packed byte shift right logical by rs2

  # Test case 1: Simple shift right by 1
  TEST_RR_OP( 2, psrl.bs, 0x0001010202030304, 0x0002030405060708, 0x0101010101010101 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psrl.bs, 0x8080808080808080, 0x8080808080808080, 0x0000000000000000 );

  # Test case 3: Shift right logical (0x80 >> 1 = 0x40, no sign extension)
  TEST_RR_OP( 4, psrl.bs, 0x4040404040404040, 0x8080808080808080, 0x0101010101010101 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


