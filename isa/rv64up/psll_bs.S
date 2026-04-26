# See LICENSE for license details.

#*****************************************************************************
# psll_bs.S
#-----------------------------------------------------------------------------
#
# Test psll.bs instruction (packed shift left logical byte - shift by rs2).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psll.bs rd, rs1, rs2
  # Performs packed byte shift left logical by rs2

  # Test case 1: Simple shift left by 1
  TEST_RR_OP( 2, psll.bs, 0x0204060810121416, 0x0102030405060708, 0x0101010101010101 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psll.bs, 0x0102030405060708, 0x0102030405060708, 0x0000000000000000 );

  # Test case 3: Shift left by 4
  TEST_RR_OP( 4, psll.bs, 0x1020304050607080, 0x0102030405060708, 0x0404040404040404 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


