# See LICENSE for license details.

#*****************************************************************************
# psabs_dh.S
#-----------------------------------------------------------------------------
#
# Test psabs.dh instruction (Packed Saturating Absolute - Double-word Halfword, RV32 only).
# Unary operation: rd, rs1 only (no rs2).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # psabs.dh rd, rs1
  # Computes saturating absolute value for each signed halfword element
  # If element is -32768, result saturates to 32767
  # rd and rs1 must be even registers

  # Test case 2: Positive values stay the same
  # rs1 = 0x0001000200030004
  # Result: same
  TEST_CASE( 2, x14, 0x00030004, \
    li x10, 0x00030004; \
    li x11, 0x00010002; \
    psabs.dh x14, x10 );
  TEST_CASE( 3, x15, 0x00010002, nop );

  # Test case 4: Negative values become positive
  # rs1 = 0xFFFFFFFEFFFDFFFC (-1, -2, -3, -4 as signed halfwords)
  # Result: 1, 2, 3, 4
  TEST_CASE( 4, x14, 0x00030004, \
    li x10, 0xfffdfffc; \
    li x11, 0xfffffffe; \
    psabs.dh x14, x10 );
  TEST_CASE( 5, x15, 0x00010002, nop );

  # Test case 6: All zeros - should remain zeros
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psabs.dh x14, x10 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 8: Saturation case - (-32768) saturates to 32767
  # rs1 = 0x8000800080008000 (all -32768)
  # Result = 0x7FFF7FFF7FFF7FFF
  TEST_CASE( 8, x14, 0x7fff7fff, \
    li x10, 0x80008000; \
    li x11, 0x80008000; \
    psabs.dh x14, x10 );
  TEST_CASE( 9, x15, 0x7fff7fff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

