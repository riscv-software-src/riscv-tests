# See LICENSE for license details.

#*****************************************************************************
# unzip8p.S
#-----------------------------------------------------------------------------
#
# Test unzip8p instruction (unzip 8-bit elements).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip8p (per P-ext spec):
  #   rd = s2[55:48]@s2[39:32]@s2[23:16]@s2[7:0] @ s1[55:48]@s1[39:32]@s1[23:16]@s1[7:0]
  # Picks even-position bytes (b0, b2, b4, b6) from each source.

  # Test case 1: Pull even-position bytes from each input.
  # rs1 = 0x1808170716061505; s1 even bytes = 0x05, 0x06, 0x07, 0x08
  # rs2 = 0x1404130312021101; s2 even bytes = 0x01, 0x02, 0x03, 0x04
  # rd = (s2 evens) @ (s1 evens) = 0x04030201_08070605
  TEST_CASE( 2, x14, 0x0403020108070605, \
    li x10, 0x1808170716061505; \
    li x12, 0x1404130312021101; \
    unzip8p x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip8p x14, x10, x12 );

  # Test case 3: Alternating FF/AA pattern -- even bytes all 0xAA
  TEST_CASE( 4, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xFFAAFFAAFFAAFFAA; \
    li x12, 0xFFAAFFAAFFAAFFAA; \
    unzip8p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
