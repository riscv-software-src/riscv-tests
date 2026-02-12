# See LICENSE for license details.

#*****************************************************************************
# pssha_dhs.S
#-----------------------------------------------------------------------------
#
# Test pssha.dhs instruction (packed saturating shift arithmetic, double-word, halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed halfword element based on rs2[7:0] (negative=right, positive=left).
# Left shifts saturate on overflow.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssha.dhs rd, rs1, rs2
  # rd (register pair) = saturating shift of rs1 (register pair) by rs2
  # rd and rs1 must be even registers

  # Test 2: Positive shift (left shift by 1)
  # rs1 = 0x00010002 (halfwords: 1, 2)
  # shift = 1
  # Expected: 2, 4 = 0x00020004
  TEST_CASE( 2, x14, 0x00020004, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    li x12, 1; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00020004, nop );

  # Test 4: Negative shift (right shift by 1)
  # rs1 = 0x00020004 (halfwords: 2, 4)
  # shift = -1 (0xFF)
  # Expected: 1, 2 = 0x00010002
  TEST_CASE( 4, x14, 0x00010002, \
    li x10, 0x00020004; \
    li x11, 0x00020004; \
    li x12, 0xFFFFFFFF; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00010002, nop );

  # Test 6: Saturating left shift (positive overflow)
  # rs1 = 0x40004000 (halfwords: 0x4000 = 16384)
  # shift = 2
  # Expected: saturate to 0x7FFF = 32767
  TEST_CASE( 6, x14, 0x7FFF7FFF, \
    li x10, 0x40004000; \
    li x11, 0x40004000; \
    li x12, 2; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 7, x15, 0x7FFF7FFF, nop );

  # Test 8: Saturating left shift (negative overflow)
  # rs1 = 0xC000C000 (halfwords: 0xC000 = -16384)
  # shift = 2
  # Expected: saturate to 0x8000 = -32768
  TEST_CASE( 8, x14, 0x80008000, \
    li x10, 0xC000C000; \
    li x11, 0xC000C000; \
    li x12, 2; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x80008000, nop );

  # Test 10: Shift by 0 (no change)
  TEST_CASE( 10, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 11, x15, 0x12345678, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Right shift negative value
  # rs1 = 0xFFFCFFF8 (halfwords: -4, -8)
  # shift = -1 (0xFF)
  # Expected: -2, -4 = 0xFFFEFFFC
  TEST_CASE( 14, x14, 0xFFFEFFFC, \
    li x10, 0xFFFCFFF8; \
    li x11, 0xFFFCFFF8; \
    li x12, 0xFFFFFFFF; \
    pssha.dhs x14, x10, x12 );
  TEST_CASE( 15, x15, 0xFFFEFFFC, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

