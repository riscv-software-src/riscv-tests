# See LICENSE for license details.

#*****************************************************************************
# unzip16p.S
#-----------------------------------------------------------------------------
#
# Test unzip16p instruction (unzip 16-bit elements).
# Deinterleaves 16-bit elements.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip16p rd, rs1, rs2
  # Deinterleaves halfwords

  # Test case 1: Simple deinterleave
  TEST_CASE( 2, x14, 0x0003000200010000, \
    li x10, 0x0007000600050004; \
    li x12, 0x0003000200010000; \
    unzip16p x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip16p x14, x10, x12 );

  # Test case 3: Alternating pattern
  TEST_CASE( 4, x14, 0xFFFFFFFFFFFFFFFF, \
    li x10, 0xFFFFFFFFFFFFFFFF; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    unzip16p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

