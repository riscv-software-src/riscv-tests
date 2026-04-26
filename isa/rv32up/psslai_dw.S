# See LICENSE for license details.

#*****************************************************************************
# psslai_dw.S
#-----------------------------------------------------------------------------
#
# Test psslai.dw instruction (packed saturating shift left arithmetic immediate, double-word, word).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed word element left by an immediate value with saturation.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psslai.dw rd, rs1, imm
  # rd (register pair) = saturating shift of rs1 (register pair) by imm
  # rd and rs1 must be even registers

  # Test 2: Simple left shift by 1 (no saturation)
  # rs1 = 0x00000001 (word: 1)
  # shift = 1
  # Expected: 2 = 0x00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    psslai.dw x14, x10, 1 );
  TEST_CASE( 3, x15, 0x00000002, nop );

  # Test 4: Left shift by 4 (no saturation)
  # rs1 = 0x00000010 (word: 16)
  # shift = 4
  # Expected: 256 = 0x00000100
  TEST_CASE( 4, x14, 0x00000100, \
    li x10, 0x00000010; \
    li x11, 0x00000010; \
    psslai.dw x14, x10, 4 );
  TEST_CASE( 5, x15, 0x00000100, nop );

  # Test 6: Saturating left shift (positive overflow)
  # rs1 = 0x40000000 (word: 0x40000000 = 1073741824)
  # shift = 2
  # Expected: saturate to 0x7FFFFFFF = 2147483647
  TEST_CASE( 6, x14, 0x7FFFFFFF, \
    li x10, 0x40000000; \
    li x11, 0x40000000; \
    psslai.dw x14, x10, 2 );
  TEST_CASE( 7, x15, 0x7FFFFFFF, nop );

  # Test 8: Saturating left shift (negative overflow)
  # rs1 = 0xC0000000 (word: 0xC0000000 = -1073741824)
  # shift = 2
  # Expected: saturate to 0x80000000 = -2147483648
  TEST_CASE( 8, x14, 0x80000000, \
    li x10, 0xC0000000; \
    li x11, 0xC0000000; \
    psslai.dw x14, x10, 2 );
  TEST_CASE( 9, x15, 0x80000000, nop );

  # Test 10: Shift by 0 (no change)
  TEST_CASE( 10, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    psslai.dw x14, x10, 0 );
  TEST_CASE( 11, x15, 0x12345678, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psslai.dw x14, x10, 5 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Negative values shift without overflow
  # rs1 = 0xFFFFFFFF (word: -1)
  # shift = 1
  # Expected: -2 = 0xFFFFFFFE
  TEST_CASE( 14, x14, 0xFFFFFFFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    psslai.dw x14, x10, 1 );
  TEST_CASE( 15, x15, 0xFFFFFFFE, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

