# See LICENSE for license details.

#*****************************************************************************
# pmin_db.S
#-----------------------------------------------------------------------------
#
# Test pmin.db instruction (packed min byte signed, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmin.db rd, rs1, rs2
  # Performs packed signed min: rd[i] = min(rs1[i], rs2[i]) for each byte (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: Simple min (5 vs 3 = 3)
  TEST_CASE( 2, x14, 0x03030303, \
    li x10, 0x05050505; \
    li x11, 0x05050505; \
    li x12, 0x03030303; \
    li x13, 0x03030303; \
    pmin.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x03030303, nop );

  # Test case 2: Reverse order (3 vs 5 = 3)
  TEST_CASE( 4, x14, 0x03030303, \
    li x10, 0x03030303; \
    li x11, 0x03030303; \
    li x12, 0x05050505; \
    li x13, 0x05050505; \
    pmin.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x03030303, nop );

  # Test case 3: Equal values
  TEST_CASE( 6, x14, 0x04040404, \
    li x10, 0x04040404; \
    li x11, 0x04040404; \
    li x12, 0x04040404; \
    li x13, 0x04040404; \
    pmin.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x04040404, nop );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = -1)
  # 0xff = -1, 0x01 = 1
  TEST_CASE( 8, x14, 0xffffffff, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pmin.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0xffffffff, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

