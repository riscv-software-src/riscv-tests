# See LICENSE for license details.

#*****************************************************************************
# zip8hp.S
#-----------------------------------------------------------------------------
#
# Test zip8hp instruction (zip 8-bit elements from two sources, high part).
# Interleaves 8-bit elements from high halves.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip8hp rd, rs1, rs2
  # Interleaves bytes from high halves

  # Test case 1: Simple interleave high
  # rs1 = 0x0807060504030201, rs2 = 0x1817161514131211
  TEST_CASE( 2, x14, 0x1404130312021101, \
    li x10, 0x0807060504030201; \
    li x12, 0x1817161514131211; \
    zip8hp x14, x10, x12 );

  # Test case 2: All zeros from rs1
  TEST_CASE( 3, x14, 0x1400130012001100, \
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

