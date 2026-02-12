# See LICENSE for license details.

#*****************************************************************************
# psati_dh.S
#-----------------------------------------------------------------------------
#
# Test psati.dh instruction (packed saturate immediate double-word halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Saturates each 16-bit element to signed (imm+1)-bit range.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psati.dh saturates each halfword to imm+1 bits (signed)
  #-------------------------------------------------------------

  # psati.dh rd, rs1, imm4
  # Saturates each 16-bit element to signed (imm+1)-bit range

  # Test case 1: No saturation needed (value fits in 8 bits signed: -128 to 127)
  # rs1 = 0x0005000500050005 (5 in each halfword)
  # imm = 7 (saturate to 8 bits: -128 to 127)
  # Expected: 0x0005000500050005 (no change)
  TEST_IMM_OP( 2, psati.dh, 0x0005000500050005, 0x0005000500050005, 7 );

  # Test case 2: Positive saturation (value > max for 8 bits signed)
  # rs1 = 0x0100010001000100 (256 in each halfword)
  # imm = 7 (saturate to 8 bits: max = 127)
  # Expected: 0x007f007f007f007f (saturated to 127)
  TEST_IMM_OP( 3, psati.dh, 0x007f007f007f007f, 0x0100010001000100, 7 );

  # Test case 3: Negative saturation (value < min for 8 bits signed)
  # rs1 = 0xff00ff00ff00ff00 (-256 in each halfword)
  # imm = 7 (saturate to 8 bits: min = -128)
  # Expected: 0xff80ff80ff80ff80 (-128 in each halfword)
  TEST_IMM_OP( 4, psati.dh, 0xff80ff80ff80ff80, 0xff00ff00ff00ff00, 7 );

  # Test case 4: Zero remains zero
  TEST_IMM_OP( 5, psati.dh, 0x0000000000000000, 0x0000000000000000, 7 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

