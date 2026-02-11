# See LICENSE for license details.

#*****************************************************************************
# psub_db.S
#-----------------------------------------------------------------------------
#
# Test psub.db instruction (packed byte subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psub.db rd, rs1, rs2
  # Packed byte subtraction on 64-bit register pairs

  # Test case 1: Simple byte subtraction
  # Low:  0x02030405 - 0x01010101 = 0x01020304
  # High: 0x06070809 - 0x01010101 = 0x05060708
  TEST_CASE( 2, x14, 0x01020304, \
    li x10, 0x02030405; \
    li x11, 0x06070809; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    psub.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x05060708, nop );

  # Test case 2: Zero - Zero
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psub.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Byte underflow (wraps)
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    psub.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

