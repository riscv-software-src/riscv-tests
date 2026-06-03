# See LICENSE for license details.

#*****************************************************************************
# srari64.S
#-----------------------------------------------------------------------------
#
# Test srari64 instruction (shift right arithmetic rounding immediate, RV64 only).
# Assembler mnemonic: srari
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

  # srari rd, rs1, imm
  # rd = (rs1 >> imm) + round_bit (if imm != 0)

  # Test case 1: Rounding up
  # Input: 0x03, shift by 1 = 1 + round(1) = 2
  TEST_CASE( 2, x14, 0x0000000000000002, \
    li x10, 0x0000000000000003; \
    srari x14, x10, 1 );

  # Test case 2: No rounding (bit before shift point is 0)
  # Input: 0x04, shift by 1 = 2 + round(0) = 2
  TEST_CASE( 3, x14, 0x0000000000000002, \
    li x10, 0x0000000000000004; \
    srari x14, x10, 1 );

  # Test case 3: Large shift with rounding
  # Input: 0xC000000000000000, shift by 63 = -1 + round(1) = 0
  TEST_CASE( 4, x14, 0x0000000000000000, \
    li x10, 0xC000000000000000; \
    srari x14, x10, 63 );

  # Test case 4: Zero shift (no rounding)
  TEST_CASE( 5, x14, 0x0000000000000005, \
    li x10, 0x0000000000000005; \
    srari x14, x10, 0 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

