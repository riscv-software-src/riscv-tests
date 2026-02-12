# See LICENSE for license details.

#*****************************************************************************
# psll_dws.S
#-----------------------------------------------------------------------------
#
# Test psll.dws instruction (packed shift left logical, double-word, word, by register).
# RV32-only instruction using register pairs for 64-bit operations.
# Shifts each word element left by the amount in rs2[7:0].
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psll.dws rd, rs1, rs2
  # rd (register pair) = rs1 (register pair) << rs2[7:0] (per word)
  # rd and rs1 must be even registers

  # Test 2: Shift by 1
  # rs1 = 0x0000000100000001 (words: 1, 1)
  # shift = 1
  # Expected: 2, 2 = 0x00000002
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 1; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000002, nop );

  # Test 4: Shift by 16
  # rs1 = 0x0000000100000001
  # shift = 16
  # Expected: 0x00010000
  TEST_CASE( 4, x14, 0x00010000, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 16; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00010000, nop );

  # Test 6: Shift by 31
  # rs1 = 0x0000000100000001
  # shift = 31
  # Expected: 0x80000000
  TEST_CASE( 6, x14, 0x80000000, \
    li x10, 0x00000001; \
    li x11, 0x00000001; \
    li x12, 31; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 7, x15, 0x80000000, nop );

  # Test 8: Shift by 0 (no change)
  TEST_CASE( 8, x14, 0x12345678, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 9, x15, 0x12345678, nop );

  # Test 10: Shift by 32 or more (result is 0)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 32; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  # Test 12: All 0xFFFFFFFF shifted by 1
  # 0xFFFFFFFF << 1 = 0xFFFFFFFE (word)
  TEST_CASE( 12, x14, 0xFFFFFFFE, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 13, x15, 0xFFFFFFFE, nop );

  # Test 14: Zero input
  TEST_CASE( 14, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 15, x15, 0x00000000, nop );

  # Test 16: Large value shift
  TEST_CASE( 16, x14, 0xAAAA0000, \
    li x10, 0x0000AAAA; \
    li x11, 0x0000AAAA; \
    li x12, 16; \
    psll.dws x14, x10, x12 );
  TEST_CASE( 17, x15, 0xAAAA0000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

