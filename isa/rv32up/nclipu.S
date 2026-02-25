# See LICENSE for license details.

#*****************************************************************************
# nclipu.S
#-----------------------------------------------------------------------------
#
# Test nclipu instruction (narrow clip unsigned, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right logical
# by rs2, saturates to unsigned 32-bit, outputs result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nclipu rd, rs1, rs2
  # rd = USAT32((uint64_t)(rs1_pair) >> (rs2 & 0x3f))

  # Test case 1: No saturation needed
  # Input: 0x00000000_00000010, shift by 1 = 8
  TEST_CASE( 2, x14, 0x00000008, \
    li x10, 0x00000010; \
    li x11, 0x00000000; \
    li x12, 1; \
    nclipu x14, x10, x12 );

  # Test case 2: Positive saturation
  # Input: 0x00000001_00000000 (2^32), shift by 0 = saturate to 0xFFFFFFFF
  TEST_CASE( 3, x14, 0xFFFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000001; \
    li x12, 0; \
    nclipu x14, x10, x12 );

  # Test case 3: Large value saturation
  # Input: 0xFFFFFFFF_FFFFFFFF, shift by 0 = saturate to 0xFFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFF; \
    li x11, 0xFFFFFFFF; \
    li x12, 0; \
    nclipu x14, x10, x12 );

  # Test case 4: Shift reduces value to fit
  # Input: 0x00000000_80000000, shift by 31 = 1 (fits)
  TEST_CASE( 5, x14, 0x00000001, \
    li x10, 0x80000000; \
    li x11, 0x00000000; \
    li x12, 31; \
    nclipu x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

