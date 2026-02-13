# See LICENSE for license details.

#*****************************************************************************
# zip16p.S
#-----------------------------------------------------------------------------
#
# Test zip16p instruction (zip 16-bit elements from two sources, RV64 only).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip16p (per P-ext spec):
  #   rd = s2[31:16] @ s1[31:16] @ s2[15:0] @ s1[15:0]
  # Operates on the LOW 32 bits of each source.

  # Test case 1: Simple interleave (low halves)
  # rs1 = 0x0004000300020001, rs2 = 0x0014001300120011
  # rd = s2.h1 @ s1.h1 @ s2.h0 @ s1.h0 = 0x0012 0x0002 0x0011 0x0001
  TEST_CASE( 2, x14, 0x0012000200110001, \
    li x10, 0x0004000300020001; \
    li x12, 0x0014001300120011; \
    zip16p x14, x10, x12 );

  # Test case 2: rs1 zero, rs2 has data only in HIGH 32 bits -> low halves are 0 -> rd = 0
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x10, 0x0000000000000000; \
    li x12, 0x0011001200000000; \
    zip16p x14, x10, x12 );

  # Test case 3: Alternating pattern
  TEST_CASE( 4, x14, 0xFFFFAAAAFFFFAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    zip16p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
