# See LICENSE for license details.

#*****************************************************************************
# zip16hp.S
#-----------------------------------------------------------------------------
#
# Test zip16hp instruction (zip 16-bit elements from two sources, high part).
# Interleaves 16-bit elements from high halves.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip16hp rd, rs1, rs2
  # Interleaves halfwords from high halves

  # Test case 1: Simple interleave high
  # rs1 = 0x0004000300020001, rs2 = 0x0014001300120011
  TEST_CASE( 2, x14, 0x0012000200110001, \
    li x10, 0x0004000300020001; \
    li x12, 0x0014001300120011; \
    zip16hp x14, x10, x12 );

  # Test case 2: All zeros from rs1
  TEST_CASE( 3, x14, 0x0012000000110000, \
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

