# See LICENSE for license details.

#*****************************************************************************
# ppaireo_db.S
#-----------------------------------------------------------------------------
#
# Test ppaireo.db instruction (Packed pair even-odd - double-word byte, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # ppaireo.db rd, rs1, rs2
  # Selects even bytes from rs1 and odd bytes from rs2 and packs them
  # rd and rs1 must be even registers

  # Test case 2: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Even bytes rs1: 00, 02, 04, 06; Odd bytes rs2: 09, 0b, 0d, 0f
  # Result low: 0x0b020900, Result high: 0x0f060d04
  TEST_CASE( 2, x14, 0x0b020900, \
    li x10, 0x03020100; \
    li x11, 0x07060504; \
    li x12, 0x0b0a0908; \
    li x13, 0x0f0e0d0c; \
    ppaireo.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x0f060d04, nop );

  # Test case 4: Zero values
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    ppaireo.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: All ones
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    ppaireo.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 8: Alternating pattern
  # rs1 = 0xff00ff00ff00ff00, rs2 = 0xaaffaaffaaffaaff
  # Even bytes rs1: 00, 00, 00, 00; Odd bytes rs2: ff, ff, ff, ff
  # Result: 0xff00ff00ff00ff00
  TEST_CASE( 8, x14, 0xff00ff00, \
    li x10, 0xff00ff00; \
    li x11, 0xff00ff00; \
    li x12, 0xaaffaaff; \
    li x13, 0xaaffaaff; \
    ppaireo.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xff00ff00, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

