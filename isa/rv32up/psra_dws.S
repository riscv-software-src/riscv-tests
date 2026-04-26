# See LICENSE for license details.

#*****************************************************************************
# psra_dws.S
#-----------------------------------------------------------------------------
#
# Test psra.dws instruction (packed shift right arithmetic, double-word, word, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each signed word element right by the amount in rs2, with sign extension.
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psra.dws rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) >> rs2 (per word, arithmetic)
  # rd and rs1 must be even registers

  # Test 2: Shift positive values by 1
  # rs1 = 0x0000000200000002 (words: 2, 2)
  # shift = 1
  # Expected: 1 = 0x00000001
  TEST_CASE( 2, x14, 0x00000001, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 1; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000001, nop );

  # Test 4: Shift negative values by 1 (sign extension)
  # rs1 = 0xFFFFFFFEFFFFFFFE (signed words: -2, -2)
  # shift = 1
  # Expected: -1 = 0xFFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFE; \
    li x11, 0xFFFFFFFE; \
    li x12, 1; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 5, x15, 0xFFFFFFFF, nop );

  # Test 6: Shift by 16
  # rs1 = 0x8000000080000000 (all -2147483648)
  # shift = 16
  # Expected: 0xFFFF8000
  TEST_CASE( 6, x14, 0xFFFF8000, \
    li x10, 0x80000000; \
    li x11, 0x80000000; \
    li x12, 16; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFFFF8000, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: Shift by 31 (sign fill)
  # rs1 = 0x8000000080000000 (all -2147483648)
  # shift = 31
  # Expected: 0xFFFFFFFF (all -1)
  TEST_CASE( 10, x14, 0xFFFFFFFF, \
    li x10, 0x80000000; \
    li x11, 0x80000000; \
    li x12, 31; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 11, x15, 0xFFFFFFFF, nop );

  # Test 12: Shift positive by 31
  # rs1 = 0x7FFFFFFF7FFFFFFF (all 2147483647)
  # shift = 31
  # Expected: 0x00000000
  TEST_CASE( 12, x14, 0x00000000, \
    li x10, 0x7FFFFFFF; \
    li x11, 0x7FFFFFFF; \
    li x12, 31; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 13, x15, 0x00000000, nop );

  # Test 14: Zero input
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psra.dws x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

