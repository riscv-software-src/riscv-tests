# See LICENSE for license details.

#*****************************************************************************
# pmslt_db.S
#-----------------------------------------------------------------------------
#
# Test pmslt.db instruction (packed mask set less than byte signed, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmslt.db rd, rs1, rs2
  # Sets mask: rd[i] = 0xff if rs1[i] < rs2[i] (signed), else 0x00 for each byte (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: rs1 < rs2 - all masks set (3 < 5)
  TEST_CASE( 2, x14, 0xffffffff, \
    li x10, 0x03030303; \
    li x11, 0x03030303; \
    li x12, 0x05050505; \
    li x13, 0x05050505; \
    pmslt.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0xffffffff, nop );

  # Test case 2: rs1 > rs2 - no masks set (5 > 3)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x05050505; \
    li x11, 0x05050505; \
    li x12, 0x03030303; \
    li x13, 0x03030303; \
    pmslt.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: rs1 == rs2 - no masks set
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x04040404; \
    li x11, 0x04040404; \
    li x12, 0x04040404; \
    li x13, 0x04040404; \
    pmslt.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  # Test case 4: Signed comparison (-1 < 1 = true)
  # 0xff = -1, 0x01 = 1
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pmslt.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  # Test case 5: Signed comparison (1 < -1 = false)
  TEST_CASE( 10, x14, 0x00000000, \
    li x10, 0x01010101; \
    li x11, 0x01010101; \
    li x12, 0xffffffff; \
    li x13, 0xffffffff; \
    pmslt.db x14, x10, x12 );
  TEST_CASE( 11, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

