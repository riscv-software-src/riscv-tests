# See LICENSE for license details.

#*****************************************************************************
# nsra.S
#-----------------------------------------------------------------------------
#
# Test nsra instruction (narrow shift right arithmetic, RV32 only).
# Takes 64-bit input from register pair (rs1, rs1+1), shifts right arithmetic
# by rs2, outputs 32-bit result to rd.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  # nsra rd, rs1, rs2
  # rd = (int64_t)(rs1_pair) >> (rs2 & 0x3f)

  # Test case 1: Simple shift
  # Input: 0x00000002_00000000 (2^33), shift by 1 = 0x100000000 -> low 32 bits = 0x00000000
  TEST_CASE( 2, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000002; \
    li x12, 1; \
    nsra x14, x10, x12 );

  # Test case 2: Shift by 31
  # Input: 0x80000000_00000000 (-2^63), shift by 31 = 0xFFFFFFFF_00000000 -> low 32 bits = 0x00000000
  TEST_CASE( 3, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x80000000; \
    li x12, 31; \
    nsra x14, x10, x12 );

  # Test case 3: Negative value shift
  # Input: 0xFFFFFFFF_FFFFFFFE (-2), shift by 1 = -1 = 0xFFFFFFFF
  TEST_CASE( 4, x14, 0xFFFFFFFF, \
    li x10, 0xFFFFFFFE; \
    li x11, 0xFFFFFFFF; \
    li x12, 1; \
    nsra x14, x10, x12 );

  # Test case 4: Zero
  TEST_CASE( 5, x14, 0x00000000, \
    li x10, 0x00000000; \
    li x11, 0x00000000; \
    li x12, 5; \
    nsra x14, x10, x12 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
  TEST_DATA
RVTEST_DATA_END

