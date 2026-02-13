# See LICENSE for license details.

#*****************************************************************************
# unzip16p.S
#-----------------------------------------------------------------------------
#
# Test unzip16p instruction (unzip 16-bit elements).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip16p (per P-ext spec):
  #   rd = s2[47:32] @ s2[15:0] @ s1[47:32] @ s1[15:0]
  # Picks halfwords h0 and h2 from each source.

  # Test case 1: Simple deinterleave
  # rs1 = 0x0007000600050004; s1.h0=0x0004, s1.h2=0x0006
  # rs2 = 0x0003000200010000; s2.h0=0x0000, s2.h2=0x0002
  # rd = s2.h2 @ s2.h0 @ s1.h2 @ s1.h0 = 0x0002 0x0000 0x0006 0x0004
  TEST_CASE( 2, x14, 0x0002000000060004, \
    li x10, 0x0007000600050004; \
    li x12, 0x0003000200010000; \
    unzip16p x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip16p x14, x10, x12 );

  # Test case 3: All ones
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
