# See LICENSE for license details.

#*****************************************************************************
# psrari_h.S
#-----------------------------------------------------------------------------
#
# Test psrari.h instruction (packed shift right arithmetic rounding immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrari.h rd, rs1, imm
  # Performs packed halfword shift right arithmetic with rounding by immediate

  # Test case 1: Shift right by 1 with rounding (0x0003 >> 1 = 0x0002 rounded)
  TEST_CASE( 2, x14, 0x0001000100020002, li a1, 0x0001000200030004; psrari.h x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x8000800080008000, li a1, 0x8000800080008000; psrari.h x14, a1, 0 );

  # Test case 3: Shift right with sign extension and rounding (0x8001 >> 1 = 0xC001 rounded)
  TEST_CASE( 4, x14, 0xc001c001c001c001, li a1, 0x8001800180018001; psrari.h x14, a1, 1 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


