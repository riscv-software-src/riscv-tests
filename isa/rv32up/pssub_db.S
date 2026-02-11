# See LICENSE for license details.

#*****************************************************************************
# pssub_db.S
#-----------------------------------------------------------------------------
#
# Test pssub.db instruction (packed saturating byte subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pssub.db rd, rs1, rs2
  # Packed saturating byte subtraction (signed): saturates to [-128, 127]

  # Test case 1: Simple subtraction (no saturation)
  TEST_CASE( 2, x14, 0x01010101, \
    li x10, 0x03030303; \
    li x11, 0x03030303; \
    li x12, 0x02020202; \
    li x13, 0x02020202; \
    pssub.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x01010101, nop );

  # Test case 2: Negative saturation (0x80 - 0x01 saturates to 0x80)
  TEST_CASE( 4, x14, 0x80808080, \
    li x10, 0x80808080; \
    li x11, 0x80808080; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    pssub.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x80808080, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

