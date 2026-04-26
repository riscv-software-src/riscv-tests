# See LICENSE for license details.

#*****************************************************************************
# pasubu_db.S
#-----------------------------------------------------------------------------
#
# Test pasubu.db instruction (packed unsigned averaging byte subtract, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pasubu.db rd, rs1, rs2
  # Packed unsigned averaging byte subtraction: rd[i] = (rs1[i] - rs2[i]) >> 1 (unsigned)

  # Test case 1: Simple averaging subtract
  TEST_CASE( 2, x14, 0x01010101, \
    li x10, 0x04040404; \
    li x11, 0x04040404; \
    li x12, 0x02020202; \
    li x13, 0x02020202; \
    pasubu.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x01010101, nop );

  # Test case 2: Zero averaging
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    pasubu.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

