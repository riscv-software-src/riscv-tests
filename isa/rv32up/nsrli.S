# See LICENSE for license details.

#*****************************************************************************
# nsrli.S
#-----------------------------------------------------------------------------
#
# Test nsrli instruction (narrow shift right logical immediate, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right logical,
# outputs 32-bit result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nsrli rd, rs1, imm
  # rd = (uint64_t)(rs1_pair) >> imm

  # Test case 1: Simple shift
  # Input: 0x00000002_00000000 (2^33), shift by 1 = 0x100000000 -> low 32 bits = 0x00000000
  TEST_CASE( 2, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000002; \
    nsrli x14, x10, 1 );

  # Test case 2: Shift by 31
  # Input: 0x80000000_00000000, shift by 31 = 0x100000000 -> low 32 bits = 0x00000000
  TEST_CASE( 3, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x80000000; \
    nsrli x14, x10, 31 );

  # Test case 3: Unsigned shift (no sign extension)
  # Input: 0xFFFFFFFF_FFFFFFFE, shift by 1 = 0x7FFFFFFF_FFFFFFFF -> low 32 bits = 0xFFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFE; \
    li x11, 0xFFFFFFFF; \
    nsrli x14, x10, 1 );

  # Test case 4: Zero
  TEST_CASE( 5, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    nsrli x14, x10, 5 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

