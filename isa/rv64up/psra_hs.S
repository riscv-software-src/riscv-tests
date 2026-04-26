# See LICENSE for license details.

#*****************************************************************************
# psra_hs.S
#-----------------------------------------------------------------------------
#
# Test psra.hs instruction (packed shift right arithmetic halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psra.hs rd, rs1, rs2
  # Performs packed halfword shift right arithmetic by rs2

  # Test case 1: Simple shift right by 1 (positive values)
  TEST_RR_OP( 2, psra.hs, 0x0000000100010002, 0x0001000200030004, 0x0001000100010001 );

  # Test case 2: Shift by 0 (no change)
  TEST_RR_OP( 3, psra.hs, 0x8000800080008000, 0x8000800080008000, 0x0000000000000000 );

  # Test case 3: Shift right with sign extension (0x8000 >> 1 = 0xC000)
  TEST_RR_OP( 4, psra.hs, 0xc000c000c000c000, 0x8000800080008000, 0x0001000100010001 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


