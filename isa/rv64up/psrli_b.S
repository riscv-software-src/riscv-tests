# See LICENSE for license details.

#*****************************************************************************
# psrli_b.S
#-----------------------------------------------------------------------------
#
# Test psrli.b instruction (packed shift right logical immediate byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrli.b rd, rs1, imm
  # Performs packed byte shift right logical by immediate

  # Test case 1: Shift right by 1
  TEST_CASE( 2, x14, 0x0001010202030304, li a1, 0x0002030405060708; psrli.b x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x8080808080808080, li a1, 0x8080808080808080; psrli.b x14, a1, 0 );

  # Test case 3: Shift right logical (0x80 >> 1 = 0x40, no sign extension)
  TEST_CASE( 4, x14, 0x4040404040404040, li a1, 0x8080808080808080; psrli.b x14, a1, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


