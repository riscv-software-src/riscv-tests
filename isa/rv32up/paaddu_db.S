# See LICENSE for license details.

#*****************************************************************************
# paaddu_db.S
#-----------------------------------------------------------------------------
#
# Test paaddu.db instruction (packed unsigned averaging byte add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paaddu.db rd, rs1, rs2
  # Packed unsigned averaging byte addition: rd[i] = (rs1[i] + rs2[i]) >> 1 (unsigned)

  # Test case 1: Simple averaging add
  TEST_CASE( 2, x14, 0x03030303, \
    li x10, 0x02020202; \
    li x11, 0x02020202; \
    li x12, 0x04040404; \
    li x13, 0x04040404; \
    paaddu.db x14, x10, x12 );
  TEST_CASE( 3, x15, 0x03030303, nop );

  # Test case 2: Unsigned averaging with high values
  # (0xFF + 0x01) >> 1 = 0x80 (unsigned)
  TEST_CASE( 4, x14, 0x80808080, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x01010101; \
    li x13, 0x01010101; \
    paaddu.db x14, x10, x12 );
  TEST_CASE( 5, x15, 0x80808080, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

