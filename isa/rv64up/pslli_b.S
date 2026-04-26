# See LICENSE for license details.

#*****************************************************************************
# pslli_b.S
#-----------------------------------------------------------------------------
#
# Test pslli.b instruction (packed shift left logical immediate byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pslli.b rd, rs1, imm
  # Performs packed byte shift left logical by immediate

  # Test case 1: Shift left by 1
  TEST_CASE( 2, x14, 0x0204060810121416, li a1, 0x0102030405060708; pslli.b x14, a1, 1 );

  # Test case 2: Shift left by 0 (no change)
  TEST_CASE( 3, x14, 0x0102030405060708, li a1, 0x0102030405060708; pslli.b x14, a1, 0 );

  # Test case 3: Shift left by 4
  TEST_CASE( 4, x14, 0x1020304050607080, li a1, 0x0102030405060708; pslli.b x14, a1, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


