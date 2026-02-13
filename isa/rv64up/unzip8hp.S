# See LICENSE for license details.

#*****************************************************************************
# unzip8hp.S
#-----------------------------------------------------------------------------
#
# Test unzip8hp instruction (unzip 8-bit elements, high part).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip8hp (per P-ext spec):
  #   rd = s2[63:56]@s2[47:40]@s2[31:24]@s2[15:8] @ s1[63:56]@s1[47:40]@s1[31:24]@s1[15:8]
  # Picks odd-position bytes (b1, b3, b5, b7) from each source.

  # Test case 1: Pull odd-position bytes from each input.
  # rs1 = 0x0F0E0D0C0B0A0908; s1 odd bytes = 0x09, 0x0B, 0x0D, 0x0F
  # rs2 = 0x0706050403020100; s2 odd bytes = 0x01, 0x03, 0x05, 0x07
  # rd = (s2 odds) @ (s1 odds) = 0x07050301_0F0D0B09
  TEST_CASE( 2, x14, 0x070503010F0D0B09, \
    li x10, 0x0F0E0D0C0B0A0908; \
    li x12, 0x0706050403020100; \
    unzip8hp x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip8hp x14, x10, x12 );

  # Test case 3: All ones
  TEST_CASE( 4, x14, 0xFFFFFFFFFFFFFFFF, \
    li x10, 0xFFFFFFFFFFFFFFFF; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    unzip8hp x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
