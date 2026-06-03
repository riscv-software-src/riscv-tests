# See LICENSE for license details.

#*****************************************************************************
# usati.S
#-----------------------------------------------------------------------------
#
# Test usati instruction (unsigned saturate immediate, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - usati saturates 32-bit value to unsigned imm+1 bits
  #-------------------------------------------------------------

  # usati rd, rs1, width
  # Saturates 32-bit signed value to unsigned `width`-bit range
  # Negative values clamp to 0, positive values clamp to (2^width - 1)
  # (assembler encodes width-1 in the uimm5 field)

  # Test case 1: No saturation needed (value fits in 8 bits unsigned: 0 to 255)
  # rs1 = 0x00000005 (5)
  # width = 8 (saturate to 8 bits: 0 to 255)
  # Expected: 0x00000005 (no change)
  TEST_CASE( 2, x14, 0x00000005, li a1, 0x00000005; usati x14, a1, 8 );

  # Test case 2: Positive saturation (value > max for unsigned 8 bits)
  # rs1 = 0x00000100 (256)
  # width = 8 (saturate to 8 bits: max = 255)
  # Expected: 0x000000ff (saturated to 255)
  TEST_CASE( 3, x14, 0x000000ff, li a1, 0x00000100; usati x14, a1, 8 );

  # Test case 3: Negative value clamps to zero
  # rs1 = 0xfffffff0 (-16, signed)
  # width = 8 (saturate to 8 bits: min = 0)
  # Expected: 0x00000000 (negative clamped to 0)
  TEST_CASE( 4, x14, 0x00000000, li a1, 0xfffffff0; usati x14, a1, 8 );

  # Test case 4: Zero remains zero
  TEST_CASE( 5, x14, 0x00000000, li a1, 0x00000000; usati x14, a1, 8 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

