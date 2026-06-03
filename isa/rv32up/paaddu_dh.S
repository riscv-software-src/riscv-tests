# See LICENSE for license details.

#*****************************************************************************
# paaddu_dh.S
#-----------------------------------------------------------------------------
#
# Test paaddu.dh instruction (packed unsigned averaging halfword add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paaddu.dh rd, rs1, rs2
  # Packed unsigned averaging halfword addition: rd[i] = (rs1[i] + rs2[i]) >> 1 (unsigned)

  # Test case 1: Simple averaging add
  TEST_CASE( 2, x14, 0x00030003, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    li x12, 0x00040004; \
    li x13, 0x00040004; \
    paaddu.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00030003, nop );

  # Test case 2: Unsigned averaging with high values
  # (0xFFFF + 0x0001) >> 1 = 0x8000 (unsigned)
  TEST_CASE( 4, x14, 0x80008000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00010001; \
    li x13, 0x00010001; \
    paaddu.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x80008000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

