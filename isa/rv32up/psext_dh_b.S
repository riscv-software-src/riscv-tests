# See LICENSE for license details.

#*****************************************************************************
# psext_dh_b.S
#-----------------------------------------------------------------------------
#
# Test psext.dh.b instruction (packed sign-extend double-word halfword from byte).
# RV32-only instruction using register pairs for 64-bit operations.
# Sign-extends the low 8 bits of each 16-bit element to 16 bits.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psext.dh.b sign-extends low byte of each halfword
  #-------------------------------------------------------------

  # psext.dh.b rd, rs1
  # Sign-extends the low 8 bits of each 16-bit element to 16 bits

  # Test case 1: Positive byte values (no sign extension needed)
  # rs1 = 0x0005000500050005 (5 in low byte of each halfword)
  # Expected: 0x0005000500050005 (5 sign-extended)
  # Using even registers for register-pair constraint (rd, rs1 must be even)
  TEST_CASE( 2, x14, 0x00050005, \
    li x10, 0x00050005; \
    li x11, 0x00050005; \
    psext.dh.b x14, x10 );
  TEST_CASE( 3, x15, 0x00050005, nop );

  # Test case 2: Negative byte values (0x80 = -128, sign extends to 0xFF80)
  # rs1 = 0x0080008000800080 (0x80 in low byte)
  # Expected: 0xff80ff80ff80ff80 (-128 sign-extended to halfword)
  TEST_CASE( 4, x14, 0xff80ff80, \
    li x10, 0x00800080; \
    li x11, 0x00800080; \
    psext.dh.b x14, x10 );
  TEST_CASE( 5, x15, 0xff80ff80, nop );

  # Test case 3: 0xFF in low byte (-1) sign extends to 0xFFFF
  # rs1 = 0x00ff00ff00ff00ff
  # Expected: 0xffffffffffffffff
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0x00ff00ff; \
    li x11, 0x00ff00ff; \
    psext.dh.b x14, x10 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 4: Zero remains zero
  TEST_CASE( 8, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psext.dh.b x14, x10 );
  TEST_CASE( 9, x15, 0x00000000, nop );

  # Test case 5: High byte is ignored, only low byte matters
  # rs1 = 0xff05ff05ff05ff05 (high byte 0xFF, low byte 0x05)
  # Expected: 0x0005000500050005 (only low byte 0x05 is sign-extended)
  TEST_CASE( 10, x14, 0x00050005, \
    li x10, 0xff05ff05; \
    li x11, 0xff05ff05; \
    psext.dh.b x14, x10 );
  TEST_CASE( 11, x15, 0x00050005, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

