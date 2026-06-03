# See LICENSE for license details.

#*****************************************************************************
# psext_w_b.S
#-----------------------------------------------------------------------------
#
# Test psext.w.b instruction (packed sign-extend word from byte, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psext.w.b sign-extends low byte of each word
  #-------------------------------------------------------------

  # psext.w.b rd, rs1
  # Sign-extends the low 8 bits of each 32-bit element to 32 bits

  # Test case 1: Positive byte values (no sign extension needed)
  # rs1 = 0x0000000500000005 (5 in low byte of each word)
  # Expected: 0x0000000500000005 (5 sign-extended)
  TEST_R_OP( 2, psext.w.b, 0x0000000500000005, 0x0000000500000005 );

  # Test case 2: Negative byte values (0x80 = -128, sign extends to 0xFFFFFF80)
  # rs1 = 0x0000008000000080 (0x80 in low byte)
  # Expected: 0xffffff80ffffff80 (-128 sign-extended to word)
  TEST_R_OP( 3, psext.w.b, 0xffffff80ffffff80, 0x0000008000000080 );

  # Test case 3: 0xFF in low byte (-1) sign extends to 0xFFFFFFFF
  # rs1 = 0x000000ff000000ff
  # Expected: 0xffffffffffffffff
  TEST_R_OP( 4, psext.w.b, 0xffffffffffffffff, 0x000000ff000000ff );

  # Test case 4: Zero remains zero
  TEST_R_OP( 5, psext.w.b, 0x0000000000000000, 0x0000000000000000 );

  # Test case 5: High bytes are ignored, only low byte matters
  # rs1 = 0xffffff05ffffff05 (high bytes 0xFFFFFF, low byte 0x05)
  # Expected: 0x0000000500000005 (only low byte 0x05 is sign-extended)
  TEST_R_OP( 6, psext.w.b, 0x0000000500000005, 0xffffff05ffffff05 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


