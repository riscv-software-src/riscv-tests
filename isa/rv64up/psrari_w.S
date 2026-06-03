# See LICENSE for license details.

#*****************************************************************************
# psrari_w.S
#-----------------------------------------------------------------------------
#
# Test psrari.w instruction (packed shift right arithmetic rounding immediate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # psrari.w rd, rs1, imm
  # Performs packed word shift right arithmetic with rounding by immediate

  # Test case 1: Shift right by 1 with rounding
  TEST_CASE( 2, x14, 0x0000000200000001, li a1, 0x0000000300000001; psrari.w x14, a1, 1 );

  # Test case 2: Shift right by 0 (no change)
  TEST_CASE( 3, x14, 0x0000000200000001, li a1, 0x0000000200000001; psrari.w x14, a1, 0 );

  # Test case 3: Shift right by 4 with rounding
  TEST_CASE( 4, x14, 0x0000001000000001, li a1, 0x0000010000000008; psrari.w x14, a1, 4 );

  # Test case 4: Negative value with rounding
  TEST_CASE( 5, x14, 0xf8000000f8000000, li a1, 0x8000000080000000; psrari.w x14, a1, 4 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

