# See LICENSE for license details.

#*****************************************************************************
# ppaire_db.S
#-----------------------------------------------------------------------------
#
# Test ppaire.db instruction (Packed pair even - double-word byte, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # ppaire.db rd, rs1, rs2
  # Selects even bytes from rs1 and rs2 and packs them
  # rd and rs1 must be even registers

  # Test case 2: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Even bytes rs1: 00, 02, 04, 06; Even bytes rs2: 08, 0a, 0c, 0e
  # Result low: 0x0a020800, Result high: 0x0e060c04
  TEST_CASE( 2, x14, 0x0a020800, \
    li x10, 0x03020100; \
    li x11, 0x07060504; \
    li x12, 0x0b0a0908; \
    li x13, 0x0f0e0d0c; \
    ppaire.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x0e060c04, nop );

  # Test case 4: Zero values
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    ppaire.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: All ones
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    ppaire.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 8: Alternating pattern
  # rs1 = 0xff00ff00ff00ff00, rs2 = 0xffaaffaaffaaffaa
  # Even bytes rs1: 00, 00, 00, 00; Even bytes rs2: aa, aa, aa, aa
  # Result: 0xaa00aa00aa00aa00
  TEST_CASE( 8, x14, 0xaa00aa00, \
    li x10, 0xff00ff00; \
    li x11, 0xff00ff00; \
    li x12, 0xffaaffaa; \
    li x13, 0xffaaffaa; \
    ppaire.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xaa00aa00, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

