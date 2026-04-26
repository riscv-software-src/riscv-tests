# See LICENSE for license details.

#*****************************************************************************
# psext_h_b.S
#-----------------------------------------------------------------------------
#
# Test psext.h.b instruction (packed sign-extend halfword from byte).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psext.h.b sign-extends low byte of each halfword
  #-------------------------------------------------------------

  # psext.h.b rd, rs1
  # Sign-extends the low 8 bits of each 16-bit element to 16 bits

  # Test case 1: Positive byte values (no sign extension needed)
  # rs1 = 0x0005000500050005 (5 in low byte of each halfword)
  # Expected: 0x0005000500050005 (5 sign-extended)
  TEST_R_OP( 2, psext.h.b, 0x0005000500050005, 0x0005000500050005 );

  # Test case 2: Negative byte values (0x80 = -128, sign extends to 0xFF80)
  # rs1 = 0x0080008000800080 (0x80 in low byte)
  # Expected: 0xff80ff80ff80ff80 (-128 sign-extended to halfword)
  TEST_R_OP( 3, psext.h.b, 0xff80ff80ff80ff80, 0x0080008000800080 );

  # Test case 3: 0xFF in low byte (-1) sign extends to 0xFFFF
  # rs1 = 0x00ff00ff00ff00ff
  # Expected: 0xffffffffffffffff
  TEST_R_OP( 4, psext.h.b, 0xffffffffffffffff, 0x00ff00ff00ff00ff );

  # Test case 4: Zero remains zero
  TEST_R_OP( 5, psext.h.b, 0x0000000000000000, 0x0000000000000000 );

  # Test case 5: High byte is ignored, only low byte matters
  # rs1 = 0xff05ff05ff05ff05 (high byte 0xFF, low byte 0x05)
  # Expected: 0x0005000500050005 (only low byte 0x05 is sign-extended)
  TEST_R_OP( 6, psext.h.b, 0x0005000500050005, 0xff05ff05ff05ff05 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

