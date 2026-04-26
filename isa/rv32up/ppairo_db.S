# See LICENSE for license details.

#*****************************************************************************
# ppairo_db.S
#-----------------------------------------------------------------------------
#
# Test ppairo.db instruction (Packed pair odd - double-word byte, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # ppairo.db rd, rs1, rs2
  # Selects odd bytes from rs1 and rs2 and packs them
  # rd and rs1 must be even registers

  # Test case 2: Distinct byte pattern
  # rs1 = 0x0706050403020100, rs2 = 0x0f0e0d0c0b0a0908
  # Odd bytes rs1: 01, 03, 05, 07; Odd bytes rs2: 09, 0b, 0d, 0f
  # Result low: 0x0b030901, Result high: 0x0f070d05
  TEST_CASE( 2, x14, 0x0b030901, \
    li x10, 0x03020100; \
    li x11, 0x07060504; \
    li x12, 0x0b0a0908; \
    li x13, 0x0f0e0d0c; \
    ppairo.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x0f070d05, nop );

  # Test case 4: Zero values
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    ppairo.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 6: All ones
  TEST_CASE( 6, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    ppairo.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0xffffffff, nop );

  # Test case 8: Alternating pattern
  # rs1 = 0x00ff00ff00ff00ff, rs2 = 0xaaffaaffaaffaaff
  # Odd bytes rs1: ff, ff, ff, ff; Odd bytes rs2: ff, ff, ff, ff
  # Result: 0xffffffffffffffff
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x00ff00ff; \
    li x11, 0x00ff00ff; \
    li x12, 0xaaffaaff; \
    li x13, 0xaaffaaff; \
    ppairo.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

