# See LICENSE for license details.

#*****************************************************************************
# unzip8p.S
#-----------------------------------------------------------------------------
#
# Test unzip8p instruction (unzip 8-bit elements).
# Deinterleaves 8-bit elements.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip8p rd, rs1, rs2
  # Deinterleaves bytes

  # Test case 1: Simple deinterleave
  # Input interleaved: extract even/odd bytes
  TEST_CASE( 2, x14, 0x0706050403020100, \
    li x10, 0x0F0E0D0C0B0A0908; \
    li x12, 0x0706050403020100; \
    unzip8p x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip8p x14, x10, x12 );

  # Test case 3: Alternating pattern
  TEST_CASE( 4, x14, 0xFFFFFFFFFFFFFFFF, \
    li x10, 0xFFFFFFFFFFFFFFFF; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    unzip8p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

