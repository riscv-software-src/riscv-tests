# See LICENSE for license details.

#*****************************************************************************
# wmaccsu.S
#-----------------------------------------------------------------------------
#
# Test wmaccsu instruction (widening multiply accumulate signed-unsigned).
# RV32-only instruction using register pairs for 64-bit accumulator.
# rd = rd + (signed)rs1 * (unsigned)rs2
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # wmaccsu rd, rs1, rs2
  # rd[63:0] = rd[63:0] + (signed)rs1[31:0] * (unsigned)rs2[31:0]
  # rd is a register pair (rd, rd+1)

  # Test 2: Simple accumulate
  # Accum = 10, 3 * 4 = 12, result = 22
  TEST_CASE( 2, x14, 22, \
    li x14, 10; \
    li x15, 0; \
    li a1, 3; \
    li a2, 4; \
    wmaccsu x14, a1, a2 );
  TEST_CASE( 3, x15, 0, nop );

  # Test 4: Negative signed operand with positive unsigned
  # Accum = 100, (-2) * 3 = -6, result = 94
  TEST_CASE( 4, x14, 94, \
    li x14, 100; \
    li x15, 0; \
    li a1, -2; \
    li a2, 3; \
    wmaccsu x14, a1, a2 );
  TEST_CASE( 5, x15, 0, nop );

  # Test 6: Unsigned operand treated as unsigned (0xFFFFFFFF = 4294967295)
  # Accum = 0, 1 * 0xFFFFFFFF = 0xFFFFFFFF
  TEST_CASE( 6, x14, 0xFFFFFFFF, \
    li x14, 0; \
    li x15, 0; \
    li a1, 1; \
    li a2, 0xFFFFFFFF; \
    wmaccsu x14, a1, a2 );
  TEST_CASE( 7, x15, 0, nop );

  # Test 8: Negative signed * large unsigned
  # Accum = 0, (-1) * 2 = -2 (sign extended to 64-bit)
  TEST_CASE( 8, x14, 0xFFFFFFFE, \
    li x14, 0; \
    li x15, 0; \
    li a1, -1; \
    li a2, 2; \
    wmaccsu x14, a1, a2 );
  TEST_CASE( 9, x15, 0xFFFFFFFF, nop );

  # Test 10: Zero accumulator
  # Accum = 0, 5 * 6 = 30, result = 30
  TEST_CASE( 10, x14, 30, \
    li x14, 0; \
    li x15, 0; \
    li a1, 5; \
    li a2, 6; \
    wmaccsu x14, a1, a2 );
  TEST_CASE( 11, x15, 0, nop );

  # Test 12: Large product
  # Accum = 0, 0x10000 * 0x10000 = 0x100000000
  TEST_CASE( 12, x14, 0, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x10000; \
    li a2, 0x10000; \
    wmaccsu x14, a1, a2 );
  TEST_CASE( 13, x15, 1, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

