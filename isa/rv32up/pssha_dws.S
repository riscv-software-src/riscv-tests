# See LICENSE for license details.

#*****************************************************************************
# pssha_dws.S
#-----------------------------------------------------------------------------
#
# Test pssha.dws instruction (packed saturating shift arithmetic, double-word, word).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed word element based on rs2[7:0] (negative=right, positive=left).
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

  # pssha.dws rd, rs1, rs2
  # rd (register pair) = saturating shift of rs1 (register pair) by rs2
  # rd and rs1 must be even registers

  # Test 2: Positive shift (left shift by 1)
  # rs1 = 0x00000001 (word: 1)
  # shift = 1
  # Expected: 2 = 0x00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 1; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000002, nop );

  # Test 4: Negative shift (right shift by 1)
  # rs1 = 0x00000004 (word: 4)
  # shift = -1 (0xFF)
  # Expected: 2 = 0x00000002
  TEST_CASE( 4, x14, 0x00000002, \
    li x10, 0x00000004; \
    li x11, 0x00000004; \
    li x12, 0xFFFFFFFF; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000002, nop );

  # Test 6: Saturating left shift (positive overflow)
  # rs1 = 0x40000000 (word: 0x40000000 = 1073741824)
  # shift = 2
  # Expected: saturate to 0x7FFFFFFF = 2147483647
  TEST_CASE( 6, x14, 0x7FFFFFFF, \
    li x10, 0x40000000; \
    li x11, 0x40000000; \
    li x12, 2; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 7, x15, 0x7FFFFFFF, nop );

  # Test 8: Saturating left shift (negative overflow)
  # rs1 = 0xC0000000 (word: 0xC0000000 = -1073741824)
  # shift = 2
  # Expected: saturate to 0x80000000 = -2147483648
  TEST_CASE( 8, x14, 0x80000000, \
    li x10, 0xC0000000; \
    li x11, 0xC0000000; \
    li x12, 2; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 9, x15, 0x80000000, nop );

  # Test 10: Shift by 0 (no change)
  TEST_CASE( 10, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 11, x15, 0x12345678, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Right shift negative value
  # rs1 = 0xFFFFFFF8 (word: -8)
  # shift = -1 (0xFF)
  # Expected: -4 = 0xFFFFFFFC
  TEST_CASE( 14, x14, 0xFFFFFFFC, \
    li x10, 0xFFFFFFF8; \
    li x11, 0xFFFFFFF8; \
    li x12, 0xFFFFFFFF; \
    pssha.dws x14, x10, x12 );
  TEST_CASE( 15, x15, 0xFFFFFFFC, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

