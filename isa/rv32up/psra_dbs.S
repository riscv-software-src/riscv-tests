# See LICENSE for license details.

#*****************************************************************************
# psra_dbs.S
#-----------------------------------------------------------------------------
#
# Test psra.dbs instruction (packed shift right arithmetic, double-word, byte, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed byte element right by the amount in rs2, with sign extension.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psra.dbs rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) >> rs2 (per byte, arithmetic)
  # rd and rs1 must be even registers

  # Test 2: Shift positive values by 1
  # rs1 = 0x0204060802040608 (bytes: 2, 4, 6, 8)
  # shift = 1
  # Expected: 1, 2, 3, 4 = 0x01020304
  TEST_CASE( 2, x14, 0x01020304, \
    li x10, 0x02040608; \
    li x11, 0x02040608; \
    li x12, 1; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x01020304, nop );

  # Test 4: Shift negative values by 1 (sign extension)
  # rs1 = 0xFEFCFAF8FEFCFAF8 (signed bytes: -2, -4, -6, -8)
  # shift = 1
  # Expected: -1, -2, -3, -4 = 0xFFFEFDFC
  TEST_CASE( 4, x14, 0xFFFEFDFC, \
    li x10, 0xFEFCFAF8; \
    li x11, 0xFEFCFAF8; \
    li x12, 1; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 5, x15, 0xFFFEFDFC, nop );

  # Test 6: Shift by 4
  # rs1 = 0x8080808080808080 (all -128)
  # shift = 4
  # Expected: 0xF8F8F8F8 (-8 per byte)
  TEST_CASE( 6, x14, 0xF8F8F8F8, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 4; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 7, x15, 0xF8F8F8F8, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: Shift by 7 (sign fill)
  # rs1 = 0x8080808080808080 (all -128)
  # shift = 7
  # Expected: 0xFFFFFFFF (all -1)
  TEST_CASE( 10, x14, 0xFFFFFFFF, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 7; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 11, x15, 0xFFFFFFFF, nop );

  # Test 12: Shift positive by 7
  # rs1 = 0x7F7F7F7F7F7F7F7F (all 127)
  # shift = 7
  # Expected: 0x00000000
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x7F7F7F7F; \
    li x11, 0x7F7F7F7F; \
    li x12, 7; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Zero input
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psra.dbs x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

