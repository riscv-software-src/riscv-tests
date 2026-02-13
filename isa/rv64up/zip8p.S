# See LICENSE for license details.

#*****************************************************************************
# zip8p.S
#-----------------------------------------------------------------------------
#
# Test zip8p instruction (zip 8-bit elements from two sources).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip8p (per P-ext spec):
  #   rd = s2[31:24]@s1[31:24] @ s2[23:16]@s1[23:16] @ s2[15:8]@s1[15:8] @ s2[7:0]@s1[7:0]
  # Operates on the LOW 32 bits of each source.

  # Test case 1: Simple interleave of low 32 bits
  # rs1 = 0x0807060504030201 -> low bytes: 04, 03, 02, 01
  # rs2 = 0x1817161514131211 -> low bytes: 14, 13, 12, 11
  # rd = 14 04 13 03 12 02 11 01
  TEST_CASE( 2, x14, 0x1404130312021101, \
    li x10, 0x0807060504030201; \
    li x12, 0x1817161514131211; \
    zip8p x14, x10, x12 );

  # Test case 2: rs1 zero, rs2 has data only in HIGH 32 bits -> low bytes are 0 -> rd = 0
  TEST_CASE( 3, x14, 0x0000000000000000, \
    li x10, 0x0000000000000000; \
    li x12, 0x1113151700000000; \
    zip8p x14, x10, x12 );

  # Test case 3: Identity pattern
  TEST_CASE( 4, x14, 0xFFAAFFAAFFAAFFAA, \
    li x10, 0xAAAAAAAAAAAAAAAA; \
    li x12, 0xFFFFFFFFFFFFFFFF; \
    zip8p x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END
