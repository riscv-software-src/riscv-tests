# See LICENSE for license details.

#*****************************************************************************
# psrl_dbs.S
#-----------------------------------------------------------------------------
#
# Test psrl.dbs instruction (packed shift right logical, double-word, byte, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each unsigned byte element right by the amount in rs2[7:0].
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrl.dbs rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) >> rs2 (per byte, logical)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x02040608 (bytes: 2, 4, 6, 8)
  # shift = 1
  # Expected: 1, 2, 3, 4 = 0x01020304
  TEST_CASE( 2, x14, 0x01020304, \
    li x10, 0x02040608; \
    li x11, 0x02040608; \
    li x12, 1; \
    psrl.dbs x14, x10, x12 );
  TEST_CASE( 3, x15, 0x01020304, nop );

  # Test 4: Shift by 4
  # rs1 = 0x80808080 (all 0x80)
  # shift = 4
  # Expected: 0x08080808
  TEST_CASE( 4, x14, 0x08080808, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 4; \
    psrl.dbs x14, x10, x12 );
  TEST_CASE( 5, x15, 0x08080808, nop );

  # Test 6: Shift by 7
  # rs1 = 0x80808080 (all 0x80)
  # shift = 7
  # Expected: 0x01010101
  TEST_CASE( 6, x14, 0x01010101, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 7; \
    psrl.dbs x14, x10, x12 );
  TEST_CASE( 7, x15, 0x01010101, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psrl.dbs x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: All 0xFF shifted by 1
  # 0xFF >> 1 = 0x7F (byte, no sign extension)
  TEST_CASE( 10, x14, 0x7F7F7F7F, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    psrl.dbs x14, x10, x12 );
  TEST_CASE( 11, x15, 0x7F7F7F7F, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psrl.dbs x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

