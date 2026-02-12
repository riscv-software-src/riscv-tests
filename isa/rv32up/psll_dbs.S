# See LICENSE for license details.

#*****************************************************************************
# psll_dbs.S
#-----------------------------------------------------------------------------
#
# Test psll.dbs instruction (packed shift left logical, double-word, byte, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each byte element left by the amount in rs2[7:0].
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psll.dbs rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) << rs2[7:0] (per byte)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x0102030401020304 (bytes: 1, 2, 3, 4, 1, 2, 3, 4)
  # shift = 1
  # Expected: 2, 4, 6, 8, 2, 4, 6, 8 = 0x0204060802040608
  TEST_CASE( 2, x14, 0x02040608, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    li x12, 1; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x02040608, nop );

  # Test 4: Shift by 4
  # rs1 = 0x0102030401020304
  # shift = 4
  # Expected: 0x10, 0x20, 0x30, 0x40 = 0x10203040
  TEST_CASE( 4, x14, 0x10203040, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    li x12, 4; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x10203040, nop );

  # Test 6: Shift by 7
  # rs1 = 0x0102030401020304
  # shift = 7 (only bit 0 of each byte matters)
  # Expected: 0x80, 0x00, 0x80, 0x00 = 0x80008000
  TEST_CASE( 6, x14, 0x80008000, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    li x12, 7; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 7, x15, 0x80008000, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x01020304, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    li x12, 0; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x01020304, nop );

  # Test 10: Shift by 8 or more (result is 0)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 8; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  # Test 12: All 0xFF shifted by 1
  # 0xFF << 1 = 0xFE (byte)
  TEST_CASE( 12, x14, 0xFEFEFEFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 13, x15, 0xFEFEFEFE, nop );

  # Test 14: Zero input
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psll.dbs x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

