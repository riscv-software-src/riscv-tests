# See LICENSE for license details.

#*****************************************************************************
# pusati_dw.S
#-----------------------------------------------------------------------------
#
# Test pusati.dw instruction (packed unsigned saturate immediate double-word word).
# RV32-only instruction using register pairs for 64-bit operations.
# Saturates each signed 32-bit element to unsigned (imm+1)-bit range.
# Negative values clamp to 0, positive values clamp to max unsigned.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - pusati.dw saturates each word to unsigned imm+1 bits
  #-------------------------------------------------------------

  # pusati.dw rd, rs1, imm5
  # Saturates each 32-bit signed element to unsigned (imm+1)-bit range
  # Negative values clamp to 0, positive values clamp to max unsigned

  # Test case 1: No saturation needed (value fits in 16 bits: 0 to 32767)
  # rs1 = 0x0000000500000005 (5 in each word)
  # imm = 15 (saturate to 16 bits: 0 to 32767)
  # Expected: 0x0000000500000005 (no change)
  TEST_IMM_OP( 2, pusati.dw, 0x0000000500000005, 0x0000000500000005, 15 );

  # Test case 2: Positive saturation (value > max for unsigned 16 bits)
  # rs1 = 0x0001000000010000 (65536 in each word)
  # imm = 15 (saturate to 16 bits: max = 32767)
  # Expected: 0x00007fff00007fff (saturated to 32767)
  TEST_IMM_OP( 3, pusati.dw, 0x00007fff00007fff, 0x0001000000010000, 15 );

  # Test case 3: Negative value clamps to zero
  # rs1 = 0xfffffff0fffffff0 (-16 in each word, signed)
  # imm = 15 (saturate to 16 bits: min = 0)
  # Expected: 0x0000000000000000 (negative clamped to 0)
  TEST_IMM_OP( 4, pusati.dw, 0x0000000000000000, 0xfffffff0fffffff0, 15 );

  # Test case 4: Zero remains zero
  TEST_IMM_OP( 5, pusati.dw, 0x0000000000000000, 0x0000000000000000, 15 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

