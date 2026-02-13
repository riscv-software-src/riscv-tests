# See LICENSE for license details.

#*****************************************************************************
# pmhracc_w.S
#-----------------------------------------------------------------------------
#
# Test pmhracc.w instruction (packed multiply-high rounding accumulate word, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # pmhracc.w: packed multiply-high rounding accumulate for words
  # rd[i] += ((rs1[i] * rs2[i]) + 0x80000000) >> 32 (signed) for each 32-bit word

  # Test: 0x10 + (0x10000 * 0x10000 + 0x80000000) >> 32 = 0x10 + 0x01 = 0x11
  TEST_CASE( 2, x14, 0x0000001100000011, \
    li x14, 0x0000001000000010; \
    li a1, 0x0001000000010000; \
    li a2, 0x0001000000010000; \
    pmhracc.w x14, a1, a2 );

  # Test: 0x00 + (0x20000 * 0x20000 + 0x80000000) >> 32 = 0x00 + 0x04 = 0x04
  TEST_CASE( 3, x14, 0x0000000400000004, \
    li x14, 0x0000000000000000; \
    li a1, 0x0002000000020000; \
    li a2, 0x0002000000020000; \
    pmhracc.w x14, a1, a2 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

