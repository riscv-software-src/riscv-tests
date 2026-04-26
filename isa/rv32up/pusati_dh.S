# See LICENSE for license details.

#*****************************************************************************
# pusati_dh.S
#-----------------------------------------------------------------------------
#
# Test pusati.dh instruction (packed unsigned saturate immediate double-word halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Saturates each signed 16-bit element to unsigned (imm+1)-bit range.
# Negative values clamp to 0, positive values clamp to max unsigned.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pusati.dh saturates each halfword to unsigned imm+1 bits
  #-------------------------------------------------------------

  # pusati.dh rd, rs1, imm4
  # Saturates each 16-bit signed element to unsigned (imm+1)-bit range
  # Negative values clamp to 0, positive values clamp to max unsigned

  # Test case 1: No saturation needed (value fits in 8 bits: 0 to 127)
  # rs1 = 0x0005000500050005 (5 in each halfword)
  # imm = 7 (saturate to 8 bits: 0 to 127)
  # Expected: 0x0005000500050005 (no change)
  TEST_IMM_OP( 2, pusati.dh, 0x0005000500050005, 0x0005000500050005, 7 );

  # Test case 2: Positive saturation (value > max for unsigned 8 bits)
  # rs1 = 0x0100010001000100 (256 in each halfword)
  # imm = 7 (saturate to 8 bits: max = 127)
  # Expected: 0x007f007f007f007f (saturated to 127)
  TEST_IMM_OP( 3, pusati.dh, 0x007f007f007f007f, 0x0100010001000100, 7 );

  # Test case 3: Negative value clamps to zero
  # rs1 = 0xfff0fff0fff0fff0 (-16 in each halfword, signed)
  # imm = 7 (saturate to 8 bits: min = 0)
  # Expected: 0x0000000000000000 (negative clamped to 0)
  TEST_IMM_OP( 4, pusati.dh, 0x0000000000000000, 0xfff0fff0fff0fff0, 7 );

  # Test case 4: Zero remains zero
  TEST_IMM_OP( 5, pusati.dh, 0x0000000000000000, 0x0000000000000000, 7 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

