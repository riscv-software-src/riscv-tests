# See LICENSE for license details.

#*****************************************************************************
# psadd_db.S
#-----------------------------------------------------------------------------
#
# Test psadd.db instruction (packed saturating byte add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psadd.db rd, rs1, rs2
  # Packed saturating byte addition (signed): saturates to [-128, 127]

  # Test case 1: Simple addition (no saturation)
  TEST_CASE( 2, x14, 0x03030303, \
    li x10, 0x01010101; \
    li x11, 0x01010101; \
    li x12, 0x02020202; \
    li x13, 0x02020202; \
    psadd.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x03030303, nop );

  # Test case 2: Positive saturation (0x7F + 0x01 saturates to 0x7F)
  TEST_CASE( 4, x14, 0x7F7F7F7F, \
    li x10, 0x7F7F7F7F; \
    li x11, 0x7F7F7F7F; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    psadd.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x7F7F7F7F, nop );

  # Test case 3: Zero + Zero
  TEST_CASE( 6, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    psadd.db x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

