# See LICENSE for license details.

#*****************************************************************************
# pmhacc_w_h0.S
#-----------------------------------------------------------------------------
#
# Test pmhacc.w.h0 instruction (packed multiply-high accumulate word h0, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhacc.w.h0: packed multiply-high accumulate for words using low halfword
  # rd[i] += (sext(rs1[i].h0) * sext(rs2[i])) >> 16 for each 32-bit word

  # Test: 0x10 + (0x100 * 0x10000) >> 16 = 0x10 + 0x100 = 0x110
  TEST_CASE( 2, x14, 0x0000011000000110, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000010000000100; \
    li a2, 0x0001000000010000; \
    pmhacc.w.h0 x14, a1, a2 );

  # Test: 0x00 + (0x200 * 0x20000) >> 16 = 0x00 + 0x400 = 0x400
  TEST_CASE( 3, x14, 0x0000040000000400, \
    li x14, 0x0000000000000000; \
    li a1, 0x0000020000000200; \
    li a2, 0x0002000000020000; \
    pmhacc.w.h0 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

