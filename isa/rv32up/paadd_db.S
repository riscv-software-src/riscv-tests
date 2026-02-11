# See LICENSE for license details.

#*****************************************************************************
# paadd_db.S
#-----------------------------------------------------------------------------
#
# Test paadd.db instruction (packed averaging byte add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paadd.db rd, rs1, rs2
  # Packed averaging byte addition: rd[i] = (rs1[i] + rs2[i]) >> 1 (signed)

  # Test case 1: Simple averaging add
  # (0x02 + 0x04) >> 1 = 0x03
  TEST_CASE( 2, x14, 0x03030303, \
    li x10, 0x02020202; \
    li x11, 0x02020202; \
    li x12, 0x04040404; \
    li x13, 0x04040404; \
    paadd.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x03030303, nop );

  # Test case 2: Zero averaging
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    paadd.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Odd sum (rounds down)
  # (0x01 + 0x02) >> 1 = 0x01
  TEST_CASE( 6, x14, 0x01010101, \
    li x10, 0x01010101; \
    li x11, 0x01010101; \
    li x12, 0x02020202; \
    li x13, 0x02020202; \
    paadd.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x01010101, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

