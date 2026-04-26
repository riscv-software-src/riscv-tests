# See LICENSE for license details.

#*****************************************************************************
# pmhaccsu_h_b0.S
#-----------------------------------------------------------------------------
#
# Test pmhaccsu.h.b0 instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhaccsu.h.b0: packed multiply-high accumulate (signed-unsigned) with byte selection (even)
  # rd[i] += (rs1[i](signed) * rs2[even_byte](unsigned)) >> 16
  # Test: 0x0010 + (0x0100 * 0x0100) >> 16 = 0x0010 + 0x0001 = 0x0011
  TEST_CASE( 2, x14, 0x0011001100110011, \
    li x14, 0x0010001000100010; \
    li a1, 0x0100010001000100; \
    li a2, 0x0001000100010001; \
    pmhaccsu.h.b0 x14, a1, a2 );

  # Test: 0x0000 + (0x0200 * 0x0200) >> 16 = 0x0000 + 0x0004 = 0x0004
  TEST_CASE( 3, x14, 0x0004000400040004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0200020002000200; \
    li a2, 0x0002000200020002; \
    pmhaccsu.h.b0 x14, a1, a2 );

  # Test: 0x0005 + (0x0100 * 0x0300) >> 16 = 0x0005 + 0x0003 = 0x0008
  TEST_CASE( 4, x14, 0x0008000800080008, \
    li x14, 0x0005000500050005; \
    li a1, 0x0100010001000100; \
    li a2, 0x0003000300030003; \
    pmhaccsu.h.b0 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

