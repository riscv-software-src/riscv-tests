# See LICENSE for license details.

#*****************************************************************************
# psrl_dws.S
#-----------------------------------------------------------------------------
#
# Test psrl.dws instruction (packed shift right logical, double-word, word, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each unsigned word element right by the amount in rs2[7:0].
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psrl.dws rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) >> rs2 (per word, logical)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x00000002 (word: 2)
  # shift = 1
  # Expected: 1 = 0x00000001
  TEST_CASE( 2, x14, 0x00000001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 1; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000001, nop );

  # Test 4: Shift by 16
  # rs1 = 0x80000000
  # shift = 16
  # Expected: 0x00008000
  TEST_CASE( 4, x14, 0x00008000, \
    li x10, 0x80000000; \
    li x11, 0x80000000; \
    li x12, 16; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00008000, nop );

  # Test 6: Shift by 31
  # rs1 = 0x80000000
  # shift = 31
  # Expected: 0x00000001
  TEST_CASE( 6, x14, 0x00000001, \
    li x10, 0x80000000; \
    li x11, 0x80000000; \
    li x12, 31; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000001, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: All 0xFFFFFFFF shifted by 1
  # 0xFFFFFFFF >> 1 = 0x7FFFFFFF (word, no sign extension)
  TEST_CASE( 10, x14, 0x7FFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 11, x15, 0x7FFFFFFF, nop );

  # Test 12: Zero input
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Large shift
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 32; \
    psrl.dws x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

