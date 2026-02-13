# See LICENSE for license details.

#*****************************************************************************
# pmaccu_w_h00.S
#-----------------------------------------------------------------------------
#
# Test pmaccu.w.h00 instruction (packed multiply-accumulate word unsigned, h0*h0, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmaccu.w.h00: packed multiply-accumulate unsigned for words using low halfwords
  # rd[i] += zext(rs1[i].h0) * zext(rs2[i].h0) for each 32-bit word

  # Test: 0x10 + (2 * 3) = 16 + 6 = 22 = 0x16
  TEST_CASE( 2, x14, 0x0000001600000016, \
    li x14, 0x0000001000000010; \
    li a1, 0x0000000200000002; \
    li a2, 0x0000000300000003; \
    pmaccu.w.h00 x14, a1, a2 );

  # Test with large unsigned: 0x100 + (0xFFFF * 1) = 256 + 65535 = 65791 = 0x100ff
  TEST_CASE( 3, x14, 0x000100ff000100ff, \
    li x14, 0x0000010000000100; \
    li a1, 0x0000ffff0000ffff; \
    li a2, 0x0000000100000001; \
    pmaccu.w.h00 x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

