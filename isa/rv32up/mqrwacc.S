# See LICENSE for license details.

#*****************************************************************************
# mqrwacc.S
#-----------------------------------------------------------------------------
#
# Test mqrwacc instruction (packed multiply Q-format rounding widening accumulate).
# RV32-only instruction using register pairs for 64-bit accumulator.
# rd = rd + ((signed)rs1 * (signed)rs2 + 0x40000000) >> 31
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  # mqrwacc rd, rs1, rs2
  # rd[63:0] = rd[63:0] + ((signed)rs1 * (signed)rs2 + 0x40000000) >> 31
  # rd is a register pair (rd, rd+1)
  # The 0x40000000 adds rounding before the shift

  # Test 2: Simple Q-format rounding multiply accumulate
  # Accum = 10, rs1 = 0x40000000 (0.5 in Q31), rs2 = 0x40000000 (0.5 in Q31)
  # 0.5 * 0.5 = 0.25, rounded: (0x40000000 * 0x40000000 + 0x40000000) >> 31 = 0x20000000
  TEST_CASE( 2, x14, 0x2000000A, \
    li x14, 10; \
    li x15, 0; \
    li a1, 0x40000000; \
    li a2, 0x40000000; \
    mqrwacc x14, a1, a2 );
  TEST_CASE( 3, x15, 0, nop );

  # Test 4: Zero accumulator with rounding
  # Accum = 0, rs1 = 0x7FFFFFFF (~1.0), rs2 = 0x40000000 (0.5)
  # With rounding: result ≈ 0x40000000
  TEST_CASE( 4, x14, 0x40000000, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x7FFFFFFF; \
    li a2, 0x40000000; \
    mqrwacc x14, a1, a2 );
  TEST_CASE( 5, x15, 0, nop );

  # Test 6: Negative values with rounding
  # Accum = 100, rs1 = 0x80000000 (-1.0 in Q31), rs2 = 0x40000000 (0.5)
  # -1.0 * 0.5 + rounding = -0.5 rounded
  TEST_CASE( 6, x14, 0xC0000064, \
    li x14, 100; \
    li x15, 0; \
    li a1, 0x80000000; \
    li a2, 0x40000000; \
    mqrwacc x14, a1, a2 );
  TEST_CASE( 7, x15, 0xFFFFFFFF, nop );

  # Test 8: Both negative with rounding
  # Accum = 0, rs1 = 0x80000000 (-1.0), rs2 = 0x80000000 (-1.0)
  # -1.0 * -1.0 with rounding
  # 0x80000000 * 0x80000000 + 0x40000000 >> 31 = 0x80000001
  TEST_CASE( 8, x14, 0x80000001, \
    li x14, 0; \
    li x15, 0; \
    li a1, 0x80000000; \
    li a2, 0x80000000; \
    mqrwacc x14, a1, a2 );
  TEST_CASE( 9, x15, 0, nop );

  # Test 10: Small values with rounding effect
  # Accum = 1000, rs1 = 0x10000000 (0.125), rs2 = 0x10000000 (0.125)
  # 0.125 * 0.125 + rounding = 0.015625 rounded
  # 0x10000000 * 0x10000000 + 0x40000000 >> 31 = 0x02000000
  TEST_CASE( 10, x14, 0x020003E8, \
    li x14, 1000; \
    li x15, 0; \
    li a1, 0x10000000; \
    li a2, 0x10000000; \
    mqrwacc x14, a1, a2 );
  TEST_CASE( 11, x15, 0, nop );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END

