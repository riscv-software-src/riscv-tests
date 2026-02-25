# See LICENSE for license details.

#*****************************************************************************
# nclipri.S
#-----------------------------------------------------------------------------
#
# Test nclipri instruction (narrow clip rounding immediate, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right arithmetic
# with rounding, saturates to signed 32-bit, outputs result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nclipri rd, rs1, imm
  # rd = SAT32(((int64_t)(rs1_pair) >> imm) + round_bit)

  # Test case 1: No saturation, with rounding
  # Input: 0x00000000_00000003, shift by 1 = 1 + round(1) = 2
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000003; \
    li x11, 0x00000000; \
    nclipri x14, x10, 1 );

  # Test case 2: Positive saturation after rounding
  # Input: 0x00000000_FFFFFFFF (max signed 32 before overflow), shift by 0 = saturate
  TEST_CASE( 3, x14, 0x7FFFFFFF, \
    li x10, 0x00000000; \
    li x11, 0x00000001; \
    nclipri x14, x10, 0 );

  # Test case 3: Shift by 31 with rounding
  # Input: 0x00000000_C0000000, shift by 31 = 1 + round(1) = 2
  TEST_CASE( 4, x14, 0x00000002, \
    li x10, 0xC0000000; \
    li x11, 0x00000000; \
    nclipri x14, x10, 31 );

  # Test case 4: Zero shift (saturation check)
  TEST_CASE( 5, x14, 0x00000005, \
    li x10, 0x00000005; \
    li x11, 0x00000000; \
    nclipri x14, x10, 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

