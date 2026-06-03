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

  # Test case 6: rs1=-128 bytes, rs2=0 -> per spec |a-b|=128 wraps to 0x80
  # Spec PABD.B does no saturation: result = (a<_s b) ? b-a : a-b.
  # rs1 = 0x80808080... (all -128), rs2 = 0; a<_s b so result = b-a = 128 = 0x80.
  TEST_CASE( 6, x14, 0x80808080, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pabd.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x80808080, nop );

  # Test case 8: rs1=0, rs2=-128 -> result = 128 = 0x80 (no saturation)
  TEST_CASE( 8, x14, 0x80808080, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x80808080; \
    li x13, 0x80808080; \
    pabd.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0x80808080, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

