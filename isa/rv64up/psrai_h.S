# See LICENSE for license details.

#*****************************************************************************
# psrai_h.S
#-----------------------------------------------------------------------------
#
# Test psrai.h instruction (packed shift right arithmetic immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrai.h rd, rs1, imm
  # Performs packed halfword shift right arithmetic by immediate

  # Test case 1: Shift right by 1 (positive values)
  TEST_CASE( 2, x14, 0x0000000100010002, li a1, 0x0001000200030004; psrai.h x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x8000800080008000, li a1, 0x8000800080008000; psrai.h x14, a1, 0 );

  # Test case 3: Shift right with sign extension (0x8000 >> 1 = 0xC000)
  TEST_CASE( 4, x14, 0xc000c000c000c000, li a1, 0x8000800080008000; psrai.h x14, a1, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


