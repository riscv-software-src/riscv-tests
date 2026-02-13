# See LICENSE for license details.

#*****************************************************************************
# zip16hp.S
#-----------------------------------------------------------------------------
#
# Test zip16hp instruction (zip 16-bit elements from two sources, high part).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip16hp (per P-ext spec):
  #   rd = s2[63:48] @ s1[63:48] @ s2[47:32] @ s1[47:32]
  # Operates on the HIGH 32 bits of each source.

  # Test case 1: Simple interleave (high halves)
  # rs1 = 0x0004000300020001, rs2 = 0x0014001300120011
  # rd = s2.h3 @ s1.h3 @ s2.h2 @ s1.h2 = 0x0014 0x0004 0x0013 0x0003
  TEST_CASE( 2, x14, 0x0014000400130003, \
    li x10, 0x0004000300020001; \
    li x12, 0x0014001300120011; \
    zip16hp x14, x10, x12 );

  # Test case 2: rs1 zero, rs2 has data only in LOW 32 bits -> high halves are 0 -> rd = 0
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x10, 0x0000000000000000; \
    li x12, 0x0000000000120011; \
    zip16hp x14, x10, x12 );

  # Test case 3: Alternating pattern
  TEST_CASE( 4, x14, 0xFFFFAAAAFFFFAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    zip16hp x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
