# See LICENSE for license details.

#*****************************************************************************
# psati_h.S
#-----------------------------------------------------------------------------
#
# Test psati.h instruction (packed saturate immediate halfword).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psati.h saturates each halfword to imm+1 bits (signed)
  #-------------------------------------------------------------

  # psati.h rd, rs1, imm4
  # Saturates each 16-bit element to signed (imm+1)-bit range

  # Test case 1: No saturation needed (value fits in 8 bits signed: -128 to 127)
  # rs1 = 0x0005000500050005 (5 in each halfword)
  # imm = 7 (saturate to 8 bits: -128 to 127)
  # Expected: 0x0005000500050005 (no change)
  TEST_CASE( 2, x14, 0x0005000500050005, li a1, 0x0005000500050005; psati.h x14, a1, 7 );

  # Test case 2: Positive saturation (value > max for 8 bits signed)
  # rs1 = 0x0100010001000100 (256 in each halfword)
  # imm = 7 (saturate to 8 bits: max = 127)
  # Expected: 0x007f007f007f007f (saturated to 127)
  TEST_CASE( 3, x14, 0x007f007f007f007f, li a1, 0x0100010001000100; psati.h x14, a1, 7 );

  # Test case 3: Negative saturation (value < min for 8 bits signed)
  # rs1 = 0xff00ff00ff00ff00 (-256 in each halfword)
  # imm = 7 (saturate to 8 bits: min = -128)
  # Expected: 0xff80ff80ff80ff80 (-128 in each halfword)
  TEST_CASE( 4, x14, 0xff80ff80ff80ff80, li a1, 0xff00ff00ff00ff00; psati.h x14, a1, 7 );

  # Test case 4: Zero remains zero
  TEST_CASE( 5, x14, 0x0000000000000000, li a1, 0x0000000000000000; psati.h x14, a1, 7 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

