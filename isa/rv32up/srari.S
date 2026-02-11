# See LICENSE for license details.

#*****************************************************************************
# srari.S
#-----------------------------------------------------------------------------
#
# Test srari instruction (shift right arithmetic rounding immediate).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # srari rd, rs1, imm
  # Performs shift right arithmetic with rounding by immediate

  # Test case 1: Shift right by 1 with rounding (0x00000003 >> 1 = 0x00000002 rounded)
  TEST_CASE( 2, x14, 0x00000002, li a1, 0x00000003; srari x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x80000000, li a1, 0x80000000; srari x14, a1, 0 );

  # Test case 3: Shift right with sign extension and rounding (0x80000001 >> 1 = 0xC0000001 rounded)
  TEST_CASE( 4, x14, 0xc0000001, li a1, 0x80000001; srari x14, a1, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


