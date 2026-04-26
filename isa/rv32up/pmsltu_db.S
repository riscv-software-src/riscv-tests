# See LICENSE for license details.

#*****************************************************************************
# pmsltu_db.S
#-----------------------------------------------------------------------------
#
# Test pmsltu.db instruction (packed mask set less than byte unsigned, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmsltu.db rd, rs1, rs2
  # Sets mask: rd[i] = 0xff if rs1[i] < rs2[i] (unsigned), else 0x00 for each byte (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x03030303; \
    li x11, 0x03030303; \
    li x12, 0x05050505; \
    li x13, 0x05050505; \
    pmsltu.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x05050505; \
    li x11, 0x05050505; \
    li x12, 0x03030303; \
    li x13, 0x03030303; \
    pmsltu.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x04040404; \
    li x11, 0x04040404; \
    li x12, 0x04040404; \
    li x13, 0x04040404; \
    pmsltu.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 4: Unsigned comparison (0x01 < 0xff = true, since 1 < 255)
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0x01010101; \
    li x11, 0x01010101; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    pmsltu.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  # Test case 5: Unsigned comparison (0xff < 0x01 = false, since 255 > 1)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pmsltu.db x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

