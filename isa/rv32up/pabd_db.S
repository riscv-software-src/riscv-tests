# See LICENSE for license details.

#*****************************************************************************
# pabd_db.S
#-----------------------------------------------------------------------------
#
# Test pabd.db instruction (Packed Absolute Difference - Double-word Byte, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # pabd.db rd, rs1, rs2
  # Computes |rs1[i] - rs2[i]| for each signed byte element
  # rd and rs1 must be even registers

  # Test case 2: Basic test - small positive differences
  # rs1 = 0x0403020104030201, rs2 = 0x0201000002010000
  # Result low: 0x02020201, Result high: 0x02020201
  TEST_CASE( 2, x14, 0x02020201, \
    li x10, 0x04030201; \
    li x11, 0x04030201; \
    li x12, 0x02010000; \
    li x13, 0x02010000; \
    pabd.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x02020201, nop );

  # Test case 4: Both operands same - result should be all zeros
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x12345678; \
    li x11, 0x12345678; \
    li x12, 0x12345678; \
    li x13, 0x12345678; \
    pabd.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: Saturation case: -128 - 0 = -128, saturates to 127
  # rs1 = 0x8080808080808080 (all -128), rs2 = 0x0000000000000000
  TEST_CASE( 6, x14, 0x7f7f7f7f, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pabd.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x7f7f7f7f, nop );

  # Test case 8: Another saturation case: 0 - (-128) saturates to 127
  TEST_CASE( 8, x14, 0x7f7f7f7f, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x80808080; \
    li x13, 0x80808080; \
    pabd.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0x7f7f7f7f, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

