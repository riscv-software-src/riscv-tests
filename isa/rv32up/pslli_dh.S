# See LICENSE for license details.

#*****************************************************************************
# pslli_dh.S
#-----------------------------------------------------------------------------
#
# Test pslli.dh instruction (packed shift left logical immediate, double-word, halfword).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each halfword element left by an immediate value.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pslli.dh rd, rs1, imm
  # rd (register pair) = rs1 (register pair) << imm (per halfword)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x0001000200010002
  # shift = 1
  # Expected: 2, 4 = 0x00020004
  TEST_CASE( 2, x14, 0x00020004, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    pslli.dh x14, x10, 1 );
  TEST_CASE( 3, x15, 0x00020004, nop );

  # Test 4: Shift by 8
  # rs1 = 0x0001000200010002
  # shift = 8
  # Expected: 0x0100, 0x0200 = 0x01000200
  TEST_CASE( 4, x14, 0x01000200, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    pslli.dh x14, x10, 8 );
  TEST_CASE( 5, x15, 0x01000200, nop );

  # Test 6: Shift by 15
  # rs1 = 0x0001000300010003
  # shift = 15
  # Expected: 0x8000, 0x8000 = 0x80008000
  TEST_CASE( 6, x14, 0x80008000, \
    li x10, 0x00010003; \
    li x11, 0x00010003; \
    pslli.dh x14, x10, 15 );
  TEST_CASE( 7, x15, 0x80008000, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    pslli.dh x14, x10, 0 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: All 0xFFFF shifted by 1
  # 0xFFFF << 1 = 0xFFFE (halfword)
  TEST_CASE( 10, x14, 0xFFFEFFFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    pslli.dh x14, x10, 1 );
  TEST_CASE( 11, x15, 0xFFFEFFFE, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    pslli.dh x14, x10, 5 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Shift by 4
  TEST_CASE( 14, x14, 0x00100020, \
    li x10, 0x00010002; \
    li x11, 0x00010002; \
    pslli.dh x14, x10, 4 );
  TEST_CASE( 15, x15, 0x00100020, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

