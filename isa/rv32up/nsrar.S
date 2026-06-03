# See LICENSE for license details.

#*****************************************************************************
# nsrar.S
#-----------------------------------------------------------------------------
#
# Test nsrar instruction (narrow shift right arithmetic rounding, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right arithmetic
# with rounding by rs2, outputs 32-bit result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nsrar rd, rs1, rs2
  # rd = ((int64_t)(rs1_pair) >> (rs2 & 0x3f)) + round_bit

  # Test case 1: Rounding up
  # Input: 0x00000000_00000003, shift by 1 = 1 + round(1) = 2
  TEST_CASE( 2, x14, 0x00000002, \
    li x10, 0x00000003; \
    li x11, 0x00000000; \
    li x12, 1; \
    nsrar x14, x10, x12 );

  # Test case 2: No rounding (bit before shift point is 0)
  # Input: 0x00000000_00000004, shift by 1 = 2 + round(0) = 2
  TEST_CASE( 3, x14, 0x00000002, \
    li x10, 0x00000004; \
    li x11, 0x00000000; \
    li x12, 1; \
    nsrar x14, x10, x12 );

  # Test case 3: Shift by 31 with rounding
  # Input: 0x00000000_C0000000, shift by 31 = 1 + round(1) = 2
  TEST_CASE( 4, x14, 0x00000002, \
    li x10, 0xC0000000; \
    li x11, 0x00000000; \
    li x12, 31; \
    nsrar x14, x10, x12 );

  # Test case 4: Zero shift (no rounding)
  TEST_CASE( 5, x14, 0x00000005, \
    li x10, 0x00000005; \
    li x11, 0x00000000; \
    li x12, 0; \
    nsrar x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

