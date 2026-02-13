# See LICENSE for license details.

#*****************************************************************************
# zip8hp.S
#-----------------------------------------------------------------------------
#
# Test zip8hp instruction (zip 8-bit elements from two sources, high part).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip8hp (per P-ext spec):
  #   rd = s2[63:56]@s1[63:56] @ s2[55:48]@s1[55:48] @ s2[47:40]@s1[47:40] @ s2[39:32]@s1[39:32]
  # Operates on the HIGH 32 bits of each source.

  # Test case 1: Simple interleave of high 32 bits
  # rs1 = 0x0807060504030201 -> high bytes: 08, 07, 06, 05
  # rs2 = 0x1817161514131211 -> high bytes: 18, 17, 16, 15
  # rd = 18 08 17 07 16 06 15 05
  TEST_CASE( 2, x14, 0x1808170716061505, \
    li x10, 0x0807060504030201; \
    li x12, 0x1817161514131211; \
    zip8hp x14, x10, x12 );

  # Test case 2: rs1 zero, rs2 has data only in LOW 32 bits -> high bytes are 0 -> rd = 0
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x10, 0x0000000000000000; \
    li x12, 0x0000000014131211; \
    zip8hp x14, x10, x12 );

  # Test case 3: Identity pattern
  TEST_CASE( 4, x14, 0xFFAAFFAAFFAAFFAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    zip8hp x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
