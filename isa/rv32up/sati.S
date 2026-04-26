# See LICENSE for license details.

#*****************************************************************************
# sati.S
#-----------------------------------------------------------------------------
#
# Test sati instruction (saturate immediate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - sati saturates 32-bit value to imm+1 bits (signed)
  #-------------------------------------------------------------

  # sati rd, rs1, imm5
  # Saturates 32-bit signed value to signed (imm+1)-bit range

  # Test case 1: No saturation needed (value fits in 8 bits signed: -128 to 127)
  # rs1 = 0x00000005 (5)
  # imm = 7 (saturate to 8 bits: -128 to 127)
  # Expected: 0x00000005 (no change)
  TEST_CASE( 2, x14, 0x00000005, li a1, 0x00000005; sati x14, a1, 7 );

  # Test case 2: Positive saturation (value > max for 8 bits signed)
  # rs1 = 0x00000100 (256)
  # imm = 7 (saturate to 8 bits: max = 127)
  # Expected: 0x0000007f (saturated to 127)
  TEST_CASE( 3, x14, 0x0000007f, li a1, 0x00000100; sati x14, a1, 7 );

  # Test case 3: Negative saturation (value < min for 8 bits signed)
  # rs1 = 0xffffff00 (-256)
  # imm = 7 (saturate to 8 bits: min = -128)
  # Expected: 0xffffff80 (-128)
  TEST_CASE( 4, x14, 0xffffff80, li a1, 0xffffff00; sati x14, a1, 7 );

  # Test case 4: Zero remains zero
  TEST_CASE( 5, x14, 0x00000000, li a1, 0x00000000; sati x14, a1, 7 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

