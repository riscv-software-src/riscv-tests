# See LICENSE for license details.

#*****************************************************************************
# unzip16hp.S
#-----------------------------------------------------------------------------
#
# Test unzip16hp instruction (unzip 16-bit elements, high part).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # unzip16hp (per P-ext spec):
  #   rd = s2[63:48] @ s2[31:16] @ s1[63:48] @ s1[31:16]
  # Picks halfwords h1 and h3 from each source.

  # Test case 1: Simple deinterleave high
  # rs1 = 0x0007000600050004; s1.h1=0x0005, s1.h3=0x0007
  # rs2 = 0x0003000200010000; s2.h1=0x0001, s2.h3=0x0003
  # rd = s2.h3 @ s2.h1 @ s1.h3 @ s1.h1 = 0x0003 0x0001 0x0007 0x0005
  TEST_CASE( 2, x14, 0x0003000100070005, \
    li x10, 0x0007000600050004; \
    li x12, 0x0003000200010000; \
    unzip16hp x14, x10, x12 );

  # Test case 2: All same value
  TEST_CASE( 3, x14, 0xAAAAAAAAAAAAAAAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xAAAAAAAAAAAAAAAA; \
    unzip16hp x14, x10, x12 );

  # Test case 3: All ones
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
