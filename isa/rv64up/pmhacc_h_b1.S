# See LICENSE for license details.

#*****************************************************************************
# pmhacc_h_b1.S
#-----------------------------------------------------------------------------
#
# Test pmhacc.h.b1 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhacc.h.b1: packed multiply-high accumulate with byte selection (odd bytes)
  # rd[i] += (rs1[i] * rs2[odd_byte]) >> 16 (signed)
  # Test: 0x0010 + (0x0100 * 0x0100) >> 16 = 0x0010 + 0x0001 = 0x0011
  TEST_CASE( 2, x14, 0x0011001100110011, \
    li x14, 0x0010001000100010; \
    li a1, 0x0100010001000100; \
    li a2, 0x0100010001000100; \
    pmhacc.h.b1 x14, a1, a2 );

  # Test: 0x0000 + (0x0200 * 0x0200) >> 16 = 0x0000 + 0x0004 = 0x0004
  TEST_CASE( 3, x14, 0x0004000400040004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0200020002000200; \
    li a2, 0x0200020002000200; \
    pmhacc.h.b1 x14, a1, a2 );

  # Test: 0x0005 + (0x0100 * 0x0300) >> 16 = 0x0005 + 0x0003 = 0x0008
  TEST_CASE( 4, x14, 0x0008000800080008, \
    li x14, 0x0005000500050005; \
    li a1, 0x0100010001000100; \
    li a2, 0x0300030003000300; \
    pmhacc.h.b1 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

