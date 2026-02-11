# See LICENSE for license details.

#*****************************************************************************
# psabs_db.S
#-----------------------------------------------------------------------------
#
# Test psabs.db instruction (Packed Saturating Absolute - Double-word Byte, RV32 only).
# Unary operation: rd, rs1 only (no rs2).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # psabs.db rd, rs1
  # Computes saturating absolute value for each signed byte element
  # If element is -128, result saturates to 127
  # rd and rs1 must be even registers

  # Test case 2: Positive values stay the same
  # rs1 = 0x0102030401020304
  # Result: same
  TEST_CASE( 2, x14, 0x01020304, \
    li x10, 0x01020304; \
    li x11, 0x01020304; \
    psabs.db x14, x10 );
  TEST_CASE( 3, x15, 0x01020304, nop );

  # Test case 4: Negative values become positive
  # rs1 = 0xFFFEFDFCFFFEFDFC (-1, -2, -3, -4 as signed bytes)
  # Result: 1, 2, 3, 4
  TEST_CASE( 4, x14, 0x01020304, \
    li x10, 0xfffefdfc; \
    li x11, 0xfffefdfc; \
    psabs.db x14, x10 );
  TEST_CASE( 5, x15, 0x01020304, nop );

  # Test case 6: All zeros - should remain zeros
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    psabs.db x14, x10 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 8: Saturation case - (-128) saturates to 127
  # rs1 = 0x8080808080808080 (all -128)
  # Result = 0x7F7F7F7F7F7F7F7F
  TEST_CASE( 8, x14, 0x7f7f7f7f, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    psabs.db x14, x10 );
  TEST_CASE( 9, x15, 0x7f7f7f7f, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

