# See LICENSE for license details.

#*****************************************************************************
# unzip16hp.S
#-----------------------------------------------------------------------------
#
# Test unzip16hp instruction (unzip 16-bit elements, high part).
# Deinterleaves 16-bit elements from high halves.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip16hp rd, rs1, rs2
  # Deinterleaves halfwords from high halves

  # Test case 1: Simple deinterleave high
  TEST_CASE( 2, x14, 0x0007000600050004, \
    li x10, 0x0007000600050004; \
    li x12, 0x0003000200010000; \
    unzip16hp x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip16hp x14, x10, x12 );

  # Test case 3: Alternating pattern
  TEST_CASE( 4, x14, 0xFFFFFFFFFFFFFFFF, \
    li x10, 0xFFFFFFFFFFFFFFFF; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    unzip16hp x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

