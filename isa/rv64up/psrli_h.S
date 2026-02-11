# See LICENSE for license details.

#*****************************************************************************
# psrli_h.S
#-----------------------------------------------------------------------------
#
# Test psrli.h instruction (packed shift right logical immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrli.h rd, rs1, imm
  # Performs packed halfword shift right logical by immediate

  # Test case 1: Shift right by 1
  TEST_CASE( 2, x14, 0x0000000100010002, li a1, 0x0001000200030004; psrli.h x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x8000800080008000, li a1, 0x8000800080008000; psrli.h x14, a1, 0 );

  # Test case 3: Shift right logical (0x8000 >> 1 = 0x4000, no sign extension)
  TEST_CASE( 4, x14, 0x4000400040004000, li a1, 0x8000800080008000; psrli.h x14, a1, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


