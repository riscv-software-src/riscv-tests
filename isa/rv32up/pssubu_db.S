# See LICENSE for license details.

#*****************************************************************************
# pssubu_db.S
#-----------------------------------------------------------------------------
#
# Test pssubu.db instruction (packed unsigned saturating byte subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssubu.db rd, rs1, rs2
  # Packed unsigned saturating byte subtraction: saturates to [0, 255]

  # Test case 1: Simple subtraction (no saturation)
  TEST_CASE( 2, x14, 0x01010101, \
    li x10, 0x03030303; \
    li x11, 0x03030303; \
    li x12, 0x02020202; \
    li x13, 0x02020202; \
    pssubu.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x01010101, nop );

  # Test case 2: Unsigned saturation to 0 (0x00 - 0x01 saturates to 0x00)
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pssubu.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

