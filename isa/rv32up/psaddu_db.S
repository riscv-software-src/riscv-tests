# See LICENSE for license details.

#*****************************************************************************
# psaddu_db.S
#-----------------------------------------------------------------------------
#
# Test psaddu.db instruction (packed unsigned saturating byte add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # psaddu.db rd, rs1, rs2
  # Packed unsigned saturating byte addition: saturates to [0, 255]

  # Test case 1: Simple addition (no saturation)
  TEST_CASE( 2, x14, 0x03030303, \
    li x10, 0x01010101; \
    li x11, 0x01010101; \
    li x12, 0x02020202; \
    li x13, 0x02020202; \
    psaddu.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x03030303, nop );

  # Test case 2: Unsigned saturation (0xFF + 0x01 saturates to 0xFF)
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    psaddu.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0xFFFFFFFF, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

