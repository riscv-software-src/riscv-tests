# See LICENSE for license details.

#*****************************************************************************
# paaddu_dw.S
#-----------------------------------------------------------------------------
#
# Test paaddu.dw instruction (packed unsigned averaging word add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paaddu.dw rd, rs1, rs2
  # Packed unsigned averaging word addition: rd[i] = (rs1[i] + rs2[i]) >> 1 (unsigned)

  # Test case 1: Simple averaging add
  TEST_CASE( 2, x14, 0x00000003, \
    li x10, 0x00000002; \
    li x11, 0x00000002; \
    li x12, 0x00000004; \
    li x13, 0x00000004; \
    paaddu.dw x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00000003, nop );

  # Test case 2: Unsigned averaging with high values
  # (0xFFFFFFFF + 0x00000001) >> 1 = 0x80000000 (unsigned)
  TEST_CASE( 4, x14, 0x80000000, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0x00000001; \
    li x13, 0x00000001; \
    paaddu.dw x14, x10, x12 );
  TEST_CASE( 5, x15, 0x80000000, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

