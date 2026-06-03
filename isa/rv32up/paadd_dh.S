# See LICENSE for license details.

#*****************************************************************************
# paadd_dh.S
#-----------------------------------------------------------------------------
#
# Test paadd.dh instruction (packed averaging halfword add, double-word, RV32 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # paadd.dh rd, rs1, rs2
  # Packed averaging halfword addition: rd[i] = (rs1[i] + rs2[i]) >> 1 (signed)

  # Test case 1: Simple averaging add
  # (0x0002 + 0x0004) >> 1 = 0x0003
  TEST_CASE( 2, x14, 0x00030003, \
    li x10, 0x00020002; \
    li x11, 0x00020002; \
    li x12, 0x00040004; \
    li x13, 0x00040004; \
    paadd.dh x14, x10, x12 );
  TEST_CASE( 3, x15, 0x00030003, nop );

  # Test case 2: Zero averaging
  TEST_CASE( 4, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 0x00000000; \
    li x13, 0x00000000; \
    paadd.dh x14, x10, x12 );
  TEST_CASE( 5, x15, 0x00000000, nop );

  # Test case 3: Odd sum (rounds down)
  # (0x0001 + 0x0002) >> 1 = 0x0001
  TEST_CASE( 6, x14, 0x00010001, \
    li x10, 0x00010001; \
    li x11, 0x00010001; \
    li x12, 0x00020002; \
    li x13, 0x00020002; \
    paadd.dh x14, x10, x12 );
  TEST_CASE( 7, x15, 0x00010001, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

