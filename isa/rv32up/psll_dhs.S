# See LICENSE for license details.

#*****************************************************************************
# psll_dhs.S
#-----------------------------------------------------------------------------
#
# Test psll.dhs instruction (packed shift left logical, double-word, halfword, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each halfword element left by the amount in rs2[7:0].
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psll.dhs rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) << rs2[7:0] (per halfword)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x0001000200010002 (halfwords: 1, 2, 1, 2)
  # shift = 1
  # Expected: 2, 4, 2, 4 = 0x00020004
  TEST_CASE( 2, x14, 0x00020004, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    li x12, 1; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00020004, nop );

  # Test 4: Shift by 8
  # rs1 = 0x0001000200010002
  # shift = 8
  # Expected: 0x0100, 0x0200 = 0x01000200
  TEST_CASE( 4, x14, 0x01000200, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    li x12, 8; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x01000200, nop );

  # Test 6: Shift by 15
  # rs1 = 0x0001000300010003 (halfwords: 1, 3, 1, 3)
  # shift = 15 (only bit 0 matters)
  # Expected: 0x8000, 0x8000 = 0x80008000
  TEST_CASE( 6, x14, 0x80008000, \
    li x10, 0x00010003; \
    li x11, 0x00010003; \
    li x12, 15; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 7, x15, 0x80008000, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: Shift by 16 or more (result is 0)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 16; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  # Test 12: All 0xFFFF shifted by 1
  # 0xFFFF << 1 = 0xFFFE (halfword)
  TEST_CASE( 12, x14, 0xFFFEFFFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 13, x15, 0xFFFEFFFE, nop );

  # Test 14: Zero input
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psll.dhs x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

