# See LICENSE for license details.

#*****************************************************************************
# padd_db.S
#-----------------------------------------------------------------------------
#
# Test padd.db instruction (packed byte add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # padd.db rd, rs1, rs2
  # Packed byte addition on 64-bit register pairs

  # Test case 1: Simple byte addition
  # Low:  0x01020304 + 0x01010101 = 0x02030405
  # High: 0x05060708 + 0x01010101 = 0x06070809
  TEST_CASE( 2, x14, 0x02030405, \
    li x10, 0x01020304; \
    li x11, 0x05060708; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    padd.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x06070809, nop );

  # Test case 2: Zero + Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    padd.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Byte overflow (wraps)
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    padd.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

