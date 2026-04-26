# See LICENSE for license details.

#*****************************************************************************
# nclipi.S
#-----------------------------------------------------------------------------
#
# Test nclipi instruction (narrow clip immediate, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right arithmetic,
# saturates to signed 32-bit, outputs result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nclipi rd, rs1, imm
  # rd = SAT32((int64_t)(rs1_pair) >> imm)

  # Test case 1: No saturation needed
  # Input: 0x00000000_00000010, shift by 1 = 8
  TEST_CASE( 2, x14, 0x00000008, \
    li x10, 0x00000010; \
    li x11, 0x00000000; \
    nclipi x14, x10, 1 );

  # Test case 2: Positive saturation
  # Input: 0x00000001_00000000 (2^32), shift by 0 = saturate to 0x7FFFFFFF
  TEST_CASE( 3, x14, 0x7FFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000001; \
    nclipi x14, x10, 0 );

  # Test case 3: Negative saturation
  # Input: 0xFFFFFFFE_00000000 (-2^33), shift by 0 = saturate to 0x80000000
  TEST_CASE( 4, x14, 0x80000000, \
    li x10, 0x00000000; \
    li x11, 0xFFFFFFFE; \
    nclipi x14, x10, 0 );

  # Test case 4: Shift reduces value to fit
  # Input: 0x00000000_80000000, shift by 31 = 1 (fits)
  TEST_CASE( 5, x14, 0x00000001, \
    li x10, 0x80000000; \
    li x11, 0x00000000; \
    nclipi x14, x10, 31 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

