# See LICENSE for license details.

#*****************************************************************************
# psslai_dh.S
#-----------------------------------------------------------------------------
#
# Test psslai.dh instruction (packed saturating shift left arithmetic immediate, double-word, halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed halfword element left by an immediate value with saturation.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psslai.dh rd, rs1, imm
  # rd (register pair) = saturating shift of rs1 (register pair) by imm
  # rd and rs1 must be even registers

  # Test 2: Simple left shift by 1 (no saturation)
  # rs1 = 0x00010002 (halfwords: 1, 2)
  # shift = 1
  # Expected: 2, 4 = 0x00020004
  TEST_CASE( 2, x14, 0x00020004, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    psslai.dh x14, x10, 1 );
  TEST_CASE( 3, x15, 0x00020004, nop );

  # Test 4: Left shift by 4 (no saturation)
  # rs1 = 0x00100020 (halfwords: 16, 32)
  # shift = 4
  # Expected: 256, 512 = 0x01000200
  TEST_CASE( 4, x14, 0x01000200, \
    li x10, 0x00100020; \
    li x11, 0x00100020; \
    psslai.dh x14, x10, 4 );
  TEST_CASE( 5, x15, 0x01000200, nop );

  # Test 6: Saturating left shift (positive overflow)
  # rs1 = 0x40004000 (halfwords: 0x4000 = 16384)
  # shift = 2
  # Expected: saturate to 0x7FFF = 32767
  TEST_CASE( 6, x14, 0x7FFF7FFF, \
    li x10, 0x40004000; \
    li x11, 0x40004000; \
    psslai.dh x14, x10, 2 );
  TEST_CASE( 7, x15, 0x7FFF7FFF, nop );

  # Test 8: Saturating left shift (negative overflow)
  # rs1 = 0xC000C000 (halfwords: 0xC000 = -16384)
  # shift = 2
  # Expected: saturate to 0x8000 = -32768
  TEST_CASE( 8, x14, 0x80008000, \
    li x10, 0xC000C000; \
    li x11, 0xC000C000; \
    psslai.dh x14, x10, 2 );
  TEST_CASE( 9, x15, 0x80008000, nop );

  # Test 10: Shift by 0 (no change)
  TEST_CASE( 10, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    psslai.dh x14, x10, 0 );
  TEST_CASE( 11, x15, 0x12345678, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psslai.dh x14, x10, 5 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Negative values shift without overflow
  # rs1 = 0xFFFFFFFF (halfwords: -1, -1)
  # shift = 1
  # Expected: -2, -2 = 0xFFFEFFFE
  TEST_CASE( 14, x14, 0xFFFEFFFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    psslai.dh x14, x10, 1 );
  TEST_CASE( 15, x15, 0xFFFEFFFE, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

