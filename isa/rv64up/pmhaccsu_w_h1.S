# See LICENSE for license details.

#*****************************************************************************
# pmhaccsu_w_h1.S
#-----------------------------------------------------------------------------
#
# Test pmhaccsu.w.h1 instruction (packed multiply-high accumulate word signed*unsigned h1, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhaccsu.w.h1: packed multiply-high accumulate signed*unsigned for words using high halfword
  # rd[i] += (sext(rs1[i].h1) * zext(rs2[i])) >> 16 for each 32-bit word

  # Test: 0x10 + (0x100 * 0x10000) >> 16 = 0x10 + 0x100 = 0x110
  TEST_CASE( 2, x14, 0x0000011000000110, \
    li x14, 0x0000001000000010; \
    li a1, 0x0100000001000000; \
    li a2, 0x0001000000010000; \
    pmhaccsu.w.h1 x14, a1, a2 );

  # Test: 0x100 + (-1 * 0x100) >> 16 = 0x100 + (-1) = 0xff
  TEST_CASE( 3, x14, 0x000000ff000000ff, \
    li x14, 0x0000010000000100; \
    li a1, 0xffff0000ffff0000; \
    li a2, 0x0001000000010000; \
    pmhaccsu.w.h1 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

