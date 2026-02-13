# See LICENSE for license details.

#*****************************************************************************
# pmq2adda_w.S
#-----------------------------------------------------------------------------
#
# Test pmq2adda.w instruction (packed multiply Q31 2-way add accumulate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmq2adda.w: packed multiply Q31 2-way add accumulate for 32-bit words
  # rd = rd + sum((rs1[i] * rs2[i]) >> 31) for each 64-bit segment

  # Test: 0x10 + ((0x40000000 * 0x40000000) >> 31) + ((0x40000000 * 0x40000000) >> 31)
  #     = 0x10 + 0x20000000 + 0x20000000 = 0x40000010
  TEST_CASE( 2, x14, 0x0000000040000010, \
    li x14, 0x0000000000000010; \
    li a1, 0x4000000040000000; \
    li a2, 0x4000000040000000; \
    pmq2adda.w x14, a1, a2 );

  # Test: 0x00 + ((0x10000000 * 0x10000000) >> 31) + ((0x10000000 * 0x10000000) >> 31)
  #     = 0x00 + 0x02000000 + 0x02000000 = 0x04000000
  TEST_CASE( 3, x14, 0x0000000004000000, \
    li x14, 0x0000000000000000; \
    li a1, 0x1000000010000000; \
    li a2, 0x1000000010000000; \
    pmq2adda.w x14, a1, a2 );

  # Test: 0x05 + ((0x20000000 * 0x20000000) >> 31) + ((0x20000000 * 0x20000000) >> 31)
  #     = 0x05 + 0x08000000 + 0x08000000 = 0x10000005
  TEST_CASE( 4, x14, 0x0000000010000005, \
    li x14, 0x0000000000000005; \
    li a1, 0x2000000020000000; \
    li a2, 0x2000000020000000; \
    pmq2adda.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

