# See LICENSE for license details.

#*****************************************************************************
# pmax_db.S
#-----------------------------------------------------------------------------
#
# Test pmax.db instruction (packed max byte signed, double-word, RV32 only).
# Note: rd and rs1 must be even registers (register-pair constraint).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmax.db rd, rs1, rs2
  # Performs packed signed max: rd[i] = max(rs1[i], rs2[i]) for each byte (64-bit)
  # rd and rs1 must be even registers

  # Test case 1: Simple max (5 vs 3 = 5)
  TEST_CASE( 2, x14, 0x05050505, \
    li x10, 0x05050505; \
    li x11, 0x05050505; \
    li x12, 0x03030303; \
    li x13, 0x03030303; \
    pmax.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x05050505, nop );

  # Test case 2: Reverse order (3 vs 5 = 5)
  TEST_CASE( 4, x14, 0x05050505, \
    li x10, 0x03030303; \
    li x11, 0x03030303; \
    li x12, 0x05050505; \
    li x13, 0x05050505; \
    pmax.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x05050505, nop );

  # Test case 3: Equal values
  TEST_CASE( 6, x14, 0x04040404, \
    li x10, 0x04040404; \
    li x11, 0x04040404; \
    li x12, 0x04040404; \
    li x13, 0x04040404; \
    pmax.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x04040404, nop );

  # Test case 4: Mixed positive and negative (signed: -1 vs 1 = 1)
  # 0xff = -1, 0x01 = 1
  TEST_CASE( 8, x14, 0x01010101, \
    li x10, 0xffffffff; \
    li x11, 0xffffffff; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pmax.db x14, x10, x12 );
  TEST_CASE( 9, x15, 0x01010101, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

