# See LICENSE for license details.

#*****************************************************************************
# pabdu_db.S
#-----------------------------------------------------------------------------
#
# Test pabdu.db instruction (Packed Unsigned Absolute Difference - Double-word Byte, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pabdu.db rd, rs1, rs2
  # Computes |rs1[i] - rs2[i]| for each unsigned byte element (signed comparison)
  # rd and rs1 must be even registers

  # Test case 2: Basic test - small positive differences
  # rs1 = 0x0403020104030201, rs2 = 0x0201000002010000
  # Result low: 0x02020201, Result high: 0x02020201
  TEST_CASE( 2, x14, 0x02020201, \
    li x10, 0x04030201; \
    li x11, 0x04030201; \
    li x12, 0x02010000; \
    li x13, 0x02010000; \
    pabdu.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x02020201, nop );

  # Test case 4: Both operands same - result should be all zeros
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0x12345678; \
    li x13, 0x12345678; \
    pabdu.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: Small values only
  # rs1 = 0x0A0A0A0A0A0A0A0A (10), rs2 = 0x0505050505050505 (5)
  # Result = 5
  TEST_CASE( 6, x14, 0x05050505, \
    li x10, 0x0a0a0a0a; \
    li x11, 0x0a0a0a0a; \
    li x12, 0x05050505; \
    li x13, 0x05050505; \
    pabdu.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x05050505, nop );

  # Test case 8: High value (0x80) which is -128 as signed
  # rs1 = 0x8080808080808080 (128 unsigned, -128 signed), rs2 = 0x0101010101010101 (1)
  # compare = -128 - 1 wraps, result = 0x80 - 0x01 = 0x7F
  TEST_CASE( 8, x14, 0x7f7f7f7f, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pabdu.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0x7f7f7f7f, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

