# See LICENSE for license details.

#*****************************************************************************
# zip16p.S
#-----------------------------------------------------------------------------
#
# Test zip16p instruction (zip 16-bit elements from two sources, RV64 only).
# Interleaves 16-bit elements: rd[i] = (i % 2) ? rs2[i/2] : rs1[i/2]
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # zip16p rd, rs1, rs2
  # Interleaves halfwords: rd = {rs2[1], rs1[1], rs2[0], rs1[0]}

  # Test case 1: Simple interleave
  # rs1 = 0x0004000300020001, rs2 = 0x0014001300120011
  # rd = {0x0014, 0x0004, 0x0013, 0x0003, 0x0012, 0x0002, 0x0011, 0x0001}
  TEST_CASE( 2, x14, 0x0014000400130003, \
    li x10, 0x0004000300020001; \
    li x12, 0x0014001300120011; \
    zip16p x14, x10, x12 );

  # Test case 2: All zeros from rs1
  TEST_CASE( 3, x14, 0x0011000000120000, \
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

