# See LICENSE for license details.

#*****************************************************************************
# psext_dw_b.S
#-----------------------------------------------------------------------------
#
# Test psext.dw.b instruction (packed sign-extend double-word word from byte).
# RV32-only instruction using register pairs for 64-bit operations.
# Sign-extends the low 8 bits of each 32-bit element to 32 bits.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic tests - psext.dw.b sign-extends low byte of each word
  #-------------------------------------------------------------

  # psext.dw.b rd, rs1
  # Sign-extends the low 8 bits of each 32-bit element to 32 bits

  # Test case 1: Positive byte values (no sign extension needed)
  # rs1 = 0x0000000500000005 (5 in low byte of each word)
  # Expected: 0x0000000500000005 (5 sign-extended)
  # Using even registers for register-pair constraint (rd, rs1 must be even)
  TEST_CASE( 2, x14, 0x00000005, \
    li x10, 0x00000005; \
    li x11, 0x00000005; \
    psext.dw.b x14, x10 );
  TEST_CASE( 3, x15, 0x00000005, nop );

  # Test case 2: Negative byte values (0x80 = -128, sign extends to 0xFFFFFF80)
  # rs1 = 0x0000008000000080 (0x80 in low byte)
  # Expected: 0xffffff80ffffff80 (-128 sign-extended to word)
  TEST_CASE( 4, x14, 0xffffff80, \
    li x10, 0x00000080; \
    li x11, 0x00000080; \
    psext.dw.b x14, x10 );
  TEST_CASE( 5, x15, 0xffffff80, nop );

  # Test case 3: 0xFF in low byte (-1) sign extends to 0xFFFFFFFF
  # rs1 = 0x000000ff000000ff
  # Expected: 0xffffffffffffffff
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0x000000ff; \
    li x11, 0x000000ff; \
    psext.dw.b x14, x10 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 4: Zero remains zero
  TEST_CASE( 8, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psext.dw.b x14, x10 );
  TEST_CASE( 9, x15, 0x00000000, nop );

  # Test case 5: High bytes are ignored, only low byte matters
  # rs1 = 0xffffff05ffffff05 (high bytes 0xFF, low byte 0x05)
  # Expected: 0x0000000500000005 (only low byte 0x05 is sign-extended)
  TEST_CASE( 10, x14, 0x00000005, \
    li x10, 0xffffff05; \
    li x11, 0xffffff05; \
    psext.dw.b x14, x10 );
  TEST_CASE( 11, x15, 0x00000005, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

