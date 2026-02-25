# See LICENSE for license details.

#*****************************************************************************
# nsrl.S
#-----------------------------------------------------------------------------
#
# Test nsrl instruction (narrow shift right logical, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right logical
# by rs2, outputs 32-bit result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nsrl rd, rs1, rs2
  # rd = (uint64_t)(rs1_pair) >> (rs2 & 0x3f)

  # Test case 1: Simple shift
  # Input: 0x00000002_00000000 (2^33), shift by 1 = 0x100000000 -> low 32 bits = 0x00000000
  TEST_CASE( 2, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000002; \
    li x12, 1; \
    nsrl x14, x10, x12 );

  # Test case 2: Shift by 31
  # Input: 0x80000000_00000000, shift by 31 = 0x100000000 -> low 32 bits = 0x00000000
  TEST_CASE( 3, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x80000000; \
    li x12, 31; \
    nsrl x14, x10, x12 );

  # Test case 3: Unsigned shift (no sign extension)
  # Input: 0xFFFFFFFF_FFFFFFFE, shift by 1 = 0x7FFFFFFF_FFFFFFFF -> low 32 bits = 0xFFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFE; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    nsrl x14, x10, x12 );

  # Test case 4: Zero
  TEST_CASE( 5, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    nsrl x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

