# See LICENSE for license details.

#*****************************************************************************
# pslli_db.S
#-----------------------------------------------------------------------------
#
# Test pslli.db instruction (packed shift left logical immediate, double-word, byte).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each byte element left by an immediate value.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pslli.db rd, rs1, imm
  # rd (register pair) = rs1 (register pair) << imm (per byte)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x0102030401020304
  # shift = 1
  # Expected: 2, 4, 6, 8 = 0x02040608
  TEST_CASE( 2, x14, 0x02040608, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    pslli.db x14, x10, 1 );
  TEST_CASE( 3, x15, 0x02040608, nop );

  # Test 4: Shift by 4
  # rs1 = 0x0102030401020304
  # shift = 4
  # Expected: 0x10, 0x20, 0x30, 0x40 = 0x10203040
  TEST_CASE( 4, x14, 0x10203040, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    pslli.db x14, x10, 4 );
  TEST_CASE( 5, x15, 0x10203040, nop );

  # Test 6: Shift by 7
  # rs1 = 0x0102030401020304
  # shift = 7
  # Expected: 0x80, 0x00, 0x80, 0x00 = 0x80008000
  TEST_CASE( 6, x14, 0x80008000, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    pslli.db x14, x10, 7 );
  TEST_CASE( 7, x15, 0x80008000, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x01020304, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    pslli.db x14, x10, 0 );
  TEST_CASE( 9, x15, 0x01020304, nop );

  # Test 10: All 0xFF shifted by 1
  # 0xFF << 1 = 0xFE (byte)
  TEST_CASE( 10, x14, 0xFEFEFEFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    pslli.db x14, x10, 1 );
  TEST_CASE( 11, x15, 0xFEFEFEFE, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    pslli.db x14, x10, 5 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Shift by 3
  TEST_CASE( 14, x14, 0x08101820, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    pslli.db x14, x10, 3 );
  TEST_CASE( 15, x15, 0x08101820, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

